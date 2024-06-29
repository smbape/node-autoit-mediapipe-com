#include-once

#include <Debug.au3>

_DebugSetup(Default, True, 2)

; #FUNCTION# ;===============================================================================
;
; Name...........: _StringStartsWith
; Description ...: Returns whether or not the given string begins with the specified text.
; Syntax.........: _StringStartsWith($sInput, $sSearch, $fCaseSensitive)
; Parameters ....: $sInput - The string to be searched
;				   $sSearch - The text to search for
;				   $fCaseSensitive - Specifies whether the search string should be case sensitive
; Return values .: Success - Returns true
;				   Failure - Returns false and sets @Error:
;				   |0 - No error.
;				   |1 - The search string is longer than the input string.
;				   |2 - The search string or the input string is empty.
; Author ........: Chris Coale (chris95219)
; Modified.......:
; Remarks .......:
; Related .......: _StringEndsWith
; Link ..........;
; Example .......; Yes
;
; ;==========================================================================================
Func _StringStartsWith($sInput, $sSearch, $fCaseSensitive = False)
	Local Const $iSearchLen = StringLen($sSearch)
	Local Const $iInputLen = StringLen($sInput)

	If (($sInput = "") Or ($sSearch = "")) Then
		SetError(2)
		Return False
	EndIf

	If ($iSearchLen > $iInputLen) Then
		SetError(1)
		Return False
	EndIf

	If ($fCaseSensitive == True) Then
		If (StringMid($sInput, 1, $iSearchLen) == $sSearch) Then
			Return True
		EndIf
	Else
		If (StringMid($sInput, 1, $iSearchLen) = $sSearch) Then
			Return True
		EndIf
	EndIf

	SetError(0)
	Return False
EndFunc   ;==>_StringStartsWith

Func _AssertEqual($vA, $vB, $sMessage = Default, $bExit = Default, $iCode = Default, $iLine = @ScriptLineNumber, Const $_iCallerError = @error, Const $_vCallerExtended = @extended)
	Local $vAStr = IsObj($vA) ? $vA.__str__() : $vA
	Local $vBStr = IsObj($vB) ? $vB.__str__() : $vB
	If $sMessage == Default Then $sMessage = "expecting " & $vAStr & " to be equal to " & $vBStr

	If IsObj($vA) Then
		Return _AssertTrue($vA.__eq__($vB), $sMessage, $bExit, $iCode, $iLine, $_iCallerError, $_vCallerExtended)
	EndIf

	If IsObj($vB) Then
		Return _AssertTrue($vB.__eq__($vA), $sMessage, $bExit, $iCode, $iLine, $_iCallerError, $_vCallerExtended)
	EndIf

	Return _AssertTrue($vA == $vB, $sMessage, $bExit, $iCode, $iLine, $_iCallerError, $_vCallerExtended)
EndFunc   ;==>_AssertEqual

Func _AssertNotEqual($vA, $vB, $sMessage = Default, $bExit = Default, $iCode = Default, $iLine = @ScriptLineNumber, Const $_iCallerError = @error, Const $_vCallerExtended = @extended)
	If $sMessage == Default Then $sMessage = "expecting " & $vA & " not to be equal to " & $vB
	Return _AssertTrue($vA <> $vB, $sMessage, $bExit, $iCode, $iLine, $_iCallerError, $_vCallerExtended)
EndFunc   ;==>_AssertNotEqual

Func _AssertGreater($vA, $vB, $sMessage = Default, $bExit = Default, $iCode = Default, $iLine = @ScriptLineNumber, Const $_iCallerError = @error, Const $_vCallerExtended = @extended)
	If $sMessage == Default Then $sMessage = "expecting " & $vA & " to be greater than " & $vB
	Return _AssertTrue($vA > $vB, $sMessage, $bExit, $iCode, $iLine, $_iCallerError, $_vCallerExtended)
EndFunc   ;==>_AssertGreater

