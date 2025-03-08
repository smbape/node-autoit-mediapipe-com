#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Change2CUI=y
#AutoIt3Wrapper_Au3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

;~ Sources:
;~     https://github.com/google-ai-edge/mediapipe/blob/v0.10.14/mediapipe/tasks/python/test/text/language_detector_test.py

#include "..\..\..\autoit-mediapipe-com\udf\mediapipe_udf_utils.au3"
#include "..\..\..\autoit-opencv-com\udf\opencv_udf_utils.au3"
#include "..\..\_assert.au3"
#include "..\..\_mat_utils.au3"
#include "..\..\_proto_utils.au3"
#include "..\..\_test_utils.au3"

_Mediapipe_Open(_Mediapipe_FindDLL("opencv_world4110*"), _Mediapipe_FindDLL("autoit_mediapipe_com-*-4110*"))
_OpenCV_Open(_OpenCV_FindDLL("opencv_world4110*"), _OpenCV_FindDLL("autoit_opencv_com4110*"))
OnAutoItExitRegister("_OnAutoItExit")

; Tell mediapipe where to look its resource files
_Mediapipe_SetResourceDir()

Global Const $download_utils = _Mediapipe_ObjCreate("mediapipe.autoit.solutions.download_utils")
_AssertIsObj($download_utils, "Failed to load mediapipe.autoit.solutions.download_utils")

Global Const $category = _Mediapipe_ObjCreate("mediapipe.tasks.autoit.components.containers.category")
_AssertIsObj($category)

Global Const $classification_result_module = _Mediapipe_ObjCreate("mediapipe.tasks.autoit.components.containers.classification_result")
_AssertIsObj($classification_result_module)

Global Const $base_options_module = _Mediapipe_ObjCreate("mediapipe.tasks.autoit.core.base_options")
_AssertIsObj($base_options_module)

Global Const $language_detector = _Mediapipe_ObjCreate("mediapipe.tasks.autoit.text.language_detector")
_AssertIsObj($language_detector)

Global Const $LanguageDetectorResult = $language_detector.LanguageDetectorResult
Global Const $LanguageDetectorPrediction = $language_detector.LanguageDetectorResult.Detection
Global Const $_BaseOptions = $base_options_module.BaseOptions
Global Const $_LanguageDetector = $language_detector.LanguageDetector
Global Const $_LanguageDetectorOptions = $language_detector.LanguageDetectorOptions

Global Const $_LANGUAGE_DETECTOR_MODEL = "language_detector.tflite"
Global Const $_TEST_DATA_DIR = "mediapipe/tasks/testdata/text"

Global Const $_SCORE_THRESHOLD = 0.3
Global Const $_EN_TEXT = "To be, or not to be, that is the question"
Global Const $_EN_EXPECTED_RESULT = $LanguageDetectorResult( _
		_Mediapipe_Tuple($LanguageDetectorPrediction("en", 0.999856)) _
		)
Global Const $_FR_TEXT = "Il y a beaucoup de bouches qui parlent et fort peu de têtes qui pensent."
Global Const $_FR_EXPECTED_RESULT = $LanguageDetectorResult( _
		_Mediapipe_Tuple($LanguageDetectorPrediction("fr", 0.999781)) _
		)
Global Const $_RU_TEXT = "это какой-то английский язык"
Global Const $_RU_EXPECTED_RESULT = $LanguageDetectorResult( _
		_Mediapipe_Tuple($LanguageDetectorPrediction("ru", 0.993362)) _
		)
Global Const $_MIXED_TEXT = "分久必合合久必分"
Global Const $_MIXED_EXPECTED_RESULT = $LanguageDetectorResult(_Mediapipe_Tuple( _
		$LanguageDetectorPrediction("zh", 0.505424), _
		$LanguageDetectorPrediction("ja", 0.481617) _
		))
Global Const $_TOLERANCE = 1E-6

Global Const $FILE_CONTENT = 1
Global Const $FILE_NAME = 2

Global $model_path

Test()

Func Test()
	Local Const $_TEST_DATA_DIR = _Mediapipe_FindResourceDir() & "\mediapipe\tasks\testdata\text"
	Local $url, $file_path

	Local $test_files[] = [ _
			$_LANGUAGE_DETECTOR_MODEL _
			]
	For $name In $test_files
		If IsArray($name) Then
			$url = $name[1]
			$name = $name[0]
		Else
			$url = "https://storage.googleapis.com/mediapipe-assets/" & $name
		EndIf
		If Not FileExists(get_test_data_path($name)) Then
			$file_path = $_TEST_DATA_DIR & "\" & $name
			$download_utils.download($url, $file_path)
		EndIf
	Next

	$model_path = get_test_data_path($_LANGUAGE_DETECTOR_MODEL)

	test_create_from_file_succeeds_with_valid_model_path()
	test_create_from_options_succeeds_with_valid_model_path()
	test_create_from_options_succeeds_with_valid_model_content()

	test_detect($FILE_NAME, $_EN_TEXT, $_EN_EXPECTED_RESULT)
	test_detect($FILE_CONTENT, $_EN_TEXT, $_EN_EXPECTED_RESULT)
	test_detect($FILE_NAME, $_FR_TEXT, $_FR_EXPECTED_RESULT)
	test_detect($FILE_CONTENT, $_FR_TEXT, $_FR_EXPECTED_RESULT)
	test_detect($FILE_NAME, $_RU_TEXT, $_RU_EXPECTED_RESULT)
	test_detect($FILE_CONTENT, $_RU_TEXT, $_RU_EXPECTED_RESULT)
	test_detect($FILE_NAME, $_MIXED_TEXT, $_MIXED_EXPECTED_RESULT)
	test_detect($FILE_CONTENT, $_MIXED_TEXT, $_MIXED_EXPECTED_RESULT)
	test_allowlist_option()
	test_denylist_option()
