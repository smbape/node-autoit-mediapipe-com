#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Change2CUI=y
#AutoIt3Wrapper_Au3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

;~ Sources:
;~     https://github.com/google-ai-edge/mediapipe/blob/v0.10.24/mediapipe/python/solutions/hands_test.py

#include "..\..\autoit-mediapipe-com\udf\mediapipe_udf_utils.au3"
#include "..\..\autoit-opencv-com\udf\opencv_udf_utils.au3"
#include "..\_assert.au3"
#include "..\_mat_utils.au3"

_Mediapipe_Open(_Mediapipe_FindDLL("opencv_world4110*"), _Mediapipe_FindDLL("autoit_mediapipe_com-*-4110*"))
_OpenCV_Open(_OpenCV_FindDLL("opencv_world4110*"), _OpenCV_FindDLL("autoit_opencv_com4110*"))
OnAutoItExitRegister("_OnAutoItExit")

; Tell mediapipe where to look its resource files
_Mediapipe_SetResourceDir()

Global Const $cv = _OpenCV_get()
_AssertIsObj($cv, "Failed to load opencv")

Global Const $download_utils = _Mediapipe_ObjCreate("mediapipe.autoit.solutions.download_utils")
_AssertIsObj($download_utils, "Failed to load mediapipe.autoit.solutions.download_utils")

Global Const $drawing_styles = _Mediapipe_ObjCreate("mediapipe.autoit.solutions.drawing_styles")
_AssertIsObj($drawing_styles, "Failed to load mediapipe.autoit.solutions.drawing_styles")

Global Const $mp_drawing = _Mediapipe_ObjCreate("mediapipe.autoit.solutions.drawing_utils")
_AssertIsObj($mp_drawing, "Failed to load mediapipe.autoit.solutions.drawing_utils")

Global Const $mp_hands = _Mediapipe_ObjCreate("mediapipe.autoit.solutions.hands")
_AssertIsObj($mp_hands, "Failed to load mediapipe.autoit.solutions.hands")

Global Const $Mat = _OpenCV_ObjCreate("Mat")

Global Const $LITE_MODEL_DIFF_THRESHOLD = 25  ; pixels
Global Const $FULL_MODEL_DIFF_THRESHOLD = 20  ; pixels
Global Const $EXPECTED_HAND_COORDINATES_PREDICTION[][][] = [[[580, 34], [504, 50], [459, 94], _
		[429, 146], [397, 182], [507, 167], _
		[479, 245], [469, 292], [464, 330], _
		[545, 180], [534, 265], [533, 319], _
		[536, 360], [581, 172], [587, 252], _
		[593, 304], [599, 346], [615, 168], _
		[628, 223], [638, 258], [648, 288]], _
		[[138, 343], [211, 330], [257, 286], _
		[289, 237], [322, 203], [219, 216], _
		[238, 138], [249, 90], [253, 51], _
		[177, 204], [184, 115], [187, 60], _
		[185, 19], [138, 208], [131, 127], _
		[124, 77], [117, 36], [106, 222], _
		[92, 159], [79, 124], [68, 93]]]

Test()

Func Test()
	test_blank_image()
	test_multi_hands("static_image_mode_with_lite_model", True, 0, 5)
	test_multi_hands("video_mode_with_lite_model", False, 0, 10)
	test_multi_hands("static_image_mode_with_full_model", True, 1, 5)
	test_multi_hands("video_mode_with_full_model", False, 1, 10)
	test_on_video("full", 1, "asl_hand.full.yml")
EndFunc   ;==>Test

Func test_blank_image()
	Local $image = $Mat.zeros(100, 100, $CV_8UC3)
	$image.setTo(255.0)

	Local $hands = $mp_hands.Hands()
	Local $results = $hands.process($image)
	_AssertIsNone($results("multi_hand_landmarks"))
	_AssertIsNone($results("multi_handedness"))
EndFunc   ;==>test_blank_image

