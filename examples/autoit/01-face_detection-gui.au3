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
;~     https://mediapipe.page.link/face_detection_py_colab

;~ Images:
;~     https://unsplash.com/photos/JyVcAIUAcPM
;~     https://unsplash.com/photos/auTAb39ImXg
;~     https://unsplash.com/photos/ezgW6z6oIvA
;~     https://unsplash.com/photos/_veZpXKU71c

_GDIPlus_Startup()
_Mediapipe_Open(_Mediapipe_FindDLL("opencv_world470*"), _Mediapipe_FindDLL("autoit_mediapipe_com-*-470*"))
_OpenCV_Open(_OpenCV_FindDLL("opencv_world470*"), _OpenCV_FindDLL("autoit_opencv_com470*"))
OnAutoItExitRegister("_OnAutoItExit")

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
Global $FormGUI = GUICreate("Face Detection", 1065, 700, 192, 124)

Global $InputSrcShortRange = GUICtrlCreateInput($MEDIAPIPE_SAMPLES_DATA_PATH & "\garrett-jackson-auTAb39ImXg-unsplash.jpg", 230, 16, 449, 21)
Global $BtnSrcShortRange = GUICtrlCreateButton("Short range image", 689, 14, 99, 25)

Global $InputSrcFullRange = GUICtrlCreateInput($MEDIAPIPE_SAMPLES_DATA_PATH & "\brooke-cagle-ezgW6z6oIvA-unsplash.jpg", 230, 52, 449, 21)
Global $BtnSrcFullRange = GUICtrlCreateButton("Full range image", 689, 50, 99, 25)

Global $CheckboxUseGDI = GUICtrlCreateCheckbox("Use GDI+", 832, 12, 97, 17)
GUICtrlSetState(-1, $GUI_CHECKED)

Global $BtnExec = GUICtrlCreateButton("Execute", 832, 48, 75, 25)

Global $LabelShortRange = GUICtrlCreateLabel("Short range image", 210, 140, 130, 20)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
Global $GroupShortRange = GUICtrlCreateGroup("", 20, 163, 510, 516)
Global $PicShortRange = GUICtrlCreatePic("", 25, 174, 500, 500)
GUICtrlCreateGroup("", -99, -99, 1, 1)

Global $LabelFullRange = GUICtrlCreateLabel("Full range image", 727, 140, 120, 20)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
Global $GroupFullRange = GUICtrlCreateGroup("", 532, 163, 510, 516)
Global $PicFullRange = GUICtrlCreatePic("", 537, 174, 500, 500)
GUICtrlCreateGroup("", -99, -99, 1, 1)

GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

Global $sSrcShortRange, $sSrcFullRange
Global $nMsg

Main()

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			ExitLoop
		Case $BtnSrcShortRange
			$sSrcShortRange = ControlGetText($FormGUI, "", $InputSrcShortRange)
			$sSrcShortRange = FileOpenDialog("Select an image", $MEDIAPIPE_SAMPLES_DATA_PATH, "Image files (*.bmp;*.dlib;*.jpg;*.jpeg;*.png;*.pbm;*.pgm;*.ppm;*.pxm;*.pnm;*.pfm;*.sr;*.ras;*.tiff;*.tif;*.exr;*.hdr;.pic)", $FD_FILEMUSTEXIST, $sSrcShortRange)
			If Not @error Then
				ControlSetText($FormGUI, "", $InputSrcShortRange, $sSrcShortRange)
			EndIf
		Case $BtnSrcFullRange
			$sSrcFullRange = ControlGetText($FormGUI, "", $InputSrcFullRange)
			$sSrcFullRange = FileOpenDialog("Select an image", $MEDIAPIPE_SAMPLES_DATA_PATH, "Image files (*.bmp;*.dlib;*.jpg;*.jpeg;*.png;*.pbm;*.pgm;*.ppm;*.pxm;*.pnm;*.pfm;*.sr;*.ras;*.tiff;*.tif;*.exr;*.hdr;.pic)", $FD_FILEMUSTEXIST, $sSrcFullRange)
			If Not @error Then
				ControlSetText($FormGUI, "", $InputSrcFullRange, $sSrcFullRange)
			EndIf
		Case $BtnExec
			Main()
	EndSwitch
WEnd

Func Main()
	$_cv_gdi_resize = _IsChecked($CheckboxUseGDI)

	; Run MediaPipe Face Detection with short range model.
	RunFaceDetection(0, $InputSrcShortRange, $PicShortRange)

	; Run MediaPipe Face Detection with full range model.
	RunFaceDetection(1, $InputSrcFullRange, $PicFullRange)
EndFunc   ;==>Main

Func RunFaceDetection($model_selection, $controlID, $Picture)
	Local $sImagePath = ControlGetText($FormGUI, "", $controlID)
	Local $image = _OpenCV_imread_and_check($sImagePath)
	If @error Then Return

	; Preview the images.
	_OpenCV_imshow_ControlPic($image, $FormGUI, $Picture)

	Local $mp_face_detection = $mp.solutions.face_detection
	Local $mp_drawing = $mp.solutions.drawing_utils

	; Run MediaPipe Face Detection
	Local $face_detection = $mp_face_detection.FaceDetection(_Mediapipe_Params("min_detection_confidence", 0.5, "model_selection", $model_selection))

	; Convert the BGR image to RGB and process it with MediaPipe Face Detection.
	Local $results = $face_detection.process($cv.cvtColor($image, $CV_COLOR_BGR2RGB))
	If $results("detections") == Default Then
		ConsoleWrite("No face detection for " & $sImagePath & @CRLF)
		_OpenCV_imshow_ControlPic($image, $FormGUI, $Picture)
		Return
	EndIf

	; keep drawings visible after resize
	Local $ratio = _OpenCV_resizeRatio_ControlPic($image, $FormGUI, $Picture)
	Local $thickness = 2 / $ratio
	Local $keypoint_drawing_spec = $mp_drawing.DrawingSpec($mp_drawing.RED_COLOR, $thickness, $thickness)
	Local $bbox_drawing_spec = $mp_drawing.DrawingSpec($mp_drawing.WHITE_COLOR, $thickness, $thickness)

	; Draw face detections of each face.
	For $detection In $results("detections")
		$mp_drawing.draw_detection($image, $detection, $keypoint_drawing_spec, $bbox_drawing_spec)
	Next

	_OpenCV_imshow_ControlPic($image, $FormGUI, $Picture)
EndFunc   ;==>RunFaceDetection

Func _IsChecked($idControlID)
	Return BitAND(GUICtrlRead($idControlID), $GUI_CHECKED) = $GUI_CHECKED
EndFunc   ;==>_IsChecked

Func _OnAutoItExit()
	_OpenCV_Close()
	_Mediapipe_Close()
	_GDIPlus_Shutdown()
EndFunc   ;==>_OnAutoItExit
