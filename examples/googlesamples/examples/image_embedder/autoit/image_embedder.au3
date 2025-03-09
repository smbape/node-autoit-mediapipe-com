#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Change2CUI=y
#AutoIt3Wrapper_Au3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

;~ Sources:
;~     https://colab.research.google.com/github/google-ai-edge/mediapipe-samples/blob/8c1d61ad6eb12f1f98ed95c3c8b64cb9801f3230/examples/image_embedder/python/image_embedder.ipynb
;~     https://github.com/google-ai-edge/mediapipe-samples/blob/8c1d61ad6eb12f1f98ed95c3c8b64cb9801f3230/examples/image_embedder/python/image_embedder.ipynb

;~ Title: Image Embedding with MediaPipe Tasks

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

Global $cosine_similarity = _Mediapipe_ObjCreate("mediapipe.tasks.autoit.components.utils.cosine_similarity")
_AssertIsObj($cosine_similarity, "Failed to load mediapipe.tasks.autoit.components.utils.cosine_similarity")

Main()

Func Main()
	Local $IMAGE_FILENAMES[] = ['burger.jpg', 'burger_crop.jpg']

	Local $url, $file_path

	For $name In $IMAGE_FILENAMES
		$file_path = $MEDIAPIPE_SAMPLES_DATA_PATH & "\" & $name
		$url = "https://storage.googleapis.com/mediapipe-assets/" & $name
		If Not FileExists($file_path) Then
			$download_utils.download($url, $file_path)
		EndIf
	Next

	Local $_MODEL_FILE = $MEDIAPIPE_SAMPLES_DATA_PATH & "\mobilenet_v3_small.tflite"
	If Not FileExists($_MODEL_FILE) Then
		$download_utils.download("https://storage.googleapis.com/mediapipe-models/image_embedder/mobilenet_v3_small/float32/1/mobilenet_v3_small.tflite", $_MODEL_FILE)
	EndIf

	; Create options for Image Embedder
	Local $base_options = $autoit.BaseOptions(_Mediapipe_Params("model_asset_path", $_MODEL_FILE))
	Local $l2_normalize = True ;@param {type:"boolean"}
	Local $quantize = True ;@param {type:"boolean"}
	Local $options = $vision.ImageEmbedderOptions(_Mediapipe_Params( _
			"base_options", $base_options, _
			"l2_normalize", $l2_normalize, _
			"quantize", $quantize))

	; Create Image Embedder
	Local $embedder = $vision.ImageEmbedder.create_from_options($options)

	; Format images for MediaPipe
	Local $first_image = $mp.Image.create_from_file($MEDIAPIPE_SAMPLES_DATA_PATH & "\" & $IMAGE_FILENAMES[0])
	Local $second_image = $mp.Image.create_from_file($MEDIAPIPE_SAMPLES_DATA_PATH & "\" & $IMAGE_FILENAMES[1])
	Local $first_embedding_result = $embedder.embed($first_image)
	Local $second_embedding_result = $embedder.embed($second_image)

	Local $similarity = $cosine_similarity.cosine_similarity($first_embedding_result.embeddings(0), $second_embedding_result.embeddings(0))
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $similarity = ' & $similarity & @CRLF) ;### Debug Console

	resize_and_show($cv.cvtColor($first_image.mat_view(), $CV_COLOR_RGB2BGR), $IMAGE_FILENAMES[0])
	resize_and_show($cv.cvtColor($second_image.mat_view(), $CV_COLOR_RGB2BGR), $IMAGE_FILENAMES[1])
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
