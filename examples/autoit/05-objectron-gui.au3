#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Change2CUI=y
#AutoIt3Wrapper_Au3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

;~ Sources:
;~     https://mediapipe.page.link/hands_py_colab

;~ Images:
;~     https://unsplash.com/photos/QyCH5jwrD_A
;~     https://unsplash.com/photos/mt2fyrdXxzk

#include <GDIPlus.au3>
#include <GuiComboBox.au3>
#include <GUIConstantsEx.au3>
#include "..\..\autoit-mediapipe-com\udf\mediapipe_udf_utils.au3"
#include "..\..\autoit-opencv-com\udf\opencv_udf_utils.au3"

_GDIPlus_Startup()
_Mediapipe_Open(_Mediapipe_FindDLL("opencv_world4100*"), _Mediapipe_FindDLL("autoit_mediapipe_com-*-4100*"))
_OpenCV_Open(_OpenCV_FindDLL("opencv_world4100*"), _OpenCV_FindDLL("autoit_opencv_com4100*"))
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
Global $FormGUI = GUICreate("Objectron", 1065, 640, 192, 124)

Global $InputSrcImage = GUICtrlCreateInput($MEDIAPIPE_SAMPLES_DATA_PATH & "\aisfaris-jr-8dukMg99Hd8-unsplash.jpg", 230, 16, 449, 21)
Global $BtnSrcImage = GUICtrlCreateButton("Browse", 689, 14, 75, 25)

Global $CheckboxUseGDI = GUICtrlCreateCheckbox("Use GDI+", 780, 14, 97, 17)
GUICtrlSetState(-1, $GUI_CHECKED)

Global $LabelModelName = GUICtrlCreateLabel("Model name", 396, 48, 89, 20)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
Global $ComboModelName = GUICtrlCreateCombo("", 498, 48, 180, 25, BitOR($GUI_SS_DEFAULT_COMBO, $CBS_SIMPLE))
GUICtrlSetData(-1, "Shoe|Chair|Cup|Camera")

Global $BtnExec = GUICtrlCreateButton("Execute", 689, 48, 75, 25)

Global $LabelImage = GUICtrlCreateLabel("Image", 252, 80, 46, 20)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
Global $GroupImage = GUICtrlCreateGroup("", 20, 103, 510, 516)
Global $PicImage = GUICtrlCreatePic("", 25, 114, 500, 500)
GUICtrlCreateGroup("", -99, -99, 1, 1)

Global $LabelResult = GUICtrlCreateLabel("Objectron", 747, 80, 80, 20)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
Global $GroupResult = GUICtrlCreateGroup("", 532, 103, 510, 516)
Global $PicResult = GUICtrlCreatePic("", 537, 114, 500, 500)
GUICtrlCreateGroup("", -99, -99, 1, 1)

GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

_GUICtrlComboBox_SetCurSel($ComboModelName, 0)

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

	Local $model_name = GUICtrlRead($ComboModelName)

	; Preview the images.
	_OpenCV_imshow_ControlPic($image, $FormGUI, $PicImage)

	Local $mp_objectron = $mp.solutions.objectron
	Local $mp_drawing = $mp.solutions.drawing_utils

	; Run MediaPipe Objectron and draw pose landmarks.
	Local $objectron = $mp_objectron.Objectron(_Mediapipe_Params( _
			"static_image_mode", True, _
			"max_num_objects", 5, _
			"min_detection_confidence", 0.5, _
			"model_name", $model_name _
			))

	; Convert the BGR image to RGB and process it with MediaPipe Objectron.
	Local $results = $objectron.process($cv.cvtColor($image, $CV_COLOR_BGR2RGB))

	If $results("detected_objects") == Default Then
		ConsoleWrite("No box landmarks detected on " & $image_path & @CRLF)
		_OpenCV_imshow_ControlPic($image, $FormGUI, $PicResult)
		Return
	EndIf

	; Display the image
	Local $ratio = _OpenCV_resizeRatio_ControlPic($image, $FormGUI, $PicResult)

	; Compute the scale to make drawn elements visible when the image is resized for display
	Local $scale = 1 / $ratio

	; enlarge/shrink drawings to keep them visible after resize
	Local $landmark_drawing_spec = $mp_drawing.DrawingSpec($mp_drawing.RED_COLOR)
	$landmark_drawing_spec.thickness *= $scale
	$landmark_drawing_spec.circle_radius *= $scale

	Local $connection_drawing_spec = $mp_drawing.DrawingSpec()
	$connection_drawing_spec.thickness *= $scale
	$connection_drawing_spec.circle_radius *= $scale

	; Draw box landmarks.
	ConsoleWrite('Box landmarks of ' & $image_path & ':' & @CRLF)
	Local $annotated_image = $image.copy()
	For $detected_object In $results("detected_objects")
		$mp_drawing.draw_landmarks($annotated_image, $detected_object.landmarks_2d, $mp_objectron.BOX_CONNECTIONS, _
				_Mediapipe_Params( _
				"landmark_drawing_spec", $landmark_drawing_spec, _
				"connection_drawing_spec", $connection_drawing_spec _
				))
		$mp_drawing.draw_axis($annotated_image, $detected_object.rotation, $detected_object.translation, _
				_Mediapipe_Params("axis_drawing_spec", $connection_drawing_spec))
	Next

	_OpenCV_imshow_ControlPic($annotated_image, $FormGUI, $PicResult)
EndFunc   ;==>Main

Func _IsChecked($idControlID)
	Return BitAND(GUICtrlRead($idControlID), $GUI_CHECKED) = $GUI_CHECKED
EndFunc   ;==>_IsChecked

Func _OnAutoItExit()
	_OpenCV_Close()
	_Mediapipe_Close()
	_GDIPlus_Shutdown()
EndFunc   ;==>_OnAutoItExit
