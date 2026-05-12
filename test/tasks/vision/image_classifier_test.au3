#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Change2CUI=y
#AutoIt3Wrapper_Au3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

;~ Sources:
;~     https://github.com/google-ai-edge/mediapipe/blob/v0.10.35/mediapipe/tasks/python/test/vision/image_classifier_test.py

#include "..\..\..\autoit-mediapipe-com\udf\mediapipe_udf_utils.au3"
#include "..\..\_assert.au3"
#include "..\..\_test_utils.au3"

_Mediapipe_Open(_Mediapipe_FindDLL("opencv_world4130*"), _Mediapipe_FindDLL("autoit_mediapipe_com-*-4130*"))
OnAutoItExitRegister("_OnAutoItExit")

Global Const $download_utils = _Mediapipe_ObjCreate("mediapipe.tasks.autoit.core.download_utils")
_AssertIsObj($download_utils, "Failed to load mediapipe.tasks.autoit.core.download_utils")

Global Const $category_module = _Mediapipe_ObjCreate("mediapipe.tasks.autoit.components.containers.category")
_AssertIsObj($category_module, "Failed to load mediapipe.tasks.autoit.components.containers.category")

Global Const $classification_result_module = _Mediapipe_ObjCreate("mediapipe.tasks.autoit.components.containers.classification_result")
_AssertIsObj($classification_result_module, "Failed to load mediapipe.tasks.autoit.components.containers.classification_result")

Global Const $rect_module = _Mediapipe_ObjCreate("mediapipe.tasks.autoit.components.containers.rect")
_AssertIsObj($rect_module, "Failed to load mediapipe.tasks.autoit.components.containers.rect")

Global Const $base_options_module = _Mediapipe_ObjCreate("mediapipe.tasks.autoit.core.base_options")
_AssertIsObj($base_options_module, "Failed to load mediapipe.tasks.autoit.core.base_options")

Global Const $image_classifier = _Mediapipe_ObjCreate("mediapipe.tasks.autoit.vision.image_classifier")
_AssertIsObj($image_classifier, "Failed to load mediapipe.tasks.autoit.vision.image_classifier")

Global Const $image_module = _Mediapipe_ObjCreate("mediapipe.tasks.autoit.vision.core.image")
_AssertIsObj($image_module, "Failed to load mediapipe.tasks.autoit.vision.core.image")

Global Const $image_processing_options_module = _Mediapipe_ObjCreate("mediapipe.tasks.autoit.vision.core.image_processing_options")
_AssertIsObj($image_processing_options_module, "Failed to load mediapipe.tasks.autoit.vision.core.image_processing_options")

Global Const $vision_task_running_mode = _Mediapipe_ObjCreate("mediapipe.tasks.autoit.vision.core.vision_task_running_mode")
_AssertIsObj($vision_task_running_mode, "Failed to load mediapipe.tasks.autoit.vision.core.vision_task_running_mode")

Global Const $_ImageClassifierResult = $classification_result_module.ClassificationResult
Global Const $RectF = $rect_module.RectF
Global Const $_BaseOptions = $base_options_module.BaseOptions
Global Const $_Category = $category_module.Category
Global Const $_Classifications = $classification_result_module.Classifications
Global Const $_Image = $image_module.Image
Global Const $_ImageClassifier = $image_classifier.ImageClassifier
Global Const $_ImageClassifierOptions = $image_classifier.ImageClassifierOptions
Global Const $_RUNNING_MODE = $vision_task_running_mode.VisionTaskRunningMode
Global Const $_ImageProcessingOptions = $image_processing_options_module.ImageProcessingOptions

