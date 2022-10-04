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

$_mediapipe_build_type = "Release"
$_mediapipe_debug = 0
$_cv_build_type = "Release"
$_cv_debug = 0
_Mediapipe_Open_And_Register(_Mediapipe_FindDLL("opencv_world4*", "opencv-4.*\opencv"), _Mediapipe_FindDLL("autoit_mediapipe_com-*"))
_OpenCV_Open_And_Register(_OpenCV_FindDLL("opencv_world4*", "opencv-4.*\opencv"), _OpenCV_FindDLL("autoit_opencv_com4*"))
OnAutoItExitRegister("_OnAutoItExit")

Global Const $image_frame = _Mediapipe_ObjCreate("mediapipe.autoit._framework_bindings.image_frame")
_AssertTrue(IsObj($image_frame), "Failed to load mediapipe.autoit._framework_bindings.image_frame")

Global Const $ImageFrame = $image_frame.ImageFrame
_AssertTrue(IsObj($ImageFrame), "Failed to load image_frame.ImageFrame")

Test()

Func Test()
	Local Const $cv = _OpenCV_get()
	_AssertTrue(IsObj($cv), "Failed to load opencv")

	test_create_image_frame_from_gray_cv_mat($ImageFrame)
	test_create_image_frame_from_rgb_cv_mat($ImageFrame)
	test_create_image_frame_from_rgb48_cv_mat($ImageFrame)
	test_image_frame_mat_view_with_contiguous_data($ImageFrame)
	test_image_frame_numpy_view_with_non_contiguous_data($ImageFrame)
EndFunc   ;==>Test

Func test_create_image_frame_from_gray_cv_mat($ImageFrame)
	Local $w = Floor(Random(3, 100))
	Local $h = Floor(Random(3, 100))
	Local $mat = _RandomImage($w, $h, $CV_8UC1, 0, 2 ^ 8)
	_AssertEqual($mat.rows, $h)
	_AssertEqual($mat.cols, $w)

	Local $gray8_image_frame, $gray8_image_frame_mat

	; specify the image format
	$gray8_image_frame = $ImageFrame($MEDIAPIPE_IMAGE_FORMAT_GRAY8, $mat)
	$gray8_image_frame_mat = $gray8_image_frame.mat_view()
	_AssertMatEqual($mat, $gray8_image_frame_mat)

	; by default, image frame should be a copy or mat
	$mat(2, 2) = 42
	$gray8_image_frame_mat(2, 2) = 43
	_AssertEqual(43, $gray8_image_frame_mat(2, 2))
	_AssertEqual(42, $mat(2, 2))

	; infer format from mat
	$gray8_image_frame = $ImageFrame($mat)
	_AssertEqual($gray8_image_frame.image_format, $MEDIAPIPE_IMAGE_FORMAT_GRAY8)
	$gray8_image_frame_mat = $gray8_image_frame.mat_view()
	_AssertMatEqual($mat, $gray8_image_frame_mat)

	; by default, image frame should be a copy or mat
	$mat(2, 2) = 42
	$gray8_image_frame_mat(2, 2) = 43
	_AssertEqual(42, $mat(2, 2))
	_AssertEqual(43, $gray8_image_frame_mat(2, 2))

EndFunc   ;==>test_create_image_frame_from_gray_cv_mat

Func test_create_image_frame_from_rgb_cv_mat($ImageFrame)
	Local $w = 46 ; Floor(Random(3, 100))
	Local $h = 52 ; Floor(Random(3, 100))
	Local $channels = 3
	Local $mat = _RandomImage($w, $h, CV_MAKETYPE($CV_8U, $channels), 0, 2 ^ 8)

	; OpenCV color space is BGR by default
	; convert it to RGB as expected by mediapipe
	Local Const $cv = _OpenCV_get()
	$mat = $cv.cvtColor($mat, $CV_COLOR_BGR2RGB)

	_MatSetAt($mat, "byte", 2, 2, 1, 42)

	Local $rgb_image_frame, $rgb_image_frame_mat

	; specify the image format
	$rgb_image_frame = $ImageFrame($MEDIAPIPE_IMAGE_FORMAT_SRGB, $mat)
	$rgb_image_frame_mat = $rgb_image_frame.mat_view()
	_AssertMatEqual($mat, $rgb_image_frame_mat)

	; by default, image frame should be a copy or mat
	_MatSetAt($mat, "byte", 2, 2, 1, 42)
	_MatSetAt($rgb_image_frame_mat, "byte", 2, 2, 1, 43)
	_AssertEqual(42, _MatGetAt($mat, "byte", 2, 2, 1))
	_AssertEqual(43, _MatGetAt($rgb_image_frame_mat, "byte", 2, 2, 1))

	; infer format from mat
	$rgb_image_frame = $ImageFrame($mat)
	_AssertEqual($rgb_image_frame.image_format, $MEDIAPIPE_IMAGE_FORMAT_SRGB)
	$rgb_image_frame_mat = $rgb_image_frame.mat_view()
	_AssertMatEqual($mat, $rgb_image_frame_mat)

	; by default, image frame should be a copy or mat
	_MatSetAt($mat, "byte", 2, 2, 1, 42)
	_MatSetAt($rgb_image_frame_mat, "byte", 2, 2, 1, 43)
	_AssertEqual(42, _MatGetAt($mat, "byte", 2, 2, 1))
	_AssertEqual(43, _MatGetAt($rgb_image_frame_mat, "byte", 2, 2, 1))
