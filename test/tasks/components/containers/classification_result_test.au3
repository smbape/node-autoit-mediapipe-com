#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Change2CUI=y
#AutoIt3Wrapper_Au3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

;~ Sources:
;~     https://github.com/google-ai-edge/mediapipe/blob/v0.10.35/mediapipe/tasks/python/test/components/containers/classification_result_test.py

#include "..\..\..\..\autoit-mediapipe-com\udf\mediapipe_udf_utils.au3"
#include "..\..\..\_assert.au3"

_Mediapipe_Open(_Mediapipe_FindDLL("opencv_world4130*"), _Mediapipe_FindDLL("autoit_mediapipe_com-*-4130*"))
OnAutoItExitRegister("_OnAutoItExit")

Global Const $category_lib = _Mediapipe_ObjCreate("mediapipe.tasks.autoit.components.containers.category")
_AssertIsObj($category_lib, "Failed to load mediapipe.tasks.autoit.components.containers.category")

Global Const $classification_result_lib = _Mediapipe_ObjCreate("mediapipe.tasks.autoit.components.containers.classification_result")
_AssertIsObj($classification_result_lib, "Failed to load mediapipe.tasks.autoit.components.containers.classification_result")

Global Const $_MOCK_CATEGORY_NAME = "test_category"
Global Const $_MOCK_DISPLAY_NAME = "Test Category"
Global Const $_MOCK_TIMESTAMP_MS = 1000
Global Const $_MOCK_HEAD_NAME = "Head"
Global Const $_MOCK_HEAD_INDEX = 0
Global Const $_MOCK_CATEGORY = $category_lib.Category(_Mediapipe_Params( _
		"index", 1, _
		"score", 0.95, _
		"category_name", $_MOCK_CATEGORY_NAME, _
		"display_name", $_MOCK_DISPLAY_NAME _
		))


Func _create_classification_result_c($categories_count = Default, $classifications_count = Default)
	Local Static $NamedParameters = _Mediapipe_ObjCreate("NamedParameters")

	Local $kwargs = Default
	Switch @NumParams
		Case 1
			$kwargs = $NamedParameters.isNamedParameters($categories_count) ? $categories_count : Default
		Case 2
			$kwargs = $NamedParameters.isNamedParameters($classifications_count) ? $classifications_count : Default
	EndSwitch

	Local $has_kwarg = $kwargs <> Default
	If $kwargs == Default Then $kwargs = $NamedParameters
	Local $usedkw = 0

	; get argument categories_count
	If (Not $has_kwarg) Or @NumParams > 1 Then
		; positional parameter should not be a named parameter
		If $has_kwarg And $kwargs.count("categories_count") Then
			ConsoleWriteError('@@ Debug(' & @ScriptLineNumber & ') : categories_count was both specified as a Positional and NamedParameter' & @CRLF)
			Exit (1)
		EndIf
	Else
		; named parameter
		If $kwargs.has("categories_count") Then
			$categories_count = $kwargs.Item("categories_count")
			$usedkw += 1
		EndIf
	EndIf

	; get argument classifications_count
	If (Not $has_kwarg) Or @NumParams > 2 Then
		; positional parameter should not be a named parameter
		If $has_kwarg And $kwargs.count("classifications_count") Then
			ConsoleWriteError('@@ Debug(' & @ScriptLineNumber & ') : classifications_count was both specified as a Positional and NamedParameter' & @CRLF)
			Exit (1)
		EndIf
	Else
		; named parameter
		If $kwargs.has("classifications_count") Then
			$classifications_count = $kwargs.Item("classifications_count")
			$usedkw += 1
		EndIf
	EndIf

	If $usedkw <> $kwargs.size() Then
		ConsoleWriteError('@@ Debug(' & @ScriptLineNumber & ') : there are ' & ($kwargs.size() - $usedkw) & '  unknown named parameters' & @CRLF)
		Exit (1)
	EndIf

	; ... YOUR CODE HERE

	Local $c_category = $category_lib.Category(_Mediapipe_Params( _
			"index", $_MOCK_CATEGORY.index, _
			"score", $_MOCK_CATEGORY.score, _
			"category_name", $_MOCK_CATEGORY_NAME, _
			"display_name", $_MOCK_DISPLAY_NAME _
			))

	Local $c_categories[1]
	If $categories_count == 0 Then
		$c_categories = Default
	Else
		ReDim $c_categories[$categories_count]
	EndIf
	For $i = 0 To $categories_count - 1
		$c_categories[$i] = $c_category
	Next

	Local $c_classifications = $classification_result_lib.Classifications(_Mediapipe_Params( _
			"categories", $c_categories, _
			"head_index", $_MOCK_HEAD_INDEX, _
			"head_name", $_MOCK_HEAD_NAME _
			))

	Local $c_classifications_array[1]
	If $classifications_count == 0 Then
		$c_classifications_array = Default
	Else
		ReDim $c_categories[$classifications_count]
	EndIf

	For $i = 0 To $classifications_count - 1
		$c_classifications_array[$i] = $c_classifications
	Next

	Return $classification_result_lib.ClassificationResult(_Mediapipe_Params( _
			"classifications", $c_classifications_array, _
			"timestamp_ms", $_MOCK_TIMESTAMP_MS _
			))
