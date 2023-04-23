#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Change2CUI=y
#AutoIt3Wrapper_Au3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#include "..\..\..\autoit-mediapipe-com\udf\mediapipe_udf_utils.au3"
#include "..\..\..\autoit-opencv-com\udf\opencv_udf_utils.au3"
#include "..\..\_assert.au3"
#include "..\..\_mat_utils.au3"
#include "..\..\_proto_utils.au3"
#include "..\..\_test_utils.au3"

;~ Sources:
;~     https://github.com/google/mediapipe/blob/v0.9.3.0/mediapipe/tasks/python/test/text/text_classifier_test.py

_Mediapipe_Open(_Mediapipe_FindDLL("opencv_world470*"), _Mediapipe_FindDLL("autoit_mediapipe_com-*-470*"))
_OpenCV_Open(_OpenCV_FindDLL("opencv_world470*"), _OpenCV_FindDLL("autoit_opencv_com470*"))
OnAutoItExitRegister("_OnAutoItExit")

_Mediapipe_SetResourceDir()

Global $download_utils = _Mediapipe_ObjCreate("mediapipe.autoit.solutions.download_utils")
_AssertIsObj($download_utils, "Failed to load mediapipe.autoit.solutions.download_utils")

Global $category = _Mediapipe_ObjCreate("mediapipe.tasks.autoit.components.containers.category")
_AssertIsObj($category)

Global $classification_result_module = _Mediapipe_ObjCreate("mediapipe.tasks.autoit.components.containers.classification_result")
_AssertIsObj($classification_result_module)

Global $base_options_module = _Mediapipe_ObjCreate("mediapipe.tasks.autoit.core.base_options")
_AssertIsObj($base_options_module)

Global $text_classifier = _Mediapipe_ObjCreate("mediapipe.tasks.autoit.text.text_classifier")
_AssertIsObj($text_classifier)

Global $TextClassifierResult = $classification_result_module.ClassificationResult
Global $_BaseOptions = $base_options_module.BaseOptions
Global $_Category = $category.Category
Global $_Classifications = $classification_result_module.Classifications
Global $_TextClassifier = $text_classifier.TextClassifier
Global $_TextClassifierOptions = $text_classifier.TextClassifierOptions

Global $_BERT_MODEL_FILE = 'bert_text_classifier.tflite'
Global $_REGEX_MODEL_FILE = 'test_model_text_classifier_with_regex_tokenizer.tflite'

Global $_NEGATIVE_TEXT = 'What a waste of my time.'
Global $_POSITIVE_TEXT = 'This is the best movie I’ve seen in recent years. Strongly recommend it!'

Global $_BERT_NEGATIVE_RESULTS = $TextClassifierResult(_Mediapipe_Params( _
	"classifications", _Mediapipe_Tuple( _
		$_Classifications(_Mediapipe_Params( _
			"categories", _Mediapipe_Tuple( _
				$_Category(_Mediapipe_Params( _
					"index", 0, _
					"score", 0.999479, _
					"display_name", "", _
					"category_name", "negative")), _
				$_Category(_Mediapipe_Params( _
					"index", 1, _
					"score", 0.00052154, _
					"display_name", "", _
					"category_name", "positive")) _
			), _
			"head_index", 0, _
			"head_name", "probability" _
		)) _
	), _
	"timestamp_ms", 0 _
))

Global $_BERT_POSITIVE_RESULTS = $TextClassifierResult( _Mediapipe_Params( _
	"classifications", _Mediapipe_Tuple( _
		$_Classifications(_Mediapipe_Params( _
			"categories", _Mediapipe_Tuple( _
				$_Category(_Mediapipe_Params( _
					"index", 1, _
					"score", 0.999655962, _
					"display_name", "", _
					"category_name", "positive")), _
				$_Category(_Mediapipe_Params( _
					"index", 0, _
					"score", 0.000344068656, _
					"display_name", "", _
					"category_name", "negative")) _
			), _
			"head_index", 0, _
			"head_name", "probability" _
		)) _
	), _
	"timestamp_ms", 0 _
))

