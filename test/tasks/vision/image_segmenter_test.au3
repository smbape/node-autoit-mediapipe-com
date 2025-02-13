#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Change2CUI=y
#AutoIt3Wrapper_Au3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

;~ Sources:
;~     https://github.com/google-ai-edge/mediapipe/blob/v0.10.14/mediapipe/tasks/python/test/vision/image_segmenter_test.py

#include "..\..\..\autoit-mediapipe-com\udf\mediapipe_udf_utils.au3"
#include "..\..\..\autoit-opencv-com\udf\opencv_udf_utils.au3"
#include "..\..\_assert.au3"
#include "..\..\_mat_utils.au3"
#include "..\..\_proto_utils.au3"
#include "..\..\_test_utils.au3"

_Mediapipe_Open(_Mediapipe_FindDLL("opencv_world4100*"), _Mediapipe_FindDLL("autoit_mediapipe_com-*-4100*"))
_OpenCV_Open(_OpenCV_FindDLL("opencv_world4100*"), _OpenCV_FindDLL("autoit_opencv_com4100*"))
OnAutoItExitRegister("_OnAutoItExit")

; Tell mediapipe where to look its resource files
_Mediapipe_SetResourceDir()

Global Const $cv = _OpenCV_get()
_AssertIsObj($cv, "Failed to load opencv")

Global Const $download_utils = _Mediapipe_ObjCreate("mediapipe.autoit.solutions.download_utils")
_AssertIsObj($download_utils, "Failed to load mediapipe.autoit.solutions.download_utils")

Global Const $image_module = _Mediapipe_ObjCreate("mediapipe.autoit._framework_bindings.image")
_AssertIsObj($image_module, "Failed to load mediapipe.autoit._framework_bindings.image")

Global Const $image_frame = _Mediapipe_ObjCreate("mediapipe.autoit._framework_bindings.image_frame")
_AssertIsObj($image_frame, "Failed to load mediapipe.autoit._framework_bindings.image_frame")

Global Const $base_options_module = _Mediapipe_ObjCreate("mediapipe.tasks.autoit.core.base_options")
_AssertIsObj($base_options_module, "Failed to load mediapipe.tasks.autoit.core.base_options")

Global Const $image_segmenter = _Mediapipe_ObjCreate("mediapipe.tasks.autoit.vision.image_segmenter")
_AssertIsObj($image_segmenter, "Failed to load mediapipe.tasks.autoit.vision.image_segmenter")

Global Const $vision_task_running_mode = _Mediapipe_ObjCreate("mediapipe.tasks.autoit.vision.core.vision_task_running_mode")
_AssertIsObj($vision_task_running_mode, "Failed to load mediapipe.tasks.autoit.vision.core.vision_task_running_mode")

Global Const $ImageSegmenterResult = $image_segmenter.ImageSegmenterResult
Global Const $_BaseOptions = $base_options_module.BaseOptions
Global Const $_Image = $image_module.Image
Global Const $_ImageFormat = $image_frame.ImageFormat
Global Const $_OutputType = $image_segmenter.ImageSegmenterOptions_OutputType
Global Const $_Activation = $image_segmenter.ImageSegmenterOptions_Activation
Global Const $_ImageSegmenter = $image_segmenter.ImageSegmenter
Global Const $_ImageSegmenterOptions = $image_segmenter.ImageSegmenterOptions
Global Const $_RUNNING_MODE = $vision_task_running_mode.VisionTaskRunningMode

Global Const $_MODEL_FILE = 'deeplabv3.tflite'
Global Const $_IMAGE_FILE = 'segmentation_input_rotation0.jpg'
Global Const $_SEGMENTATION_FILE = 'segmentation_golden_rotation0.png'
Global Const $_CAT_IMAGE = 'cat.jpg'
Global Const $_CAT_MASK = 'cat_mask.jpg'
Global Const $_MASK_MAGNIFICATION_FACTOR = 10
Global Const $_MASK_SIMILARITY_THRESHOLD = 0.98
Global Const $_EXPECTED_LABELS[] = [ _
		'background', _
		'aeroplane', _
		'bicycle', _
		'bird', _
		'boat', _
		'bottle', _
		'bus', _
		'car', _
		'cat', _
		'chair', _
		'cow', _
		'dining table', _
		'dog', _
		'horse', _
		'motorbike', _
		'person', _
		'potted plant', _
		'sheep', _
		'sofa', _
		'train', _
		'tv' _
		]

