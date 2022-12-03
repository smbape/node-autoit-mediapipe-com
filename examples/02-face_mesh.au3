#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Change2CUI=y
#AutoIt3Wrapper_Au3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#include "..\autoit-mediapipe-com\udf\mediapipe_udf_utils.au3"
#include "..\autoit-opencv-com\udf\opencv_udf_utils.au3"

;~ Sources:
;~     https://mediapipe.page.link/face_mesh_py_colab

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
	Local Const $image_path = _OpenCV_FindFile("examples\data\garrett-jackson-auTAb39ImXg-unsplash.jpg")
	Local $image = _OpenCV_imread_and_check($image_path)
	If @error Then Return

	; Preview the images.
	Local $ratio = resize_and_show("preview", $image)
	Local $scale = 1 / $ratio

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

	Local $results = $face_mesh.process($cv.cvtColor($image, $CV_COLOR_BGR2RGB))
	If $results("multi_face_landmarks") == Default Then
		ConsoleWrite("No face detection for " & $image_path & @CRLF)
		Return
	EndIf

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

	resize_and_show("face mesh", $annotated_image)

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
