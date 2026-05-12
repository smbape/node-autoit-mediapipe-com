#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Change2CUI=y
#AutoIt3Wrapper_Au3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

;~ Sources:
;~     https://github.com/google-ai-edge/mediapipe/blob/v0.10.35/mediapipe/tasks/python/test/vision/hand_landmarker_test.py

#include "..\..\..\autoit-mediapipe-com\udf\mediapipe_udf_utils.au3"
#include "..\..\_assert.au3"
#include "..\..\_test_utils.au3"

_Mediapipe_Open(_Mediapipe_FindDLL("opencv_world4130*"), _Mediapipe_FindDLL("autoit_mediapipe_com-*-4130*"))
OnAutoItExitRegister("_OnAutoItExit")

Global Const $download_utils = _Mediapipe_ObjCreate("mediapipe.tasks.autoit.core.download_utils")
_AssertIsObj($download_utils, "Failed to load mediapipe.tasks.autoit.core.download_utils")

Global Const $text_format = _Mediapipe_ObjCreate("google.protobuf.text_format")
_AssertIsObj($text_format, "Failed to load google.protobuf.text_format")

Global Const $landmarks_detection_result_pb2 = _Mediapipe_ObjCreate("mediapipe.tasks.cc.components.containers.proto.landmarks_detection_result_pb2")
_AssertIsObj($landmarks_detection_result_pb2, "Failed to load mediapipe.tasks.cc.components.containers.proto.landmarks_detection_result_pb2")

Global Const $proto_utils = _Mediapipe_ObjCreate("mediapipe.tasks.autoit.test.vision.proto_utils")
_AssertIsObj($proto_utils, "Failed to load mediapipe.tasks.autoit.test.vision.proto_utils")

Global Const $landmark_module = _Mediapipe_ObjCreate("mediapipe.tasks.autoit.components.containers.landmark")
_AssertIsObj($landmark_module, "Failed to load mediapipe.tasks.autoit.components.containers.landmark")

Global Const $image_module = _Mediapipe_ObjCreate("mediapipe.tasks.autoit.vision.core.image")
_AssertIsObj($image_module, "Failed to load mediapipe.tasks.autoit.vision.core.image")

Global Const $landmark_detection_result_module = _Mediapipe_ObjCreate("mediapipe.tasks.autoit.components.containers.landmark_detection_result")
_AssertIsObj($landmark_detection_result_module, "Failed to load mediapipe.tasks.autoit.components.containers.landmark_detection_result")

Global Const $rect_module = _Mediapipe_ObjCreate("mediapipe.tasks.autoit.components.containers.rect")
_AssertIsObj($rect_module, "Failed to load mediapipe.tasks.autoit.components.containers.rect")

Global Const $base_options_module = _Mediapipe_ObjCreate("mediapipe.tasks.autoit.core.base_options")
_AssertIsObj($base_options_module, "Failed to load mediapipe.tasks.autoit.core.base_options")

Global Const $hand_landmarker = _Mediapipe_ObjCreate("mediapipe.tasks.autoit.vision.hand_landmarker")
_AssertIsObj($hand_landmarker, "Failed to load mediapipe.tasks.autoit.vision.hand_landmarker")

Global Const $image_processing_options_module = _Mediapipe_ObjCreate("mediapipe.tasks.autoit.vision.core.image_processing_options")
_AssertIsObj($image_processing_options_module, "Failed to load mediapipe.tasks.autoit.vision.core.image_processing_options")

Global Const $running_mode_module = _Mediapipe_ObjCreate("mediapipe.tasks.autoit.vision.core.vision_task_running_mode")
_AssertIsObj($running_mode_module, "Failed to load mediapipe.tasks.autoit.vision.core.vision_task_running_mode")

Global Const $landmark_pb2 = _Mediapipe_ObjCreate("mediapipe.framework.formats.landmark_pb2")
_AssertIsObj($landmark_pb2, "Failed to load mediapipe.framework.formats.landmark_pb2")

Global Const $_LandmarksDetectionResultProto = $landmarks_detection_result_pb2.LandmarksDetectionResult
Global Const $_BaseOptions = $base_options_module.BaseOptions
Global Const $_RectF = $rect_module.RectF
Global Const $_Landmark = $landmark_module.Landmark
Global Const $_NormalizedLandmark = $landmark_module.NormalizedLandmark
Global Const $_LandmarksDetectionResult = $landmark_detection_result_module.LandmarksDetectionResult
Global Const $_Image = $image_module.Image
Global Const $_HandLandmarker = $hand_landmarker.HandLandmarker
Global Const $_HandLandmarkerOptions = $hand_landmarker.HandLandmarkerOptions
Global Const $_HandLandmarkerResult = $hand_landmarker.HandLandmarkerResult
Global Const $_RUNNING_MODE = $running_mode_module.VisionTaskRunningMode
Global Const $_ImageProcessingOptions = $image_processing_options_module.ImageProcessingOptions