Func _AssertGreaterEqual($vA, $vB, $sMessage = Default, $bExit = Default, $iCode = Default, $iLine = @ScriptLineNumber, Const $_iCallerError = @error, Const $_vCallerExtended = @extended)
	If $sMessage == Default Then $sMessage = "expecting " & $vA & " to be greater than or equal to " & $vB
	Return _AssertTrue($vA >= $vB, $sMessage, $bExit, $iCode, $iLine, $_iCallerError, $_vCallerExtended)
EndFunc   ;==>_AssertGreaterEqual

Func _AssertLess($vA, $vB, $sMessage = Default, $bExit = Default, $iCode = Default, $iLine = @ScriptLineNumber, Const $_iCallerError = @error, Const $_vCallerExtended = @extended)
	If $sMessage == Default Then $sMessage = "expecting " & $vA & " to be less than or equal to " & $vB
	Return _AssertTrue($vA < $vB, $sMessage, $bExit, $iCode, $iLine, $_iCallerError, $_vCallerExtended)
EndFunc   ;==>_AssertLess

Func _AssertLessEqual($vA, $vB, $sMessage = Default, $bExit = Default, $iCode = Default, $iLine = @ScriptLineNumber, Const $_iCallerError = @error, Const $_vCallerExtended = @extended)
	If $sMessage == Default Then $sMessage = "expecting " & $vA & " to be less than or equal to " & $vB
	Return _AssertTrue($vA <= $vB, $sMessage, $bExit, $iCode, $iLine, $_iCallerError, $_vCallerExtended)
EndFunc   ;==>_AssertLessEqual

Func _AssertIsInstance($vVal, $vType, $sMessage = Default, $bExit = Default, $iCode = Default, $iLine = @ScriptLineNumber, Const $_iCallerError = @error, Const $_vCallerExtended = @extended)
	Local Const $sValFullyQualifiedName = IsObj($vVal) ? $vVal.FullyQualifiedName : IsArray($vVal) ? "Array" : $vVal
	Local Const $sTypeFullyQualifiedName = IsObj($vType) ? $vType.FullyQualifiedName : $vType
	If $sMessage == Default Then $sMessage = "expecting [" & $sValFullyQualifiedName & "] to be an instance of [" & $sTypeFullyQualifiedName & "]"

	If IsObj($vType) Then
		Return _AssertTrue($vType.IsInstance($vVal), $sMessage, $bExit, $iCode, $iLine, $_iCallerError, $_vCallerExtended)
	EndIf

	Local $bIsListType = $vType == "Array" Or $vType == "List" Or $vType == "Vector"

	If IsArray($vVal) Then
		Return _AssertTrue($bIsListType, $sMessage, $bExit, $iCode, $iLine, $_iCallerError, $_vCallerExtended)
	EndIf

	Local $bCondition = _AssertTrue(IsObj($vVal), $sMessage, $bExit, $iCode, $iLine, $_iCallerError, $_vCallerExtended)
	If Not $bCondition Then Return $bCondition

	If $bIsListType Then
		Return _AssertTrue(_StringStartsWith($sValFullyQualifiedName, "std::vector<", True), $sMessage, $bExit, $iCode, $iLine, $_iCallerError, $_vCallerExtended)
	EndIf

	Return _AssertEqual($sValFullyQualifiedName, $sTypeFullyQualifiedName, $sMessage, $bExit, $iCode, $iLine, $_iCallerError, $_vCallerExtended)
EndFunc   ;==>_AssertIsInstance

