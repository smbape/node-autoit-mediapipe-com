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
;~     https://colab.research.google.com/github/googlesamples/mediapipe/blob/7d956461efb88e7601de5a4ae55d5a954b093589/examples/text_classification/python/text_classifier.ipynb
;~     https://github.com/googlesamples/mediapipe/blob/7d956461efb88e7601de5a4ae55d5a954b093589/examples/text_classification/python/text_classifier.ipynb

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

Global $text = _Mediapipe_ObjCreate("mediapipe.tasks.autoit.text")
_AssertIsObj($text, "Failed to load mediapipe.tasks.autoit.text")

Main()

Func Main()
	Local $_MODEL_FILE = $MEDIAPIPE_SAMPLES_DATA_PATH & "\bert_text_classifier.tflite"
	If Not FileExists($_MODEL_FILE) Then
		$download_utils.download("https://storage.googleapis.com/mediapipe-tasks/text_classifier/bert_text_classifier.tflite", $_MODEL_FILE)
	EndIf

	; Define the input text that you wants the model to classify.
	Local $INPUT_TEXT = "I'm looking forward to what will come next."

	; STEP 2: Create an TextClassifier object.
	Local $base_options = $autoit.BaseOptions(_Mediapipe_Params("model_asset_path", $_MODEL_FILE))
	Local $options = $text.TextClassifierOptions(_Mediapipe_Params("base_options", $base_options))
	Local $classifier = $text.TextClassifier.create_from_options($options)

	; STEP 3: Classify the input text.
	Local $classification_result = $classifier.classify($INPUT_TEXT)

	; STEP 4: Process the classification result. In this case, print out the most likely category.
	Local $top_category = $classification_result.classifications(0).categories(0)
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : ' & StringFormat('%s (%.2f)', $top_category.category_name, $top_category.score) & @CRLF) ;### Debug Console
EndFunc   ;==>Main

Func _OnAutoItExit()
	_OpenCV_Close()
	_Mediapipe_Close()
EndFunc   ;==>_OnAutoItExit
