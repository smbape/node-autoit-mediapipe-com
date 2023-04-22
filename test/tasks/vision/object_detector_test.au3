#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Change2CUI=y
#AutoIt3Wrapper_Au3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#include "..\..\..\autoit-mediapipe-com\udf\mediapipe_udf_utils.au3"
#include "..\..\..\autoit-opencv-com\udf\opencv_udf_utils.au3"
#include "..\..\_assert.au3"
#include "..\..\_mat_utils.au3"
#include "..\..\_proto_utils.au3"
#include "..\..\_test_utils.au3"

;~ Sources:
;~     https://github.com/google/mediapipe/blob/v0.9.2.1/mediapipe/tasks/python/test/vision/object_detector_test.py
; EnvSet("MEDIAPIPE_BUILD_TYPE", "Debug")
; EnvSet("OPENCV_BUILD_TYPE", "Debug")
_Mediapipe_Open(_Mediapipe_FindDLL("opencv_world470*"), _Mediapipe_FindDLL("autoit_mediapipe_com-*-470*"))
_OpenCV_Open(_OpenCV_FindDLL("opencv_world470*"), _OpenCV_FindDLL("autoit_opencv_com470*"))
OnAutoItExitRegister("_OnAutoItExit")

_Mediapipe_SetResourceDir()

Global $cv = _OpenCV_get()

Global $download_utils = _Mediapipe_ObjCreate("mediapipe.autoit.solutions.download_utils")
_AssertIsObj($download_utils, "Failed to load mediapipe.autoit.solutions.download_utils")

Global $image_module = _Mediapipe_ObjCreate("mediapipe.autoit._framework_bindings.image")
_AssertIsObj($image_module, "Failed to load mediapipe.autoit._framework_bindings.image")

Global $bounding_box_module = _Mediapipe_ObjCreate("mediapipe.tasks.autoit.components.containers.bounding_box")
_AssertIsObj($bounding_box_module, "Failed to load mediapipe.tasks.autoit.components.containers.bounding_box")

Global $category_module = _Mediapipe_ObjCreate("mediapipe.tasks.autoit.components.containers.category")
_AssertIsObj($category_module, "Failed to load mediapipe.tasks.autoit.components.containers.category")

Global $detections_module = _Mediapipe_ObjCreate("mediapipe.tasks.autoit.components.containers.detections")
_AssertIsObj($detections_module, "Failed to load mediapipe.tasks.autoit.components.containers.detections")

Global $base_options_module = _Mediapipe_ObjCreate("mediapipe.tasks.autoit.core.base_options")
_AssertIsObj($base_options_module, "Failed to load mediapipe.tasks.autoit.core.base_options")

Global $object_detector = _Mediapipe_ObjCreate("mediapipe.tasks.autoit.vision.object_detector")
_AssertIsObj($object_detector, "Failed to load mediapipe.tasks.autoit.vision.object_detector")

Global $running_mode_module = _Mediapipe_ObjCreate("mediapipe.tasks.autoit.vision.core.vision_task_running_mode")
_AssertIsObj($running_mode_module, "Failed to load mediapipe.tasks.autoit.vision.core.vision_task_running_mode")


Global $_BaseOptions = $base_options_module.BaseOptions
Global $_Category = $category_module.Category
Global $_BoundingBox = $bounding_box_module.BoundingBox
Global $_Detection = $detections_module.Detection
Global $_DetectionResult = $detections_module.DetectionResult
Global $_Image = $image_module.Image
Global $_ObjectDetector = $object_detector.ObjectDetector
Global $_ObjectDetectorOptions = $object_detector.ObjectDetectorOptions
Global $_RUNNING_MODE = $running_mode_module.VisionTaskRunningMode

Global $_MODEL_FILE = 'coco_ssd_mobilenet_v1_1.0_quant_2018_06_29.tflite'
Global $_IMAGE_FILE = 'cats_and_dogs.jpg'
Global $_EXPECTED_DETECTION_RESULT = $_DetectionResult(_Mediapipe_Params("detections", _Mediapipe_Tuple( _
		$_Detection(_Mediapipe_Params( _
				"bounding_box", $_BoundingBox(_Mediapipe_Params( _
						"origin_x", 608, _
						"origin_y", 161, _
						"width", 381, _
						"height", 439)), _
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
								"score", 0.64453125, _
								"display_name", Default, _
								"category_name", 'cat')) _
				))), _
		$_Detection(_Mediapipe_Params( _
				"bounding_box", $_BoundingBox(_Mediapipe_Params( _
						"origin_x", 257, _
						"origin_y", 394, _
						"width", 173, _
						"height", 202)), _
				"categories", _Mediapipe_Tuple( _
						$_Category(_Mediapipe_Params( _
								"index", Default, _
								"score", 0.5234375, _
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
Global $_ALLOW_LIST[] = ['cat', 'dog']
Global $_DENY_LIST[] = ['cat']
Global $_SCORE_THRESHOLD = 0.3
Global $_MAX_RESULTS = 3

Global $FILE_CONTENT = 1
Global $FILE_NAME = 2

Global $test_image
Global $model_path

Test()

Func Test()
	Local Const $_TEST_DATA_DIR = _Mediapipe_FindResourceDir() & "\mediapipe\tasks\testdata\vision"
	Local $url, $file_path

	Local $test_files[] = [ _
			$_MODEL_FILE, _
			$_IMAGE_FILE _
			]
	For $name In $test_files
		$url = "https://storage.googleapis.com/mediapipe-assets/" & $name
		$file_path = $_TEST_DATA_DIR & "\" & $name
		If Not FileExists(get_test_data_path($name)) Then
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
	test_empty_detection_outputs()
	test_detect_for_video()
EndFunc   ;==>Test

Func test_create_from_file_succeeds_with_valid_model_path()
	; Creates with default option and valid model file successfully.
	Local $detector = $_ObjectDetector.create_from_model_path($model_path)
	_AssertIsObj($detector)
	$detector.close()
EndFunc   ;==>test_create_from_file_succeeds_with_valid_model_path

Func test_create_from_options_succeeds_with_valid_model_path()
	; Creates with options containing model file successfully.
	Local $base_options = $_BaseOptions(_Mediapipe_Params("model_asset_path", $model_path))
	Local $options = $_ObjectDetectorOptions(_Mediapipe_Params("base_options", $base_options))
	Local $detector = $_ObjectDetector.create_from_options($options)
	_AssertIsObj($detector)
	$detector.close()
EndFunc   ;==>test_create_from_options_succeeds_with_valid_model_path

Func test_create_from_options_succeeds_with_valid_model_content()
	; Creates with options containing model content successfully.
	Local $model_content = read_binary_to_mat($model_path)
	Local $base_options = $_BaseOptions(_Mediapipe_Params("model_asset_buffer", $model_content))
	Local $options = $_ObjectDetectorOptions(_Mediapipe_Params("base_options", $base_options))
	Local $detector = $_ObjectDetector.create_from_options($options)
	_AssertIsObj($detector)
	$detector.close()
EndFunc   ;==>test_create_from_options_succeeds_with_valid_model_content

Func test_detect($model_file_type, $max_results, $expected_detection_result)
	Local $base_options, $model_content

	; Creates detector.
	If $model_file_type == $FILE_NAME Then
		$base_options = $_BaseOptions(_Mediapipe_Params("model_asset_path", $model_path))
	ElseIf $model_file_type == $FILE_CONTENT Then
		$model_content = read_binary_to_mat($model_path)
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

Func test_empty_detection_outputs()
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
EndFunc   ;==>test_empty_detection_outputs

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
