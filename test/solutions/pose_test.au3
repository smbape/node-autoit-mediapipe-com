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
;~     https://github.com/google/mediapipe/blob/v0.8.11/mediapipe/python/solutions/pose_test.py

_Mediapipe_Open_And_Register(_Mediapipe_FindDLL("opencv_world4*", "opencv-4.*\opencv"), _Mediapipe_FindDLL("autoit_mediapipe_com-*"))
_OpenCV_Open_And_Register(_OpenCV_FindDLL("opencv_world4*", "opencv-4.*\opencv"), _OpenCV_FindDLL("autoit_opencv_com4*"))
OnAutoItExitRegister("_OnAutoItExit")

_Mediapipe_SetResourceDir()

Global $cv = _OpenCV_get()

Global $download_utils = _Mediapipe_ObjCreate("mediapipe.autoit.solutions.download_utils")
_AssertTrue(IsObj($download_utils), "Failed to load mediapipe.autoit.solutions.download_utils")

Global $drawing_styles = _Mediapipe_ObjCreate("mediapipe.autoit.solutions.drawing_styles")
_AssertTrue(IsObj($drawing_styles), "Failed to load mediapipe.autoit.solutions.drawing_styles")

Global $mp_drawing = _Mediapipe_ObjCreate("mediapipe.autoit.solutions.drawing_utils")
_AssertTrue(IsObj($mp_drawing), "Failed to load mediapipe.autoit.solutions.drawing_utils")

Global $mp_pose = _Mediapipe_ObjCreate("mediapipe.autoit.solutions.pose")
_AssertTrue(IsObj($mp_pose), "Failed to load mediapipe.autoit.solutions.pose")

Global $Mat = _OpenCV_ObjCreate("Mat")

#include ".\test_on_video_fullpose_squats.full.au3"

Global Const $DIFF_THRESHOLD = 15  ; pixels
Global $EXPECTED_POSE_LANDMARKS[][] = [[460, 283], [467, 273], [471, 273], _
		[474, 273], [465, 273], [465, 273], _
		[466, 273], [491, 277], [480, 277], _
		[470, 294], [465, 294], [545, 319], _
		[453, 329], [622, 323], [375, 316], _
		[696, 316], [299, 307], [719, 316], _
		[278, 306], [721, 311], [274, 304], _
		[713, 313], [283, 306], [520, 476], _
		[467, 471], [612, 550], [358, 490], _
		[701, 613], [349, 611], [709, 624], _
		[363, 630], [730, 633], [303, 628]]

Global Const $WORLD_DIFF_THRESHOLD = 15  ; pixels
Global $EXPECTED_POSE_WORLD_LANDMARKS[][] = [ _
		[-0.11, -0.59, -0.15], [-0.09, -0.64, -0.16], [-0.09, -0.64, -0.16], _
		[-0.09, -0.64, -0.16], [-0.11, -0.64, -0.14], [-0.11, -0.64, -0.14], _
		[-0.11, -0.64, -0.14], [0.01, -0.65, -0.15], [-0.06, -0.64, -0.05], _
		[-0.07, -0.57, -0.15], [-0.09, -0.57, -0.12], [0.18, -0.49, -0.09], _
		[-0.14, -0.5, -0.03], [0.41, -0.48, -0.11], [-0.42, -0.5, -0.02], _
		[0.64, -0.49, -0.17], [-0.63, -0.51, -0.13], [0.7, -0.5, -0.19], _
		[-0.71, -0.53, -0.15], [0.72, -0.51, -0.23], [-0.69, -0.54, -0.19], _
		[0.66, -0.49, -0.19], [-0.64, -0.52, -0.15], [0.09, 0.0, -0.04], _
		[-0.09, -0.0, 0.03], [0.41, 0.23, -0.09], [-0.43, 0.1, -0.11], _
		[0.69, 0.49, -0.04], [-0.48, 0.47, -0.02], [0.72, 0.52, -0.04], _
		[-0.48, 0.51, -0.02], [0.8, 0.5, -0.14], [-0.59, 0.52, -0.11] _
		]

Global Const $IOU_THRESHOLD = 0.85 ; percents

Test()

Func Test()
	test_blank_image()
	test_on_image('static_lite', True, 0, 3)
	test_on_image('static_full', True, 1, 3)
	test_on_image('static_heavy', True, 2, 3)
	test_on_image('video_lite', False, 0, 3)
	test_on_image('video_full', False, 1, 3)
	test_on_image('video_heavy', False, 2, 3)
	test_on_video('full', 1, 'pose_squats.full.npz')
