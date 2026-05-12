#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Change2CUI=y
#AutoIt3Wrapper_Au3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

;~ Sources:
;~     https://github.com/google-ai-edge/mediapipe/blob/v0.10.35/mediapipe/tasks/python/test/vision/face_detector_test.py

#include "..\..\..\autoit-mediapipe-com\udf\mediapipe_udf_utils.au3"
#include "..\..\_assert.au3"
#include "..\..\_test_utils.au3"

_Mediapipe_Open(_Mediapipe_FindDLL("opencv_world4130*"), _Mediapipe_FindDLL("autoit_mediapipe_com-*-4130*"))
OnAutoItExitRegister("_OnAutoItExit")

Global Const $download_utils = _Mediapipe_ObjCreate("mediapipe.tasks.autoit.core.download_utils")
_AssertIsObj($download_utils, "Failed to load mediapipe.tasks.autoit.core.download_utils")

Global Const $text_format = _Mediapipe_ObjCreate("google.protobuf.text_format")
_AssertIsObj($text_format, "Failed to load google.protobuf.text_format")

Global Const $detection_pb2 = _Mediapipe_ObjCreate("mediapipe.framework.formats.detection_pb2")
_AssertIsObj($detection_pb2, "Failed to load mediapipe.framework.formats.detection_pb2")

Global Const $detections_module = _Mediapipe_ObjCreate("mediapipe.tasks.autoit.components.containers.detections")
_AssertIsObj($detections_module, "Failed to load mediapipe.tasks.autoit.components.containers.detections")

Global Const $base_options_module = _Mediapipe_ObjCreate("mediapipe.tasks.autoit.core.base_options")
_AssertIsObj($base_options_module, "Failed to load mediapipe.tasks.autoit.core.base_options")

Global Const $proto_utils = _Mediapipe_ObjCreate("mediapipe.tasks.autoit.test.vision.proto_utils")
_AssertIsObj($proto_utils, "Failed to load mediapipe.tasks.autoit.test.vision.proto_utils")

Global Const $face_detector = _Mediapipe_ObjCreate("mediapipe.tasks.autoit.vision.face_detector")
_AssertIsObj($face_detector, "Failed to load mediapipe.tasks.autoit.vision.face_detector")

Global Const $image_module = _Mediapipe_ObjCreate("mediapipe.tasks.autoit.vision.core.image")
_AssertIsObj($image_module, "Failed to load mediapipe.tasks.autoit.vision.core.image")

Global Const $image_processing_options_module = _Mediapipe_ObjCreate("mediapipe.tasks.autoit.vision.core.image_processing_options")
_AssertIsObj($image_processing_options_module, "Failed to load mediapipe.tasks.autoit.vision.core.image_processing_options")

Global Const $running_mode_module = _Mediapipe_ObjCreate("mediapipe.tasks.autoit.vision.core.vision_task_running_mode")
_AssertIsObj($running_mode_module, "Failed to load mediapipe.tasks.autoit.vision.core.vision_task_running_mode")

Global Const $FaceDetectorResult = $detections_module.DetectionResult
Global Const $_BaseOptions = $base_options_module.BaseOptions
Global Const $_Image = $image_module.Image
Global Const $_FaceDetector = $face_detector.FaceDetector
Global Const $_FaceDetectorOptions = $face_detector.FaceDetectorOptions
Global Const $_RUNNING_MODE = $running_mode_module.VisionTaskRunningMode
Global Const $_ImageProcessingOptions = $image_processing_options_module.ImageProcessingOptions

Global Const $_SHORT_RANGE_BLAZE_FACE_MODEL = 'face_detection_short_range.tflite'
Global Const $_FULL_RANGE_BLAZE_FACE_MODEL = 'face_detection_full_range.tflite'
Global Const $_PORTRAIT_IMAGE = 'portrait.jpg'
Global Const $_PORTRAIT_EXPECTED_DETECTION = 'portrait_expected_detection.pbtxt'
Global Const $_PORTRAIT_EXPECTED_FULL_RANGE_DETECTION = 'portrait_expected_full_range_detection.pbtxt'
Global Const $_PORTRAIT_ROTATED_IMAGE = 'portrait_rotated.jpg'
Global Const $_PORTRAIT_ROTATED_EXPECTED_DETECTION = 'portrait_rotated_expected_detection.pbtxt'
Global Const $_CAT_IMAGE = 'cat.jpg'
Global Const $_KEYPOINT_ERROR_THRESHOLD = 1E-2
Global Const $_BOUNDING_BOX_ERROR_THRESHOLD = 5

