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
;~     https://colab.research.google.com/github/googlesamples/mediapipe/blob/7d956461efb88e7601de5a4ae55d5a954b093589/examples/text_embedder/python/text_embedder.ipynb
;~     https://github.com/googlesamples/mediapipe/blob/7d956461efb88e7601de5a4ae55d5a954b093589/examples/text_embedder/python/text_embedder.ipynb

_Mediapipe_Open(_Mediapipe_FindDLL("opencv_world470*"), _Mediapipe_FindDLL("autoit_mediapipe_com-*-470*"))
OnAutoItExitRegister("_OnAutoItExit")

_Mediapipe_SetResourceDir()

Global Const $MEDIAPIPE_SAMPLES_DATA_PATH = _Mediapipe_FindFile("examples\data")

Global $download_utils = _Mediapipe_ObjCreate("mediapipe.autoit.solutions.download_utils")
_AssertIsObj($download_utils, "Failed to load mediapipe.autoit.solutions.download_utils")

; STEP 1: Import the necessary modules.
Global $mp = _Mediapipe_get()
_AssertIsObj($mp, "Failed to load mediapipe")

Global $autoit = _Mediapipe_ObjCreate("mediapipe.tasks.autoit")
_AssertIsObj($autoit, "Failed to load mediapipe.tasks.autoit")

Global $text = _Mediapipe_ObjCreate("mediapipe.tasks.autoit.text")
_AssertIsObj($text, "Failed to load mediapipe.tasks.autoit.text")

Global $cosine_similarity = _Mediapipe_ObjCreate("mediapipe.tasks.autoit.components.utils.cosine_similarity")
_AssertIsObj($cosine_similarity, "Failed to load mediapipe.tasks.autoit.components.utils.cosine_similarity")

Main()

Func Main()
	Local $_MODEL_FILE = $MEDIAPIPE_SAMPLES_DATA_PATH & "\mobilebert_embedding_with_metadata.tflite"
	If Not FileExists($_MODEL_FILE) Then
		$download_utils.download("https://storage.googleapis.com/mediapipe-tasks/text_embedder/mobilebert_embedding_with_metadata.tflite", $_MODEL_FILE)
	EndIf

	; Create your base options with the model that was downloaded earlier
	Local $base_options = $autoit.BaseOptions(_Mediapipe_Params("model_asset_path", $_MODEL_FILE))

	; Set your values for using normalization and quantization
	Local $l2_normalize = True ;@param {type:"boolean"}
	Local $quantize = False ;@param {type:"boolean"}

	; Create the final set of options for the Embedder
	Local $options = $text.TextEmbedderOptions(_Mediapipe_Params( _
			"base_options", $base_options, "l2_normalize", $l2_normalize, "quantize", $quantize))

	Local $embedder = $text.TextEmbedder.create_from_options($options)

	; Retrieve the first and second sets of text that will be compared
	Local $first_text = "I'm feeling so good" ;@param {type:"string"}
	Local $second_text = "I'm okay I guess" ;@param {type:"string"}

	; Convert both sets of text to embeddings
	Local $first_embedding_result = $embedder.embed($first_text)
	Local $second_embedding_result = $embedder.embed($second_text)

	; Retrieve the cosine similarity value from both sets of text, then take the
	; cosine of that value to receie a decimal similarity value.
	Local $similarity = $cosine_similarity.cosine_similarity($first_embedding_result.embeddings(0), _
			$second_embedding_result.embeddings(0))
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $similarity = ' & $similarity & @CRLF) ;### Debug Console
EndFunc   ;==>Main

Func _OnAutoItExit()
	_Mediapipe_Close()
EndFunc   ;==>_OnAutoItExit