EndFunc   ;==>Test

Func test_blank_image()
	Local $image = $Mat.zeros(100, 100, $CV_8UC3)
	$image.setTo(255.0)

	Local $pose = $mp_pose.Pose()
	Local $results = $pose.process($image)
	_AssertIsNone($results("pose_landmarks"))
	_AssertIsNone($results("segmentation_mask"))
EndFunc   ;==>test_blank_image

Func test_on_image($id, $static_image_mode, $model_complexity, $num_frames)
	$download_utils.download( _
			"https://github.com/tensorflow/tfjs-models/raw/master/pose-detection/test_data/pose.jpg", _
			@ScriptDir & "/testdata/pose.jpg" _
			)

	$download_utils.download( _
			"https://github.com/tensorflow/tfjs-models/raw/master/pose-detection/test_data/pose_segmentation.png", _
			@ScriptDir & "/testdata/pose_segmentation.png" _
			)

	Local $image_path = @ScriptDir & "/testdata/pose.jpg"
	Local $expected_segmentation_path = @ScriptDir & "/testdata/pose_segmentation.png"

	Local $image = $cv.imread($image_path)
	Local $expected_segmentation = _bgr_to_segmentation($cv.imread($expected_segmentation_path))

	Local $pose = $mp_pose.Pose(_Mediapipe_Params( _
			"static_image_mode", $static_image_mode, _
			"model_complexity", $model_complexity, _
			"enable_segmentation", True _
			))

	Local $results, $segmentation
	For $idx = 0 To $num_frames - 1
		$results = $pose.process($cv.cvtColor($image, $CV_COLOR_BGR2RGB))
		$segmentation = $Mat.create($results("segmentation_mask")).convertTo($CV_8U)

		; TODO: Add rendering of world 3D when supported.
		_annotate("test_on_image_" & $id, $image.copy(), $results, $idx)
		_annotate_segmentation("test_on_image_" & $id, $segmentation, $expected_segmentation, $idx)

		_AssertMatDiffLess(_landmarks_list_to_array($results("pose_landmarks"), _
				$image.shape), _
				$EXPECTED_POSE_LANDMARKS, $DIFF_THRESHOLD)
		_AssertMatDiffLess( _
				_world_landmarks_list_to_array($results("pose_world_landmarks")), _
				$EXPECTED_POSE_WORLD_LANDMARKS, $WORLD_DIFF_THRESHOLD)
		_AssertMatGreaterEqual( _
				_segmentation_iou($expected_segmentation, $segmentation), _
				$IOU_THRESHOLD)
	Next
EndFunc   ;==>test_on_image

Func test_on_video($id, $model_complexity, $expected_name)
	#forceref $id, $expected_name
	$download_utils.download( _
			"https://github.com/tensorflow/tfjs-models/raw/master/pose-detection/test_data/pose_squats.mp4", _
			@ScriptDir & "/testdata/pose_squats.mp4" _
			)

	; Set threshold for comparing actual and expected predictions in pixels.
	Local Const $DIFF_THRESHOLD = 15
	Local Const $WORLD_DIFF_THRESHOLD = 0.1

	Local $video_path = @ScriptDir & "/testdata/pose_squats.mp4"

	; Predict pose landmarks for each frame.
	Local $video_cap = _OpenCV_ObjCreate("cv.VideoCapture").create($video_path)
	If Not _AssertTrue($video_cap.isOpened(), "cannot open the video file " & $video_path & ".") Then
		Return _Mediapipe_Tuple(Default, Default)
	EndIf

	Local $pose = $mp_pose.Pose(_Mediapipe_Params( _
			"static_image_mode", False, _
			"model_complexity", $model_complexity _
			))

	Local $actual_per_frame = _OpenCV_ObjCreate("VectorOfMat")
	Local $actual_world_per_frame = _OpenCV_ObjCreate("VectorOfMat")

	Local $input_frame = $Mat.create()
	Local $results, $pose_landmarks, $pose_world_landmarks
	Local $frame_idx = 0

	While $video_cap.read($input_frame)
		; Run pose tracker.
		$results = $pose.process($cv.cvtColor($input_frame, $CV_COLOR_BGR2RGB))

		$pose_landmarks = _landmarks_list_to_array($results("pose_landmarks"), $input_frame.shape)
		$pose_world_landmarks = _world_landmarks_list_to_array($results("pose_world_landmarks"))

		$actual_per_frame.append($pose_landmarks)
		$actual_world_per_frame.append($pose_world_landmarks)

		_annotate("test_on_video_" & $id, $input_frame, $results, $frame_idx)
		$frame_idx += 1
	WEnd

	Local $actual = $cv.vconcat($actual_per_frame)
	Local $actual_world = $cv.vconcat($actual_world_per_frame)

	_AssertMatDiffLess($actual, $EXPECTED_PREDICTIONS_POSE_LANDMARKS_PER_FRAME, $DIFF_THRESHOLD)
	_AssertMatDiffLess($actual_world, $EXPECTED_PREDICTIONS_WORLD_POSE_LANDMARKS_PER_FRAME, $WORLD_DIFF_THRESHOLD)