Global Const $_HAND_LANDMARKER_BUNDLE_ASSET_FILE = 'hand_landmarker.task'
Global Const $_NO_HANDS_IMAGE = 'cats_and_dogs.jpg'
Global Const $_TWO_HANDS_IMAGE = 'right_hands.jpg'
Global Const $_THUMB_UP_IMAGE = 'thumb_up.jpg'
Global Const $_THUMB_UP_LANDMARKS = 'thumb_up_landmarks.pbtxt'
Global Const $_POINTING_UP_IMAGE = 'pointing_up.jpg'
Global Const $_POINTING_UP_LANDMARKS = 'pointing_up_landmarks.pbtxt'
Global Const $_POINTING_UP_ROTATED_IMAGE = 'pointing_up_rotated.jpg'
Global Const $_POINTING_UP_ROTATED_LANDMARKS = 'pointing_up_rotated_landmarks.pbtxt'
Global Const $_LANDMARKS_MARGIN = 0.03
Global Const $_HANDEDNESS_MARGIN = 0.05

Global Const $FILE_CONTENT = 1
Global Const $FILE_NAME = 2

Global $test_image
Global $model_path


Func _get_expected_hand_landmarker_result($file_path)
	Local Const $landmarks_detection_result_file_path = get_test_data_path($file_path)

	Local $landmarks_detection_result_proto = $_LandmarksDetectionResultProto.create()
	$text_format.Parse(FileRead($landmarks_detection_result_file_path), $landmarks_detection_result_proto)
	; ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $landmarks_detection_result_proto = ' & $landmarks_detection_result_proto.__str__() & @CRLF) ;### Debug Console

	Local $landmarks_detection_result = $proto_utils.create_landmarks_detection_result_from_proto($landmarks_detection_result_proto)

	Return $_HandLandmarkerResult(_Mediapipe_Params( _
			"handedness", _Mediapipe_Tuple($landmarks_detection_result.categories), _
			"hand_landmarks", _Mediapipe_Tuple($landmarks_detection_result.landmarks), _
			"hand_world_landmarks", _Mediapipe_Tuple($landmarks_detection_result.world_landmarks)))
EndFunc   ;==>_get_expected_hand_landmarker_result


HandLandmarkerTest()

Func HandLandmarkerTest()
	HandLandmarkerTest_setUp()

	test_create_from_file_succeeds_with_valid_model_path()
	test_create_from_options_succeeds_with_valid_model_path()
	test_create_from_options_succeeds_with_valid_model_content()

	test_detect($FILE_NAME, _get_expected_hand_landmarker_result($_THUMB_UP_LANDMARKS))
	test_detect($FILE_CONTENT, _get_expected_hand_landmarker_result($_THUMB_UP_LANDMARKS))
	test_detect_succeeds_with_num_hands()
	test_detect_succeeds_with_rotation()
	test_empty_detection_outputs()

	test_detect_for_video($_THUMB_UP_IMAGE, 0, _
			_get_expected_hand_landmarker_result($_THUMB_UP_LANDMARKS))
	test_detect_for_video($_POINTING_UP_IMAGE, 0, _
			_get_expected_hand_landmarker_result($_POINTING_UP_LANDMARKS))
	test_detect_for_video($_POINTING_UP_ROTATED_IMAGE, -90, _
			_get_expected_hand_landmarker_result($_POINTING_UP_ROTATED_LANDMARKS))
	test_detect_for_video($_NO_HANDS_IMAGE, 0, $_HandLandmarkerResult.create())

EndFunc   ;==>HandLandmarkerTest

