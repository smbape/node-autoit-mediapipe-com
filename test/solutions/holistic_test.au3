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
;~     https://github.com/google/mediapipe/blob/v0.9.2.1/mediapipe/python/solutions/holistic_test.py

_Mediapipe_Open(_Mediapipe_FindDLL("opencv_world470*"), _Mediapipe_FindDLL("autoit_mediapipe_com-*-470*"))
_OpenCV_Open(_OpenCV_FindDLL("opencv_world470*"), _OpenCV_FindDLL("autoit_opencv_com470*"))
OnAutoItExitRegister("_OnAutoItExit")

_Mediapipe_SetResourceDir()

Global $cv = _OpenCV_get()

Global $download_utils = _Mediapipe_ObjCreate("mediapipe.autoit.solutions.download_utils")
_AssertIsObj($download_utils, "Failed to load mediapipe.autoit.solutions.download_utils")

Global $drawing_styles = _Mediapipe_ObjCreate("mediapipe.autoit.solutions.drawing_styles")
_AssertIsObj($drawing_styles, "Failed to load mediapipe.autoit.solutions.drawing_styles")

Global $mp_drawing = _Mediapipe_ObjCreate("mediapipe.autoit.solutions.drawing_utils")
_AssertIsObj($mp_drawing, "Failed to load mediapipe.autoit.solutions.drawing_utils")

Global $mp_holistic = _Mediapipe_ObjCreate("mediapipe.autoit.solutions.holistic")
_AssertIsObj($mp_holistic, "Failed to load mediapipe.autoit.solutions.holistic")

Global $Mat = _OpenCV_ObjCreate("Mat")

; #include ".\test_on_video_fullholistic_squats.full.au3"

Global Const $POSE_DIFF_THRESHOLD = 30  ; pixels
Global Const $HAND_DIFF_THRESHOLD = 30  ; pixels

Global Const $EXPECTED_POSE_LANDMARKS[][] = [[291, 110], [296, 100], [299, 100], _
		[301, 100], [286, 99], [282, 99], _
		[279, 99], [306, 103], [275, 103], _
		[298, 119], [285, 119], [329, 159], _
		[248, 146], [341, 228], [196, 167], _
		[361, 285], [153, 131], [368, 306], _
		[141, 112], [366, 306], [147, 107], _
		[362, 300], [153, 114], [299, 290], _
		[267, 289], [265, 385], [309, 385], _
		[212, 473], [337, 495], [195, 489], _
		[327, 515], [250, 508], [386, 518]]
Global Const $EXPECTED_LEFT_HAND_LANDMARKS[][] = [[364, 289], [359, 293], [356, 299], _
		[356, 306], [356, 313], [367, 306], _
		[366, 317], [363, 322], [360, 325], _
		[370, 307], [368, 318], [364, 323], _
		[360, 326], [370, 308], [369, 317], _
		[365, 322], [361, 325], [370, 308], _
		[369, 316], [366, 321], [363, 323]]
Global Const $EXPECTED_RIGHT_HAND_LANDMARKS[][] = [[143, 132], [150, 128], [155, 121], _
		[158, 115], [161, 110], [147, 104], _
		[148, 94], [147, 87], [146, 82], _
		[141, 103], [140, 92], [139, 84], _
		[137, 78], [136, 105], [133, 95], _
		[130, 89], [127, 83], [132, 109], _
		[126, 103], [122, 99], [119, 96]]

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
			"https://images.teleprogramma.pro/sites/default/files/nodes/node_540493_1653677473.jpg", _
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
