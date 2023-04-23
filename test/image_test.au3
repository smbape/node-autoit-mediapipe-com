#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Change2CUI=y
#AutoIt3Wrapper_Au3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#include "..\autoit-mediapipe-com\udf\mediapipe_udf_utils.au3"
#include "..\autoit-opencv-com\udf\opencv_udf_utils.au3"
#include "_assert.au3"
#include "_mat_utils.au3"

;~ Sources:
;~     https://github.com/google/mediapipe/blob/v0.9.3.0/mediapipe/python/image_test.py

_Mediapipe_Open(_Mediapipe_FindDLL("opencv_world470*"), _Mediapipe_FindDLL("autoit_mediapipe_com-*-470*"))
_OpenCV_Open(_OpenCV_FindDLL("opencv_world470*"), _OpenCV_FindDLL("autoit_opencv_com470*"))
OnAutoItExitRegister("_OnAutoItExit")

_Mediapipe_SetResourceDir()

Global $cv = _OpenCV_get()

Global $download_utils = _Mediapipe_ObjCreate("mediapipe.autoit.solutions.download_utils")
_AssertIsObj($download_utils, "Failed to load mediapipe.autoit.solutions.download_utils")

Global Const $_image = _Mediapipe_ObjCreate("mediapipe.autoit._framework_bindings.image")
_AssertIsObj($_image, "Failed to load mediapipe.autoit._framework_bindings.image")

Global Const $Image = $_image.Image
_AssertIsObj($Image, "Failed to load image.Image")

Test()

Func Test()
	test_create_image_from_gray_cv_mat()
	test_create_image_from_rgb_cv_mat()
	test_create_image_from_rgb48_cv_mat()
	test_image_mat_view_with_contiguous_data()
	test_image_mat_view_with_non_contiguous_data()
	test_image_create_from_cvmat()
EndFunc   ;==>Test

Func test_create_image_from_gray_cv_mat()
	Local $w = Floor(Random(3, 100))
	Local $h = Floor(Random(3, 100))
	Local $mat = _RandomImage($w, $h, $CV_8UC1, 0, 2 ^ 8)
	_AssertEqual($mat.rows, $h)
	_AssertEqual($mat.cols, $w)

	Local $gray8_image, $gray8_image_mat

	; specify the image format
	$gray8_image = $Image($MEDIAPIPE_IMAGE_FORMAT_GRAY8, $mat)
	$gray8_image_mat = $gray8_image.mat_view()
	_AssertMatEqual($mat, $gray8_image_mat)

	; by default, image frame should be a copy or mat
	$mat(2, 2) = 42
	$gray8_image_mat(2, 2) = 43
	_AssertEqual(43, $gray8_image_mat(2, 2))
	_AssertEqual(42, $mat(2, 2))

	; infer format from mat
	$gray8_image = $Image($mat)
	$gray8_image_mat = $gray8_image.mat_view()
	_AssertMatEqual($mat, $gray8_image_mat)

	; by default, image frame should be a copy or mat
	$mat(2, 2) = 42
	$gray8_image_mat(2, 2) = 43
	_AssertEqual(42, $mat(2, 2))
	_AssertEqual(43, $gray8_image_mat(2, 2))

EndFunc   ;==>test_create_image_from_gray_cv_mat

Func test_create_image_from_rgb_cv_mat()
	Local $w = 46 ; Floor(Random(3, 100))
	Local $h = 52 ; Floor(Random(3, 100))
	Local $channels = 3
	Local $mat = _RandomImage($w, $h, CV_MAKETYPE($CV_8U, $channels), 0, 2 ^ 8)

	; OpenCV color space is BGR by default
	; convert it to RGB as expected by mediapipe
	$mat = $cv.cvtColor($mat, $CV_COLOR_BGR2RGB)

	_MatSetAt($mat, "byte", 2, 2, 1, 42)

	Local $rgb_image, $rgb_image_mat

	; specify the image format
	$rgb_image = $Image($MEDIAPIPE_IMAGE_FORMAT_SRGB, $mat)
	$rgb_image_mat = $rgb_image.mat_view()
	_AssertMatEqual($mat, $rgb_image_mat)

	; by default, image frame should be a copy or mat
	_MatSetAt($mat, "byte", 2, 2, 1, 42)
	_MatSetAt($rgb_image_mat, "byte", 2, 2, 1, 43)
	_AssertEqual(42, _MatGetAt($mat, "byte", 2, 2, 1))
	_AssertEqual(43, _MatGetAt($rgb_image_mat, "byte", 2, 2, 1))

	; infer format from mat
	$rgb_image = $Image($mat)
	$rgb_image_mat = $rgb_image.mat_view()
	_AssertMatEqual($mat, $rgb_image_mat)

	; by default, image frame should be a copy or mat
	_MatSetAt($mat, "byte", 2, 2, 1, 42)
	_MatSetAt($rgb_image_mat, "byte", 2, 2, 1, 43)
	_AssertEqual(42, _MatGetAt($mat, "byte", 2, 2, 1))
	_AssertEqual(43, _MatGetAt($rgb_image_mat, "byte", 2, 2, 1))
