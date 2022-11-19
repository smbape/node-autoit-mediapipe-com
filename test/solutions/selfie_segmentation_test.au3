#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Change2CUI=y
#AutoIt3Wrapper_Au3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#include "..\..\autoit-mediapipe-com\udf\mediapipe_udf_utils.au3"
#include "..\..\autoit-opencv-com\udf\opencv_udf_utils.au3"
#include "..\_assert.au3"
#include "..\_mat_utils.au3"

;~ Sources:
;~     https://github.com/google/mediapipe/blob/v0.8.11/mediapipe/python/solutions/selfie_segmentation_test.py

$_mediapipe_build_type = "Release"
$_mediapipe_debug = 0
$_cv_build_type = "Release"
$_cv_debug = 0
_Mediapipe_Open_And_Register(_Mediapipe_FindDLL("opencv_world4*", "opencv-4.*\opencv"), _Mediapipe_FindDLL("autoit_mediapipe_com-*"))
_OpenCV_Open_And_Register(_OpenCV_FindDLL("opencv_world4*", "opencv-4.*\opencv"), _OpenCV_FindDLL("autoit_opencv_com4*"))
OnAutoItExitRegister("_OnAutoItExit")

Global $cv = _OpenCV_get()

Global $download_utils = _Mediapipe_ObjCreate("mediapipe.autoit.solutions.download_utils")
_AssertTrue(IsObj($download_utils), "Failed to load mediapipe.autoit.solutions.download_utils")

Global $mp_drawing = _Mediapipe_ObjCreate("mediapipe.autoit.solutions.drawing_utils")
_AssertTrue(IsObj($mp_drawing), "Failed to load mediapipe.autoit.solutions.drawing_utils")

Global $mp_selfie_segmentation = _Mediapipe_ObjCreate("mediapipe.autoit.solutions.selfie_segmentation")
_AssertTrue(IsObj($mp_selfie_segmentation), "Failed to load mediapipe.autoit.solutions.selfie_segmentation")

Test()

Func Test()
	_Mediapipe_SetResourceDir()

	test_blank_image()
    test_segmentation("general", 0)
    test_segmentation("landscape", 1)
EndFunc   ;==>Test

Func test_blank_image()
	Local $image = _OpenCV_ObjCreate("Mat").zeros(100, 100, $CV_8UC3)
	$image.setTo(255.0)

	Local $selfie_segmentation = $mp_selfie_segmentation.SelfieSegmentation()
	Local $results = $selfie_segmentation.process($image)
	Local $normalized_segmentation_mask = $cv.multiply($results("segmentation_mask"), 255.0).convertTo($CV_32S)
	_AssertMatLess($normalized_segmentation_mask, 1)
EndFunc   ;==>test_blank_image

Func test_segmentation($id, $model_selection)
	$download_utils.download( _
			"https://github.com/tensorflow/tfjs-models/raw/master/face-detection/test_data/portrait.jpg", _
			@ScriptDir & "/testdata/portrait.jpg" _
			)

	Local $image_path = @ScriptDir & "/testdata/portrait.jpg"
	Local $image = $cv.imread($image_path)

	Local $selfie_segmentation = $mp_selfie_segmentation.SelfieSegmentation($model_selection)
	Local $results = $selfie_segmentation.process($cv.cvtColor($image, $CV_COLOR_BGR2RGB))
	Local $normalized_segmentation_mask = $cv.multiply($results("segmentation_mask"), 255.0).convertTo($CV_32S)

	_draw("test_segmentation_" & $id, $image.copy(), $normalized_segmentation_mask)
EndFunc   ;==>test_segmentation

Func _draw($id, $frame, $mask)
    ; frame and mask must have the same size and type
    If $frame.depth() <> $mask.depth() Then
        $mask = $mask.convertTo($frame.depth())
    EndIf

	Local $image_mask[] = [$mask, $mask, $mask]
	$frame = $cv.min($frame, $cv.merge($image_mask))

	Local Const $path = @TempDir & "\" & $id & ".png"
	$cv.imwrite($path, $frame)
EndFunc   ;==>_draw

Func _OnAutoItExit()
	_OpenCV_Unregister_And_Close()
	_Mediapipe_Unregister_And_Close()
EndFunc   ;==>_OnAutoItExit