Func HandLandmarkerTest_setUp()
	Local Const $_TEST_DATA_DIR = _Mediapipe_FindResourceDir() & "\mediapipe\tasks\testdata\vision"
	Local $url, $file_path

	Local $test_files[] = [ _
			_Mediapipe_Tuple($_HAND_LANDMARKER_BUNDLE_ASSET_FILE, "https://storage.googleapis.com/mediapipe-models/hand_landmarker/hand_landmarker/float16/1/hand_landmarker.task"), _
			$_NO_HANDS_IMAGE, _
			$_TWO_HANDS_IMAGE, _
			$_THUMB_UP_IMAGE, _
			$_THUMB_UP_LANDMARKS, _
			$_POINTING_UP_IMAGE, _
			$_POINTING_UP_LANDMARKS, _
			$_POINTING_UP_ROTATED_IMAGE, _
			$_POINTING_UP_ROTATED_LANDMARKS _
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

	$test_image = $_Image.create_from_file(get_test_data_path($_THUMB_UP_IMAGE))
	$model_path = get_test_data_path($_HAND_LANDMARKER_BUNDLE_ASSET_FILE)
EndFunc

Func _expect_hand_landmarks_correct($actual_landmarks, $expected_landmarks, $margin)
	; Expects to have the same number of hands detected.
	_AssertLen($actual_landmarks, UBound($expected_landmarks))

	Local $i, $j

	$i = 0
	For $actual_landmark In $actual_landmarks
		$j = 0
		For $elem In $actual_landmark
			_AssertAlmostEqual($elem.x, ($expected_landmarks[$i])[$j].x, $margin)
			_AssertAlmostEqual($elem.y, ($expected_landmarks[$i])[$j].y, $margin)
			$j = $j + 1
		Next
		$i = $i + 1
	Next
EndFunc   ;==>_expect_hand_landmarks_correct

Func _expect_handedness_correct($actual_handedness, $expected_handedness, $margin)
	; Actual top handedness matches expected top handedness.
	Local $actual_top_handedness = ($actual_handedness[0])[0]
	Local $expected_top_handedness = ($expected_handedness[0])[0]
	_AssertEqual($actual_top_handedness.index, $expected_top_handedness.index)
	_AssertEqual($actual_top_handedness.category_name, $expected_top_handedness.category_name)
	_AssertAlmostEqual($actual_top_handedness.score, $expected_top_handedness.score, $margin)
EndFunc   ;==>_expect_handedness_correct

Func _expect_hand_landmarker_results_correct($actual_result, $expected_result)
	_expect_hand_landmarks_correct( _
			$actual_result.hand_landmarks, _
			$expected_result.hand_landmarks, _
			$_LANDMARKS_MARGIN _
			)
	_expect_handedness_correct($actual_result.handedness, $expected_result.handedness, $_HANDEDNESS_MARGIN)
EndFunc   ;==>_expect_hand_landmarker_results_correct

Func test_create_from_file_succeeds_with_valid_model_path()
	ConsoleWrite('"' & @ScriptFullPath & '" @@ Debug(' & @ScriptLineNumber & ') : test_detect' & @CRLF) ;### Debug Console

	; Creates with default option and valid model file successfully.
	Local $landmarker = $_HandLandmarker.create_from_model_path($model_path)
	_AssertIsInstance($landmarker, $_HandLandmarker)
	$landmarker.close()
EndFunc   ;==>test_create_from_file_succeeds_with_valid_model_path

Func test_create_from_options_succeeds_with_valid_model_path()
	ConsoleWrite('"' & @ScriptFullPath & '" @@ Debug(' & @ScriptLineNumber & ') : test_detect' & @CRLF) ;### Debug Console

	; Creates with options containing model file successfully.
	Local $base_options = $_BaseOptions(_Mediapipe_Params("model_asset_path", $model_path))
	Local $options = $_HandLandmarkerOptions(_Mediapipe_Params("base_options", $base_options))
	Local $landmarker = $_HandLandmarker.create_from_options($options)
	_AssertIsInstance($landmarker, $_HandLandmarker)
	$landmarker.close()
EndFunc   ;==>test_create_from_options_succeeds_with_valid_model_path

Func test_create_from_options_succeeds_with_valid_model_content()
	ConsoleWrite('"' & @ScriptFullPath & '" @@ Debug(' & @ScriptLineNumber & ') : test_detect' & @CRLF) ;### Debug Console

	; Creates with options containing model content successfully.
	Local $model_content = read_file_into_buffer($model_path)
	Local $base_options = $_BaseOptions(_Mediapipe_Params("model_asset_buffer", $model_content))
	Local $options = $_HandLandmarkerOptions(_Mediapipe_Params("base_options", $base_options))
	Local $landmarker = $_HandLandmarker.create_from_options($options)
	_AssertIsInstance($landmarker, $_HandLandmarker)
	$landmarker.close()
EndFunc   ;==>test_create_from_options_succeeds_with_valid_model_content

Func test_detect($model_file_type, $expected_detection_result)
	ConsoleWrite('"' & @ScriptFullPath & '" @@ Debug(' & @ScriptLineNumber & ') : test_detect' & @CRLF) ;### Debug Console

	Local $base_options, $model_content

	; Creates hand landmarker.
	If $model_file_type == $FILE_NAME Then
		$base_options = $_BaseOptions(_Mediapipe_Params("model_asset_path", $model_path))
	ElseIf $model_file_type == $FILE_CONTENT Then
		$model_content = read_file_into_buffer($model_path)
		$base_options = $_BaseOptions(_Mediapipe_Params("model_asset_buffer", $model_content))
	EndIf

	Local $options = $_HandLandmarkerOptions(_Mediapipe_Params("base_options", $base_options))
	Local $landmarker = $_HandLandmarker.create_from_options($options)

	; Performs hand landmarks detection on the input.
	Local $detection_result = $landmarker.detect($test_image)

	; Comparing results.
	_expect_hand_landmarker_results_correct($detection_result, $expected_detection_result)
EndFunc   ;==>test_detect

Func test_detect_succeeds_with_num_hands()
	ConsoleWrite('"' & @ScriptFullPath & '" @@ Debug(' & @ScriptLineNumber & ') : test_detect' & @CRLF) ;### Debug Console

	; Creates hand landmarker.
	Local $base_options = $_BaseOptions(_Mediapipe_Params("model_asset_path", $model_path))
	Local $options = $_HandLandmarkerOptions(_Mediapipe_Params("base_options", $base_options, "num_hands", 2))
	Local $landmarker = $_HandLandmarker.create_from_options($options)

	; Load the two hands image.
	Local $test_image = $_Image.create_from_file(get_test_data_path($_TWO_HANDS_IMAGE))

	; Performs hand landmarks detection on the input.
	Local $detection_result = $landmarker.detect($test_image)

	; Comparing results.
	_AssertLen($detection_result.handedness, 2)
EndFunc   ;==>test_detect_succeeds_with_num_hands

Func test_detect_succeeds_with_rotation()
	ConsoleWrite('"' & @ScriptFullPath & '" @@ Debug(' & @ScriptLineNumber & ') : test_detect' & @CRLF) ;### Debug Console

	; Creates hand landmarker.
	Local $base_options = $_BaseOptions(_Mediapipe_Params("model_asset_path", $model_path))
	Local $options = $_HandLandmarkerOptions(_Mediapipe_Params("base_options", $base_options))
	Local $landmarker = $_HandLandmarker.create_from_options($options)

	; Load the pointing up rotated image.
	Local $test_image = $_Image.create_from_file(get_test_data_path($_POINTING_UP_ROTATED_IMAGE))

	; Set rotation parameters using ImageProcessingOptions.
	Local $image_processing_options = $_ImageProcessingOptions(_Mediapipe_Params("rotation_degrees", -90))

	; Performs hand landmarks detection on the input.
	Local $detection_result = $landmarker.detect($test_image, $image_processing_options)
	Local $expected_detection_result = _get_expected_hand_landmarker_result($_POINTING_UP_ROTATED_LANDMARKS)

	; Comparing results.
	_expect_hand_landmarker_results_correct($detection_result, $expected_detection_result)
EndFunc   ;==>test_detect_succeeds_with_rotation

Func test_empty_detection_outputs()
	ConsoleWrite('"' & @ScriptFullPath & '" @@ Debug(' & @ScriptLineNumber & ') : test_detect' & @CRLF) ;### Debug Console

	; Creates hand landmarker.
	Local $options = $_HandLandmarkerOptions(_Mediapipe_Params( _
			"base_options", $_BaseOptions(_Mediapipe_Params("model_asset_path", $model_path))))
	Local $landmarker = $_HandLandmarker.create_from_options($options)

	; Load the image with no hands.
	Local $no_hands_test_image = $_Image.create_from_file(get_test_data_path($_NO_HANDS_IMAGE))

	; Performs hand landmarks detection on the input.
	Local $detection_result = $landmarker.detect($no_hands_test_image)
	_AssertEmpty($detection_result.hand_landmarks)
	_AssertEmpty($detection_result.hand_world_landmarks)
	_AssertEmpty($detection_result.handedness)
EndFunc   ;==>test_empty_detection_outputs

Func test_detect_for_video($image_path, $rotation, $expected_result)
	ConsoleWrite('"' & @ScriptFullPath & '" @@ Debug(' & @ScriptLineNumber & ') : test_detect' & @CRLF) ;### Debug Console

	; Creates hand landmarker.
	Local $options = $_HandLandmarkerOptions(_Mediapipe_Params( _
			"base_options", $_BaseOptions(_Mediapipe_Params("model_asset_path", $model_path)), _
			"running_mode", $_RUNNING_MODE.VIDEO))
	Local $landmarker = $_HandLandmarker.create_from_options($options)

	; Load the image.
	Local $test_image = $_Image.create_from_file(get_test_data_path($image_path))

	; Set rotation parameters using ImageProcessingOptions.
	Local $image_processing_options = $_ImageProcessingOptions(_Mediapipe_Params("rotation_degrees", $rotation))

	Local $result

	For $timestamp = 0 To (300 - 30) Step 30
		$result = $landmarker.detect_for_video($test_image, $timestamp, $image_processing_options)

		If UBound($result.hand_landmarks) > 0 And UBound($result.hand_world_landmarks) > 0 And UBound($result.handedness) > 0 Then
			_expect_hand_landmarker_results_correct($result, $expected_result)
		Else
			_AssertEqual($result, $expected_result)
		EndIf
	Next
EndFunc   ;==>test_detect_for_video

Func _OnAutoItExit()
	_Mediapipe_Close()
EndFunc   ;==>_OnAutoItExit
