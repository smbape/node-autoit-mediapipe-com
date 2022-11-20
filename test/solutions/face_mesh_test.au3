#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Change2CUI=y
#AutoIt3Wrapper_Au3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#include "..\..\autoit-mediapipe-com\udf\mediapipe_udf_utils.au3"
#include "..\..\autoit-opencv-com\udf\opencv_udf_utils.au3"
#include "..\_assert.au3"
#include "..\_mat_utils.au3"

;~ Sources:
;~     https://github.com/google/mediapipe/blob/v0.8.11/mediapipe/python/solutions/face_mesh_test.py

$_mediapipe_build_type = "Release"
$_mediapipe_debug = 0
$_cv_build_type = "Release"
$_cv_debug = 0
_Mediapipe_Open_And_Register(_Mediapipe_FindDLL("opencv_world4*", "opencv-4.*\opencv"), _Mediapipe_FindDLL("autoit_mediapipe_com-*"))
_OpenCV_Open_And_Register(_OpenCV_FindDLL("opencv_world4*", "opencv-4.*\opencv"), _OpenCV_FindDLL("autoit_opencv_com4*"))
OnAutoItExitRegister("_OnAutoItExit")

Global $cv = _OpenCV_get()

Global $download_utils = _Mediapipe_ObjCreate("mediapipe.autoit.solutions.download_utils")
_AssertTrue(IsObj($download_utils), "Failed to load mediapipe.autoit.solutions.download_utils")

Global $drawing_styles = _Mediapipe_ObjCreate("mediapipe.autoit.solutions.drawing_styles")
_AssertTrue(IsObj($drawing_styles), "Failed to load mediapipe.autoit.solutions.drawing_styles")

Global $mp_drawing = _Mediapipe_ObjCreate("mediapipe.autoit.solutions.drawing_utils")
_AssertTrue(IsObj($mp_drawing), "Failed to load mediapipe.autoit.solutions.drawing_utils")

Global $mp_faces = _Mediapipe_ObjCreate("mediapipe.autoit.solutions.face_mesh")
_AssertTrue(IsObj($mp_faces), "Failed to load mediapipe.autoit.solutions.face_mesh")

Global $Mat = _OpenCV_ObjCreate("Mat")

Global Const $DIFF_THRESHOLD = 5 ; pixels

Global Const $EYE_INDICES_TO_LANDMARKS[] = [ _
		_Mediapipe_Tuple(33, _Mediapipe_Tuple(345, 178)), _
		_Mediapipe_Tuple(7, _Mediapipe_Tuple(348, 179)), _
		_Mediapipe_Tuple(163, _Mediapipe_Tuple(352, 178)), _
		_Mediapipe_Tuple(144, _Mediapipe_Tuple(357, 179)), _
		_Mediapipe_Tuple(145, _Mediapipe_Tuple(365, 179)), _
		_Mediapipe_Tuple(153, _Mediapipe_Tuple(371, 179)), _
		_Mediapipe_Tuple(154, _Mediapipe_Tuple(378, 178)), _
		_Mediapipe_Tuple(155, _Mediapipe_Tuple(381, 177)), _
		_Mediapipe_Tuple(133, _Mediapipe_Tuple(383, 177)), _
		_Mediapipe_Tuple(246, _Mediapipe_Tuple(347, 175)), _
		_Mediapipe_Tuple(161, _Mediapipe_Tuple(350, 174)), _
		_Mediapipe_Tuple(160, _Mediapipe_Tuple(355, 172)), _
		_Mediapipe_Tuple(159, _Mediapipe_Tuple(362, 170)), _
		_Mediapipe_Tuple(158, _Mediapipe_Tuple(368, 171)), _
		_Mediapipe_Tuple(157, _Mediapipe_Tuple(375, 172)), _
		_Mediapipe_Tuple(173, _Mediapipe_Tuple(380, 175)), _
		_Mediapipe_Tuple(263, _Mediapipe_Tuple(467, 176)), _
		_Mediapipe_Tuple(249, _Mediapipe_Tuple(464, 177)), _
		_Mediapipe_Tuple(390, _Mediapipe_Tuple(460, 177)), _
		_Mediapipe_Tuple(373, _Mediapipe_Tuple(455, 178)), _
		_Mediapipe_Tuple(374, _Mediapipe_Tuple(448, 179)), _
		_Mediapipe_Tuple(380, _Mediapipe_Tuple(441, 179)), _
		_Mediapipe_Tuple(381, _Mediapipe_Tuple(435, 178)), _
		_Mediapipe_Tuple(382, _Mediapipe_Tuple(432, 177)), _
		_Mediapipe_Tuple(362, _Mediapipe_Tuple(430, 177)), _
		_Mediapipe_Tuple(466, _Mediapipe_Tuple(465, 175)), _
		_Mediapipe_Tuple(388, _Mediapipe_Tuple(462, 173)), _
		_Mediapipe_Tuple(387, _Mediapipe_Tuple(457, 171)), _
		_Mediapipe_Tuple(386, _Mediapipe_Tuple(450, 170)), _
		_Mediapipe_Tuple(385, _Mediapipe_Tuple(444, 171)), _
		_Mediapipe_Tuple(384, _Mediapipe_Tuple(437, 172)), _
		_Mediapipe_Tuple(398, _Mediapipe_Tuple(432, 175)) _
		]

