#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Change2CUI=y
#AutoIt3Wrapper_Au3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

;~ Sources:
;~     https://github.com/google-ai-edge/mediapipe/blob/v0.10.35/mediapipe/tasks/python/test/components/containers/detections_test.py

#include "..\..\..\..\autoit-mediapipe-com\udf\mediapipe_udf_utils.au3"
#include "..\..\..\_assert.au3"

_Mediapipe_Open(_Mediapipe_FindDLL("opencv_world4130*"), _Mediapipe_FindDLL("autoit_mediapipe_com-*-4130*"))
OnAutoItExitRegister("_OnAutoItExit")

Global Const $bounding_box_lib = _Mediapipe_ObjCreate("mediapipe.tasks.autoit.components.containers.bounding_box")
_AssertIsObj($bounding_box_lib, "Failed to load mediapipe.tasks.autoit.components.containers.bounding_box")

Global Const $category_lib = _Mediapipe_ObjCreate("mediapipe.tasks.autoit.components.containers.category")
_AssertIsObj($category_lib, "Failed to load mediapipe.tasks.autoit.components.containers.category")

Global Const $detections_lib = _Mediapipe_ObjCreate("mediapipe.tasks.autoit.components.containers.detections")
_AssertIsObj($detections_lib, "Failed to load mediapipe.tasks.autoit.components.containers.detections")

Global Const $keypoint_lib = _Mediapipe_ObjCreate("mediapipe.tasks.autoit.components.containers.keypoint")
_AssertIsObj($keypoint_lib, "Failed to load mediapipe.tasks.autoit.components.containers.keypoint")

Global Const $rect_lib = _Mediapipe_ObjCreate("mediapipe.tasks.autoit.components.containers.rect")
_AssertIsObj($rect_lib, "Failed to load mediapipe.tasks.autoit.components.containers.rect")

Global Const $_CATEGORY_WITH_NAMES = $category_lib.Category(_Mediapipe_Params( _
		"index", 1, _
		"score", 0.9, _
		"category_name", 'test_category_WITH_NAMES', _
		"display_name", 'Test Category 1' _
		))
Global Const $_CATEGORY_WITH_NAMES_DICT = ObjCreate("Scripting.Dictionary")
$_CATEGORY_WITH_NAMES_DICT.Add('index', 1)
$_CATEGORY_WITH_NAMES_DICT.Add('score', 0.9)
$_CATEGORY_WITH_NAMES_DICT.Add('category_name', 'test_category_WITH_NAMES')
$_CATEGORY_WITH_NAMES_DICT.Add('display_name', 'Test Category 1')

Global Const $_CATEGORY_WITHOUT_NAMES = $category_lib.Category(_Mediapipe_Params( _
		"index", 2, _
		"score", 0.8, _
		"category_name", 'test_category_WITHOUT_NAMES', _
		"display_name", 'Test Category 2' _
		))
Global Const $_CATEGORY_WITHOUT_NAMES_DICT = ObjCreate("Scripting.Dictionary")
$_CATEGORY_WITHOUT_NAMES_DICT.Add('index', 2)
$_CATEGORY_WITHOUT_NAMES_DICT.Add('score', 0.8)
$_CATEGORY_WITHOUT_NAMES_DICT.Add('category_name', 'test_category_WITHOUT_NAMES')
$_CATEGORY_WITHOUT_NAMES_DICT.Add('display_name', 'Test Category 2')

Global Const $_KEYPOINT_1 = $keypoint_lib.NormalizedKeypoint(_Mediapipe_Params( _
		"x", 0.1, "y", 0.2, "label", 'keypoint1', "score", 0.9 _
		))
Global Const $_KEYPOINT_1_DICT = ObjCreate("Scripting.Dictionary")
$_KEYPOINT_1_DICT.Add('x', 0.1)
$_KEYPOINT_1_DICT.Add('y', 0.2)
$_KEYPOINT_1_DICT.Add('label', 'keypoint1')
$_KEYPOINT_1_DICT.Add('score', 0.9)

Global Const $_KEYPOINT_2 = $keypoint_lib.NormalizedKeypoint(_Mediapipe_Params( _
		"x", 0.3, "y", 0.4, "label", 'keypoint2', "score", 0.8 _
		))
Global Const $_KEYPOINT_2_DICT = ObjCreate("Scripting.Dictionary")
$_KEYPOINT_2_DICT.Add('x', 0.3)
$_KEYPOINT_2_DICT.Add('y', 0.4)
$_KEYPOINT_2_DICT.Add('label', 'keypoint2')
$_KEYPOINT_2_DICT.Add('score', 0.8)

