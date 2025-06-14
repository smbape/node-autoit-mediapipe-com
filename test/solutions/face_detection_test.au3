#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Change2CUI=y
#AutoIt3Wrapper_Au3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

;~ Sources:
;~     https://github.com/google-ai-edge/mediapipe/blob/v0.10.24/mediapipe/python/solutions/face_detection_test.py

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

Global Const $mp_faces = _Mediapipe_ObjCreate("mediapipe.autoit.solutions.face_detection")
_AssertIsObj($mp_faces, "Failed to load mediapipe.autoit.solutions.face_detection")

Global Const $Mat = _OpenCV_ObjCreate("Mat")

Global Const $SHORT_RANGE_EXPECTED_FACE_KEY_POINTS[][] = [[363, 182], [460, 186], [420, 241], _
		[417, 284], [295, 199], [502, 198]]
Global Const $FULL_RANGE_EXPECTED_FACE_KEY_POINTS[][] = [[363, 181], [455, 181], [413, 233], _
		[411, 278], [306, 204], [499, 207]]

Global Const $DIFF_THRESHOLD = 5 ; pixels

Test()

Func Test()
	test_blank_image()
	test_face("short_range_model", 0)
	test_face("full_range_model", 1)
EndFunc   ;==>Test

Func test_blank_image()
	Local $image = $Mat.zeros(100, 100, $CV_8UC3)
	$image.setTo(255.0)

	Local $faces = $mp_faces.FaceDetection(0.5)
	Local $results = $faces.process($image)

	_AssertIsNone($results("detections"))
EndFunc   ;==>test_blank_image

Func test_face($id, $model_selection)
	$download_utils.download( _
			"https://github.com/tensorflow/tfjs-models/raw/master/face-detection/test_data/portrait.jpg", _
			@ScriptDir & "/testdata/portrait.jpg" _
			)

	Local $image_path = @ScriptDir & "/testdata/portrait.jpg"
	Local $image = $cv.imread($image_path)
	Local $rows = $image.rows
	Local $cols = $image.cols

	Local $faces = $mp_faces.FaceDetection(0.5, $model_selection)
	Local $results, $location_data, $i
	Local $face_keypoints[6][2]

	For $idx = 0 To 4
		$results = $faces.process($cv.cvtColor($image, $CV_COLOR_BGR2RGB))
		_annotate("test_face_" & $id, $image.copy(), $results, $idx)
		$location_data = $results("detections")[0].location_data
		_AssertEqual($location_data.relative_keypoints.size(), 6)
		$i = 0
		For $keypoint In $location_data.relative_keypoints
			$face_keypoints[$i][0] = $keypoint.x * $cols
			$face_keypoints[$i][1] = $keypoint.y * $rows
			$i += 1
		Next

		Local $prediction_error = $cv.absdiff($Mat.createFromArray($face_keypoints, $CV_32S), _
				$Mat.createFromArray( _
				$model_selection == 0 ? $SHORT_RANGE_EXPECTED_FACE_KEY_POINTS : $FULL_RANGE_EXPECTED_FACE_KEY_POINTS _
				))

		_AssertLen($results("detections"), 1)
		_AssertMatLess($prediction_error, $DIFF_THRESHOLD)

		; $results = $cv.format($Mat.createFromArray($face_keypoints, $CV_32S))
		; ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $results = ' & $results & @CRLF) ;### Debug Console
	Next
EndFunc   ;==>test_face

Func _annotate($id, $frame, $results, $idx)
	For $detection In $results("detections")
		$mp_drawing.draw_detection($frame, $detection)
	Next

	Local Const $path = @TempDir & "\" & $id & "_frame_" & $idx & ".png"
	$cv.imwrite($path, $frame)
EndFunc   ;==>_annotate

Func _OnAutoItExit()
	_OpenCV_Close()
	_Mediapipe_Close()
EndFunc   ;==>_OnAutoItExit
