#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Change2CUI=y
#AutoIt3Wrapper_Au3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#include <GDIPlus.au3>
#include <GUIConstantsEx.au3>
#include "..\..\autoit-mediapipe-com\udf\mediapipe_udf_utils.au3"
#include "..\..\autoit-opencv-com\udf\opencv_udf_utils.au3"

;~ Sources:
;~     https://mediapipe.page.link/pose_py_colab

;~ Images:
;~     https://unsplash.com/photos/v4zceVZ5HK8
;~     https://unsplash.com/photos/e_rhazQLaSs

_GDIPlus_Startup()
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

Global Const $MEDIAPIPE_SAMPLES_DATA_PATH = _OpenCV_FindFile("examples\data")

#Region ### START Koda GUI section ### Form=
Global $FormGUI = GUICreate("Pose", 1560, 640, 192, 124)

Global $InputSrcImage = GUICtrlCreateInput($MEDIAPIPE_SAMPLES_DATA_PATH & "\thao-lee-v4zceVZ5HK8-unsplash.jpg", 230, 16, 449, 21)
Global $BtnSrcImage = GUICtrlCreateButton("Browse", 689, 14, 75, 25)

Global $CheckboxUseGDI = GUICtrlCreateCheckbox("Use GDI+", 780, 14, 97, 17)
GUICtrlSetState(-1, $GUI_CHECKED)

Global $BtnExec = GUICtrlCreateButton("Execute", 689, 48, 75, 25)

Global $LabelImage = GUICtrlCreateLabel("Image", 252, 80, 46, 20)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
Global $GroupImage = GUICtrlCreateGroup("", 20, 103, 510, 516)
Global $PicImage = GUICtrlCreatePic("", 25, 114, 500, 500)
GUICtrlCreateGroup("", -99, -99, 1, 1)

Global $LabelResult = GUICtrlCreateLabel("Pose", 747, 80, 80, 20)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
Global $GroupResult = GUICtrlCreateGroup("", 532, 103, 510, 516)
Global $PicResult = GUICtrlCreatePic("", 537, 114, 500, 500)
GUICtrlCreateGroup("", -99, -99, 1, 1)

Global $LabelSegmentation = GUICtrlCreateLabel("Segmentation", 1233, 80, 98, 20)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
Global $GroupSegmentation = GUICtrlCreateGroup("", 1027, 103, 510, 516)
Global $PicSegmentation = GUICtrlCreatePic("", 1032, 114, 500, 500)
GUICtrlCreateGroup("", -99, -99, 1, 1)

GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

Global $sSrcImage
Global $nMsg

Main()

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			ExitLoop
		Case $BtnSrcImage
			$sSrcImage = ControlGetText($FormGUI, "", $InputSrcImage)
			$sSrcImage = FileOpenDialog("Select an image", $MEDIAPIPE_SAMPLES_DATA_PATH, "Image files (*.bmp;*.dlib;*.jpg;*.jpeg;*.png;*.pbm;*.pgm;*.ppm;*.pxm;*.pnm;*.pfm;*.sr;*.ras;*.tiff;*.tif;*.exr;*.hdr;.pic)", $FD_FILEMUSTEXIST, $sSrcImage)
			If Not @error Then
				ControlSetText($FormGUI, "", $InputSrcImage, $sSrcImage)
			EndIf
		Case $BtnExec
			Main()
	EndSwitch
WEnd

Func Main()
	$_cv_gdi_resize = _IsChecked($CheckboxUseGDI)

	Local $image_path = ControlGetText($FormGUI, "", $InputSrcImage)
	Local $image = _OpenCV_imread_and_check($image_path)
	If @error Then Return

	; Preview the images.
	_OpenCV_imshow_ControlPic($image, $FormGUI, $PicImage)

	Local $mp_pose = $mp.solutions.pose
	Local $mp_drawing = $mp.solutions.drawing_utils
	Local $mp_drawing_styles = $mp.solutions.drawing_styles

	; Run MediaPipe Pose and draw pose landmarks.
	Local $pose = $mp_pose.Pose(_Mediapipe_Params( _
			"static_image_mode", True, _
			"min_detection_confidence", 0.5, _
			"model_complexity", 2 _
			))

	; Convert the BGR image to RGB and process it with MediaPipe Pose.
	Local $results = $pose.process($cv.cvtColor($image, $CV_COLOR_BGR2RGB))

	If $results("pose_landmarks") == Default Then
		ConsoleWrite("No pose detection for " & $image_path & @CRLF)
		_OpenCV_imshow_ControlPic($image, $FormGUI, $PicResult)
		_OpenCV_imshow_ControlPic($image, $FormGUI, $PicSegmentation)
		Return
	EndIf

	; keep drawings visible after resize
	Local $ratio = _OpenCV_resizeRatio_ControlPic($image, $FormGUI, $PicResult)
	Local $scale = 1 / $ratio

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
			$results("pose_landmarks").landmark($mp_pose.PoseLandmark.NOSE).x * $image_width & ', ' & _
			$results("pose_landmarks").landmark($mp_pose.PoseLandmark.NOSE).y * $image_height & ')' & _
			@CRLF _
			)

	; Draw pose landmarks.
	ConsoleWrite('Pose landmarks of ' & $image_path & ':' & @CRLF)
	Local $annotated_image = $image.copy()
	$mp_drawing.draw_landmarks( _
			$annotated_image, _
			$results("pose_landmarks"), _
			$mp_pose.POSE_CONNECTIONS, _
			_Mediapipe_Params( _
			"landmark_drawing_spec", $mp_drawing_styles.get_default_pose_landmarks_style($scale), _
			"connection_drawing_spec", $connection_drawing_spec _
			))

	_OpenCV_imshow_ControlPic($annotated_image, $FormGUI, $PicResult)

	; Run MediaPipe Pose with `enable_segmentation=True` to get pose segmentation.
	$pose = $mp_pose.Pose(_Mediapipe_Params( _
			"static_image_mode", True, _
			"min_detection_confidence", 0.5, _
			"model_complexity", 2, _
			"enable_segmentation", True _
			))

	$results = $pose.process($cv.cvtColor($image, $CV_COLOR_BGR2RGB))

	; Draw pose segmentation.
	ConsoleWrite('Pose segmentation of ' & $image_path & ':' & @CRLF)
	$annotated_image = $image.copy()
	Local $red_img = _OpenCV_ObjCreate("Mat").create($image.rows, $image.cols, $CV_32FC3, _OpenCV_Scalar(255, 255, 255))
	Local $segm_2class = $cv.add($cv.multiply($results("segmentation_mask"), 0.8), 0.2)
	$segm_2class = $cv.merge(_OpenCV_Tuple($segm_2class, $segm_2class, $segm_2class))
	$annotated_image = $cv.multiply($annotated_image.convertTo($CV_32F), $segm_2class)
	$red_img = $cv.multiply($red_img, $cv.subtract(1.0, $segm_2class))
	$annotated_image = $cv.add($annotated_image, $red_img)

	_OpenCV_imshow_ControlPic($annotated_image, $FormGUI, $PicSegmentation)
EndFunc   ;==>Main

Func _IsChecked($idControlID)
	Return BitAND(GUICtrlRead($idControlID), $GUI_CHECKED) = $GUI_CHECKED
EndFunc   ;==>_IsChecked

Func _OnAutoItExit()
	_OpenCV_Unregister_And_Close()
	_Mediapipe_Unregister_And_Close()
	_GDIPlus_Shutdown()
EndFunc   ;==>_OnAutoItExit
