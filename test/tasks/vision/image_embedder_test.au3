#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Change2CUI=y
#AutoIt3Wrapper_Au3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

;~ Sources:
;~     https://github.com/google-ai-edge/mediapipe/blob/v0.10.14/mediapipe/tasks/python/test/vision/image_embedder_test.py

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

Global Const $image_module = _Mediapipe_ObjCreate("mediapipe.autoit._framework_bindings.image")
_AssertIsObj($image_module, "Failed to load mediapipe.autoit._framework_bindings.image")

Global Const $embedding_result_module = _Mediapipe_ObjCreate("mediapipe.tasks.autoit.components.containers.embedding_result")
_AssertIsObj($embedding_result_module, "Failed to load mediapipe.tasks.autoit.components.containers.embedding_result")

Global Const $rect = _Mediapipe_ObjCreate("mediapipe.tasks.autoit.components.containers.rect")
_AssertIsObj($rect, "Failed to load mediapipe.tasks.autoit.components.containers.rect")

Global Const $base_options_module = _Mediapipe_ObjCreate("mediapipe.tasks.autoit.core.base_options")
_AssertIsObj($base_options_module, "Failed to load mediapipe.tasks.autoit.core.base_options")

Global Const $image_embedder = _Mediapipe_ObjCreate("mediapipe.tasks.autoit.vision.image_embedder")
_AssertIsObj($image_embedder, "Failed to load mediapipe.tasks.autoit.vision.image_embedder")

Global Const $image_processing_options_module = _Mediapipe_ObjCreate("mediapipe.tasks.autoit.vision.core.image_processing_options")
_AssertIsObj($image_processing_options_module, "Failed to load mediapipe.tasks.autoit.vision.core.image_processing_options")

Global Const $running_mode_module = _Mediapipe_ObjCreate("mediapipe.tasks.autoit.vision.core.vision_task_running_mode")
_AssertIsObj($running_mode_module, "Failed to load mediapipe.tasks.autoit.vision.core.vision_task_running_mode")


Global Const $_Rect = $rect.Rect
Global Const $_BaseOptions = $base_options_module.BaseOptions
Global Const $_Image = $image_module.Image
Global Const $_ImageEmbedder = $image_embedder.ImageEmbedder
Global Const $_ImageEmbedderOptions = $image_embedder.ImageEmbedderOptions
Global Const $_ImageEmbedderResult = $image_embedder.ImageEmbedderResult
Global Const $_RUNNING_MODE = $running_mode_module.VisionTaskRunningMode
Global Const $_ImageProcessingOptions = $image_processing_options_module.ImageProcessingOptions

Global Const $_MODEL_FILE = 'mobilenet_v3_small_100_224_embedder.tflite'
Global Const $_BURGER_IMAGE_FILE = 'burger.jpg'
Global Const $_BURGER_CROPPED_IMAGE_FILE = 'burger_crop.jpg'

; Tolerance for embedding vector coordinate values.
Global Const $_EPSILON = 1E-4
; Tolerance for cosine similarity evaluation.
Global Const $_SIMILARITY_TOLERANCE = 1E-6

Global Const $FILE_CONTENT = 1
Global Const $FILE_NAME = 2

Global $test_image
Global $test_cropped_image
Global $model_path

Test()

