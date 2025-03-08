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
;~     https://github.com/google-ai-edge/mediapipe/blob/v0.10.14/mediapipe/tasks/python/test/vision/face_stylizer_test.py

_Mediapipe_Open(_Mediapipe_FindDLL("opencv_world4110*"), _Mediapipe_FindDLL("autoit_mediapipe_com-*-4110*"))
_OpenCV_Open(_OpenCV_FindDLL("opencv_world4110*"), _OpenCV_FindDLL("autoit_opencv_com4110*"))
OnAutoItExitRegister("_OnAutoItExit")

; Tell mediapipe where to look its resource files
_Mediapipe_SetResourceDir()

Global Const $download_utils = _Mediapipe_ObjCreate("mediapipe.autoit.solutions.download_utils")
_AssertIsObj($download_utils, "Failed to load mediapipe.autoit.solutions.download_utils")

Global Const $image_module = _Mediapipe_ObjCreate("mediapipe.autoit._framework_bindings.image")
_AssertIsObj($image_module, "Failed to load mediapipe.autoit._framework_bindings.image")

Global Const $rect_module = _Mediapipe_ObjCreate("mediapipe.tasks.autoit.components.containers.rect")
_AssertIsObj($rect_module, "Failed to load mediapipe.tasks.autoit.components.containers.rect")

Global Const $base_options_module = _Mediapipe_ObjCreate("mediapipe.tasks.autoit.core.base_options")
_AssertIsObj($base_options_module, "Failed to load mediapipe.tasks.autoit.core.base_options")

Global Const $face_stylizer = _Mediapipe_ObjCreate("mediapipe.tasks.autoit.vision.face_stylizer")
_AssertIsObj($face_stylizer, "Failed to load mediapipe.tasks.autoit.vision.face_stylizer")

Global Const $image_processing_options_module = _Mediapipe_ObjCreate("mediapipe.tasks.autoit.vision.core.image_processing_options")
_AssertIsObj($image_processing_options_module, "Failed to load mediapipe.tasks.autoit.vision.core.image_processing_options")

Global Const $_BaseOptions = $base_options_module.BaseOptions
Global Const $_Rect = $rect_module.Rect
Global Const $_Image = $image_module.Image
Global Const $_FaceStylizer = $face_stylizer.FaceStylizer
Global Const $_FaceStylizerOptions = $face_stylizer.FaceStylizerOptions
Global Const $_ImageProcessingOptions = $image_processing_options_module.ImageProcessingOptions

Global Const $_MODEL = "face_stylizer_color_ink.task"
Global Const $_LARGE_FACE_IMAGE = "portrait.jpg"
Global Const $_MODEL_IMAGE_SIZE = 256

Global Const $FILE_CONTENT = 1
Global Const $FILE_NAME = 2

Global $model_path

Test()

