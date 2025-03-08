#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Change2CUI=y
#AutoIt3Wrapper_Au3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

;~ Sources:
;~     https://colab.research.google.com/github/google-ai-edge/mediapipe-samples/blob/88792a956f9996c728b92d19ef7fac99cef8a4fe/examples/interactive_segmentation/python/interactive_segmenter.ipynb
;~     https://github.com/google-ai-edge/mediapipe-samples/blob/88792a956f9996c728b92d19ef7fac99cef8a4fe/examples/interactive_segmentation/python/interactive_segmenter.ipynb

#include <GDIPlus.au3>
#include <GUIConstantsEx.au3>
#include "..\..\..\..\..\autoit-mediapipe-com\udf\mediapipe_udf_utils.au3"
#include "..\..\..\..\..\autoit-opencv-com\udf\opencv_udf_utils.au3"

_GDIPlus_Startup()
_Mediapipe_Open(_Mediapipe_FindDLL("opencv_world4110*"), _Mediapipe_FindDLL("autoit_mediapipe_com-*-4110*"))
_OpenCV_Open(_OpenCV_FindDLL("opencv_world4110*"), _OpenCV_FindDLL("autoit_opencv_com4110*"))
OnAutoItExitRegister("_OnAutoItExit")

; Where to download data files
Global Const $MEDIAPIPE_SAMPLES_DATA_PATH = _Mediapipe_FindFile("examples\data")
Global Const $_MODEL_FILE = $MEDIAPIPE_SAMPLES_DATA_PATH & "\magic_touch.tflite"

Setup()

; STEP 1: Import the necessary modules.
Global $mp = _Mediapipe_get()
_AssertIsObj($mp, "Failed to load mediapipe")

Global $cv = _OpenCV_get()
_AssertIsObj($cv, "Failed to load opencv")

Global $autoit = _Mediapipe_ObjCreate("mediapipe.tasks.autoit")
_AssertIsObj($autoit, "Failed to load mediapipe.tasks.autoit")

Global $vision = _Mediapipe_ObjCreate("mediapipe.tasks.autoit.vision")
_AssertIsObj($vision, "Failed to load mediapipe.tasks.autoit.vision")

Global $containers = _Mediapipe_ObjCreate("mediapipe.tasks.autoit.components.containers")
_AssertIsObj($containers, "Failed to load mediapipe.tasks.autoit.components.containers")

#Region ### START Koda GUI section ### Form=
Global $FormGUI = GUICreate("Interactive segmenter", 1570, 640, 192, 124)

Global $InputImage = GUICtrlCreateInput($cv.samples.findFile("cats_and_dogs.jpg"), 230, 16, 449, 21)
Global $BtnImage = GUICtrlCreateButton("Open", 689, 14, 75, 25)

Global $BtnExec = GUICtrlCreateButton("Execute", 689, 48, 75, 25)

Global $LabelBlurring = GUICtrlCreateLabel("Blurring", 246, 80, 58, 20)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
Global $GroupBlurring = GUICtrlCreateGroup("", 20, 103, 510, 516)
Global $PicBlurring = GUICtrlCreatePic("", 25, 114, 500, 500)
GUICtrlCreateGroup("", -99, -99, 1, 1)

Global $LabelSegmentation = GUICtrlCreateLabel("Segmentation", 747, 80, 100, 20)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
Global $GroupSegmentation = GUICtrlCreateGroup("", 532, 103, 510, 516)
Global $PicSegmentation = GUICtrlCreatePic("", 537, 114, 500, 500)
GUICtrlCreateGroup("", -99, -99, 1, 1)

Global $LabelOverlaying = GUICtrlCreateLabel("Overlaying", 1249, 80, 80, 20)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
Global $GroupOverlaying = GUICtrlCreateGroup("", 1044, 103, 510, 516)
Global $PicOverlaying = GUICtrlCreatePic("", 1049, 114, 500, 500)
GUICtrlCreateGroup("", -99, -99, 1, 1)

GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

Global $nMsg
Global $sImage, $aSize

Main()
UpdateCursor()

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			ExitLoop
		Case $GUI_EVENT_MOUSEMOVE
			UpdateCursor()
		Case $BtnImage
			$sImage = ControlGetText($FormGUI, "", $InputImage)
			$sImage = FileOpenDialog("Select an image", $MEDIAPIPE_SAMPLES_DATA_PATH, "Image files (*.bmp;*.dlib;*.jpg;*.jpeg;*.png;*.pbm;*.pgm;*.ppm;*.pxm;*.pnm;*.pfm;*.sr;*.ras;*.tiff;*.tif;*.exr;*.hdr;.pic)", $FD_FILEMUSTEXIST, $sImage)
			If @error Then
				$sImage = ""
			Else
				ControlSetText($FormGUI, "", $InputImage, $sImage)
				Main()
			EndIf
		Case $BtnExec
			Main()
		Case $PicBlurring
			UpdateCursor()
	EndSwitch
