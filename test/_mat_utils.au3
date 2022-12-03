#include-once

; https://stackoverflow.com/questions/35526127/generate-random-numbers-matrix-in-opencv
Func _RandomImage($width, $height, $type, $low, $high)
	Local Static $MatPtr = _OpenCV_ObjCreate("cv.Mat")
	Local Const $cv = _OpenCV_get()
	Local Const $mat = $MatPtr.create($height, $width, $type)
	$cv.randu($mat, 0.0 + $low, 0.0 + $high)
	Return $mat
EndFunc   ;==>_RandomImage

Func _MatGetAt($mat, $type, $i0, $i1, $i2)
	Local $pixel = DllStructCreate($type & " value[3]", $mat.ptr($i0, $i1))
	Return $pixel.value(($i2 + 1))
EndFunc   ;==>_MatGetAt

Func _MatSetAt($mat, $type, $i0, $i1, $i2, $value)
	Local $pixel = DllStructCreate($type & " value[3]", $mat.ptr($i0, $i1))
	$pixel.value(($i2 + 1)) = $value
EndFunc   ;==>_MatSetAt

Func _AssertMatEqual($oMatA, $oMatB, $sMessage = Default, $bExit = True, $iCode = 0x7FFFFFFF, $sLine = @ScriptLineNumber, Const $_iCallerError = @error, Const $_iCallerExtended = @extended)
	If $sMessage == Default Then $sMessage = "expecting both matrices to be equals"

	Local $bCondition = True

	$bCondition = _AssertEqual($oMatA.rows, $oMatB.rows, "expecting both matrices to have the same number of rows", $bExit, $iCode, $sLine, $_iCallerError, $_iCallerExtended) And $bCondition
	$bCondition = _AssertEqual($oMatA.cols, $oMatB.cols, "expecting both matrices to have the same number of columns", $bExit, $iCode, $sLine, $_iCallerError, $_iCallerExtended) And $bCondition
	$bCondition = _AssertEqual($oMatA.channels(), $oMatB.channels(), "expecting both matrices to have the same number of channels", $bExit, $iCode, $sLine, $_iCallerError, $_iCallerExtended) And $bCondition
	$bCondition = _AssertEqual($oMatA.depth(), $oMatB.depth(), "expecting both matrices to have the same number of depth", $bExit, $iCode, $sLine, $_iCallerError, $_iCallerExtended) And $bCondition

	Local Const $cv = _OpenCV_get()
	Local $absdiff = $cv.absdiff(Ptr($oMatA.self), Ptr($oMatB.self)).reshape(1)
	$bCondition = _AssertEqual($cv.countNonZero($absdiff), 0, $sMessage, $bExit, $iCode, $sLine, $_iCallerError, $_iCallerExtended) And $bCondition

	Return $bCondition
EndFunc   ;==>_AssertMatEqual

Func _AssertMatAlmostEqual($oMatA, $oMatB, $sMessage = Default, $bExit = True, $iCode = 0x7FFFFFFF, $sLine = @ScriptLineNumber, Const $_iCallerError = @error, Const $_iCallerExtended = @extended)
	If $sMessage == Default Then $sMessage = "expecting both matrices to be almost equals"

	Local $bCondition = True

	$bCondition = _AssertEqual($oMatA.rows, $oMatB.rows, "expecting both matrices to have the same number of rows", $bExit, $iCode, $sLine, $_iCallerError, $_iCallerExtended) And $bCondition
	$bCondition = _AssertEqual($oMatA.cols, $oMatB.cols, "expecting both matrices to have the same number of columns", $bExit, $iCode, $sLine, $_iCallerError, $_iCallerExtended) And $bCondition
	$bCondition = _AssertEqual($oMatA.channels(), $oMatB.channels(), "expecting both matrices to have the same number of channels", $bExit, $iCode, $sLine, $_iCallerError, $_iCallerExtended) And $bCondition
	$bCondition = _AssertEqual($oMatA.depth(), $oMatB.depth(), "expecting both matrices to have the same number of depth", $bExit, $iCode, $sLine, $_iCallerError, $_iCallerExtended) And $bCondition

	If Not $bCondition Then Return $bCondition

	Local Const $cv = _OpenCV_get()
	Local $absdiff = $cv.absdiff(Ptr($oMatA.self), Ptr($oMatB.self)).reshape(1)
	$absdiff = $cv.compare($absdiff, 10 ^ - 7, $CV_CMP_GE)

	Return _AssertEqual($cv.countNonZero($absdiff), 0, $sMessage, $bExit, $iCode, $sLine, $_iCallerError, $_iCallerExtended)
EndFunc   ;==>_AssertMatAlmostEqual

