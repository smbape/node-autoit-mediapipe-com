#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Change2CUI=y
#AutoIt3Wrapper_Au3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#include "..\..\autoit-mediapipe-com\udf\mediapipe_udf_utils.au3"
#include "..\..\autoit-opencv-com\udf\opencv_udf_utils.au3"

;~ Sources:
;~     https://mediapipe.page.link/selfie_segmentation_py_colab

;~ Images:
;~     https://unsplash.com/photos/oB1mqkdDiU0
;~     https://unsplash.com/photos/fU3EJRO_qGY

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

Example()

Func Example()
	Local Const $image_path = _OpenCV_FindFile("examples\data\ilya-mirnyy-fU3EJRO_qGY-unsplash.jpg")
	Local $image = _OpenCV_imread_and_check($image_path)
	If @error Then Return

	; Preview the images.
	resize_and_show("preview", $image)

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
		Return
	EndIf

	; Generate solid color images for showing the output selfie segmentation mask.
	Local $fg_image = _OpenCV_ObjCreate("Mat").create($image.size(), $CV_8UC3, $MASK_COLOR)
	Local $bg_image = _OpenCV_ObjCreate("Mat").create($image.size(), $CV_8UC3, $BG_COLOR)

	Local $segmentation_mask = $cv.compare($results("segmentation_mask"), 0.2, $CV_CMP_GT)

	Local $output_image = $bg_image.copy()
	$fg_image.copyTo($segmentation_mask, $output_image)

	resize_and_show("Segmentation mask", $output_image)

	; Blur the image background based on the segmentation mask.
	Local $blurred_image = $cv.GaussianBlur($image, _OpenCV_Size(55, 55), 0)
	$image.copyTo($segmentation_mask, $blurred_image)

	resize_and_show("Blurred background", $blurred_image)

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
	_OpenCV_Unregister_And_Close()
	_Mediapipe_Unregister_And_Close()
EndFunc   ;==>_OnAutoItExit
