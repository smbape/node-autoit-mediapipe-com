#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Change2CUI=y
#AutoIt3Wrapper_Au3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

;~ Sources:
;~     https://github.com/google-ai-edge/mediapipe/blob/v0.10.21/mediapipe/tasks/python/test/text/text_embedder_test.py

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

Global Const $embedding_result_module = _Mediapipe_ObjCreate("mediapipe.tasks.autoit.components.containers.embedding_result")
_AssertIsObj($embedding_result_module)

Global Const $base_options_module = _Mediapipe_ObjCreate("mediapipe.tasks.autoit.core.base_options")
_AssertIsObj($base_options_module)

Global Const $text_embedder = _Mediapipe_ObjCreate("mediapipe.tasks.autoit.text.text_embedder")
_AssertIsObj($text_embedder)

Global Const $_BaseOptions = $base_options_module.BaseOptions
Global Const $_TextEmbedder = $text_embedder.TextEmbedder
Global Const $_TextEmbedderOptions = $text_embedder.TextEmbedderOptions

Global Const $_BERT_MODEL_FILE = 'mobilebert_embedding_with_metadata.tflite'
Global Const $_REGEX_MODEL_FILE = 'regex_one_embedding_with_metadata.tflite'
Global Const $_USE_MODEL_FILE = 'universal_sentence_encoder_qa_with_metadata.tflite'
; Tolerance for embedding vector coordinate values.
Global Const $_EPSILON = 1E-4
; Tolerance for cosine similarity evaluation.
Global Const $_SIMILARITY_TOLERANCE = 1E-3

Global Const $FILE_CONTENT = 1
Global Const $FILE_NAME = 2

Global $model_path

Test()

