#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Change2CUI=y
#AutoIt3Wrapper_Au3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

;~ Sources:
;~     https://github.com/google-ai-edge/mediapipe/blob/v0.10.14/mediapipe/tasks/python/test/vision/object_detector_test.py

#include "..\..\..\autoit-mediapipe-com\udf\mediapipe_udf_utils.au3"
#include "..\..\..\autoit-opencv-com\udf\opencv_udf_utils.au3"
#include "..\..\_assert.au3"
#include "..\..\_mat_utils.au3"
#include "..\..\_proto_utils.au3"
#include "..\..\_test_utils.au3"

_Mediapipe_Open(_Mediapipe_FindDLL("opencv_world4100*"), _Mediapipe_FindDLL("autoit_mediapipe_com-*-4100*"))
_OpenCV_Open(_OpenCV_FindDLL("opencv_world4100*"), _OpenCV_FindDLL("autoit_opencv_com4100*"))
OnAutoItExitRegister("_OnAutoItExit")

; Tell mediapipe where to look its resource files
_Mediapipe_SetResourceDir()

Global Const $download_utils = _Mediapipe_ObjCreate("mediapipe.autoit.solutions.download_utils")
_AssertIsObj($download_utils, "Failed to load mediapipe.autoit.solutions.download_utils")

Global Const $image_module = _Mediapipe_ObjCreate("mediapipe.autoit._framework_bindings.image")
_AssertIsObj($image_module, "Failed to load mediapipe.autoit._framework_bindings.image")

Global Const $bounding_box_module = _Mediapipe_ObjCreate("mediapipe.tasks.autoit.components.containers.bounding_box")
_AssertIsObj($bounding_box_module, "Failed to load mediapipe.tasks.autoit.components.containers.bounding_box")

Global Const $category_module = _Mediapipe_ObjCreate("mediapipe.tasks.autoit.components.containers.category")
_AssertIsObj($category_module, "Failed to load mediapipe.tasks.autoit.components.containers.category")

Global Const $detections_module = _Mediapipe_ObjCreate("mediapipe.tasks.autoit.components.containers.detections")
_AssertIsObj($detections_module, "Failed to load mediapipe.tasks.autoit.components.containers.detections")

Global Const $base_options_module = _Mediapipe_ObjCreate("mediapipe.tasks.autoit.core.base_options")
_AssertIsObj($base_options_module, "Failed to load mediapipe.tasks.autoit.core.base_options")

Global Const $object_detector = _Mediapipe_ObjCreate("mediapipe.tasks.autoit.vision.object_detector")
_AssertIsObj($object_detector, "Failed to load mediapipe.tasks.autoit.vision.object_detector")

Global Const $running_mode_module = _Mediapipe_ObjCreate("mediapipe.tasks.autoit.vision.core.vision_task_running_mode")
_AssertIsObj($running_mode_module, "Failed to load mediapipe.tasks.autoit.vision.core.vision_task_running_mode")

Global Const $_BaseOptions = $base_options_module.BaseOptions
Global Const $_Category = $category_module.Category
Global Const $_BoundingBox = $bounding_box_module.BoundingBox
Global Const $_Detection = $detections_module.Detection
Global Const $_DetectionResult = $detections_module.DetectionResult
Global Const $_Image = $image_module.Image
Global Const $_ObjectDetector = $object_detector.ObjectDetector
Global Const $_ObjectDetectorOptions = $object_detector.ObjectDetectorOptions
Global Const $_RUNNING_MODE = $running_mode_module.VisionTaskRunningMode

