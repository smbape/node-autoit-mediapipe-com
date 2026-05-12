#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Change2CUI=y
#AutoIt3Wrapper_Au3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

;~ Sources:
;~     https://github.com/google-ai-edge/mediapipe/blob/v0.10.35/mediapipe/tasks/python/test/components/containers/embedding_result_test.py

#include "..\..\..\..\autoit-mediapipe-com\udf\mediapipe_udf_utils.au3"
#include "..\..\..\_assert.au3"

_Mediapipe_Open(_Mediapipe_FindDLL("opencv_world4130*"), _Mediapipe_FindDLL("autoit_mediapipe_com-*-4130*"))
OnAutoItExitRegister("_OnAutoItExit")

Global Const $embedding_result_lib = _Mediapipe_ObjCreate("mediapipe.tasks.autoit.components.containers.embedding_result")
_AssertIsObj($embedding_result_lib, "Failed to load mediapipe.tasks.autoit.components.containers.embedding_result")

Global Const $_Embedding = $embedding_result_lib.Embedding
Global Const $_EmbeddingResult = $embedding_result_lib.EmbeddingResult


Func _create_c_embedding_result($values = Default, $is_quantized = Default, $timestamp_ms = Default)
	Local Static $NamedParameters = _Mediapipe_ObjCreate("NamedParameters")

	Local $kwargs = Default
	Switch @NumParams
		Case 1
			$kwargs = $NamedParameters.isNamedParameters($values) ? $values : Default
		Case 2
			$kwargs = $NamedParameters.isNamedParameters($is_quantized) ? $is_quantized : Default
		Case 3
			$kwargs = $NamedParameters.isNamedParameters($timestamp_ms) ? $timestamp_ms : Default
	EndSwitch

	Local $has_kwarg = $kwargs <> Default
	If $kwargs == Default Then $kwargs = $NamedParameters
	Local $usedkw = 0

	; get argument values
	If (Not $has_kwarg) Or @NumParams > 1 Then
		; positional parameter should not be a named parameter
		If $has_kwarg And $kwargs.count("values") Then
			ConsoleWriteError('@@ Debug(' & @ScriptLineNumber & ') : values was both specified as a Positional and NamedParameter' & @CRLF)
			Exit (1)
		EndIf
	Else
		; named parameter
		If $kwargs.has("values") Then
			$values = $kwargs.Item("values")
			$usedkw += 1
		EndIf
	EndIf

	; get argument is_quantized
	If (Not $has_kwarg) Or @NumParams > 2 Then
		; positional parameter should not be a named parameter
		If $has_kwarg And $kwargs.count("is_quantized") Then
			ConsoleWriteError('@@ Debug(' & @ScriptLineNumber & ') : is_quantized was both specified as a Positional and NamedParameter' & @CRLF)
			Exit (1)
		EndIf
	Else
		; named parameter
		If $kwargs.has("is_quantized") Then
			$is_quantized = $kwargs.Item("is_quantized")
			$usedkw += 1
		EndIf
	EndIf

	; get argument timestamp_ms
	If (Not $has_kwarg) Or @NumParams > 3 Then
		; positional parameter should not be a named parameter
		If $has_kwarg And $kwargs.count("timestamp_ms") Then
			ConsoleWriteError('@@ Debug(' & @ScriptLineNumber & ') : timestamp_ms was both specified as a Positional and NamedParameter' & @CRLF)
			Exit (1)
		EndIf
	Else
		; named parameter
		If $kwargs.has("timestamp_ms") Then
			$timestamp_ms = $kwargs.Item("timestamp_ms")
			$usedkw += 1
		EndIf
	EndIf

	If $usedkw <> $kwargs.size() Then
		ConsoleWriteError('@@ Debug(' & @ScriptLineNumber & ') : there are ' & ($kwargs.size() - $usedkw) & '  unknown named parameters' & @CRLF)
		Exit (1)
	EndIf

	; ... YOUR CODE HERE

	Local $c_embedding = $_Embedding(_Mediapipe_Params( _
			"head_index", 0, _
			"head_name", "feature" _
			))
	If $is_quantized Then
		$c_embedding.quantized_embedding = $values
	Else
		$c_embedding.float_embedding = $values
	EndIf

	Local $c_embeddings[] = [$c_embedding]
	Return $_EmbeddingResult(_Mediapipe_Params( _
			"embeddings", $c_embeddings, _
			"timestamp_ms", $timestamp_ms _
			))
