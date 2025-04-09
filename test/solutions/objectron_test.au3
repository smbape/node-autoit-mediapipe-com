#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Change2CUI=y
#AutoIt3Wrapper_Au3Check_Parameters=-d -w 1 ; -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

;~ Sources:
;~     https://github.com/google-ai-edge/mediapipe/blob/v0.10.22/mediapipe/python/solutions/objectron_test.py

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

Global Const $mp_drawing = _Mediapipe_ObjCreate("mediapipe.autoit.solutions.drawing_utils")
_AssertIsObj($mp_drawing, "Failed to load mediapipe.autoit.solutions.drawing_utils")

Global Const $mp_objectron = _Mediapipe_ObjCreate("mediapipe.autoit.solutions.objectron")
_AssertIsObj($mp_objectron, "Failed to load mediapipe.autoit.solutions.objectron")

Global Const $DIFF_THRESHOLD = 30 ; pixels

Global $EXPECTED_BOX_COORDINATES_PREDICTION[][][] = [ _
		[[322, 142], [366, 109], [222, 209], _
		[365, 55], [206, 154], [422, 135], _
		[273, 254], [426, 74], [259, 195]], _
		[[176, 113], [226, 94], [88, 164], _
		[220, 47], [68, 113], [265, 115], _
		[127, 195], [262, 65], [110, 140]]]

Test()

Func Test()
	test_blank_image()
	test_multi_objects("static_image_mode", True, 1)
	test_multi_objects("video_mode", False, 5)
EndFunc   ;==>Test

Func test_blank_image()
	Local $image = _OpenCV_ObjCreate("Mat").zeros(100, 100, $CV_8UC3)
	$image.setTo(255.0)

	Local $objectron = $mp_objectron.Objectron()
	Local $results = $objectron.process($image)

	_AssertIsNone($results("detected_objects"))
EndFunc   ;==>test_blank_image

Func test_multi_objects($id, $static_image_mode, $num_frames)
	$download_utils.download( _
			"https://github.com/rkuo2000/cv2/raw/master/shoes.jpg", _
			@ScriptDir & "/testdata/shoes.jpg" _
			)

	Local $image_path = @ScriptDir & "/testdata/shoes.jpg"
	Local $image = $cv.imread($image_path)
	Local $rows = $image.rows
	Local $cols = $image.cols

	Local $objectron = $mp_objectron.Objectron(_Mediapipe_Params( _
			"static_image_mode", $static_image_mode, _
			"max_num_objects", 2, _
			"min_detection_confidence", 0.5 _
			))

	Local $Mat = _OpenCV_ObjCreate("Mat")
	Local $multi_box_coordinates[2][9][2], $row, $col
	Local $results, $landmarks, $prediction_error

	For $idx = 0 To $num_frames - 1
		$results = $objectron.process($cv.cvtColor($image, $CV_COLOR_BGR2RGB))
		_AssertLen($results("detected_objects"), 2)

		_annotate("test_multi_objects_" & $id, $image, $results, $idx)

		$row = 0
		For $detected_object In $results("detected_objects")
			$landmarks = $detected_object.landmarks_2d
			_AssertEqual($landmarks.landmark.size(), 9)

			$col = 0
			For $landmark In $landmarks.landmark
				$multi_box_coordinates[$row][$col][0] = $landmark.x * $cols
				$multi_box_coordinates[$row][$col][1] = $landmark.y * $rows
				$col += 1
			Next

			$row += 1
		Next

		$prediction_error = $cv.absdiff($Mat.createFromArray($multi_box_coordinates, $CV_32F), _
				$Mat.createFromArray($EXPECTED_BOX_COORDINATES_PREDICTION, $CV_32F))

		; $results = $cv.format($Mat.createFromArray($multi_box_coordinates, $CV_32S))
		; ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $results = ' & $results & @CRLF) ;### Debug Console
		_AssertMatLess($prediction_error.reshape(1), $DIFF_THRESHOLD)
	Next
EndFunc   ;==>test_multi_objects

Func _annotate($id, $frame, $results, $idx)
	$frame = $frame.copy()

	For $detected_object In $results("detected_objects")
		$mp_drawing.draw_landmarks($frame, $detected_object.landmarks_2d, $mp_objectron.BOX_CONNECTIONS)
		$mp_drawing.draw_axis($frame, $detected_object.rotation, $detected_object.translation)
	Next

	Local Const $path = @TempDir & "\" & $id & "_frame_" & $idx & ".png"
	$cv.imwrite($path, $frame)
EndFunc   ;==>_annotate

Func _OnAutoItExit()
	_OpenCV_Close()
	_Mediapipe_Close()
EndFunc   ;==>_OnAutoItExit
