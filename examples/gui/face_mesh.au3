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
;~     https://mediapipe.page.link/face_mesh_py_colab

;~ Images:
;~     https://unsplash.com/photos/JyVcAIUAcPM
;~     https://unsplash.com/photos/auTAb39ImXg

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
Global $FormGUI = GUICreate("Face Mesh", 1065, 640, 192, 124)

Global $InputSrcImage = GUICtrlCreateInput($MEDIAPIPE_SAMPLES_DATA_PATH & "\garrett-jackson-auTAb39ImXg-unsplash.jpg", 230, 16, 449, 21)
Global $BtnSrcImage = GUICtrlCreateButton("Browse", 689, 14, 75, 25)

Global $CheckboxUseGDI = GUICtrlCreateCheckbox("Use GDI+", 780, 14, 97, 17)
GUICtrlSetState(-1, $GUI_CHECKED)

Global $BtnExec = GUICtrlCreateButton("Execute", 689, 48, 75, 25)

Global $LabelImage = GUICtrlCreateLabel("Image", 252, 80, 46, 20)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
Global $GroupImage = GUICtrlCreateGroup("", 20, 103, 510, 516)
Global $PicImage = GUICtrlCreatePic("", 25, 114, 500, 500)
GUICtrlCreateGroup("", -99, -99, 1, 1)

Global $LabelResult = GUICtrlCreateLabel("Face mesh", 747, 80, 80, 20)
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

	Local $mp_face_mesh = $mp.solutions.face_mesh
	Local $mp_drawing = $mp.solutions.drawing_utils
	Local $mp_drawing_styles = $mp.solutions.drawing_styles

	; Run MediaPipe Face Mesh
	Local $face_mesh = $mp_face_mesh.FaceMesh(_Mediapipe_Params( _
			"static_image_mode", True, _
			"refine_landmarks", True, _
			"max_num_faces", 2, _
			"min_detection_confidence", 0.5 _
			))

	; Convert the BGR image to RGB and process it with MediaPipe Face Mesh.
	Local $results = $face_mesh.process($cv.cvtColor($image, $CV_COLOR_BGR2RGB))
	If $results("multi_face_landmarks") == Default Then
		ConsoleWrite("No face detection for " & $image_path & @CRLF)
		_OpenCV_imshow_ControlPic($image, $FormGUI, $PicResult)
		Return
	EndIf

	; keep drawings visible after resize
	Local $ratio = _OpenCV_resizeRatio_ControlPic($image, $FormGUI, $PicResult)
	Local $scale = 1 / $ratio

	; enlarge/shrink drawings to keep them visible after resize
	Local $landmark_drawing_spec = $mp_drawing.DrawingSpec($mp_drawing.RED_COLOR)
	$landmark_drawing_spec.thickness *= $scale
	$landmark_drawing_spec.circle_radius *= $scale

	Local $annotated_image = $image.copy()

	; Draw face detections of each face.
	For $face_landmarks In $results("multi_face_landmarks")
		$mp_drawing.draw_landmarks(_Mediapipe_Params( _
				"image", $annotated_image, _
				"landmark_list", $face_landmarks, _
				"connections", $mp_face_mesh.FACEMESH_TESSELATION, _
				"landmark_drawing_spec", $landmark_drawing_spec, _
				"connection_drawing_spec", $mp_drawing_styles.get_default_face_mesh_tesselation_style($scale)))
		$mp_drawing.draw_landmarks(_Mediapipe_Params( _
				"image", $annotated_image, _
				"landmark_list", $face_landmarks, _
				"connections", $mp_face_mesh.FACEMESH_CONTOURS, _
				"landmark_drawing_spec", $landmark_drawing_spec, _
				"connection_drawing_spec", $mp_drawing_styles.get_default_face_mesh_contours_style($scale)))
		$mp_drawing.draw_landmarks(_Mediapipe_Params( _
				"image", $annotated_image, _
				"landmark_list", $face_landmarks, _
				"connections", $mp_face_mesh.FACEMESH_IRISES, _
				"landmark_drawing_spec", $landmark_drawing_spec, _
				"connection_drawing_spec", $mp_drawing_styles.get_default_face_mesh_iris_connections_style($scale)))
	Next

	_OpenCV_imshow_ControlPic($annotated_image, $FormGUI, $PicResult)
EndFunc   ;==>Main

Func _IsChecked($idControlID)
	Return BitAND(GUICtrlRead($idControlID), $GUI_CHECKED) = $GUI_CHECKED
EndFunc   ;==>_IsChecked

Func _OnAutoItExit()
	_OpenCV_Unregister_And_Close()
	_Mediapipe_Unregister_And_Close()
	_GDIPlus_Shutdown()
EndFunc   ;==>_OnAutoItExit
