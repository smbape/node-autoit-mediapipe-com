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
;~     https://github.com/google/mediapipe/blob/v0.9.2.1/mediapipe/tasks/python/test/vision/hand_landmarker_test.py
;~     https://colab.research.google.com/github/googlesamples/mediapipe/blob/main/examples/hand_landmarker/python/hand_landmarker.ipynb#scrollTo=s3E6NFV-00Qt&uniqifier=1

_Mediapipe_Open(_Mediapipe_FindDLL("opencv_world470*"), _Mediapipe_FindDLL("autoit_mediapipe_com-*-470*"))
_OpenCV_Open(_OpenCV_FindDLL("opencv_world470*"), _OpenCV_FindDLL("autoit_opencv_com470*"))
OnAutoItExitRegister("_OnAutoItExit")

_Mediapipe_SetResourceDir()

Global $download_utils = _Mediapipe_ObjCreate("mediapipe.autoit.solutions.download_utils")
_AssertIsObj($download_utils, "Failed to load mediapipe.autoit.solutions.download_utils")

Global $text_format = _Mediapipe_ObjCreate("google.protobuf.text_format")
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

Global Const $hand_landmarker = _Mediapipe_ObjCreate("mediapipe.tasks.autoit.vision.hand_landmarker")
_AssertIsObj($hand_landmarker, "Failed to load mediapipe.tasks.autoit.vision.hand_landmarker")

Global Const $image_processing_options_module = _Mediapipe_ObjCreate("mediapipe.tasks.autoit.vision.core.image_processing_options")
_AssertIsObj($image_processing_options_module, "Failed to load mediapipe.tasks.autoit.vision.core.image_processing_options")

Global Const $running_mode_module = _Mediapipe_ObjCreate("mediapipe.tasks.autoit.vision.core.vision_task_running_mode")
_AssertIsObj($running_mode_module, "Failed to load mediapipe.tasks.autoit.vision.core.vision_task_running_mode")

Global Const $solutions = _Mediapipe_ObjCreate("mediapipe.solutions")
_AssertIsObj($solutions, "Failed to load mediapipe.solutions")

Global Const $landmark_pb2 = _Mediapipe_ObjCreate("mediapipe.framework.formats.landmark_pb2")
_AssertIsObj($landmark_pb2, "Failed to load mediapipe.framework.formats.landmark_pb2")

Global Const $_LandmarksDetectionResultProto = $landmarks_detection_result_pb2.LandmarksDetectionResult
Global Const $_BaseOptions = $base_options_module.BaseOptions
Global Const $_Rect = $rect_module.Rect
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
Global Const $_LANDMARKS_ERROR_TOLERANCE = 0.03
Global Const $_HANDEDNESS_MARGIN = 0.05

Global Const $FILE_CONTENT = 1
Global Const $FILE_NAME = 2

Global $test_image
Global $model_path

Test()