Func _AssertMatLess($oMatA, $oMatB, $sMessage = Default, $bExit = True, $iCode = 0x7FFFFFFF, $sLine = @ScriptLineNumber, Const $_iCallerError = @error, Const $_iCallerExtended = @extended)
	If $sMessage == Default Then $sMessage = "Matrices are not less-ordered"

	If IsNumber($oMatA) Then $oMatA = Number($oMatA, $NUMBER_DOUBLE)
	If IsNumber($oMatB) Then $oMatB = Number($oMatB, $NUMBER_DOUBLE)

	If IsObj($oMatA) And IsObj($oMatB) And $oMatA.depth() <> $oMatB.depth() Then
		$oMatA = $oMatA.convertTo($oMatB.depth())
	EndIf

	If IsNumber($oMatA) And IsObj($oMatB) Then
		$oMatB = $oMatB.reshape(1)
	EndIf

	If IsObj($oMatA) And IsNumber($oMatB) Then
		$oMatA = $oMatA.reshape(1)
	EndIf

	Local $bCondition = True

	If IsObj($oMatA) And IsObj($oMatB) Then
		Local $sSizeA = '[' & $oMatA.rows & 'x' & $oMatA.cols & 'x' & $oMatA.channels() & ']'
		Local $sSizeB = '[' & $oMatB.rows & 'x' & $oMatB.cols & 'x' & $oMatB.channels() & ']'
		Local $sMessageSize = "expecting both matrices to have the same size and the same number of channels : " & $sSizeA & " <> " & $sSizeB
		$bCondition = _AssertEqual($sSizeA, $sSizeB, $sMessageSize, $bExit, $iCode, $sLine, $_iCallerError, $_iCallerExtended)
	EndIf

	If Not $bCondition Then Return $bCondition

	Local Const $cv = _OpenCV_get()
	Local $diff = $cv.compare($oMatA, $oMatB, $CV_CMP_GE)
	Return _AssertEqual($cv.countNonZero($diff), 0, $sMessage, $bExit, $iCode, $sLine, $_iCallerError, $_iCallerExtended)
EndFunc   ;==>_AssertMatLess

Func _AssertMatDiffLess($oMatA, $oMatB, $threshold, $sMessage = Default, $bExit = True, $iCode = 0x7FFFFFFF, $sLine = @ScriptLineNumber, Const $_iCallerError = @error, Const $_iCallerExtended = @extended)
	If $sMessage == Default Then $sMessage = "Diff between matrices is not less than " & $threshold

	Local Const $cv = _OpenCV_get()
	Local Const $mat = _OpenCV_ObjCreate("Mat")

	If IsArray($oMatA) Then $oMatA = $mat.createFromArray($oMatA, $CV_32F)
	If IsArray($oMatB) Then $oMatB = $mat.createFromArray($oMatB, $CV_32F)

	Local $bCondition = True

	If IsObj($oMatA) And IsObj($oMatB) Then
		Local $sSizeA = "[" & $oMatA.rows & " x " & $oMatA.cols & " x " & $oMatA.channels() & "]"
		Local $sSizeB = "[" & $oMatB.rows & " x " & $oMatB.cols & " x " & $oMatB.channels() & "]"
		Local $sMessageSize = "expecting both matrices to have the same size and the same number of channels : " & $sSizeA & " <> " & $sSizeB
		$bCondition = _AssertEqual($sSizeA, $sSizeB, $sMessageSize, $bExit, $iCode, $sLine, $_iCallerError, $_iCallerExtended)
	EndIf

	If Not $bCondition Then Return $bCondition

	Local $prediction_error = $cv.absdiff($oMatA, $oMatB)
	Return _AssertMatLess($prediction_error, $threshold, $sMessage, $bExit, $iCode, $sLine, $_iCallerError, $_iCallerExtended)
EndFunc   ;==>_AssertMatDiffLess

Func _AssertMatGreaterEqual($oMatA, $oMatB, $sMessage = Default, $bExit = True, $iCode = 0x7FFFFFFF, $sLine = @ScriptLineNumber, Const $_iCallerError = @error, Const $_iCallerExtended = @extended)
	If $sMessage == Default Then $sMessage = "Matrices are not greater or equal ordered"

	If IsNumber($oMatA) Then $oMatA = Number($oMatA, $NUMBER_DOUBLE)
	If IsNumber($oMatB) Then $oMatB = Number($oMatB, $NUMBER_DOUBLE)

	If IsObj($oMatA) And IsObj($oMatB) And $oMatA.depth() <> $oMatB.depth() Then
		$oMatA = $oMatA.convertTo($oMatB.depth())
	EndIf

	If IsNumber($oMatA) And IsObj($oMatB) Then
		$oMatB = $oMatB.reshape(1)
	EndIf

	If IsObj($oMatA) And IsNumber($oMatB) Then
		$oMatA = $oMatA.reshape(1)
	EndIf

	Local Const $cv = _OpenCV_get()
	Local $diff = $cv.compare($oMatA, $oMatB, $CV_CMP_LT)
	Return _AssertEqual($cv.countNonZero($diff), 0, $sMessage, $bExit, $iCode, $sLine, $_iCallerError, $_iCallerExtended)
EndFunc   ;==>_AssertMatGreaterEqual