Global Const $FILE_CONTENT = 1
Global Const $FILE_NAME = 2

Global $test_image
Global $test_seg_image
Global $model_path

Test()

Func Test()
	Local Const $_TEST_DATA_DIR = _Mediapipe_FindResourceDir() & "\mediapipe\tasks\testdata\vision"
	Local $url, $file_path

	Local $test_files[] = [ _
			_Mediapipe_Tuple($_MODEL_FILE, "https://storage.googleapis.com/mediapipe-models/image_segmenter/deeplab_v3/float32/1/deeplab_v3.tflite"), _
			$_IMAGE_FILE, _
			$_SEGMENTATION_FILE, _
			$_CAT_IMAGE, _
			$_CAT_MASK _
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

	; Load the test input image.
	$test_image = $_Image.create_from_file(get_test_data_path($_IMAGE_FILE))

	; Loads ground truth segmentation file.
	$test_seg_image = _load_segmentation_mask($_SEGMENTATION_FILE)
	$model_path = get_test_data_path($_MODEL_FILE)

	test_create_from_file_succeeds_with_valid_model_path()
	test_create_from_options_succeeds_with_valid_model_path()
	test_create_from_options_succeeds_with_valid_model_content()

	test_segment_succeeds_with_category_mask($FILE_NAME)
	test_segment_succeeds_with_category_mask($FILE_CONTENT)

	test_segment_succeeds_with_confidence_mask($FILE_NAME)
	test_segment_succeeds_with_confidence_mask($FILE_CONTENT)

	test_labels_succeeds(True, False)
	test_labels_succeeds(False, True)

	test_segment_for_video_in_category_mask_mode()
	test_segment_for_video_in_confidence_mask_mode()
EndFunc   ;==>Test

Func test_create_from_file_succeeds_with_valid_model_path()
	; Creates with default option and valid model file successfully.
	Local $segmenter = $_ImageSegmenter.create_from_model_path($model_path)
	_AssertIsInstance($segmenter, $_ImageSegmenter)
EndFunc   ;==>test_create_from_file_succeeds_with_valid_model_path

Func test_create_from_options_succeeds_with_valid_model_path()
	; Creates with options containing model file successfully.
	Local $base_options = $_BaseOptions(_Mediapipe_Params("model_asset_path", $model_path))
	Local $options = $_ImageSegmenterOptions(_Mediapipe_Params("base_options", $base_options))
	Local $segmenter = $_ImageSegmenter.create_from_options($options)
	_AssertIsInstance($segmenter, $_ImageSegmenter)
EndFunc   ;==>test_create_from_options_succeeds_with_valid_model_path

Func test_create_from_options_succeeds_with_valid_model_content()
	; Creates with options containing model content successfully.
	Local $model_content = read_file_into_buffer($model_path)
	Local $base_options = $_BaseOptions(_Mediapipe_Params("model_asset_buffer", $model_content))
	Local $options = $_ImageSegmenterOptions(_Mediapipe_Params("base_options", $base_options))
	Local $segmenter = $_ImageSegmenter.create_from_options($options)
	_AssertIsInstance($segmenter, $_ImageSegmenter)
EndFunc   ;==>test_create_from_options_succeeds_with_valid_model_content

Func test_segment_succeeds_with_category_mask($model_file_type)
	Local $base_options, $model_content

	; Creates segmenter.
	If $model_file_type == $FILE_NAME Then
		$base_options = $_BaseOptions(_Mediapipe_Params("model_asset_path", $model_path))
	ElseIf $model_file_type == $FILE_CONTENT Then
		$model_content = read_file_into_buffer($model_path)
		$base_options = $_BaseOptions(_Mediapipe_Params("model_asset_buffer", $model_content))
	EndIf

	Local $options = $_ImageSegmenterOptions(_Mediapipe_Params( _
			"base_options", $base_options, _
			"output_category_mask", True, _
			"output_confidence_masks", False _
			))
	Local $segmenter = $_ImageSegmenter.create_from_options($options)

	; Performs image segmentation on the input.
	Local $segmentation_result = $segmenter.segment($test_image)
	Local $category_mask = $segmentation_result.category_mask
	Local $result_pixels = $category_mask.mat_view().clone().reshape(1, 1) ; reshape needs a continuous matrix, clone to the make matrix continous

	; Check if data type of `category_mask` is correct.
	_AssertEqual($result_pixels.depth(), $CV_8U)

	_AssertTrue( _
			_similar_to_uint8_mask($category_mask, $test_seg_image), _
			'Number of pixels in the candidate mask differing from that of the ' & _
			'ground truth mask exceeds ' & $_MASK_SIMILARITY_THRESHOLD & '.')

	; Closes the segmenter explicitly when the segmenter is not used ina context.
EndFunc   ;==>test_segment_succeeds_with_category_mask

Func test_segment_succeeds_with_confidence_mask($model_file_type)
	Local $base_options, $model_content

	; Creates segmenter.
	If $model_file_type == $FILE_NAME Then
		$base_options = $_BaseOptions(_Mediapipe_Params("model_asset_path", $model_path))
	ElseIf $model_file_type == $FILE_CONTENT Then
		$model_content = read_file_into_buffer($model_path)
		$base_options = $_BaseOptions(_Mediapipe_Params("model_asset_buffer", $model_content))
	EndIf

	; Load the cat image.
	Local $test_image = $_Image.create_from_file(get_test_data_path($_CAT_IMAGE))

	; Run segmentation on the model in CONFIDENCE_MASK mode.
	Local $options = $_ImageSegmenterOptions(_Mediapipe_Params( _
			"base_options", $base_options, _
			"output_category_mask", False, _
			"output_confidence_masks", True _
			))
	Local $segmenter = $_ImageSegmenter.create_from_options($options)
	Local $segmentation_result = $segmenter.segment($test_image)
	Local $confidence_masks = $segmentation_result.confidence_masks

	; Check if confidence mask shape is correct.
	_AssertLen($confidence_masks, 21, 'Number of confidence masks must match with number of categories.')

	; Gather the confidence masks in a single array `confidence_mask_array`.
	Local $confidence_mask_array = _OpenCV_ObjCreate("VectorOfMat")
	For $confidence_mask In $confidence_masks
		$confidence_mask_array.append($confidence_mask.mat_view())
	Next
	$confidence_mask_array = $cv.Mat.createFromVectorOfMat($confidence_mask_array)

	; Check if data type of `confidence_masks` are correct.
	_AssertEqual($confidence_mask_array.depth(), $CV_32F)

	; Loads ground truth segmentation file.
	Local $expected_mask = _load_segmentation_mask($_CAT_MASK)

	_AssertTrue(_similar_to_float_mask($confidence_masks(8), $expected_mask, $_MASK_SIMILARITY_THRESHOLD))
EndFunc   ;==>test_segment_succeeds_with_confidence_mask

Func test_labels_succeeds($output_category_mask, $output_confidence_masks)
	Local $expected_labels = $_EXPECTED_LABELS
	Local $base_options = $_BaseOptions(_Mediapipe_Params("model_asset_path", $model_path))
	Local $options = $_ImageSegmenterOptions(_Mediapipe_Params( _
			"base_options", $base_options, _
			"output_category_mask", $output_category_mask, _
			"output_confidence_masks", $output_confidence_masks _
			))
	Local $segmenter = $_ImageSegmenter.create_from_options($options)

	; Performs image segmentation on the input.
	Local $actual_labels = $segmenter.labels
	_AssertListEqual($actual_labels, $expected_labels)
EndFunc   ;==>test_labels_succeeds

Func test_segment_for_video_in_category_mask_mode()
	Local $options = $_ImageSegmenterOptions(_Mediapipe_Params( _
			"base_options", $_BaseOptions(_Mediapipe_Params("model_asset_path", $model_path)), _
			"output_category_mask", True, _
			"output_confidence_masks", False, _
			"running_mode", $_RUNNING_MODE.VIDEO))

	Local $segmenter = $_ImageSegmenter.create_from_options($options)

	Local $segmentation_result, $category_mask

	For $timestamp = 0 To (300 - 30) Step 30
		$segmentation_result = $segmenter.segment_for_video($test_image, $timestamp)
		$category_mask = $segmentation_result.category_mask
		_AssertTrue( _
				_similar_to_uint8_mask($category_mask, $test_seg_image), _
				'Number of pixels in the candidate mask differing from that of' & _
				' the ground truth mask exceeds' & $_MASK_SIMILARITY_THRESHOLD & '.')
	Next
EndFunc   ;==>test_segment_for_video_in_category_mask_mode

Func test_segment_for_video_in_confidence_mask_mode()
	; Load the cat image.
	Local $test_image = $_Image.create_from_file(get_test_data_path($_CAT_IMAGE))

	Local $options = $_ImageSegmenterOptions(_Mediapipe_Params( _
			"base_options", $_BaseOptions(_Mediapipe_Params("model_asset_path", $model_path)), _
			"output_category_mask", False, _
			"output_confidence_masks", True, _
			"running_mode", $_RUNNING_MODE.VIDEO))

	Local $segmenter = $_ImageSegmenter.create_from_options($options)

	Local $segmentation_result, $confidence_masks, $expected_mask

	For $timestamp = 0 To (300 - 30) Step 30
		$segmentation_result = $segmenter.segment_for_video($test_image, $timestamp)
		$confidence_masks = $segmentation_result.confidence_masks

		; Check if confidence mask shape is correct.
		_AssertLen( _
				$confidence_masks, _
				21, _
				'Number of confidence masks must match with number of categories.' _
				)

		; Loads ground truth segmentation file.
		$expected_mask = _load_segmentation_mask($_CAT_MASK)
		_AssertTrue( _
				_similar_to_float_mask( _
				$confidence_masks(8), $expected_mask, $_MASK_SIMILARITY_THRESHOLD _
				) _
				)
	Next
EndFunc   ;==>test_segment_for_video_in_confidence_mask_mode

Func _load_segmentation_mask($file_path)
	; Loads ground truth segmentation file.
	Local $gt_segmentation_data = $cv.imread(get_test_data_path($file_path), $CV_IMREAD_GRAYSCALE)
	Return $_Image($_ImageFormat.GRAY8, $gt_segmentation_data)
EndFunc   ;==>_load_segmentation_mask

Func _calculate_sum($m)
	Local $sum = 0.0
	Local $s = $cv.sumElems($m)
	For $i = 0 To $m.channels() - 1
		$sum += $s[$i]
	Next
	Return $sum
EndFunc   ;==>_calculate_sum

Func _calculate_soft_iou($m1, $m2)
	Local $intersection_sum = _calculate_sum($cv.multiply($m1, $m2))
	Local $union_sum = _calculate_sum($cv.multiply($m1, $m1)) + _calculate_sum($cv.multiply($m2, $m2)) - $intersection_sum

	Return $union_sum > 0.0 ? $intersection_sum / $union_sum : 0.0
EndFunc   ;==>_calculate_soft_iou


Func _similar_to_float_mask($actual_mask, $expected_mask, $similarity_threshold)
	$actual_mask = $actual_mask.mat_view()
	$expected_mask = $expected_mask.mat_view().convertTo($CV_32F, Null, 1 / 255.0)

	Return _
			$actual_mask.rows == $expected_mask.rows And _
			$actual_mask.cols == $expected_mask.cols And _
			_calculate_soft_iou($actual_mask, $expected_mask) > $similarity_threshold
EndFunc   ;==>_similar_to_float_mask

Func _similar_to_uint8_mask($actual_mask, $expected_mask)
	Local $actual_mask_pixels = $actual_mask.mat_view().convertTo(-1, Null, $_MASK_MAGNIFICATION_FACTOR)
	Local $expected_mask_pixels = $expected_mask.mat_view()

	Local $num_pixels = $expected_mask_pixels.total()
	Local $consistent_pixels = $num_pixels - $cv.countNonZero($cv.absdiff($actual_mask_pixels, $expected_mask_pixels).reshape(1))

	Return $consistent_pixels / $num_pixels >= $_MASK_SIMILARITY_THRESHOLD
EndFunc   ;==>_similar_to_uint8_mask

Func _OnAutoItExit()
	_OpenCV_Close()
	_Mediapipe_Close()
EndFunc   ;==>_OnAutoItExit