Global $_REGEX_NEGATIVE_RESULTS = $TextClassifierResult( _Mediapipe_Params( _
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

Test()

Func Test()
	Local Const $_TEST_DATA_DIR = _Mediapipe_FindResourceDir() & "\mediapipe\tasks\testdata\text"
	Local $url, $file_path

	Local $test_files[] = [ _
			$_BERT_MODEL_FILE, _
			$_REGEX_MODEL_FILE _
			]
	For $name In $test_files
		$url = "https://storage.googleapis.com/mediapipe-assets/" & $name
		$file_path = $_TEST_DATA_DIR & "\" & $name
		If Not FileExists(get_test_data_path($name)) Then
			$download_utils.download($url, $file_path)
		EndIf
	Next

	$model_path = get_test_data_path($_BERT_MODEL_FILE)

	test_create_from_file_succeeds_with_valid_model_path()
	test_create_from_options_succeeds_with_valid_model_path()
	test_create_from_options_succeeds_with_valid_model_content()

	test_classify($FILE_NAME,    $_BERT_MODEL_FILE,  $_NEGATIVE_TEXT, $_BERT_NEGATIVE_RESULTS)
	test_classify($FILE_CONTENT, $_BERT_MODEL_FILE,  $_NEGATIVE_TEXT, $_BERT_NEGATIVE_RESULTS)
	test_classify($FILE_NAME,    $_BERT_MODEL_FILE,  $_POSITIVE_TEXT, $_BERT_POSITIVE_RESULTS)
	test_classify($FILE_CONTENT, $_BERT_MODEL_FILE,  $_POSITIVE_TEXT, $_BERT_POSITIVE_RESULTS)
	test_classify($FILE_NAME,    $_REGEX_MODEL_FILE, $_NEGATIVE_TEXT, $_REGEX_NEGATIVE_RESULTS)
	test_classify($FILE_CONTENT, $_REGEX_MODEL_FILE, $_NEGATIVE_TEXT, $_REGEX_NEGATIVE_RESULTS)
	test_classify($FILE_NAME,    $_REGEX_MODEL_FILE, $_POSITIVE_TEXT, $_REGEX_POSITIVE_RESULTS)
	test_classify($FILE_CONTENT, $_REGEX_MODEL_FILE, $_POSITIVE_TEXT, $_REGEX_POSITIVE_RESULTS)
EndFunc   ;==>Test

Func test_create_from_file_succeeds_with_valid_model_path()
	; Creates with default option and valid model file successfully.
	Local $classifier = $_TextClassifier.create_from_model_path($model_path)
	_AssertIsObj($classifier)
	$classifier.close()
EndFunc   ;==>test_create_from_file_succeeds_with_valid_model_path

Func test_create_from_options_succeeds_with_valid_model_path()
	; Creates with options containing model file successfully.
	Local $base_options = $_BaseOptions(_Mediapipe_Params("model_asset_path", $model_path))
	Local $options = $_TextClassifierOptions(_Mediapipe_Params("base_options", $base_options))
	Local $classifier = $_TextClassifier.create_from_options($options)
	_AssertIsObj($classifier)
	$classifier.close()
EndFunc   ;==>test_create_from_options_succeeds_with_valid_model_path

Func test_create_from_options_succeeds_with_valid_model_content()
	; Creates with options containing model content successfully.
	Local $model_content = read_binary_to_mat($model_path)
	Local $base_options = $_BaseOptions(_Mediapipe_Params("model_asset_buffer", $model_content))
	Local $options = $_TextClassifierOptions(_Mediapipe_Params("base_options", $base_options))
	Local $classifier = $_TextClassifier.create_from_options($options)
	_AssertIsObj($classifier)
	$classifier.close()
EndFunc   ;==>test_create_from_options_succeeds_with_valid_model_content

Func test_classify($model_file_type, $model_name, $text, $expected_classification_result)
	Local $model_path = get_test_data_path($model_name)
	Local $base_options, $model_content

	; Creates classifier.
	If $model_file_type == $FILE_NAME Then
		$base_options = $_BaseOptions(_Mediapipe_Params("model_asset_path", $model_path))
	ElseIf $model_file_type == $FILE_CONTENT Then
		$model_content = read_binary_to_mat($model_path)
		$base_options = $_BaseOptions(_Mediapipe_Params("model_asset_buffer", $model_content))
	EndIf

	Local $options = $_TextClassifierOptions(_Mediapipe_Params("base_options", $base_options))
	Local $classifier = $_TextClassifier.create_from_options($options)

	; Performs text classification on the input.
	Local $text_result = $classifier.classify($text)

	; Comparing results.
	_AssertProtoEquals($text_result.to_pb2(), $expected_classification_result.to_pb2())

	; Closes the classifier explicitly when the classifier is not used in a context.
	$classifier.close()
EndFunc   ;==>test_classify

Func _OnAutoItExit()
	_OpenCV_Close()
	_Mediapipe_Close()
EndFunc   ;==>_OnAutoItExit
