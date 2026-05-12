#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Change2CUI=y
#AutoIt3Wrapper_Au3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

;~ Sources:
;~     https://github.com/google-ai-edge/mediapipe/blob/v0.10.35/mediapipe/tasks/python/test/text/text_classifier_test.py

#include "..\..\..\autoit-mediapipe-com\udf\mediapipe_udf_utils.au3"
#include "..\..\_assert.au3"
#include "..\..\_test_utils.au3"

_Mediapipe_Open(_Mediapipe_FindDLL("opencv_world4130*"), _Mediapipe_FindDLL("autoit_mediapipe_com-*-4130*"))
OnAutoItExitRegister("_OnAutoItExit")

Global Const $download_utils = _Mediapipe_ObjCreate("mediapipe.tasks.autoit.core.download_utils")
_AssertIsObj($download_utils, "Failed to load mediapipe.tasks.autoit.core.download_utils")

Global Const $category = _Mediapipe_ObjCreate("mediapipe.tasks.autoit.components.containers.category")
_AssertIsObj($category)

Global Const $classification_result_module = _Mediapipe_ObjCreate("mediapipe.tasks.autoit.components.containers.classification_result")
_AssertIsObj($classification_result_module)

Global Const $base_options_module = _Mediapipe_ObjCreate("mediapipe.tasks.autoit.core.base_options")
_AssertIsObj($base_options_module)

Global Const $text_classifier = _Mediapipe_ObjCreate("mediapipe.tasks.autoit.text.text_classifier")
_AssertIsObj($text_classifier)

Global Const $TextClassifierResult = $classification_result_module.ClassificationResult
Global Const $_BaseOptions = $base_options_module.BaseOptions
Global Const $_Category = $category.Category
Global Const $_Classifications = $classification_result_module.Classifications
Global Const $_TextClassifier = $text_classifier.TextClassifier
Global Const $_TextClassifierOptions = $text_classifier.TextClassifierOptions

Global Const $_BERT_MODEL_FILE = 'bert_text_classifier.tflite'
Global Const $_REGEX_MODEL_FILE = 'test_model_text_classifier_with_regex_tokenizer.tflite'

Global Const $_NEGATIVE_TEXT = 'What a waste of my time.'
Global Const $_POSITIVE_TEXT = 'This is the best movie I’ve seen in recent years. Strongly recommend it!'

Global Const $_BERT_NEGATIVE_RESULTS = $TextClassifierResult(_Mediapipe_Params( _
		"classifications", _Mediapipe_Tuple( _
		$_Classifications(_Mediapipe_Params( _
		"categories", _Mediapipe_Tuple( _
		$_Category(_Mediapipe_Params( _
		"index", 0, _
		"score", 0.9995, _
		"display_name", "", _
		"category_name", "negative")), _
		$_Category(_Mediapipe_Params( _
		"index", 1, _
		"score", 0.0005, _
		"display_name", "", _
		"category_name", "positive")) _
		), _
		"head_index", 0, _
		"head_name", "probability" _
		)) _
		), _
		"timestamp_ms", 0 _
		))

Global Const $_BERT_POSITIVE_RESULTS = $TextClassifierResult( _Mediapipe_Params( _
		"classifications", _Mediapipe_Tuple( _
		$_Classifications(_Mediapipe_Params( _
		"categories", _Mediapipe_Tuple( _
		$_Category(_Mediapipe_Params( _
		"index", 1, _
		"score", 0.9995, _
		"display_name", "", _
		"category_name", "positive")), _
		$_Category(_Mediapipe_Params( _
		"index", 0, _
		"score", 0.0005, _
		"display_name", "", _
		"category_name", "negative")) _
		), _
		"head_index", 0, _
		"head_name", "probability" _
		)) _
		), _
		"timestamp_ms", 0 _
		))

Global Const $_REGEX_NEGATIVE_RESULTS = $TextClassifierResult( _Mediapipe_Params( _
		"classifications", _Mediapipe_Tuple( _
		$_Classifications(_Mediapipe_Params( _
		"categories", _Mediapipe_Tuple( _
		$_Category(_Mediapipe_Params( _
		"index", 0, _
		"score", 0.81313, _
		"display_name", "", _
		"category_name", "Negative")), _
		$_Category(_Mediapipe_Params( _
		"index", 1, _
		"score", 0.1868704, _
		"display_name", "", _
		"category_name", "Positive")) _
		), _
		"head_index", 0, _
		"head_name", "probability" _
		)) _
		), _
		"timestamp_ms", 0 _
		))