Func Test()
	Local Const $_TEST_DATA_DIR = _Mediapipe_FindResourceDir() & "\mediapipe\tasks\testdata\vision"
	Local $url, $file_path

	Local $test_files[] = [ _
			$_MODEL, _
			$_LARGE_FACE_IMAGE _
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

	$model_path = get_test_data_path($_MODEL)

	test_create_from_file_succeeds_with_valid_model_path()
	test_create_from_options_succeeds_with_valid_model_path()
	test_create_from_options_succeeds_with_valid_model_content()

	test_stylize($FILE_NAME, $_LARGE_FACE_IMAGE)
	test_stylize($FILE_CONTENT, $_LARGE_FACE_IMAGE)

	test_stylize_succeeds_with_region_of_interest()
	test_stylize_succeeds_with_no_face_detected()
EndFunc   ;==>Test

Func test_create_from_file_succeeds_with_valid_model_path()
	; Creates with default option and valid model file successfully.
	Local $stylizer = $_FaceStylizer.create_from_model_path($model_path)
	_AssertIsInstance($stylizer, $_FaceStylizer)
EndFunc   ;==>test_create_from_file_succeeds_with_valid_model_path

Func test_create_from_options_succeeds_with_valid_model_path()
	; Creates with options containing model file successfully.
	Local $base_options = $_BaseOptions(_Mediapipe_Params("model_asset_path", $model_path))
	Local $options = $_FaceStylizerOptions(_Mediapipe_Params("base_options", $base_options))
	Local $stylizer = $_FaceStylizer.create_from_options($options)
	_AssertIsInstance($stylizer, $_FaceStylizer)
EndFunc   ;==>test_create_from_options_succeeds_with_valid_model_path

Func test_create_from_options_succeeds_with_valid_model_content()
	; Creates with options containing model content successfully.
	Local $model_content = read_file_into_buffer($model_path)
	Local $base_options = $_BaseOptions(_Mediapipe_Params("model_asset_buffer", $model_content))
	Local $options = $_FaceStylizerOptions(_Mediapipe_Params("base_options", $base_options))
	Local $stylizer = $_FaceStylizer.create_from_options($options)
	_AssertIsInstance($stylizer, $_FaceStylizer)
EndFunc   ;==>test_create_from_options_succeeds_with_valid_model_content

Func test_stylize($model_file_type, $image_file_name)
	Local $base_options, $model_content

	; Creates stylizer.
	If $model_file_type == $FILE_NAME Then
		$base_options = $_BaseOptions(_Mediapipe_Params("model_asset_path", $model_path))
	ElseIf $model_file_type == $FILE_CONTENT Then
		$model_content = read_file_into_buffer($model_path)
		$base_options = $_BaseOptions(_Mediapipe_Params("model_asset_buffer", $model_content))
	EndIf

	Local $options = $_FaceStylizerOptions(_Mediapipe_Params("base_options", $base_options))
	Local $stylizer = $_FaceStylizer.create_from_options($options)

	; Load the test image.
	Local $test_image = $_Image.create_from_file(get_test_data_path($image_file_name))

	; Performs face stylization on the input.
	Local $stylized_image = $stylizer.stylize($test_image)
	_AssertIsInstance($stylized_image, $_Image)
EndFunc   ;==>test_stylize

Func test_stylize_succeeds_with_region_of_interest()
	; Creates stylizer.
	Local $base_options = $_BaseOptions(_Mediapipe_Params("model_asset_path", $model_path))
	Local $options = $_FaceStylizerOptions(_Mediapipe_Params("base_options", $base_options))
	Local $stylizer = $_FaceStylizer.create_from_options($options)

	; Load the test image.
	Local $test_image = $_Image.create_from_file(get_test_data_path($_LARGE_FACE_IMAGE))

	; Region-of-interest around the face.
	Local $roi = $_Rect(_Mediapipe_Params("left", 0.32, "top", 0.02, "right", 0.67, "bottom", 0.32))
	Local $image_processing_options = $_ImageProcessingOptions($roi)

	; Performs face stylization on the input.
	Local $stylized_image = $stylizer.stylize($test_image, $image_processing_options)
	_AssertIsInstance($stylized_image, $_Image)
	_AssertEqual($stylized_image.width, $_MODEL_IMAGE_SIZE)
	_AssertEqual($stylized_image.height, $_MODEL_IMAGE_SIZE)
EndFunc   ;==>test_stylize_succeeds_with_region_of_interest

Func test_stylize_succeeds_with_no_face_detected()
	; Creates stylizer.
	Local $base_options = $_BaseOptions(_Mediapipe_Params("model_asset_path", $model_path))
	Local $options = $_FaceStylizerOptions(_Mediapipe_Params("base_options", $base_options))
	Local $stylizer = $_FaceStylizer.create_from_options($options)

	; Load the test image.
	Local $test_image = $_Image.create_from_file(get_test_data_path($_LARGE_FACE_IMAGE))

	; Region-of-interest that doesn't contain a human face.
	Local $roi = $_Rect(_Mediapipe_Params("left", 0.1, "top", 0.1, "right", 0.2, "bottom", 0.2))
	Local $image_processing_options = $_ImageProcessingOptions($roi)

	; Performs face stylization on the input.
	Local $stylized_image = $stylizer.stylize($test_image, $image_processing_options)
	_AssertIsNone($stylized_image)
EndFunc   ;==>test_stylize_succeeds_with_no_face_detected

Func _OnAutoItExit()
	_OpenCV_Close()
	_Mediapipe_Close()
EndFunc   ;==>_OnAutoItExit
