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
;~     https://colab.research.google.com/github/googlesamples/mediapipe/blob/7d956461efb88e7601de5a4ae55d5a954b093589/examples/image_segmentation/python/image_segmentation.ipynb
;~     https://github.com/googlesamples/mediapipe/blob/7d956461efb88e7601de5a4ae55d5a954b093589/examples/image_segmentation/python/image_segmentation.ipynb

_Mediapipe_Open(_Mediapipe_FindDLL("opencv_world470*"), _Mediapipe_FindDLL("autoit_mediapipe_com-*-470*"))
_OpenCV_Open(_OpenCV_FindDLL("opencv_world470*"), _OpenCV_FindDLL("autoit_opencv_com470*"))
OnAutoItExitRegister("_OnAutoItExit")

_Mediapipe_SetResourceDir()

Global Const $MEDIAPIPE_SAMPLES_DATA_PATH = _OpenCV_FindFile("examples\data")

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

Main()

Func Main()
	Local $IMAGE_FILENAMES[] = ['segmentation_input_rotation0.jpg']

	Local $url, $file_path

	For $name In $IMAGE_FILENAMES
		$file_path = $MEDIAPIPE_SAMPLES_DATA_PATH & "\" & $name
		$url = "https://storage.googleapis.com/mediapipe-assets/" & $name
		If Not FileExists($file_path) Then
			$download_utils.download($url, $file_path)
		EndIf
	Next

	Local $_MODEL_FILE = $MEDIAPIPE_SAMPLES_DATA_PATH & "\deeplabv3.tflite"
	If Not FileExists($_MODEL_FILE) Then
		$download_utils.download("https://storage.googleapis.com/mediapipe-assets/deeplabv3.tflite", $_MODEL_FILE)
	EndIf

	Local $BG_COLOR = _OpenCV_Scalar(192, 192, 192) ; gray
	Local $FG_COLOR = _OpenCV_Scalar(255, 255, 255) ; white

	Local $OutputType = $vision.ImageSegmenterOptions_OutputType
	; Local $Activation = $vision.ImageSegmenterOptions_Activation

	; Create the options that will be used for ImageSegmenter
	Local $base_options = $autoit.BaseOptions(_Mediapipe_Params("model_asset_path", $_MODEL_FILE))
	Local $options = $vision.ImageSegmenterOptions(_Mediapipe_Params("base_options", $base_options, _
			"output_type", $OutputType.CATEGORY_MASK))

	Local $segmenter = $vision.ImageSegmenter.create_from_options($options)
	Local $image, $category_masks, $image_data, $fg_image, $bg_image, $fg_mask, $blurred_image, $output_image

	; Loop through demo image(s)
	For $image_file_name In $IMAGE_FILENAMES
		; Create the MediaPipe image file that will be segmented
		$image = $mp.Image.create_from_file($MEDIAPIPE_SAMPLES_DATA_PATH & "\" & $image_file_name)

		; Retrieve the masks for the segmented image
		$category_masks = $segmenter.segment($image)

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
		resize_and_show($output_image, 'Segmentation mask of ' & $image_file_name)

		; Blur the image background based on the segmentation mask.
		$blurred_image = $cv.GaussianBlur($image_data, _OpenCV_Size(55, 55), 0)
		$image_data.copyTo($fg_mask, $blurred_image)
		resize_and_show($blurred_image, 'Blurred background of ' & $image_file_name)
	Next

	$cv.waitKey()
EndFunc   ;==>Main

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
