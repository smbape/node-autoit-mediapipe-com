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
;~     https://github.com/google/mediapipe/blob/v0.9.3.0/mediapipe/tasks/python/test/vision/interactive_segmenter_test.py

_Mediapipe_Open(_Mediapipe_FindDLL("opencv_world470*"), _Mediapipe_FindDLL("autoit_mediapipe_com-*-470*"))
_OpenCV_Open(_OpenCV_FindDLL("opencv_world470*"), _OpenCV_FindDLL("autoit_opencv_com470*"))
OnAutoItExitRegister("_OnAutoItExit")

_Mediapipe_SetResourceDir()

Global $download_utils = _Mediapipe_ObjCreate("mediapipe.autoit.solutions.download_utils")
_AssertIsObj($download_utils, "Failed to load mediapipe.autoit.solutions.download_utils")

Global $image_module = _Mediapipe_ObjCreate("mediapipe.autoit._framework_bindings.image")
_AssertIsObj($image_module, "Failed to load mediapipe.autoit._framework_bindings.image")

Global $image_frame = _Mediapipe_ObjCreate("mediapipe.autoit._framework_bindings.image_frame")
_AssertIsObj($image_frame, "Failed to load mediapipe.autoit._framework_bindings.image_frame")

Global $keypoint_module = _Mediapipe_ObjCreate("mediapipe.tasks.autoit.components.containers.keypoint")
_AssertIsObj($keypoint_module, "Failed to load mediapipe.tasks.autoit.components.containers.keypoint")

Global $rect = _Mediapipe_ObjCreate("mediapipe.tasks.autoit.components.containers.rect")
_AssertIsObj($rect, "Failed to load mediapipe.tasks.autoit.components.containers.rect")

Global $base_options_module = _Mediapipe_ObjCreate("mediapipe.tasks.autoit.core.base_options")
_AssertIsObj($base_options_module, "Failed to load mediapipe.tasks.autoit.core.base_options")

Global $interactive_segmenter = _Mediapipe_ObjCreate("mediapipe.tasks.autoit.vision.interactive_segmenter")
_AssertIsObj($interactive_segmenter, "Failed to load mediapipe.tasks.autoit.vision.interactive_segmenter")

Global $image_processing_options_module = _Mediapipe_ObjCreate("mediapipe.tasks.autoit.vision.core.image_processing_options")
_AssertIsObj($image_processing_options_module, "Failed to load mediapipe.tasks.autoit.vision.core.image_processing_options")

Global $_BaseOptions = $base_options_module.BaseOptions
Global $_Image = $image_module.Image
Global $_ImageFormat = $image_frame.ImageFormat
Global $_NormalizedKeypoint = $keypoint_module.NormalizedKeypoint
Global $_Rect = $rect.Rect
Global $_OutputType = $interactive_segmenter.InteractiveSegmenterOptions_OutputType
Global $_InteractiveSegmenter = $interactive_segmenter.InteractiveSegmenter
Global $_InteractiveSegmenterOptions = $interactive_segmenter.InteractiveSegmenterOptions
Global $_RegionOfInterest = $interactive_segmenter.RegionOfInterest
Global $_Format = $interactive_segmenter.RegionOfInterest.Format
Global $_ImageProcessingOptions = $image_processing_options_module.ImageProcessingOptions

Global $_MODEL_FILE = 'ptm_512_hdt_ptm_woid.tflite'
Global $_CATS_AND_DOGS = 'cats_and_dogs.jpg'
Global $_CATS_AND_DOGS_MASK_DOG_1 = 'cats_and_dogs_mask_dog1.png'
Global $_CATS_AND_DOGS_MASK_DOG_2 = 'cats_and_dogs_mask_dog2.png'
Global $_MASK_MAGNIFICATION_FACTOR = 255
Global $_MASK_SIMILARITY_THRESHOLD = 0.97

Global $FILE_CONTENT = 1
Global $FILE_NAME = 2

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
		$url = "https://storage.googleapis.com/mediapipe-assets/" & $name
		$file_path = $_TEST_DATA_DIR & "\" & $name
		If Not FileExists(get_test_data_path($name)) Then
			$download_utils.download($url, $file_path)
		EndIf
	Next

	$test_image = $_Image.create_from_file(get_test_data_path($_CATS_AND_DOGS))
	$test_seg_image = $_Image.create_from_file(get_test_data_path($_CATS_AND_DOGS_MASK_DOG_1))
	$model_path = get_test_data_path($_MODEL_FILE)
EndFunc   ;==>Test

Func _OnAutoItExit()
	_OpenCV_Close()
	_Mediapipe_Close()
EndFunc   ;==>_OnAutoItExit