Global Const $_RECT_1 = $rect_lib.Rect(_Mediapipe_Params("left", 10, "top", 20, "right", 50, "bottom", 70))
Global Const $_RECT_1_DICT = ObjCreate("Scripting.Dictionary")
$_RECT_1_DICT.Add('origin_x', 10)
$_RECT_1_DICT.Add('origin_y', 20)
$_RECT_1_DICT.Add('width', 40)
$_RECT_1_DICT.Add('height', 50)

Global Const $_RECT_2 = $rect_lib.Rect(_Mediapipe_Params("left", 15, "top", 25, "right", 55, "bottom", 75))
Global Const $_RECT_2_DICT = ObjCreate("Scripting.Dictionary")
$_RECT_2_DICT.Add('origin_x', 15)
$_RECT_2_DICT.Add('origin_y', 25)
$_RECT_2_DICT.Add('width', 40)
$_RECT_2_DICT.Add('height', 50)


DetectionsTest()


Func DetectionsTest()
	test_create_detection_from_ctypes()
	test_create_detection_from_ctypes_without_keypoints()
	test_create_detection_result_from_ctypes()
EndFunc   ;==>DetectionsTest


Func _assert_categories_equal($actual_categories, $expected_categories, $bExit = Default, $iCode = Default, $sFile = @ScriptFullPath, $iLine = @ScriptLineNumber, Const $_iCallerError = @error, Const $_vCallerExtended = @extended)
	_AssertLen($actual_categories, UBound($expected_categories), Default, $bExit, $iCode, $sFile, $iLine, $_iCallerError, $_vCallerExtended)
	For $i = 0 To UBound($expected_categories) - 1
		_AssertDictAlmostEqual($actual_categories($i), $expected_categories[$i], Default, Default, Default, $bExit, $iCode, $sFile, $iLine, $_iCallerError, $_vCallerExtended)
	Next
EndFunc   ;==>_assert_categories_equal

Func _assert_keypoints_equal($actual_keypoints, $expected_keypoints, $bExit = Default, $iCode = Default, $sFile = @ScriptFullPath, $iLine = @ScriptLineNumber, Const $_iCallerError = @error, Const $_vCallerExtended = @extended)
	_AssertLen($actual_keypoints, UBound($expected_keypoints), Default, $bExit, $iCode, $sFile, $iLine, $_iCallerError, $_vCallerExtended)
	For $i = 0 To UBound($expected_keypoints) - 1
		_AssertDictAlmostEqual($actual_keypoints($i), $expected_keypoints[$i], Default, Default, Default, $bExit, $iCode, $sFile, $iLine, $_iCallerError, $_vCallerExtended)
	Next
EndFunc   ;==>_assert_keypoints_equal

Func _assert_bounding_box_equal($actual_values, $expected_values, $bExit = Default, $iCode = Default, $sFile = @ScriptFullPath, $iLine = @ScriptLineNumber, Const $_iCallerError = @error, Const $_vCallerExtended = @extended)
	_AssertDictAlmostEqual($actual_values, $expected_values, Default, Default, Default, $bExit, $iCode, $sFile, $iLine, $_iCallerError, $_vCallerExtended)
EndFunc   ;==>_assert_bounding_box_equal

Func _assert_detection_matches($actual, $expected_bounding_box, $expected_categories, $expected_keypoints, $bExit = Default, $iCode = Default, $sFile = @ScriptFullPath, $iLine = @ScriptLineNumber, Const $_iCallerError = @error, Const $_vCallerExtended = @extended)
	_assert_bounding_box_equal($actual.bounding_box, $expected_bounding_box, $bExit, $iCode, $sFile, $iLine, $_iCallerError, $_vCallerExtended)
	_assert_categories_equal($actual.categories, $expected_categories, $bExit, $iCode, $sFile, $iLine, $_iCallerError, $_vCallerExtended)

	If $expected_keypoints <> Null Then
		_assert_keypoints_equal($actual.keypoints, $expected_keypoints, $bExit, $iCode, $sFile, $iLine, $_iCallerError, $_vCallerExtended)
	Else
		_AssertIsNone($actual.keypoints, Default, $bExit, $iCode, $sFile, $iLine, $_iCallerError, $_vCallerExtended)
	EndIf
EndFunc   ;==>_assert_detection_matches


