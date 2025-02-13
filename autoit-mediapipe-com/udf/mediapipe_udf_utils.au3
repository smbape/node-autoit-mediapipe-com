#include-once

#include "mediapipe_udf.au3"

#include <GDIPlus.au3>
#include <Math.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <WinAPI.au3>

Global Const $MEDIAPIPE_UDF_SORT_ASC = 1
Global Const $MEDIAPIPE_UDF_SORT_DESC = -1

Func _Mediapipe_FindDLL($sFile, $sFilter = Default, $sDir = Default, $bReverse = Default)
	Local $_mediapipe_build_type = EnvGet("MEDIAPIPE_BUILD_TYPE")
	Local $sBuildType = $_mediapipe_build_type == "Debug" ? "Debug" : "Release"
	Local $sPostfix = $_mediapipe_build_type == "Debug" ? "d" : ""

	Local $aSearchPaths[] = [ _
			".", _
			"autoit-mediapipe-com", _
			"autoit-mediapipe-com\build_x64\bin\" & $sBuildType, _
			"autoit-opencv-com", _
			"autoit-opencv-com\build_x64\bin\" & $sBuildType, _
			"opencv\build\x64\vc16\bin", _
			"opencv-4.10.0-*\build\x64\vc16\bin", _
			"opencv-4.10.0-*\opencv\build\x64\vc16\bin" _
			]

	Return _Mediapipe_FindFile($sFile & $sPostfix & ".dll", $sFilter, $sDir, $FLTA_FILES, $aSearchPaths, $bReverse)
EndFunc   ;==>_Mediapipe_FindDLL

