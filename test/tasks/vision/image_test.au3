#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Change2CUI=y
#AutoIt3Wrapper_Au3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

;~ Sources:
;~     https://github.com/google-ai-edge/mediapipe/blob/v0.10.35/mediapipe/python/image_test.py
;~     https://github.com/google-ai-edge/mediapipe/blob/v0.10.35/mediapipe/tasks/python/test/vision/image_test.py

#include "..\..\..\autoit-mediapipe-com\udf\mediapipe_udf_utils.au3"
#include "..\..\..\autoit-opencv-com\udf\opencv_udf_utils.au3"
#include "..\..\_assert.au3"
#include "..\..\_mat_utils.au3"
#include "..\..\_test_utils.au3"

_Mediapipe_Open(_Mediapipe_FindDLL("opencv_world4130*"), _Mediapipe_FindDLL("autoit_mediapipe_com-*-4130*"))
_OpenCV_Open(_OpenCV_FindDLL("opencv_world4130*"), _OpenCV_FindDLL("autoit_opencv_com4130*"))
OnAutoItExitRegister("_OnAutoItExit")

Global Const $cv = _OpenCV_get()
_AssertIsObj($cv, "Failed to load opencv")

Global Const $download_utils = _Mediapipe_ObjCreate("mediapipe.tasks.autoit.core.download_utils")
_AssertIsObj($download_utils, "Failed to load mediapipe.tasks.autoit.core.download_utils")

Global Const $_image = _Mediapipe_ObjCreate("mediapipe.tasks.autoit.vision.core.image")
_AssertIsObj($_image, "Failed to load mediapipe.tasks.autoit.vision.core.image")

Global Const $Image = $_image.Image
_AssertIsObj($Image, "Failed to load image.Image")

Global Const $_IMAGE_FILE = 'portrait.jpg'

Global $test_image_path


ImageTest()


Func ImageTest()
	ImageTest_setUp()

	test_create_image_from_gray_cv_mat()
	test_create_image_from_rgb_cv_mat()
	test_create_image_from_rgb48_cv_mat()
	test_image_mat_view_with_contiguous_data()
	test_image_mat_view_with_non_contiguous_data()
	test_create_from_cvmat()
	test_create_from_file()
EndFunc   ;==>ImageTest


