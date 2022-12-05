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
;~     https://mediapipe.page.link/hands_py_colab

;~ Images:
;~     https://unsplash.com/photos/QyCH5jwrD_A
;~     https://unsplash.com/photos/mt2fyrdXxzk

_GDIPlus_Startup()
_Mediapipe_Open_And_Register(_Mediapipe_FindDLL("opencv_world4*", "opencv-4.*\opencv"), _Mediapipe_FindDLL("autoit_mediapipe_com-*"))
_OpenCV_Open_And_Register(_OpenCV_FindDLL("opencv_world4*", "opencv-4.*\opencv"), _OpenCV_FindDLL("autoit_opencv_com4*"))
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
Global $FormGUI = GUICreate("Hands", 1065, 640, 192, 124)

Global $InputSrcImage = GUICtrlCreateInput($MEDIAPIPE_SAMPLES_DATA_PATH & "\brooke-cagle-mt2fyrdXxzk-unsplash.jpg", 230, 16, 449, 21)
Global $BtnSrcImage = GUICtrlCreateButton("Browse", 689, 14, 75, 25)

Global $CheckboxUseGDI = GUICtrlCreateCheckbox("Use GDI+", 780, 14, 97, 17)
GUICtrlSetState(-1, $GUI_CHECKED)

Global $BtnExec = GUICtrlCreateButton("Execute", 689, 48, 75, 25)

Global $LabelImage = GUICtrlCreateLabel("Image", 252, 80, 46, 20)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
Global $GroupImage = GUICtrlCreateGroup("", 20, 103, 510, 516)
Global $PicImage = GUICtrlCreatePic("", 25, 114, 500, 500)
GUICtrlCreateGroup("", -99, -99, 1, 1)

Global $LabelResult = GUICtrlCreateLabel("Hands", 747, 80, 80, 20)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
Global $GroupResult = GUICtrlCreateGroup("", 532, 103, 510, 516)
Global $PicResult = GUICtrlCreatePic("", 537, 114, 500, 500)
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

	Local $mp_hands = $mp.solutions.hands
	Local $mp_drawing = $mp.solutions.drawing_utils
	Local $mp_drawing_styles = $mp.solutions.drawing_styles

	; Run MediaPipe Hands
	Local $hands = $mp_hands.Hands(_Mediapipe_Params( _
			"static_image_mode", True, _
			"max_num_hands", 2, _
			"min_detection_confidence", 0.7 _
			))

	; Convert the BGR image to RGB, flip the image around y-axis for correct
	; handedness output and process it with MediaPipe Hands.
	Local $results = $hands.process($cv.flip($cv.cvtColor($image, $CV_COLOR_BGR2RGB), 1))

	If $results("multi_hand_landmarks") == Default Then
		ConsoleWrite("No hand detection for " & $image_path & @CRLF)
		_OpenCV_imshow_ControlPic($image, $FormGUI, $PicResult)
		Return
	EndIf

	ConsoleWrite("Handedness of " & $image_path & @CRLF)
	For $classificationList In $results("multi_handedness")
		For $classification In $classificationList.classification
			ConsoleWrite($classification.__str__() & @CRLF)
		Next
	Next

	; keep drawings visible after resize
	Local $ratio = _OpenCV_resizeRatio_ControlPic($image, $FormGUI, $PicResult)
	Local $scale = 1 / $ratio

	; Draw hand landmarks of each hand.
	ConsoleWrite('Hand landmarks of ' & $image_path & ':' & @CRLF)
	Local $image_width = $image.width
	Local $image_height = $image.height
	Local $annotated_image = $cv.flip($image.copy(), 1)

	; Draw face detections of each face.
	For $hand_landmarks In $results("multi_hand_landmarks")
		; Print index finger tip coordinates.
		ConsoleWrite( _
				'Index finger tip coordinate: (' & _
				$hand_landmarks.landmark($mp_hands.HandLandmark.INDEX_FINGER_TIP).x * $image_width & ', ' & _
				$hand_landmarks.landmark($mp_hands.HandLandmark.INDEX_FINGER_TIP).y * $image_height & ')' & _
				@CRLF _
				)
		$mp_drawing.draw_landmarks( _
				$annotated_image, _
				$hand_landmarks, _
				$mp_hands.HAND_CONNECTIONS, _
				$mp_drawing_styles.get_default_hand_landmarks_style($scale), _
				$mp_drawing_styles.get_default_hand_connections_style($scale))
	Next

	_OpenCV_imshow_ControlPic($cv.flip($annotated_image, 1), $FormGUI, $PicResult)
EndFunc   ;==>Main

Func _IsChecked($idControlID)
	Return BitAND(GUICtrlRead($idControlID), $GUI_CHECKED) = $GUI_CHECKED
EndFunc   ;==>_IsChecked

Func _OnAutoItExit()
	_OpenCV_Unregister_And_Close()
	_Mediapipe_Unregister_And_Close()
	_GDIPlus_Shutdown()
EndFunc   ;==>_OnAutoItExit
