#include-once

; https://stackoverflow.com/questions/35526127/generate-random-numbers-matrix-in-opencv
Func _RandomImage($width, $height, $type, $low, $high)
	Local Static $MatPtr = _OpenCV_ObjCreate("cv.Mat")
	Local Static $cv = _OpenCV_get()
	Local Const $image = $MatPtr.create($height, $width, $type)
	$cv.randu($image, 0.0 + $low, 0.0 + $high)
	Return $image
EndFunc   ;==>_RandomImage

Func _MatSliceLastDim($oMat, $iStart, $iEnd)
	Local Static $cv = _OpenCV_get()

	Local $sizes = _OpenCV_ObjCreate("VectorOfInt")
	$sizes.push_vector($oMat.sizes())

	Local $channels = $oMat.channels()
	If $oMat.dims == 2 And $channels <> 1 Then $sizes.Add($channels)

	Local $ranges = _OpenCV_ObjCreate("VectorOfRange")
	For $i = 0 To $sizes.size() - 2
		$ranges.Add($cv.Range.all())
	Next
	$ranges.Add($cv.Range($iStart, $iEnd))

	; ; .clone().reshape(2, $actual.sizes())

	Return $cv.Mat.create($oMat.reshape(1, $sizes), $ranges)
EndFunc   ;==>_MatSliceLastDim

Func _MatDimStr($oMat)
	Local $sSize = "["
	For $iSize In $oMat.sizes
		If StringLen($sSize) <> 1 Then $sSize &= " x "
		$sSize &= $iSize
	Next
	If $oMat.dims == 2 Then $sSize &= " x " & $oMat.channels()
	$sSize &= "]"
	Return $sSize
EndFunc   ;==>_MatDimStr

; #FUNCTION# ====================================================================================================================
; Name ..........: _AsOpenCVMat
; Description ...: When passing Mat from Mediapipe to OpenCV, if the memory is not managed by OpenCV, there can sometimes be a access violation memory error.
;                  This function creates a view of a Mediapipe Mat managed by OpenCV
; Syntax ........: _AsOpenCVMat(Byref $extMat)
; Parameters ....: $extMat              - Mediapipe Mat.
; Return values .: OpenCV Mat
; Author ........: Stéphane MBAPE
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _AsOpenCVMat(ByRef $extMat)
	Local Static $cv = _OpenCV_get()
	Local $inMat = $cv.Mat
	$inMat.self = Ptr($extMat.self)
	Return $inMat
EndFunc   ;==>_AsOpenCVMat

Func _ToOpenCVMat($extMat)
	Return _AsOpenCVMat($extMat).clone()
EndFunc   ;==>_ToOpenCVMat

Func _MatGetAt($mat, $type, $i0, $i1, $i2)
	Local $pixel = DllStructCreate($type & " value[3]", $mat.ptr($i0, $i1))
	Return $pixel.value(($i2 + 1))
EndFunc   ;==>_MatGetAt

Func _MatSetAt($mat, $type, $i0, $i1, $i2, $value)
	Local $pixel = DllStructCreate($type & " value[3]", $mat.ptr($i0, $i1))
	$pixel.value(($i2 + 1)) = $value
EndFunc   ;==>_MatSetAt

Func _AssertMatEqual($oMatA, $oMatB, $sMessage = Default, $bExit = True, $iCode = Default, $iLine = @ScriptLineNumber, Const $_iCallerError = @error, Const $_vCallerExtended = @extended)
	If $sMessage == Default Then $sMessage = "expecting both matrices to be equals"

	Local $bCondition = True

	$bCondition = _AssertEqual($oMatA.rows, $oMatB.rows, "expecting both matrices to have the same number of rows", $bExit, $iCode, $iLine, $_iCallerError, $_vCallerExtended) And $bCondition
	$bCondition = _AssertEqual($oMatA.cols, $oMatB.cols, "expecting both matrices to have the same number of columns", $bExit, $iCode, $iLine, $_iCallerError, $_vCallerExtended) And $bCondition
	$bCondition = _AssertEqual($oMatA.channels(), $oMatB.channels(), "expecting both matrices to have the same number of channels", $bExit, $iCode, $iLine, $_iCallerError, $_vCallerExtended) And $bCondition
	$bCondition = _AssertEqual($oMatA.depth(), $oMatB.depth(), "expecting both matrices to have the same number of depth", $bExit, $iCode, $iLine, $_iCallerError, $_vCallerExtended) And $bCondition

	If Not $bCondition Then Return $bCondition

	Local Static $cv = _OpenCV_get()
	Local $absdiff = $cv.absdiff(_AsOpenCVMat($oMatA), _AsOpenCVMat($oMatB)).reshape(1)
	$bCondition = _AssertEqual($cv.countNonZero($absdiff), 0, $sMessage, $bExit, $iCode, $iLine, $_iCallerError, $_vCallerExtended) And $bCondition

	Return $bCondition