Func test_create_detection_from_ctypes()
	ConsoleWrite('"' & @ScriptFullPath & '" @@ Debug(' & @ScriptLineNumber & ') : test_create_detection_from_ctypes' & @CRLF) ;### Debug Console

	Local $c_categories[] = [$_CATEGORY_WITH_NAMES, $_CATEGORY_WITHOUT_NAMES]
	Local $c_keypoints[] = [$_KEYPOINT_1, $_KEYPOINT_2]
	Local $c_detection = $detections_lib.Detection(_Mediapipe_Params( _
			"categories", $c_categories, _
			"bounding_box", $_RECT_1, _
			"keypoints", $c_keypoints _
			))

	Local $actual_detection = $c_detection

	_assert_detection_matches( _
			$actual_detection, _
			$_RECT_1_DICT, _
			_Mediapipe_Tuple($_CATEGORY_WITH_NAMES_DICT, $_CATEGORY_WITHOUT_NAMES_DICT), _
			_Mediapipe_Tuple($_KEYPOINT_1_DICT, $_KEYPOINT_2_DICT) _
			)
EndFunc   ;==>test_create_detection_from_ctypes

Func test_create_detection_from_ctypes_without_keypoints()
	ConsoleWrite('"' & @ScriptFullPath & '" @@ Debug(' & @ScriptLineNumber & ') : test_create_detection_from_ctypes_without_keypoints' & @CRLF) ;### Debug Console

	Local $c_categories[] = [$_CATEGORY_WITH_NAMES]
	Local $c_detection = $detections_lib.Detection(_Mediapipe_Params( _
			"categories", $c_categories, _
			"bounding_box", $_RECT_2, _
			"keypoints", Default _
			))

	Local $actual_detection = $c_detection

	_assert_detection_matches( _
			$actual_detection, _
			$_RECT_2_DICT, _
			_Mediapipe_Tuple($_CATEGORY_WITH_NAMES_DICT), _
			Default _
			)
EndFunc   ;==>test_create_detection_from_ctypes_without_keypoints

Func test_create_detection_result_from_ctypes()
	ConsoleWrite('"' & @ScriptFullPath & '" @@ Debug(' & @ScriptLineNumber & ') : test_create_detection_result_from_ctypes' & @CRLF) ;### Debug Console

	Local $c_categories_1[] = [$_CATEGORY_WITH_NAMES]
	Local $c_keypoints_1[] = [$_KEYPOINT_1]
	Local $c_detection_1 = $detections_lib.Detection(_Mediapipe_Params( _
			"categories", $c_categories_1, _
			"bounding_box", $_RECT_1, _
			"keypoints", $c_keypoints_1 _
			))

	Local $c_categories_2[] = [$_CATEGORY_WITHOUT_NAMES]
	Local $c_keypoints_2[] = [$_KEYPOINT_2]
	Local $c_detection_2 = $detections_lib.Detection(_Mediapipe_Params( _
			"categories", $c_categories_2, _
			"bounding_box", $_RECT_2, _
			"keypoints", $c_keypoints_2 _
			))

	Local $c_detections[] = [$c_detection_1, $c_detection_2]
	Local $c_detection_result = $detections_lib.DetectionResult(_Mediapipe_Params( _
			"detections", $c_detections _
			))

	Local $actual_detection_result = $c_detection_result

	_AssertLen($actual_detection_result.detections, 2)

	ConsoleWrite('"' & @ScriptFullPath & '" @@ Debug(' & @ScriptLineNumber & ') :     FirstDetectionConvertedCorrectly' & @CRLF) ;### Debug Console
	_assert_detection_matches( _
			$actual_detection_result.detections(0), _
			$_RECT_1_DICT, _
			_Mediapipe_Tuple($_CATEGORY_WITH_NAMES_DICT), _
			_Mediapipe_Tuple($_KEYPOINT_1_DICT) _
			)

	ConsoleWrite('"' & @ScriptFullPath & '" @@ Debug(' & @ScriptLineNumber & ') :     SecondDetectionConvertedCorrectly' & @CRLF)   ;### Debug Console
	_assert_detection_matches( _
			$actual_detection_result.detections(1), _
			$_RECT_2_DICT, _
			_Mediapipe_Tuple($_CATEGORY_WITHOUT_NAMES_DICT), _
			_Mediapipe_Tuple($_KEYPOINT_2_DICT) _
			)
EndFunc   ;==>test_create_detection_result_from_ctypes


Func _OnAutoItExit()
	_Mediapipe_Close()
EndFunc   ;==>_OnAutoItExit
