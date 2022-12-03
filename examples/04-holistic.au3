#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Change2CUI=y
#AutoIt3Wrapper_Au3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#include "..\autoit-mediapipe-com\udf\mediapipe_udf_utils.au3"
#include "..\autoit-opencv-com\udf\opencv_udf_utils.au3"

;~ Sources:
;~     https://mediapipe.page.link/holistic_py_colab

_Mediapipe_Open_And_Register(_Mediapipe_FindDLL("opencv_world4*", "opencv-4.*\opencv"), _Mediapipe_FindDLL("autoit_mediapipe_com-*"))
_OpenCV_Open_And_Register(_OpenCV_FindDLL("opencv_world4*", "opencv-4.*\opencv"), _OpenCV_FindDLL("autoit_opencv_com4*"))
OnAutoItExitRegister("_OnAutoItExit")

Global $mp = _Mediapipe_get()
If Not IsObj($mp) Then
	ConsoleWriteError("Failed to load mediapipe" & @CRLF)
	Exit
EndIf

Global $cv = _OpenCV_get()
If Not IsObj($cv) Then
	ConsoleWriteError("Failed to load opencv" & @CRLF)
	Exit
EndIf

Example()

Func Example()
	Local Const $image_path = _OpenCV_FindFile("examples\data\thao-lee-v4zceVZ5HK8-unsplash.jpg")
	Local $image = _OpenCV_imread_and_check($image_path)
	If @error Then Return

	; Preview the images.
	Local $ratio = resize_and_show("preview", $image)
	Local $scale = 1 / $ratio

	Local $mp_holistic = $mp.solutions.holistic
	Local $mp_drawing = $mp.solutions.drawing_utils
	Local $mp_drawing_styles = $mp.solutions.drawing_styles

	; Run MediaPipe Holistic and draw pose landmarks.
	Local $holistic = $mp_holistic.Holistic(_Mediapipe_Params( _
			"static_image_mode", True, _
			"min_detection_confidence", 0.5, _
			"model_complexity", 2 _
			))

	; Convert the BGR image to RGB and process it with MediaPipe Pose.
	Local $results = $holistic.process($cv.cvtColor($image, $CV_COLOR_BGR2RGB))

	If $results("pose_landmarks") == Default Then
		ConsoleWrite("No holistic detection for " & $image_path & @CRLF)
		Return
	EndIf

	; enlarge/shrink drawings to keep them visible after resize
	Local $landmark_drawing_spec = $mp_drawing.DrawingSpec($mp_drawing.RED_COLOR)
	$landmark_drawing_spec.thickness *= $scale
	$landmark_drawing_spec.circle_radius *= $scale

	Local $connection_drawing_spec = $mp_drawing.DrawingSpec()
	$connection_drawing_spec.thickness *= $scale
	$connection_drawing_spec.circle_radius *= $scale

	; Print nose coordinates.
	Local $image_width = $image.width
	Local $image_height = $image.height
	ConsoleWrite( _
			'Nose coordinates: (' & _
			$results("pose_landmarks").landmark($mp_holistic.PoseLandmark.NOSE).x * $image_width & ', ' & _
			$results("pose_landmarks").landmark($mp_holistic.PoseLandmark.NOSE).y * $image_height & ')' & _
			@CRLF _
			)

	; Draw pose landmarks.
	ConsoleWrite('Pose landmarks of ' & $image_path & ':' & @CRLF)
	Local $annotated_image = $image.copy()
	$mp_drawing.draw_landmarks($annotated_image, $results("left_hand_landmarks"), $mp_holistic.HAND_CONNECTIONS, $landmark_drawing_spec)
	$mp_drawing.draw_landmarks($annotated_image, $results("right_hand_landmarks"), $mp_holistic.HAND_CONNECTIONS, $landmark_drawing_spec)
	$mp_drawing.draw_landmarks( _
			$annotated_image, _
			$results("face_landmarks"), _
			$mp_holistic.FACEMESH_TESSELATION, _
			_Mediapipe_Params( _
			"landmark_drawing_spec", $landmark_drawing_spec, _
			"connection_drawing_spec", $mp_drawing_styles.get_default_face_mesh_tesselation_style($scale) _
			))
	$mp_drawing.draw_landmarks( _
			$annotated_image, _
			$results("pose_landmarks"), _
			$mp_holistic.POSE_CONNECTIONS, _
			_Mediapipe_Params( _
			"landmark_drawing_spec", $mp_drawing_styles.get_default_pose_landmarks_style($scale), _
			"connection_drawing_spec", $connection_drawing_spec _
			))

	resize_and_show("holistic", $annotated_image)

	; Run MediaPipe Holistic with `enable_segmentation=True` to get pose segmentation.
	$holistic = $mp_holistic.Holistic(_Mediapipe_Params( _
			"static_image_mode", True, _
			"enable_segmentation", True _
			))

	$results = $holistic.process($cv.cvtColor($image, $CV_COLOR_BGR2RGB))

	; Draw pose segmentation.
	ConsoleWrite('Pose segmentation of ' & $image_path & ':' & @CRLF)
	$annotated_image = $image.copy()
	Local $red_img = _OpenCV_ObjCreate("Mat").create($image.rows, $image.cols, $CV_32FC3, _OpenCV_Scalar(255, 255, 255))
	Local $segm_2class = $cv.add($cv.multiply($results("segmentation_mask"), 0.8), 0.2)
	$segm_2class = $cv.merge(_OpenCV_Tuple($segm_2class, $segm_2class, $segm_2class))
	$annotated_image = $cv.multiply($annotated_image.convertTo($CV_32F), $segm_2class)
	$red_img = $cv.multiply($red_img, $cv.subtract(1.0, $segm_2class))
	$annotated_image = $cv.add($annotated_image, $red_img)
	resize_and_show("segmentation", $annotated_image)

	; display images until a keyboard action is detected
	$cv.waitKey()
EndFunc   ;==>Example

Func resize_and_show($title, $image)
	Local Const $DESIRED_HEIGHT = 480
	Local Const $DESIRED_WIDTH = 480
	Local $w = $image.width
	Local $h = $image.height

	If $h < $w Then
		$h = $h / ($w / $DESIRED_WIDTH)
		$w = $DESIRED_WIDTH
	Else
		$w = $w / ($h / $DESIRED_HEIGHT)
		$h = $DESIRED_HEIGHT
	EndIf

	Local $interpolation = $DESIRED_WIDTH > $image.width Or $DESIRED_HEIGHT > $image.height ? $CV_INTER_CUBIC : $CV_INTER_AREA

	Local $img = $cv.resize($image, _OpenCV_Size($w, $h), _OpenCV_Params("interpolation", $interpolation))
	$cv.imshow($title, $img.convertToShow())

	Return $img.width / $image.width
EndFunc   ;==>resize_and_show

Func _OnAutoItExit()
	_OpenCV_Unregister_And_Close()
	_Mediapipe_Unregister_And_Close()
EndFunc   ;==>_OnAutoItExit
