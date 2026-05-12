#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Change2CUI=y
#AutoIt3Wrapper_Au3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

;~ Sources:
;~     https://github.com/google-ai-edge/mediapipe/blob/v0.10.35/mediapipe/tasks/python/test/components/containers/category_test.py

#include "..\..\..\..\autoit-mediapipe-com\udf\mediapipe_udf_utils.au3"
#include "..\..\..\_assert.au3"

_Mediapipe_Open(_Mediapipe_FindDLL("opencv_world4130*"), _Mediapipe_FindDLL("autoit_mediapipe_com-*-4130*"))
OnAutoItExitRegister("_OnAutoItExit")

Global Const $category_lib = _Mediapipe_ObjCreate("mediapipe.tasks.autoit.components.containers.category")
_AssertIsObj($category_lib, "Failed to load mediapipe.tasks.autoit.components.containers.category")

Global Const $_CATEGORY_WITH_NAMES = $category_lib.Category(_Mediapipe_Params( _
		"index", 1, _
		"score", 0.9, _
		"category_name", 'test_category_with_names', _
		"display_name", 'Test Category 1' _
		))

Global Const $_DICT_WITH_NAMES = ObjCreate("Scripting.Dictionary")
$_DICT_WITH_NAMES.Add('index', 1)
$_DICT_WITH_NAMES.Add('score', 0.9)
$_DICT_WITH_NAMES.Add('category_name', 'test_category_with_names')
$_DICT_WITH_NAMES.Add('display_name', 'Test Category 1')

Global Const $_CATEGORY_WITHOUT_NAMES = $category_lib.Category(_Mediapipe_Params( _
		"index", 2, _
		"score", 0.8, _
		"category_name", Default, _
		"display_name", Default _
		))

Global Const $_DICT_WITHOUT_NAMES = ObjCreate("Scripting.Dictionary")
$_DICT_WITHOUT_NAMES.Add('index', 2)
$_DICT_WITHOUT_NAMES.Add('score', 0.8)
$_DICT_WITHOUT_NAMES.Add('category_name', Default)
$_DICT_WITHOUT_NAMES.Add('display_name', Default)


CategoryTest()


Func CategoryTest()
	test_create_category_from_ctypes()
	test_create_category_from_ctypes_without_name_fields()
	test_create_category_from_ctypes_with_unknown_index()
EndFunc   ;==>CategoryTest


Func test_create_category_from_ctypes()
	ConsoleWrite('"' & @ScriptFullPath & '" @@ Debug(' & @ScriptLineNumber & ') : test_create_category_from_ctypes' & @CRLF) ;### Debug Console
	_AssertDictAlmostEqual($_CATEGORY_WITH_NAMES, $_DICT_WITH_NAMES)
EndFunc   ;==>test_create_category_from_ctypes

Func test_create_category_from_ctypes_without_name_fields()
	ConsoleWrite('"' & @ScriptFullPath & '" @@ Debug(' & @ScriptLineNumber & ') : test_create_category_from_ctypes_without_name_fields' & @CRLF) ;### Debug Console
	_AssertDictAlmostEqual($_CATEGORY_WITHOUT_NAMES, $_DICT_WITHOUT_NAMES)
EndFunc   ;==>test_create_category_from_ctypes_without_name_fields

Func test_create_category_from_ctypes_with_unknown_index()
	ConsoleWrite('"' & @ScriptFullPath & '" @@ Debug(' & @ScriptLineNumber & ') : test_create_category_from_ctypes_with_unknown_index' & @CRLF) ;### Debug Console

	Local $category = $category_lib.Category(_Mediapipe_Params( _
			"index", -1, _
			"score", 0.8, _
			"category_name", Default, _
			"display_name", Default _
			))

	Local $expected_dict = ObjCreate("Scripting.Dictionary")
	$expected_dict.Add('index', -1)
	$expected_dict.Add('score', 0.8)
	$expected_dict.Add('category_name', Default)
	$expected_dict.Add('display_name', Default)

	_AssertDictAlmostEqual($category, $expected_dict)
EndFunc   ;==>test_create_category_from_ctypes_with_unknown_index


Func _OnAutoItExit()
	_Mediapipe_Close()
EndFunc   ;==>_OnAutoItExit