Global Const $FILE_CONTENT = 1
Global Const $FILE_NAME = 2

Global $test_image
Global $model_path
Global $full_range_model_path


Func _get_expected_face_detector_result($file_path)
	Local $face_detection_result_file_path = get_test_data_path($file_path)
	Local $face_detection_proto = $detection_pb2.Detection.create()
	$text_format.Parse(FileRead($face_detection_result_file_path), $face_detection_proto)
	Local $face_detection = $proto_utils.create_detection_from_proto($face_detection_proto)
	Return $FaceDetectorResult(_Mediapipe_Params("detections", _Mediapipe_Tuple($face_detection)))
EndFunc   ;==>_get_expected_face_detector_result


FaceDetectorTest()


Func FaceDetectorTest()
	FaceDetectorTest_setUp()

	test_create_from_file_succeeds_with_valid_model_path()
	test_create_from_options_succeeds_with_valid_model_path()
	test_create_from_options_succeeds_with_valid_model_content()

	test_detect($FILE_NAME, $_PORTRAIT_EXPECTED_DETECTION)
	test_detect($FILE_CONTENT, $_PORTRAIT_EXPECTED_DETECTION)

	test_detect_succeeds_with_full_range_model()
	test_detect_succeeds_with_rotated_image()
	test_empty_detection_outputs()
	test_detect_for_video_succeeds_with_full_range_model()

	test_detect_for_video($FILE_NAME, $_PORTRAIT_IMAGE, 0, _get_expected_face_detector_result($_PORTRAIT_EXPECTED_DETECTION))
	test_detect_for_video($FILE_CONTENT, $_PORTRAIT_IMAGE, 0, _get_expected_face_detector_result($_PORTRAIT_EXPECTED_DETECTION))
	test_detect_for_video($FILE_NAME, $_PORTRAIT_ROTATED_IMAGE, -90, _get_expected_face_detector_result($_PORTRAIT_ROTATED_EXPECTED_DETECTION))
	test_detect_for_video($FILE_CONTENT, $_PORTRAIT_ROTATED_IMAGE, -90, _get_expected_face_detector_result($_PORTRAIT_ROTATED_EXPECTED_DETECTION))
	test_detect_for_video($FILE_NAME, $_CAT_IMAGE, 0, $FaceDetectorResult.create())
	test_detect_for_video($FILE_CONTENT, $_CAT_IMAGE, 0, $FaceDetectorResult.create())
EndFunc   ;==>FaceDetectorTest


