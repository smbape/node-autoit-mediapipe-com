#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Change2CUI=y
#AutoIt3Wrapper_Au3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

;~ Sources:
;~     https://github.com/google-ai-edge/mediapipe/blob/v0.10.35/mediapipe/tasks/python/test/components/containers/landmark_test.py

#include "..\..\..\..\autoit-mediapipe-com\udf\mediapipe_udf_utils.au3"
#include "..\..\..\_assert.au3"

_Mediapipe_Open(_Mediapipe_FindDLL("opencv_world4130*"), _Mediapipe_FindDLL("autoit_mediapipe_com-*-4130*"))
OnAutoItExitRegister("_OnAutoItExit")

Global Const $landmark_lib = _Mediapipe_ObjCreate("mediapipe.tasks.autoit.components.containers.landmark")
_AssertIsObj($landmark_lib, "Failed to load mediapipe.tasks.autoit.components.containers.landmark")

Global Const $rect_lib = _Mediapipe_ObjCreate("mediapipe.tasks.autoit.components.containers.rect")
_AssertIsObj($rect_lib, "Failed to load mediapipe.tasks.autoit.components.containers.rect")


LandmarkTest()
NormalizedLandmarkTest()


Func LandmarkTest()
	test_create_landmark_from_ctypes()
	test_create_landmark_from_ctypes_without_optional_fields()
EndFunc   ;==>LandmarkTest


Func test_create_landmark_from_ctypes()
	ConsoleWrite('"' & @ScriptFullPath & '" @@ Debug(' & @ScriptLineNumber & ') : test_create_landmark_from_ctypes' & @CRLF) ;### Debug Console

	Local $actual_landmark = $landmark_lib.Landmark(_Mediapipe_Params( _
			"x", 0.1, _
			"y", 0.2, _
			"z", 0.3, _
			"visibility", 0.4, _
			"presence", 0.5, _
			"name", 'test_landmark' _
			))

	Local $expected_values = ObjCreate("Scripting.Dictionary")
	$expected_values.Add('x', 0.1)
	$expected_values.Add('y', 0.2)
	$expected_values.Add('z', 0.3)
	$expected_values.Add('visibility', 0.4)
	$expected_values.Add('presence', 0.5)
	$expected_values.Add('name', 'test_landmark')

	_AssertDictAlmostEqual($actual_landmark, $expected_values)
EndFunc   ;==>test_create_landmark_from_ctypes

Func test_create_landmark_from_ctypes_without_optional_fields()
	ConsoleWrite('"' & @ScriptFullPath & '" @@ Debug(' & @ScriptLineNumber & ') : test_create_landmark_from_ctypes_without_optional_fields' & @CRLF) ;### Debug Console

	Local $actual_landmark = $landmark_lib.Landmark(_Mediapipe_Params( _
			"x", 0.1, _
			"y", 0.2, _
			"z", 0.3, _
			"visibility", Default, _
			"presence", Default, _
			"name", Default _
			))

	Local $expected_values = ObjCreate("Scripting.Dictionary")
	$expected_values.Add('x', 0.1)
	$expected_values.Add('y', 0.2)
	$expected_values.Add('z', 0.3)
	$expected_values.Add('visibility', Default)
	$expected_values.Add('presence', Default)
	$expected_values.Add('name', Default)

	_AssertDictAlmostEqual($actual_landmark, $expected_values)
EndFunc   ;==>test_create_landmark_from_ctypes_without_optional_fields


Func NormalizedLandmarkTest()
	test_create_normalized_landmark_from_ctypes()
	test_create_normalized_landmark_from_ctypes_without_optional_fields()
EndFunc   ;==>NormalizedLandmarkTest


Func test_create_normalized_landmark_from_ctypes()
	ConsoleWrite('"' & @ScriptFullPath & '" @@ Debug(' & @ScriptLineNumber & ') : test_create_normalized_landmark_from_ctypes' & @CRLF) ;### Debug Console

	Local $actual_landmark = $landmark_lib.NormalizedLandmark(_Mediapipe_Params( _
			"x", 0.1, _
			"y", 0.2, _
			"z", 0.3, _
			"visibility", 0.4, _
			"presence", 0.5, _
			"name", 'test_landmark' _
			))

	Local $expected_values = ObjCreate("Scripting.Dictionary")
	$expected_values.Add('x', 0.1)
	$expected_values.Add('y', 0.2)
	$expected_values.Add('z', 0.3)
	$expected_values.Add('visibility', 0.4)
	$expected_values.Add('presence', 0.5)
	$expected_values.Add('name', 'test_landmark')

	_AssertDictAlmostEqual($actual_landmark, $expected_values)
EndFunc   ;==>test_create_normalized_landmark_from_ctypes

Func test_create_normalized_landmark_from_ctypes_without_optional_fields()
	ConsoleWrite('"' & @ScriptFullPath & '" @@ Debug(' & @ScriptLineNumber & ') : test_create_normalized_landmark_from_ctypes_without_optional_fields' & @CRLF) ;### Debug Console


	Local $actual_landmark = $landmark_lib.NormalizedLandmark(_Mediapipe_Params( _
			"x", 0.1, _
			"y", 0.2, _
			"z", 0.3, _
			"visibility", Default, _
			"presence", Default, _
			"name", Default _
			))

	Local $expected_values = ObjCreate("Scripting.Dictionary")
	$expected_values.Add('x', 0.1)
	$expected_values.Add('y', 0.2)
	$expected_values.Add('z', 0.3)
	$expected_values.Add('visibility', Default)
	$expected_values.Add('presence', Default)
	$expected_values.Add('name', Default)

	_AssertDictAlmostEqual($actual_landmark, $expected_values)
EndFunc   ;==>test_create_normalized_landmark_from_ctypes_without_optional_fields


Func _OnAutoItExit()
	_Mediapipe_Close()
EndFunc   ;==>_OnAutoItExit
