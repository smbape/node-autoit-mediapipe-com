#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Change2CUI=y
#AutoIt3Wrapper_Au3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

;~ Sources:
;~     https://colab.research.google.com/github/google-ai-edge/mediapipe-samples/blob/88792a956f9996c728b92d19ef7fac99cef8a4fe/examples/interactive_segmentation/python/interactive_segmenter.ipynb
;~     https://github.com/google-ai-edge/mediapipe-samples/blob/88792a956f9996c728b92d19ef7fac99cef8a4fe/examples/interactive_segmentation/python/interactive_segmenter.ipynb

;~ Title: Interactive Image Segmenter

#include "..\..\..\..\..\autoit-mediapipe-com\udf\mediapipe_udf_utils.au3"
#include "..\..\..\..\..\autoit-opencv-com\udf\opencv_udf_utils.au3"

_Mediapipe_Open(_Mediapipe_FindDLL("opencv_world4100*"), _Mediapipe_FindDLL("autoit_mediapipe_com-*-4100*"))
_OpenCV_Open(_OpenCV_FindDLL("opencv_world4100*"), _OpenCV_FindDLL("autoit_opencv_com4100*"))
OnAutoItExitRegister("_OnAutoItExit")

; Tell mediapipe where to look its resource files
_Mediapipe_SetResourceDir()

; Where to download data files
Global Const $MEDIAPIPE_SAMPLES_DATA_PATH = _Mediapipe_FindFile("examples\data")

Global $download_utils = _Mediapipe_ObjCreate("mediapipe.autoit.solutions.download_utils")
_AssertIsObj($download_utils, "Failed to load mediapipe.autoit.solutions.download_utils")

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

Main()

