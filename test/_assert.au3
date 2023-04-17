#include-once

#include <Debug.au3>

_DebugSetup(Default, True, 2)

Func _AssertEqual($vA, $vB, $sMessage = Default, $bExit = True, $iCode = 0x7FFFFFFF, $sLine = @ScriptLineNumber, Const $_iCallerError = @error, Const $_iCallerExtended = @extended)
	If $sMessage == Default Then $sMessage = "expecting " & $vA & " to be equal to " & $vB
	Return _AssertTrue($vA == $vB, $sMessage, $bExit, $iCode, $sLine, $_iCallerError, $_iCallerExtended)
EndFunc   ;==>_AssertEqual

Func _AssertNotEqual($vA, $vB, $sMessage = Default, $bExit = True, $iCode = 0x7FFFFFFF, $sLine = @ScriptLineNumber, Const $_iCallerError = @error, Const $_iCallerExtended = @extended)
	If $sMessage == Default Then $sMessage = "expecting " & $vA & " not to be equal to " & $vB
	Return _AssertTrue($vA <> $vB, $sMessage, $bExit, $iCode, $sLine, $_iCallerError, $_iCallerExtended)
EndFunc   ;==>_AssertNotEqual

Func _AssertGreater($vA, $vB, $sMessage = Default, $bExit = True, $iCode = 0x7FFFFFFF, $sLine = @ScriptLineNumber, Const $_iCallerError = @error, Const $_iCallerExtended = @extended)
	If $sMessage == Default Then $sMessage = "expecting " & $vA & " to be greater than " & $vB
	Return _AssertTrue($vA > $vB, $sMessage, $bExit, $iCode, $sLine, $_iCallerError, $_iCallerExtended)
EndFunc   ;==>_AssertGreater

Func _AssertGreaterEqual($vA, $vB, $sMessage = Default, $bExit = True, $iCode = 0x7FFFFFFF, $sLine = @ScriptLineNumber, Const $_iCallerError = @error, Const $_iCallerExtended = @extended)
	If $sMessage == Default Then $sMessage = "expecting " & $vA & " to be greater than or equal to " & $vB
	Return _AssertTrue($vA >= $vB, $sMessage, $bExit, $iCode, $sLine, $_iCallerError, $_iCallerExtended)
EndFunc   ;==>_AssertGreaterEqual

Func _AssertLess($vA, $vB, $sMessage = Default, $bExit = True, $iCode = 0x7FFFFFFF, $sLine = @ScriptLineNumber, Const $_iCallerError = @error, Const $_iCallerExtended = @extended)
	If $sMessage == Default Then $sMessage = "expecting " & $vA & " to be less than or equal to " & $vB
	Return _AssertTrue($vA < $vB, $sMessage, $bExit, $iCode, $sLine, $_iCallerError, $_iCallerExtended)
EndFunc   ;==>_AssertLess

Func _AssertLessEqual($vA, $vB, $sMessage = Default, $bExit = True, $iCode = 0x7FFFFFFF, $sLine = @ScriptLineNumber, Const $_iCallerError = @error, Const $_iCallerExtended = @extended)
	If $sMessage == Default Then $sMessage = "expecting " & $vA & " to be less than or equal to " & $vB
	Return _AssertTrue($vA <= $vB, $sMessage, $bExit, $iCode, $sLine, $_iCallerError, $_iCallerExtended)
EndFunc   ;==>_AssertLessEqual

Func _AssertIsObj($oVal, $sMessage = Default, $bExit = True, $iCode = 0x7FFFFFFF, $sLine = @ScriptLineNumber, Const $_iCallerError = @error, Const $_iCallerExtended = @extended)
	If $sMessage == Default Then $sMessage = "expecting " & $oVal & " to be an object"
	Return _AssertTrue(IsObj($oVal), $sMessage, $bExit, $iCode, $sLine, $_iCallerError, $_iCallerExtended)
EndFunc   ;==>_AssertEqual