Global Const $_MODEL_FILE = 'coco_ssd_mobilenet_v1_1.0_quant_2018_06_29.tflite'
Global Const $_NO_NMS_MODEL_FILE = 'efficientdet_lite0_fp16_no_nms.tflite'
Global Const $_IMAGE_FILE = 'cats_and_dogs.jpg'
Global Const $_EXPECTED_DETECTION_RESULT = $_DetectionResult(_Mediapipe_Params("detections", _Mediapipe_Tuple( _
		$_Detection(_Mediapipe_Params( _
				"bounding_box", $_BoundingBox(_Mediapipe_Params( _
						"origin_x", 608, _
						"origin_y", 164, _
						"width", 381, _
						"height", 432)), _
				"categories", _Mediapipe_Tuple( _
						$_Category(_Mediapipe_Params( _
								"index", Default, _
								"score", 0.69921875, _
								"display_name", Default, _
								"category_name", 'cat')) _
				))), _
		$_Detection(_Mediapipe_Params( _
				"bounding_box", $_BoundingBox(_Mediapipe_Params( _
						"origin_x", 57, _
						"origin_y", 398, _
						"width", 386, _
						"height", 196)), _
				"categories", _Mediapipe_Tuple( _
						$_Category(_Mediapipe_Params( _
								"index", Default, _
								"score", 0.65625, _
								"display_name", Default, _
								"category_name", 'cat')) _
				))), _
		$_Detection(_Mediapipe_Params( _
				"bounding_box", $_BoundingBox(_Mediapipe_Params( _
						"origin_x", 256, _
						"origin_y", 394, _
						"width", 173, _
						"height", 202)), _
				"categories", _Mediapipe_Tuple( _
						$_Category(_Mediapipe_Params( _
								"index", Default, _
								"score", 0.51171875, _
								"display_name", Default, _
								"category_name", 'cat')) _
				))), _
		$_Detection(_Mediapipe_Params( _
				"bounding_box", $_BoundingBox(_Mediapipe_Params( _
						"origin_x", 360, _
						"origin_y", 195, _
						"width", 330, _
						"height", 412)), _
				"categories", _Mediapipe_Tuple( _
						$_Category(_Mediapipe_Params( _
								"index", Default, _
								"score", 0.48828125, _
								"display_name", Default, _
								"category_name", 'cat')) _
				))) _
)))
Global Const $_ALLOW_LIST[] = ['cat', 'dog']
Global Const $_DENY_LIST[] = ['cat']
Global Const $_SCORE_THRESHOLD = 0.3
Global Const $_MAX_RESULTS = 3

Global Const $FILE_CONTENT = 1
Global Const $FILE_NAME = 2

Global $test_image
Global $model_path

Test()

Func Test()
	Local Const $_TEST_DATA_DIR = _Mediapipe_FindResourceDir() & "\mediapipe\tasks\testdata\vision"
	Local $url, $file_path

	Local $test_files[] = [ _
			$_MODEL_FILE, _
			$_NO_NMS_MODEL_FILE, _
			$_IMAGE_FILE _
			]
	For $name In $test_files
		If IsArray($name) Then
			$url = $name[1]
			$name = $name[0]
		Else
			$url = "https://storage.googleapis.com/mediapipe-assets/" & $name
		EndIf
		If Not FileExists(get_test_data_path($name)) Then
			$file_path = $_TEST_DATA_DIR & "\" & $name
			$download_utils.download($url, $file_path)
		EndIf
	Next

	$test_image = $_Image.create_from_file(get_test_data_path($_IMAGE_FILE))
	$model_path = get_test_data_path($_MODEL_FILE)

	test_create_from_file_succeeds_with_valid_model_path()
	test_create_from_options_succeeds_with_valid_model_path()
	test_create_from_options_succeeds_with_valid_model_content()

	test_detect($FILE_NAME, 4, $_EXPECTED_DETECTION_RESULT)
	test_detect($FILE_CONTENT, 4, $_EXPECTED_DETECTION_RESULT)
	test_score_threshold_option()
	test_max_results_option()
	test_allow_list_option()
	test_deny_list_option()
	test_empty_detection_outputs_with_in_model_nms()
	test_empty_detection_outputs_without_in_model_nms()
	test_detect_for_video()
EndFunc   ;==>Test

Func test_create_from_file_succeeds_with_valid_model_path()
	; Creates with default option and valid model file successfully.
	Local $detector = $_ObjectDetector.create_from_model_path($model_path)
	_AssertIsInstance($detector, $_ObjectDetector)
	$detector.close()