Global $_REGEX_POSITIVE_RESULTS = $TextClassifierResult( _Mediapipe_Params( _
		"classifications", _Mediapipe_Tuple( _
		$_Classifications(_Mediapipe_Params( _
		"categories", _Mediapipe_Tuple( _
		$_Category(_Mediapipe_Params( _
		"index", 1, _
		"score", 0.5134273, _
		"display_name", "", _
		"category_name", "Positive")), _
		$_Category(_Mediapipe_Params( _
		"index", 0, _
		"score", 0.486573, _
		"display_name", "", _
		"category_name", "Negative")) _
		), _
		"head_index", 0, _
		"head_name", "probability" _
		)) _
		), _
		"timestamp_ms", 0 _
		))

Global Const $FILE_CONTENT = 1
Global Const $FILE_NAME = 2

Global $model_path


TextClassifierTest()


Func TextClassifierTest()
	TextClassifierTest_setUp()

	test_create_from_file_succeeds_with_valid_model_path()
	test_create_from_options_succeeds_with_valid_model_path()
	test_create_from_options_succeeds_with_valid_model_content()
	test_create_from_options_succeeds_with_allow_list()
	test_create_from_options_succeeds_with_deny_list()
	test_create_from_options_succeeds_with_display_names_locale()

	test_classify($FILE_NAME, $_BERT_MODEL_FILE, $_NEGATIVE_TEXT, $_BERT_NEGATIVE_RESULTS)
	test_classify($FILE_CONTENT, $_BERT_MODEL_FILE, $_NEGATIVE_TEXT, $_BERT_NEGATIVE_RESULTS)
	test_classify($FILE_NAME, $_BERT_MODEL_FILE, $_POSITIVE_TEXT, $_BERT_POSITIVE_RESULTS)
	test_classify($FILE_CONTENT, $_BERT_MODEL_FILE, $_POSITIVE_TEXT, $_BERT_POSITIVE_RESULTS)
	test_classify($FILE_NAME, $_REGEX_MODEL_FILE, $_NEGATIVE_TEXT, $_REGEX_NEGATIVE_RESULTS)
	test_classify($FILE_CONTENT, $_REGEX_MODEL_FILE, $_NEGATIVE_TEXT, $_REGEX_NEGATIVE_RESULTS)
	test_classify($FILE_NAME, $_REGEX_MODEL_FILE, $_POSITIVE_TEXT, $_REGEX_POSITIVE_RESULTS)
	test_classify($FILE_CONTENT, $_REGEX_MODEL_FILE, $_POSITIVE_TEXT, $_REGEX_POSITIVE_RESULTS)
EndFunc   ;==>TextClassifierTest


