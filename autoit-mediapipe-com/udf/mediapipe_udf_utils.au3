#include-once

#include "mediapipe_udf.au3"

#include <File.au3>
#include <GDIPlus.au3>
#include <Math.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <WinAPI.au3>

Global Const $MEDIAPIPE_UDF_SORT_ASC = 1
Global Const $MEDIAPIPE_UDF_SORT_DESC = -1

Func _Mediapipe_FindFiles($aParts, $sDir = Default, $iFlag = Default, $bReturnPath = Default, $bReverse = Default)
	If $sDir == Default Then $sDir = @ScriptDir
	If $iFlag == Default Then $iFlag = $FLTA_FILESFOLDERS
	If $bReturnPath == Default Then $bReturnPath = False
	If $bReverse == Default Then $bReverse = False

	If IsString($aParts) Then
		$aParts = StringSplit($aParts, "\", $STR_NOCOUNT)
	EndIf

	Local $aMatches[0]
	Local $bFound = False
	Local $aNextParts[0]
	Local $aFileList[0]
	Local $aNextFileList[0]
	Local $iParts = UBound($aParts)
	Local $iFound = 0, $iNextFound = 0
	Local $iLen = StringLen($sDir)
	Local $sPath = "", $iiFlags = 0

	For $i = 0 To $iParts - 1
		$bFound = False

		If ($iFlag == $FLTA_FILESFOLDERS Or $i <> $iParts - 1) And StringInStr($aParts[$i], "?") == 0 And StringInStr($aParts[$i], "*") == 0 Then
			_Mediapipe_DebugMsg("Looking for " & $sDir & "\" & $aParts[$i])
			$bFound = FileExists($sDir & "\" & $aParts[$i])
			If Not $bFound Then
				ExitLoop
			EndIf

			$sDir &= "\" & $aParts[$i]
			ContinueLoop
		EndIf

		_Mediapipe_DebugMsg("Listing " & $sDir & "\=" & $aParts[$i])
		$iiFlags = $i == $iParts - 1 ? $iFlag : $FLTA_FILESFOLDERS

		$aFileList = _FileListToArray($sDir, $aParts[$i], $iiFlags, $bReturnPath)
		If @error Then ExitLoop

		If $i == $iParts - 1 Then
			ReDim $aMatches[$aFileList[0]]

			For $j = 1 To $aFileList[0]
				$sPath = $aFileList[$j]
				If Not $bReturnPath Then
					$sPath = $sDir & "\" & $sPath
					$sPath = StringRight($sPath, StringLen($sPath) - $iLen - 1)
				EndIf
				$aMatches[$j - 1] = $sPath
			Next

			If $bReverse Then _ArrayReverse($aMatches)
			Return $aMatches
		EndIf

		ReDim $aNextParts[$iParts - $i - 1]
		For $j = $i + 1 To $iParts - 1
			$aNextParts[$j - $i - 1] = $aParts[$j]
		Next

		For $j = 1 To $aFileList[0]
			$sPath = $aFileList[$j]
			If Not $bReturnPath Then
				$sPath = $sDir & "\" & $sPath
			EndIf

			$aNextFileList = _Mediapipe_FindFiles($aNextParts, $sPath, $iFlag, $bReturnPath, $bReverse)
			$iNextFound = UBound($aNextFileList)

			If $iNextFound <> 0 Then
				ReDim $aMatches[$iFound + $iNextFound]
				For $k = 0 To $iNextFound - 1
					$sPath = $aNextFileList[$k]
					If Not $bReturnPath Then
						$sPath = $sDir & "\" & $aFileList[$j] & "\" & $sPath
						$sPath = StringRight($sPath, StringLen($sPath) - $iLen - 1)
					EndIf
					$aMatches[$iFound + $k] = $sPath
				Next
				$iFound += $iNextFound
			EndIf
		Next

		If $bReverse Then _ArrayReverse($aMatches)
		Return $aMatches
	Next

	If $bFound Then
		ReDim $aMatches[1]

		If Not $bReturnPath Then
			$sDir = StringRight($sDir, StringLen($sDir) - $iLen - 1)
		EndIf

		_Mediapipe_DebugMsg("Found " & $sDir)
		$aMatches[0] = $sDir
	EndIf

	SetError(@error)

	If $bReverse Then _ArrayReverse($aMatches)
	Return $aMatches
EndFunc   ;==>_Mediapipe_FindFiles

Func _Mediapipe_FindFile($sFile, $sFilter = Default, $sDir = Default, $iFlag = Default, $aSearchPaths = Default, $bReverse = Default)
	If $sFilter == Default Then $sFilter = ""
	If $sDir == Default Then $sDir = @ScriptDir
	If $aSearchPaths == Default Then $aSearchPaths = _Mediapipe_Tuple(1, ".")

	_Mediapipe_DebugMsg("_Mediapipe_FindFile('" & $sFile & "', '" & $sDir & "') " & VarGetType($aSearchPaths))

	Local $sFound = "", $sPath, $aFileList
	Local $sDrive = "", $sFileName = "", $sExtension = ""

	While 1
		For $i = 1 To $aSearchPaths[0]
			$sPath = ""

			If $sFilter <> "" Then
				$sPath = $sFilter
			EndIf

			If StringCompare($aSearchPaths[$i], ".") <> 0 Then
				If $sPath == "" Then
					$sPath = $aSearchPaths[$i]
				Else
					$sPath &= "\" & $aSearchPaths[$i]
				EndIf
			EndIf

			If $sPath == "" Then
				$sPath = $sFile
			Else
				$sPath &= "\" & $sFile
			EndIf

			$aFileList = _Mediapipe_FindFiles($sPath, $sDir, $iFlag, True, $bReverse)
			$sFound = UBound($aFileList) == 0 ? "" : $aFileList[0]

			If $sFound <> "" Then
				_Mediapipe_DebugMsg("Found " & $sFound & @CRLF)
				ExitLoop 2
			EndIf
		Next

		_PathSplit($sDir, $sDrive, $sDir, $sFileName, $sExtension)
		If $sDir == "" Then
			ExitLoop
		EndIf
		$sDir = $sDrive & StringLeft($sDir, StringLen($sDir) - 1)
	WEnd

	Return $sFound
EndFunc   ;==>_Mediapipe_FindFile

Func _Mediapipe_FindDLL($sFile, $sFilter = Default, $sDir = Default, $bReverse = Default)
	Local $sBuildType = $_mediapipe_build_type == "Debug" ? "Debug" : "Release"
	Local $sPostfix = $_mediapipe_build_type == "Debug" ? "d" : ""
	Local $sCompileMode = $_mediapipe_build_type == "Debug" ? "dbg" : "opt"
	Local $sBazelOut = "build_x64\mediapipe-prefix\src\mediapipe\bazel-out\x64_windows-" & _
			$sCompileMode & "\bin\mediapipe\autoit"

	Local $aSearchPaths[] = [ _
			0, _
			".", _
			"build_x64", _
			"build_x64\" & $sBuildType, _
			"build", _
			"build\x64", _
			"build\x64\vc15\bin", _
			$sBazelOut, _
			"autoit-mediapipe-com", _
			"autoit-mediapipe-com\build_x64", _
			"autoit-mediapipe-com\build_x64\" & $sBuildType, _
			"autoit-mediapipe-com\" & $sBazelOut _
			]
	$aSearchPaths[0] = UBound($aSearchPaths) - 1

	Return _Mediapipe_FindFile($sFile & $sPostfix & ".dll", $sFilter, $sDir, $FLTA_FILES, $aSearchPaths, $bReverse)
EndFunc   ;==>_Mediapipe_FindDLL

Func _Mediapipe_ArraySort(ByRef $aArray, $sCompare = Default, $iOrder = Default, $iStart = Default, $iEnd = Default)
	_Mediapipe_Sort($aArray, "__Mediapipe_ArraySize", "__Mediapipe_ArrayGetter", "__Mediapipe_ArraySetter", $sCompare, $iOrder, $iStart, $iEnd)
EndFunc   ;==>_Mediapipe_ArraySort

Func _Mediapipe_VectorSort(ByRef $oVector, $sCompare = Default, $iOrder = Default, $iStart = Default, $iEnd = Default)
	_Mediapipe_Sort($oVector, "__Mediapipe_VectorSize", "__Mediapipe_VectorGetter", "__Mediapipe_VectorSetter", $sCompare, $iOrder, $iStart, $iEnd)
EndFunc   ;==>_Mediapipe_VectorSort

; #FUNCTION# ====================================================================================================================
; Name ..........: _Mediapipe_Sort
; Description ...: Sort a collection using a custom comapator, getter, setter
; Syntax ........: _Mediapipe_ArraySort(ByRef $aArray[, $sCompare = Default[, $iOrder = Default[, $iStart = Default[,
;                  $iEnd = Default]]]])
; Parameters ....: $aArray              - [in/out] array to sort.
;                  $sGetSize            - [optional] get size function. Default is array UBound
;                  $sGetter             - [optional] getter function. Default is array getter
;                  $sSetter             - [optional] setter function. Default is array setter
;                  $sCompare            - [optional] comparator function. Default is "StringCompare".
;                  $iOrder              - [optional] sorting order. 1 for asc, -1 for desc. Default is 1.
;                  $iStart              - [optional] index of array to start sorting at. Default is 0
;                  $iEnd                - [optional] index of array to stop sorting at (included). Default is UBound($aArray) - 1
; Return values .: None
; Author ........: Stéphane MBAPE
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _Mediapipe_Sort(ByRef $aArray, $sGetSize, $sGetter, $sSetter, $sCompare = Default, $iOrder = Default, $iStart = Default, $iEnd = Default)
	Local $iUBound = Call($sGetSize, $aArray) - 1

	If $sCompare == Default Then $sCompare = "StringCompare"
	If $iOrder == Default Then $iOrder = $MEDIAPIPE_UDF_SORT_ASC
	If $iStart < 0 Or $iStart = Default Then $iStart = 0
	If $iEnd < 1 Or $iEnd > $iUBound Or $iEnd = Default Then $iEnd = $iUBound
	If $iEnd <= $iStart Then Return

	__Mediapipe_QuickSort($aArray, $sGetter, $sSetter, $sCompare, $iOrder, $iStart, $iEnd)
EndFunc   ;==>_Mediapipe_Sort

; #FUNCTION# ====================================================================================================================
; Name ..........: __Mediapipe_QuickSort
; Description ...: Helper function for sorting collections
; Syntax ........: __Mediapipe_QuickSort(ByRef $aArray, Const ByRef $sCompare, Const ByRef $iStart, Const ByRef $iEnd)
; Parameters ....: $aArray              - [in/out] array to sort.
;                  $sGetter             - [in/out and const] getter function.
;                  $sSetter             - [in/out and const] setter function.
;                  $sCompare            - [in/out and const] comparator function.
;                  $iOrder              - [optional] sorting order. 1 for asc, -1 for desc. Default is 1.
;                  $iStart              - [in/out and const] index of array to start sorting at.
;                  $iEnd                - [in/out and const] index of array to stop sorting at (included).
; Return values .: None
; Author ........: Stéphane MBAPE
; Modified ......:
; Remarks .......: A modified version of Array.au3 __ArrayQuickSort1D
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func __Mediapipe_QuickSort(ByRef $aArray, Const ByRef $sGetter, Const ByRef $sSetter, Const ByRef $sCompare, Const ByRef $iOrder, Const ByRef $iStart, Const ByRef $iEnd)
	If $iEnd <= $iStart Then Return

	Local $vTmp, $vValue

	; InsertionSort (faster for smaller segments)
	If ($iEnd - $iStart) <= 16 Then
		For $i = $iStart + 1 To $iEnd
			$vTmp = Call($sGetter, $aArray, $i)

			For $j = $i - 1 To $iStart Step -1
				$vValue = Call($sGetter, $aArray, $j)
				If Call($sCompare, $vTmp, $vValue) * $iOrder >= 0 Then ExitLoop
				Call($sSetter, $aArray, $j + 1, $vValue)
			Next

			Call($sSetter, $aArray, $j + 1, $vTmp)
		Next
		Return
	EndIf

	; QuickSort
	Local $L = $iStart, $R = $iEnd, $vPivot = Call($sGetter, $aArray, Int(($iStart + $iEnd) / 2))
	Do
		While Call($sCompare, Call($sGetter, $aArray, $L), $vPivot) * $iOrder < 0
			$L += 1
		WEnd
		While Call($sCompare, Call($sGetter, $aArray, $R), $vPivot) * $iOrder > 0
			$R -= 1
		WEnd

		; Swap
		If $L <= $R Then
			If $L <> $R Then
				$vTmp = Call($sGetter, $aArray, $L)
				Call($sSetter, $aArray, $L, Call($sGetter, $aArray, $R))
				Call($sSetter, $aArray, $R, $vTmp)
			EndIf
			$L += 1
			$R -= 1
		EndIf
	Until $L > $R

	__Mediapipe_QuickSort($aArray, $sGetter, $sSetter, $sCompare, $iOrder, $iStart, $R)
	__Mediapipe_QuickSort($aArray, $sGetter, $sSetter, $sCompare, $iOrder, $L, $iEnd)
EndFunc   ;==>__Mediapipe_QuickSort

Func __Mediapipe_ArraySize(ByRef $aArray)
	Return UBound($aArray)
EndFunc   ;==>__Mediapipe_ArraySize

Func __Mediapipe_ArrayGetter(ByRef $aArray, $i)
	Return $aArray[$i]
EndFunc   ;==>__Mediapipe_ArrayGetter

Func __Mediapipe_ArraySetter(ByRef $aArray, $i, $vValue)
	$aArray[$i] = $vValue
EndFunc   ;==>__Mediapipe_ArraySetter

Func __Mediapipe_VectorSize(ByRef $oVector)
	Return $oVector.size()
EndFunc   ;==>__Mediapipe_VectorSize

Func __Mediapipe_VectorGetter(ByRef $oVector, $i)
	Return $oVector.at($i)
EndFunc   ;==>__Mediapipe_VectorGetter

Func __Mediapipe_VectorSetter(ByRef $oVector, $i, $vValue)
	$oVector.at($i, $vValue)
EndFunc   ;==>__Mediapipe_VectorSetter

; Array.from(Array(30).keys()).map(i => `$sKey${ i + 1 } = Default, $vVal${ i + 1 } = Default`).join(", ")
Func _Mediapipe_MapOfStringAndPacket($sKey1 = Default, $vVal1 = Default, $sKey2 = Default, $vVal2 = Default, $sKey3 = Default, $vVal3 = Default, $sKey4 = Default, $vVal4 = Default, $sKey5 = Default, $vVal5 = Default, $sKey6 = Default, $vVal6 = Default, $sKey7 = Default, $vVal7 = Default, $sKey8 = Default, $vVal8 = Default, $sKey9 = Default, $vVal9 = Default, $sKey10 = Default, $vVal10 = Default, $sKey11 = Default, $vVal11 = Default, $sKey12 = Default, $vVal12 = Default, $sKey13 = Default, $vVal13 = Default, $sKey14 = Default, $vVal14 = Default, $sKey15 = Default, $vVal15 = Default, $sKey16 = Default, $vVal16 = Default, $sKey17 = Default, $vVal17 = Default, $sKey18 = Default, $vVal18 = Default, $sKey19 = Default, $vVal19 = Default, $sKey20 = Default, $vVal20 = Default, $sKey21 = Default, $vVal21 = Default, $sKey22 = Default, $vVal22 = Default, $sKey23 = Default, $vVal23 = Default, $sKey24 = Default, $vVal24 = Default, $sKey25 = Default, $vVal25 = Default, $sKey26 = Default, $vVal26 = Default, $sKey27 = Default, $vVal27 = Default, $sKey28 = Default, $vVal28 = Default, $sKey29 = Default, $vVal29 = Default, $sKey30 = Default, $vVal30 = Default)
	; console.log(Array.from(Array(30).keys()).map(j => `
	; Case ${ 2 * (j + 1) }
	;     Return $MapOfStringAndPacket.create(_Mediapipe_Tuple(${ Array.from(Array(j + 1).keys()).map(i => `_Mediapipe_Tuple($sKey${ i + 1 }, $vVal${ i + 1 })`).join(", ") }))
	; `.trim()).join("\n"))
	Local Static $MapOfStringAndPacket = _Mediapipe_ObjCreate("MapOfStringAndPacket")
	Switch @NumParams
		Case 2
			Return $MapOfStringAndPacket.create(_Mediapipe_Tuple(_Mediapipe_Tuple($sKey1, $vVal1)))
		Case 4
			Return $MapOfStringAndPacket.create(_Mediapipe_Tuple(_Mediapipe_Tuple($sKey1, $vVal1), _Mediapipe_Tuple($sKey2, $vVal2)))
		Case 6
			Return $MapOfStringAndPacket.create(_Mediapipe_Tuple(_Mediapipe_Tuple($sKey1, $vVal1), _Mediapipe_Tuple($sKey2, $vVal2), _Mediapipe_Tuple($sKey3, $vVal3)))
		Case 8
			Return $MapOfStringAndPacket.create(_Mediapipe_Tuple(_Mediapipe_Tuple($sKey1, $vVal1), _Mediapipe_Tuple($sKey2, $vVal2), _Mediapipe_Tuple($sKey3, $vVal3), _Mediapipe_Tuple($sKey4, $vVal4)))
		Case 10
			Return $MapOfStringAndPacket.create(_Mediapipe_Tuple(_Mediapipe_Tuple($sKey1, $vVal1), _Mediapipe_Tuple($sKey2, $vVal2), _Mediapipe_Tuple($sKey3, $vVal3), _Mediapipe_Tuple($sKey4, $vVal4), _Mediapipe_Tuple($sKey5, $vVal5)))
		Case 12
			Return $MapOfStringAndPacket.create(_Mediapipe_Tuple(_Mediapipe_Tuple($sKey1, $vVal1), _Mediapipe_Tuple($sKey2, $vVal2), _Mediapipe_Tuple($sKey3, $vVal3), _Mediapipe_Tuple($sKey4, $vVal4), _Mediapipe_Tuple($sKey5, $vVal5), _Mediapipe_Tuple($sKey6, $vVal6)))
		Case 14
			Return $MapOfStringAndPacket.create(_Mediapipe_Tuple(_Mediapipe_Tuple($sKey1, $vVal1), _Mediapipe_Tuple($sKey2, $vVal2), _Mediapipe_Tuple($sKey3, $vVal3), _Mediapipe_Tuple($sKey4, $vVal4), _Mediapipe_Tuple($sKey5, $vVal5), _Mediapipe_Tuple($sKey6, $vVal6), _Mediapipe_Tuple($sKey7, $vVal7)))
		Case 16
			Return $MapOfStringAndPacket.create(_Mediapipe_Tuple(_Mediapipe_Tuple($sKey1, $vVal1), _Mediapipe_Tuple($sKey2, $vVal2), _Mediapipe_Tuple($sKey3, $vVal3), _Mediapipe_Tuple($sKey4, $vVal4), _Mediapipe_Tuple($sKey5, $vVal5), _Mediapipe_Tuple($sKey6, $vVal6), _Mediapipe_Tuple($sKey7, $vVal7), _Mediapipe_Tuple($sKey8, $vVal8)))
		Case 18
			Return $MapOfStringAndPacket.create(_Mediapipe_Tuple(_Mediapipe_Tuple($sKey1, $vVal1), _Mediapipe_Tuple($sKey2, $vVal2), _Mediapipe_Tuple($sKey3, $vVal3), _Mediapipe_Tuple($sKey4, $vVal4), _Mediapipe_Tuple($sKey5, $vVal5), _Mediapipe_Tuple($sKey6, $vVal6), _Mediapipe_Tuple($sKey7, $vVal7), _Mediapipe_Tuple($sKey8, $vVal8), _Mediapipe_Tuple($sKey9, $vVal9)))
		Case 20
			Return $MapOfStringAndPacket.create(_Mediapipe_Tuple(_Mediapipe_Tuple($sKey1, $vVal1), _Mediapipe_Tuple($sKey2, $vVal2), _Mediapipe_Tuple($sKey3, $vVal3), _Mediapipe_Tuple($sKey4, $vVal4), _Mediapipe_Tuple($sKey5, $vVal5), _Mediapipe_Tuple($sKey6, $vVal6), _Mediapipe_Tuple($sKey7, $vVal7), _Mediapipe_Tuple($sKey8, $vVal8), _Mediapipe_Tuple($sKey9, $vVal9), _Mediapipe_Tuple($sKey10, $vVal10)))
		Case 22
			Return $MapOfStringAndPacket.create(_Mediapipe_Tuple(_Mediapipe_Tuple($sKey1, $vVal1), _Mediapipe_Tuple($sKey2, $vVal2), _Mediapipe_Tuple($sKey3, $vVal3), _Mediapipe_Tuple($sKey4, $vVal4), _Mediapipe_Tuple($sKey5, $vVal5), _Mediapipe_Tuple($sKey6, $vVal6), _Mediapipe_Tuple($sKey7, $vVal7), _Mediapipe_Tuple($sKey8, $vVal8), _Mediapipe_Tuple($sKey9, $vVal9), _Mediapipe_Tuple($sKey10, $vVal10), _Mediapipe_Tuple($sKey11, $vVal11)))
		Case 24
			Return $MapOfStringAndPacket.create(_Mediapipe_Tuple(_Mediapipe_Tuple($sKey1, $vVal1), _Mediapipe_Tuple($sKey2, $vVal2), _Mediapipe_Tuple($sKey3, $vVal3), _Mediapipe_Tuple($sKey4, $vVal4), _Mediapipe_Tuple($sKey5, $vVal5), _Mediapipe_Tuple($sKey6, $vVal6), _Mediapipe_Tuple($sKey7, $vVal7), _Mediapipe_Tuple($sKey8, $vVal8), _Mediapipe_Tuple($sKey9, $vVal9), _Mediapipe_Tuple($sKey10, $vVal10), _Mediapipe_Tuple($sKey11, $vVal11), _Mediapipe_Tuple($sKey12, $vVal12)))
		Case 26
			Return $MapOfStringAndPacket.create(_Mediapipe_Tuple(_Mediapipe_Tuple($sKey1, $vVal1), _Mediapipe_Tuple($sKey2, $vVal2), _Mediapipe_Tuple($sKey3, $vVal3), _Mediapipe_Tuple($sKey4, $vVal4), _Mediapipe_Tuple($sKey5, $vVal5), _Mediapipe_Tuple($sKey6, $vVal6), _Mediapipe_Tuple($sKey7, $vVal7), _Mediapipe_Tuple($sKey8, $vVal8), _Mediapipe_Tuple($sKey9, $vVal9), _Mediapipe_Tuple($sKey10, $vVal10), _Mediapipe_Tuple($sKey11, $vVal11), _Mediapipe_Tuple($sKey12, $vVal12), _Mediapipe_Tuple($sKey13, $vVal13)))
		Case 28
			Return $MapOfStringAndPacket.create(_Mediapipe_Tuple(_Mediapipe_Tuple($sKey1, $vVal1), _Mediapipe_Tuple($sKey2, $vVal2), _Mediapipe_Tuple($sKey3, $vVal3), _Mediapipe_Tuple($sKey4, $vVal4), _Mediapipe_Tuple($sKey5, $vVal5), _Mediapipe_Tuple($sKey6, $vVal6), _Mediapipe_Tuple($sKey7, $vVal7), _Mediapipe_Tuple($sKey8, $vVal8), _Mediapipe_Tuple($sKey9, $vVal9), _Mediapipe_Tuple($sKey10, $vVal10), _Mediapipe_Tuple($sKey11, $vVal11), _Mediapipe_Tuple($sKey12, $vVal12), _Mediapipe_Tuple($sKey13, $vVal13), _Mediapipe_Tuple($sKey14, $vVal14)))
		Case 30
			Return $MapOfStringAndPacket.create(_Mediapipe_Tuple(_Mediapipe_Tuple($sKey1, $vVal1), _Mediapipe_Tuple($sKey2, $vVal2), _Mediapipe_Tuple($sKey3, $vVal3), _Mediapipe_Tuple($sKey4, $vVal4), _Mediapipe_Tuple($sKey5, $vVal5), _Mediapipe_Tuple($sKey6, $vVal6), _Mediapipe_Tuple($sKey7, $vVal7), _Mediapipe_Tuple($sKey8, $vVal8), _Mediapipe_Tuple($sKey9, $vVal9), _Mediapipe_Tuple($sKey10, $vVal10), _Mediapipe_Tuple($sKey11, $vVal11), _Mediapipe_Tuple($sKey12, $vVal12), _Mediapipe_Tuple($sKey13, $vVal13), _Mediapipe_Tuple($sKey14, $vVal14), _Mediapipe_Tuple($sKey15, $vVal15)))
		Case 32
			Return $MapOfStringAndPacket.create(_Mediapipe_Tuple(_Mediapipe_Tuple($sKey1, $vVal1), _Mediapipe_Tuple($sKey2, $vVal2), _Mediapipe_Tuple($sKey3, $vVal3), _Mediapipe_Tuple($sKey4, $vVal4), _Mediapipe_Tuple($sKey5, $vVal5), _Mediapipe_Tuple($sKey6, $vVal6), _Mediapipe_Tuple($sKey7, $vVal7), _Mediapipe_Tuple($sKey8, $vVal8), _Mediapipe_Tuple($sKey9, $vVal9), _Mediapipe_Tuple($sKey10, $vVal10), _Mediapipe_Tuple($sKey11, $vVal11), _Mediapipe_Tuple($sKey12, $vVal12), _Mediapipe_Tuple($sKey13, $vVal13), _Mediapipe_Tuple($sKey14, $vVal14), _Mediapipe_Tuple($sKey15, $vVal15), _Mediapipe_Tuple($sKey16, $vVal16)))
		Case 34
			Return $MapOfStringAndPacket.create(_Mediapipe_Tuple(_Mediapipe_Tuple($sKey1, $vVal1), _Mediapipe_Tuple($sKey2, $vVal2), _Mediapipe_Tuple($sKey3, $vVal3), _Mediapipe_Tuple($sKey4, $vVal4), _Mediapipe_Tuple($sKey5, $vVal5), _Mediapipe_Tuple($sKey6, $vVal6), _Mediapipe_Tuple($sKey7, $vVal7), _Mediapipe_Tuple($sKey8, $vVal8), _Mediapipe_Tuple($sKey9, $vVal9), _Mediapipe_Tuple($sKey10, $vVal10), _Mediapipe_Tuple($sKey11, $vVal11), _Mediapipe_Tuple($sKey12, $vVal12), _Mediapipe_Tuple($sKey13, $vVal13), _Mediapipe_Tuple($sKey14, $vVal14), _Mediapipe_Tuple($sKey15, $vVal15), _Mediapipe_Tuple($sKey16, $vVal16), _Mediapipe_Tuple($sKey17, $vVal17)))
		Case 36
			Return $MapOfStringAndPacket.create(_Mediapipe_Tuple(_Mediapipe_Tuple($sKey1, $vVal1), _Mediapipe_Tuple($sKey2, $vVal2), _Mediapipe_Tuple($sKey3, $vVal3), _Mediapipe_Tuple($sKey4, $vVal4), _Mediapipe_Tuple($sKey5, $vVal5), _Mediapipe_Tuple($sKey6, $vVal6), _Mediapipe_Tuple($sKey7, $vVal7), _Mediapipe_Tuple($sKey8, $vVal8), _Mediapipe_Tuple($sKey9, $vVal9), _Mediapipe_Tuple($sKey10, $vVal10), _Mediapipe_Tuple($sKey11, $vVal11), _Mediapipe_Tuple($sKey12, $vVal12), _Mediapipe_Tuple($sKey13, $vVal13), _Mediapipe_Tuple($sKey14, $vVal14), _Mediapipe_Tuple($sKey15, $vVal15), _Mediapipe_Tuple($sKey16, $vVal16), _Mediapipe_Tuple($sKey17, $vVal17), _Mediapipe_Tuple($sKey18, $vVal18)))
		Case 38
			Return $MapOfStringAndPacket.create(_Mediapipe_Tuple(_Mediapipe_Tuple($sKey1, $vVal1), _Mediapipe_Tuple($sKey2, $vVal2), _Mediapipe_Tuple($sKey3, $vVal3), _Mediapipe_Tuple($sKey4, $vVal4), _Mediapipe_Tuple($sKey5, $vVal5), _Mediapipe_Tuple($sKey6, $vVal6), _Mediapipe_Tuple($sKey7, $vVal7), _Mediapipe_Tuple($sKey8, $vVal8), _Mediapipe_Tuple($sKey9, $vVal9), _Mediapipe_Tuple($sKey10, $vVal10), _Mediapipe_Tuple($sKey11, $vVal11), _Mediapipe_Tuple($sKey12, $vVal12), _Mediapipe_Tuple($sKey13, $vVal13), _Mediapipe_Tuple($sKey14, $vVal14), _Mediapipe_Tuple($sKey15, $vVal15), _Mediapipe_Tuple($sKey16, $vVal16), _Mediapipe_Tuple($sKey17, $vVal17), _Mediapipe_Tuple($sKey18, $vVal18), _Mediapipe_Tuple($sKey19, $vVal19)))
		Case 40
			Return $MapOfStringAndPacket.create(_Mediapipe_Tuple(_Mediapipe_Tuple($sKey1, $vVal1), _Mediapipe_Tuple($sKey2, $vVal2), _Mediapipe_Tuple($sKey3, $vVal3), _Mediapipe_Tuple($sKey4, $vVal4), _Mediapipe_Tuple($sKey5, $vVal5), _Mediapipe_Tuple($sKey6, $vVal6), _Mediapipe_Tuple($sKey7, $vVal7), _Mediapipe_Tuple($sKey8, $vVal8), _Mediapipe_Tuple($sKey9, $vVal9), _Mediapipe_Tuple($sKey10, $vVal10), _Mediapipe_Tuple($sKey11, $vVal11), _Mediapipe_Tuple($sKey12, $vVal12), _Mediapipe_Tuple($sKey13, $vVal13), _Mediapipe_Tuple($sKey14, $vVal14), _Mediapipe_Tuple($sKey15, $vVal15), _Mediapipe_Tuple($sKey16, $vVal16), _Mediapipe_Tuple($sKey17, $vVal17), _Mediapipe_Tuple($sKey18, $vVal18), _Mediapipe_Tuple($sKey19, $vVal19), _Mediapipe_Tuple($sKey20, $vVal20)))
		Case 42
			Return $MapOfStringAndPacket.create(_Mediapipe_Tuple(_Mediapipe_Tuple($sKey1, $vVal1), _Mediapipe_Tuple($sKey2, $vVal2), _Mediapipe_Tuple($sKey3, $vVal3), _Mediapipe_Tuple($sKey4, $vVal4), _Mediapipe_Tuple($sKey5, $vVal5), _Mediapipe_Tuple($sKey6, $vVal6), _Mediapipe_Tuple($sKey7, $vVal7), _Mediapipe_Tuple($sKey8, $vVal8), _Mediapipe_Tuple($sKey9, $vVal9), _Mediapipe_Tuple($sKey10, $vVal10), _Mediapipe_Tuple($sKey11, $vVal11), _Mediapipe_Tuple($sKey12, $vVal12), _Mediapipe_Tuple($sKey13, $vVal13), _Mediapipe_Tuple($sKey14, $vVal14), _Mediapipe_Tuple($sKey15, $vVal15), _Mediapipe_Tuple($sKey16, $vVal16), _Mediapipe_Tuple($sKey17, $vVal17), _Mediapipe_Tuple($sKey18, $vVal18), _Mediapipe_Tuple($sKey19, $vVal19), _Mediapipe_Tuple($sKey20, $vVal20), _Mediapipe_Tuple($sKey21, $vVal21)))
		Case 44
			Return $MapOfStringAndPacket.create(_Mediapipe_Tuple(_Mediapipe_Tuple($sKey1, $vVal1), _Mediapipe_Tuple($sKey2, $vVal2), _Mediapipe_Tuple($sKey3, $vVal3), _Mediapipe_Tuple($sKey4, $vVal4), _Mediapipe_Tuple($sKey5, $vVal5), _Mediapipe_Tuple($sKey6, $vVal6), _Mediapipe_Tuple($sKey7, $vVal7), _Mediapipe_Tuple($sKey8, $vVal8), _Mediapipe_Tuple($sKey9, $vVal9), _Mediapipe_Tuple($sKey10, $vVal10), _Mediapipe_Tuple($sKey11, $vVal11), _Mediapipe_Tuple($sKey12, $vVal12), _Mediapipe_Tuple($sKey13, $vVal13), _Mediapipe_Tuple($sKey14, $vVal14), _Mediapipe_Tuple($sKey15, $vVal15), _Mediapipe_Tuple($sKey16, $vVal16), _Mediapipe_Tuple($sKey17, $vVal17), _Mediapipe_Tuple($sKey18, $vVal18), _Mediapipe_Tuple($sKey19, $vVal19), _Mediapipe_Tuple($sKey20, $vVal20), _Mediapipe_Tuple($sKey21, $vVal21), _Mediapipe_Tuple($sKey22, $vVal22)))
		Case 46
			Return $MapOfStringAndPacket.create(_Mediapipe_Tuple(_Mediapipe_Tuple($sKey1, $vVal1), _Mediapipe_Tuple($sKey2, $vVal2), _Mediapipe_Tuple($sKey3, $vVal3), _Mediapipe_Tuple($sKey4, $vVal4), _Mediapipe_Tuple($sKey5, $vVal5), _Mediapipe_Tuple($sKey6, $vVal6), _Mediapipe_Tuple($sKey7, $vVal7), _Mediapipe_Tuple($sKey8, $vVal8), _Mediapipe_Tuple($sKey9, $vVal9), _Mediapipe_Tuple($sKey10, $vVal10), _Mediapipe_Tuple($sKey11, $vVal11), _Mediapipe_Tuple($sKey12, $vVal12), _Mediapipe_Tuple($sKey13, $vVal13), _Mediapipe_Tuple($sKey14, $vVal14), _Mediapipe_Tuple($sKey15, $vVal15), _Mediapipe_Tuple($sKey16, $vVal16), _Mediapipe_Tuple($sKey17, $vVal17), _Mediapipe_Tuple($sKey18, $vVal18), _Mediapipe_Tuple($sKey19, $vVal19), _Mediapipe_Tuple($sKey20, $vVal20), _Mediapipe_Tuple($sKey21, $vVal21), _Mediapipe_Tuple($sKey22, $vVal22), _Mediapipe_Tuple($sKey23, $vVal23)))
		Case 48
			Return $MapOfStringAndPacket.create(_Mediapipe_Tuple(_Mediapipe_Tuple($sKey1, $vVal1), _Mediapipe_Tuple($sKey2, $vVal2), _Mediapipe_Tuple($sKey3, $vVal3), _Mediapipe_Tuple($sKey4, $vVal4), _Mediapipe_Tuple($sKey5, $vVal5), _Mediapipe_Tuple($sKey6, $vVal6), _Mediapipe_Tuple($sKey7, $vVal7), _Mediapipe_Tuple($sKey8, $vVal8), _Mediapipe_Tuple($sKey9, $vVal9), _Mediapipe_Tuple($sKey10, $vVal10), _Mediapipe_Tuple($sKey11, $vVal11), _Mediapipe_Tuple($sKey12, $vVal12), _Mediapipe_Tuple($sKey13, $vVal13), _Mediapipe_Tuple($sKey14, $vVal14), _Mediapipe_Tuple($sKey15, $vVal15), _Mediapipe_Tuple($sKey16, $vVal16), _Mediapipe_Tuple($sKey17, $vVal17), _Mediapipe_Tuple($sKey18, $vVal18), _Mediapipe_Tuple($sKey19, $vVal19), _Mediapipe_Tuple($sKey20, $vVal20), _Mediapipe_Tuple($sKey21, $vVal21), _Mediapipe_Tuple($sKey22, $vVal22), _Mediapipe_Tuple($sKey23, $vVal23), _Mediapipe_Tuple($sKey24, $vVal24)))
		Case 50
			Return $MapOfStringAndPacket.create(_Mediapipe_Tuple(_Mediapipe_Tuple($sKey1, $vVal1), _Mediapipe_Tuple($sKey2, $vVal2), _Mediapipe_Tuple($sKey3, $vVal3), _Mediapipe_Tuple($sKey4, $vVal4), _Mediapipe_Tuple($sKey5, $vVal5), _Mediapipe_Tuple($sKey6, $vVal6), _Mediapipe_Tuple($sKey7, $vVal7), _Mediapipe_Tuple($sKey8, $vVal8), _Mediapipe_Tuple($sKey9, $vVal9), _Mediapipe_Tuple($sKey10, $vVal10), _Mediapipe_Tuple($sKey11, $vVal11), _Mediapipe_Tuple($sKey12, $vVal12), _Mediapipe_Tuple($sKey13, $vVal13), _Mediapipe_Tuple($sKey14, $vVal14), _Mediapipe_Tuple($sKey15, $vVal15), _Mediapipe_Tuple($sKey16, $vVal16), _Mediapipe_Tuple($sKey17, $vVal17), _Mediapipe_Tuple($sKey18, $vVal18), _Mediapipe_Tuple($sKey19, $vVal19), _Mediapipe_Tuple($sKey20, $vVal20), _Mediapipe_Tuple($sKey21, $vVal21), _Mediapipe_Tuple($sKey22, $vVal22), _Mediapipe_Tuple($sKey23, $vVal23), _Mediapipe_Tuple($sKey24, $vVal24), _Mediapipe_Tuple($sKey25, $vVal25)))
		Case 52
			Return $MapOfStringAndPacket.create(_Mediapipe_Tuple(_Mediapipe_Tuple($sKey1, $vVal1), _Mediapipe_Tuple($sKey2, $vVal2), _Mediapipe_Tuple($sKey3, $vVal3), _Mediapipe_Tuple($sKey4, $vVal4), _Mediapipe_Tuple($sKey5, $vVal5), _Mediapipe_Tuple($sKey6, $vVal6), _Mediapipe_Tuple($sKey7, $vVal7), _Mediapipe_Tuple($sKey8, $vVal8), _Mediapipe_Tuple($sKey9, $vVal9), _Mediapipe_Tuple($sKey10, $vVal10), _Mediapipe_Tuple($sKey11, $vVal11), _Mediapipe_Tuple($sKey12, $vVal12), _Mediapipe_Tuple($sKey13, $vVal13), _Mediapipe_Tuple($sKey14, $vVal14), _Mediapipe_Tuple($sKey15, $vVal15), _Mediapipe_Tuple($sKey16, $vVal16), _Mediapipe_Tuple($sKey17, $vVal17), _Mediapipe_Tuple($sKey18, $vVal18), _Mediapipe_Tuple($sKey19, $vVal19), _Mediapipe_Tuple($sKey20, $vVal20), _Mediapipe_Tuple($sKey21, $vVal21), _Mediapipe_Tuple($sKey22, $vVal22), _Mediapipe_Tuple($sKey23, $vVal23), _Mediapipe_Tuple($sKey24, $vVal24), _Mediapipe_Tuple($sKey25, $vVal25), _Mediapipe_Tuple($sKey26, $vVal26)))
		Case 54
			Return $MapOfStringAndPacket.create(_Mediapipe_Tuple(_Mediapipe_Tuple($sKey1, $vVal1), _Mediapipe_Tuple($sKey2, $vVal2), _Mediapipe_Tuple($sKey3, $vVal3), _Mediapipe_Tuple($sKey4, $vVal4), _Mediapipe_Tuple($sKey5, $vVal5), _Mediapipe_Tuple($sKey6, $vVal6), _Mediapipe_Tuple($sKey7, $vVal7), _Mediapipe_Tuple($sKey8, $vVal8), _Mediapipe_Tuple($sKey9, $vVal9), _Mediapipe_Tuple($sKey10, $vVal10), _Mediapipe_Tuple($sKey11, $vVal11), _Mediapipe_Tuple($sKey12, $vVal12), _Mediapipe_Tuple($sKey13, $vVal13), _Mediapipe_Tuple($sKey14, $vVal14), _Mediapipe_Tuple($sKey15, $vVal15), _Mediapipe_Tuple($sKey16, $vVal16), _Mediapipe_Tuple($sKey17, $vVal17), _Mediapipe_Tuple($sKey18, $vVal18), _Mediapipe_Tuple($sKey19, $vVal19), _Mediapipe_Tuple($sKey20, $vVal20), _Mediapipe_Tuple($sKey21, $vVal21), _Mediapipe_Tuple($sKey22, $vVal22), _Mediapipe_Tuple($sKey23, $vVal23), _Mediapipe_Tuple($sKey24, $vVal24), _Mediapipe_Tuple($sKey25, $vVal25), _Mediapipe_Tuple($sKey26, $vVal26), _Mediapipe_Tuple($sKey27, $vVal27)))
		Case 56
			Return $MapOfStringAndPacket.create(_Mediapipe_Tuple(_Mediapipe_Tuple($sKey1, $vVal1), _Mediapipe_Tuple($sKey2, $vVal2), _Mediapipe_Tuple($sKey3, $vVal3), _Mediapipe_Tuple($sKey4, $vVal4), _Mediapipe_Tuple($sKey5, $vVal5), _Mediapipe_Tuple($sKey6, $vVal6), _Mediapipe_Tuple($sKey7, $vVal7), _Mediapipe_Tuple($sKey8, $vVal8), _Mediapipe_Tuple($sKey9, $vVal9), _Mediapipe_Tuple($sKey10, $vVal10), _Mediapipe_Tuple($sKey11, $vVal11), _Mediapipe_Tuple($sKey12, $vVal12), _Mediapipe_Tuple($sKey13, $vVal13), _Mediapipe_Tuple($sKey14, $vVal14), _Mediapipe_Tuple($sKey15, $vVal15), _Mediapipe_Tuple($sKey16, $vVal16), _Mediapipe_Tuple($sKey17, $vVal17), _Mediapipe_Tuple($sKey18, $vVal18), _Mediapipe_Tuple($sKey19, $vVal19), _Mediapipe_Tuple($sKey20, $vVal20), _Mediapipe_Tuple($sKey21, $vVal21), _Mediapipe_Tuple($sKey22, $vVal22), _Mediapipe_Tuple($sKey23, $vVal23), _Mediapipe_Tuple($sKey24, $vVal24), _Mediapipe_Tuple($sKey25, $vVal25), _Mediapipe_Tuple($sKey26, $vVal26), _Mediapipe_Tuple($sKey27, $vVal27), _Mediapipe_Tuple($sKey28, $vVal28)))
		Case 58
			Return $MapOfStringAndPacket.create(_Mediapipe_Tuple(_Mediapipe_Tuple($sKey1, $vVal1), _Mediapipe_Tuple($sKey2, $vVal2), _Mediapipe_Tuple($sKey3, $vVal3), _Mediapipe_Tuple($sKey4, $vVal4), _Mediapipe_Tuple($sKey5, $vVal5), _Mediapipe_Tuple($sKey6, $vVal6), _Mediapipe_Tuple($sKey7, $vVal7), _Mediapipe_Tuple($sKey8, $vVal8), _Mediapipe_Tuple($sKey9, $vVal9), _Mediapipe_Tuple($sKey10, $vVal10), _Mediapipe_Tuple($sKey11, $vVal11), _Mediapipe_Tuple($sKey12, $vVal12), _Mediapipe_Tuple($sKey13, $vVal13), _Mediapipe_Tuple($sKey14, $vVal14), _Mediapipe_Tuple($sKey15, $vVal15), _Mediapipe_Tuple($sKey16, $vVal16), _Mediapipe_Tuple($sKey17, $vVal17), _Mediapipe_Tuple($sKey18, $vVal18), _Mediapipe_Tuple($sKey19, $vVal19), _Mediapipe_Tuple($sKey20, $vVal20), _Mediapipe_Tuple($sKey21, $vVal21), _Mediapipe_Tuple($sKey22, $vVal22), _Mediapipe_Tuple($sKey23, $vVal23), _Mediapipe_Tuple($sKey24, $vVal24), _Mediapipe_Tuple($sKey25, $vVal25), _Mediapipe_Tuple($sKey26, $vVal26), _Mediapipe_Tuple($sKey27, $vVal27), _Mediapipe_Tuple($sKey28, $vVal28), _Mediapipe_Tuple($sKey29, $vVal29)))
		Case 60
			Return $MapOfStringAndPacket.create(_Mediapipe_Tuple(_Mediapipe_Tuple($sKey1, $vVal1), _Mediapipe_Tuple($sKey2, $vVal2), _Mediapipe_Tuple($sKey3, $vVal3), _Mediapipe_Tuple($sKey4, $vVal4), _Mediapipe_Tuple($sKey5, $vVal5), _Mediapipe_Tuple($sKey6, $vVal6), _Mediapipe_Tuple($sKey7, $vVal7), _Mediapipe_Tuple($sKey8, $vVal8), _Mediapipe_Tuple($sKey9, $vVal9), _Mediapipe_Tuple($sKey10, $vVal10), _Mediapipe_Tuple($sKey11, $vVal11), _Mediapipe_Tuple($sKey12, $vVal12), _Mediapipe_Tuple($sKey13, $vVal13), _Mediapipe_Tuple($sKey14, $vVal14), _Mediapipe_Tuple($sKey15, $vVal15), _Mediapipe_Tuple($sKey16, $vVal16), _Mediapipe_Tuple($sKey17, $vVal17), _Mediapipe_Tuple($sKey18, $vVal18), _Mediapipe_Tuple($sKey19, $vVal19), _Mediapipe_Tuple($sKey20, $vVal20), _Mediapipe_Tuple($sKey21, $vVal21), _Mediapipe_Tuple($sKey22, $vVal22), _Mediapipe_Tuple($sKey23, $vVal23), _Mediapipe_Tuple($sKey24, $vVal24), _Mediapipe_Tuple($sKey25, $vVal25), _Mediapipe_Tuple($sKey26, $vVal26), _Mediapipe_Tuple($sKey27, $vVal27), _Mediapipe_Tuple($sKey28, $vVal28), _Mediapipe_Tuple($sKey29, $vVal29), _Mediapipe_Tuple($sKey30, $vVal30)))
		Case Else
			ConsoleWriteError('!>Error: Invalid number of arguments')
			Return SetError(1, 0, -1)
	EndSwitch
EndFunc   ;==>_Mediapipe_MapOfStringAndPacket
