#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Change2CUI=y
#AutoIt3Wrapper_Au3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

;~ Sources:
;~     https://github.com/google-ai-edge/mediapipe/blob/v0.10.14/mediapipe/tasks/python/test/vision/pose_landmarker_test.py

#include "..\..\..\autoit-mediapipe-com\udf\mediapipe_udf_utils.au3"
#include "..\..\..\autoit-opencv-com\udf\opencv_udf_utils.au3"
#include "..\..\_assert.au3"
#include "..\..\_mat_utils.au3"
#include "..\..\_proto_utils.au3"
#include "..\..\_test_utils.au3"

_Mediapipe_Open(_Mediapipe_FindDLL("opencv_world4110*"), _Mediapipe_FindDLL("autoit_mediapipe_com-*-4110*"))
_OpenCV_Open(_OpenCV_FindDLL("opencv_world4110*"), _OpenCV_FindDLL("autoit_opencv_com4110*"))
OnAutoItExitRegister("_OnAutoItExit")

; Tell mediapipe where to look its resource files
_Mediapipe_SetResourceDir()

Global Const $download_utils = _Mediapipe_ObjCreate("mediapipe.autoit.solutions.download_utils")
_AssertIsObj($download_utils, "Failed to load mediapipe.autoit.solutions.download_utils")

Global Const $text_format = _Mediapipe_ObjCreate("google.protobuf.text_format")
_AssertIsObj($text_format, "Failed to load google.protobuf.text_format")

Global Const $image_module = _Mediapipe_ObjCreate("mediapipe.autoit._framework_bindings.image")
_AssertIsObj($image_module, "Failed to load mediapipe.autoit._framework_bindings.image")

Global Const $landmarks_detection_result_pb2 = _Mediapipe_ObjCreate("mediapipe.tasks.cc.components.containers.proto.landmarks_detection_result_pb2")
_AssertIsObj($landmarks_detection_result_pb2, "Failed to load mediapipe.tasks.cc.components.containers.proto.landmarks_detection_result_pb2")

Global Const $landmark_module = _Mediapipe_ObjCreate("mediapipe.tasks.autoit.components.containers.landmark")
_AssertIsObj($landmark_module, "Failed to load mediapipe.tasks.autoit.components.containers.landmark")

Global Const $landmark_detection_result_module = _Mediapipe_ObjCreate("mediapipe.tasks.autoit.components.containers.landmark_detection_result")
_AssertIsObj($landmark_detection_result_module, "Failed to load mediapipe.tasks.autoit.components.containers.landmark_detection_result")

Global Const $rect_module = _Mediapipe_ObjCreate("mediapipe.tasks.autoit.components.containers.rect")
_AssertIsObj($rect_module, "Failed to load mediapipe.tasks.autoit.components.containers.rect")

Global Const $base_options_module = _Mediapipe_ObjCreate("mediapipe.tasks.autoit.core.base_options")
_AssertIsObj($base_options_module, "Failed to load mediapipe.tasks.autoit.core.base_options")

Global Const $pose_landmarker = _Mediapipe_ObjCreate("mediapipe.tasks.autoit.vision.pose_landmarker")
_AssertIsObj($pose_landmarker, "Failed to load mediapipe.tasks.autoit.vision.pose_landmarker")

Global Const $image_processing_options_module = _Mediapipe_ObjCreate("mediapipe.tasks.autoit.vision.core.image_processing_options")
_AssertIsObj($image_processing_options_module, "Failed to load mediapipe.tasks.autoit.vision.core.image_processing_options")

Global Const $running_mode_module = _Mediapipe_ObjCreate("mediapipe.tasks.autoit.vision.core.vision_task_running_mode")
_AssertIsObj($running_mode_module, "Failed to load mediapipe.tasks.autoit.vision.core.vision_task_running_mode")

Global Const $PoseLandmarkerResult = $pose_landmarker.PoseLandmarkerResult
Global Const $_LandmarksDetectionResultProto = $landmarks_detection_result_pb2.LandmarksDetectionResult
Global Const $_BaseOptions = $base_options_module.BaseOptions
Global Const $_Rect = $rect_module.Rect
Global Const $_LandmarksDetectionResult = $landmark_detection_result_module.LandmarksDetectionResult
Global Const $_Image = $image_module.Image
Global Const $_PoseLandmarker = $pose_landmarker.PoseLandmarker
Global Const $_PoseLandmarkerOptions = $pose_landmarker.PoseLandmarkerOptions
Global Const $_RUNNING_MODE = $running_mode_module.VisionTaskRunningMode
Global Const $_ImageProcessingOptions = $image_processing_options_module.ImageProcessingOptions

