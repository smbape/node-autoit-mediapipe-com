#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Change2CUI=y
#AutoIt3Wrapper_Au3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

;~ Sources:
;~     https://github.com/google-ai-edge/mediapipe/blob/v0.10.22/mediapipe/tasks/python/test/vision/holistic_landmarker_test.py

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

Global Const $holistic_result_pb2 = _Mediapipe_ObjCreate("mediapipe.tasks.cc.vision.holistic_landmarker.proto.holistic_result_pb2")
_AssertIsObj($holistic_result_pb2, "Failed to load mediapipe.tasks.cc.vision.holistic_landmarker.proto.holistic_result_pb2")

Global Const $base_options_module = _Mediapipe_ObjCreate("mediapipe.tasks.autoit.core.base_options")
_AssertIsObj($base_options_module, "Failed to load mediapipe.tasks.autoit.core.base_options")

Global Const $holistic_landmarker = _Mediapipe_ObjCreate("mediapipe.tasks.autoit.vision.holistic_landmarker")
_AssertIsObj($holistic_landmarker, "Failed to load mediapipe.tasks.autoit.vision.holistic_landmarker")

Global Const $image_processing_options_module = _Mediapipe_ObjCreate("mediapipe.tasks.autoit.vision.core.image_processing_options")
_AssertIsObj($image_processing_options_module, "Failed to load mediapipe.tasks.autoit.vision.core.image_processing_options")

Global Const $running_mode_module = _Mediapipe_ObjCreate("mediapipe.tasks.autoit.vision.core.vision_task_running_mode")
_AssertIsObj($running_mode_module, "Failed to load mediapipe.tasks.autoit.vision.core.vision_task_running_mode")

Global Const $HolisticLandmarkerResult = $holistic_landmarker.HolisticLandmarkerResult
Global Const $_HolisticResultProto = $holistic_result_pb2.HolisticResult
Global Const $_BaseOptions = $base_options_module.BaseOptions
Global Const $_Image = $image_module.Image
Global Const $_HolisticLandmarker = $holistic_landmarker.HolisticLandmarker
Global Const $_HolisticLandmarkerOptions = $holistic_landmarker.HolisticLandmarkerOptions
Global Const $_RUNNING_MODE = $running_mode_module.VisionTaskRunningMode

Global Const $_HOLISTIC_LANDMARKER_BUNDLE_ASSET_FILE = "holistic_landmarker.task"
Global Const $_POSE_IMAGE = "male_full_height_hands.jpg"
Global Const $_CAT_IMAGE = "cat.jpg"
Global Const $_EXPECTED_HOLISTIC_RESULT = "male_full_height_hands_result_cpu.pbtxt"
Global Const $_IMAGE_WIDTH = 638
Global Const $_IMAGE_HEIGHT = 1000
Global Const $_LANDMARKS_MARGIN = 0.03
Global Const $_BLENDSHAPES_MARGIN = 0.13
Global Const $_VIDEO_LANDMARKS_MARGIN = 0.03
Global Const $_VIDEO_BLENDSHAPES_MARGIN = 0.31
Global Const $_LIVE_STREAM_LANDMARKS_MARGIN = 0.03
Global Const $_LIVE_STREAM_BLENDSHAPES_MARGIN = 0.31

Global Const $FILE_CONTENT = 1
Global Const $FILE_NAME = 2

Global $test_image
Global $model_path

Test()

