#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Change2CUI=y
#AutoIt3Wrapper_Au3Check_Parameters=-d -w 1 ; -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#include "..\..\autoit-mediapipe-com\udf\mediapipe_udf_utils.au3"
#include "..\..\autoit-opencv-com\udf\opencv_udf_utils.au3"
#include "..\_assert.au3"
#include "..\_mat_utils.au3"

$_mediapipe_build_type = "Release"
$_mediapipe_debug = 0
$_cv_build_type = "Release"
$_cv_debug = 0
_Mediapipe_Open_And_Register(_Mediapipe_FindDLL("opencv_world4*", "opencv-4.*\opencv"), _Mediapipe_FindDLL("autoit_mediapipe_com-*"))
_OpenCV_Open_And_Register(_OpenCV_FindDLL("opencv_world4*", "opencv-4.*\opencv"), _OpenCV_FindDLL("autoit_opencv_com4*"))
OnAutoItExitRegister("_OnAutoItExit")

Global $cv = _OpenCV_get()

Global $mp_drawing = _Mediapipe_ObjCreate("mediapipe.autoit.solutions.drawing_utils")
_AssertTrue(IsObj($mp_drawing), "Failed to load mediapipe.autoit.solutions.drawing_utils")

Global $mp_faces = _Mediapipe_ObjCreate("mediapipe.autoit.solutions.face_detection")
_AssertTrue(IsObj($mp_faces), "Failed to load mediapipe.autoit.solutions.face_detection")

Global $SHORT_RANGE_EXPECTED_FACE_KEY_POINTS = _OpenCV_ObjCreate("Mat").createFromVectorOfVec2i(_OpenCV_Tuple( _
		_OpenCV_Tuple(363, 182), _
		_OpenCV_Tuple(460, 186), _
		_OpenCV_Tuple(420, 241), _
		_OpenCV_Tuple(417, 284), _
		_OpenCV_Tuple(295, 199), _
		_OpenCV_Tuple(502, 198) _
		)).reshape(1, 6)

Global $FULL_RANGE_EXPECTED_FACE_KEY_POINTS = _OpenCV_ObjCreate("Mat").createFromVectorOfVec2i(_OpenCV_Tuple( _
		_OpenCV_Tuple(363, 181), _
		_OpenCV_Tuple(455, 181), _
		_OpenCV_Tuple(413, 233), _
		_OpenCV_Tuple(411, 278), _
		_OpenCV_Tuple(306, 204), _
		_OpenCV_Tuple(499, 207) _
		)).reshape(1, 6)

Global Const $DIFF_THRESHOLD = 5 ; pixels

Test()

Func Test()
	_Mediapipe_SetResourceDir()

	test_blank_image()
	test_face("short_range_model", 0)
	test_face("full_range_model", 1)
EndFunc   ;==>Test

Func test_blank_image()
	Local $image = _OpenCV_ObjCreate("Mat").zeros(100, 100, $CV_8UC3)
	$image.setTo(255.0)

	Local $faces = $mp_faces.FaceDetection(0.5)
	Local $results = $faces.process($image)

	_AssertIsNone($results("detections"))
EndFunc   ;==>test_blank_image

Func test_face($id, $model_selection)
	Local $image_path = @ScriptDir & "/testdata/portrait.jpg"
	Local $image = $cv.imread($image_path)
	Local $rows = $image.rows
	Local $cols = $image.cols

	Local $faces = $mp_faces.FaceDetection(0.5, $model_selection)
	Local $results, $location_data, $face_keypoints, $i

	For $idx = 0 To 4
		$results = $faces.process($cv.cvtColor($image, $CV_COLOR_BGR2RGB))
		_annotate("test_face_" & $id, $image.copy(), $results, $idx)
		$location_data = $results("detections")[0].location_data
		$face_keypoints = _OpenCV_ObjCreate("Mat").create($location_data.relative_keypoints.size(), 2, $CV_32SC1)
		$i = 0
		For $keypoint In $location_data.relative_keypoints
			$face_keypoints($i, 0) = $keypoint.x * $cols
			$face_keypoints($i, 1) = $keypoint.y * $rows
			$i = $i + 1
		Next

		Local $prediction_error = $cv.absdiff($face_keypoints, _
				$model_selection == 0 ? $SHORT_RANGE_EXPECTED_FACE_KEY_POINTS : $FULL_RANGE_EXPECTED_FACE_KEY_POINTS)

		_AssertLen($results("detections"), 1)
		_AssertEqual($location_data.relative_keypoints.size(), 6)
		_AssertMatLess($prediction_error, $DIFF_THRESHOLD)
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
	_OpenCV_Unregister_And_Close()
	_Mediapipe_Unregister_And_Close()
EndFunc   ;==>_OnAutoItExit
