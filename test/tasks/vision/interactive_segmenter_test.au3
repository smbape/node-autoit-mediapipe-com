#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Change2CUI=y
#AutoIt3Wrapper_Au3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

;~ Sources:
;~     https://github.com/google-ai-edge/mediapipe/blob/v0.10.14/mediapipe/tasks/python/test/vision/interactive_segmenter_test.py

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

Global Const $keypoint_module = _Mediapipe_ObjCreate("mediapipe.tasks.autoit.components.containers.keypoint")
_AssertIsObj($keypoint_module, "Failed to load mediapipe.tasks.autoit.components.containers.keypoint")

Global Const $rect = _Mediapipe_ObjCreate("mediapipe.tasks.autoit.components.containers.rect")
_AssertIsObj($rect, "Failed to load mediapipe.tasks.autoit.components.containers.rect")

Global Const $base_options_module = _Mediapipe_ObjCreate("mediapipe.tasks.autoit.core.base_options")
_AssertIsObj($base_options_module, "Failed to load mediapipe.tasks.autoit.core.base_options")

Global Const $interactive_segmenter = _Mediapipe_ObjCreate("mediapipe.tasks.autoit.vision.interactive_segmenter")
_AssertIsObj($interactive_segmenter, "Failed to load mediapipe.tasks.autoit.vision.interactive_segmenter")

Global Const $image_processing_options_module = _Mediapipe_ObjCreate("mediapipe.tasks.autoit.vision.core.image_processing_options")
_AssertIsObj($image_processing_options_module, "Failed to load mediapipe.tasks.autoit.vision.core.image_processing_options")

Global Const $InteractiveSegmenterResult = $interactive_segmenter.InteractiveSegmenterResult
Global Const $_BaseOptions = $base_options_module.BaseOptions
Global Const $_Image = $image_module.Image
Global Const $_ImageFormat = $image_frame.ImageFormat
Global Const $_NormalizedKeypoint = $keypoint_module.NormalizedKeypoint
Global Const $_Rect = $rect.Rect
Global Const $_InteractiveSegmenter = $interactive_segmenter.InteractiveSegmenter
Global Const $_InteractiveSegmenterOptions = $interactive_segmenter.InteractiveSegmenterOptions
Global Const $_RegionOfInterest = $interactive_segmenter.RegionOfInterest
Global Const $_RegionOfInterest_Format = $interactive_segmenter.RegionOfInterest_Format
Global Const $_ImageProcessingOptions = $image_processing_options_module.ImageProcessingOptions

Global Const $_MODEL_FILE = 'ptm_512_hdt_ptm_woid.tflite'
Global Const $_CATS_AND_DOGS = 'cats_and_dogs.jpg'
Global Const $_CATS_AND_DOGS_MASK_DOG_1 = 'cats_and_dogs_mask_dog1.png'
Global Const $_CATS_AND_DOGS_MASK_DOG_2 = 'cats_and_dogs_mask_dog2.png'
Global Const $_MASK_MAGNIFICATION_FACTOR = 255
Global Const $_MASK_SIMILARITY_THRESHOLD = 0.97

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
			$_MODEL_FILE, _
			$_CATS_AND_DOGS, _
			$_CATS_AND_DOGS_MASK_DOG_1, _
			$_CATS_AND_DOGS_MASK_DOG_2 _
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
	$test_image = $_Image.create_from_file(get_test_data_path($_CATS_AND_DOGS))

	; Loads ground truth segmentation file.
	$test_seg_image = _load_segmentation_mask($_CATS_AND_DOGS_MASK_DOG_1)
	$model_path = get_test_data_path($_MODEL_FILE)

	test_create_from_file_succeeds_with_valid_model_path()
	test_create_from_options_succeeds_with_valid_model_path()
	test_create_from_options_succeeds_with_valid_model_content()

	test_segment_succeeds_with_category_mask( _
			$FILE_NAME, _
			$_RegionOfInterest_Format.KEYPOINT, _
			$_NormalizedKeypoint(0.44, 0.7), _
			$_CATS_AND_DOGS_MASK_DOG_1, _
			0.84 _
			)
	test_segment_succeeds_with_category_mask( _
			$FILE_CONTENT, _
			$_RegionOfInterest_Format.KEYPOINT, _
			$_NormalizedKeypoint(0.44, 0.7), _
			$_CATS_AND_DOGS_MASK_DOG_1, _
			0.84 _
			)
	test_segment_succeeds_with_category_mask( _
			$FILE_NAME, _
			$_RegionOfInterest_Format.KEYPOINT, _
			$_NormalizedKeypoint(0.66, 0.66), _
			$_CATS_AND_DOGS_MASK_DOG_2, _
			$_MASK_SIMILARITY_THRESHOLD _
			)
	test_segment_succeeds_with_category_mask( _
			$FILE_CONTENT, _
			$_RegionOfInterest_Format.KEYPOINT, _
			$_NormalizedKeypoint(0.66, 0.66), _
			$_CATS_AND_DOGS_MASK_DOG_2, _
			$_MASK_SIMILARITY_THRESHOLD _
			)

	test_segment_succeeds_with_confidence_mask( _
			$FILE_NAME, _
			$_RegionOfInterest_Format.KEYPOINT, _
			$_NormalizedKeypoint(0.44, 0.7), _
			$_CATS_AND_DOGS_MASK_DOG_1, _
			0.84 _
			)
	test_segment_succeeds_with_confidence_mask( _
			$FILE_CONTENT, _
			$_RegionOfInterest_Format.KEYPOINT, _
			$_NormalizedKeypoint(0.44, 0.7), _
			$_CATS_AND_DOGS_MASK_DOG_1, _
			0.84 _
			)
	test_segment_succeeds_with_confidence_mask( _
			$FILE_NAME, _
			$_RegionOfInterest_Format.KEYPOINT, _
			$_NormalizedKeypoint(0.66, 0.66), _
			$_CATS_AND_DOGS_MASK_DOG_2, _
			$_MASK_SIMILARITY_THRESHOLD _
			)
	test_segment_succeeds_with_confidence_mask( _
			$FILE_CONTENT, _
			$_RegionOfInterest_Format.KEYPOINT, _
			$_NormalizedKeypoint(0.66, 0.66), _
			$_CATS_AND_DOGS_MASK_DOG_2, _
			$_MASK_SIMILARITY_THRESHOLD _
			)

	test_segment_succeeds_with_rotation()
