#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Change2CUI=y
#AutoIt3Wrapper_Au3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

;~ Sources:
;~     https://colab.research.google.com/github/google-ai-edge/mediapipe-samples/blob/8c1d61ad6eb12f1f98ed95c3c8b64cb9801f3230/examples/image_classification/python/image_classifier.ipynb
;~     https://github.com/google-ai-edge/mediapipe-samples/blob/8c1d61ad6eb12f1f98ed95c3c8b64cb9801f3230/examples/image_classification/python/image_classifier.ipynb

;~ Title: Image Classifier with MediaPipe Tasks

#include "..\..\..\..\..\autoit-mediapipe-com\udf\mediapipe_udf_utils.au3"
#include "..\..\..\..\..\autoit-opencv-com\udf\opencv_udf_utils.au3"

_Mediapipe_Open(_Mediapipe_FindDLL("opencv_world4110*"), _Mediapipe_FindDLL("autoit_mediapipe_com-*-4110*"))
_OpenCV_Open(_OpenCV_FindDLL("opencv_world4110*"), _OpenCV_FindDLL("autoit_opencv_com4110*"))
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

Main()

Func Main()
	Local $IMAGE_FILENAMES[] = ['burger.jpg', 'cat.jpg']

	Local $url, $file_path

	For $name In $IMAGE_FILENAMES
		$file_path = $MEDIAPIPE_SAMPLES_DATA_PATH & "\" & $name
		$url = "https://storage.googleapis.com/mediapipe-tasks/image_classifier/" & $name
		If Not FileExists($file_path) Then
			$download_utils.download($url, $file_path)
		EndIf
	Next

	Local $_MODEL_FILE = $MEDIAPIPE_SAMPLES_DATA_PATH & "\efficientnet_lite0.tflite"
	If Not FileExists($_MODEL_FILE) Then
		$download_utils.download("https://storage.googleapis.com/mediapipe-models/image_classifier/efficientnet_lite0/float32/1/efficientnet_lite0.tflite", $_MODEL_FILE)
	EndIf

	; STEP 2: Create an ImageClassifier object.
	Local $base_options = $autoit.BaseOptions(_Mediapipe_Params("model_asset_path", $_MODEL_FILE))
	Local $options = $vision.ImageClassifierOptions(_Mediapipe_Params("base_options", $base_options, "max_results", 4))
	Local $classifier = $vision.ImageClassifier.create_from_options($options)
	Local $image, $classification_result, $top_category, $title

	For $image_name In $IMAGE_FILENAMES
		; STEP 3: Load the input image.
		$image = $mp.Image.create_from_file($MEDIAPIPE_SAMPLES_DATA_PATH & "\" & $image_name)

		; STEP 4: Classify the input image.
		$classification_result = $classifier.classify($image)

		; STEP 5: Process the classification result. In this case, visualize it.
		$top_category = $classification_result.classifications(0).categories(0)
		$title = StringFormat("%s (%.2f)", $top_category.category_name, $top_category.score)
		resize_and_show($cv.cvtColor($image.mat_view(), $CV_COLOR_RGB2BGR), $title)
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

Func _AssertIsObj($vVal, $sMsg)
	If Not IsObj($vVal) Then
		ConsoleWriteError($sMsg & @CRLF)
		Exit 0x7FFFFFFF
	EndIf
EndFunc   ;==>_AssertIsObj
