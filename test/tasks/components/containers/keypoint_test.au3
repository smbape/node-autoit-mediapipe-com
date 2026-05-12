#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Change2CUI=y
#AutoIt3Wrapper_Au3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

;~ Sources:
;~     https://github.com/google-ai-edge/mediapipe/blob/v0.10.35/mediapipe/tasks/python/test/components/containers/keypoint_test.py

#include "..\..\..\..\autoit-mediapipe-com\udf\mediapipe_udf_utils.au3"
#include "..\..\..\_assert.au3"

_Mediapipe_Open(_Mediapipe_FindDLL("opencv_world4130*"), _Mediapipe_FindDLL("autoit_mediapipe_com-*-4130*"))
OnAutoItExitRegister("_OnAutoItExit")

Global Const $keypoint_lib = _Mediapipe_ObjCreate("mediapipe.tasks.autoit.components.containers.keypoint")
_AssertIsObj($keypoint_lib, "Failed to load mediapipe.tasks.autoit.components.containers.keypoint")


NormalizedKeypointTest()


Func NormalizedKeypointTest()
	Local Const $named_parameters[] = [ _
			_Mediapipe_Params( _
			"testcase_name", 'with_optional_fields', _
			"x", 0.1, _
			"y", 0.2, _
			"label", 'test_label', _
			"score", 0.9 _
			), _
			_Mediapipe_Params( _
			"testcase_name", 'without_optional_fields', _
			"x", 0.1, _
			"y", 0.2, _
			"label", Default, _
			"score", 0.0 _
			) _
			]

	For $kwargs In $named_parameters
		test_create_from_ctypes_succeeds($kwargs)
	Next
EndFunc   ;==>NormalizedKeypointTest


Func test_create_from_ctypes_succeeds($testcase_name = Default, $x = Default, $y = Default, $label = Default, $score = Default)
	ConsoleWrite('"' & @ScriptFullPath & '" @@ Debug(' & @ScriptLineNumber & ') : test_create_from_ctypes_succeeds' & @CRLF) ;### Debug Console

	Local Static $NamedParameters = _Mediapipe_ObjCreate("NamedParameters")

	Local $kwargs = Default
	Switch @NumParams
		Case 1
			$kwargs = $NamedParameters.isNamedParameters($testcase_name) ? $testcase_name : Default
		Case 2
			$kwargs = $NamedParameters.isNamedParameters($x) ? $x : Default
		Case 3
			$kwargs = $NamedParameters.isNamedParameters($y) ? $y : Default
		Case 4
			$kwargs = $NamedParameters.isNamedParameters($label) ? $label : Default
		Case 5
			$kwargs = $NamedParameters.isNamedParameters($score) ? $score : Default
	EndSwitch

	Local $has_kwarg = $kwargs <> Default
	If $kwargs == Default Then $kwargs = $NamedParameters
	Local $usedkw = 0

	; get argument testcase_name
	If (Not $has_kwarg) Or @NumParams > 1 Then
		; positional parameter should not be a named parameter
		If $has_kwarg And $kwargs.count("testcase_name") Then
			ConsoleWriteError('@@ Debug(' & @ScriptLineNumber & ') : testcase_name was both specified as a Positional and NamedParameter' & @CRLF)
			Exit (1)
		EndIf
	Else
		; named parameter
		If $kwargs.has("testcase_name") Then
			$testcase_name = $kwargs.Item("testcase_name")
			$usedkw += 1
		EndIf
	EndIf

	; get argument x
	If (Not $has_kwarg) Or @NumParams > 2 Then
		; positional parameter should not be a named parameter
		If $has_kwarg And $kwargs.count("x") Then
			ConsoleWriteError('@@ Debug(' & @ScriptLineNumber & ') : x was both specified as a Positional and NamedParameter' & @CRLF)
			Exit (1)
		EndIf
	Else
		; named parameter
		If $kwargs.has("x") Then
			$x = $kwargs.Item("x")
			$usedkw += 1
		EndIf
	EndIf

	; get argument y
	If (Not $has_kwarg) Or @NumParams > 3 Then
		; positional parameter should not be a named parameter
		If $has_kwarg And $kwargs.count("y") Then
			ConsoleWriteError('@@ Debug(' & @ScriptLineNumber & ') : y was both specified as a Positional and NamedParameter' & @CRLF)
			Exit (1)
		EndIf
	Else
		; named parameter
		If $kwargs.has("y") Then
			$y = $kwargs.Item("y")
			$usedkw += 1
		EndIf
	EndIf

	; get argument label
	If (Not $has_kwarg) Or @NumParams > 4 Then
		; positional parameter should not be a named parameter
		If $has_kwarg And $kwargs.count("label") Then
			ConsoleWriteError('@@ Debug(' & @ScriptLineNumber & ') : label was both specified as a Positional and NamedParameter' & @CRLF)
			Exit (1)
		EndIf
	Else
		; named parameter
		If $kwargs.has("label") Then
			$label = $kwargs.Item("label")
			$usedkw += 1
		EndIf
	EndIf

	; get argument score
	If (Not $has_kwarg) Or @NumParams > 5 Then
		; positional parameter should not be a named parameter
		If $has_kwarg And $kwargs.count("score") Then
			ConsoleWriteError('@@ Debug(' & @ScriptLineNumber & ') : score was both specified as a Positional and NamedParameter' & @CRLF)
			Exit (1)
		EndIf
	Else
		; named parameter
		If $kwargs.has("score") Then
			$score = $kwargs.Item("score")
			$usedkw += 1
		EndIf
	EndIf

	If $usedkw <> $kwargs.size() Then
		ConsoleWriteError('@@ Debug(' & @ScriptLineNumber & ') : there are ' & ($kwargs.size() - $usedkw) & '  unknown named parameters' & @CRLF)
		Exit (1)
	EndIf

	; ... YOUR CODE HERE

	ConsoleWrite('"' & @ScriptFullPath & '" @@ Debug(' & @ScriptLineNumber & ') : test_create_from_ctypes_succeeds - ' & $testcase_name & @CRLF) ;### Debug Console

	Local $actual_keypoint = $keypoint_lib.NormalizedKeypoint(_Mediapipe_Params( _
			"x", $x, "y", $y, "label", $label, "score", $score _
			))

	Local $expected_keypoint_values = ObjCreate("Scripting.Dictionary")
	$expected_keypoint_values.Add('x', $x)
	$expected_keypoint_values.Add('y', $y)
	$expected_keypoint_values.Add('label', $label)
	$expected_keypoint_values.Add('score', $score)

	_AssertDictAlmostEqual($actual_keypoint, $expected_keypoint_values)
EndFunc   ;==>test_create_from_ctypes_succeeds


Func _OnAutoItExit()
	_Mediapipe_Close()
EndFunc   ;==>_OnAutoItExit