EndFunc   ;==>Test

Func test_create_from_file_succeeds_with_valid_model_path()
	; Creates with default option and valid model file successfully.
	Local $segmenter = $_InteractiveSegmenter.create_from_model_path($model_path)
	_AssertIsInstance($segmenter, $_InteractiveSegmenter)
EndFunc   ;==>test_create_from_file_succeeds_with_valid_model_path

Func test_create_from_options_succeeds_with_valid_model_path()
	; Creates with options containing model file successfully.
	Local $base_options = $_BaseOptions(_Mediapipe_Params("model_asset_path", $model_path))
	Local $options = $_InteractiveSegmenterOptions(_Mediapipe_Params("base_options", $base_options))
	Local $segmenter = $_InteractiveSegmenter.create_from_options($options)
	_AssertIsInstance($segmenter, $_InteractiveSegmenter)
EndFunc   ;==>test_create_from_options_succeeds_with_valid_model_path

Func test_create_from_options_succeeds_with_valid_model_content()
	; Creates with options containing model content successfully.
	Local $model_content = read_file_into_buffer($model_path)
	Local $base_options = $_BaseOptions(_Mediapipe_Params("model_asset_buffer", $model_content))
	Local $options = $_InteractiveSegmenterOptions(_Mediapipe_Params("base_options", $base_options))
	Local $segmenter = $_InteractiveSegmenter.create_from_options($options)
	_AssertIsInstance($segmenter, $_InteractiveSegmenter)
EndFunc   ;==>test_create_from_options_succeeds_with_valid_model_content

Func test_segment_succeeds_with_category_mask( _
		$model_file_type, _
		$roi_format, _
		$keypoint, _
		$output_mask, _
		$similarity_threshold _
		)
	Local $base_options, $model_content

	; Creates segmenter.
	If $model_file_type == $FILE_NAME Then
		$base_options = $_BaseOptions(_Mediapipe_Params("model_asset_path", $model_path))
	ElseIf $model_file_type == $FILE_CONTENT Then
		$model_content = read_file_into_buffer($model_path)
		$base_options = $_BaseOptions(_Mediapipe_Params("model_asset_buffer", $model_content))
	EndIf

	Local $options = $_InteractiveSegmenterOptions(_Mediapipe_Params( _
			"base_options", $base_options, _
			"output_category_mask", True, _
			"output_confidence_masks", False _
			))
	Local $segmenter = $_InteractiveSegmenter.create_from_options($options)

	; Performs image segmentation on the input.
	Local $roi = $_RegionOfInterest(_Mediapipe_Params("format", $roi_format, "keypoint", $keypoint))
	Local $segmentation_result = $segmenter.segment($test_image, $roi)
	Local $category_mask = $segmentation_result.category_mask
	Local $result_pixels = $category_mask.mat_view().clone().reshape(1, 1) ; reshape needs a continuous matrix, clone to the make matrix continous

	; Check if data type of `category_mask` is correct.
	_AssertEqual($result_pixels.depth(), $CV_8U)

	; Loads ground truth segmentation file.
	Local $test_seg_image = _load_segmentation_mask($output_mask)

	_AssertTrue( _
			_similar_to_uint8_mask($category_mask, $test_seg_image, $similarity_threshold), _
			'Number of pixels in the candidate mask differing from that of the ' & _
			'ground truth mask exceeds ' & $similarity_threshold & '.')