Func test_multi_hands($id, $static_image_mode, $model_complexity, $num_frames)
	$download_utils.download( _
			"https://github.com/tensorflow/tfjs-models/raw/master/hand-pose-detection/test_data/hands.jpg", _
			@ScriptDir & "/testdata/hands.jpg" _
			)

	Local $image_path = @ScriptDir & "/testdata/hands.jpg"
	Local $image = $cv.imread($image_path)
	Local $rows = $image.rows
	Local $cols = $image.cols

	Local $hands = $mp_hands.Hands(_Mediapipe_Params( _
			"static_image_mode", $static_image_mode, _
			"max_num_hands", 2, _
			"model_complexity", $model_complexity, _
			"min_detection_confidence", 0.5 _
			))

	Local $results, $i, $j, $prediction_error, $diff_threshold
	Local $multi_hand_coordinates[2][21][2], $handedness[2]

	For $idx = 0 To $num_frames - 1
		$results = $hands.process($cv.cvtColor($image, $CV_COLOR_BGR2RGB))
		_annotate("test_multi_hands_" & $id, $image.copy(), $results, $idx)

		ReDim $handedness[UBound($results("multi_handedness"))]
		$i = 0
		For $_handedness In $results("multi_handedness")
			$handedness[$i] = $_handedness.classification(0).label
			$i += 1
		Next

		$i = 0
		For $landmarks In $results("multi_hand_landmarks")
			_AssertEqual($landmarks.landmark.size(), 21)
			ReDim $multi_hand_coordinates[UBound($results("multi_hand_landmarks"))][$landmarks.landmark.size()][2]

			$j = 0
			For $landmark In $landmarks.landmark
				$multi_hand_coordinates[$i][$j][0] = $landmark.x * $cols
				$multi_hand_coordinates[$i][$j][1] = $landmark.y * $rows
				$j = $j + 1
			Next

			$i += 1
		Next

		_AssertLen($handedness, 2)
		_AssertLen($multi_hand_coordinates, 2)

		$prediction_error = $cv.absdiff($Mat.createFromArray($multi_hand_coordinates, $CV_64F), _
				$Mat.createFromArray($EXPECTED_HAND_COORDINATES_PREDICTION, $CV_64F))

		$diff_threshold = $model_complexity == 0 ? $LITE_MODEL_DIFF_THRESHOLD : $FULL_MODEL_DIFF_THRESHOLD

		If Not _AssertMatLess($prediction_error, $diff_threshold) Then
			$prediction_error = $Mat.createFromArray($multi_hand_coordinates, $CV_64F)
			ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $idx = ' & $idx & @CRLF) ;### Debug Console
			ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $prediction_error = ' & $cv.format($prediction_error) & @CRLF) ;### Debug Console
			ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $EXPECTED_HAND_COORDINATES_PREDICTION = ' & _
					$cv.format($Mat.createFromArray($EXPECTED_HAND_COORDINATES_PREDICTION, $CV_64F)) & @CRLF) ;### Debug Console
		EndIf
	Next
EndFunc   ;==>test_multi_hands

Func test_on_video($id, $model_complexity, $expected_name)
	#forceref $id, $expected_name
	$download_utils.download( _
			"https://github.com/tensorflow/tfjs-models/raw/master/hand-pose-detection/test_data/asl_hand.25fps.mp4", _
			@ScriptDir & "/testdata/asl_hand.25fps.mp4" _
			)

	Local $expected_path = @ScriptDir & "/testdata/test_on_video_full" & $expected_name
	Local $storage = $cv.FileStorage($expected_path, $CV_FILE_STORAGE_READ)
	Local $expected = $storage.getNode("predictions").mat()
	Local $expected_world = $storage.getNode("w_predictions").mat()

	Local $video_path = @ScriptDir & "/testdata/asl_hand.25fps.mp4"

	Local $aTuple = _process_video($model_complexity, $video_path)
	Local $actual = $aTuple[0]
	Local $actual_world = $aTuple[1]

	; Dump actual .yml.
	$expected_path = @ScriptDir & "/testdata/_test_on_video_full" & $expected_name
	$storage = $cv.FileStorage($expected_path, $CV_FILE_STORAGE_WRITE)
	$storage.write("predictions", $actual)
	$storage.write("w_predictions", $actual_world)
	$storage.release()

	_AssertMatAllClose(_MatSliceLastDim($actual, 0, 2), _MatSliceLastDim($expected, 0, 2), 0.1)
	_AssertMatAlmostEqual($actual_world, $expected_world, 1.5 * 1e-1)