EndFunc   ;==>Test

Func _expect_language_detector_result_correct($actual_result, $expect_result)
	Local $prediction, $expected_prediction
	_AssertLen($actual_result.detections, $expect_result.detections.size())
	For $i = 0 To $expect_result.detections.size() - 1
		$prediction = $actual_result.detections($i)
		$expected_prediction = $expect_result.detections($i)
		_AssertEqual($prediction.language_code, $expected_prediction.language_code)
		_AssertAlmostEqual($prediction.probability, $expected_prediction.probability, $_TOLERANCE)
	Next
EndFunc   ;==>_expect_language_detector_result_correct

Func test_create_from_file_succeeds_with_valid_model_path()
	; Creates with default option and valid model file successfully.
	Local $detector = $_LanguageDetector.create_from_model_path($model_path)
	_AssertIsInstance($detector, $_LanguageDetector)
EndFunc   ;==>test_create_from_file_succeeds_with_valid_model_path

Func test_create_from_options_succeeds_with_valid_model_path()
	; Creates with options containing model file successfully.
	Local $base_options = $_BaseOptions(_Mediapipe_Params("model_asset_path", $model_path))
	Local $options = $_LanguageDetectorOptions(_Mediapipe_Params("base_options", $base_options))
	Local $detector = $_LanguageDetector.create_from_options($options)
	_AssertIsInstance($detector, $_LanguageDetector)
EndFunc   ;==>test_create_from_options_succeeds_with_valid_model_path

Func test_create_from_options_succeeds_with_valid_model_content()
	; Creates with options containing model content successfully.
	Local $model_content = read_file_into_buffer($model_path)
	Local $base_options = $_BaseOptions(_Mediapipe_Params("model_asset_buffer", $model_content))
	Local $options = $_LanguageDetectorOptions(_Mediapipe_Params("base_options", $base_options))
	Local $detector = $_LanguageDetector.create_from_options($options)
	_AssertIsInstance($detector, $_LanguageDetector)
EndFunc   ;==>test_create_from_options_succeeds_with_valid_model_content

Func test_detect($model_file_type, $text, $expected_result)
	Local $base_options, $model_content

	; Creates detector.
	If $model_file_type == $FILE_NAME Then
		$base_options = $_BaseOptions(_Mediapipe_Params("model_asset_path", $model_path))
	ElseIf $model_file_type == $FILE_CONTENT Then
		$model_content = read_file_into_buffer($model_path)
		$base_options = $_BaseOptions(_Mediapipe_Params("model_asset_buffer", $model_content))
	EndIf

	Local $options = $_LanguageDetectorOptions(_Mediapipe_Params("base_options", $base_options, "score_threshold", $_SCORE_THRESHOLD))
	Local $detector = $_LanguageDetector.create_from_options($options)

	; Performs language detection on the input.
	Local $text_result = $detector.detect($text)

	; Comparing results.
	_expect_language_detector_result_correct($text_result, $expected_result)
EndFunc   ;==>test_detect

Func test_allowlist_option()
	; Creates detector.
	Local $base_options = $_BaseOptions(_Mediapipe_Params("model_asset_path", $model_path))
	Local $options = $_LanguageDetectorOptions(_Mediapipe_Params( _
			"base_options", $base_options, _
			"score_threshold", $_SCORE_THRESHOLD, _
			"category_allowlist", _Mediapipe_Tuple("ja") _
			))
	Local $detector = $_LanguageDetector.create_from_options($options)

	; Performs language detection on the input.
	Local $text_result = $detector.detect($_MIXED_TEXT)

	; Comparing results.
	Local $expected_result = $LanguageDetectorResult( _
			_Mediapipe_Tuple($LanguageDetectorPrediction("ja", 0.481617)) _
			)
	_expect_language_detector_result_correct($text_result, $expected_result)
EndFunc   ;==>test_allowlist_option

Func test_denylist_option()
	; Creates detector.
	Local $base_options = $_BaseOptions(_Mediapipe_Params("model_asset_path", $model_path))
	Local $options = $_LanguageDetectorOptions(_Mediapipe_Params( _
			"base_options", $base_options, _
			"score_threshold", $_SCORE_THRESHOLD, _
			"category_denylist", _Mediapipe_Tuple("ja") _
			))
	Local $detector = $_LanguageDetector.create_from_options($options)

	; Performs language detection on the input.
	Local $text_result = $detector.detect($_MIXED_TEXT)

	; Comparing results.
	Local $expected_result = $LanguageDetectorResult( _
			_Mediapipe_Tuple($LanguageDetectorPrediction("zh", 0.505424)) _
			)
	_expect_language_detector_result_correct($text_result, $expected_result)
EndFunc   ;==>test_denylist_option

Func _OnAutoItExit()
	_OpenCV_Close()
	_Mediapipe_Close()
EndFunc   ;==>_OnAutoItExit