Global Const $_MODEL_FILE = 'mobilenet_v2_1.0_224.tflite'
Global Const $_IMAGE_FILE = 'burger.jpg'
Global Const $_IMAGE_ROTATED_FILE = 'burger_rotated.jpg'
Global Const $_IMAGE_ROI_FILE = 'multi_objects.jpg'
Global Const $_IMAGE_ROI_ROTATED_FILE = 'multi_objects_rotated.jpg'
Global Const $_ALLOW_LIST[] = ['cheeseburger', 'guacamole']
Global Const $_DENY_LIST[] = ['cheeseburger']
Global Const $_SCORE_THRESHOLD = 0.5
Global Const $_MAX_RESULTS = 3

Global Const $_EXPECTED_ROTATED_CLASSIFICATION_RESULT = $_ImageClassifierResult(_Mediapipe_Params( _
		"classifications", _Mediapipe_Tuple( _
		$_Classifications(_Mediapipe_Params( _
		"categories", _Mediapipe_Tuple( _
		$_Category(_Mediapipe_Params( _
		"index", 934, _
		"score", 0.754467, _
		"display_name", '', _
		"category_name", 'cheeseburger' _
		)), _
		$_Category(_Mediapipe_Params( _
		"index", 925, _
		"score", 0.0288028, _
		"display_name", '', _
		"category_name", 'guacamole' _
		)), _
		$_Category(_Mediapipe_Params( _
		"index", 932, _
		"score", 0.0286119, _
		"display_name", '', _
		"category_name", 'bagel' _
		)) _
		), _
		"head_index", 0, _
		"head_name", 'probability' _
		)) _
		), _
		"timestamp_ms", 0 _
		))

Global Const $_EXPECTED_ROI_ROTATED__CLASSIFICATION_RESULT = $_ImageClassifierResult(_Mediapipe_Params( _
		"classifications", _Mediapipe_Tuple( _
		$_Classifications(_Mediapipe_Params( _
		"categories", _Mediapipe_Tuple( _
		$_Category(_Mediapipe_Params( _
		"index", 806, _
		"score", 0.997684, _
		"display_name", '', _
		"category_name", 'soccer ball' _
		)) _
		), _
		"head_index", 0, _
		"head_name", 'probability' _
		)) _
		), _
		"timestamp_ms", 0 _
		))

Global Const $FILE_CONTENT = 1
Global Const $FILE_NAME = 2

Global $test_image
Global $model_path


Func _generate_empty_results()
	Return $_ImageClassifierResult(_Mediapipe_Params( _
			"classifications", _Mediapipe_Tuple( _
			$_Classifications(_Mediapipe_Params( _
			"categories", _Mediapipe_Tuple(), "head_index", 0, "head_name", 'probability')) _
			), _
			"timestamp_ms", 0))
EndFunc   ;==>_generate_empty_results

Func _generate_burger_results($timestamp_ms = 0)
	Return $_ImageClassifierResult(_Mediapipe_Params( _
			"classifications", _Mediapipe_Tuple( _
			$_Classifications(_Mediapipe_Params( _
			"categories", _Mediapipe_Tuple( _
			$_Category(_Mediapipe_Params( _
			"index", 934, _
			"score", 0.793959, _
			"display_name", '', _
			"category_name", 'cheeseburger' _
			)), _
			$_Category(_Mediapipe_Params( _
			"index", 932, _
			"score", 0.0273929, _
			"display_name", '', _
			"category_name", 'bagel' _
			)), _
			$_Category(_Mediapipe_Params( _
			"index", 925, _
			"score", 0.0193408, _
			"display_name", '', _
			"category_name", 'guacamole' _
			)), _
			$_Category(_Mediapipe_Params( _
			"index", 963, _
			"score", 0.00632786, _
			"display_name", '', _
			"category_name", 'meat loaf' _
			)) _
			), _
			"head_index", 0, _
			"head_name", 'probability' _
			)) _
			), _
			"timestamp_ms", $timestamp_ms _
			))
EndFunc   ;==>_generate_burger_results