EndFunc   ;==>test_create_image_frame_from_rgb_cv_mat

Func test_create_image_frame_from_rgb48_cv_mat($ImageFrame)
	Local $w = Floor(Random(3, 100))
	Local $h = Floor(Random(3, 100))
	Local $channels = 3
	Local $mat = _RandomImage($w, $h, CV_MAKETYPE($CV_16U, $channels), 0, 2 ^ 16)

	; OpenCV color space is BGR by default
	; convert it to RGB as expected by mediapipe
	Local Const $cv = _OpenCV_get()
	$mat = $cv.cvtColor($mat, $CV_COLOR_BGR2RGB)

	_MatSetAt($mat, "ushort", 2, 2, 1, 42)

	Local $rgb48_image_frame, $rgb48_image_frame_mat

	; specify the image format
	$rgb48_image_frame = $ImageFrame($MEDIAPIPE_IMAGE_FORMAT_SRGB48, $mat)
	$rgb48_image_frame_mat = $rgb48_image_frame.mat_view()
	_AssertMatEqual($mat, $rgb48_image_frame_mat)

	; by default, image frame should be a copy or mat
	_MatSetAt($mat, "ushort", 2, 2, 1, 42)
	_MatSetAt($rgb48_image_frame_mat, "ushort", 2, 2, 1, 43)
	_AssertEqual(42, _MatGetAt($mat, "ushort", 2, 2, 1))
	_AssertEqual(43, _MatGetAt($rgb48_image_frame_mat, "ushort", 2, 2, 1))

	; infer format from mat
	$rgb48_image_frame = $ImageFrame($mat)
	_AssertEqual($rgb48_image_frame.image_format, $MEDIAPIPE_IMAGE_FORMAT_SRGB48)
	$rgb48_image_frame_mat = $rgb48_image_frame.mat_view()
	_AssertMatEqual($mat, $rgb48_image_frame_mat)

	; by default, image frame should be a copy or mat
	_MatSetAt($mat, "ushort", 2, 2, 1, 42)
	_MatSetAt($rgb48_image_frame_mat, "ushort", 2, 2, 1, 43)
	_AssertEqual(42, _MatGetAt($mat, "ushort", 2, 2, 1))
	_AssertEqual(43, _MatGetAt($rgb48_image_frame_mat, "ushort", 2, 2, 1))
EndFunc   ;==>test_create_image_frame_from_rgb48_cv_mat

; For image frames that store contiguous data, the output of mat_view()
; points to the pixel data of the original image frame object.
Func test_image_frame_mat_view_with_contiguous_data($ImageFrame)
	Local $w = 640
	Local $h = 480
	Local $mat = _RandomImage($w, $h, $CV_8UC3, 0, 2 ^ 8)

	Local $rgb_image_frame = $ImageFrame($MEDIAPIPE_IMAGE_FORMAT_SRGB, $mat)

	_AssertTrue($rgb_image_frame.is_contiguous(), "image frame data should be contiguous")

	; Get 2 data array objects and verify that the image frame's data is the same
	Local $np_view = $rgb_image_frame.mat_view()
	_AssertEqual(Ptr($rgb_image_frame.data), Ptr($np_view.data))

	Local $np_view2 = $rgb_image_frame.mat_view()
	_AssertEqual(Ptr($rgb_image_frame.data), Ptr($np_view2.data))
EndFunc   ;==>test_image_frame_mat_view_with_contiguous_data

; For image frames that store non contiguous data, the output of mat_view()
; points to the pixel data of the original image frame object.
Func test_image_frame_numpy_view_with_non_contiguous_data($ImageFrame)
	Local $w = 641
	Local $h = 481
	Local $mat = _RandomImage($w, $h, $CV_8UC3, 0, 2 ^ 8)

	Local $rgb_image_frame = $ImageFrame($MEDIAPIPE_IMAGE_FORMAT_SRGB, $mat)

	_AssertFalse($rgb_image_frame.is_contiguous(), "image frame data should not be contiguous")

	; Get 2 data array objects and verify that the image frame's data is the same
	Local $np_view = $rgb_image_frame.mat_view()
	_AssertEqual(Ptr($rgb_image_frame.data), Ptr($np_view.data))

	Local $np_view2 = $rgb_image_frame.mat_view()
	_AssertEqual(Ptr($rgb_image_frame.data), Ptr($np_view2.data))
EndFunc   ;==>test_image_frame_numpy_view_with_non_contiguous_data

Func _OnAutoItExit()
	_OpenCV_Unregister_And_Close()
	_Mediapipe_Unregister_And_Close()
EndFunc   ;==>_OnAutoItExit