Func Main()
	Local $IMAGE_FILENAMES[] = ['cats_and_dogs.jpg']

	Local $url, $file_path

	For $name In $IMAGE_FILENAMES
		$file_path = $MEDIAPIPE_SAMPLES_DATA_PATH & "\" & $name
		$url = "https://storage.googleapis.com/mediapipe-assets/" & $name
		If Not FileExists($file_path) Then
			$download_utils.download($url, $file_path)
		EndIf
	Next

	Local $_MODEL_FILE = $MEDIAPIPE_SAMPLES_DATA_PATH & "\magic_touch.tflite"
	If Not FileExists($_MODEL_FILE) Then
		$download_utils.download("https://storage.googleapis.com/mediapipe-models/interactive_segmenter/magic_touch/float32/1/magic_touch.tflite", $_MODEL_FILE)
	EndIf

	Local $x = 0.68 ;@param {type:"slider", min:0, max:1, step:0.01}
	Local $y = 0.68 ;@param {type:"slider", min:0, max:1, step:0.01}

	Local $BG_COLOR = _OpenCV_Scalar(192, 192, 192) ; gray
	Local $MASK_COLOR = _OpenCV_Scalar(255, 255, 255) ; white
	Local $OVERLAY_COLOR = _OpenCV_Scalar(100, 100, 0) ; cyan

	Local $RegionOfInterest_Format = $vision.InteractiveSegmenterRegionOfInterest_Format
	Local $RegionOfInterest = $vision.InteractiveSegmenterRegionOfInterest
	Local $NormalizedKeypoint = $containers.keypoint.NormalizedKeypoint

	; Create the options that will be used for InteractiveSegmenter
	Local $base_options = $autoit.BaseOptions(_Mediapipe_Params("model_asset_path", $_MODEL_FILE))
	Local $options = $vision.InteractiveSegmenterOptions(_Mediapipe_Params("base_options", $base_options, _
			"output_category_mask", True))

	; Create the interactive segmenter
	Local $segmenter = $vision.InteractiveSegmenter.create_from_options($options)

	Local $image, $roi, $segmentation_result, $category_mask, $image_data
	Local $fg_image, $bg_image, $fg_mask
	Local $output_image, $blurred_image, $overlayed_image
	Local $keypoint_px, $alpha

	Local $color = _OpenCV_Scalar(255, 255, 0)
	Local $thickness = 10
	Local $radius = 2
	Local $scale

	; Loop through demo image(s)
	For $image_file_name In $IMAGE_FILENAMES
		; Create the MediaPipe image file that will be segmented
		$image = $mp.Image.create_from_file($MEDIAPIPE_SAMPLES_DATA_PATH & "\" & $image_file_name)

		; Compute the scale to make drawn elements visible when the image is resized for display
		$scale = 1 / resize_and_show($image.mat_view(), Default, False)

		; mediapipe uses RGB images while opencv uses BGR images
		; Convert the BGR image to RGB
		$image_data = $cv.cvtColor($image.mat_view(), $CV_COLOR_RGB2BGR)

		; Retrieve the masks for the segmented image
		$roi = $RegionOfInterest(_Mediapipe_Params("format", $RegionOfInterest_Format.KEYPOINT, _
				"keypoint", $NormalizedKeypoint($x, $y)))
		$segmentation_result = $segmenter.segment($image, $roi)
		$category_mask = $segmentation_result.category_mask

		; Generate solid color images for showing the output segmentation mask.
		$fg_image = $cv.Mat.create($image_data.size(), $CV_8UC3, $MASK_COLOR)
		$bg_image = $cv.Mat.create($image_data.size(), $CV_8UC3, $BG_COLOR)

		; Foreground mask corresponds to all 'i' pixels where category_mask[i] > 0.1
		$fg_mask = $cv.compare($category_mask.mat_view(), 0.1, $CV_CMP_GT)

		; Draw fg_image on bg_image based on the segmentation mask.
		$output_image = $bg_image.copy()
		$fg_image.copyTo($fg_mask, $output_image)

		; Compute the point of interest coordinates
		$keypoint_px = _normalized_to_pixel_coordinates($x, $y, $image.width, $image.height)

		; Draw a circle to denote the point of interest
		$cv.circle($output_image, $keypoint_px, $thickness * $scale, $color, $radius * $scale)

		; Display the segmented image
		resize_and_show($output_image, 'Segmentation mask of ' & $image_file_name)

		; Blur the image background based on the segmentation mask.
		$blurred_image = $cv.GaussianBlur($image_data, _OpenCV_Size(55, 55), 0)
		$image_data.copyTo($fg_mask, $blurred_image)

		; Draw a circle to denote the point of interest
		$cv.circle($blurred_image, $keypoint_px, $thickness * $scale, $color, $radius * $scale)

		; Display the blurred image
		resize_and_show($blurred_image, 'Blurred background of ' & $image_file_name)

		; Create an overlay image with the desired color (e.g., (255, 0, 0) for red)
		$overlayed_image = $cv.Mat.create($image_data.size(), $CV_8UC3, $OVERLAY_COLOR)

		; Create an alpha channel based on the segmentation mask with the desired opacity (e.g., 0.7 for 70%)
		; fg_mask values are 0 where the mask should not apply and 255 where it should
		; multiplying by 0.7 / 255.0 gives values that are 0 where the mask should not apply and 0.7 where it should
		$alpha = $fg_mask.convertTo($CV_32F, Null, 0.7 / 255.0)

		; repeat the alpha mask for each image channel color
		$alpha = $cv.merge(_OpenCV_Tuple($alpha, $alpha, $alpha))

		; Blend the original image and the overlay image based on the alpha channel
		$overlayed_image = $cv.add($cv.multiply($image_data, $cv.subtract(1.0, $alpha), Null, Default, $CV_32F), $cv.multiply($overlayed_image, $alpha, Null, Default, $CV_32F))

		; Draw a circle to denote the point of interest
		$cv.circle($overlayed_image, $keypoint_px, $thickness * $scale, $color, $radius * $scale)

		; Display the overlayed image
		resize_and_show($overlayed_image, 'Overlayed foreground of ' & $image_file_name)
	Next

	$cv.waitKey()

	; Closes the segmenter explicitly when the segmenter is not used ina context.
	$segmenter.close()
EndFunc   ;==>Main

Func isclose($a, $b)
	Return Abs($a - $b) <= 1E-6
EndFunc   ;==>isclose

; Checks if the float value is between 0 and 1.
Func is_valid_normalized_value($value)
	Return ($value > 0 Or isclose(0, $value)) And ($value < 1 Or isclose(1, $value))
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

Func resize_and_show($image, $title = Default, $show = Default)
	If $title == Default Then $title = ""
	If $show == Default Then $show = True

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

	If $show Then
		Local $img = $cv.resize($image, _OpenCV_Size($w, $h), _OpenCV_Params("interpolation", $interpolation))
		$cv.imshow($title, $img.convertToShow())
	EndIf

	Return $w / $image.width
EndFunc   ;==>resize_and_show

Func _OnAutoItExit()
	_OpenCV_Close()
	_Mediapipe_Close()
EndFunc   ;==>_OnAutoItExit

Func _AssertIsObj($vVal, $sMsg)
	If Not IsObj($vVal) Then
		ConsoleWriteError($sMsg & @CRLF)
		Exit 0x7FFFFFFF
	EndIf
EndFunc   ;==>_AssertIsObj
