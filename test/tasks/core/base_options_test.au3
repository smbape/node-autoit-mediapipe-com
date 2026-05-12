#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Change2CUI=y
#AutoIt3Wrapper_Au3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

;~ Sources:
;~     https://github.com/google-ai-edge/mediapipe/blob/v0.10.35/mediapipe/tasks/python/test/core/base_options_test.py

#include "..\..\..\autoit-mediapipe-com\udf\mediapipe_udf_utils.au3"
#include "..\..\_assert.au3"

_Mediapipe_Open(_Mediapipe_FindDLL("opencv_world4130*"), _Mediapipe_FindDLL("autoit_mediapipe_com-*-4130*"))
OnAutoItExitRegister("_OnAutoItExit")

Global Const $base_options_lib = _Mediapipe_ObjCreate("mediapipe.tasks.autoit.core.base_options")
_AssertIsObj($base_options_lib, "Failed to load mediapipe.tasks.autoit.core.base_options")


BaseOptionsTest()


Func BaseOptionsTest()
	test_convert_to_ctypes_with_model_asset_path()
	test_convert_to_ctypes_with_model_asset_buffer()
	test_convert_to_ctypes_with_gpu_delegate()
	test_convert_to_ctypes_without_delegate()
EndFunc   ;==>BaseOptionsTest


Func test_convert_to_ctypes_with_model_asset_path()
	ConsoleWrite('"' & @ScriptFullPath & '" @@ Debug(' & @ScriptLineNumber & ') : test_convert_to_ctypes_with_model_asset_path' & @CRLF) ;### Debug Console

	Local $options = $base_options_lib.BaseOptions(_Mediapipe_Params("model_asset_path", '/path/to/model'))
	_AssertEqual($options.model_asset_path, '/path/to/model')
	_AssertIsNone($options.model_asset_buffer)
	_AssertEqual($options.delegate, $MEDIAPIPE_TASKS_CORE_BASE_OPTIONS_CPU)
EndFunc   ;==>test_convert_to_ctypes_with_model_asset_path

Func test_convert_to_ctypes_with_model_asset_buffer()
	ConsoleWrite('"' & @ScriptFullPath & '" @@ Debug(' & @ScriptLineNumber & ') : test_convert_to_ctypes_with_model_asset_buffer' & @CRLF) ;### Debug Console

	Local $options = $base_options_lib.BaseOptions(_Mediapipe_Params("model_asset_buffer", 'buffer'))
	_AssertIsNone($options.model_asset_path)
	_AssertEqual($options.model_asset_buffer, 'buffer')
	_AssertEqual($options.delegate, $MEDIAPIPE_TASKS_CORE_BASE_OPTIONS_CPU)
EndFunc   ;==>test_convert_to_ctypes_with_model_asset_buffer

Func test_convert_to_ctypes_with_gpu_delegate()
	ConsoleWrite('"' & @ScriptFullPath & '" @@ Debug(' & @ScriptLineNumber & ') : test_convert_to_ctypes_with_gpu_delegate' & @CRLF) ;### Debug Console

	Local $options = $base_options_lib.BaseOptions(_Mediapipe_Params( _
			"model_asset_path", '/path/to/model', _
			"delegate", $MEDIAPIPE_TASKS_CORE_BASE_OPTIONS_GPU _
			))
	_AssertEqual($options.model_asset_path, '/path/to/model')
	_AssertEqual($options.delegate, $MEDIAPIPE_TASKS_CORE_BASE_OPTIONS_GPU)
EndFunc   ;==>test_convert_to_ctypes_with_gpu_delegate

Func test_convert_to_ctypes_without_delegate()
	ConsoleWrite('"' & @ScriptFullPath & '" @@ Debug(' & @ScriptLineNumber & ') : test_convert_to_ctypes_without_delegate' & @CRLF) ;### Debug Console

	Local $options = $base_options_lib.BaseOptions(_Mediapipe_Params( _
			"model_asset_path", '/path/to/model', _
			"delegate", Default _
			))
	_AssertEqual($options.model_asset_path, '/path/to/model')
	_AssertEqual($options.delegate, $MEDIAPIPE_TASKS_CORE_BASE_OPTIONS_CPU)
EndFunc   ;==>test_convert_to_ctypes_without_delegate


Func _OnAutoItExit()
	_Mediapipe_Close()
EndFunc   ;==>_OnAutoItExit
