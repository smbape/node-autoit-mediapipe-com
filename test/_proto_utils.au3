#include-once

Func _AssertProtoEquals($oProtoA, $oProtoB, $sMessage = Default, $bExit = True, $iCode = 0x7FFFFFFF, $sLine = @ScriptLineNumber, Const $_iCallerError = @error, Const $_iCallerExtended = @extended)
	Local Static $text_format = _Mediapipe_ObjCreate("google.protobuf.text_format")
	If $sMessage == Default Then $sMessage = "expecting both proto buffers to be equals"

	If IsString($oProtoA) Then
		$oProtoA = $text_format.Parse($oProtoA, $oProtoB.create())
	EndIf

	Return _AssertEqual($text_format.Print($oProtoA), $text_format.Print($oProtoB), $sMessage, $bExit, $iCode, $sLine, $_iCallerError, $_iCallerExtended)
EndFunc   ;==>_AssertProtoEquals