EndFunc   ;==>test_create_from_file_succeeds_with_valid_model_path

Func test_create_from_options_succeeds_with_valid_model_path()
	; Creates with options containing model file successfully.
	Local $base_options = $_BaseOptions(_Mediapipe_Params("model_asset_path", $model_path))
	Local $options = $_ObjectDetectorOptions(_Mediapipe_Params("base_options", $base_options))
	Local $detector = $_ObjectDetector.create_from_options($options)
	_AssertIsInstance($detector, $_ObjectDetector)
	$detector.close()
EndFunc   ;==>test_create_from_options_succeeds_with_valid_model_path

Func test_create_from_options_succeeds_with_valid_model_content()
	; Creates with options containing model content successfully.
	Local $model_content = read_file_into_buffer($model_path)
	Local $base_options = $_BaseOptions(_Mediapipe_Params("model_asset_buffer", $model_content))
	Local $options = $_ObjectDetectorOptions(_Mediapipe_Params("base_options", $base_options))
	Local $detector = $_ObjectDetector.create_from_options($options)
	_AssertIsInstance($detector, $_ObjectDetector)
	$detector.close()
EndFunc   ;==>test_create_from_options_succeeds_with_valid_model_content

Func test_detect($model_file_type, $max_results, $expected_detection_result)
	Local $base_options, $model_content

	; Creates detector.
	If $model_file_type == $FILE_NAME Then
		$base_options = $_BaseOptions(_Mediapipe_Params("model_asset_path", $model_path))
	ElseIf $model_file_type == $FILE_CONTENT Then
		$model_content = read_file_into_buffer($model_path)
		$base_options = $_BaseOptions(_Mediapipe_Params("model_asset_buffer", $model_content))
	EndIf

	Local $options = $_ObjectDetectorOptions(_Mediapipe_Params( _
				"base_options", $base_options, "max_results", $max_results))
	Local $detector = $_ObjectDetector.create_from_options($options)

	; Performs object detection on the input.
	Local $detection_result = $detector.detect($test_image)

	; Comparing results.
	_AssertProtoEquals($detection_result.to_pb2(), $expected_detection_result.to_pb2())

	; Closes the detector explicitly when the detector is not used in a context.
	$detector.close()
EndFunc   ;==>test_detect

Func test_score_threshold_option()
	Local $options = $_ObjectDetectorOptions(_Mediapipe_Params( _
			"base_options", $_BaseOptions(_Mediapipe_Params("model_asset_path", $model_path)), _
			"score_threshold", $_SCORE_THRESHOLD _
	))

	Local $detector = $_ObjectDetector.create_from_options($options)

	; Performs object detection on the input.
	Local $detection_result = $detector.detect($test_image)
	Local $detections = $detection_result.detections

	Local $score
	For $detection In $detections
		$score = $detection.categories(0).score
		_AssertGreaterEqual( _
				$score, _
				$_SCORE_THRESHOLD, _
				'Detection with score lower than threshold found. ' & $detection.to_pb2().__str__() _
		)
	Next

	; Closes the detector explicitly when the detector is not used in a context.
	$detector.close()
EndFunc   ;==>test_score_threshold_option

Func test_max_results_option()
	Local $options = $_ObjectDetectorOptions(_Mediapipe_Params( _
			"base_options", $_BaseOptions(_Mediapipe_Params("model_asset_path", $model_path)), _
			"max_results", $_MAX_RESULTS _
	))

	Local $detector = $_ObjectDetector.create_from_options($options)

	; Performs object detection on the input.
	Local $detection_result = $detector.detect($test_image)
	Local $detections = $detection_result.detections

	_AssertLessEqual( _
			$detections.size(), $_MAX_RESULTS, 'Too many results returned.' _
	)

	; Closes the detector explicitly when the detector is not used in a context.
	$detector.close()
EndFunc   ;==>test_max_results_option