EndFunc   ;==>_create_c_embedding_result


EmbeddingResultTest()


Func EmbeddingResultTest()
	test_from_ctypes_float_embedding()
	test_from_ctypes_quantized_embedding()
	test_from_ctypes_quantized_embedding_contains_a_zero_value()
	test_from_ctypes_with_timestamp()
EndFunc   ;==>EmbeddingResultTest


Func _assert_embedding_result($autoit_result = Default, $expected_values = Default, $is_quantized = Default, $expected_timestamp = Default, $bExit = Default, $iCode = Default, $sFile = @ScriptFullPath, $iLine = @ScriptLineNumber, $_iCallerError = @error, $_vCallerExtended = @extended)
	Local Static $NamedParameters = _Mediapipe_ObjCreate("NamedParameters")

	Local $kwargs = Default
	Switch @NumParams
		Case 1
			$kwargs = $NamedParameters.isNamedParameters($autoit_result) ? $autoit_result : Default
		Case 2
			$kwargs = $NamedParameters.isNamedParameters($expected_values) ? $expected_values : Default
		Case 3
			$kwargs = $NamedParameters.isNamedParameters($is_quantized) ? $is_quantized : Default
		Case 4
			$kwargs = $NamedParameters.isNamedParameters($expected_timestamp) ? $expected_timestamp : Default
		Case 5
			$kwargs = $NamedParameters.isNamedParameters($bExit) ? $bExit : Default
		Case 6
			$kwargs = $NamedParameters.isNamedParameters($iCode) ? $iCode : Default
		Case 7
			$kwargs = $NamedParameters.isNamedParameters($sFile) ? $sFile : Default
		Case 8
			$kwargs = $NamedParameters.isNamedParameters($iLine) ? $iLine : Default
		Case 9
			$kwargs = $NamedParameters.isNamedParameters($_iCallerError) ? $_iCallerError : Default
		Case 10
			$kwargs = $NamedParameters.isNamedParameters($_vCallerExtended) ? $_vCallerExtended : Default
	EndSwitch

	Local $has_kwarg = $kwargs <> Default
	If $kwargs == Default Then $kwargs = $NamedParameters
	Local $usedkw = 0

	; get argument autoit_result
	If (Not $has_kwarg) Or @NumParams > 1 Then
		; positional parameter should not be a named parameter
		If $has_kwarg And $kwargs.count("autoit_result") Then
			ConsoleWriteError('@@ Debug(' & @ScriptLineNumber & ') : autoit_result was both specified as a Positional and NamedParameter' & @CRLF)
			Exit (1)
		EndIf
	Else
		; named parameter
		If $kwargs.has("autoit_result") Then
			$autoit_result = $kwargs.Item("autoit_result")
			$usedkw += 1
		EndIf
	EndIf

	; get argument expected_values
	If (Not $has_kwarg) Or @NumParams > 2 Then
		; positional parameter should not be a named parameter
		If $has_kwarg And $kwargs.count("expected_values") Then
			ConsoleWriteError('@@ Debug(' & @ScriptLineNumber & ') : expected_values was both specified as a Positional and NamedParameter' & @CRLF)
			Exit (1)
		EndIf
	Else
		; named parameter
		If $kwargs.has("expected_values") Then
			$expected_values = $kwargs.Item("expected_values")
			$usedkw += 1
		EndIf
	EndIf

	; get argument is_quantized
	If (Not $has_kwarg) Or @NumParams > 3 Then
		; positional parameter should not be a named parameter
		If $has_kwarg And $kwargs.count("is_quantized") Then
			ConsoleWriteError('@@ Debug(' & @ScriptLineNumber & ') : is_quantized was both specified as a Positional and NamedParameter' & @CRLF)
			Exit (1)
		EndIf
	Else
		; named parameter
		If $kwargs.has("is_quantized") Then
			$is_quantized = $kwargs.Item("is_quantized")
			$usedkw += 1
		EndIf
	EndIf

	; get argument expected_timestamp
	If (Not $has_kwarg) Or @NumParams > 4 Then
		; positional parameter should not be a named parameter
		If $has_kwarg And $kwargs.count("expected_timestamp") Then
			ConsoleWriteError('@@ Debug(' & @ScriptLineNumber & ') : expected_timestamp was both specified as a Positional and NamedParameter' & @CRLF)
			Exit (1)
		EndIf
	Else
		; named parameter
		If $kwargs.has("expected_timestamp") Then
			$expected_timestamp = $kwargs.Item("expected_timestamp")
			$usedkw += 1
		EndIf
	EndIf

	; get argument bExit
	If (Not $has_kwarg) Or @NumParams > 5 Then
		; positional parameter should not be a named parameter
		If $has_kwarg And $kwargs.count("bExit") Then
			ConsoleWriteError('@@ Debug(' & @ScriptLineNumber & ') : bExit was both specified as a Positional and NamedParameter' & @CRLF)
			Exit (1)
		EndIf
	Else
		; named parameter
		If $kwargs.has("bExit") Then
			$bExit = $kwargs.Item("bExit")
			$usedkw += 1
		EndIf
	EndIf

	; get argument iCode
	If (Not $has_kwarg) Or @NumParams > 6 Then
		; positional parameter should not be a named parameter
		If $has_kwarg And $kwargs.count("iCode") Then
			ConsoleWriteError('@@ Debug(' & @ScriptLineNumber & ') : iCode was both specified as a Positional and NamedParameter' & @CRLF)
			Exit (1)
		EndIf
	Else
		; named parameter
		If $kwargs.has("iCode") Then
			$iCode = $kwargs.Item("iCode")
			$usedkw += 1
		EndIf
	EndIf

	; get argument sFile
	If (Not $has_kwarg) Or @NumParams > 7 Then
		; positional parameter should not be a named parameter
		If $has_kwarg And $kwargs.count("sFile") Then
			ConsoleWriteError('@@ Debug(' & @ScriptLineNumber & ') : sFile was both specified as a Positional and NamedParameter' & @CRLF)
			Exit (1)
		EndIf
	Else
		; named parameter
		If $kwargs.has("sFile") Then
			$sFile = $kwargs.Item("sFile")
			$usedkw += 1
		EndIf
	EndIf
	If $sFile == Default Then $sFile = @ScriptFullPath

	; get argument iLine
	If (Not $has_kwarg) Or @NumParams > 8 Then
		; positional parameter should not be a named parameter
		If $has_kwarg And $kwargs.count("iLine") Then
			ConsoleWriteError('@@ Debug(' & @ScriptLineNumber & ') : iLine was both specified as a Positional and NamedParameter' & @CRLF)
			Exit (1)
		EndIf
	Else
		; named parameter
		If $kwargs.has("iLine") Then
			$iLine = $kwargs.Item("iLine")
			$usedkw += 1
		EndIf
	EndIf
	If $iLine == Default Then $iLine = @ScriptLineNumber

	; get argument _iCallerError
	If (Not $has_kwarg) Or @NumParams > 9 Then
		; positional parameter should not be a named parameter
		If $has_kwarg And $kwargs.count("_iCallerError") Then
			ConsoleWriteError('@@ Debug(' & @ScriptLineNumber & ') : _iCallerError was both specified as a Positional and NamedParameter' & @CRLF)
			Exit (1)
		EndIf
	Else
		; named parameter
		If $kwargs.has("_iCallerError") Then
			$_iCallerError = $kwargs.Item("_iCallerError")
			$usedkw += 1
		EndIf
	EndIf
	If $_iCallerError == Default Then $_iCallerError = @error

	; get argument _vCallerExtended
	If (Not $has_kwarg) Or @NumParams > 10 Then
		; positional parameter should not be a named parameter
		If $has_kwarg And $kwargs.count("_vCallerExtended") Then
			ConsoleWriteError('@@ Debug(' & @ScriptLineNumber & ') : _vCallerExtended was both specified as a Positional and NamedParameter' & @CRLF)
			Exit (1)
		EndIf
	Else
		; named parameter
		If $kwargs.has("_vCallerExtended") Then
			$_vCallerExtended = $kwargs.Item("_vCallerExtended")
			$usedkw += 1
		EndIf
	EndIf
	If $_vCallerExtended == Default Then $_vCallerExtended = @extended

	If $usedkw <> $kwargs.size() Then
		ConsoleWriteError('@@ Debug(' & @ScriptLineNumber & ') : there are ' & ($kwargs.size() - $usedkw) & '  unknown named parameters' & @CRLF)
		Exit (1)
	EndIf

	; ... YOUR CODE HERE

	_AssertLen($autoit_result.embeddings, 1, Default, $bExit, $iCode, $sFile, $iLine, $_iCallerError, $_vCallerExtended)
	Local $embedding = $autoit_result.embeddings(0)
	If $is_quantized Then
		_AssertListEqual($embedding.embedding.asArray(), $expected_values, Default, $bExit, $iCode, $sFile, $iLine, $_iCallerError, $_vCallerExtended)
	Else
		_AssertListAlmostEqual($embedding.embedding.asArray(), $expected_values, Default, Default, Default, $bExit, $iCode, $sFile, $iLine, $_iCallerError, $_vCallerExtended)
	EndIf
	_AssertEqual($embedding.head_index, 0, Default, $bExit, $iCode, $sFile, $iLine, $_iCallerError, $_vCallerExtended)
	_AssertEqual($embedding.head_name, "feature", Default, $bExit, $iCode, $sFile, $iLine, $_iCallerError, $_vCallerExtended)
	_AssertEqual($autoit_result.timestamp_ms, $expected_timestamp, Default, $bExit, $iCode, $sFile, $iLine, $_iCallerError, $_vCallerExtended)
