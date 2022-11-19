#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Change2CUI=y
#AutoIt3Wrapper_Au3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#include "..\autoit-mediapipe-com\udf\mediapipe_udf_utils.au3"
#include "_assert.au3"

;~ Sources:
;~     https://github.com/google/mediapipe/blob/v0.8.11/mediapipe/python/timestamp_test.py

$_mediapipe_build_type = "Release"
$_mediapipe_debug = 0
_Mediapipe_Open_And_Register(_Mediapipe_FindDLL("opencv_world4*", "opencv-4.*\opencv"), _Mediapipe_FindDLL("autoit_mediapipe_com-*"))
OnAutoItExitRegister("_OnAutoItExit")

; AutoIt variable names are case insensitive
; Add an _ to differentiate timestamp and Timestamp
Global Const $_timestamp = _Mediapipe_ObjCreate("mediapipe.autoit._framework_bindings.timestamp")
_AssertTrue(IsObj($_timestamp), "Failed to load mediapipe.autoit._framework_bindings.timestamp")

Global Const $Timestamp = $_timestamp.Timestamp
_AssertTrue(IsObj($Timestamp), "Failed to load timestamp.Timestamp")

Test()

Func Test()
	test_timestamp()
	test_timestamp_copy_constructor()
	test_timestamp_comparsion()
	test_timestamp_special_values()
	test_timestamp_comparisons()
	test_from_seconds()
EndFunc   ;==>Test

Func test_timestamp()
	Local $t = $Timestamp(100)
	_AssertEqual($t.value, 100)
	_AssertEqual($t.str(), '<mediapipe.Timestamp with value: 100>')
EndFunc   ;==>test_timestamp

Func test_timestamp_copy_constructor()
	Local $ts1 = $Timestamp(100)
	Local $ts2 = $Timestamp($ts1)
	_AssertEqual($ts1.value, $ts2.value)
EndFunc   ;==>test_timestamp_copy_constructor

Func test_timestamp_comparsion()
	Local $ts1 = $Timestamp(100)
	Local $ts2 = $Timestamp(100)
	_AssertEqual($ts1.value, $ts2.value)
	Local $ts3 = $Timestamp(200)
	_AssertNotEqual($ts1.value, $ts3.value)
EndFunc   ;==>test_timestamp_comparsion

Func test_timestamp_special_values()
	Local $t1 = $Timestamp.UNSET
	_AssertEqual($t1.str(), '<mediapipe.Timestamp with value: UNSET>')
	Local $t2 = $Timestamp.UNSTARTED
	_AssertEqual($t2.str(), '<mediapipe.Timestamp with value: UNSTARTED>')
	Local $t3 = $Timestamp.PRESTREAM
	_AssertEqual($t3.str(), '<mediapipe.Timestamp with value: PRESTREAM>')
	Local $t4 = $Timestamp.MIN
	_AssertEqual($t4.str(), '<mediapipe.Timestamp with value: MIN>')
	Local $t5 = $Timestamp.MAX
	_AssertEqual($t5.str(), '<mediapipe.Timestamp with value: MAX>')
	Local $t6 = $Timestamp.POSTSTREAM
	_AssertEqual($t6.str(), '<mediapipe.Timestamp with value: POSTSTREAM>')
	Local $t7 = $Timestamp.DONE
	_AssertEqual($t7.str(), '<mediapipe.Timestamp with value: DONE>')
EndFunc   ;==>test_timestamp_special_values

Func test_timestamp_comparisons()
	Local $ts1 = $Timestamp(100)
	Local $ts2 = $Timestamp(101)
	_AssertTrue($Timestamp.gt($ts2, $ts1))
	_AssertTrue($Timestamp.ge($ts2, $ts1))
	_AssertTrue($Timestamp.lt($ts1, $ts2))
	_AssertTrue($Timestamp.le($ts1, $ts2))
	_AssertTrue($Timestamp.ne($ts1, $ts2))
EndFunc   ;==>test_timestamp_comparisons

Func test_from_seconds()
	Local $now = _Mediapipe_DllCall("msvcrt.dll", "int64", "time", "int64*", Null)
	Local $ts = $Timestamp.from_seconds($now)
	_AssertAlmostEqual($now, $ts.seconds(), 1)
EndFunc   ;==>test_from_seconds

Func _OnAutoItExit()
	_Mediapipe_Unregister_And_Close()
EndFunc   ;==>_OnAutoItExit