EndFunc   ;==>test_create_image_from_rgb_cv_mat

Func test_create_image_from_rgb48_cv_mat()
	Local $w = Floor(Random(3, 100))
	Local $h = Floor(Random(3, 100))
	Local $channels = 3
	Local $mat = _RandomImage($w, $h, CV_MAKETYPE($CV_16U, $channels), 0, 2 ^ 16)

	; OpenCV color space is BGR by default
	; convert it to RGB as expected by mediapipe
	$mat = $cv.cvtColor($mat, $CV_COLOR_BGR2RGB)

	_MatSetAt($mat, "ushort", 2, 2, 1, 42)

	Local $rgb48_image, $rgb48_image_mat

	; specify the image format
	$rgb48_image = $Image($MEDIAPIPE_IMAGE_FORMAT_SRGB48, $mat)
	$rgb48_image_mat = $rgb48_image.mat_view()
	_AssertMatEqual($mat, $rgb48_image_mat)

	; by default, image frame should be a copy or mat
	_MatSetAt($mat, "ushort", 2, 2, 1, 42)
	_MatSetAt($rgb48_image_mat, "ushort", 2, 2, 1, 43)
	_AssertEqual(42, _MatGetAt($mat, "ushort", 2, 2, 1))
	_AssertEqual(43, _MatGetAt($rgb48_image_mat, "ushort", 2, 2, 1))

	; infer format from mat
	$rgb48_image = $Image($mat)
	$rgb48_image_mat = $rgb48_image.mat_view()
	_AssertMatEqual($mat, $rgb48_image_mat)

	; by default, image frame should be a copy or mat
	_MatSetAt($mat, "ushort", 2, 2, 1, 42)
	_MatSetAt($rgb48_image_mat, "ushort", 2, 2, 1, 43)
	_AssertEqual(42, _MatGetAt($mat, "ushort", 2, 2, 1))
	_AssertEqual(43, _MatGetAt($rgb48_image_mat, "ushort", 2, 2, 1))
EndFunc   ;==>test_create_image_from_rgb48_cv_mat

; For image frames that store contiguous data, the output of mat_view()
; points to the pixel data of the original image frame object.
Func test_image_mat_view_with_contiguous_data()
	Local $w = 640
	Local $h = 480
	Local $mat = _RandomImage($w, $h, $CV_8UC3, 0, 2 ^ 8)

	Local $rgb_image = $Image($MEDIAPIPE_IMAGE_FORMAT_SRGB, $mat)

	_AssertTrue($rgb_image.is_contiguous(), "image frame data should be contiguous")

	; Get 2 data array objects and verify that the image frame's data is the same
	Local $np_view = $rgb_image.mat_view()
	_AssertEqual(Ptr($rgb_image.data), Ptr($np_view.data))

	Local $np_view2 = $rgb_image.mat_view()
	_AssertEqual(Ptr($rgb_image.data), Ptr($np_view2.data))
EndFunc   ;==>test_image_mat_view_with_contiguous_data

; For image frames that store non contiguous data, the output of mat_view()
; points to the pixel data of the original image frame object.
Func test_image_mat_view_with_non_contiguous_data()
	Local $w = 641
	Local $h = 481
	Local $mat = _RandomImage($w, $h, $CV_8UC3, 0, 2 ^ 8)

	Local $rgb_image = $Image($MEDIAPIPE_IMAGE_FORMAT_SRGB, $mat)

	_AssertFalse($rgb_image.is_contiguous(), "image frame data should not be contiguous")

	; Get 2 data array objects and verify that the image frame's data is the same
	Local $np_view = $rgb_image.mat_view()
	_AssertEqual(Ptr($rgb_image.data), Ptr($np_view.data))

	Local $np_view2 = $rgb_image.mat_view()
	_AssertEqual(Ptr($rgb_image.data), Ptr($np_view2.data))
EndFunc   ;==>test_image_mat_view_with_non_contiguous_data

Func test_image_create_from_cvmat()
	$download_utils.download( _
			"https://github.com/tensorflow/tfjs-models/raw/master/hand-pose-detection/test_data/hands.jpg", _
			@ScriptDir & "/solutions/testdata/hands.jpg" _
			)

	Local $image_path = @ScriptDir & "/solutions/testdata/hands.jpg"

	Local $mat = $cv.imread($image_path)
	$mat = $cv.cvtColor($mat, $CV_COLOR_BGR2RGB)
	Local $rgb_image = $Image($MEDIAPIPE_IMAGE_FORMAT_SRGB, $mat)
	_AssertEqual($rgb_image.width, 720)
	_AssertEqual($rgb_image.height, 382)
	_AssertEqual($rgb_image.channels, 3)
	_AssertEqual($rgb_image.image_format, $MEDIAPIPE_IMAGE_FORMAT_SRGB)
	_AssertMatEqual($mat, $rgb_image.mat_view())
EndFunc   ;==>test_image_create_from_cvmat

Func _OnAutoItExit()
	_OpenCV_Close()
	_Mediapipe_Close()
EndFunc   ;==>_OnAutoItExit