Func _generate_soccer_ball_results($timestamp_ms = 0)
	Return $_ImageClassifierResult(_Mediapipe_Params( _
			"classifications", _Mediapipe_Tuple( _
			$_Classifications(_Mediapipe_Params( _
			"categories", _Mediapipe_Tuple( _
			$_Category(_Mediapipe_Params( _
			"index", 806, _
			"score", 0.996527, _
			"display_name", '', _
			"category_name", 'soccer ball' _
			)) _
			), _
			"head_index", 0, _
			"head_name", 'probability' _
			)) _
			), _
			"timestamp_ms", $timestamp_ms _
			))
EndFunc   ;==>_generate_soccer_ball_results


ImageClassifierTest()


Func ImageClassifierTest()
	ImageClassifierTest_setUp()

	test_create_from_file_succeeds_with_valid_model_path()
	test_create_from_options_succeeds_with_valid_model_path()
	test_create_from_options_succeeds_with_valid_model_content()
	test_classify($FILE_NAME, 4, _generate_burger_results())
	test_classify($FILE_CONTENT, 4, _generate_burger_results())
	test_classify_succeeds_with_region_of_interest()
	test_classify_succeeds_with_rotation()
	test_classify_succeeds_with_region_of_interest_and_rotation()
	test_score_threshold_option()
	test_max_results_option()
	test_allow_list_option()
	test_deny_list_option()
	test_empty_classification_outputs()
	test_classify_for_video()
	test_classify_for_video_succeeds_with_region_of_interest()
EndFunc   ;==>ImageClassifierTest