Func Test()
	Local Const $_TEST_DATA_DIR = _Mediapipe_FindResourceDir() & "\mediapipe\tasks\testdata"
	Local $url, $file_path

	Local $test_files[] = [ _
			$_HAND_LANDMARKER_BUNDLE_ASSET_FILE, _
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
		$url = "https://storage.googleapis.com/mediapipe-assets/" & $name
		$file_path = $_TEST_DATA_DIR & "\vision\" & $name
		If Not FileExists(get_test_data_path($name)) Then
			$download_utils.download($url, $file_path)
		EndIf
	Next

	$test_image = $_Image.create_from_file(get_test_data_path($_THUMB_UP_IMAGE))
	$model_path = get_test_data_path($_HAND_LANDMARKER_BUNDLE_ASSET_FILE)

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

EndFunc   ;==>Test

Func test_create_from_file_succeeds_with_valid_model_path()
	; Creates with default option and valid model file successfully.
	Local $landmarker = $_HandLandmarker.create_from_model_path($model_path)
	_AssertIsObj($landmarker)
	$landmarker.close()
EndFunc   ;==>test_create_from_file_succeeds_with_valid_model_path

Func test_create_from_options_succeeds_with_valid_model_path()
	; Creates with options containing model file successfully.
	Local $base_options = $_BaseOptions(_Mediapipe_Params("model_asset_path", $model_path))
	Local $options = $_HandLandmarkerOptions(_Mediapipe_Params("base_options", $base_options))
	Local $landmarker = $_HandLandmarker.create_from_options($options)
	_AssertIsObj($landmarker)
	$landmarker.close()
EndFunc   ;==>test_create_from_options_succeeds_with_valid_model_path

Func test_create_from_options_succeeds_with_valid_model_content()
	; Creates with options containing model content successfully.
	Local $model_content = read_binary_to_mat($model_path)
	Local $base_options = $_BaseOptions(_Mediapipe_Params("model_asset_buffer", $model_content))
	Local $options = $_HandLandmarkerOptions(_Mediapipe_Params("base_options", $base_options))
	Local $landmarker = $_HandLandmarker.create_from_options($options)
	_AssertIsObj($landmarker)
	$landmarker.close()
EndFunc   ;==>test_create_from_options_succeeds_with_valid_model_content

Func test_detect($model_file_type, $expected_detection_result)
	Local $base_options, $model_content

	; Creates hand landmarker.
	If $model_file_type == $FILE_NAME Then
		$base_options = $_BaseOptions(_Mediapipe_Params("model_asset_path", $model_path))
	ElseIf $model_file_type == $FILE_CONTENT Then
		$model_content = read_binary_to_mat($model_path)
		$base_options = $_BaseOptions(_Mediapipe_Params("model_asset_buffer", $model_content))
	EndIf

	Local $options = $_HandLandmarkerOptions(_Mediapipe_Params("base_options", $base_options))
	Local $landmarker = $_HandLandmarker.create_from_options($options)

	; Performs hand landmarks detection on the input.
	Local $detection_result = $landmarker.detect($test_image)

	; Comparing results.
	_assert_actual_result_approximately_matches_expected_result($detection_result, $expected_detection_result)

	; Closes the hand landmarker explicitly when the hand landmarker is not used in a context.
	$landmarker.close()
EndFunc   ;==>test_detect

Func test_detect_succeeds_with_num_hands()
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

	; Closes the hand landmarker explicitly when the hand landmarker is not used in a context.
	$landmarker.close()
EndFunc   ;==>test_detect_succeeds_with_num_hands

Func test_detect_succeeds_with_rotation()
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
	_assert_actual_result_approximately_matches_expected_result($detection_result, $expected_detection_result)

	; Closes the hand landmarker explicitly when the hand landmarker is not used in a context.
	$landmarker.close()
EndFunc   ;==>test_detect_succeeds_with_rotation

Func test_empty_detection_outputs()
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

	; Closes the hand landmarker explicitly when the hand landmarker is not used in a context.
	$landmarker.close()
EndFunc   ;==>test_empty_detection_outputs

Func test_detect_for_video($image_path, $rotation, $expected_result)
	; Creates hand landmarker.
	Local $options = $_HandLandmarkerOptions(_Mediapipe_Params( _
			"base_options", $_BaseOptions(_Mediapipe_Params("model_asset_path", $model_path)), _
			"running_mode", $_RUNNING_MODE.VIDEO))
	Local $landmarker = $_HandLandmarker.create_from_options($options)

	; Local $cv = _OpenCV_get()
	; Local $rgb_image = $cv.imread(get_test_data_path($image_path))
	; $cv.imshow("expected", draw_landmarks_on_image($rgb_image, $expected_result))
	; $cv.waitKey(0)

	; Load the image.
	Local $test_image = $_Image.create_from_file(get_test_data_path($image_path))

	; Set rotation parameters using ImageProcessingOptions.
	Local $image_processing_options = $_ImageProcessingOptions(_Mediapipe_Params("rotation_degrees", $rotation))

	Local $result

	For $timestamp = 0 To (300 - 30) Step 30
		$result = $landmarker.detect_for_video($test_image, $timestamp, $image_processing_options)

		; $cv.imshow("actual", draw_landmarks_on_image($rgb_image, $result))
		; $cv.waitKey(0)

		If $result.hand_landmarks.size() > 0 And $result.hand_world_landmarks.size() > 0 And $result.handedness.size() > 0 Then
			_assert_actual_result_approximately_matches_expected_result($result, $expected_result)
		Else
			_AssertEqual($result.hand_landmarks.size(), $expected_result.hand_landmarks.size())
			_AssertEqual($result.hand_world_landmarks.size(), $expected_result.hand_world_landmarks.size())
			_AssertEqual($result.handedness.size(), $expected_result.handedness.size())
		EndIf

		; $result = _hand_landmarker_result_to_pb2($result)
		; ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $result = ' & $result.__str__() & @CRLF) ;### Debug Console
		; ExitLoop
	Next

	; Closes the hand landmarker explicitly when the hand landmarker is not used in a context.
	$landmarker.close()
EndFunc   ;==>test_detect_for_video

; Func check_result($result, $output_image, $timestamp_ms)
; 	If $result.hand_landmarks.size() > 0 And $result.hand_world_landmarks.size() > 0 And $result.handedness.size() > 0 Then
; 		_assert_actual_result_approximately_matches_expected_result($result, $expected_result)
; 	Else
; 		_AssertEqual($result.hand_landmarks.size(), $expected_result.hand_landmarks.size())
; 		_AssertEqual($result.hand_world_landmarks.size(), $expected_result.hand_world_landmarks.size())
; 		_AssertEqual($result.handedness.size(), $expected_result.handedness.size())
; 	EndIf

; 	_AssertMatEqual($output_image.mat_view(), $test_image.mat_view())
; 	_AssertLess($observed_timestamp_ms, $timestamp_ms)
; 	$observed_timestamp_ms = $timestamp_ms
; EndFunc   ;==>check_result

; Func test_detect_async_calls($image_path, $rotation, $expected_result)
; 	; Creates hand landmarker.
; 	Local $options = $_HandLandmarkerOptions(_Mediapipe_Params( _
; 			"base_options", $_BaseOptions(_Mediapipe_Params("model_asset_path", $model_path)), _
; 			"running_mode", $_RUNNING_MODE.LIVE_STREAM, _
; 			"result_callback", check_result))
; 	Local $landmarker = $_HandLandmarker.create_from_options($options)

; 	$test_image = $_Image.create_from_file(get_test_data_path($image_path))
; 	$observed_timestamp_ms = -1

; 	; Set rotation parameters using ImageProcessingOptions.
; 	Local $image_processing_options = $_ImageProcessingOptions(_Mediapipe_Params("rotation_degrees", $rotation))

; 	For $timestamp = 0 To (300 - 30) Step 30
; 		$landmarker.detect_async($test_image, $timestamp, $image_processing_options)
; 	Next

; 	; Closes the hand landmarker explicitly when the hand landmarker is not used in a context.
; 	$landmarker.close()
; EndFunc   ;==>test_detect_async_calls

Func _get_expected_hand_landmarker_result($file_path)
	Local Const $landmarks_detection_result_file_path = get_test_data_path($file_path)

	Local $landmarks_detection_result_proto = $_LandmarksDetectionResultProto.create()
	$text_format.Parse(FileRead($landmarks_detection_result_file_path), $landmarks_detection_result_proto)
	; ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $landmarks_detection_result_proto = ' & $landmarks_detection_result_proto.__str__() & @CRLF) ;### Debug Console

	Local $landmarks_detection_result = $_LandmarksDetectionResult.create_from_pb2($landmarks_detection_result_proto)

	Return $_HandLandmarkerResult(_Mediapipe_Params( _
			"handedness", _Mediapipe_Tuple($landmarks_detection_result.categories), _
			"hand_landmarks", _Mediapipe_Tuple($landmarks_detection_result.landmarks), _
			"hand_world_landmarks", _Mediapipe_Tuple($landmarks_detection_result.world_landmarks)))
EndFunc   ;==>_get_expected_hand_landmarker_result

Func _hand_landmarker_result_to_pb2($detection_result)
	Local $landmarks_detection_result = $_LandmarksDetectionResult(_Mediapipe_Params( _
			"categories", $detection_result.handedness(0), _
			"landmarks", $detection_result.hand_landmarks(0), _
			"world_landmarks", $detection_result.hand_world_landmarks(0)))
	Return $landmarks_detection_result.to_pb2()
EndFunc   ;==>_hand_landmarker_result_to_pb2

Func _assert_actual_result_approximately_matches_expected_result($actual_result, $expected_result, $sMessage = Default, $bExit = True, $iCode = 0x7FFFFFFF, $sLine = @ScriptLineNumber)
	; Expects to have the same number of hands detected.
	_AssertLen($actual_result.hand_landmarks, _
			$expected_result.hand_landmarks.size(), $sMessage, $bExit, $iCode, $sLine)
	_AssertLen($actual_result.hand_world_landmarks, _
			$expected_result.hand_world_landmarks.size(), $sMessage, $bExit, $iCode, $sLine)
	_AssertLen($actual_result.handedness, $expected_result.handedness.size(), $sMessage, $bExit, $iCode, $sLine)

	; Actual landmarks match expected landmarks.
	Local $actual_landmarks = $actual_result.hand_landmarks(0)
	Local $expected_landmarks = $expected_result.hand_landmarks(0)
	_AssertLen($actual_landmarks, UBound($expected_landmarks), $sMessage, $bExit, $iCode, $sLine)

	Local $i = 0
	Local $expected_landmark

	For $actual_landmark In $actual_landmarks
		$expected_landmark = $expected_landmarks[$i]

		_AssertAlmostEqual( _
				$actual_landmark.x, _
				$expected_landmark.x, _
				$_LANDMARKS_ERROR_TOLERANCE, Default, $sMessage, $bExit, $iCode, $sLine)

		_AssertAlmostEqual( _
				$actual_landmark.y, _
				$expected_landmark.y, _
				$_LANDMARKS_ERROR_TOLERANCE, Default, $sMessage, $bExit, $iCode, $sLine)

		$i += 1
	Next

	; Actual handedness matches expected handedness.
	Local $actual_top_handedness = $actual_result.handedness(0)[0]
	Local $expected_top_handedness = $expected_result.handedness(0)[0]
	_AssertEqual($actual_top_handedness.index, $expected_top_handedness.index, $sMessage, $bExit, $iCode, $sLine)
	_AssertEqual($actual_top_handedness.category_name, $expected_top_handedness.category_name, $sMessage, $bExit, $iCode, $sLine)
	_AssertAlmostEqual( _
			$actual_top_handedness.score, _
			$expected_top_handedness.score, _
			$_HANDEDNESS_MARGIN, Default, $sMessage, $bExit, $iCode, $sLine)
EndFunc   ;==>_assert_actual_result_approximately_matches_expected_result

Func draw_landmarks_on_image($rgb_image, $detection_result, $scale = 1.0)
	Local $cv = _OpenCV_get()

	Local $MARGIN = 10  ; pixels
	Local $FONT_SIZE = 1
	Local $FONT_THICKNESS = 1
	Local $HANDEDNESS_TEXT_COLOR = _OpenCV_Scalar(88, 205, 54) ; vibrant green

	Local $hand_landmarks_list = $detection_result.hand_landmarks
	Local $handedness_list = $detection_result.handedness
	Local $annotated_image = $rgb_image.clone()

	Local $width = $annotated_image.width
	Local $height = $annotated_image.height

	Local $hand_landmarks, $handedness
	Local $hand_landmarks_proto
	Local $text_x, $text_y

	; Loop through the detected hands to visualize.
	For $idx = 0 To $hand_landmarks_list.size() - 1
		$hand_landmarks = $hand_landmarks_list($idx)
		$handedness = $handedness_list($idx)

		; Draw the hand landmarks.
		$hand_landmarks_proto = $landmark_pb2.NormalizedLandmarkList.create()
		For $landmark In $hand_landmarks
			$hand_landmarks_proto.landmark.add($landmark_pb2.NormalizedLandmark.create( _
					_Mediapipe_Params("x", $landmark.x, "y", $landmark.y, "z", $landmark.z)))
		Next

		$solutions.drawing_utils.draw_landmarks( _
				$annotated_image, _
				$hand_landmarks_proto, _
				$solutions.hands.HAND_CONNECTIONS, _
				$solutions.drawing_styles.get_default_hand_landmarks_style($scale), _
				$solutions.drawing_styles.get_default_hand_connections_style($scale))

		; Get the top left corner of the detected hand's bounding box.
		$text_x = 1
		$text_y = 1
		For $landmark In $hand_landmarks
			$text_x = _Min($text_x, $landmark.x)
			$text_y = _Min($text_y, $landmark.y)
		Next

		$text_x *= $width
		$text_y = $text_y * $height - $MARGIN

		; Draw handedness (left or right hand) on the image.
		$cv.putText($annotated_image, $handedness[0].category_name, _
				_OpenCV_Point($text_x, $text_y), $CV_FONT_HERSHEY_DUPLEX, _
				$FONT_SIZE, $HANDEDNESS_TEXT_COLOR, $FONT_THICKNESS, $CV_LINE_AA)
	Next

	Return $annotated_image
EndFunc   ;==>draw_landmarks_on_image

Func _OnAutoItExit()
	_OpenCV_Close()
	_Mediapipe_Close()
EndFunc   ;==>_OnAutoItExit