Global Const $IRIS_INDICES_TO_LANDMARKS[] = [ _
		_Mediapipe_Tuple(468, _Mediapipe_Tuple(362, 175)), _
		_Mediapipe_Tuple(469, _Mediapipe_Tuple(371, 175)), _
		_Mediapipe_Tuple(470, _Mediapipe_Tuple(362, 167)), _
		_Mediapipe_Tuple(471, _Mediapipe_Tuple(354, 175)), _
		_Mediapipe_Tuple(472, _Mediapipe_Tuple(363, 182)), _
		_Mediapipe_Tuple(473, _Mediapipe_Tuple(449, 174)), _
		_Mediapipe_Tuple(474, _Mediapipe_Tuple(458, 174)), _
		_Mediapipe_Tuple(475, _Mediapipe_Tuple(449, 167)), _
		_Mediapipe_Tuple(476, _Mediapipe_Tuple(440, 174)), _
		_Mediapipe_Tuple(477, _Mediapipe_Tuple(449, 181)) _
		]

Test()

Func Test()
	_Mediapipe_SetResourceDir()

	test_blank_image()
	test_face("static_image_mode_no_attention", True, False, 5)
	test_face("static_image_mode_with_attention", True, True, 5)
	test_face("streaming_mode_no_attention", False, False, 10)
	test_face("streaming_mode_with_attention", False, True, 10)
EndFunc   ;==>Test

Func test_blank_image()
	Local $image = $Mat.zeros(100, 100, $CV_8UC3)
	$image.setTo(255.0)

	Local $faces = $mp_faces.FaceMesh()
	Local $results = $faces.process($image)
	_AssertIsNone($results("multi_face_landmarks"))
EndFunc   ;==>test_blank_image

