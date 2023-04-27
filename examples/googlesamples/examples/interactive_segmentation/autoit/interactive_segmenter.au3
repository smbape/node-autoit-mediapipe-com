#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Change2CUI=y
#AutoIt3Wrapper_Au3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#include "..\..\..\..\..\autoit-mediapipe-com\udf\mediapipe_udf_utils.au3"
#include "..\..\..\..\..\autoit-opencv-com\udf\opencv_udf_utils.au3"
#include "..\..\..\..\..\test\_assert.au3"

;~ Sources:
;~     https://colab.research.google.com/github/googlesamples/mediapipe/blob/7d956461efb88e7601de5a4ae55d5a954b093589/examples/interactive_segmentation/python/interactive_segmenter.ipynb
;~     https://github.com/googlesamples/mediapipe/blob/7d956461efb88e7601de5a4ae55d5a954b093589/examples/interactive_segmentation/python/interactive_segmenter.ipynb

_Mediapipe_Open(_Mediapipe_FindDLL("opencv_world470*"), _Mediapipe_FindDLL("autoit_mediapipe_com-*-470*"))
_OpenCV_Open(_OpenCV_FindDLL("opencv_world470*"), _OpenCV_FindDLL("autoit_opencv_com470*"))
OnAutoItExitRegister("_OnAutoItExit")

_Mediapipe_SetResourceDir()

Global Const $MEDIAPIPE_SAMPLES_DATA_PATH = _Mediapipe_FindFile("examples\data")

Global $download_utils = _Mediapipe_ObjCreate("mediapipe.autoit.solutions.download_utils")
_AssertIsObj($download_utils, "Failed to load mediapipe.autoit.solutions.download_utils")

; STEP 1: Import the necessary modules.
Global $mp = _Mediapipe_get()
_AssertIsObj($mp, "Failed to load mediapipe")

Global $cv = _OpenCV_get()
_AssertIsObj($mp, "Failed to load opencv")

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

	Local $_MODEL_FILE = $MEDIAPIPE_SAMPLES_DATA_PATH & "\ptm_512_hdt_ptm_woid.tflite"
	If Not FileExists($_MODEL_FILE) Then
		$download_utils.download("https://storage.googleapis.com/mediapipe-assets/ptm_512_hdt_ptm_woid.tflite?generation=1678323604771164", $_MODEL_FILE)
	EndIf

	Local $x = 0.68 ;@param {type:"slider", min:0, max:1, step:0.01}
	Local $y = 0.68 ;@param {type:"slider", min:0, max:1, step:0.01}

	Local $BG_COLOR = _OpenCV_Scalar(192, 192, 192) ; gray
	Local $FG_COLOR = _OpenCV_Scalar(255, 255, 255) ; white

	Local $OutputType = $vision.ImageSegmenterOptions_OutputType
	Local $RegionOfInterest = $vision.InteractiveSegmenterRegionOfInterest
	Local $RegionOfInterest_Format = $vision.InteractiveSegmenterRegionOfInterest_Format
	Local $NormalizedKeypoint = $containers.keypoint.NormalizedKeypoint

	; Create the options that will be used for InteractiveSegmenter
	Local $base_options = $autoit.BaseOptions(_Mediapipe_Params("model_asset_path", $_MODEL_FILE))
	Local $options = $vision.InteractiveSegmenterOptions(_Mediapipe_Params("base_options", $base_options, _
			"output_type", $OutputType.CATEGORY_MASK))

	; Create the interactive segmenter
	Local $segmenter = $vision.InteractiveSegmenter.create_from_options($options)

	Local $image, $roi, $category_masks, $image_data
	Local $fg_image, $bg_image, $fg_mask
	Local $blurred_image, $output_image
	Local $keypoint_px

	Local $color = _OpenCV_Scalar(255, 255, 0)
	Local $thickness = 10
	Local $radius = 2
	Local $scale

	; Loop through demo image(s)
	For $image_file_name In $IMAGE_FILENAMES
		; Create the MediaPipe image file that will be segmented
		$image = $mp.Image.create_from_file($MEDIAPIPE_SAMPLES_DATA_PATH & "\" & $image_file_name)

		; Compute the point of interest coordinates
		$keypoint_px = _normalized_to_pixel_coordinates($x, $y, $image.width, $image.height)

		; Compute the scale to make drawn elements visible when the image is resized for display
		$scale = 1 / resize_and_show($image.mat_view(), Default, False)

		; Retrieve the masks for the segmented image
		$roi = $RegionOfInterest(_Mediapipe_Params("format", $RegionOfInterest_Format.KEYPOINT, _
				"keypoint", $NormalizedKeypoint($x, $y)))
		$category_masks = $segmenter.segment($image, $roi)

		; Foreground mask corresponds to all i pixels where category_masks[0][i] > 0.2
		$fg_mask = $cv.compare($category_masks[0].mat_view(), 0.2, $CV_CMP_GT)

		; mediapipe deals with RGB images while opencv deals with BGR images
		; covert mediapipe RGB image to opencv BGR image
		$image_data = $cv.cvtColor($image.mat_view(), $CV_COLOR_RGB2BGR)

		; Generate solid color images for showing the output segmentation mask.
		$fg_image = $cv.Mat.create($image_data.size(), $CV_8UC3, $FG_COLOR)
		$bg_image = $cv.Mat.create($image_data.size(), $CV_8UC3, $BG_COLOR)
		$output_image = $bg_image.copy()
		$fg_image.copyTo($fg_mask, $output_image)

		; Draw a circle to denote the point of interest
		$cv.circle($output_image, $keypoint_px, $thickness * $scale, $color, $radius * $scale)

		resize_and_show($output_image, 'Segmentation mask of ' & $image_file_name)

		; Blur the image background based on the segmentation mask.
		$blurred_image = $cv.GaussianBlur($image_data, _OpenCV_Size(55, 55), 0)
		$image_data.copyTo($fg_mask, $blurred_image)

		; Draw a circle to denote the point of interest
		$cv.circle($blurred_image, $keypoint_px, $thickness * $scale, $color, $radius * $scale)

		resize_and_show($blurred_image, 'Blurred background of ' & $image_file_name)
	Next

	$cv.waitKey()
EndFunc   ;==>Main

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