EndFunc   ;==>_assert_embedding_result


Func test_from_ctypes_float_embedding()
	ConsoleWrite('"' & @ScriptFullPath & '" @@ Debug(' & @ScriptLineNumber & ') : test_from_ctypes_float_embedding' & @CRLF) ;### Debug Console

	Local $float_values[] = [0.1, 0.2, 0.3]
	Local $original_result = _create_c_embedding_result( _
			$float_values, _Mediapipe_Params("is_quantized", False) _
			)
	Local $converted_result = $original_result
	_assert_embedding_result( _
			$converted_result, $float_values, _Mediapipe_Params("is_quantized", False) _
			)
EndFunc   ;==>test_from_ctypes_float_embedding

Func test_from_ctypes_quantized_embedding()
	ConsoleWrite('"' & @ScriptFullPath & '" @@ Debug(' & @ScriptLineNumber & ') : test_from_ctypes_quantized_embedding' & @CRLF) ;### Debug Console

	Local $quantized_values[] = [100, 200, 255]
	Local $original_result = _create_c_embedding_result( _
			$quantized_values, _Mediapipe_Params("is_quantized", True) _
			)
	Local $converted_result = $original_result
	_assert_embedding_result( _
			$converted_result, $quantized_values, _Mediapipe_Params("is_quantized", True) _
			)
