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
;~     https://github.com/google/mediapipe/blob/v0.9.2.1/mediapipe/tasks/python/test/vision/image_segmenter_test.py

_Mediapipe_Open(_Mediapipe_FindDLL("opencv_world470*"), _Mediapipe_FindDLL("autoit_mediapipe_com-*-470*"))
_OpenCV_Open(_OpenCV_FindDLL("opencv_world470*"), _OpenCV_FindDLL("autoit_opencv_com470*"))
OnAutoItExitRegister("_OnAutoItExit")

_Mediapipe_SetResourceDir()

Global $cv = _OpenCV_get()

Global $download_utils = _Mediapipe_ObjCreate("mediapipe.autoit.solutions.download_utils")
_AssertIsObj($download_utils, "Failed to load mediapipe.autoit.solutions.download_utils")

Global $image_module = _Mediapipe_ObjCreate("mediapipe.autoit._framework_bindings.image")
_AssertIsObj($image_module, "Failed to load mediapipe.autoit._framework_bindings.image")

Global $image_frame = _Mediapipe_ObjCreate("mediapipe.autoit._framework_bindings.image_frame")
_AssertIsObj($image_frame, "Failed to load mediapipe.autoit._framework_bindings.image_frame")

Global $base_options_module = _Mediapipe_ObjCreate("mediapipe.tasks.autoit.core.base_options")
_AssertIsObj($base_options_module, "Failed to load mediapipe.tasks.autoit.core.base_options")

Global $image_segmenter = _Mediapipe_ObjCreate("mediapipe.tasks.autoit.vision.image_segmenter")
_AssertIsObj($image_segmenter, "Failed to load mediapipe.tasks.autoit.vision.image_segmenter")

Global $vision_task_running_mode = _Mediapipe_ObjCreate("mediapipe.tasks.autoit.vision.core.vision_task_running_mode")
_AssertIsObj($vision_task_running_mode, "Failed to load mediapipe.tasks.autoit.vision.core.vision_task_running_mode")

Global $_BaseOptions = $base_options_module.BaseOptions
Global $_Image = $image_module.Image
Global $_ImageFormat = $image_frame.ImageFormat
Global $_OutputType = $image_segmenter.ImageSegmenterOptionsEnums.OutputType
Global $_Activation = $image_segmenter.ImageSegmenterOptionsEnums.Activation
Global $_ImageSegmenter = $image_segmenter.ImageSegmenter
Global $_ImageSegmenterOptions = $image_segmenter.ImageSegmenterOptions
Global $_RUNNING_MODE = $vision_task_running_mode.VisionTaskRunningMode

Global $_MODEL_FILE = 'deeplabv3.tflite'
Global $_IMAGE_FILE = 'segmentation_input_rotation0.jpg'
Global $_SEGMENTATION_FILE = 'segmentation_golden_rotation0.png'
Global $_MASK_MAGNIFICATION_FACTOR = 10
Global $_MASK_SIMILARITY_THRESHOLD = 0.98

Global $FILE_CONTENT = 1
Global $FILE_NAME = 2

Global $test_image
Global $gt_segmentation_data
Global $test_seg_image
Global $model_path

Test()

Func Test()
	Local Const $_TEST_DATA_DIR = _Mediapipe_FindResourceDir() & "\mediapipe\tasks\testdata\vision"
	Local $url, $file_path

	Local $test_files[] = [ _
			$_MODEL_FILE, _
			$_IMAGE_FILE, _
			$_SEGMENTATION_FILE _
			]
	For $name In $test_files
		$url = "https://storage.googleapis.com/mediapipe-assets/" & $name
		$file_path = $_TEST_DATA_DIR & "\" & $name
		If Not FileExists(get_test_data_path($name)) Then
			$download_utils.download($url, $file_path)
		EndIf
	Next

	; Load the test input image.
	$test_image = $_Image.create_from_file(get_test_data_path($_IMAGE_FILE))

	; Loads ground truth segmentation file.
	$gt_segmentation_data = $cv.imread(get_test_data_path($_SEGMENTATION_FILE), $CV_IMREAD_GRAYSCALE)
	$test_seg_image = $_Image($_ImageFormat.GRAY8, $gt_segmentation_data)
	$model_path = get_test_data_path($_MODEL_FILE)

	test_create_from_file_succeeds_with_valid_model_path()
	test_create_from_options_succeeds_with_valid_model_path()
	test_create_from_options_succeeds_with_valid_model_content()

	test_segment_succeeds_with_category_mask($FILE_NAME)
	test_segment_succeeds_with_category_mask($FILE_CONTENT)

	test_segment_succeeds_with_confidence_mask()

	test_segment_without_context($FILE_NAME)
	test_segment_without_context($FILE_CONTENT)

	test_segment_for_video()
