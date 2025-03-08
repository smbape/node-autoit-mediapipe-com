#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Change2CUI=y
#AutoIt3Wrapper_Au3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

;~ Sources:
;~     https://mediapipe.page.link/objectron_py_colab

;~ Images:
;~     https://unsplash.com/photos/8dukMg99Hd8
;~     https://unsplash.com/photos/PqbL_mxmaUE
;~     https://unsplash.com/photos/7T8vSHYXq4U
;~     https://unsplash.com/photos/WJ7gZ3cilBA
;~     https://unsplash.com/photos/XzL8YAWdirE

#include "..\..\autoit-mediapipe-com\udf\mediapipe_udf_utils.au3"
#include "..\..\autoit-opencv-com\udf\opencv_udf_utils.au3"

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

Example()

Func Example()
	Local Const $image_path = _OpenCV_FindFile("examples\data\aisfaris-jr-8dukMg99Hd8-unsplash.jpg")
	Local $image = _OpenCV_imread_and_check($image_path)
	If @error Then Return

	; Preview the images.
	Local $ratio = resize_and_show("preview", $image)

	; Compute the scale to make drawn elements visible when the image is resized for display
	Local $scale = 1 / $ratio

	Local $mp_objectron = $mp.solutions.objectron
	Local $mp_drawing = $mp.solutions.drawing_utils

	; Run MediaPipe Objectron and draw pose landmarks.
	Local $objectron = $mp_objectron.Objectron(_Mediapipe_Params( _
			"static_image_mode", True, _
			"max_num_objects", 5, _
			"min_detection_confidence", 0.5, _
			"model_name", "Shoe" _
			))

	; Convert the BGR image to RGB and process it with MediaPipe Objectron.
	Local $results = $objectron.process($cv.cvtColor($image, $CV_COLOR_BGR2RGB))

	If $results("detected_objects") == Default Then
		ConsoleWrite("No box landmarks detected on " & $image_path & @CRLF)
		Return
	EndIf

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

	resize_and_show("objectron", $annotated_image)

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

	Local $interpolation = ($DESIRED_WIDTH > $image.width Or $DESIRED_HEIGHT > $image.height) ? $CV_INTER_CUBIC : $CV_INTER_AREA

	Local $img = $cv.resize($image, _OpenCV_Size($w, $h), _OpenCV_Params("interpolation", $interpolation))
	$cv.imshow($title, $img.convertToShow())

	Return $img.width / $image.width
EndFunc   ;==>resize_and_show

Func _OnAutoItExit()
	_OpenCV_Close()
	_Mediapipe_Close()
EndFunc   ;==>_OnAutoItExit