EndFunc   ;==>_AssertMatEqual

Func _AssertMatAlmostEqual($oMatA, $oMatB, $fDelta = Default, $fSimilarity = Default, $sMessage = Default, $bExit = True, $iCode = Default, $iLine = @ScriptLineNumber, Const $_iCallerError = @error, Const $_vCallerExtended = @extended)
	If $fDelta == Default Then $fDelta = 10 ^ - 7
	If $fSimilarity == Default Then $fSimilarity = 1
	If $sMessage == Default Then $sMessage = "expecting both matrices to be almost equals"

	Local $bCondition = True

	$bCondition = _AssertEqual($oMatA.rows, $oMatB.rows, "expecting both matrices to have the same number of rows", $bExit, $iCode, $iLine, $_iCallerError, $_vCallerExtended) And $bCondition
	$bCondition = _AssertEqual($oMatA.cols, $oMatB.cols, "expecting both matrices to have the same number of columns", $bExit, $iCode, $iLine, $_iCallerError, $_vCallerExtended) And $bCondition
	$bCondition = _AssertEqual($oMatA.channels(), $oMatB.channels(), "expecting both matrices to have the same number of channels", $bExit, $iCode, $iLine, $_iCallerError, $_vCallerExtended) And $bCondition
	$bCondition = _AssertEqual($oMatA.depth(), $oMatB.depth(), "expecting both matrices to have the same number of depth", $bExit, $iCode, $iLine, $_iCallerError, $_vCallerExtended) And $bCondition

	If Not $bCondition Then Return $bCondition

	Local Static $cv = _OpenCV_get()
	Local $absdiff = $cv.compare($cv.absdiff(_AsOpenCVMat($oMatA), _AsOpenCVMat($oMatB)).reshape(1), $fDelta, $CV_CMP_GE)

	Local $num_pixels = $oMatA.total()
	Local $consistent_pixels = $num_pixels - $cv.countNonZero($absdiff)
	Return _AssertGreaterEqual($consistent_pixels / $num_pixels, $fSimilarity, $sMessage, $bExit, $iCode, $iLine, $_iCallerError, $_vCallerExtended)
EndFunc   ;==>_AssertMatAlmostEqual

Func _AssertMatDim($oMatA, $oMatB, $sMessage = Default, $bExit = True, $iCode = Default, $iLine = @ScriptLineNumber, Const $_iCallerError = @error, Const $_vCallerExtended = @extended)
	Local $sSizeA = _MatDimStr($oMatA)
	Local $sSizeB = _MatDimStr($oMatB)
	If $sMessage == Default Then $sMessage = "expecting both matrices to have the same size and the same number of channels : " & $sSizeA & " <> " & $sSizeB
	Return _AssertEqual($sSizeA, $sSizeB, $sMessage, $bExit, $iCode, $iLine, $_iCallerError, $_vCallerExtended)
EndFunc   ;==>_AssertMatDim

Func _AssertMatLess($oMatA, $vValB, $sMessage = Default, $bExit = True, $iCode = Default, $iLine = @ScriptLineNumber, Const $_iCallerError = @error, Const $_vCallerExtended = @extended)
	Local Static $cv = _OpenCV_get()

	If IsNumber($oMatA) Then $oMatA = Number($oMatA, $NUMBER_DOUBLE)
	If IsNumber($vValB) Then $vValB = Number($vValB, $NUMBER_DOUBLE)

	If $cv.Mat.IsInstance($oMatA) And $cv.Mat.IsInstance($vValB) And $oMatA.depth() <> $vValB.depth() Then
		$oMatA = $oMatA.convertTo($vValB.depth())
	EndIf

	If $cv.Mat.IsInstance($oMatA) And IsNumber($vValB) Then
		$oMatA = $oMatA.reshape(1)
	EndIf

	If IsNumber($oMatA) And $cv.Mat.IsInstance($vValB) Then
		$vValB = $vValB.reshape(1)
	EndIf

	If $cv.Mat.IsInstance($oMatA) And $cv.Mat.IsInstance($vValB) Then
		Local $bCondition = _AssertMatDim($oMatA, $vValB, $sMessage, $bExit, $iCode, $iLine, $_iCallerError, $_vCallerExtended)
		If Not $bCondition Then Return $bCondition
	EndIf

	Local $diff = $cv.compare($oMatA, $vValB, $CV_CMP_GE)
	If $sMessage == Default Then $sMessage = "Matrices are not less-ordered"
	Return _AssertEqual($cv.countNonZero($diff), 0, $sMessage, $bExit, $iCode, $iLine, $_iCallerError, $_vCallerExtended)
EndFunc   ;==>_AssertMatLess

