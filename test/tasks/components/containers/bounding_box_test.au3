#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Change2CUI=y
#AutoIt3Wrapper_Au3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

;~ Sources:
;~     https://github.com/google-ai-edge/mediapipe/blob/v0.10.35/mediapipe/tasks/python/test/components/containers/bounding_box_test.py

#include "..\..\..\..\autoit-mediapipe-com\udf\mediapipe_udf_utils.au3"
#include "..\..\..\_assert.au3"

_Mediapipe_Open(_Mediapipe_FindDLL("opencv_world4130*"), _Mediapipe_FindDLL("autoit_mediapipe_com-*-4130*"))
OnAutoItExitRegister("_OnAutoItExit")

Global Const $bounding_box_lib = _Mediapipe_ObjCreate("mediapipe.tasks.autoit.components.containers.bounding_box")
_AssertIsObj($bounding_box_lib, "Failed to load mediapipe.tasks.autoit.components.containers.bounding_box")

Global Const $rect_lib = _Mediapipe_ObjCreate("mediapipe.tasks.autoit.components.containers.rect")
_AssertIsObj($rect_lib, "Failed to load mediapipe.tasks.autoit.components.containers.rect")


BoundingBoxTest()


Func BoundingBoxTest()
	test_create_bounding_box_from_ctypes_converts_values()
EndFunc   ;==>BoundingBoxTest


Func test_create_bounding_box_from_ctypes_converts_values()
	ConsoleWrite('"' & @ScriptFullPath & '" @@ Debug(' & @ScriptLineNumber & ') : test_create_bounding_box_from_ctypes_converts_values' & @CRLF) ;### Debug Console

	Local $expected_values = ObjCreate("Scripting.Dictionary")
	$expected_values.Add("origin_x", 10)
	$expected_values.Add("origin_y", 20)
	$expected_values.Add("width", 40)
	$expected_values.Add("height", 50)
	$expected_values.Add("left", 10)
	$expected_values.Add("top", 20)
	$expected_values.Add("right", 50)
	$expected_values.Add("bottom", 70)

	Local $actual_bounding_box = $bounding_box_lib.BoundingBox(_Mediapipe_Params( _
			"origin_x", 10, _
			"origin_y", 20, _
			"width", 40, _
			"height", 50 _
			))
	_AssertDictAlmostEqual($actual_bounding_box, $expected_values)

	Local $actual_rect = $rect_lib.Rect(_Mediapipe_Params( _
			"left", 10, _
			"top", 20, _
			"right", 50, _
			"bottom", 70 _
			))
	_AssertDictAlmostEqual($actual_rect, $expected_values)
EndFunc   ;==>test_create_bounding_box_from_ctypes_converts_values


Func _OnAutoItExit()
	_Mediapipe_Close()
EndFunc   ;==>_OnAutoItExit
