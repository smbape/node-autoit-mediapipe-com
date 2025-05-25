#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Change2CUI=y
#AutoIt3Wrapper_Au3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

;~ Sources:
;~     https://github.com/google-ai-edge/mediapipe/blob/v0.10.24/mediapipe/python/solutions/selfie_segmentation_test.py

#include "..\..\autoit-mediapipe-com\udf\mediapipe_udf_utils.au3"
#include "..\..\autoit-opencv-com\udf\opencv_udf_utils.au3"
#include "..\_assert.au3"
#include "..\_mat_utils.au3"

_Mediapipe_Open(_Mediapipe_FindDLL("opencv_world4110*"), _Mediapipe_FindDLL("autoit_mediapipe_com-*-4110*"))
_OpenCV_Open(_OpenCV_FindDLL("opencv_world4110*"), _OpenCV_FindDLL("autoit_opencv_com4110*"))
OnAutoItExitRegister("_OnAutoItExit")

; Tell mediapipe where to look its resource files
_Mediapipe_SetResourceDir()

Global Const $cv = _OpenCV_get()
_AssertIsObj($cv, "Failed to load opencv")

Global Const $download_utils = _Mediapipe_ObjCreate("mediapipe.autoit.solutions.download_utils")
_AssertIsObj($download_utils, "Failed to load mediapipe.autoit.solutions.download_utils")

Global Const $mp_drawing = _Mediapipe_ObjCreate("mediapipe.autoit.solutions.drawing_utils")
_AssertIsObj($mp_drawing, "Failed to load mediapipe.autoit.solutions.drawing_utils")

Global Const $mp_selfie_segmentation = _Mediapipe_ObjCreate("mediapipe.autoit.solutions.selfie_segmentation")
_AssertIsObj($mp_selfie_segmentation, "Failed to load mediapipe.autoit.solutions.selfie_segmentation")

Test()

Func Test()
	test_blank_image()
	test_segmentation("general", 0)
	test_segmentation("landscape", 1)
EndFunc   ;==>Test

Func test_blank_image()
	Local $image = _OpenCV_ObjCreate("Mat").zeros(100, 100, $CV_8UC3)
	$image.setTo(255.0)

	Local $selfie_segmentation = $mp_selfie_segmentation.SelfieSegmentation()
	Local $results = $selfie_segmentation.process($image)
	Local $normalized_segmentation_mask = $results("segmentation_mask").convertTo($CV_32S, Null, 255.0)
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
	Local $normalized_segmentation_mask = $results("segmentation_mask").convertTo($CV_32S, Null, 255.0)

	_draw("test_segmentation_" & $id, $image.copy(), $normalized_segmentation_mask)
EndFunc   ;==>test_segmentation

Func _draw($id, $frame, $mask)
	; frame and mask must have the same size and type to perform cv::min
	If $frame.depth() <> $mask.depth() Then
		$mask = $mask.convertTo($frame.depth())
	EndIf

	Local $image_mask[] = [$mask, $mask, $mask]
	$frame = $cv.min($frame, $cv.merge($image_mask))

	Local Const $path = @TempDir & "\" & $id & ".png"
	$cv.imwrite($path, $frame)
EndFunc   ;==>_draw

Func _OnAutoItExit()
	_OpenCV_Close()
	_Mediapipe_Close()
EndFunc   ;==>_OnAutoItExit