EndFunc   ;==>Test

Func test_create_from_file_succeeds_with_valid_model_path()
	; Creates with default option and valid model file successfully.
	Local $segmenter = $_ImageSegmenter.create_from_model_path($model_path)
	_AssertIsObj($segmenter)
	$segmenter.close()
EndFunc   ;==>test_create_from_file_succeeds_with_valid_model_path

Func test_create_from_options_succeeds_with_valid_model_path()
	; Creates with options containing model file successfully.
	Local $base_options = $_BaseOptions(_Mediapipe_Params("model_asset_path", $model_path))
	Local $options = $_ImageSegmenterOptions(_Mediapipe_Params("base_options", $base_options))
	Local $segmenter = $_ImageSegmenter.create_from_options($options)
	_AssertIsObj($segmenter)
	$segmenter.close()
EndFunc   ;==>test_create_from_options_succeeds_with_valid_model_path

Func test_create_from_options_succeeds_with_valid_model_content()
	; Creates with options containing model content successfully.
	Local $model_content = read_binary_to_mat($model_path)
	Local $base_options = $_BaseOptions(_Mediapipe_Params("model_asset_buffer", $model_content))
	Local $options = $_ImageSegmenterOptions(_Mediapipe_Params("base_options", $base_options))
	Local $segmenter = $_ImageSegmenter.create_from_options($options)
	_AssertIsObj($segmenter)
	$segmenter.close()
EndFunc   ;==>test_create_from_options_succeeds_with_valid_model_content

Func test_segment_succeeds_with_category_mask($model_file_type)
	Local $base_options, $model_content

	; Creates segmenter.
	If $model_file_type == $FILE_NAME Then
		$base_options = $_BaseOptions(_Mediapipe_Params("model_asset_path", $model_path))
	ElseIf $model_file_type == $FILE_CONTENT Then
		$model_content = read_binary_to_mat($model_path)
		$base_options = $_BaseOptions(_Mediapipe_Params("model_asset_buffer", $model_content))
	EndIf

	Local $options = $_ImageSegmenterOptions(_Mediapipe_Params("base_options", $base_options, "output_type", $_OutputType.CATEGORY_MASK))
	Local $segmenter = $_ImageSegmenter.create_from_options($options)

	; Performs image segmentation on the input.
	Local $category_masks = $segmenter.segment($test_image)
	_AssertLen($category_masks, 1)
	Local $category_mask = $category_masks[0]
	Local $result_pixels = $category_mask.mat_view().clone().reshape(1, 1) ; reshape needs a continuous matrix, clone to make matrix continous

	; Check if data type of `category_mask` is correct.
	_AssertEqual($result_pixels.depth(), $CV_8U)

	_AssertTrue( _
			_similar_to_uint8_mask($category_masks[0], $test_seg_image), _
			'Number of pixels in the candidate mask differing from that of the ' & _
			'ground truth mask exceeds ' & $_MASK_SIMILARITY_THRESHOLD & '.')

	; Closes the segmenter explicitly when the segmenter is not used ina context.
	$segmenter.close()
EndFunc   ;==>test_segment_succeeds_with_category_mask

