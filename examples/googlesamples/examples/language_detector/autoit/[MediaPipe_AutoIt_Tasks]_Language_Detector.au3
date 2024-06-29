#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Change2CUI=y
#AutoIt3Wrapper_Au3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

;~ Sources:
;~     https://colab.research.google.com/github/google-ai-edge/mediapipe-samples/blob/88792a956f9996c728b92d19ef7fac99cef8a4fe/examples/language_detector/python/[MediaPipe_Python_Tasks]_Language_Detector.ipynb
;~     https://github.com/google-ai-edge/mediapipe-samples/blob/88792a956f9996c728b92d19ef7fac99cef8a4fe/examples/language_detector/python/[MediaPipe_Python_Tasks]_Language_Detector.ipynb

;~ Title: Language Detector with MediaPipe Tasks

#include "..\..\..\..\..\autoit-mediapipe-com\udf\mediapipe_udf_utils.au3"
#include "..\..\..\..\..\autoit-opencv-com\udf\opencv_udf_utils.au3"

_Mediapipe_Open(_Mediapipe_FindDLL("opencv_world4100*"), _Mediapipe_FindDLL("autoit_mediapipe_com-*-4100*"))
OnAutoItExitRegister("_OnAutoItExit")

; Tell mediapipe where to look its resource files
_Mediapipe_SetResourceDir()

; Where to download data files
Global Const $MEDIAPIPE_SAMPLES_DATA_PATH = _Mediapipe_FindFile("examples\data")

; STEP 1: Import the necessary modules.
Global $download_utils = _Mediapipe_ObjCreate("mediapipe.autoit.solutions.download_utils")
_AssertIsObj($download_utils, "Failed to load mediapipe.autoit.solutions.download_utils")

Global $autoit = _Mediapipe_ObjCreate("mediapipe.tasks.autoit")
_AssertIsObj($autoit, "Failed to load mediapipe.tasks.autoit")

Global $text = _Mediapipe_ObjCreate("mediapipe.tasks.autoit.text")
_AssertIsObj($text, "Failed to load mediapipe.tasks.autoit.text")

Main()

Func Main()
	Local $_MODEL_FILE = $MEDIAPIPE_SAMPLES_DATA_PATH & "\language_detector.tflite"
	Local $_MODEL_URL = "https://storage.googleapis.com/mediapipe-models/language_detector/language_detector/float32/latest/language_detector.tflite"

	Local $url, $file_path

	Local $sample_files[] = [ _
			_Mediapipe_Tuple($_MODEL_FILE, $_MODEL_URL) _
			]
	For $config In $sample_files
		$file_path = $config[0]
		$url = $config[1]
		If Not FileExists($file_path) Then
			$download_utils.download($url, $file_path)
		EndIf
	Next

	; Define the input text that you wants the model to classify.
	Local $INPUT_TEXT = "分久必合合久必分" ;@param {type:"string"}

	; STEP 2: Create a LanguageDetector object.
	Local $base_options = $autoit.BaseOptions(_Mediapipe_Params("model_asset_path", $_MODEL_FILE))
	Local $options = $text.LanguageDetectorOptions(_Mediapipe_Params("base_options", $base_options))
	Local $detector = $text.LanguageDetector.create_from_options($options)

	; STEP 3: Get the language detcetion result for the input text.
	Local $detection_result = $detector.detect($INPUT_TEXT)

	; STEP 4: Process the detection result and print the languages detected and their scores.
	For $detection In $detection_result.detections
		ConsoleWrite(StringFormat("%s: (%.2f)", $detection.language_code, $detection.probability) & @CRLF)
	Next

	; STEP 5: Closes the detector explicitly when the detector is not used ina context.
	$detector.close()
EndFunc   ;==>Main

Func _OnAutoItExit()
	_Mediapipe_Close()
EndFunc   ;==>_OnAutoItExit

Func _AssertIsObj($vVal, $sMsg)
	If Not IsObj($vVal) Then
		ConsoleWriteError($sMsg & @CRLF)
		Exit 0x7FFFFFFF
	EndIf
EndFunc   ;==>_AssertIsObj