WEnd

Func Main($x = 0.68, $y = 0.68)
	$sImage = ControlGetText($FormGUI, "", $InputImage)
	If $sImage == "" Then Return

	Local Static $BG_COLOR = _OpenCV_Scalar(192, 192, 192) ; gray
	Local Static $MASK_COLOR = _OpenCV_Scalar(255, 255, 255) ; white
	Local Static $OVERLAY_COLOR = _OpenCV_Scalar(100, 100, 0) ; cyan

	Local Static $color = _OpenCV_Scalar(255, 255, 0)
	Local Static $thickness = 10
	Local Static $radius = 2

	Local Static $segmenter = GetSegmenter()

	Local Static $RegionOfInterest_Format = $vision.InteractiveSegmenterRegionOfInterest_Format
	Local Static $RegionOfInterest = $vision.InteractiveSegmenterRegionOfInterest
	Local Static $NormalizedKeypoint = $containers.keypoint.NormalizedKeypoint

	; Create the MediaPipe image file that will be segmented
	Local $image = $mp.Image.create_from_file($sImage)

	; Compute the scale to make drawn elements visible when the image is resized for display
	Local $scale = 1 / _OpenCV_resizeRatio_ControlPic($image.mat_view(), $FormGUI, $PicBlurring)

	; mediapipe uses RGB images while opencv uses BGR images
	; Convert the BGR image to RGB
	Local $image_data = $cv.cvtColor($image.mat_view(), $CV_COLOR_RGB2BGR)

	; Retrieve the masks for the segmented image
	Local $roi = $RegionOfInterest(_Mediapipe_Params("format", $RegionOfInterest_Format.KEYPOINT, _
			"keypoint", $NormalizedKeypoint($x, $y)))
	Local $segmentation_result = $segmenter.segment($image, $roi)
	Local $category_mask = $segmentation_result.category_mask

	; Generate solid color images for showing the output segmentation mask.
	Local $fg_image = $cv.Mat.create($image_data.size(), $CV_8UC3, $MASK_COLOR)
	Local $bg_image = $cv.Mat.create($image_data.size(), $CV_8UC3, $BG_COLOR)

	; Foreground mask corresponds to all 'i' pixels where category_mask[i] > 0.1
	Local $fg_mask = $cv.compare($category_mask.mat_view(), 0.1, $CV_CMP_GT)

	; Draw fg_image on bg_image based on the segmentation mask.
	Local $output_image = $bg_image.copy()
	$fg_image.copyTo($fg_mask, $output_image)

	; Compute the point of interest coordinates
	Local $keypoint_px = _normalized_to_pixel_coordinates($x, $y, $image.width, $image.height)

	; Draw a circle to denote the point of interest
	$cv.circle($output_image, $keypoint_px, $thickness * $scale, $color, $radius * $scale)

	; Display the segmented image
	_OpenCV_imshow_ControlPic($output_image, $FormGUI, $PicSegmentation)

	; Blur the image background based on the segmentation mask.
	Local $blurred_image = $cv.GaussianBlur($image_data, _OpenCV_Size(55, 55), 0)
	$image_data.copyTo($fg_mask, $blurred_image)

	; Draw a circle to denote the point of interest
	$cv.circle($blurred_image, $keypoint_px, $thickness * $scale, $color, $radius * $scale)

	; Display the blurred image
	_OpenCV_imshow_ControlPic($blurred_image, $FormGUI, $PicBlurring)

	; Create an overlay image with the desired color (e.g., (255, 0, 0) for red)
	Local $overlayed_image = $cv.Mat.create($image_data.size(), $CV_8UC3, $OVERLAY_COLOR)

	; Create an alpha channel based on the segmentation mask with the desired opacity (e.g., 0.7 for 70%)
	; fg_mask values are 0 where the mask should not apply and 255 where it should
	; multiplying by 0.7 / 255.0 gives values that are 0 where the mask should not apply and 0.7 where it should
	Local $alpha = $fg_mask.convertTo($CV_32F, Null, 0.7 / 255.0)

	; repeat the alpha mask for each image channel color
	$alpha = $cv.merge(_OpenCV_Tuple($alpha, $alpha, $alpha))

	; Blend the original image and the overlay image based on the alpha channel
	$overlayed_image = $cv.add($cv.multiply($image_data, $cv.subtract(1.0, $alpha), Null, Default, $CV_32F), $cv.multiply($overlayed_image, $alpha, Null, Default, $CV_32F))

	; Draw a circle to denote the point of interest
	$cv.circle($overlayed_image, $keypoint_px, $thickness * $scale, $color, $radius * $scale)

	; Display the overlayed image
	_OpenCV_imshow_ControlPic($overlayed_image, $FormGUI, $PicOverlaying)

	; update image size used to determine click coordinates
	$aSize = $image_data.size()