Func _AssertAlmostEqual($vA, $vB, $fDelta = Default, $iPlaces = Default, $sMessage = Default, $bExit = True, $iCode = 0x7FFFFFFF, $sLine = @ScriptLineNumber, Const $_iCallerError = @error, Const $_iCallerExtended = @extended)
	If $iPlaces == Default Then $iPlaces = 7
	If $sMessage == Default Then $sMessage = "expecting " & $vA & " to be almost equal to " & $vB & " with decimal places of " & $iPlaces & " with a delta of " & $fDelta
	$vA = Round($vA, $iPlaces)
	$vB = Round($vB, $iPlaces)
	Return _AssertTrue($fDelta == Default ? $vA == $vB : Abs($vA - $vB) < $fDelta, $sMessage, $bExit, $iCode, $sLine, $_iCallerError, $_iCallerExtended)
EndFunc   ;==>_AssertAlmostEqual

Func _AssertLen($aArr, $iLength, $sMessage = Default, $bExit = True, $iCode = 0x7FFFFFFF, $sLine = @ScriptLineNumber, Const $_iCallerError = @error, Const $_iCallerExtended = @extended)
	Local $iALength
	If IsArray($aArr) Then
		$iALength = UBound($aArr)
	Else
		$iALength = $aArr.size()
	EndIf
	If $sMessage == Default Then $sMessage = "expecting length " & $iALength & " to be equal to " & $iLength
	Return _AssertEqual($iALength, $iLength, $sMessage, $bExit, $iCode, $sLine, $_iCallerError, $_iCallerExtended)
EndFunc   ;==>_AssertLen

Func _AssertEmpty($aArr, $sMessage = Default, $bExit = True, $iCode = 0x7FFFFFFF, $sLine = @ScriptLineNumber, Const $_iCallerError = @error, Const $_iCallerExtended = @extended)
	If $sMessage == Default Then $sMessage = "expecting value to be empty"
	Return _AssertLen($aArr, 0, $sMessage, $bExit, $iCode, $sLine, $_iCallerError, $_iCallerExtended);
EndFunc

Func _AssertIsNone($vVal, $sMessage = Default, $bExit = True, $iCode = 0x7FFFFFFF, $sLine = @ScriptLineNumber, Const $_iCallerError = @error, Const $_iCallerExtended = @extended)
	If $sMessage == Default Then $sMessage = "expecting value to be none"
	Return _AssertEqual($vVal, Default, $sMessage, $bExit, $iCode, $sLine, $_iCallerError, $_iCallerExtended)
EndFunc   ;==>_AssertIsNone

Func _AssertFalse($bCondition, $sMessage = Default, $bExit = True, $iCode = 0x7FFFFFFF, $sLine = @ScriptLineNumber, Const $_iCallerError = @error, Const $_iCallerExtended = @extended)
	If $sMessage == Default Then $sMessage = "expecting " & $bCondition & " to be False"
	Return _AssertTrue(Not $bCondition, $sMessage, $bExit, $iCode, $sLine, $_iCallerError, $_iCallerExtended)
EndFunc   ;==>_AssertFalse

Func _AssertTrue($bCondition, $sMessage = Default, $bExit = True, $iCode = 0x7FFFFFFF, $sLine = @ScriptLineNumber, Const $_iCallerError = @error, Const $_iCallerExtended = @extended)
	If $sMessage == Default Then $sMessage = "expecting " & $bCondition & " to be True"
	If Not $bCondition Then
		Local $sOutput = "@@ Assertion Failed (" & $sLine & ") : " & @CRLF & @CRLF & $sMessage
		If _DebugOut(StringReplace($sOutput, @CRLF, "")) = 0 Then ; _DebugSetup() as not been called.
			MsgBox($MB_SYSTEMMODAL, "AutoIt Assert", $sOutput)
		Else
			$bExit = False
		EndIf
		If $bExit Then Exit $iCode
	EndIf
	Return SetError($_iCallerError, $_iCallerExtended, $bCondition)
EndFunc   ;==>_AssertTrue
