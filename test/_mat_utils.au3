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
	If $sMessage == Default Then $sMessage = "expecting both matrix to be equals"

	_AssertEqual($oMatA.rows, $oMatB.rows, "expecting both matrix to have the same number of rows", $bExit, $iCode, $sLine, $_iCallerError, $_iCallerExtended)
	_AssertEqual($oMatA.cols, $oMatB.cols, "expecting both matrix to have the same number of columns", $bExit, $iCode, $sLine, $_iCallerError, $_iCallerExtended)
	_AssertEqual($oMatA.channels(), $oMatB.channels(), "expecting both matrix to have the same number of channels", $bExit, $iCode, $sLine, $_iCallerError, $_iCallerExtended)
	_AssertEqual($oMatA.depth(), $oMatB.depth(), "expecting both matrix to have the same number of depth", $bExit, $iCode, $sLine, $_iCallerError, $_iCallerExtended)

	Local Const $cv = _OpenCV_get()
	Local $absdiff = $cv.absdiff(Ptr($oMatA.self), Ptr($oMatB.self)).reshape(1)
	_AssertEqual($cv.countNonZero($absdiff), 0, $sMessage, $bExit, $iCode, $sLine, $_iCallerError, $_iCallerExtended)
EndFunc   ;==>_AssertMatEqual

Func _AssertMatAlmostEqual($oMatA, $oMatB, $sMessage = Default, $bExit = True, $iCode = 0x7FFFFFFF, $sLine = @ScriptLineNumber, Const $_iCallerError = @error, Const $_iCallerExtended = @extended)
	If $sMessage == Default Then $sMessage = "expecting both matrix to be almost equals"

	_AssertEqual($oMatA.rows, $oMatB.rows, "expecting both matrix to have the same number of rows", $bExit, $iCode, $sLine, $_iCallerError, $_iCallerExtended)
	_AssertEqual($oMatA.cols, $oMatB.cols, "expecting both matrix to have the same number of columns", $bExit, $iCode, $sLine, $_iCallerError, $_iCallerExtended)
	_AssertEqual($oMatA.channels(), $oMatB.channels(), "expecting both matrix to have the same number of channels", $bExit, $iCode, $sLine, $_iCallerError, $_iCallerExtended)
	_AssertEqual($oMatA.depth(), $oMatB.depth(), "expecting both matrix to have the same number of depth", $bExit, $iCode, $sLine, $_iCallerError, $_iCallerExtended)

	Local Const $cv = _OpenCV_get()
	Local $absdiff = $cv.absdiff(Ptr($oMatA.self), Ptr($oMatB.self)).reshape(1)
	$absdiff = $cv.compare($absdiff, 10 ^ - 7, $CV_CMP_GE)

	_AssertEqual($cv.countNonZero($absdiff), 0, $sMessage, $bExit, $iCode, $sLine, $_iCallerError, $_iCallerExtended)
EndFunc   ;==>_AssertMatAlmostEqual

Func _AssertMatLess($oMatA, $oMatB, $sMessage = Default, $bExit = True, $iCode = 0x7FFFFFFF, $sLine = @ScriptLineNumber, Const $_iCallerError = @error, Const $_iCallerExtended = @extended)
	If $sMessage == Default Then $sMessage = "Arrays are not less-ordered"

	If IsNumber($oMatA) Then $oMatA = Number($oMatA, $NUMBER_DOUBLE)
	If IsNumber($oMatB) Then $oMatB = Number($oMatB, $NUMBER_DOUBLE)

	Local Const $cv = _OpenCV_get()
	Local $diff = $cv.compare($oMatA, $oMatB, $CV_CMP_GE)
	_AssertEqual($cv.countNonZero($diff), 0, $sMessage, $bExit, $iCode, $sLine, $_iCallerError, $_iCallerExtended)
EndFunc   ;==>_AssertMatLess