Func _AssertAlmostEqual($vA, $vB, $fDelta = Default, $iPlaces = Default, $sMessage = Default, $bExit = Default, $iCode = Default, $iLine = @ScriptLineNumber, Const $_iCallerError = @error, Const $_vCallerExtended = @extended)
	If $iPlaces == Default Then $iPlaces = 7
	If $sMessage == Default Then $sMessage = "expecting " & $vA & " to be almost equal to " & $vB & " with decimal places of " & $iPlaces & " with a delta of " & $fDelta
	$vA = Round($vA, $iPlaces)
	$vB = Round($vB, $iPlaces)
	Return _AssertTrue($fDelta == Default ? $vA == $vB : Abs($vA - $vB) < $fDelta, $sMessage, $bExit, $iCode, $iLine, $_iCallerError, $_vCallerExtended)
EndFunc   ;==>_AssertAlmostEqual

Func _AssertListEqual($vAList, $vBList, $sMessage = Default, $bExit = Default, $iCode = Default, $iLine = @ScriptLineNumber, Const $_iCallerError = @error, Const $_vCallerExtended = @extended)
	Local $iBLength = IsArray($vBList) ? UBound($vBList) : $vBList.size()
	Local $bEquals = _AssertLen($vAList, $iBLength, $sMessage, $bExit, $iCode, $iLine, $_iCallerError, $_vCallerExtended)
	If Not $bEquals Then
		Return $bEquals
	EndIf

	Local $i = 0, $vB
	For $vA In $vAList
		$vB = IsArray($vBList) ? $vBList[$i] : $vBList($i)
		$bEquals = _AssertEqual($vA, $vB, $sMessage == Default ? "at index " & $i & ": expecting " & $vA & " to be equal to " & $vB : $sMessage, $bExit, $iCode, $iLine, $_iCallerError, $_vCallerExtended)
		If Not $bEquals Then
			ExitLoop
		EndIf
		$i += 1
	Next
	Return $bEquals
EndFunc   ;==>_AssertListEqual

Func _AssertIsObj($oVal, $sMessage = Default, $bExit = Default, $iCode = Default, $iLine = @ScriptLineNumber, Const $_iCallerError = @error, Const $_vCallerExtended = @extended)
	If $sMessage == Default Then $sMessage = "expecting " & $oVal & " to be an object"
	Return _AssertTrue(IsObj($oVal), $sMessage, $bExit, $iCode, $iLine, $_iCallerError, $_vCallerExtended)
EndFunc   ;==>_AssertIsObj

Func _AssertLen($aList, $iLength, $sMessage = Default, $bExit = Default, $iCode = Default, $iLine = @ScriptLineNumber, Const $_iCallerError = @error, Const $_vCallerExtended = @extended)
	Local $iALength = IsArray($aList) ? UBound($aList) : $aList.size()
	If $sMessage == Default Then $sMessage = "expecting length " & $iALength & " to be equal to " & $iLength
	Return _AssertEqual($iALength, $iLength, $sMessage, $bExit, $iCode, $iLine, $_iCallerError, $_vCallerExtended)
EndFunc   ;==>_AssertLen

Func _AssertEmpty($aList, $sMessage = Default, $bExit = Default, $iCode = Default, $iLine = @ScriptLineNumber, Const $_iCallerError = @error, Const $_vCallerExtended = @extended)
	If $sMessage == Default Then $sMessage = "expecting value to be empty"
	Return _AssertLen($aList, 0, $sMessage, $bExit, $iCode, $iLine, $_iCallerError, $_vCallerExtended) ;
EndFunc   ;==>_AssertEmpty

Func _AssertNotEmpty($aList, $sMessage = Default, $bExit = Default, $iCode = Default, $iLine = @ScriptLineNumber, Const $_iCallerError = @error, Const $_vCallerExtended = @extended)
	Local $iALength = IsArray($aList) ? UBound($aList) : $aList.size()
	If $sMessage == Default Then $sMessage = "expecting value to be not empty"
	Return _AssertNotEqual($iALength, 0, $sMessage, $bExit, $iCode, $iLine, $_iCallerError, $_vCallerExtended)
EndFunc   ;==>_AssertNotEmpty

