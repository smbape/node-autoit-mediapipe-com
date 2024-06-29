#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Change2CUI=y
#AutoIt3Wrapper_Au3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

;~ Sources:
;~     https://github.com/google/mediapipe/blob/v0.10.14/mediapipe/python/solutions/holistic_test.py

#include "..\..\autoit-mediapipe-com\udf\mediapipe_udf_utils.au3"
#include "..\..\autoit-opencv-com\udf\opencv_udf_utils.au3"
#include "..\_assert.au3"
#include "..\_mat_utils.au3"

_Mediapipe_Open(_Mediapipe_FindDLL("opencv_world4100*"), _Mediapipe_FindDLL("autoit_mediapipe_com-*-4100*"))
_OpenCV_Open(_OpenCV_FindDLL("opencv_world4100*"), _OpenCV_FindDLL("autoit_opencv_com4100*"))
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

Global Const $mp_holistic = _Mediapipe_ObjCreate("mediapipe.autoit.solutions.holistic")
_AssertIsObj($mp_holistic, "Failed to load mediapipe.autoit.solutions.holistic")

Global Const $Mat = _OpenCV_ObjCreate("Mat")

; #include ".\test_on_video_fullholistic_squats.full.au3"

Global Const $POSE_DIFF_THRESHOLD = 30  ; pixels
Global Const $HAND_DIFF_THRESHOLD = 30  ; pixels

Global Const $EXPECTED_POSE_LANDMARKS[][] = [[350, 136], [357, 125], [361, 125], _
		[365, 125], [344, 124], [340, 123], _
		[336, 123], [371, 129], [332, 127], _
		[358, 145], [343, 145], [399, 195], _
		[297, 183], [415, 282], [221, 199], _
		[442, 351], [180, 153], [452, 373], _
		[169, 134], [446, 375], [174, 127], _
		[441, 366], [178, 135], [364, 359], _
		[320, 359], [326, 485], [368, 473], _
		[256, 595], [409, 609], [238, 610], _
		[402, 629], [296, 635], [468, 641]]
Global Const $EXPECTED_LEFT_HAND_LANDMARKS[][] = [[444, 358], [437, 361], [434, 369], _
		[434, 378], [433, 385], [447, 377], _
		[446, 390], [442, 396], [439, 400], _
		[450, 379], [449, 392], [444, 398], _
		[440, 401], [451, 380], [449, 392], _
		[445, 397], [440, 400], [450, 381], _
		[448, 390], [445, 395], [442, 398]]
Global Const $EXPECTED_RIGHT_HAND_LANDMARKS[][] = [[172, 162], [181, 157], [187, 149], _
		[190, 142], [194, 136], [176, 129], _
		[177, 116], [177, 108], [175, 101], _
		[169, 128], [168, 113], [166, 104], _
		[164, 97], [163, 130], [159, 117], _
		[155, 110], [153, 103], [157, 136], _
		[150, 128], [145, 123], [141, 118]]

Test()

Func Test()
	test_blank_image()
	test_on_image('static_lite', True, 0, False, 3)
	test_on_image('static_full', True, 1, False, 3)
	test_on_image('static_heavy', True, 2, False, 3)
	test_on_image('video_lite', False, 0, False, 3)
	test_on_image('video_full', False, 1, False, 3)
	test_on_image('video_heavy', False, 2, False, 3)
	test_on_image('static_full_refine_face', True, 1, True, 3)
	test_on_image('video_full_refine_face', False, 1, True, 3)
EndFunc   ;==>Test

Func test_blank_image()
	Local $image = $Mat.zeros(100, 100, $CV_8UC3)
	$image.setTo(255.0)

	Local $holistic = $mp_holistic.Holistic()
	Local $results = $holistic.process($image)
	_AssertIsNone($results("pose_landmarks"))
	_AssertIsNone($results("pose_world_landmarks"))
	_AssertIsNone($results("left_hand_landmarks"))
	_AssertIsNone($results("right_hand_landmarks"))
	_AssertIsNone($results("face_landmarks"))
	_AssertIsNone($results("segmentation_mask"))
EndFunc   ;==>test_blank_image

Func test_on_image($id, $static_image_mode, $model_complexity, $refine_face_landmarks, $num_frames)
	$download_utils.download( _
			"https://teleprogramma.pro/sites/default/files/styles/post_850x666/public/nodes/node_540493_1653677473.jpg", _
			@ScriptDir & "/testdata/holistic.jpg" _
			)

	Local $image_path = @ScriptDir & "/testdata/holistic.jpg"

	Local $image = $cv.imread($image_path)

	Local $holistic = $mp_holistic.Holistic(_Mediapipe_Params( _
			"static_image_mode", $static_image_mode, _
			"model_complexity", $model_complexity, _
			"refine_face_landmarks", $refine_face_landmarks _
			))

	Local $results
	For $idx = 0 To $num_frames - 1
		$results = $holistic.process($cv.cvtColor($image, $CV_COLOR_BGR2RGB))

		_annotate("test_on_image_" & $id, $image.copy(), $results, $idx)

		_AssertMatDiffLess(_landmarks_list_to_array($results("pose_landmarks"), _
				$image.shape), _
				$EXPECTED_POSE_LANDMARKS, $POSE_DIFF_THRESHOLD)
		_AssertMatDiffLess(_landmarks_list_to_array($results("left_hand_landmarks"), _
				$image.shape), _
				$EXPECTED_LEFT_HAND_LANDMARKS, $HAND_DIFF_THRESHOLD)
		_AssertMatDiffLess(_landmarks_list_to_array($results("right_hand_landmarks"), _
				$image.shape), _
				$EXPECTED_RIGHT_HAND_LANDMARKS, $HAND_DIFF_THRESHOLD)

		; TODO: Verify the correctness of the face landmarks.
		_AssertLen($results("face_landmarks").landmark, $refine_face_landmarks ? 478 : 468)
	Next
EndFunc   ;==>test_on_image

Func _landmarks_list_to_array($landmark_list, $image_shape)
	Local $rows = $image_shape[0]
	Local $cols = $image_shape[1]
	Local $aArray[$landmark_list.landmark.size()][2]

	Local $i = 0
	For $lmk In $landmark_list.landmark
		$aArray[$i][0] = $lmk.x * $cols
		$aArray[$i][1] = $lmk.y * $rows
		$i += 1
	Next

	Return $Mat.createFromArray($aArray, $CV_32F)
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

	Return $Mat.createFromArray($aArray, $CV_32F)
EndFunc   ;==>_world_landmarks_list_to_array

Func _annotate($id, $frame, $results, $idx)
	$mp_drawing.draw_landmarks( _
			$frame, _
			$results("face_landmarks"), _
			$mp_holistic.FACEMESH_TESSELATION, _
			_Mediapipe_Params("connection_drawing_spec", $drawing_styles.get_default_face_mesh_tesselation_style()))
	$mp_drawing.draw_landmarks( _
			$frame, _
			$results("pose_landmarks"), _
			$mp_holistic.POSE_CONNECTIONS, _
			_Mediapipe_Params("landmark_drawing_spec", $drawing_styles.get_default_pose_landmarks_style()))

	Local Const $path = @TempDir & "\" & $id & "_frame_" & $idx & ".png"
	$cv.imwrite($path, $frame)
EndFunc   ;==>_annotate

Func _OnAutoItExit()
	_OpenCV_Close()
	_Mediapipe_Close()
EndFunc   ;==>_OnAutoItExit