Func test_segment_succeeds_with_confidence_mask()
	; Creates segmenter.
	Local $base_options = $_BaseOptions(_Mediapipe_Params("model_asset_path", $model_path))

	; Run segmentation on the model in CATEGORY_MASK mode.
	Local $options = $_ImageSegmenterOptions(_Mediapipe_Params("base_options", $base_options, "output_type", $_OutputType.CATEGORY_MASK))
	Local $segmenter = $_ImageSegmenter.create_from_options($options)
	Local $category_masks = $segmenter.segment($test_image)
	Local $category_mask = $category_masks[0].mat_view()

	; Closes the segmenter explicitly when the segmenter is not used in a context.
	$segmenter.close()

	; Run segmentation on the model in CONFIDENCE_MASK mode.
	$options = $_ImageSegmenterOptions(_Mediapipe_Params( _
			"base_options", $base_options, _
			"output_type", $_OutputType.CONFIDENCE_MASK, _
			"activation", $_Activation.SOFTMAX))
	$segmenter = $_ImageSegmenter.create_from_options($options)
	Local $confidence_masks = $segmenter.segment($test_image)

	; Closes the segmenter explicitly when the segmenter is not used in a context.
	$segmenter.close()

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

	; Compute the category mask from the created confidence mask.
	; reduceArgMax returns a CV_32SC1 matrix
	; but the expected result, category_mask, is a CV_8U matrix
	; therefore, convert to CV_8U
	Local $calculated_category_mask = $cv.reduceArgMax($confidence_mask_array, _OpenCV_Params("axis", 0)).convertTo($CV_8U)

	; calculated_category_mask has only one element at axis 0
	; get that one element in a matrix
	Local $sizes = _OpenCV_ObjCreate("VectorOfInt").create($calculated_category_mask.sizes())
	$sizes.remove(0) ; treat [1 x N x ...] matrix as a [N x ...] matrix
	$calculated_category_mask = $calculated_category_mask.reshape(1, $sizes)

	_AssertMatEqual($calculated_category_mask, $category_mask, _
			'Confidence mask does not match with the category mask.')
EndFunc   ;==>test_segment_succeeds_with_confidence_mask

Func test_segment_without_context($model_file_type)
	Local $base_options, $model_content

	; Creates segmenter.
	If $model_file_type == $FILE_NAME Then
		$base_options = $_BaseOptions(_Mediapipe_Params("model_asset_path", $model_path))
	ElseIf $model_file_type == $FILE_CONTENT Then
		$model_content = read_binary_to_mat($model_path)
		$base_options = $_BaseOptions(_Mediapipe_Params("model_asset_buffer", $model_content))
	EndIf

	Local $options = $_ImageSegmenterOptions(_Mediapipe_Params("base_options", $base_options, "output_type", $_OutputType.CATEGORY_MASK))
	Local $segmenter = $_ImageSegmenter.create_from_options($options)

	; Performs image segmentation on the input.
	Local $category_masks = $segmenter.segment($test_image)
	_AssertLen($category_masks, 1)
	_AssertTrue( _
			_similar_to_uint8_mask($category_masks[0], $test_seg_image), _
			'Number of pixels in the candidate mask differing from that of the ' & _
			'ground truth mask exceeds ' & $_MASK_SIMILARITY_THRESHOLD & '.')

	; Closes the segmenter explicitly when the segmenter is not used in a context.
	$segmenter.close()
EndFunc   ;==>test_segment_without_context

Func test_segment_for_video()
	Local $options = $_ImageSegmenterOptions(_Mediapipe_Params( _
			"base_options", $_BaseOptions(_Mediapipe_Params("model_asset_path", $model_path)), _
			"output_type", $_OutputType.CATEGORY_MASK, _
			"running_mode", $_RUNNING_MODE.VIDEO))

	Local $segmenter = $_ImageSegmenter.create_from_options($options)

	Local $category_masks
	For $timestamp = 0 To (300 - 30) Step 30
		$category_masks = $segmenter.segment_for_video($test_image, $timestamp)
		_AssertLen($category_masks, 1)
		_AssertTrue( _
				_similar_to_uint8_mask($category_masks[0], $test_seg_image), _
				'Number of pixels in the candidate mask differing from that of the ' & _
				'ground truth mask exceeds ' & $_MASK_SIMILARITY_THRESHOLD & '.')
	Next

	; Closes the segmenter explicitly when the segmenter is not used in a context.
	$segmenter.close()
EndFunc   ;==>test_segment_for_video

Func _similar_to_uint8_mask($actual_mask, $expected_mask)
	Local $actual_mask_pixels = $actual_mask.mat_view().convertTo(-1, Null, $_MASK_MAGNIFICATION_FACTOR)
	Local $expected_mask_pixels = $expected_mask.mat_view().clone() ; reshape needs a continuous matrix, clone to make matrix continous

	Return _AssertMatAlmostEqual($actual_mask_pixels, $expected_mask_pixels, Default, $_MASK_SIMILARITY_THRESHOLD)
EndFunc   ;==>_similar_to_uint8_mask

Func _OnAutoItExit()
	_OpenCV_Close()
	_Mediapipe_Close()
EndFunc   ;==>_OnAutoItExit