Func _AssertMatDiffLess($oMatA, $oMatB, $threshold, $sMessage = Default, $bExit = True, $iCode = Default, $iLine = @ScriptLineNumber, Const $_iCallerError = @error, Const $_vCallerExtended = @extended)
	Local Static $cv = _OpenCV_get()

	If IsArray($oMatA) Then $oMatA = $cv.Mat.createFromArray($oMatA, $CV_64F)
	If IsArray($oMatB) Then $oMatB = $cv.Mat.createFromArray($oMatB, $CV_64F)

	If $cv.Mat.IsInstance($oMatA) And $cv.Mat.IsInstance($oMatB) Then
		If $oMatA.depth() <> $oMatB.depth() Then
			$oMatA = $oMatA.convertTo($CV_64F)
			$oMatB = $oMatB.convertTo($CV_64F)
		EndIf

		Local $bCondition = _AssertMatDim($oMatA, $oMatB, $sMessage, $bExit, $iCode, $iLine, $_iCallerError, $_vCallerExtended)
		If Not $bCondition Then Return $bCondition
	EndIf

	; ConsoleWrite("MatA " & $cv.format($oMatA.convertTo($CV_32S)) & @CRLF)
	; ConsoleWrite("MatB " & $cv.format($oMatB.convertTo($CV_32S)) & @CRLF)

	Local $prediction_error = $cv.absdiff($oMatA, $oMatB)
	If $sMessage == Default Then $sMessage = "Diff between matrices is not less than " & $threshold
	Return _AssertMatLess($prediction_error, $threshold, $sMessage, $bExit, $iCode, $iLine, $_iCallerError, $_vCallerExtended)
EndFunc   ;==>_AssertMatDiffLess

Func _AssertMatAllClose($oMatA, $oMatB, $rtol = Default, $atol = Default, $sMessage = Default, $bExit = True, $iCode = Default, $iLine = @ScriptLineNumber, Const $_iCallerError = @error, Const $_vCallerExtended = @extended)
	Local Static $cv = _OpenCV_get()

	If IsArray($oMatA) Then $oMatA = $cv.Mat.createFromArray($oMatA, $CV_64F)
	If IsArray($oMatB) Then $oMatB = $cv.Mat.createFromArray($oMatB, $CV_64F)

	If $cv.Mat.IsInstance($oMatA) And $cv.Mat.IsInstance($oMatB) Then
		If $oMatA.depth() <> $oMatB.depth() Then
			$oMatA = $oMatA.convertTo($CV_64F)
			$oMatB = $oMatB.convertTo($CV_64F)
		EndIf

		Local $bCondition = _AssertMatDim($oMatA, $oMatB, $sMessage, $bExit, $iCode, $iLine, $_iCallerError, $_vCallerExtended)
		If Not $bCondition Then Return $bCondition
	EndIf

	; ConsoleWrite("MatA " & $cv.format($oMatA.convertTo($CV_32S)) & @CRLF)
	; ConsoleWrite("MatB " & $cv.format($oMatB.convertTo($CV_32S)) & @CRLF)

	If $rtol == Default Then $rtol = 1e-07
	If $atol == Default Then $atol = 0.0

	Local $a = $cv.absdiff($oMatA, $oMatB)
	Local $b = $cv.add($atol, $cv.multiply($rtol, $cv.absdiff($oMatB, 0.0)))

	If $sMessage == Default Then $sMessage = "Not equal to tolerance rtol=" & $rtol & ", atol=" & $atol
	Return _AssertMatLess($a, $b, $sMessage, $bExit, $iCode, $iLine, $_iCallerError, $_vCallerExtended)
EndFunc   ;==>_AssertMatAllClose

Func _AssertMatGreaterEqual($oMatA, $oMatB, $sMessage = Default, $bExit = True, $iCode = Default, $iLine = @ScriptLineNumber, Const $_iCallerError = @error, Const $_vCallerExtended = @extended)
	Local Static $cv = _OpenCV_get()
	If $sMessage == Default Then $sMessage = "Matrices are not greater or equal ordered"

	If IsNumber($oMatA) Then $oMatA = Number($oMatA, $NUMBER_DOUBLE)
	If IsNumber($oMatB) Then $oMatB = Number($oMatB, $NUMBER_DOUBLE)

	If $cv.Mat.IsInstance($oMatA) And $cv.Mat.IsInstance($oMatB) And $oMatA.depth() <> $oMatB.depth() Then
		$oMatA = $oMatA.convertTo($oMatB.depth())
	EndIf

	If $cv.Mat.IsInstance($oMatA) And IsNumber($oMatB) Then
		$oMatA = $oMatA.reshape(1)
	EndIf

	If IsNumber($oMatA) And $cv.Mat.IsInstance($oMatB) Then
		$oMatB = $oMatB.reshape(1)
	EndIf

	Local $diff = $cv.compare($oMatA, $oMatB, $CV_CMP_LT)
	Return _AssertEqual($cv.countNonZero($diff), 0, $sMessage, $bExit, $iCode, $iLine, $_iCallerError, $_vCallerExtended)
EndFunc   ;==>_AssertMatGreaterEqual