Func Test()
	Local Const $_TEST_DATA_DIR = _Mediapipe_FindResourceDir() & "\mediapipe\tasks\testdata\vision"
	Local $url, $file_path

	Local $test_files[] = [ _
			$_HOLISTIC_LANDMARKER_BUNDLE_ASSET_FILE, _
			$_POSE_IMAGE, _
			$_CAT_IMAGE, _
			$_EXPECTED_HOLISTIC_RESULT _
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
	$model_path = get_test_data_path($_HOLISTIC_LANDMARKER_BUNDLE_ASSET_FILE)

	test_create_from_file_succeeds_with_valid_model_path()
	test_create_from_options_succeeds_with_valid_model_path()
	test_create_from_options_succeeds_with_valid_model_content()

	test_detect( _
			$FILE_NAME, _
			$_HOLISTIC_LANDMARKER_BUNDLE_ASSET_FILE, _
			False, _
			_get_expected_holistic_landmarker_result($_EXPECTED_HOLISTIC_RESULT) _
			)
	test_detect( _
			$FILE_CONTENT, _
			$_HOLISTIC_LANDMARKER_BUNDLE_ASSET_FILE, _
			False, _
			_get_expected_holistic_landmarker_result($_EXPECTED_HOLISTIC_RESULT) _
			)
	test_detect( _
			$FILE_NAME, _
			$_HOLISTIC_LANDMARKER_BUNDLE_ASSET_FILE, _
			True, _
			_get_expected_holistic_landmarker_result($_EXPECTED_HOLISTIC_RESULT) _
			)
	test_detect( _
			$FILE_CONTENT, _
			$_HOLISTIC_LANDMARKER_BUNDLE_ASSET_FILE, _
			True, _
			_get_expected_holistic_landmarker_result($_EXPECTED_HOLISTIC_RESULT) _
			)

	test_empty_detection_outputs()
EndFunc   ;==>Test

Func test_create_from_file_succeeds_with_valid_model_path()
	; Creates with default option and valid model file successfully.
	Local $landmarker = $_HolisticLandmarker.create_from_model_path($model_path)
	_AssertIsInstance($landmarker, $_HolisticLandmarker)
EndFunc   ;==>test_create_from_file_succeeds_with_valid_model_path

Func test_create_from_options_succeeds_with_valid_model_path()
	; Creates with options containing model file successfully.
	Local $base_options = $_BaseOptions(_Mediapipe_Params("model_asset_path", $model_path))
	Local $options = $_HolisticLandmarkerOptions(_Mediapipe_Params("base_options", $base_options))
	Local $landmarker = $_HolisticLandmarker.create_from_options($options)
	_AssertIsInstance($landmarker, $_HolisticLandmarker)
EndFunc   ;==>test_create_from_options_succeeds_with_valid_model_path

Func test_create_from_options_succeeds_with_valid_model_content()
	; Creates with options containing model content successfully.
	Local $model_content = read_file_into_buffer($model_path)
	Local $base_options = $_BaseOptions(_Mediapipe_Params("model_asset_buffer", $model_content))
	Local $options = $_HolisticLandmarkerOptions(_Mediapipe_Params("base_options", $base_options))
	Local $landmarker = $_HolisticLandmarker.create_from_options($options)
	_AssertIsInstance($landmarker, $_HolisticLandmarker)
EndFunc   ;==>test_create_from_options_succeeds_with_valid_model_content

Func test_detect( _
		$model_file_type, _
		$model_name, _
		$output_segmentation_mask, _
		$expected_holistic_landmarker_result _
		)
	Local $model_path = get_test_data_path($model_name)
	Local $base_options, $model_content

	; Creates holistic landmarker.
	If $model_file_type == $FILE_NAME Then
		$base_options = $_BaseOptions(_Mediapipe_Params("model_asset_path", $model_path))
	ElseIf $model_file_type == $FILE_CONTENT Then
		$model_content = read_file_into_buffer($model_path)
		$base_options = $_BaseOptions(_Mediapipe_Params("model_asset_buffer", $model_content))
	EndIf

	Local $options = $_HolisticLandmarkerOptions(_Mediapipe_Params( _
			"base_options", $base_options, _
			"output_face_blendshapes", $expected_holistic_landmarker_result.face_blendshapes.size() <> 0, _
			"output_segmentation_mask", $output_segmentation_mask _
			))
	Local $landmarker = $_HolisticLandmarker.create_from_options($options)

	; Performs holistic landmarks detection on the input.
	Local $detection_result = $landmarker.detect($test_image)

	; Comparing results.
	_expect_holistic_landmarker_results_correct( _
			$detection_result, _
			$expected_holistic_landmarker_result, _
			$output_segmentation_mask, _
			$_LANDMARKS_MARGIN, _
			$_BLENDSHAPES_MARGIN _
			)
EndFunc   ;==>test_detect

Func test_empty_detection_outputs()
	Local $options = $_HolisticLandmarkerOptions(_Mediapipe_Params( _
			"base_options", $_BaseOptions(_Mediapipe_Params("model_asset_path", $model_path)) _
			))
	Local $landmarker = $_HolisticLandmarker.create_from_options($options)

	; Load the cat image.
	Local $cat_test_image = $_Image.create_from_file(get_test_data_path($_CAT_IMAGE))

	; Performs holistic landmarks detection on the input.
	Local $detection_result = $landmarker.detect($cat_test_image)

	; Comparing results.
	_AssertEmpty($detection_result.face_landmarks)
	_AssertEmpty($detection_result.pose_landmarks)
	_AssertEmpty($detection_result.pose_world_landmarks)
	_AssertEmpty($detection_result.left_hand_landmarks)
	_AssertEmpty($detection_result.left_hand_world_landmarks)
	_AssertEmpty($detection_result.right_hand_landmarks)
	_AssertEmpty($detection_result.right_hand_world_landmarks)
	_AssertEmpty($detection_result.face_blendshapes)
	_AssertIsNone($detection_result.segmentation_mask)
EndFunc   ;==>test_empty_detection_outputs

Func _get_expected_holistic_landmarker_result($file_path)
	Local $holistic_result_file_path = get_test_data_path($file_path)

	Local $holistic_result_proto = $_HolisticResultProto.create()
	$text_format.Parse(FileRead($holistic_result_file_path), $holistic_result_proto)
	; ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $holistic_result_proto = ' & $holistic_result_proto.__str__() & @CRLF) ;### Debug Console

	Return $HolisticLandmarkerResult.create_from_pb2($holistic_result_proto)
EndFunc   ;==>_get_expected_holistic_landmarker_result

Func _expect_landmarks_correct($actual_landmarks, $expected_landmarks, $margin)
	; Expects to have the same number of landmarks detected.
	_AssertLen($actual_landmarks, $expected_landmarks.size())

	Local $i = 0
	For $elem In $actual_landmarks
		_AssertAlmostEqual($elem.x, $expected_landmarks($i).x, $margin)
		_AssertAlmostEqual($elem.y, $expected_landmarks($i).y, $margin)
		$i += 1
	Next
EndFunc   ;==>_expect_landmarks_correct

Func _expect_blendshapes_correct($actual_blendshapes, $expected_blendshapes, $margin)
	; Expects to have the same number of blendshapes.
	_AssertLen($actual_blendshapes, $expected_blendshapes.size())

	Local $i = 0
	For $elem In $actual_blendshapes
		_AssertEqual($elem.index, $expected_blendshapes($i).index)
		_AssertEqual($elem.category_name, $expected_blendshapes($i).category_name)
		_AssertAlmostEqual( _
				$elem.score, _
				$expected_blendshapes($i).score, _
				$margin _
				)
		$i += 1
	Next
EndFunc   ;==>_expect_blendshapes_correct

Func _expect_holistic_landmarker_results_correct( _
		$actual_result, _
		$expected_result, _
		$output_segmentation_mask, _
		$landmarks_margin, _
		$blendshapes_margin _
		)
	_expect_landmarks_correct( _
			$actual_result.pose_landmarks, _
			$expected_result.pose_landmarks, _
			$landmarks_margin _
			)
	_expect_landmarks_correct( _
			$actual_result.face_landmarks, _
			$expected_result.face_landmarks, _
			$landmarks_margin _
			)
	_expect_blendshapes_correct( _
			$actual_result.face_blendshapes, _
			$expected_result.face_blendshapes, _
			$blendshapes_margin _
			)

	If $output_segmentation_mask Then
		_AssertIsInstance($actual_result.segmentation_mask, $_Image)
		_AssertEqual($actual_result.segmentation_mask.width, $_IMAGE_WIDTH)
		_AssertEqual($actual_result.segmentation_mask.height, $_IMAGE_HEIGHT)
	Else
		_AssertIsNone($actual_result.segmentation_mask)
	EndIf
EndFunc   ;==>_expect_holistic_landmarker_results_correct

Func _OnAutoItExit()
	_OpenCV_Close()
	_Mediapipe_Close()
EndFunc   ;==>_OnAutoItExit