EndFunc   ;==>test_from_ctypes_quantized_embedding

Func test_from_ctypes_quantized_embedding_contains_a_zero_value()
	ConsoleWrite('"' & @ScriptFullPath & '" @@ Debug(' & @ScriptLineNumber & ') : test_from_ctypes_quantized_embedding_contains_a_zero_value' & @CRLF) ;### Debug Console

	Local $quantized_values = [0, 100, 200]
	Local $original_result = _create_c_embedding_result( _
			$quantized_values, _Mediapipe_Params("is_quantized", True) _
			)
	Local $converted_result = $original_result
	_assert_embedding_result( _
			$converted_result, $quantized_values, _Mediapipe_Params("is_quantized", True) _
			)
EndFunc   ;==>test_from_ctypes_quantized_embedding_contains_a_zero_value

Func test_from_ctypes_with_timestamp()
	ConsoleWrite('"' & @ScriptFullPath & '" @@ Debug(' & @ScriptLineNumber & ') : test_from_ctypes_with_timestamp' & @CRLF) ;### Debug Console

	Local $float_values = [0.1, 0.2]
	Local $original_result = _create_c_embedding_result( _
			$float_values, _Mediapipe_Params("is_quantized", False, "timestamp_ms", 12345) _
			)
	Local $converted_result = $original_result
	_assert_embedding_result( _
			$converted_result, _
			$float_values, _
			_Mediapipe_Params("is_quantized", False, "expected_timestamp", 12345) _
			)
EndFunc   ;==>test_from_ctypes_with_timestamp


Func _OnAutoItExit()
	_Mediapipe_Close()
EndFunc   ;==>_OnAutoItExit