; #FUNCTION# ====================================================================================================================
; Name ..........: _Mediapipe_GetDevices
; Description ...: Return devices
; Syntax ........: _Mediapipe_GetDevices([$iDeviceCategory = Default])
; Parameters ....: $iDeviceCategory     - [optional] device type to return. Default is 2.
;                                         $iDeviceCategory = 0 : Audio and Video devices
;                                         $iDeviceCategory = 1 : Audio devices
;                                         $iDeviceCategory = 2 : Video devices
; Return values .: None
; Author ........: Your Name
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _Mediapipe_GetDevices($iDeviceCategory = Default)
	Local $devices = _Mediapipe_ObjCreate("VectorOfString")

	If $iDeviceCategory == 0 Then
		$devices.push_vector(_Mediapipe_GetDevices(1))
		$devices.push_vector(_Mediapipe_GetDevices(2))
		Return $devices
	EndIf

	;===============================================================================
	#interface "ICreateDevEnum"
	Local Static $sCLSID_SystemDeviceEnum = '{62BE5D10-60EB-11D0-BD3B-00A0C911CE86}'
	Local Static $sIID_ICreateDevEnum = '{29840822-5B84-11D0-BD3B-00A0C911CE86}'
	Local Static $tagICreateDevEnum = "CreateClassEnumerator hresult(clsid;ptr*;dword);"
	;===============================END=============================================

	;===============================================================================
	#interface "IEnumMoniker"
	Local Static $sIID_IEnumMoniker = '{00000102-0000-0000-C000-000000000046}'
	Local Static $tagIEnumMoniker = "Next hresult(dword;ptr*;dword*);" & _
			"Skip hresult(dword);" & _
			"Reset hresult();" & _
			"Clone hresult(ptr*);"
	;===============================END=============================================

	;===============================================================================
	#interface "IMoniker"
	Local Static $sIID_IMoniker = '{0000000F-0000-0000-C000-000000000046}'
	Local Static $tagIMoniker = "GetClassID hresult( clsid )" & _
			"IsDirty hresult(  );" & _
			"Load hresult( ptr );" & _
			"Save hresult( ptr, bool );" & _
			"GetSizeMax hresult( uint64 );" & _
			"BindToObject hresult( ptr;ptr;clsid;ptr*);" & _
			"BindToStorage hresult( ptr;ptr;clsid;ptr*);" & _
			"Reduce hresult( ptr;dword;ptr*;ptr*);" & _
			"ComposeWith hresult( ptr;bool;ptr*);" & _
			"Enum hresult( bool;ptr*);" & _
			"IsEqual hresult( ptr);" & _
			"Hash hresult( dword);" & _
			"IsRunning hresult( ptr;ptr;ptr);" & _
			"GetTimeOfLastChange hresult( ptr;ptr;uint64);" & _
			"Inverse hresult( ptr*);" & _
			"CommonPrefixWith hresult( ptr;ptr*);" & _
			"RelativePathTo hresult( ptr;ptr*);" & _
			"GetDisplayName hresult( ptr;ptr;ushort);" & _
			"ParseDisplayName hresult( ptr;ptr;ushort;ulong;ptr*);" & _
			"IsSystemMoniker hresult( dword);"
	;===============================END=============================================

	;===============================================================================
	#interface "IPropertyBag"
	Local Static $sIID_IPropertyBag = '{55272A00-42CB-11CE-8135-00AA004BB851}'
	Local Static $tagIPropertyBag = "Read hresult( wstr;variant*;ptr* );" & _
			"Write hresult( wstr;variant );"
	;===============================END=============================================

	Local Static $S_FALSE = 1
	Local Static $VFW_E_NOT_FOUND = 0x80040216
	Local Static $sCLSID_AudioInputDeviceCategory = '{33D9A762-90C8-11D0-BD43-00A0C911CE86}'
	Local Static $sCLSID_VideoInputDeviceCategory = '{860BB310-5D01-11D0-BD3B-00A0C911CE86}'

	Local $sCLSID_category = $iDeviceCategory == 1 ? $sCLSID_AudioInputDeviceCategory : $sCLSID_VideoInputDeviceCategory

	;  // Create a helper object To find the capture device.
	;  hr = CoCreateInstance(CLSID_SystemDeviceEnum, Null, CLSCTX_INPROC_SERVER, IID_ICreateDevEnum, (LPVOID *) & pDevEnum);
	Local $oDevEnum = ObjCreateInterface($sCLSID_SystemDeviceEnum, $sIID_ICreateDevEnum, $tagICreateDevEnum)
	If Not IsObj($oDevEnum) Then
		ConsoleWriteError('@@ Debug(' & @ScriptLineNumber & ') : Failed to create SystemDeviceEnum' & @CRLF)
		Return $devices
	EndIf

	; IEnumMoniker *pEnum = 0;
	; hr = pDevEnum->CreateClassEnumerator(CLSID_category, &pEnum, 0);
	Local $pEnum = 0
	Local $hr = $oDevEnum.CreateClassEnumerator($sCLSID_category, $pEnum, 0)
	If $hr == $S_FALSE Then
		$hr = $VFW_E_NOT_FOUND ; The category is empty. Treat as an error.
	EndIf

	If $hr < 0 Then
		ConsoleWriteError('@@ Debug(' & @ScriptLineNumber & ') : Failed to create the device enumerator' & @CRLF)
		Return $devices
	EndIf

	Local $oEnum = ObjCreateInterface(Ptr($pEnum), $sIID_IEnumMoniker, $tagIEnumMoniker)
	If Not IsObj($oEnum) Then
		ConsoleWriteError('@@ Debug(' & @ScriptLineNumber & ') : Failed to enumerate devices' & @CRLF)
	EndIf

	; IMoniker *pMoniker = 0;
	Local $pMoniker, $oMoniker, $pPropBag, $oPropBag, $var

	; while (pEnum->Next(1, &pMoniker, NULL) == S_OK) {
	While $oEnum.Next(1, $pMoniker, 0) == $S_OK
		$oMoniker = ObjCreateInterface($pMoniker, $sIID_IMoniker, $tagIMoniker)
		If Not IsObj($oMoniker) Then
			ConsoleWriteError('@@ Debug(' & @ScriptLineNumber & ') : Failed to get device' & @CRLF)
			ContinueLoop
		EndIf

		; HRESULT hr = pMoniker->BindToStorage(0, 0, IID_PPV_ARGS(&pPropBag));
		$hr = $oMoniker.BindToStorage(0, 0, $sIID_IPropertyBag, $pPropBag)
		If $hr < 0 Then
			ConsoleWriteError('@@ Debug(' & @ScriptLineNumber & ') : Failed bind device properties' & @CRLF)
			ContinueLoop
		EndIf

		$oPropBag = ObjCreateInterface($pPropBag, $sIID_IPropertyBag, $tagIPropertyBag)
		If Not IsObj($oPropBag) Then
			ConsoleWriteError('@@ Debug(' & @ScriptLineNumber & ') : Failed to get device properties' & @CRLF)
			ContinueLoop
		EndIf

		; hr = pPropBag->Read(L"Description", &var, 0);
		$hr = $oPropBag.Read('Description', $var, 0)
		If $hr < 0 Then
			; hr = pPropBag->Read(L"FriendlyName", &var, 0);
			$hr = $oPropBag.Read('FriendlyName', $var, 0)
		EndIf

		If $hr < 0 Then
			ConsoleWriteError('@@ Debug(' & @ScriptLineNumber & ') : Failed get device FriendlyName' & @CRLF)
			ContinueLoop
		EndIf

		$devices.Add($var)
	WEnd

	Return $devices
EndFunc   ;==>_Mediapipe_GetDevices

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

; Array.from(Array(30).keys()).map(i => `$sKey${ i + 1 } = Default, $vVal${ i + 1 } = Default`).join(", ")
Func _Mediapipe_MapOfStringAndVariant($sKey1 = Default, $vVal1 = Default, $sKey2 = Default, $vVal2 = Default, $sKey3 = Default, $vVal3 = Default, $sKey4 = Default, $vVal4 = Default, $sKey5 = Default, $vVal5 = Default, $sKey6 = Default, $vVal6 = Default, $sKey7 = Default, $vVal7 = Default, $sKey8 = Default, $vVal8 = Default, $sKey9 = Default, $vVal9 = Default, $sKey10 = Default, $vVal10 = Default, $sKey11 = Default, $vVal11 = Default, $sKey12 = Default, $vVal12 = Default, $sKey13 = Default, $vVal13 = Default, $sKey14 = Default, $vVal14 = Default, $sKey15 = Default, $vVal15 = Default, $sKey16 = Default, $vVal16 = Default, $sKey17 = Default, $vVal17 = Default, $sKey18 = Default, $vVal18 = Default, $sKey19 = Default, $vVal19 = Default, $sKey20 = Default, $vVal20 = Default, $sKey21 = Default, $vVal21 = Default, $sKey22 = Default, $vVal22 = Default, $sKey23 = Default, $vVal23 = Default, $sKey24 = Default, $vVal24 = Default, $sKey25 = Default, $vVal25 = Default, $sKey26 = Default, $vVal26 = Default, $sKey27 = Default, $vVal27 = Default, $sKey28 = Default, $vVal28 = Default, $sKey29 = Default, $vVal29 = Default, $sKey30 = Default, $vVal30 = Default)
	; console.log(Array.from(Array(30).keys()).map(j => `
	; Case ${ 2 * (j + 1) }
	;     Return $MapOfStringAndVariant.create(_Mediapipe_Tuple(${ Array.from(Array(j + 1).keys()).map(i => `_Mediapipe_Tuple($sKey${ i + 1 }, $vVal${ i + 1 })`).join(", ") }))
	; `.trim()).join("\n"))
	Local Static $MapOfStringAndVariant = _Mediapipe_ObjCreate("MapOfStringAndVariant")
	Switch @NumParams
		Case 2
			Return $MapOfStringAndVariant.create(_Mediapipe_Tuple(_Mediapipe_Tuple($sKey1, $vVal1)))
		Case 4
			Return $MapOfStringAndVariant.create(_Mediapipe_Tuple(_Mediapipe_Tuple($sKey1, $vVal1), _Mediapipe_Tuple($sKey2, $vVal2)))
		Case 6
			Return $MapOfStringAndVariant.create(_Mediapipe_Tuple(_Mediapipe_Tuple($sKey1, $vVal1), _Mediapipe_Tuple($sKey2, $vVal2), _Mediapipe_Tuple($sKey3, $vVal3)))
		Case 8
			Return $MapOfStringAndVariant.create(_Mediapipe_Tuple(_Mediapipe_Tuple($sKey1, $vVal1), _Mediapipe_Tuple($sKey2, $vVal2), _Mediapipe_Tuple($sKey3, $vVal3), _Mediapipe_Tuple($sKey4, $vVal4)))
		Case 10
			Return $MapOfStringAndVariant.create(_Mediapipe_Tuple(_Mediapipe_Tuple($sKey1, $vVal1), _Mediapipe_Tuple($sKey2, $vVal2), _Mediapipe_Tuple($sKey3, $vVal3), _Mediapipe_Tuple($sKey4, $vVal4), _Mediapipe_Tuple($sKey5, $vVal5)))
		Case 12
			Return $MapOfStringAndVariant.create(_Mediapipe_Tuple(_Mediapipe_Tuple($sKey1, $vVal1), _Mediapipe_Tuple($sKey2, $vVal2), _Mediapipe_Tuple($sKey3, $vVal3), _Mediapipe_Tuple($sKey4, $vVal4), _Mediapipe_Tuple($sKey5, $vVal5), _Mediapipe_Tuple($sKey6, $vVal6)))
		Case 14
			Return $MapOfStringAndVariant.create(_Mediapipe_Tuple(_Mediapipe_Tuple($sKey1, $vVal1), _Mediapipe_Tuple($sKey2, $vVal2), _Mediapipe_Tuple($sKey3, $vVal3), _Mediapipe_Tuple($sKey4, $vVal4), _Mediapipe_Tuple($sKey5, $vVal5), _Mediapipe_Tuple($sKey6, $vVal6), _Mediapipe_Tuple($sKey7, $vVal7)))
		Case 16
			Return $MapOfStringAndVariant.create(_Mediapipe_Tuple(_Mediapipe_Tuple($sKey1, $vVal1), _Mediapipe_Tuple($sKey2, $vVal2), _Mediapipe_Tuple($sKey3, $vVal3), _Mediapipe_Tuple($sKey4, $vVal4), _Mediapipe_Tuple($sKey5, $vVal5), _Mediapipe_Tuple($sKey6, $vVal6), _Mediapipe_Tuple($sKey7, $vVal7), _Mediapipe_Tuple($sKey8, $vVal8)))
		Case 18
			Return $MapOfStringAndVariant.create(_Mediapipe_Tuple(_Mediapipe_Tuple($sKey1, $vVal1), _Mediapipe_Tuple($sKey2, $vVal2), _Mediapipe_Tuple($sKey3, $vVal3), _Mediapipe_Tuple($sKey4, $vVal4), _Mediapipe_Tuple($sKey5, $vVal5), _Mediapipe_Tuple($sKey6, $vVal6), _Mediapipe_Tuple($sKey7, $vVal7), _Mediapipe_Tuple($sKey8, $vVal8), _Mediapipe_Tuple($sKey9, $vVal9)))
		Case 20
			Return $MapOfStringAndVariant.create(_Mediapipe_Tuple(_Mediapipe_Tuple($sKey1, $vVal1), _Mediapipe_Tuple($sKey2, $vVal2), _Mediapipe_Tuple($sKey3, $vVal3), _Mediapipe_Tuple($sKey4, $vVal4), _Mediapipe_Tuple($sKey5, $vVal5), _Mediapipe_Tuple($sKey6, $vVal6), _Mediapipe_Tuple($sKey7, $vVal7), _Mediapipe_Tuple($sKey8, $vVal8), _Mediapipe_Tuple($sKey9, $vVal9), _Mediapipe_Tuple($sKey10, $vVal10)))
		Case 22
			Return $MapOfStringAndVariant.create(_Mediapipe_Tuple(_Mediapipe_Tuple($sKey1, $vVal1), _Mediapipe_Tuple($sKey2, $vVal2), _Mediapipe_Tuple($sKey3, $vVal3), _Mediapipe_Tuple($sKey4, $vVal4), _Mediapipe_Tuple($sKey5, $vVal5), _Mediapipe_Tuple($sKey6, $vVal6), _Mediapipe_Tuple($sKey7, $vVal7), _Mediapipe_Tuple($sKey8, $vVal8), _Mediapipe_Tuple($sKey9, $vVal9), _Mediapipe_Tuple($sKey10, $vVal10), _Mediapipe_Tuple($sKey11, $vVal11)))
		Case 24
			Return $MapOfStringAndVariant.create(_Mediapipe_Tuple(_Mediapipe_Tuple($sKey1, $vVal1), _Mediapipe_Tuple($sKey2, $vVal2), _Mediapipe_Tuple($sKey3, $vVal3), _Mediapipe_Tuple($sKey4, $vVal4), _Mediapipe_Tuple($sKey5, $vVal5), _Mediapipe_Tuple($sKey6, $vVal6), _Mediapipe_Tuple($sKey7, $vVal7), _Mediapipe_Tuple($sKey8, $vVal8), _Mediapipe_Tuple($sKey9, $vVal9), _Mediapipe_Tuple($sKey10, $vVal10), _Mediapipe_Tuple($sKey11, $vVal11), _Mediapipe_Tuple($sKey12, $vVal12)))
		Case 26
			Return $MapOfStringAndVariant.create(_Mediapipe_Tuple(_Mediapipe_Tuple($sKey1, $vVal1), _Mediapipe_Tuple($sKey2, $vVal2), _Mediapipe_Tuple($sKey3, $vVal3), _Mediapipe_Tuple($sKey4, $vVal4), _Mediapipe_Tuple($sKey5, $vVal5), _Mediapipe_Tuple($sKey6, $vVal6), _Mediapipe_Tuple($sKey7, $vVal7), _Mediapipe_Tuple($sKey8, $vVal8), _Mediapipe_Tuple($sKey9, $vVal9), _Mediapipe_Tuple($sKey10, $vVal10), _Mediapipe_Tuple($sKey11, $vVal11), _Mediapipe_Tuple($sKey12, $vVal12), _Mediapipe_Tuple($sKey13, $vVal13)))
		Case 28
			Return $MapOfStringAndVariant.create(_Mediapipe_Tuple(_Mediapipe_Tuple($sKey1, $vVal1), _Mediapipe_Tuple($sKey2, $vVal2), _Mediapipe_Tuple($sKey3, $vVal3), _Mediapipe_Tuple($sKey4, $vVal4), _Mediapipe_Tuple($sKey5, $vVal5), _Mediapipe_Tuple($sKey6, $vVal6), _Mediapipe_Tuple($sKey7, $vVal7), _Mediapipe_Tuple($sKey8, $vVal8), _Mediapipe_Tuple($sKey9, $vVal9), _Mediapipe_Tuple($sKey10, $vVal10), _Mediapipe_Tuple($sKey11, $vVal11), _Mediapipe_Tuple($sKey12, $vVal12), _Mediapipe_Tuple($sKey13, $vVal13), _Mediapipe_Tuple($sKey14, $vVal14)))
		Case 30
			Return $MapOfStringAndVariant.create(_Mediapipe_Tuple(_Mediapipe_Tuple($sKey1, $vVal1), _Mediapipe_Tuple($sKey2, $vVal2), _Mediapipe_Tuple($sKey3, $vVal3), _Mediapipe_Tuple($sKey4, $vVal4), _Mediapipe_Tuple($sKey5, $vVal5), _Mediapipe_Tuple($sKey6, $vVal6), _Mediapipe_Tuple($sKey7, $vVal7), _Mediapipe_Tuple($sKey8, $vVal8), _Mediapipe_Tuple($sKey9, $vVal9), _Mediapipe_Tuple($sKey10, $vVal10), _Mediapipe_Tuple($sKey11, $vVal11), _Mediapipe_Tuple($sKey12, $vVal12), _Mediapipe_Tuple($sKey13, $vVal13), _Mediapipe_Tuple($sKey14, $vVal14), _Mediapipe_Tuple($sKey15, $vVal15)))
		Case 32
			Return $MapOfStringAndVariant.create(_Mediapipe_Tuple(_Mediapipe_Tuple($sKey1, $vVal1), _Mediapipe_Tuple($sKey2, $vVal2), _Mediapipe_Tuple($sKey3, $vVal3), _Mediapipe_Tuple($sKey4, $vVal4), _Mediapipe_Tuple($sKey5, $vVal5), _Mediapipe_Tuple($sKey6, $vVal6), _Mediapipe_Tuple($sKey7, $vVal7), _Mediapipe_Tuple($sKey8, $vVal8), _Mediapipe_Tuple($sKey9, $vVal9), _Mediapipe_Tuple($sKey10, $vVal10), _Mediapipe_Tuple($sKey11, $vVal11), _Mediapipe_Tuple($sKey12, $vVal12), _Mediapipe_Tuple($sKey13, $vVal13), _Mediapipe_Tuple($sKey14, $vVal14), _Mediapipe_Tuple($sKey15, $vVal15), _Mediapipe_Tuple($sKey16, $vVal16)))
		Case 34
			Return $MapOfStringAndVariant.create(_Mediapipe_Tuple(_Mediapipe_Tuple($sKey1, $vVal1), _Mediapipe_Tuple($sKey2, $vVal2), _Mediapipe_Tuple($sKey3, $vVal3), _Mediapipe_Tuple($sKey4, $vVal4), _Mediapipe_Tuple($sKey5, $vVal5), _Mediapipe_Tuple($sKey6, $vVal6), _Mediapipe_Tuple($sKey7, $vVal7), _Mediapipe_Tuple($sKey8, $vVal8), _Mediapipe_Tuple($sKey9, $vVal9), _Mediapipe_Tuple($sKey10, $vVal10), _Mediapipe_Tuple($sKey11, $vVal11), _Mediapipe_Tuple($sKey12, $vVal12), _Mediapipe_Tuple($sKey13, $vVal13), _Mediapipe_Tuple($sKey14, $vVal14), _Mediapipe_Tuple($sKey15, $vVal15), _Mediapipe_Tuple($sKey16, $vVal16), _Mediapipe_Tuple($sKey17, $vVal17)))
		Case 36
			Return $MapOfStringAndVariant.create(_Mediapipe_Tuple(_Mediapipe_Tuple($sKey1, $vVal1), _Mediapipe_Tuple($sKey2, $vVal2), _Mediapipe_Tuple($sKey3, $vVal3), _Mediapipe_Tuple($sKey4, $vVal4), _Mediapipe_Tuple($sKey5, $vVal5), _Mediapipe_Tuple($sKey6, $vVal6), _Mediapipe_Tuple($sKey7, $vVal7), _Mediapipe_Tuple($sKey8, $vVal8), _Mediapipe_Tuple($sKey9, $vVal9), _Mediapipe_Tuple($sKey10, $vVal10), _Mediapipe_Tuple($sKey11, $vVal11), _Mediapipe_Tuple($sKey12, $vVal12), _Mediapipe_Tuple($sKey13, $vVal13), _Mediapipe_Tuple($sKey14, $vVal14), _Mediapipe_Tuple($sKey15, $vVal15), _Mediapipe_Tuple($sKey16, $vVal16), _Mediapipe_Tuple($sKey17, $vVal17), _Mediapipe_Tuple($sKey18, $vVal18)))
		Case 38
			Return $MapOfStringAndVariant.create(_Mediapipe_Tuple(_Mediapipe_Tuple($sKey1, $vVal1), _Mediapipe_Tuple($sKey2, $vVal2), _Mediapipe_Tuple($sKey3, $vVal3), _Mediapipe_Tuple($sKey4, $vVal4), _Mediapipe_Tuple($sKey5, $vVal5), _Mediapipe_Tuple($sKey6, $vVal6), _Mediapipe_Tuple($sKey7, $vVal7), _Mediapipe_Tuple($sKey8, $vVal8), _Mediapipe_Tuple($sKey9, $vVal9), _Mediapipe_Tuple($sKey10, $vVal10), _Mediapipe_Tuple($sKey11, $vVal11), _Mediapipe_Tuple($sKey12, $vVal12), _Mediapipe_Tuple($sKey13, $vVal13), _Mediapipe_Tuple($sKey14, $vVal14), _Mediapipe_Tuple($sKey15, $vVal15), _Mediapipe_Tuple($sKey16, $vVal16), _Mediapipe_Tuple($sKey17, $vVal17), _Mediapipe_Tuple($sKey18, $vVal18), _Mediapipe_Tuple($sKey19, $vVal19)))
		Case 40
			Return $MapOfStringAndVariant.create(_Mediapipe_Tuple(_Mediapipe_Tuple($sKey1, $vVal1), _Mediapipe_Tuple($sKey2, $vVal2), _Mediapipe_Tuple($sKey3, $vVal3), _Mediapipe_Tuple($sKey4, $vVal4), _Mediapipe_Tuple($sKey5, $vVal5), _Mediapipe_Tuple($sKey6, $vVal6), _Mediapipe_Tuple($sKey7, $vVal7), _Mediapipe_Tuple($sKey8, $vVal8), _Mediapipe_Tuple($sKey9, $vVal9), _Mediapipe_Tuple($sKey10, $vVal10), _Mediapipe_Tuple($sKey11, $vVal11), _Mediapipe_Tuple($sKey12, $vVal12), _Mediapipe_Tuple($sKey13, $vVal13), _Mediapipe_Tuple($sKey14, $vVal14), _Mediapipe_Tuple($sKey15, $vVal15), _Mediapipe_Tuple($sKey16, $vVal16), _Mediapipe_Tuple($sKey17, $vVal17), _Mediapipe_Tuple($sKey18, $vVal18), _Mediapipe_Tuple($sKey19, $vVal19), _Mediapipe_Tuple($sKey20, $vVal20)))
		Case 42
			Return $MapOfStringAndVariant.create(_Mediapipe_Tuple(_Mediapipe_Tuple($sKey1, $vVal1), _Mediapipe_Tuple($sKey2, $vVal2), _Mediapipe_Tuple($sKey3, $vVal3), _Mediapipe_Tuple($sKey4, $vVal4), _Mediapipe_Tuple($sKey5, $vVal5), _Mediapipe_Tuple($sKey6, $vVal6), _Mediapipe_Tuple($sKey7, $vVal7), _Mediapipe_Tuple($sKey8, $vVal8), _Mediapipe_Tuple($sKey9, $vVal9), _Mediapipe_Tuple($sKey10, $vVal10), _Mediapipe_Tuple($sKey11, $vVal11), _Mediapipe_Tuple($sKey12, $vVal12), _Mediapipe_Tuple($sKey13, $vVal13), _Mediapipe_Tuple($sKey14, $vVal14), _Mediapipe_Tuple($sKey15, $vVal15), _Mediapipe_Tuple($sKey16, $vVal16), _Mediapipe_Tuple($sKey17, $vVal17), _Mediapipe_Tuple($sKey18, $vVal18), _Mediapipe_Tuple($sKey19, $vVal19), _Mediapipe_Tuple($sKey20, $vVal20), _Mediapipe_Tuple($sKey21, $vVal21)))
		Case 44
			Return $MapOfStringAndVariant.create(_Mediapipe_Tuple(_Mediapipe_Tuple($sKey1, $vVal1), _Mediapipe_Tuple($sKey2, $vVal2), _Mediapipe_Tuple($sKey3, $vVal3), _Mediapipe_Tuple($sKey4, $vVal4), _Mediapipe_Tuple($sKey5, $vVal5), _Mediapipe_Tuple($sKey6, $vVal6), _Mediapipe_Tuple($sKey7, $vVal7), _Mediapipe_Tuple($sKey8, $vVal8), _Mediapipe_Tuple($sKey9, $vVal9), _Mediapipe_Tuple($sKey10, $vVal10), _Mediapipe_Tuple($sKey11, $vVal11), _Mediapipe_Tuple($sKey12, $vVal12), _Mediapipe_Tuple($sKey13, $vVal13), _Mediapipe_Tuple($sKey14, $vVal14), _Mediapipe_Tuple($sKey15, $vVal15), _Mediapipe_Tuple($sKey16, $vVal16), _Mediapipe_Tuple($sKey17, $vVal17), _Mediapipe_Tuple($sKey18, $vVal18), _Mediapipe_Tuple($sKey19, $vVal19), _Mediapipe_Tuple($sKey20, $vVal20), _Mediapipe_Tuple($sKey21, $vVal21), _Mediapipe_Tuple($sKey22, $vVal22)))
		Case 46
			Return $MapOfStringAndVariant.create(_Mediapipe_Tuple(_Mediapipe_Tuple($sKey1, $vVal1), _Mediapipe_Tuple($sKey2, $vVal2), _Mediapipe_Tuple($sKey3, $vVal3), _Mediapipe_Tuple($sKey4, $vVal4), _Mediapipe_Tuple($sKey5, $vVal5), _Mediapipe_Tuple($sKey6, $vVal6), _Mediapipe_Tuple($sKey7, $vVal7), _Mediapipe_Tuple($sKey8, $vVal8), _Mediapipe_Tuple($sKey9, $vVal9), _Mediapipe_Tuple($sKey10, $vVal10), _Mediapipe_Tuple($sKey11, $vVal11), _Mediapipe_Tuple($sKey12, $vVal12), _Mediapipe_Tuple($sKey13, $vVal13), _Mediapipe_Tuple($sKey14, $vVal14), _Mediapipe_Tuple($sKey15, $vVal15), _Mediapipe_Tuple($sKey16, $vVal16), _Mediapipe_Tuple($sKey17, $vVal17), _Mediapipe_Tuple($sKey18, $vVal18), _Mediapipe_Tuple($sKey19, $vVal19), _Mediapipe_Tuple($sKey20, $vVal20), _Mediapipe_Tuple($sKey21, $vVal21), _Mediapipe_Tuple($sKey22, $vVal22), _Mediapipe_Tuple($sKey23, $vVal23)))
		Case 48
			Return $MapOfStringAndVariant.create(_Mediapipe_Tuple(_Mediapipe_Tuple($sKey1, $vVal1), _Mediapipe_Tuple($sKey2, $vVal2), _Mediapipe_Tuple($sKey3, $vVal3), _Mediapipe_Tuple($sKey4, $vVal4), _Mediapipe_Tuple($sKey5, $vVal5), _Mediapipe_Tuple($sKey6, $vVal6), _Mediapipe_Tuple($sKey7, $vVal7), _Mediapipe_Tuple($sKey8, $vVal8), _Mediapipe_Tuple($sKey9, $vVal9), _Mediapipe_Tuple($sKey10, $vVal10), _Mediapipe_Tuple($sKey11, $vVal11), _Mediapipe_Tuple($sKey12, $vVal12), _Mediapipe_Tuple($sKey13, $vVal13), _Mediapipe_Tuple($sKey14, $vVal14), _Mediapipe_Tuple($sKey15, $vVal15), _Mediapipe_Tuple($sKey16, $vVal16), _Mediapipe_Tuple($sKey17, $vVal17), _Mediapipe_Tuple($sKey18, $vVal18), _Mediapipe_Tuple($sKey19, $vVal19), _Mediapipe_Tuple($sKey20, $vVal20), _Mediapipe_Tuple($sKey21, $vVal21), _Mediapipe_Tuple($sKey22, $vVal22), _Mediapipe_Tuple($sKey23, $vVal23), _Mediapipe_Tuple($sKey24, $vVal24)))
		Case 50
			Return $MapOfStringAndVariant.create(_Mediapipe_Tuple(_Mediapipe_Tuple($sKey1, $vVal1), _Mediapipe_Tuple($sKey2, $vVal2), _Mediapipe_Tuple($sKey3, $vVal3), _Mediapipe_Tuple($sKey4, $vVal4), _Mediapipe_Tuple($sKey5, $vVal5), _Mediapipe_Tuple($sKey6, $vVal6), _Mediapipe_Tuple($sKey7, $vVal7), _Mediapipe_Tuple($sKey8, $vVal8), _Mediapipe_Tuple($sKey9, $vVal9), _Mediapipe_Tuple($sKey10, $vVal10), _Mediapipe_Tuple($sKey11, $vVal11), _Mediapipe_Tuple($sKey12, $vVal12), _Mediapipe_Tuple($sKey13, $vVal13), _Mediapipe_Tuple($sKey14, $vVal14), _Mediapipe_Tuple($sKey15, $vVal15), _Mediapipe_Tuple($sKey16, $vVal16), _Mediapipe_Tuple($sKey17, $vVal17), _Mediapipe_Tuple($sKey18, $vVal18), _Mediapipe_Tuple($sKey19, $vVal19), _Mediapipe_Tuple($sKey20, $vVal20), _Mediapipe_Tuple($sKey21, $vVal21), _Mediapipe_Tuple($sKey22, $vVal22), _Mediapipe_Tuple($sKey23, $vVal23), _Mediapipe_Tuple($sKey24, $vVal24), _Mediapipe_Tuple($sKey25, $vVal25)))
		Case 52
			Return $MapOfStringAndVariant.create(_Mediapipe_Tuple(_Mediapipe_Tuple($sKey1, $vVal1), _Mediapipe_Tuple($sKey2, $vVal2), _Mediapipe_Tuple($sKey3, $vVal3), _Mediapipe_Tuple($sKey4, $vVal4), _Mediapipe_Tuple($sKey5, $vVal5), _Mediapipe_Tuple($sKey6, $vVal6), _Mediapipe_Tuple($sKey7, $vVal7), _Mediapipe_Tuple($sKey8, $vVal8), _Mediapipe_Tuple($sKey9, $vVal9), _Mediapipe_Tuple($sKey10, $vVal10), _Mediapipe_Tuple($sKey11, $vVal11), _Mediapipe_Tuple($sKey12, $vVal12), _Mediapipe_Tuple($sKey13, $vVal13), _Mediapipe_Tuple($sKey14, $vVal14), _Mediapipe_Tuple($sKey15, $vVal15), _Mediapipe_Tuple($sKey16, $vVal16), _Mediapipe_Tuple($sKey17, $vVal17), _Mediapipe_Tuple($sKey18, $vVal18), _Mediapipe_Tuple($sKey19, $vVal19), _Mediapipe_Tuple($sKey20, $vVal20), _Mediapipe_Tuple($sKey21, $vVal21), _Mediapipe_Tuple($sKey22, $vVal22), _Mediapipe_Tuple($sKey23, $vVal23), _Mediapipe_Tuple($sKey24, $vVal24), _Mediapipe_Tuple($sKey25, $vVal25), _Mediapipe_Tuple($sKey26, $vVal26)))
		Case 54
			Return $MapOfStringAndVariant.create(_Mediapipe_Tuple(_Mediapipe_Tuple($sKey1, $vVal1), _Mediapipe_Tuple($sKey2, $vVal2), _Mediapipe_Tuple($sKey3, $vVal3), _Mediapipe_Tuple($sKey4, $vVal4), _Mediapipe_Tuple($sKey5, $vVal5), _Mediapipe_Tuple($sKey6, $vVal6), _Mediapipe_Tuple($sKey7, $vVal7), _Mediapipe_Tuple($sKey8, $vVal8), _Mediapipe_Tuple($sKey9, $vVal9), _Mediapipe_Tuple($sKey10, $vVal10), _Mediapipe_Tuple($sKey11, $vVal11), _Mediapipe_Tuple($sKey12, $vVal12), _Mediapipe_Tuple($sKey13, $vVal13), _Mediapipe_Tuple($sKey14, $vVal14), _Mediapipe_Tuple($sKey15, $vVal15), _Mediapipe_Tuple($sKey16, $vVal16), _Mediapipe_Tuple($sKey17, $vVal17), _Mediapipe_Tuple($sKey18, $vVal18), _Mediapipe_Tuple($sKey19, $vVal19), _Mediapipe_Tuple($sKey20, $vVal20), _Mediapipe_Tuple($sKey21, $vVal21), _Mediapipe_Tuple($sKey22, $vVal22), _Mediapipe_Tuple($sKey23, $vVal23), _Mediapipe_Tuple($sKey24, $vVal24), _Mediapipe_Tuple($sKey25, $vVal25), _Mediapipe_Tuple($sKey26, $vVal26), _Mediapipe_Tuple($sKey27, $vVal27)))
		Case 56
			Return $MapOfStringAndVariant.create(_Mediapipe_Tuple(_Mediapipe_Tuple($sKey1, $vVal1), _Mediapipe_Tuple($sKey2, $vVal2), _Mediapipe_Tuple($sKey3, $vVal3), _Mediapipe_Tuple($sKey4, $vVal4), _Mediapipe_Tuple($sKey5, $vVal5), _Mediapipe_Tuple($sKey6, $vVal6), _Mediapipe_Tuple($sKey7, $vVal7), _Mediapipe_Tuple($sKey8, $vVal8), _Mediapipe_Tuple($sKey9, $vVal9), _Mediapipe_Tuple($sKey10, $vVal10), _Mediapipe_Tuple($sKey11, $vVal11), _Mediapipe_Tuple($sKey12, $vVal12), _Mediapipe_Tuple($sKey13, $vVal13), _Mediapipe_Tuple($sKey14, $vVal14), _Mediapipe_Tuple($sKey15, $vVal15), _Mediapipe_Tuple($sKey16, $vVal16), _Mediapipe_Tuple($sKey17, $vVal17), _Mediapipe_Tuple($sKey18, $vVal18), _Mediapipe_Tuple($sKey19, $vVal19), _Mediapipe_Tuple($sKey20, $vVal20), _Mediapipe_Tuple($sKey21, $vVal21), _Mediapipe_Tuple($sKey22, $vVal22), _Mediapipe_Tuple($sKey23, $vVal23), _Mediapipe_Tuple($sKey24, $vVal24), _Mediapipe_Tuple($sKey25, $vVal25), _Mediapipe_Tuple($sKey26, $vVal26), _Mediapipe_Tuple($sKey27, $vVal27), _Mediapipe_Tuple($sKey28, $vVal28)))
		Case 58
			Return $MapOfStringAndVariant.create(_Mediapipe_Tuple(_Mediapipe_Tuple($sKey1, $vVal1), _Mediapipe_Tuple($sKey2, $vVal2), _Mediapipe_Tuple($sKey3, $vVal3), _Mediapipe_Tuple($sKey4, $vVal4), _Mediapipe_Tuple($sKey5, $vVal5), _Mediapipe_Tuple($sKey6, $vVal6), _Mediapipe_Tuple($sKey7, $vVal7), _Mediapipe_Tuple($sKey8, $vVal8), _Mediapipe_Tuple($sKey9, $vVal9), _Mediapipe_Tuple($sKey10, $vVal10), _Mediapipe_Tuple($sKey11, $vVal11), _Mediapipe_Tuple($sKey12, $vVal12), _Mediapipe_Tuple($sKey13, $vVal13), _Mediapipe_Tuple($sKey14, $vVal14), _Mediapipe_Tuple($sKey15, $vVal15), _Mediapipe_Tuple($sKey16, $vVal16), _Mediapipe_Tuple($sKey17, $vVal17), _Mediapipe_Tuple($sKey18, $vVal18), _Mediapipe_Tuple($sKey19, $vVal19), _Mediapipe_Tuple($sKey20, $vVal20), _Mediapipe_Tuple($sKey21, $vVal21), _Mediapipe_Tuple($sKey22, $vVal22), _Mediapipe_Tuple($sKey23, $vVal23), _Mediapipe_Tuple($sKey24, $vVal24), _Mediapipe_Tuple($sKey25, $vVal25), _Mediapipe_Tuple($sKey26, $vVal26), _Mediapipe_Tuple($sKey27, $vVal27), _Mediapipe_Tuple($sKey28, $vVal28), _Mediapipe_Tuple($sKey29, $vVal29)))
		Case 60
			Return $MapOfStringAndVariant.create(_Mediapipe_Tuple(_Mediapipe_Tuple($sKey1, $vVal1), _Mediapipe_Tuple($sKey2, $vVal2), _Mediapipe_Tuple($sKey3, $vVal3), _Mediapipe_Tuple($sKey4, $vVal4), _Mediapipe_Tuple($sKey5, $vVal5), _Mediapipe_Tuple($sKey6, $vVal6), _Mediapipe_Tuple($sKey7, $vVal7), _Mediapipe_Tuple($sKey8, $vVal8), _Mediapipe_Tuple($sKey9, $vVal9), _Mediapipe_Tuple($sKey10, $vVal10), _Mediapipe_Tuple($sKey11, $vVal11), _Mediapipe_Tuple($sKey12, $vVal12), _Mediapipe_Tuple($sKey13, $vVal13), _Mediapipe_Tuple($sKey14, $vVal14), _Mediapipe_Tuple($sKey15, $vVal15), _Mediapipe_Tuple($sKey16, $vVal16), _Mediapipe_Tuple($sKey17, $vVal17), _Mediapipe_Tuple($sKey18, $vVal18), _Mediapipe_Tuple($sKey19, $vVal19), _Mediapipe_Tuple($sKey20, $vVal20), _Mediapipe_Tuple($sKey21, $vVal21), _Mediapipe_Tuple($sKey22, $vVal22), _Mediapipe_Tuple($sKey23, $vVal23), _Mediapipe_Tuple($sKey24, $vVal24), _Mediapipe_Tuple($sKey25, $vVal25), _Mediapipe_Tuple($sKey26, $vVal26), _Mediapipe_Tuple($sKey27, $vVal27), _Mediapipe_Tuple($sKey28, $vVal28), _Mediapipe_Tuple($sKey29, $vVal29), _Mediapipe_Tuple($sKey30, $vVal30)))
		Case Else
			ConsoleWriteError('!>Error: Invalid number of arguments')
			Return SetError(1, 0, -1)
	EndSwitch
EndFunc   ;==>_Mediapipe_MapOfStringAndVariant

Func _Mediapipe_FindResourceDir($sDir = Default)
	If $sDir == Default Then $sDir = @ScriptDir

	Local $sCompileMode = EnvGet("MEDIAPIPE_BUILD_TYPE") == "Debug" ? "dbg" : "opt"
	Local $sBazelBin = "build_x64\mediapipe-src\bazel-out\x64_windows-" & $sCompileMode & "\bin"

	Local $aSearchPaths[] = [ _
			".", _
			"autoit-mediapipe-com", _
			$sBazelBin, _
			"autoit-mediapipe-com\" & $sBazelBin _
			]

	Local Const $sFile = "mediapipe\modules\face_detection\face_detection_short_range_cpu.binarypb"

	Local Const $sGraphFile = _Mediapipe_FindFile($sFile, Default, $sDir, $FLTA_FILES, $aSearchPaths)

	If $sGraphFile == "" Then
		Return ""
	EndIf

	Local Const $iCount = StringLen($sGraphFile) - StringLen($sFile) - 1
	Return StringLeft($sGraphFile, $iCount)
EndFunc   ;==>_Mediapipe_FindResourceDir

Func _Mediapipe_SetResourceDir($root_path = Default)
	If $root_path == Default Then $root_path = _Mediapipe_FindResourceDir()
	_Mediapipe_DebugMsg('_Mediapipe_SetResourceDir("' & $root_path & '"')

	Local Static $resource_util = _Mediapipe_ObjCreate("mediapipe.autoit._framework_bindings.resource_util")
	$resource_util.set_resource_dir($root_path)
EndFunc   ;==>_Mediapipe_SetResourceDir