Func Test()
	Local Const $_TEST_DATA_DIR = _Mediapipe_FindResourceDir() & "\mediapipe\tasks\testdata\text"
	Local $url, $file_path

	Local $test_files[] = [ _
			$_BERT_MODEL_FILE, _
			$_REGEX_MODEL_FILE, _
			$_USE_MODEL_FILE _
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

	test_create_from_file_succeeds_with_valid_model_path()
	test_create_from_options_succeeds_with_valid_model_path()
	test_create_from_options_succeeds_with_valid_model_content()

	test_embed( _
			False, _
			False, _
			$_BERT_MODEL_FILE, _
			$FILE_NAME, _
			0.962427, _
			512, _
			_Mediapipe_Tuple(21.2054, 19.684337) _
			)
	test_embed( _
			True, _
			False, _
			$_BERT_MODEL_FILE, _
			$FILE_NAME, _
			0.962427, _
			512, _
			_Mediapipe_Tuple(0.0625787, 0.0673937) _
			)
	test_embed( _
			False, _
			False, _
			$_REGEX_MODEL_FILE, _
			$FILE_NAME, _
			0.999937, _
			16, _
			_Mediapipe_Tuple(0.0309356, 0.0312863) _
			)
	test_embed( _
			True, _
			False, _
			$_REGEX_MODEL_FILE, _
			$FILE_CONTENT, _
			0.999937, _
			16, _
			_Mediapipe_Tuple(0.549632, 0.552879) _
			)
	test_embed( _
			False, _
			False, _
			$_USE_MODEL_FILE, _
			$FILE_NAME, _
			0.851961, _
			100, _
			_Mediapipe_Tuple(1.422951, 1.404664) _
			)
	test_embed( _
			True, _
			False, _
			$_USE_MODEL_FILE, _
			$FILE_CONTENT, _
			0.851961, _
			100, _
			_Mediapipe_Tuple(0.127049, 0.125416) _
			)
EndFunc   ;==>Test

Func test_create_from_file_succeeds_with_valid_model_path()
	; Creates with default option and valid model file successfully.
	Local $embedder = $_TextEmbedder.create_from_model_path($model_path)
	_AssertIsInstance($embedder, $_TextEmbedder)
EndFunc   ;==>test_create_from_file_succeeds_with_valid_model_path

Func test_create_from_options_succeeds_with_valid_model_path()
	; Creates with options containing model file successfully.
	Local $base_options = $_BaseOptions(_Mediapipe_Params("model_asset_path", $model_path))
	Local $options = $_TextEmbedderOptions(_Mediapipe_Params("base_options", $base_options))
	Local $embedder = $_TextEmbedder.create_from_options($options)
	_AssertIsInstance($embedder, $_TextEmbedder)
EndFunc   ;==>test_create_from_options_succeeds_with_valid_model_path

Func test_create_from_options_succeeds_with_valid_model_content()
	; Creates with options containing model content successfully.
	Local $model_content = read_file_into_buffer($model_path)
	Local $base_options = $_BaseOptions(_Mediapipe_Params("model_asset_buffer", $model_content))
	Local $options = $_TextEmbedderOptions(_Mediapipe_Params("base_options", $base_options))
	Local $embedder = $_TextEmbedder.create_from_options($options)
	_AssertIsInstance($embedder, $_TextEmbedder)
EndFunc   ;==>test_create_from_options_succeeds_with_valid_model_content

Func test_embed($l2_normalize, $quantize, $model_name, $model_file_type, _
		$expected_similarity, $expected_size, $expected_first_values)
	Local $model_path = get_test_data_path($model_name)
	Local $base_options, $model_content

	; Creates embedder.
	If $model_file_type == $FILE_NAME Then
		$base_options = $_BaseOptions(_Mediapipe_Params("model_asset_path", $model_path))
	ElseIf $model_file_type == $FILE_CONTENT Then
		$model_content = read_file_into_buffer($model_path)
		$base_options = $_BaseOptions(_Mediapipe_Params("model_asset_buffer", $model_content))
	EndIf

	Local $options = $_TextEmbedderOptions(_Mediapipe_Params("base_options", $base_options, "l2_normalize", $l2_normalize, "quantize", $quantize))
	Local $embedder = $_TextEmbedder.create_from_options($options)

	; Extracts both embeddings.
	Local $positive_text0 = "it's a charming and often affecting journey"
	Local $positive_text1 = 'what a great and fantastic trip'

	Local $result0 = $embedder.embed($positive_text0)
	Local $result1 = $embedder.embed($positive_text1)

	; Checks embeddings and cosine similarity.
	Local $expected_result0_value = $expected_first_values[0]
	Local $expected_result1_value = $expected_first_values[1]
	_check_embedding_size($result0, $quantize, $expected_size)
	_check_embedding_size($result1, $quantize, $expected_size)
	_check_embedding_value($result0, $expected_result0_value)
	_check_embedding_value($result1, $expected_result1_value)
	_check_cosine_similarity($result0, $result1, $expected_similarity)
EndFunc   ;==>test_embed

Func _check_embedding_value($result, $expected_first_value, $iLine = @ScriptLineNumber)
	; Check embedding first value.
	_AssertAlmostEqual($result.embeddings(0).embedding(0), $expected_first_value, $_EPSILON, Default, Default, Default, Default, $iLine)
EndFunc   ;==>_check_embedding_value

Func _check_embedding_size($result, $quantize, $expected_embedding_size)
	; Check embedding size.
	_AssertLen($result.embeddings, 1)
	Local $embedding_result = $result.embeddings(0)
	_AssertEqual($embedding_result.embedding.total(), $expected_embedding_size)
	If $quantize Then
		_AssertEqual($embedding_result.embedding.depth(), $CV_8U)
	Else
		_AssertEqual($embedding_result.embedding.depth(), $CV_32F)
	EndIf
EndFunc   ;==>_check_embedding_size

Func _check_cosine_similarity($result0, $result1, $expected_similarity, $iLine = @ScriptLineNumber)
	; Checks cosine similarity.
	Local $similarity = $_TextEmbedder.cosine_similarity($result0.embeddings(0), $result1.embeddings(0))
	_AssertAlmostEqual($similarity, $expected_similarity, $_SIMILARITY_TOLERANCE, Default, Default, Default, Default, $iLine)
EndFunc   ;==>_check_cosine_similarity

Func _OnAutoItExit()
	_OpenCV_Close()
	_Mediapipe_Close()
EndFunc   ;==>_OnAutoItExit