Func Test()
	Local Const $_TEST_DATA_DIR = _Mediapipe_FindResourceDir() & "\mediapipe\tasks\testdata\vision"
	Local $url, $file_path

	Local $test_files[] = [ _
			$_MODEL_FILE, _
			$_BURGER_IMAGE_FILE, _
			$_BURGER_CROPPED_IMAGE_FILE _
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

	$test_image = $_Image.create_from_file(get_test_data_path($_BURGER_IMAGE_FILE))
	$test_cropped_image = $_Image.create_from_file(get_test_data_path($_BURGER_CROPPED_IMAGE_FILE))
	$model_path = get_test_data_path($_MODEL_FILE)

	test_create_from_file_succeeds_with_valid_model_path()
	test_create_from_options_succeeds_with_valid_model_path()
	test_create_from_options_succeeds_with_valid_model_content()

	test_embed(False, False, False, $FILE_NAME, 0.925519, 1024, _Mediapipe_Tuple(-0.2101883, -0.193027))
	test_embed(False, False, False, $FILE_CONTENT, 0.925519, 1024, _Mediapipe_Tuple(-0.2101883, -0.193027))
	test_embed(True, False, False, $FILE_NAME, 0.925519, 1024, _Mediapipe_Tuple(-0.0142344, -0.0131606))
	test_embed(True, False, False, $FILE_CONTENT, 0.925519, 1024, _Mediapipe_Tuple(-0.0142344, -0.0131606))
	test_embed(False, False, True, $FILE_NAME, 0.999931, 1024, _Mediapipe_Tuple(-0.195062, -0.193027))
	test_embed(False, False, True, $FILE_CONTENT, 0.999931, 1024, _Mediapipe_Tuple(-0.195062, -0.193027))

	test_embed_for_video()
	test_embed_for_video_succeeds_with_region_of_interest()
EndFunc   ;==>Test

Func test_create_from_file_succeeds_with_valid_model_path()
	; Creates with default option and valid model file successfully.
	Local $embedder = $_ImageEmbedder.create_from_model_path($model_path)
	_AssertIsInstance($embedder, $_ImageEmbedder)
EndFunc   ;==>test_create_from_file_succeeds_with_valid_model_path

Func test_create_from_options_succeeds_with_valid_model_path()
	; Creates with options containing model file successfully.
	Local $base_options = $_BaseOptions(_Mediapipe_Params("model_asset_path", $model_path))
	Local $options = $_ImageEmbedderOptions(_Mediapipe_Params("base_options", $base_options))
	Local $embedder = $_ImageEmbedder.create_from_options($options)
	_AssertIsInstance($embedder, $_ImageEmbedder)
EndFunc   ;==>test_create_from_options_succeeds_with_valid_model_path

Func test_create_from_options_succeeds_with_valid_model_content()
	; Creates with options containing model content successfully.
	Local $model_content = read_file_into_buffer($model_path)
	Local $base_options = $_BaseOptions(_Mediapipe_Params("model_asset_buffer", $model_content))
	Local $options = $_ImageEmbedderOptions(_Mediapipe_Params("base_options", $base_options))
	Local $embedder = $_ImageEmbedder.create_from_options($options)
	_AssertIsInstance($embedder, $_ImageEmbedder)
EndFunc   ;==>test_create_from_options_succeeds_with_valid_model_content

Func test_embed($l2_normalize, $quantize, $with_roi, $model_file_type, $expected_similarity, $expected_size, $expected_first_values)
	Local $base_options, $model_content

	; Creates embedder.
	If $model_file_type == $FILE_NAME Then
		$base_options = $_BaseOptions(_Mediapipe_Params("model_asset_path", $model_path))
	ElseIf $model_file_type == $FILE_CONTENT Then
		$model_content = read_file_into_buffer($model_path)
		$base_options = $_BaseOptions(_Mediapipe_Params("model_asset_buffer", $model_content))
	EndIf

	Local $options = $_ImageEmbedderOptions(_Mediapipe_Params( _
			"base_options", $base_options, _
			"l2_normalize", $l2_normalize, _
			"quantize", $quantize))
	Local $embedder = $_ImageEmbedder.create_from_options($options)

	Local $image_processing_options = Default
	If $with_roi Then
		; Region-of-interest in "burger.jpg" corresponding to "burger_crop.jpg".
		Local $roi = $_Rect(_Mediapipe_Params("left", 0, "top", 0, "right", 0.833333, "bottom", 1))
		$image_processing_options = $_ImageProcessingOptions($roi)
	EndIf

	; Extracts both embeddings.
	Local $image_result = $embedder.embed($test_image, $image_processing_options)
	Local $crop_result = $embedder.embed($test_cropped_image)

	; Checks embeddings and cosine similarity.
	Local $expected_result0_value = $expected_first_values[0]
	Local $expected_result1_value = $expected_first_values[1]
	_check_embedding_size($image_result, $quantize, $expected_size)
	_check_embedding_size($crop_result, $quantize, $expected_size)
	_check_embedding_value($image_result, $expected_result0_value)
	_check_embedding_value($crop_result, $expected_result1_value)
	_check_cosine_similarity($image_result, $crop_result, $expected_similarity)
EndFunc   ;==>test_embed

Func test_embed_for_video()
	Local $options = $_ImageEmbedderOptions(_Mediapipe_Params( _
			"base_options", $_BaseOptions(_Mediapipe_Params("model_asset_path", $model_path)), _
			"running_mode", $_RUNNING_MODE.VIDEO))

	Local $embedder0 = $_ImageEmbedder.create_from_options($options)
	Local $embedder1 = $_ImageEmbedder.create_from_options($options)

	Local Const $expected_similarity = 0.925519
	Local $image_result, $crop_result
	For $timestamp = 0 To (300 - 30) Step 30
		; Extracts both embeddings.
		$image_result = $embedder0.embed_for_video($test_image, $timestamp)
		$crop_result = $embedder1.embed_for_video($test_cropped_image, $timestamp)

		; Checks cosine similarity.
		_check_cosine_similarity($image_result, $crop_result, $expected_similarity)
	Next

EndFunc   ;==>test_embed_for_video

Func test_embed_for_video_succeeds_with_region_of_interest()
	Local $options = $_ImageEmbedderOptions(_Mediapipe_Params( _
			"base_options", $_BaseOptions(_Mediapipe_Params("model_asset_path", $model_path)), _
			"running_mode", $_RUNNING_MODE.VIDEO))

	Local $embedder0 = $_ImageEmbedder.create_from_options($options)
	Local $embedder1 = $_ImageEmbedder.create_from_options($options)

	; Region-of-interest in "burger.jpg" corresponding to "burger_crop.jpg".
	Local $roi = $_Rect(_Mediapipe_Params("left", 0, "top", 0, "right", 0.833333, "bottom", 1))
	Local $image_processing_options = $_ImageProcessingOptions($roi)

	Local Const $expected_similarity = 0.999931
	Local $image_result, $crop_result
	For $timestamp = 0 To (300 - 30) Step 30
		; Extracts both embeddings.
		$image_result = $embedder0.embed_for_video($test_image, $timestamp, $image_processing_options)
		$crop_result = $embedder1.embed_for_video($test_cropped_image, $timestamp)

		; Checks cosine similarity.
		_check_cosine_similarity($image_result, $crop_result, $expected_similarity)
	Next

EndFunc   ;==>test_embed_for_video_succeeds_with_region_of_interest

Func _check_embedding_value($result, $expected_first_value)
	; Check embedding first value.
	_AssertAlmostEqual($result.embeddings(0).embedding(0), $expected_first_value, $_EPSILON)
EndFunc   ;==>_check_embedding_value

Func _check_embedding_size($result, $quantize, $expected_embedding_size, $sLine = @ScriptLineNumber)
	; Check embedding size.
	_AssertLen($result.embeddings, 1, Default, True, 0x7FFFFFFF, $sLine)
	Local $embedding_result = $result.embeddings(0)
	_AssertEqual($embedding_result.embedding.total(), $expected_embedding_size, Default, True, 0x7FFFFFFF, $sLine)
	If $quantize Then
		_AssertEqual($embedding_result.embedding.depth(), $CV_8U, Default, True, 0x7FFFFFFF, $sLine)
	Else
		_AssertEqual($embedding_result.embedding.depth(), $CV_32F, Default, True, 0x7FFFFFFF, $sLine)
	EndIf
EndFunc   ;==>_check_embedding_size

Func _check_cosine_similarity($result0, $result1, $expected_similarity)
	; Checks cosine similarity.
	Local $similarity = $_ImageEmbedder.cosine_similarity($result0.embeddings(0), $result1.embeddings(0))
	_AssertAlmostEqual($similarity, $expected_similarity, $_SIMILARITY_TOLERANCE)
EndFunc   ;==>_check_cosine_similarity

Func _OnAutoItExit()
	_OpenCV_Close()
	_Mediapipe_Close()
EndFunc   ;==>_OnAutoItExit