EndFunc   ;==>test_on_video

Func _get_output_path($id, $name)
	Return @TempDir & "\" & $id & $name
EndFunc   ;==>_get_output_path

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
			$results("pose_landmarks"), _
			$mp_pose.POSE_CONNECTIONS, _
			_Mediapipe_Params("landmark_drawing_spec", $drawing_styles.get_default_pose_landmarks_style()))

	Local Const $path = @TempDir & "\" & $id & "_frame_" & $idx & ".png"
	$cv.imwrite($path, $frame)
EndFunc   ;==>_annotate

Func _annotate_segmentation($id, $segmentation, $expected_segmentation, $idx)
	Local $path
	$path = _get_output_path($id, '_segmentation_' & $idx & '.png')
	$cv.imwrite($path, _segmentation_to_bgr($segmentation))
	$path = _get_output_path($id, '_segmentation_diff_' & $idx & '.png')
	$cv.imwrite($path, _segmentation_diff_to_bgr($expected_segmentation, $segmentation))
EndFunc   ;==>_annotate_segmentation

Func _bgr_to_segmentation($img, $back_color = _OpenCV_Scalar(0, 0, 255), $front_color = _OpenCV_Scalar(255, 0, 0))
	Local $is_back = $cv.inRange($img, $back_color, $back_color)
	Local $is_front = $cv.inRange($img, $front_color, $front_color)
	_AssertEqual($cv.countNonZero($is_back) + $cv.countNonZero($is_front), $img.rows * $img.cols, "image is not a valid segmentation image")
	Local $segm = $cv.multiply($is_front, 1 / 255)
	Return $segm
EndFunc   ;==>_bgr_to_segmentation

Func _segmentation_to_bgr($segm, $back_color = _OpenCV_Scalar(0, 0, 255), $front_color = _OpenCV_Scalar(255, 0, 0))
	Local $img = $Mat.create($segm.rows, $segm.cols, $CV_8UC3)
	$img.setTo($back_color)
	$img.setTo($front_color, $segm)
	Return $img
EndFunc   ;==>_segmentation_to_bgr

Func _segmentation_iou($segm_expected, $segm_actual)
	Local Const $eps = 2 ^ (-52)
	Local $intersection = $cv.multiply($segm_expected, $segm_actual)
	Local $expected_dot = $cv.multiply($segm_expected, $segm_expected)
	Local $actual_dot = $cv.multiply($segm_actual, $segm_actual)
	Local $result = $cv.countNonZero($intersection) / ($cv.countNonZero($expected_dot) + _
			$cv.countNonZero($actual_dot) - _
			$cv.countNonZero($intersection) + $eps)
	Return $result
EndFunc   ;==>_segmentation_iou

Func _segmentation_diff_to_bgr($segm_expected, $segm_actual, $expected_color = _OpenCV_Scalar(0, 255, 0), $actual_color = _OpenCV_Scalar(0, 0, 255))
	Local $height = $segm_expected.height
	Local $width = $segm_expected.width
	Local $img = $Mat.zeros($height, $width, $CV_8UC3)
	$img.setTo($expected_color, $cv.bitwise_and($segm_expected, $cv.bitwise_not($segm_actual)))
	$img.setTo($actual_color, $cv.bitwise_and($cv.bitwise_not($segm_expected), $segm_actual))
	Return $img
EndFunc   ;==>_segmentation_diff_to_bgr

Func _OnAutoItExit()
	_OpenCV_Unregister_And_Close()
	_Mediapipe_Unregister_And_Close()
EndFunc   ;==>_OnAutoItExit