Func TextClassifierTest_setUp()
	Local Const $_TEST_DATA_DIR = _Mediapipe_FindResourceDir() & "\mediapipe\tasks\testdata\text"
	Local $url, $file_path

	Local $test_files[] = [ _
			$_BERT_MODEL_FILE, _
			$_REGEX_MODEL_FILE _
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

	$model_path = get_test_data_path($_BERT_MODEL_FILE)
EndFunc   ;==>TextClassifierTest_setUp

Func _AssertTextClassifierResultEquals($result, $expected_result)
	Local $actual_classification, $expected_classification, $actual_category, $expected_category

	_AssertEqual($result.timestamp_ms, $expected_result.timestamp_ms)
	_AssertLen($result.classifications, $expected_result.classifications.size())

	For $i = 0 To $expected_result.classifications.size() - 1
		$actual_classification = $result.classifications($i)
		$expected_classification = $expected_result.classifications($i)
		_AssertEqual($actual_classification.head_index, $expected_classification.head_index)
		_AssertEqual($actual_classification.head_name, $expected_classification.head_name)
		_AssertLen( _
				$actual_classification.categories, _
				$expected_classification.categories.size() _
				)
		For $j = 0 To $expected_classification.categories.size() - 1
			$actual_category = $actual_classification.categories($j)
			$expected_category = $expected_classification.categories($j)
			_AssertEqual($actual_category.index, $expected_category.index)
			_AssertEqual($actual_category.display_name == Default ? '' : $actual_category.display_name, $expected_category.display_name)
			_AssertEqual($actual_category.category_name, $expected_category.category_name)
			_AssertAlmostEqual($actual_category.score, $expected_category.score, 1E-4)
		Next
	Next
EndFunc   ;==>_AssertTextClassifierResultEquals


Func test_create_from_file_succeeds_with_valid_model_path()
	ConsoleWrite('"' & @ScriptFullPath & '" @@ Debug(' & @ScriptLineNumber & ') : test_create_from_file_succeeds_with_valid_model_path' & @CRLF) ;### Debug Console

	; Creates with default option and valid model file successfully.
	Local $classifier = $_TextClassifier.create_from_model_path($model_path)
	_AssertIsInstance($classifier, $_TextClassifier)
EndFunc   ;==>test_create_from_file_succeeds_with_valid_model_path

Func test_create_from_options_succeeds_with_valid_model_path()
	ConsoleWrite('"' & @ScriptFullPath & '" @@ Debug(' & @ScriptLineNumber & ') : test_create_from_options_succeeds_with_valid_model_path' & @CRLF) ;### Debug Console

	; Creates with options containing model file successfully.
	Local $base_options = $_BaseOptions(_Mediapipe_Params("model_asset_path", $model_path))
	Local $options = $_TextClassifierOptions(_Mediapipe_Params("base_options", $base_options))
	Local $classifier = $_TextClassifier.create_from_options($options)
	_AssertIsInstance($classifier, $_TextClassifier)
EndFunc   ;==>test_create_from_options_succeeds_with_valid_model_path

Func test_create_from_options_succeeds_with_valid_model_content()
	ConsoleWrite('"' & @ScriptFullPath & '" @@ Debug(' & @ScriptLineNumber & ') : test_create_from_options_succeeds_with_valid_model_content' & @CRLF) ;### Debug Console

	; Creates with options containing model content successfully.
	Local $model_content = read_file_into_buffer($model_path)
	Local $base_options = $_BaseOptions(_Mediapipe_Params("model_asset_buffer", $model_content))
	Local $options = $_TextClassifierOptions(_Mediapipe_Params("base_options", $base_options))
	Local $classifier = $_TextClassifier.create_from_options($options)
	_AssertIsInstance($classifier, $_TextClassifier)
EndFunc   ;==>test_create_from_options_succeeds_with_valid_model_content

Func test_create_from_options_succeeds_with_allow_list()
	ConsoleWrite('"' & @ScriptFullPath & '" @@ Debug(' & @ScriptLineNumber & ') : test_create_from_options_succeeds_with_allow_list' & @CRLF) ;### Debug Console

	Local $base_options = $_BaseOptions(_Mediapipe_Params("model_asset_path", $model_path))
	Local $options = $_TextClassifierOptions(_Mediapipe_Params( _
			"base_options", $base_options, "category_allowlist", _Mediapipe_Tuple('positive') _
			))
	Local $classifier = $_TextClassifier.create_from_options($options)
	_AssertIsInstance($classifier, $_TextClassifier)
EndFunc   ;==>test_create_from_options_succeeds_with_allow_list

Func test_create_from_options_succeeds_with_deny_list()
	ConsoleWrite('"' & @ScriptFullPath & '" @@ Debug(' & @ScriptLineNumber & ') : test_create_from_options_succeeds_with_deny_list' & @CRLF) ;### Debug Console

	Local $base_options = $_BaseOptions(_Mediapipe_Params("model_asset_path", $model_path))
	Local $options = $_TextClassifierOptions(_Mediapipe_Params( _
			"base_options", $base_options, "category_denylist", _Mediapipe_Tuple('negative') _
			))
	Local $classifier = $_TextClassifier.create_from_options($options)
	_AssertIsInstance($classifier, $_TextClassifier)
EndFunc   ;==>test_create_from_options_succeeds_with_deny_list

Func test_create_from_options_succeeds_with_display_names_locale()
	ConsoleWrite('"' & @ScriptFullPath & '" @@ Debug(' & @ScriptLineNumber & ') : test_create_from_options_succeeds_with_display_names_locale' & @CRLF) ;### Debug Console

	Local $base_options = $_BaseOptions(_Mediapipe_Params("model_asset_path", $model_path))
	Local $options = $_TextClassifierOptions(_Mediapipe_Params( _
			"base_options", $base_options, "display_names_locale", 'en' _
			))
	Local $classifier = $_TextClassifier.create_from_options($options)
	_AssertIsInstance($classifier, $_TextClassifier)
EndFunc   ;==>test_create_from_options_succeeds_with_display_names_locale

Func test_classify($model_file_type, $model_name, $text, $expected_classification_result)
	ConsoleWrite('"' & @ScriptFullPath & '" @@ Debug(' & @ScriptLineNumber & ') : test_classify' & @CRLF) ;### Debug Console

	Local $model_path = get_test_data_path($model_name)
	Local $base_options, $model_content

	; Creates classifier.
	If $model_file_type == $FILE_NAME Then
		$base_options = $_BaseOptions(_Mediapipe_Params("model_asset_path", $model_path))
	ElseIf $model_file_type == $FILE_CONTENT Then
		$model_content = read_file_into_buffer($model_path)
		$base_options = $_BaseOptions(_Mediapipe_Params("model_asset_buffer", $model_content))
	EndIf

	Local $options = $_TextClassifierOptions(_Mediapipe_Params("base_options", $base_options))
	Local $classifier = $_TextClassifier.create_from_options($options)

	; Performs text classification on the input.
	Local $text_result = $classifier.classify($text)

	; Comparing results.
	_AssertTextClassifierResultEquals($text_result, $expected_classification_result)
EndFunc   ;==>test_classify


Func _OnAutoItExit()
	_Mediapipe_Close()
EndFunc   ;==>_OnAutoItExit