EndFunc   ;==>test_on_video

Func _landmarks_list_to_array($landmark_list, $image_shape)
	Local $rows = $image_shape[0]
	Local $cols = $image_shape[1]
	Local $aArray[$landmark_list.landmark.size()][3]

	Local $i = 0
	For $lmk In $landmark_list.landmark
		$aArray[$i][0] = $lmk.x * $cols
		$aArray[$i][1] = $lmk.y * $rows
		$aArray[$i][2] = $lmk.z * $cols
		$i += 1
	Next

	Return $Mat.createFromArray($aArray, $CV_64F)
EndFunc   ;==>_landmarks_list_to_array

Func _world_landmarks_list_to_array($landmark_list)
	Local $aArray[$landmark_list.landmark.size()][3]

	Local $i = 0
	For $lmk In $landmark_list.landmark
		$aArray[$i][0] = $lmk.x
		$aArray[$i][1] = $lmk.y
		$aArray[$i][2] = $lmk.z
		$i += 1
	Next

	Return $Mat.createFromArray($aArray, $CV_64F)
EndFunc   ;==>_world_landmarks_list_to_array

Func _annotate($id, $frame, $results, $idx)
	For $hand_landmarks In $results("multi_hand_landmarks")
		$mp_drawing.draw_landmarks( _
				$frame, $hand_landmarks, $mp_hands.HAND_CONNECTIONS, _
				$drawing_styles.get_default_hand_landmarks_style(), _
				$drawing_styles.get_default_hand_connections_style())
	Next

	Local Const $path = @TempDir & "\" & $id & "_frame_" & $idx & ".png"
	$cv.imwrite($path, $frame)
EndFunc   ;==>_annotate

Func _process_video($model_complexity, $video_path, $max_num_hands = 1, $num_landmarks = 21, $num_dimensions = 3)
	; Predict pose landmarks for each frame.
	Local $video_cap = _OpenCV_ObjCreate("cv.VideoCapture").create($video_path)
	If Not _AssertTrue($video_cap.isOpened(), "cannot open the video file " & $video_path & ".") Then
		Return _Mediapipe_Tuple(Default, Default)
	EndIf

	Local $hands = $mp_hands.Hands(_Mediapipe_Params( _
			"static_image_mode", False, _
			"max_num_hands", $max_num_hands, _
			"model_complexity", $model_complexity, _
			"min_detection_confidence", 0.5 _
			))

	Local $landmarks_per_frame = _OpenCV_ObjCreate("VectorOfMat")
	Local $w_landmarks_per_frame = _OpenCV_ObjCreate("VectorOfMat")

	Local $input_frame = $Mat.create()
	Local $frame_shape, $results, $frame_landmarks, $frame_w_landmarks
	Local $sizes[] = [0, $max_num_hands, $num_landmarks, $num_dimensions]

	; Get next frame of the video.
	While $video_cap.read($input_frame)
		; Run pose tracker.
		$frame_shape = $input_frame.shape
		$results = $hands.process($cv.cvtColor($input_frame, $CV_COLOR_BGR2RGB))

		$frame_landmarks = _OpenCV_ObjCreate("VectorOfMat")
		For $landmarks In $results("multi_hand_landmarks")
			$landmarks = _landmarks_list_to_array($landmarks, $frame_shape)
			$frame_landmarks.append($landmarks)
		Next

		$frame_w_landmarks = _OpenCV_ObjCreate("VectorOfMat")
		For $w_landmarks In $results("multi_hand_world_landmarks")
			$w_landmarks = _world_landmarks_list_to_array($w_landmarks)
			$frame_w_landmarks.append($w_landmarks)
		Next

		$landmarks_per_frame.append($cv.vconcat($frame_landmarks))
		$w_landmarks_per_frame.append($cv.vconcat($frame_w_landmarks))

		$sizes[0] += 1
	WEnd

	Return _Mediapipe_Tuple($cv.vconcat($landmarks_per_frame).reshape(1, $sizes), $cv.vconcat($w_landmarks_per_frame).reshape(1, $sizes))
EndFunc   ;==>_process_video

Func _OnAutoItExit()
	_OpenCV_Close()
	_Mediapipe_Close()
EndFunc   ;==>_OnAutoItExit