EndFunc   ;==>_create_classification_result_c


ClassificationResultTest()


Func ClassificationResultTest()
	test_converts_fully_populated_classification_result_to_autoit()
	test_converts_empty_classification_result_to_autoit()
EndFunc   ;==>ClassificationResultTest


Func _assert_category_matches($actual, $expected)
	_AssertEqual($expected.index, $actual.index)
	_AssertAlmostEqual($expected.score, $actual.score)
	_AssertEqual($expected.category_name, $actual.category_name)
	_AssertEqual($expected.display_name, $actual.display_name)
EndFunc   ;==>_assert_category_matches

Func _assert_classsification_matches($actual_result = Default, $expected_categories = Default)
	Local Static $NamedParameters = _Mediapipe_ObjCreate("NamedParameters")

	Local $kwargs = Default
	Switch @NumParams
		Case 1
			$kwargs = $NamedParameters.isNamedParameters($actual_result) ? $actual_result : Default
		Case 2
			$kwargs = $NamedParameters.isNamedParameters($expected_categories) ? $expected_categories : Default
	EndSwitch

	Local $has_kwarg = $kwargs <> Default
	If $kwargs == Default Then $kwargs = $NamedParameters
	Local $usedkw = 0

	; get argument actual_result
	If (Not $has_kwarg) Or @NumParams > 1 Then
		; positional parameter should not be a named parameter
		If $has_kwarg And $kwargs.count("actual_result") Then
			ConsoleWriteError('@@ Debug(' & @ScriptLineNumber & ') : actual_result was both specified as a Positional and NamedParameter' & @CRLF)
			Exit (1)
		EndIf
	Else
		; named parameter
		If $kwargs.has("actual_result") Then
			$actual_result = $kwargs.Item("actual_result")
			$usedkw += 1
		EndIf
	EndIf

	; get argument expected_categories
	If (Not $has_kwarg) Or @NumParams > 2 Then
		; positional parameter should not be a named parameter
		If $has_kwarg And $kwargs.count("expected_categories") Then
			ConsoleWriteError('@@ Debug(' & @ScriptLineNumber & ') : expected_categories was both specified as a Positional and NamedParameter' & @CRLF)
			Exit (1)
		EndIf
	Else
		; named parameter
		If $kwargs.has("expected_categories") Then
			$expected_categories = $kwargs.Item("expected_categories")
			$usedkw += 1
		EndIf
	EndIf

	If $usedkw <> $kwargs.size() Then
		ConsoleWriteError('@@ Debug(' & @ScriptLineNumber & ') : there are ' & ($kwargs.size() - $usedkw) & '  unknown named parameters' & @CRLF)
		Exit (1)
	EndIf

	; ... YOUR CODE HERE

	_AssertEqual($actual_result.head_index, $_MOCK_HEAD_INDEX)
	_AssertEqual($actual_result.head_name, $_MOCK_HEAD_NAME)
	_AssertLen($actual_result.categories, UBound($expected_categories))

	For $i = 0 To UBound($expected_categories) - 1
		_assert_category_matches($actual_result.categories($i), $expected_categories[$i])
	Next
EndFunc   ;==>_assert_classsification_matches

Func test_converts_fully_populated_classification_result_to_autoit()
	ConsoleWrite('"' & @ScriptFullPath & '" @@ Debug(' & @ScriptLineNumber & ') : test_converts_fully_populated_classification_result_to_autoit' & @CRLF) ;### Debug Console

	Local $actual_result = _create_classification_result_c(_Mediapipe_Params( _
			"categories_count", 2, "classifications_count", 1 _
			))

	_AssertEqual($actual_result.timestamp_ms, $_MOCK_TIMESTAMP_MS)
	_AssertLen($actual_result.classifications, 1)
	_assert_classsification_matches(_Mediapipe_Params( _
			"actual_result", $actual_result.classifications(0), _
			"expected_categories", _Mediapipe_Tuple($_MOCK_CATEGORY, $_MOCK_CATEGORY) _
			))
EndFunc   ;==>test_converts_fully_populated_classification_result_to_autoit

Func test_converts_empty_classification_result_to_autoit()
	ConsoleWrite('"' & @ScriptFullPath & '" @@ Debug(' & @ScriptLineNumber & ') : test_converts_empty_classification_result_to_autoit' & @CRLF) ;### Debug Console

	Local $actual_result = _create_classification_result_c(_Mediapipe_Params( _
			"categories_count", 0, "classifications_count", 0 _
			))

	_AssertEqual($actual_result.timestamp_ms, $_MOCK_TIMESTAMP_MS)
	_AssertEmpty($actual_result.classifications)
EndFunc   ;==>test_converts_empty_classification_result_to_autoit


Func _OnAutoItExit()
	_Mediapipe_Close()
EndFunc   ;==>_OnAutoItExit