EndFunc   ;==>Main

Func Setup()
	Local $download_utils = _Mediapipe_ObjCreate("mediapipe.autoit.solutions.download_utils")
	_AssertIsObj($download_utils, "Failed to load mediapipe.autoit.solutions.download_utils")

	Local $IMAGE_FILENAMES[] = ['cats_and_dogs.jpg']

	Local $url, $file_path

	For $name In $IMAGE_FILENAMES
		$file_path = $MEDIAPIPE_SAMPLES_DATA_PATH & "\" & $name
		$url = "https://storage.googleapis.com/mediapipe-assets/" & $name
		If Not FileExists($file_path) Then
			$download_utils.download($url, $file_path)
		EndIf
	Next

	If Not FileExists($_MODEL_FILE) Then
		$download_utils.download("https://storage.googleapis.com/mediapipe-models/interactive_segmenter/magic_touch/float32/1/magic_touch.tflite", $_MODEL_FILE)
	EndIf

	Local $cv = _OpenCV_get()
	_AssertIsObj($cv, "Failed to load opencv")

	If FileExists($MEDIAPIPE_SAMPLES_DATA_PATH) Then
		$cv.samples.addSamplesDataSearchPath($MEDIAPIPE_SAMPLES_DATA_PATH)
	EndIf
EndFunc   ;==>Setup

Func GetSegmenter()
	; Create the options that will be used for InteractiveSegmenter
	Local $base_options = $autoit.BaseOptions(_Mediapipe_Params("model_asset_path", $_MODEL_FILE))
	Local $options = $vision.InteractiveSegmenterOptions(_Mediapipe_Params("base_options", $base_options, _
			"output_category_mask", True))

	; Create the interactive segmenter
	Local $segmenter = $vision.InteractiveSegmenter.create_from_options($options)

	Return $segmenter
EndFunc   ;==>GetSegmenter

Func UpdateCursor()
	Local $aCursor = GUIGetCursorInfo()

	If $aCursor[4] <> $PicBlurring Then
		; Arrow cursor
		GUISetCursor(2, $GUI_CURSOR_NOOVERRIDE, $FormGUI)
		Return
	EndIf

	Local $aPicPos = ControlGetPos($FormGUI, "", $PicBlurring)

	Local $aParams = _OpenCV_computeResizeParams($aSize[0], $aSize[1], $aPicPos[2], $aPicPos[3])
	Local $iWidth = $aParams[0]
	Local $iHeight = $aParams[1]
	Local $iPadLeft = $aParams[2]
	Local $iPadTop = $aParams[3]

	Local $iLeft = $aCursor[0] - $aPicPos[0] - $iPadLeft
	Local $iTop = $aCursor[1] - $aPicPos[1] - $iPadTop

	If $iLeft < 0 Or $iTop < 0 Or $iLeft >= $iWidth Or $iTop >= $iHeight Then
		; Arrow cursor
		GUISetCursor(2, $GUI_CURSOR_NOOVERRIDE, $FormGUI)
		Return
	EndIf

	; cross cursor
	GUISetCursor(3, $GUI_CURSOR_OVERRIDE, $FormGUI)

	; If click on image, update roi
	If $aCursor[2] == 1 Then
		Main($iLeft / $iWidth, $iTop / $iHeight)
	EndIf
EndFunc   ;==>UpdateCursor

Func isclose($a, $b)
	Return Abs($a - $b) <= 1E-6
EndFunc   ;==>isclose

; Checks if the float value is between 0 and 1.
Func is_valid_normalized_value($value)
	Return $value >= 0 And $value <= 1 Or isclose(0, $value) Or isclose(1, $value)
EndFunc   ;==>is_valid_normalized_value

#cs
Converts normalized value pair to pixel coordinates.
#ce
Func _normalized_to_pixel_coordinates($normalized_x, $normalized_y, $image_width, $image_height)
	If Not (is_valid_normalized_value($normalized_x) And is_valid_normalized_value($normalized_y)) Then
		; TODO: Draw coordinates even if it's outside of the image bounds.
		Return Default
	EndIf

	Local $x_px = _Min(Floor($normalized_x * $image_width), $image_width - 1)
	Local $y_px = _Min(Floor($normalized_y * $image_height), $image_height - 1)
	Return _OpenCV_Point($x_px, $y_px)
EndFunc   ;==>_normalized_to_pixel_coordinates

Func _OnAutoItExit()
	_OpenCV_Close()
	_Mediapipe_Close()
	_GDIPlus_Shutdown()
EndFunc   ;==>_OnAutoItExit

Func _AssertIsObj($vVal, $sMsg)
	If Not IsObj($vVal) Then
		ConsoleWriteError($sMsg & @CRLF)
		Exit 0x7FFFFFFF
	EndIf
EndFunc   ;==>_AssertIsObj