Global Const $_POSE_LANDMARKER_BUNDLE_ASSET_FILE = 'pose_landmarker.task'
Global Const $_BURGER_IMAGE = 'burger.jpg'
Global Const $_POSE_IMAGE = 'pose.jpg'
Global Const $_POSE_LANDMARKS = 'pose_landmarks.pbtxt'
Global Const $_LANDMARKS_MARGIN = 0.03

Global Const $FILE_CONTENT = 1
Global Const $FILE_NAME = 2

Global $test_image
Global $model_path

Test()

Func Test()
	Local Const $_TEST_DATA_DIR = _Mediapipe_FindResourceDir() & "\mediapipe\tasks\testdata\vision"
	Local $url, $file_path

	Local $test_files[] = [ _
			$_POSE_LANDMARKER_BUNDLE_ASSET_FILE, _
			$_BURGER_IMAGE, _
			$_POSE_IMAGE, _
			$_POSE_LANDMARKS _
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

	$test_image = $_Image.create_from_file(get_test_data_path($_POSE_IMAGE))
	$model_path = get_test_data_path($_POSE_LANDMARKER_BUNDLE_ASSET_FILE)

	test_create_from_file_succeeds_with_valid_model_path()
	test_create_from_options_succeeds_with_valid_model_path()
	test_create_from_options_succeeds_with_valid_model_content()

	test_detect( _
			$FILE_NAME, _
			False, _
			_get_expected_pose_landmarker_result($_POSE_LANDMARKS) _
			)
	test_detect( _
			$FILE_CONTENT, _
			False, _
			_get_expected_pose_landmarker_result($_POSE_LANDMARKS) _
			)
	test_detect( _
			$FILE_NAME, _
			True, _
			_get_expected_pose_landmarker_result($_POSE_LANDMARKS) _
			)
	test_detect( _
			$FILE_CONTENT, _
			True, _
			_get_expected_pose_landmarker_result($_POSE_LANDMARKS) _
			)

	test_detect_for_video( _
			$_POSE_IMAGE, _
			0, _
			False, _
			_get_expected_pose_landmarker_result($_POSE_LANDMARKS) _
			)
	test_detect_for_video( _
			$_POSE_IMAGE, _
			0, _
			True, _
			_get_expected_pose_landmarker_result($_POSE_LANDMARKS) _
			)
	test_detect_for_video($_BURGER_IMAGE, 0, False, $PoseLandmarkerResult.create())
EndFunc   ;==>Test

Func test_create_from_file_succeeds_with_valid_model_path()
	; Creates with default option and valid model file successfully.
	Local $landmarker = $_PoseLandmarker.create_from_model_path($model_path)
	_AssertIsInstance($landmarker, $_PoseLandmarker)
EndFunc   ;==>test_create_from_file_succeeds_with_valid_model_path

Func test_create_from_options_succeeds_with_valid_model_path()
	; Creates with options containing model file successfully.
	Local $base_options = $_BaseOptions(_Mediapipe_Params("model_asset_path", $model_path))
	Local $options = $_PoseLandmarkerOptions(_Mediapipe_Params("base_options", $base_options))
	Local $landmarker = $_PoseLandmarker.create_from_options($options)
	_AssertIsInstance($landmarker, $_PoseLandmarker)
EndFunc   ;==>test_create_from_options_succeeds_with_valid_model_path

Func test_create_from_options_succeeds_with_valid_model_content()
	; Creates with options containing model content successfully.
	Local $model_content = read_file_into_buffer($model_path)
	Local $base_options = $_BaseOptions(_Mediapipe_Params("model_asset_buffer", $model_content))
	Local $options = $_PoseLandmarkerOptions(_Mediapipe_Params("base_options", $base_options))
	Local $landmarker = $_PoseLandmarker.create_from_options($options)
	_AssertIsInstance($landmarker, $_PoseLandmarker)
EndFunc   ;==>test_create_from_options_succeeds_with_valid_model_content

Func test_detect( _
		$model_file_type, _
		$output_segmentation_masks, _
		$expected_detection_result _
		)
	Local $base_options, $model_content

	; Creates pose landmarker.
	If $model_file_type == $FILE_NAME Then
		$base_options = $_BaseOptions(_Mediapipe_Params("model_asset_path", $model_path))
	ElseIf $model_file_type == $FILE_CONTENT Then
		$model_content = read_file_into_buffer($model_path)
		$base_options = $_BaseOptions(_Mediapipe_Params("model_asset_buffer", $model_content))
	EndIf

	Local $options = $_PoseLandmarkerOptions(_Mediapipe_Params( _
			"base_options", $base_options, _
			"output_segmentation_masks", $output_segmentation_masks _
			))
	Local $landmarker = $_PoseLandmarker.create_from_options($options)

	; Performs pose landmarks detection on the input.
	Local $detection_result = $landmarker.detect($test_image)

	; Comparing results.
	_expect_pose_landmarker_results_correct( _
			$detection_result, _
			$expected_detection_result, _
			$output_segmentation_masks, _
			$_LANDMARKS_MARGIN _
			)
EndFunc   ;==>test_detect

Func test_detect_for_video($image_path, $rotation, $output_segmentation_masks, $expected_result)
	; Load the image.
	Local $test_image = $_Image.create_from_file(get_test_data_path($image_path))

	; Set rotation parameters using ImageProcessingOptions.
	Local $image_processing_options = $_ImageProcessingOptions(_Mediapipe_Params("rotation_degrees", $rotation))

	; Creates pose landmarker.
	Local $options = $_PoseLandmarkerOptions(_Mediapipe_Params( _
			"base_options", $_BaseOptions(_Mediapipe_Params("model_asset_path", $model_path)), _
			"output_segmentation_masks", $output_segmentation_masks, _
			"running_mode", $_RUNNING_MODE.VIDEO))
	Local $landmarker = $_PoseLandmarker.create_from_options($options)

	Local $result

	For $timestamp = 0 To (300 - 30) Step 30
		$result = $landmarker.detect_for_video($test_image, $timestamp, $image_processing_options)

		If $result.pose_landmarks.size() > 0 Then
			_expect_pose_landmarker_results_correct( _
					$result, _
					$expected_result, _
					$output_segmentation_masks, _
					$_LANDMARKS_MARGIN _
					)
		Else
			_AssertEqual($result, $expected_result)
		EndIf
	Next
EndFunc   ;==>test_detect_for_video

Func _get_expected_pose_landmarker_result($file_path)
	Local Const $landmarks_detection_result_file_path = get_test_data_path($file_path)

	Local $landmarks_detection_result_proto = $_LandmarksDetectionResultProto.create()
	$text_format.Parse(FileRead($landmarks_detection_result_file_path), $landmarks_detection_result_proto)
	; ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $landmarks_detection_result_proto = ' & $landmarks_detection_result_proto.__str__() & @CRLF) ;### Debug Console

	Local $landmarks_detection_result = $_LandmarksDetectionResult.create_from_pb2($landmarks_detection_result_proto)

	Return $PoseLandmarkerResult(_Mediapipe_Params( _
			"pose_landmarks", _Mediapipe_Tuple($landmarks_detection_result.landmarks), _
			"pose_world_landmarks", _Mediapipe_Tuple()))
EndFunc   ;==>_get_expected_pose_landmarker_result

Func _expect_pose_landmarks_correct($actual_landmarks, $expected_landmarks, $margin)
	; Expects to have the same number of poses detected.
	_AssertLen($actual_landmarks, $expected_landmarks.size())

	Local $i, $j

	$i = 0
	For $actual_landmark In $actual_landmarks
		$j = 0
		For $elem In $actual_landmark
			_AssertAlmostEqual($elem.x, $expected_landmarks($i) ($j).x, $margin)
			_AssertAlmostEqual($elem.y, $expected_landmarks($i) ($j).y, $margin)
			$j = $j + 1
		Next
		$i = $i + 1
	Next
EndFunc   ;==>_expect_pose_landmarks_correct

Func _expect_pose_landmarker_results_correct( _
		$actual_result, _
		$expected_result, _
		$output_segmentation_masks, _
		$margin _
		)
	_expect_pose_landmarks_correct($actual_result.pose_landmarks, $expected_result.pose_landmarks, $margin)

	If $output_segmentation_masks Then
		_AssertIsInstance($actual_result.segmentation_masks, "List")
		For $mask In $actual_result.segmentation_masks
			_AssertIsInstance($mask, $_Image)
		Next
	Else
		_AssertIsNone($actual_result.segmentation_masks)
	EndIf
EndFunc   ;==>_expect_pose_landmarker_results_correct

Func _OnAutoItExit()
	_OpenCV_Close()
	_Mediapipe_Close()
EndFunc   ;==>_OnAutoItExit