Func ImageClassifierTest_setUp()
	Local Const $_TEST_DATA_DIR = _Mediapipe_FindResourceDir() & "\mediapipe\tasks\testdata\vision"
	Local $url, $file_path

	Local $test_files[] = [ _
			$_MODEL_FILE, _
			$_IMAGE_FILE, _
			$_IMAGE_ROI_FILE, _
			$_IMAGE_ROTATED_FILE, _
			$_IMAGE_ROI_ROTATED_FILE _
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

	$test_image = $_Image.create_from_file(get_test_data_path($_IMAGE_FILE))
	$model_path = get_test_data_path($_MODEL_FILE)
EndFunc   ;==>ImageClassifierTest_setUp

Func _AssertCategoryAlmostEqual($actual, $expected, $fDelta = Default, $bExit = Default, $iCode = Default, $sFile = @ScriptFullPath, $iLine = @ScriptLineNumber, Const $_iCallerError = @error, Const $_vCallerExtended = @extended)
	If $fDelta == Default Then $fDelta = 1E-6

	_AssertEqual($actual.index, $expected.index, Default, $bExit, $iCode, $sFile, $iLine, $_iCallerError, $_vCallerExtended)
	_AssertAlmostEqual($actual.score, $expected.score, $fDelta, Default, Default, $bExit, $iCode, $sFile, $iLine, $_iCallerError, $_vCallerExtended)
	_AssertEqual($actual.display_name <> Default ? $actual.display_name : '', $expected.display_name, Default, $bExit, $iCode, $sFile, $iLine, $_iCallerError, $_vCallerExtended)
	_AssertEqual($actual.category_name, $expected.category_name, Default, $bExit, $iCode, $sFile, $iLine, $_iCallerError, $_vCallerExtended)
EndFunc   ;==>_AssertCategoryAlmostEqual

Func _AssertClassificationsAlmostEqual($actual, $expected, $bExit = Default, $iCode = Default, $sFile = @ScriptFullPath, $iLine = @ScriptLineNumber, Const $_iCallerError = @error, Const $_vCallerExtended = @extended)
	_AssertEqual($actual.head_index, $expected.head_index, Default, $bExit, $iCode, $sFile, $iLine, $_iCallerError, $_vCallerExtended)
	_AssertEqual($actual.head_name, $expected.head_name, Default, $bExit, $iCode, $sFile, $iLine, $_iCallerError, $_vCallerExtended)
	_AssertLen($actual.categories, $expected.categories.size(), Default, $bExit, $iCode, $sFile, $iLine, $_iCallerError, $_vCallerExtended)
	For $i = 0 To $actual.categories.size() - 1
		_AssertCategoryAlmostEqual($actual.categories($i), $expected.categories($i), Default, $bExit, $iCode, $sFile, $iLine, $_iCallerError, $_vCallerExtended)
	Next
EndFunc   ;==>_AssertClassificationsAlmostEqual

Func _AssertClassificationResultCorrect($actual, $expected, $bExit = Default, $iCode = Default, $sFile = @ScriptFullPath, $iLine = @ScriptLineNumber, Const $_iCallerError = @error, Const $_vCallerExtended = @extended)
	_AssertEqual($actual.timestamp_ms, $expected.timestamp_ms, Default, $bExit, $iCode, $sFile, $iLine, $_iCallerError, $_vCallerExtended)
	_AssertLen($actual.classifications, $expected.classifications.size(), Default, $bExit, $iCode, $sFile, $iLine, $_iCallerError, $_vCallerExtended)
	For $i = 0 To $actual.classifications.size() - 1
		_AssertClassificationsAlmostEqual($actual.classifications($i), $expected.classifications($i), $bExit, $iCode, $sFile, $iLine, $_iCallerError, $_vCallerExtended)
	Next
EndFunc   ;==>_AssertClassificationResultCorrect

Func test_create_from_file_succeeds_with_valid_model_path()
	ConsoleWrite('"' & @ScriptFullPath & '" @@ Debug(' & @ScriptLineNumber & ') : test_create_from_file_succeeds_with_valid_model_path' & @CRLF) ;### Debug Console

	; Creates with default option and valid model file successfully.
	Local $classifier = $_ImageClassifier.create_from_model_path($model_path)
	_AssertIsInstance($classifier, $_ImageClassifier)
	$classifier.close()
EndFunc   ;==>test_create_from_file_succeeds_with_valid_model_path

Func test_create_from_options_succeeds_with_valid_model_path()
	ConsoleWrite('"' & @ScriptFullPath & '" @@ Debug(' & @ScriptLineNumber & ') : test_create_from_options_succeeds_with_valid_model_path' & @CRLF) ;### Debug Console

	; Creates with options containing model file successfully.
	Local $base_options = $_BaseOptions(_Mediapipe_Params("model_asset_path", $model_path))
	Local $options = $_ImageClassifierOptions(_Mediapipe_Params("base_options", $base_options))
	Local $classifier = $_ImageClassifier.create_from_options($options)
	_AssertIsInstance($classifier, $_ImageClassifier)
	$classifier.close()
EndFunc   ;==>test_create_from_options_succeeds_with_valid_model_path

Func test_create_from_options_succeeds_with_valid_model_content()
	ConsoleWrite('"' & @ScriptFullPath & '" @@ Debug(' & @ScriptLineNumber & ') : test_create_from_options_succeeds_with_valid_model_content' & @CRLF) ;### Debug Console

	; Creates with options containing model content successfully.
	Local $model_content = read_file_into_buffer($model_path)
	Local $base_options = $_BaseOptions(_Mediapipe_Params("model_asset_buffer", $model_content))
	Local $options = $_ImageClassifierOptions(_Mediapipe_Params("base_options", $base_options))
	Local $classifier = $_ImageClassifier.create_from_options($options)
	_AssertIsInstance($classifier, $_ImageClassifier)
	$classifier.close()
EndFunc   ;==>test_create_from_options_succeeds_with_valid_model_content

Func test_classify($model_file_type, $max_results, $expected_classification_result)
	ConsoleWrite('"' & @ScriptFullPath & '" @@ Debug(' & @ScriptLineNumber & ') : test_classify' & @CRLF) ;### Debug Console

	Local $base_options, $model_content

	; Creates classifier.
	If $model_file_type == $FILE_NAME Then
		$base_options = $_BaseOptions(_Mediapipe_Params("model_asset_path", $model_path))
	ElseIf $model_file_type == $FILE_CONTENT Then
		$model_content = read_file_into_buffer($model_path)
		$base_options = $_BaseOptions(_Mediapipe_Params("model_asset_buffer", $model_content))
	EndIf

	Local $options = $_ImageClassifierOptions(_Mediapipe_Params("base_options", $base_options, "max_results", $max_results))
	Local $classifier = $_ImageClassifier.create_from_options($options)

	; Performs image classification on the input.
	Local $image_result = $classifier.classify($test_image)

	; Comparing results.
	_AssertClassificationResultCorrect($image_result, $expected_classification_result)
EndFunc   ;==>test_classify

Func test_classify_succeeds_with_region_of_interest()
	ConsoleWrite('"' & @ScriptFullPath & '" @@ Debug(' & @ScriptLineNumber & ') : test_classify_succeeds_with_region_of_interest' & @CRLF) ;### Debug Console

	; Creates classifier.
	Local $base_options = $_BaseOptions(_Mediapipe_Params("model_asset_path", $model_path))
	Local $options = $_ImageClassifierOptions(_Mediapipe_Params("base_options", $base_options, "max_results", 1))
	Local $classifier = $_ImageClassifier.create_from_options($options)

	Local $test_image = $_Image.create_from_file(get_test_data_path($_IMAGE_ROI_FILE))

	; Region-of-interest around the soccer ball.
	Local $roi = $RectF(_Mediapipe_Params("left", 0.45, "top", 0.3075, "right", 0.614, "bottom", 0.7345))

	; Performs image classification on the input.
	Local $image_processing_options = $_ImageProcessingOptions($roi)
	Local $image_result = $classifier.classify($test_image, $image_processing_options)

	; Comparing results.
	_AssertClassificationResultCorrect($image_result, _generate_soccer_ball_results())
EndFunc   ;==>test_classify_succeeds_with_region_of_interest

Func test_classify_succeeds_with_rotation()
	ConsoleWrite('"' & @ScriptFullPath & '" @@ Debug(' & @ScriptLineNumber & ') : test_classify_succeeds_with_rotation' & @CRLF) ;### Debug Console

	Local $base_options = $_BaseOptions(_Mediapipe_Params("model_asset_path", $model_path))
	Local $options = $_ImageClassifierOptions(_Mediapipe_Params("base_options", $base_options, "max_results", 3))
	Local $classifier = $_ImageClassifier.create_from_options($options)

	; Load the test image.
	Local $test_image = $_Image.create_from_file(get_test_data_path($_IMAGE_ROTATED_FILE))

	; Specify a 90° anti-clockwise rotation.
	Local $image_processing_options = $_ImageProcessingOptions(_Mediapipe_Params("rotation_degrees", -90))

	; Performs image classification on the input.
	Local $image_result = $classifier.classify($test_image, $image_processing_options)

	; Comparing results.
	_AssertClassificationResultCorrect($image_result, $_EXPECTED_ROTATED_CLASSIFICATION_RESULT)
EndFunc   ;==>test_classify_succeeds_with_rotation

Func test_classify_succeeds_with_region_of_interest_and_rotation()
	ConsoleWrite('"' & @ScriptFullPath & '" @@ Debug(' & @ScriptLineNumber & ') : test_classify_succeeds_with_region_of_interest_and_rotation' & @CRLF) ;### Debug Console

	Local $base_options = $_BaseOptions(_Mediapipe_Params("model_asset_path", $model_path))
	Local $options = $_ImageClassifierOptions(_Mediapipe_Params("base_options", $base_options, "max_results", 1))
	Local $classifier = $_ImageClassifier.create_from_options($options)

	; Load the test image.
	Local $test_image = $_Image.create_from_file(get_test_data_path($_IMAGE_ROI_ROTATED_FILE))

	; Region-of-interest around the soccer ball, with 90° anti-clockwise
	; rotation.
	Local $roi = $RectF(_Mediapipe_Params("left", 0.2655, "top", 0.45, "right", 0.6925, "bottom", 0.614))
	Local $image_processing_options = $_ImageProcessingOptions($roi, -90)

	; Performs image classification on the input.
	Local $image_result = $classifier.classify($test_image, $image_processing_options)

	; Comparing results.
	_AssertClassificationResultCorrect($image_result, $_EXPECTED_ROI_ROTATED__CLASSIFICATION_RESULT)
EndFunc   ;==>test_classify_succeeds_with_region_of_interest_and_rotation

Func test_score_threshold_option()
	ConsoleWrite('"' & @ScriptFullPath & '" @@ Debug(' & @ScriptLineNumber & ') : test_score_threshold_option' & @CRLF) ;### Debug Console

	; Creates classifier.
	Local $base_options = $_BaseOptions(_Mediapipe_Params("model_asset_path", $model_path))
	Local $options = $_ImageClassifierOptions(_Mediapipe_Params("base_options", $base_options, "score_threshold", $_SCORE_THRESHOLD))
	Local $classifier = $_ImageClassifier.create_from_options($options)

	; Performs image classification on the input.
	Local $image_result = $classifier.classify($test_image)
	Local $classifications = $image_result.classifications
	_AssertGreater($classifications.size(), 0, 'no classifications found')

	Local $score
	For $classification In $classifications
		_AssertGreater($classification.categories.size(), 0, 'no categories found')

		For $category In $classification.categories
			$score = $category.score
			_AssertGreaterEqual( _
					$score, $_SCORE_THRESHOLD, _
					'Classification with score lower than threshold found. ' & _
					$classification.__str__())
		Next
	Next
EndFunc   ;==>test_score_threshold_option

Func test_max_results_option()
	ConsoleWrite('"' & @ScriptFullPath & '" @@ Debug(' & @ScriptLineNumber & ') : test_max_results_option' & @CRLF) ;### Debug Console

	; Creates classifier.
	Local $base_options = $_BaseOptions(_Mediapipe_Params("model_asset_path", $model_path))
	Local $options = $_ImageClassifierOptions(_Mediapipe_Params("base_options", $base_options, "score_threshold", $_SCORE_THRESHOLD))
	Local $classifier = $_ImageClassifier.create_from_options($options)

	; Performs image classification on the input.
	Local $image_result = $classifier.classify($test_image)
	Local $categories = $image_result.classifications(0).categories

	_AssertLessEqual($categories.size(), $_MAX_RESULTS, 'Too many results returned.')
EndFunc   ;==>test_max_results_option

Func test_allow_list_option()
	ConsoleWrite('"' & @ScriptFullPath & '" @@ Debug(' & @ScriptLineNumber & ') : test_allow_list_option' & @CRLF) ;### Debug Console

	; Creates classifier.
	Local $options = $_ImageClassifierOptions(_Mediapipe_Params( _
			"base_options", $_BaseOptions(_Mediapipe_Params("model_asset_path", $model_path)), _
			"category_allowlist", $_ALLOW_LIST))
	Local $classifier = $_ImageClassifier.create_from_options($options)

	; Performs image classification on the input.
	Local $image_result = $classifier.classify($test_image)
	Local $classifications = $image_result.classifications
	_AssertGreater($classifications.size(), 0, 'no classifications found')

	Local $label
	For $classification In $classifications
		_AssertGreater($classification.categories.size(), 0, 'no categories found')

		For $category In $classification.categories
			$label = $category.category_name
			_AssertIn($label, $_ALLOW_LIST, _
					"Label " & $label & " found but not in label allow list")
		Next
	Next
EndFunc   ;==>test_allow_list_option

Func test_deny_list_option()
	ConsoleWrite('"' & @ScriptFullPath & '" @@ Debug(' & @ScriptLineNumber & ') : test_deny_list_option' & @CRLF) ;### Debug Console

	; Creates classifier.
	Local $options = $_ImageClassifierOptions(_Mediapipe_Params( _
			"base_options", $_BaseOptions(_Mediapipe_Params("model_asset_path", $model_path)), _
			"category_denylist", $_DENY_LIST))
	Local $classifier = $_ImageClassifier.create_from_options($options)

	; Performs image classification on the input.
	Local $image_result = $classifier.classify($test_image)
	Local $classifications = $image_result.classifications
	_AssertGreater($classifications.size(), 0, 'no classifications found')

	Local $label
	For $classification In $classifications
		_AssertGreater($classification.categories.size(), 0, 'no categories found')

		For $category In $classification.categories
			$label = $category.category_name
			_AssertNotIn($label, $_DENY_LIST, _
					"Label " & $label & " found but in deny list")
		Next
	Next
EndFunc   ;==>test_deny_list_option

Func test_empty_classification_outputs()
	ConsoleWrite('"' & @ScriptFullPath & '" @@ Debug(' & @ScriptLineNumber & ') : test_empty_classification_outputs' & @CRLF) ;### Debug Console

	; Creates classifier.
	Local $options = $_ImageClassifierOptions(_Mediapipe_Params( _
			"base_options", $_BaseOptions(_Mediapipe_Params("model_asset_path", $model_path)), _
			"score_threshold", 1))
	Local $classifier = $_ImageClassifier.create_from_options($options)

	; Performs image classification on the input.
	Local $image_result = $classifier.classify($test_image)
	_AssertEmpty($image_result.classifications(0).categories)
EndFunc   ;==>test_empty_classification_outputs

Func test_classify_for_video()
	ConsoleWrite('"' & @ScriptFullPath & '" @@ Debug(' & @ScriptLineNumber & ') : test_classify_for_video' & @CRLF) ;### Debug Console

	; Creates classifier.
	Local $options = $_ImageClassifierOptions(_Mediapipe_Params( _
			"base_options", $_BaseOptions(_Mediapipe_Params("model_asset_path", $model_path)), _
			"running_mode", $_RUNNING_MODE.VIDEO, _
			"max_results", 4))
	Local $classifier = $_ImageClassifier.create_from_options($options)

	Local $classification_result
	For $timestamp = 0 To (300 - 30) Step 30
		$classification_result = $classifier.classify_for_video($test_image, $timestamp)
		_AssertClassificationResultCorrect( _
				$classification_result, _
				_generate_burger_results($timestamp) _
				)
	Next
EndFunc   ;==>test_classify_for_video

Func test_classify_for_video_succeeds_with_region_of_interest()
	ConsoleWrite('"' & @ScriptFullPath & '" @@ Debug(' & @ScriptLineNumber & ') : test_classify_for_video_succeeds_with_region_of_interest' & @CRLF) ;### Debug Console

	; Creates classifier.
	Local $options = $_ImageClassifierOptions(_Mediapipe_Params( _
			"base_options", $_BaseOptions(_Mediapipe_Params("model_asset_path", $model_path)), _
			"running_mode", $_RUNNING_MODE.VIDEO, _
			"max_results", 1))
	Local $classifier = $_ImageClassifier.create_from_options($options)

	; Load the test image.
	Local $test_image = $_Image.create_from_file(get_test_data_path($_IMAGE_ROI_FILE))

	; Region-of-interest around the soccer ball.
	Local $roi = $RectF(_Mediapipe_Params("left", 0.45, "top", 0.3075, "right", 0.614, "bottom", 0.7345))
	Local $image_processing_options = $_ImageProcessingOptions($roi)

	Local $classification_result
	For $timestamp = 0 To (300 - 30) Step 30
		$classification_result = $classifier.classify_for_video( _
				$test_image, $timestamp, $image_processing_options)
		_AssertClassificationResultCorrect( _
				$classification_result, _
				_generate_soccer_ball_results($timestamp) _
				)
	Next
EndFunc   ;==>test_classify_for_video_succeeds_with_region_of_interest

Func _OnAutoItExit()
	_Mediapipe_Close()
EndFunc   ;==>_OnAutoItExit