Func test_face($id, $static_image_mode, $refine_landmarks, $num_frames)
	$download_utils.download( _
			"https://github.com/tensorflow/tfjs-models/raw/master/face-detection/test_data/portrait.jpg", _
			@ScriptDir & "/testdata/portrait.jpg" _
			)

	Local $image_path = @ScriptDir & "/testdata/portrait.jpg"
	Local $image = $cv.imread($image_path)
	Local $rows = $image.rows
	Local $cols = $image.cols

	Local $faces = $mp_faces.FaceMesh(_Mediapipe_Params( _
			"static_image_mode", $static_image_mode, _
			"refine_landmarks", $refine_landmarks, _
			"min_detection_confidence", 0.5 _
			))

	Local $results, $multi_face_landmarks[1], $face_landmarks, $i, $li
	Local $eye_idx, $iris_idx, $gt_lds, $prediction_error

	For $idx = 0 To $num_frames - 1
		$results = $faces.process($cv.cvtColor($image, $CV_COLOR_BGR2RGB))
        _annotate("test_face_" & $id, $image.copy(), $results, $idx, $refine_landmarks)

        ReDim $multi_face_landmarks[UBound($results("multi_face_landmarks"))]

        $li = 0
        For $landmarks In $results("multi_face_landmarks")
            _AssertEqual($landmarks.landmark.size(), _
                $refine_landmarks ? $mp_faces.FACEMESH_NUM_LANDMARKS_WITH_IRISES : $mp_faces.FACEMESH_NUM_LANDMARKS)
            $face_landmarks = $Mat.create($landmarks.landmark.size(), 2, $CV_32FC1)

            $i = 0
            For $landmark In $landmarks.landmark
                $face_landmarks($i, 0) = $landmark.x * $cols
                $face_landmarks($i, 1) = $landmark.y * $rows
                $i += 1
            Next

            $multi_face_landmarks[$li] = $face_landmarks
            $li += 1
        Next

        _AssertLen($multi_face_landmarks, 1)

        ; Verify the eye landmarks are correct as sanity check.
        For $vPair In $EYE_INDICES_TO_LANDMARKS
            $eye_idx = $vPair[0]
            $gt_lds = $vPair[1]

            $prediction_error = $cv.absdiff($Mat.createFromArray($multi_face_landmarks[0].Vec2f_at($eye_idx), $CV_32F), _
                $Mat.createFromArray($gt_lds, $CV_32F))

            If Not _AssertMatLess($prediction_error, $DIFF_THRESHOLD) Then
				$prediction_error = $Mat.createFromArray($multi_face_landmarks[0].Vec2f_at($eye_idx), $CV_32F)
				ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $idx = ' & $idx & @CRLF) ;### Debug Console
				ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $eye_idx = ' & $eye_idx & @CRLF) ;### Debug Console
				ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $prediction_error = ' & $cv.format($prediction_error) & @CRLF) ;### Debug Console
				ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $gt_lds = ' & $cv.format($Mat.createFromArray($gt_lds, $CV_32F)) & @CRLF) ;### Debug Console
			EndIf
        Next

        If $refine_landmarks Then
            For $vPair In $IRIS_INDICES_TO_LANDMARKS
                $iris_idx = $vPair[0]
                $gt_lds = $vPair[1]

                $prediction_error = $cv.absdiff($Mat.createFromArray($multi_face_landmarks[0].Vec2f_at($iris_idx), $CV_32F), _
                    $Mat.createFromArray($gt_lds, $CV_32F))

                If Not _AssertMatLess($prediction_error, $DIFF_THRESHOLD) Then
                    $prediction_error = $Mat.createFromArray($multi_face_landmarks[0].Vec2f_at($iris_idx), $CV_32F)
                    ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $idx = ' & $idx & @CRLF) ;### Debug Console
                    ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $iris_idx = ' & $iris_idx & @CRLF) ;### Debug Console
                    ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $prediction_error = ' & $cv.format($prediction_error) & @CRLF) ;### Debug Console
                    ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $gt_lds = ' & $cv.format($Mat.createFromArray($gt_lds, $CV_32F)) & @CRLF) ;### Debug Console
                EndIf
            Next
        EndIf
	Next
EndFunc   ;==>test_face

Func _annotate($id, $frame, $results, $idx, $draw_iris)
	For $face_landmarks In $results("multi_face_landmarks")
		$mp_drawing.draw_landmarks( _
				$frame, _
				$face_landmarks, _
				$mp_faces.FACEMESH_TESSELATION, _
				Default, _
				$drawing_styles.get_default_face_mesh_tesselation_style())
		$mp_drawing.draw_landmarks( _
				$frame, _
				$face_landmarks, _
				$mp_faces.FACEMESH_CONTOURS, _
				Default, _
				$drawing_styles.get_default_face_mesh_contours_style())
		If $draw_iris Then
			$mp_drawing.draw_landmarks( _
					$frame, _
					$face_landmarks, _
					$mp_faces.FACEMESH_IRISES, _
					Default, _
					$drawing_styles.get_default_face_mesh_iris_connections_style())
		EndIf
	Next

	Local Const $path = @TempDir & "\" & $id & "_frame_" & $idx & ".png"
	$cv.imwrite($path, $frame)
EndFunc   ;==>_annotate

Func _OnAutoItExit()
	_OpenCV_Unregister_And_Close()
	_Mediapipe_Unregister_And_Close()
EndFunc   ;==>_OnAutoItExit