Func _AssertIsNone($vVal, $sMessage = Default, $bExit = Default, $iCode = Default, $iLine = @ScriptLineNumber, Const $_iCallerError = @error, Const $_vCallerExtended = @extended)
	Local $bCondition
	If IsArray($vVal) Then
		If $sMessage == Default Then $sMessage = "expecting Array to be empty"
		$bCondition = UBound($vVal) == 0
	ElseIf IsObj($vVal) Then
		$bCondition = _AssertIsInstance($vVal, "List", $sMessage, $bExit, $iCode, $iLine, $_iCallerError, $_vCallerExtended)
		If $sMessage == Default Then $sMessage = "expecting List to be empty"
		If $bCondition Then _AssertLen($vVal, 0, $sMessage, $bExit, $iCode, $iLine, $_iCallerError, $_vCallerExtended)
	Else
		If $sMessage == Default Then $sMessage = "expecting value to be none"
		$bCondition = $vVal == Default Or $vVal == Null
	EndIf
	Return _AssertTrue($bCondition, $sMessage, $bExit, $iCode, $iLine, $_iCallerError, $_vCallerExtended)
EndFunc   ;==>_AssertIsNone

Func _AssertFalse($bCondition, $sMessage = Default, $bExit = Default, $iCode = Default, $iLine = @ScriptLineNumber, Const $_iCallerError = @error, Const $_vCallerExtended = @extended)
	If $sMessage == Default Then $sMessage = "expecting " & $bCondition & " to be False"
	Return _AssertTrue(Not $bCondition, $sMessage, $bExit, $iCode, $iLine, $_iCallerError, $_vCallerExtended)
EndFunc   ;==>_AssertFalse

Func _AssertIn($vA, $vColl, $sMessage = Default, $bExit = Default, $iCode = Default, $iLine = @ScriptLineNumber, Const $_iCallerError = @error, Const $_vCallerExtended = @extended)
	If $sMessage == Default Then $sMessage = "expecting " & $vA & " to be in collection"
	Local $bFound = False
	For $item In $vColl
		If $item == $vA Then
			$bFound = True
			ExitLoop
		EndIf
	Next
	Return _AssertTrue($bFound, $sMessage, $bExit, $iCode, $iLine, $_iCallerError, $_vCallerExtended)
EndFunc   ;==>_AssertIn

Func _AssertNotIn($vA, $vColl, $sMessage = Default, $bExit = Default, $iCode = Default, $iLine = @ScriptLineNumber, Const $_iCallerError = @error, Const $_vCallerExtended = @extended)
	If $sMessage == Default Then $sMessage = "expecting " & $vA & " not to be in collection"
	Local $bFound = False
	For $item In $vColl
		If $item == $vA Then
			$bFound = True
			ExitLoop
		EndIf
	Next
	Return _AssertTrue(Not $bFound, $sMessage, $bExit, $iCode, $iLine, $_iCallerError, $_vCallerExtended)
EndFunc   ;==>_AssertNotIn

Func _AssertTrue($bCondition, $sMessage = Default, $bExit = Default, $iCode = Default, $iLine = @ScriptLineNumber, Const $_iCallerError = @error, Const $_vCallerExtended = @extended)
	If $sMessage == Default Then $sMessage = "expecting " & $bCondition & " to be True"
	If Not $bCondition Then
		Local $sOutput = "@@ Assertion Failed (" & $iLine & ") : " & @CRLF & @CRLF & $sMessage
		If _DebugOut(StringReplace($sOutput, @CRLF, "")) = 0 Then ; _DebugSetup() has not been called.
			MsgBox($MB_SYSTEMMODAL, "AutoIt Assert", $sOutput)
		EndIf
		If $iCode == Default Then $iCode = 0x7FFFFFFF
		If $bExit == Default Or $bExit Then Exit $iCode
	EndIf
	Return SetError($_iCallerError, $_vCallerExtended, $bCondition)
EndFunc   ;==>_AssertTrue