Func test_allow_list_option()
	Local $options = $_ObjectDetectorOptions(_Mediapipe_Params( _
			"base_options", $_BaseOptions(_Mediapipe_Params("model_asset_path", $model_path)), _
			"category_allowlist", $_ALLOW_LIST _
	))

	Local $detector = $_ObjectDetector.create_from_options($options)

	; Performs object detection on the input.
	Local $detection_result = $detector.detect($test_image)
	Local $detections = $detection_result.detections

	Local $label
	For $detection In $detections
		$label = $detection.categories(0).category_name
		_AssertIn( _
				$label, _
				$_ALLOW_LIST, _
				'Label ' & $label & ' found but not in label allow list' _
		)
	Next

	; Closes the detector explicitly when the detector is not used in a context.
	$detector.close()
EndFunc   ;==>test_allow_list_option

Func test_deny_list_option()
	Local $options = $_ObjectDetectorOptions(_Mediapipe_Params( _
			"base_options", $_BaseOptions(_Mediapipe_Params("model_asset_path", $model_path)), _
			"category_denylist", $_DENY_LIST _
	))

	Local $detector = $_ObjectDetector.create_from_options($options)

	; Performs object detection on the input.
	Local $detection_result = $detector.detect($test_image)
	Local $detections = $detection_result.detections

	Local $label
	For $detection In $detections
		$label = $detection.categories(0).category_name
		_AssertNotIn( _
				$label, $_DENY_LIST, 'Label ' & $label & ' found but in deny list.' _
		)
	Next

	; Closes the detector explicitly when the detector is not used in a context.
	$detector.close()
EndFunc   ;==>test_deny_list_option

Func test_empty_detection_outputs_with_in_model_nms()
	Local $options = $_ObjectDetectorOptions(_Mediapipe_Params( _
			"base_options", $_BaseOptions(_Mediapipe_Params("model_asset_path", $model_path)), _
			"score_threshold", 1 _
	))

	Local $detector = $_ObjectDetector.create_from_options($options)

	; Performs object detection on the input.
	Local $detection_result = $detector.detect($test_image)
	_AssertEmpty($detection_result.detections)

	; Closes the detector explicitly when the detector is not used in a context.
	$detector.close()
EndFunc   ;==>test_empty_detection_outputs_with_in_model_nms

Func test_empty_detection_outputs_without_in_model_nms()
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : get_test_data_path($_NO_NMS_MODEL_FILE) = ' & get_test_data_path($_NO_NMS_MODEL_FILE) & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
	Local $options = $_ObjectDetectorOptions(_Mediapipe_Params( _
			"base_options", $_BaseOptions(_Mediapipe_Params("model_asset_path", get_test_data_path($_NO_NMS_MODEL_FILE))), _
			"score_threshold", 1 _
	))

	Local $detector = $_ObjectDetector.create_from_options($options)

	; Performs object detection on the input.
	Local $detection_result = $detector.detect($test_image)
	_AssertEmpty($detection_result.detections)

	; Closes the detector explicitly when the detector is not used in a context.
	$detector.close()
EndFunc   ;==>test_empty_detection_outputs_without_in_model_nms

; TODO: Tests how `detect_for_video` handles the temporal data
; with a real video.
Func test_detect_for_video()
	Local $options = $_ObjectDetectorOptions(_Mediapipe_Params( _
			"base_options", $_BaseOptions(_Mediapipe_Params("model_asset_path", $model_path)), _
			"running_mode", $_RUNNING_MODE.VIDEO, _
			"max_results", 4 _
	))

	Local $detector = $_ObjectDetector.create_from_options($options)

	Local $detection_result
	For $timestamp = 0 To (300 - 30) Step 30
		$detection_result = $detector.detect_for_video($test_image, $timestamp)
		_AssertProtoEquals($detection_result.to_pb2(), $_EXPECTED_DETECTION_RESULT.to_pb2())
	Next

	; Closes the detector explicitly when the detector is not used in a context.
	$detector.close()
EndFunc   ;==>test_detect_for_video

Func _OnAutoItExit()
	_OpenCV_Close()
	_Mediapipe_Close()
EndFunc   ;==>_OnAutoItExit