Func FaceDetectorTest_setUp()
	Local Const $_TEST_DATA_DIR = _Mediapipe_FindResourceDir() & "\mediapipe\tasks\testdata\vision"
	Local $url, $file_path

	Local $test_files[] = [ _
			_Mediapipe_Tuple($_SHORT_RANGE_BLAZE_FACE_MODEL, "https://storage.googleapis.com/mediapipe-models/face_detector/blaze_face_short_range/float16/1/blaze_face_short_range.tflite"), _
			_Mediapipe_Tuple($_FULL_RANGE_BLAZE_FACE_MODEL, "https://storage.googleapis.com/mediapipe-models/face_detector/blaze_face_full_range/float16/1/blaze_face_full_range.tflite"), _
			$_PORTRAIT_IMAGE, _
			$_PORTRAIT_EXPECTED_DETECTION, _
			$_PORTRAIT_ROTATED_IMAGE, _
			$_PORTRAIT_ROTATED_EXPECTED_DETECTION, _
			$_PORTRAIT_EXPECTED_FULL_RANGE_DETECTION, _
			$_CAT_IMAGE _
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

	$test_image = $_Image.create_from_file(get_test_data_path($_PORTRAIT_IMAGE))
	$model_path = get_test_data_path($_SHORT_RANGE_BLAZE_FACE_MODEL)
	$full_range_model_path = get_test_data_path($_FULL_RANGE_BLAZE_FACE_MODEL)
EndFunc   ;==>FaceDetectorTest_setUp


Func test_create_from_file_succeeds_with_valid_model_path()
	ConsoleWrite('"' & @ScriptFullPath & '" @@ Debug(' & @ScriptLineNumber & ') : test_create_from_file_succeeds_with_valid_model_path' & @CRLF) ;### Debug Console

	; Creates with default option and valid model file successfully.
	Local $detector = $_FaceDetector.create_from_model_path($model_path)
	_AssertIsInstance($detector, $_FaceDetector)
	$detector.close()
EndFunc   ;==>test_create_from_file_succeeds_with_valid_model_path

Func test_create_from_options_succeeds_with_valid_model_path()
	ConsoleWrite('"' & @ScriptFullPath & '" @@ Debug(' & @ScriptLineNumber & ') : test_create_from_options_succeeds_with_valid_model_path' & @CRLF) ;### Debug Console

	; Creates with options containing model file successfully.
	Local $base_options = $_BaseOptions(_Mediapipe_Params("model_asset_path", $model_path))
	Local $options = $_FaceDetectorOptions(_Mediapipe_Params("base_options", $base_options))
	Local $detector = $_FaceDetector.create_from_options($options)
	_AssertIsInstance($detector, $_FaceDetector)
	$detector.close()
EndFunc   ;==>test_create_from_options_succeeds_with_valid_model_path

Func test_create_from_options_succeeds_with_valid_model_content()
	ConsoleWrite('"' & @ScriptFullPath & '" @@ Debug(' & @ScriptLineNumber & ') : test_create_from_options_succeeds_with_valid_model_content' & @CRLF) ;### Debug Console

	; Creates with options containing model content successfully.
	Local $model_content = read_file_into_buffer($model_path)
	Local $base_options = $_BaseOptions(_Mediapipe_Params("model_asset_buffer", $model_content))
	Local $options = $_FaceDetectorOptions(_Mediapipe_Params("base_options", $base_options))
	Local $detector = $_FaceDetector.create_from_options($options)
	_AssertIsInstance($detector, $_FaceDetector)
	$detector.close()
EndFunc   ;==>test_create_from_options_succeeds_with_valid_model_content

Func _expect_keypoints_correct($actual_keypoints, $expected_keypoints)
	_AssertLen($actual_keypoints, $expected_keypoints.size())
	For $i = 0 To $actual_keypoints.size() - 1
		_AssertAlmostEqual( _
				$actual_keypoints($i).x, _
				$expected_keypoints($i).x, _
				$_KEYPOINT_ERROR_THRESHOLD _
				)
		_AssertAlmostEqual( _
				$actual_keypoints($i).y, _
				$expected_keypoints($i).y, _
				$_KEYPOINT_ERROR_THRESHOLD _
				)
	Next
EndFunc   ;==>_expect_keypoints_correct

Func _expect_bounding_box_correct($actual_bbox, $expected_bbox, $sMessage = Default, $bExit = Default, $iCode = Default, $sFile = @ScriptFullPath, $iLine = @ScriptLineNumber, Const $_iCallerError = @error, Const $_vCallerExtended = @extended)
	_AssertAlmostEqual( _
			$actual_bbox.origin_x, _
			$expected_bbox.origin_x, _
			$_BOUNDING_BOX_ERROR_THRESHOLD, _
			Default, _
			$sMessage, $bExit, $iCode, $sFile, $iLine, $_iCallerError, $_vCallerExtended _
			)
	_AssertAlmostEqual( _
			$actual_bbox.origin_y, _
			$expected_bbox.origin_y, _
			$_BOUNDING_BOX_ERROR_THRESHOLD, _
			Default, _
			$sMessage, $bExit, $iCode, $sFile, $iLine, $_iCallerError, $_vCallerExtended _
			)
	_AssertAlmostEqual( _
			$actual_bbox.width, _
			$expected_bbox.width, _
			$_BOUNDING_BOX_ERROR_THRESHOLD, _
			Default, _
			$sMessage, $bExit, $iCode, $sFile, $iLine, $_iCallerError, $_vCallerExtended _
			)
	_AssertAlmostEqual( _
			$actual_bbox.height, _
			$expected_bbox.height, _
			$_BOUNDING_BOX_ERROR_THRESHOLD, _
			Default, _
			$sMessage, $bExit, $iCode, $sFile, $iLine, $_iCallerError, $_vCallerExtended _
			)
EndFunc   ;==>_expect_bounding_box_correct

Func _expect_face_detector_results_correct($actual_results, $expected_results, $sMessage = Default, $bExit = Default, $iCode = Default, $sFile = @ScriptFullPath, $iLine = @ScriptLineNumber, Const $_iCallerError = @error, Const $_vCallerExtended = @extended)
	_AssertLen($actual_results.detections, $expected_results.detections.size())
	Local $actual_bbox, $expected_bbox
	For $i = 0 To $actual_results.detections.size() - 1
		$actual_bbox = $actual_results.detections($i).bounding_box
		$expected_bbox = $expected_results.detections($i).bounding_box
		_expect_bounding_box_correct($actual_bbox, $expected_bbox, $sMessage, $bExit, $iCode, $sFile, $iLine, $_iCallerError, $_vCallerExtended)
		_AssertNotEmpty($actual_results.detections($i).keypoints)
		_expect_keypoints_correct( _
				$actual_results.detections($i).keypoints, _
				$expected_results.detections($i).keypoints _
				)
	Next
EndFunc   ;==>_expect_face_detector_results_correct

Func test_detect($model_file_type, $expected_detection_result_file)
	ConsoleWrite('"' & @ScriptFullPath & '" @@ Debug(' & @ScriptLineNumber & ') : test_detect' & @CRLF) ;### Debug Console

	Local $base_options, $model_content

	; Creates classifier.
	If $model_file_type == $FILE_NAME Then
		$base_options = $_BaseOptions(_Mediapipe_Params("model_asset_path", $model_path))
	ElseIf $model_file_type == $FILE_CONTENT Then
		$model_content = read_file_into_buffer($model_path)
		$base_options = $_BaseOptions(_Mediapipe_Params("model_asset_buffer", $model_content))
	EndIf

	Local $options = $_FaceDetectorOptions(_Mediapipe_Params("base_options", $base_options))
	Local $detector = $_FaceDetector.create_from_options($options)

	; Performs face detection on the input.
	Local $detection_result = $detector.detect($test_image)

	; Comparing results.
	Local $expected_detection_result = _get_expected_face_detector_result($expected_detection_result_file)
	_expect_face_detector_results_correct($detection_result, $expected_detection_result)
EndFunc   ;==>test_detect


Func test_detect_succeeds_with_full_range_model()
	ConsoleWrite('"' & @ScriptFullPath & '" @@ Debug(' & @ScriptLineNumber & ') : test_detect_succeeds_with_full_range_model' & @CRLF) ;### Debug Console

	Local $base_options = $_BaseOptions(_Mediapipe_Params("model_asset_path", $full_range_model_path))
	Local $options = $_FaceDetectorOptions(_Mediapipe_Params("base_options", $base_options))
	Local $detector = $_FaceDetector.create_from_options($options)
	; Performs face detection on the input.
	Local $detection_result = $detector.detect($test_image)

	; Comparing results.
	Local $expected_detection_result = _get_expected_face_detector_result($_PORTRAIT_EXPECTED_FULL_RANGE_DETECTION)
	_expect_face_detector_results_correct($detection_result, $expected_detection_result)
	$detector.close()
EndFunc   ;==>test_detect_succeeds_with_full_range_model

Func test_detect_succeeds_with_rotated_image()
	ConsoleWrite('"' & @ScriptFullPath & '" @@ Debug(' & @ScriptLineNumber & ') : test_detect_succeeds_with_rotated_image' & @CRLF) ;### Debug Console

	Local $base_options = $_BaseOptions(_Mediapipe_Params("model_asset_path", $model_path))
	Local $options = $_FaceDetectorOptions(_Mediapipe_Params("base_options", $base_options))
	Local $detector = $_FaceDetector.create_from_options($options)

	; Load the test image.
	Local $test_image = $_Image.create_from_file(get_test_data_path($_PORTRAIT_ROTATED_IMAGE))

	; Rotated input image.
	Local $image_processing_options = $_ImageProcessingOptions(_Mediapipe_Params("rotation_degrees", -90))

	; Performs face detection on the input.
	Local $detection_result = $detector.detect($test_image, $image_processing_options)

	; Comparing results.
	Local $expected_detection_result = _get_expected_face_detector_result($_PORTRAIT_ROTATED_EXPECTED_DETECTION)
	_expect_face_detector_results_correct($detection_result, $expected_detection_result)
EndFunc   ;==>test_detect_succeeds_with_rotated_image

Func test_empty_detection_outputs()
	ConsoleWrite('"' & @ScriptFullPath & '" @@ Debug(' & @ScriptLineNumber & ') : test_empty_detection_outputs' & @CRLF) ;### Debug Console

	; Load a test image with no faces.
	Local $test_image = $_Image.create_from_file(get_test_data_path($_CAT_IMAGE))
	Local $options = $_FaceDetectorOptions(_Mediapipe_Params( _
			"base_options", $_BaseOptions(_Mediapipe_Params("model_asset_path", $model_path)) _
			))

	Local $detector = $_FaceDetector.create_from_options($options)

	; Performs face detection on the input.
	Local $detection_result = $detector.detect($test_image)
	_AssertEmpty($detection_result.detections)
EndFunc   ;==>test_empty_detection_outputs

Func test_detect_for_video_succeeds_with_full_range_model()
	ConsoleWrite('"' & @ScriptFullPath & '" @@ Debug(' & @ScriptLineNumber & ') : test_detect_for_video_succeeds_with_full_range_model' & @CRLF) ;### Debug Console

	Local $base_options = $_BaseOptions(_Mediapipe_Params("model_asset_path", $full_range_model_path))
	Local $options = $_FaceDetectorOptions(_Mediapipe_Params( _
			"base_options", $base_options, _
			"running_mode", $_RUNNING_MODE.VIDEO _
			))

	Local $detection_result, $expected_detection_result
	Local $detector = $_FaceDetector.create_from_options($options)
	For $timestamp = 0 To (300 - 30) Step 30
		; Performs face detection on the input.
		$detection_result = $detector.detect_for_video($test_image, $timestamp)
		; Comparing results.
		$expected_detection_result = _get_expected_face_detector_result($_PORTRAIT_EXPECTED_FULL_RANGE_DETECTION)
		_expect_face_detector_results_correct($detection_result, $expected_detection_result)
	Next
	$detector.close()
EndFunc   ;==>test_detect_for_video_succeeds_with_full_range_model

Func test_detect_for_video( _
		$model_file_type, _
		$test_image_file_name, _
		$rotation_degrees, _
		$expected_detection_result _
		)
	ConsoleWrite('"' & @ScriptFullPath & '" @@ Debug(' & @ScriptLineNumber & ') : test_detect_for_video' & @CRLF) ;### Debug Console

	Local $base_options, $model_content

	; Creates classifier.
	If $model_file_type == $FILE_NAME Then
		$base_options = $_BaseOptions(_Mediapipe_Params("model_asset_path", $model_path))
	ElseIf $model_file_type == $FILE_CONTENT Then
		$model_content = read_file_into_buffer($model_path)
		$base_options = $_BaseOptions(_Mediapipe_Params("model_asset_buffer", $model_content))
	EndIf

	Local $options = $_FaceDetectorOptions(_Mediapipe_Params("base_options", $base_options, "running_mode", $_RUNNING_MODE.VIDEO))

	Local $detector = $_FaceDetector.create_from_options($options)

	; Load the test image.
	Local $test_image = $_Image.create_from_file(get_test_data_path($test_image_file_name))

	; Set the image processing options.
	Local $image_processing_options = $_ImageProcessingOptions(_Mediapipe_Params("rotation_degrees", $rotation_degrees))

	Local $detection_result
	For $timestamp = 0 To (300 - 30) Step 30
		; Performs face detection on the input.
		$detection_result = $detector.detect_for_video($test_image, $timestamp, $image_processing_options)

		; Comparing results.
		_expect_face_detector_results_correct($detection_result, $expected_detection_result)
	Next
EndFunc   ;==>test_detect_for_video

Func _OnAutoItExit()
	_Mediapipe_Close()
EndFunc   ;==>_OnAutoItExit
