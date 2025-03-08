#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Change2CUI=y
#AutoIt3Wrapper_Au3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

;~ Sources:
;~     https://mediapipe.page.link/selfie_segmentation_py_colab

;~ Images:
;~     https://unsplash.com/photos/oB1mqkdDiU0
;~     https://unsplash.com/photos/fU3EJRO_qGY

#include <GDIPlus.au3>
#include <GUIConstantsEx.au3>
#include "..\..\autoit-mediapipe-com\udf\mediapipe_udf_utils.au3"
#include "..\..\autoit-opencv-com\udf\opencv_udf_utils.au3"

_GDIPlus_Startup()
_Mediapipe_Open(_Mediapipe_FindDLL("opencv_world4110*"), _Mediapipe_FindDLL("autoit_mediapipe_com-*-4110*"))
_OpenCV_Open(_OpenCV_FindDLL("opencv_world4110*"), _OpenCV_FindDLL("autoit_opencv_com4110*"))
OnAutoItExitRegister("_OnAutoItExit")

; Tell mediapipe where to look its resource files
_Mediapipe_SetResourceDir()

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
Global $FormGUI = GUICreate("Selfie Segmentation", 1570, 640, 192, 124)

Global $InputSrcImage = GUICtrlCreateInput($MEDIAPIPE_SAMPLES_DATA_PATH & "\ilya-mirnyy-fU3EJRO_qGY-unsplash.jpg", 230, 16, 449, 21)
Global $BtnSrcImage = GUICtrlCreateButton("Browse", 689, 14, 75, 25)

Global $CheckboxUseGDI = GUICtrlCreateCheckbox("Use GDI+", 780, 14, 97, 17)
GUICtrlSetState(-1, $GUI_CHECKED)

Global $BtnExec = GUICtrlCreateButton("Execute", 689, 48, 75, 25)

Global $LabelImage = GUICtrlCreateLabel("Image", 252, 80, 46, 20)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
Global $GroupImage = GUICtrlCreateGroup("", 20, 103, 510, 516)
Global $PicImage = GUICtrlCreatePic("", 25, 114, 500, 500)
GUICtrlCreateGroup("", -99, -99, 1, 1)

Global $LabelResult = GUICtrlCreateLabel("Blurred", 747, 80, 80, 20)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
Global $GroupResult = GUICtrlCreateGroup("", 532, 103, 510, 516)
Global $PicResult = GUICtrlCreatePic("", 537, 114, 500, 500)
GUICtrlCreateGroup("", -99, -99, 1, 1)

Global $LabelSegmentation = GUICtrlCreateLabel("Segmentation", 1250, 80, 98, 20)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
Global $GroupSegmentation = GUICtrlCreateGroup("", 1044, 103, 510, 516)
Global $PicSegmentation = GUICtrlCreatePic("", 1049, 114, 500, 500)
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

	Local $mp_selfie_segmentation = $mp.solutions.selfie_segmentation

	; Show segmentation masks.
	Local $BG_COLOR = _OpenCV_Scalar(192, 192, 192) ; gray
	Local $MASK_COLOR = _OpenCV_Scalar(255, 255, 255) ; white

	; Run MediaPipe Face Mesh
	Local $selfie_segmentation = $mp_selfie_segmentation.SelfieSegmentation()

	; Convert the BGR image to RGB and process it with MediaPipe Selfie Segmentation.
	Local $results = $selfie_segmentation.process($cv.cvtColor($image, $CV_COLOR_BGR2RGB))
	If $results("segmentation_mask") == Default Then
		ConsoleWrite("No selfie segmentation for " & $image_path & @CRLF)
		_OpenCV_imshow_ControlPic($image, $FormGUI, $PicSegmentation)
		_OpenCV_imshow_ControlPic($image, $FormGUI, $PicResult)
		Return
	EndIf

	; Generate solid color images for showing the output selfie segmentation mask.
	Local $fg_image = _OpenCV_ObjCreate("Mat").create($image.size(), $CV_8UC3, $MASK_COLOR)
	Local $bg_image = _OpenCV_ObjCreate("Mat").create($image.size(), $CV_8UC3, $BG_COLOR)

	Local $segmentation_mask = $cv.compare($results("segmentation_mask"), 0.2, $CV_CMP_GT)

	Local $output_image = $bg_image.copy()
	$fg_image.copyTo($segmentation_mask, $output_image)

	_OpenCV_imshow_ControlPic($output_image, $FormGUI, $PicSegmentation)

	; Blur the image background based on the segmentation mask.
	Local $blurred_image = $cv.GaussianBlur($image, _OpenCV_Size(55, 55), 0)
	$image.copyTo($segmentation_mask, $blurred_image)

	_OpenCV_imshow_ControlPic($blurred_image, $FormGUI, $PicResult)
EndFunc   ;==>Main

Func _IsChecked($idControlID)
	Return BitAND(GUICtrlRead($idControlID), $GUI_CHECKED) = $GUI_CHECKED
EndFunc   ;==>_IsChecked

Func _OnAutoItExit()
	_OpenCV_Close()
	_Mediapipe_Close()
	_GDIPlus_Shutdown()
EndFunc   ;==>_OnAutoItExit