EndFunc   ;==>test_segment_succeeds_with_category_mask

Func test_segment_succeeds_with_confidence_mask($model_file_type, $roi_format, $keypoint, $output_mask, $similarity_threshold)
	Local $base_options, $model_content

	; Creates segmenter.
	If $model_file_type == $FILE_NAME Then
		$base_options = $_BaseOptions(_Mediapipe_Params("model_asset_path", $model_path))
	ElseIf $model_file_type == $FILE_CONTENT Then
		$model_content = read_file_into_buffer($model_path)
		$base_options = $_BaseOptions(_Mediapipe_Params("model_asset_buffer", $model_content))
	EndIf

	Local $options = $_InteractiveSegmenterOptions(_Mediapipe_Params( _
			"base_options", $base_options, _
			"output_category_mask", False, _
			"output_confidence_masks", True _
			))
	Local $segmenter = $_InteractiveSegmenter.create_from_options($options)

	; Performs image segmentation on the input.
	Local $roi = $_RegionOfInterest(_Mediapipe_Params("format", $roi_format, "keypoint", $keypoint))
	Local $segmentation_result = $segmenter.segment($test_image, $roi)
	Local $confidence_masks = $segmentation_result.confidence_masks

	; Check if confidence mask shape is correct.
	_AssertLen( _
			$confidence_masks, _
			2, _
			'Number of confidence masks must match with number of categories.' _
			)


	; Loads ground truth segmentation file.
	Local $expected_mask = _load_segmentation_mask($output_mask)

	_AssertTrue( _
			_similar_to_float_mask( _
			$confidence_masks(1), $expected_mask, $similarity_threshold _
			) _
			)
EndFunc   ;==>test_segment_succeeds_with_confidence_mask

Func test_segment_succeeds_with_rotation()
	; Creates segmenter.
	Local $base_options = $_BaseOptions(_Mediapipe_Params("model_asset_path", $model_path))
	Local $roi = $_RegionOfInterest(_Mediapipe_Params( _
			"format", $_RegionOfInterest_Format.KEYPOINT, _
			"keypoint", $_NormalizedKeypoint(0.66, 0.66) _
			))

	; Run segmentation on the model in CONFIDENCE_MASK mode.
	Local $options = $_InteractiveSegmenterOptions(_Mediapipe_Params( _
			"base_options", $base_options, _
			"output_category_mask", False, _
			"output_confidence_masks", True _
			))

	Local $segmenter = $_InteractiveSegmenter.create_from_options($options)

	; Perform segmentation
	Local $image_processing_options = $_ImageProcessingOptions(_Mediapipe_Params("rotation_degrees", -90))
	Local $segmentation_result = $segmenter.segment($test_image, $roi, $image_processing_options)
	Local $confidence_masks = $segmentation_result.confidence_masks

	; Check if confidence mask shape is correct.
	_AssertLen( _
			$confidence_masks, _
			2, _
			'Number of confidence masks must match with number of categories.' _
			)
EndFunc   ;==>test_segment_succeeds_with_rotation

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

Func _similar_to_uint8_mask($actual_mask, $expected_mask, $similarity_threshold)
	Local $actual_mask_pixels = $actual_mask.mat_view().convertTo(-1, Null, $_MASK_MAGNIFICATION_FACTOR)
	Local $expected_mask_pixels = $expected_mask.mat_view()
	Return _AssertMatAlmostEqual($actual_mask_pixels, $expected_mask_pixels, Default, $similarity_threshold)
EndFunc   ;==>_similar_to_uint8_mask

Func _OnAutoItExit()
	_OpenCV_Close()
	_Mediapipe_Close()
EndFunc   ;==>_OnAutoItExit