Func ImageTest_setUp()
	Local Const $_TEST_DATA_DIR = _Mediapipe_FindResourceDir() & "\mediapipe\tasks\testdata\vision"
	Local $url, $file_path

	Local $test_files[] = [ _
			$_IMAGE_FILE _
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

	$test_image_path = get_test_data_path($_IMAGE_FILE)
EndFunc


Func test_create_image_from_gray_cv_mat()
	ConsoleWrite('"' & @ScriptFullPath & '" @@ Debug(' & @ScriptLineNumber & ') : test_create_image_from_gray_cv_mat' & @CRLF) ;### Debug Console

	Local $w = Floor(Random(3, 100))
	Local $h = Floor(Random(3, 100))
	Local $cv_image = _RandomImage($w, $h, $CV_8UC1, 0, 2 ^ 8)
	_AssertEqual($cv_image.rows, $h)
	_AssertEqual($cv_image.cols, $w)

	Local $gray8_image, $gray8_image_mat

	; specify the image format
	$gray8_image = $Image($MEDIAPIPE_IMAGE_FORMAT_GRAY8, $cv_image)
	$gray8_image_mat = $gray8_image.mat_view()
	_AssertMatEqual($cv_image, $gray8_image_mat)

	; by default, image frame should be a copy or mat
	$cv_image(2, 2) = 42
	$gray8_image_mat(2, 2) = 43
	_AssertEqual(43, $gray8_image_mat(2, 2))
	_AssertEqual(42, $cv_image(2, 2))

	; infer format from mat
	$gray8_image = $Image($cv_image)
	$gray8_image_mat = $gray8_image.mat_view()
	_AssertMatEqual($cv_image, $gray8_image_mat)

	; by default, image frame should be a copy or mat
	$cv_image(2, 2) = 42
	$gray8_image_mat(2, 2) = 43
	_AssertEqual(42, $cv_image(2, 2))
	_AssertEqual(43, $gray8_image_mat(2, 2))

EndFunc   ;==>test_create_image_from_gray_cv_mat

Func test_create_image_from_rgb_cv_mat()
	ConsoleWrite('"' & @ScriptFullPath & '" @@ Debug(' & @ScriptLineNumber & ') : test_create_image_from_rgb_cv_mat' & @CRLF) ;### Debug Console

	Local $w = 46 ; Floor(Random(3, 100))
	Local $h = 52 ; Floor(Random(3, 100))
	Local $channels = 3
	Local $cv_image = _RandomImage($w, $h, CV_MAKETYPE($CV_8U, $channels), 0, 2 ^ 8)

	; OpenCV color space is BGR by default
	; convert it to RGB as expected by mediapipe
	$cv_image = $cv.cvtColor($cv_image, $CV_COLOR_BGR2RGB)

	_MatSetAt($cv_image, "byte", 2, 2, 1, 42)

	Local $rgb_image, $rgb_image_mat

	; specify the image format
	$rgb_image = $Image($MEDIAPIPE_IMAGE_FORMAT_SRGB, $cv_image)
	$rgb_image_mat = $rgb_image.mat_view()
	_AssertMatEqual($cv_image, $rgb_image_mat)

	; by default, image frame should be a copy or mat
	_MatSetAt($cv_image, "byte", 2, 2, 1, 42)
	_MatSetAt($rgb_image_mat, "byte", 2, 2, 1, 43)
	_AssertEqual(42, _MatGetAt($cv_image, "byte", 2, 2, 1))
	_AssertEqual(43, _MatGetAt($rgb_image_mat, "byte", 2, 2, 1))

	; infer format from mat
	$rgb_image = $Image($cv_image)
	$rgb_image_mat = $rgb_image.mat_view()
	_AssertMatEqual($cv_image, $rgb_image_mat)

	; by default, image frame should be a copy or mat
	_MatSetAt($cv_image, "byte", 2, 2, 1, 42)
	_MatSetAt($rgb_image_mat, "byte", 2, 2, 1, 43)
	_AssertEqual(42, _MatGetAt($cv_image, "byte", 2, 2, 1))
	_AssertEqual(43, _MatGetAt($rgb_image_mat, "byte", 2, 2, 1))
EndFunc   ;==>test_create_image_from_rgb_cv_mat

Func test_create_image_from_rgb48_cv_mat()
	ConsoleWrite('"' & @ScriptFullPath & '" @@ Debug(' & @ScriptLineNumber & ') : test_create_image_from_rgb48_cv_mat' & @CRLF) ;### Debug Console

	Local $w = Floor(Random(3, 100))
	Local $h = Floor(Random(3, 100))
	Local $channels = 3
	Local $cv_image = _RandomImage($w, $h, CV_MAKETYPE($CV_16U, $channels), 0, 2 ^ 16)

	; OpenCV color space is BGR by default
	; convert it to RGB as expected by mediapipe
	$cv_image = $cv.cvtColor($cv_image, $CV_COLOR_BGR2RGB)

	_MatSetAt($cv_image, "ushort", 2, 2, 1, 42)

	Local $rgb48_image, $rgb48_image_mat

	; specify the image format
	$rgb48_image = $Image($MEDIAPIPE_IMAGE_FORMAT_SRGB48, $cv_image)
	$rgb48_image_mat = $rgb48_image.mat_view()
	_AssertMatEqual($cv_image, $rgb48_image_mat)

	; by default, image frame should be a copy or mat
	_MatSetAt($cv_image, "ushort", 2, 2, 1, 42)
	_MatSetAt($rgb48_image_mat, "ushort", 2, 2, 1, 43)
	_AssertEqual(42, _MatGetAt($cv_image, "ushort", 2, 2, 1))
	_AssertEqual(43, _MatGetAt($rgb48_image_mat, "ushort", 2, 2, 1))

	; infer format from mat
	$rgb48_image = $Image($cv_image)
	$rgb48_image_mat = $rgb48_image.mat_view()
	_AssertMatEqual($cv_image, $rgb48_image_mat)

	; by default, image frame should be a copy or mat
	_MatSetAt($cv_image, "ushort", 2, 2, 1, 42)
	_MatSetAt($rgb48_image_mat, "ushort", 2, 2, 1, 43)
	_AssertEqual(42, _MatGetAt($cv_image, "ushort", 2, 2, 1))
	_AssertEqual(43, _MatGetAt($rgb48_image_mat, "ushort", 2, 2, 1))
EndFunc   ;==>test_create_image_from_rgb48_cv_mat

; For image frames that store contiguous data, the output of mat_view()
; points to the pixel data of the original image frame object.
Func test_image_mat_view_with_contiguous_data()
	ConsoleWrite('"' & @ScriptFullPath & '" @@ Debug(' & @ScriptLineNumber & ') : test_image_mat_view_with_contiguous_data' & @CRLF) ;### Debug Console

	Local $w = 640
	Local $h = 480
	Local $cv_image = _RandomImage($w, $h, $CV_8UC3, 0, 2 ^ 8)

	Local $rgb_image = $Image($MEDIAPIPE_IMAGE_FORMAT_SRGB, $cv_image)

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
	ConsoleWrite('"' & @ScriptFullPath & '" @@ Debug(' & @ScriptLineNumber & ') : test_image_mat_view_with_non_contiguous_data' & @CRLF) ;### Debug Console

	Local $w = 641
	Local $h = 481
	Local $cv_image = _RandomImage($w, $h, $CV_8UC3, 0, 2 ^ 8)

	Local $rgb_image = $Image($MEDIAPIPE_IMAGE_FORMAT_SRGB, $cv_image)

	_AssertFalse($rgb_image.is_contiguous(), "image frame data should not be contiguous")

	; Get 2 data array objects and verify that the image frame's data is the same
	Local $np_view = $rgb_image.mat_view()
	_AssertEqual(Ptr($rgb_image.data), Ptr($np_view.data))

	Local $np_view2 = $rgb_image.mat_view()
	_AssertEqual(Ptr($rgb_image.data), Ptr($np_view2.data))
EndFunc   ;==>test_image_mat_view_with_non_contiguous_data

Func test_create_from_cvmat()
	ConsoleWrite('"' & @ScriptFullPath & '" @@ Debug(' & @ScriptLineNumber & ') : test_create_from_cvmat' & @CRLF) ;### Debug Console

	Local $cv_image = $cv.cvtColor($cv.imread($test_image_path), $CV_COLOR_BGR2RGB)
	Local $img = $Image($MEDIAPIPE_IMAGE_FORMAT_SRGB, $cv_image)
	; portrait.jpg is 820x1024, 3 channels (SRGB)
	_AssertEqual($img.width, 820)
	_AssertEqual($img.height, 1024)
	_AssertEqual($img.channels, 3)
	_AssertEqual($img.image_format, $MEDIAPIPE_IMAGE_FORMAT_SRGB)
	_AssertMatEqual($cv_image, $img.mat_view())
EndFunc   ;==>test_create_from_cvmat

Func test_create_from_file()
	ConsoleWrite('"' & @ScriptFullPath & '" @@ Debug(' & @ScriptLineNumber & ') : test_create_from_file' & @CRLF) ;### Debug Console

	Local $cv_image = $cv.cvtColor($cv.imread($test_image_path), $CV_COLOR_BGR2RGB)
	Local $img = $Image.create_from_file($test_image_path)
	; portrait.jpg is 820x1024, 3 channels (SRGB)
	_AssertEqual($img.width, 820)
	_AssertEqual($img.height, 1024)
	_AssertEqual($img.channels, 3)
	_AssertEqual($img.image_format, $MEDIAPIPE_IMAGE_FORMAT_SRGB)
	_AssertMatAlmostEqual($cv_image, $img.mat_view(), Default, 0.957680306)
EndFunc   ;==>test_create_from_file

Func _OnAutoItExit()
	_OpenCV_Close()
	_Mediapipe_Close()
EndFunc   ;==>_OnAutoItExit
