#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Change2CUI=y
#AutoIt3Wrapper_Au3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#include "..\autoit-mediapipe-com\udf\mediapipe_udf_utils.au3"
#include "..\autoit-opencv-com\udf\opencv_udf_utils.au3"
#include "_assert.au3"
#include "_mat_utils.au3"

$_mediapipe_build_type = "Release"
$_mediapipe_debug = 0
$_cv_build_type = "Release"
$_cv_debug = 0
_Mediapipe_Open_And_Register(_Mediapipe_FindDLL("opencv_world4*", "opencv-4.*\opencv"), _Mediapipe_FindDLL("autoit_mediapipe_com-*"))
_OpenCV_Open_And_Register(_OpenCV_FindDLL("opencv_world4*", "opencv-4.*\opencv"), _OpenCV_FindDLL("autoit_opencv_com4*"))
OnAutoItExitRegister("_OnAutoItExit")

Global $text_format = _Mediapipe_ObjCreate("google.protobuf.text_format")
_AssertTrue(IsObj($text_format), "Failed to load google.protobuf.text_format")

Global $calculator_pb2 = _Mediapipe_ObjCreate("mediapipe.framework.calculator_pb2")
_AssertTrue(IsObj($calculator_pb2), "Failed to load mediapipe.framework.calculator_pb2")

Global $detection_pb2 = _Mediapipe_ObjCreate("mediapipe.framework.formats.detection_pb2")
_AssertTrue(IsObj($detection_pb2), "Failed to load mediapipe.framework.formats.detection_pb2")

Global $solution_base = _Mediapipe_ObjCreate("mediapipe.framework.solution_base")
_AssertTrue(IsObj($solution_base), "Failed to load mediapipe.framework.solution_base")

Test()

Func Test()
	test_valid_input_data_type_proto()
EndFunc   ;==>Test

Func test_valid_input_data_type_proto()
	Local $text_config = "" & @CRLF & _
		"  input_stream: 'input_detections'" & @CRLF & _
		"  output_stream: 'output_detections'" & @CRLF & _
		"  node {" & @CRLF & _
		"    calculator: 'DetectionUniqueIdCalculator'" & @CRLF & _
		"    input_stream: 'DETECTION_LIST:input_detections'" & @CRLF & _
		"    output_stream: 'DETECTION_LIST:output_detections'" & @CRLF & _
		"  }" & @CRLF & _
		""

	Local $config_proto = $calculator_pb2.CalculatorGraphConfig()
	$text_format.Parse($text_config, $config_proto)
	Local $solution = $solution_base.SolutionBase($config_proto)

	Local $input_detections = $detection_pb2.DetectionList()
	Local $detection_1 = $input_detections.detection.add()
	$text_format.Parse('score: 0.5', $detection_1)
	Local $detection_2 = $input_detections.detection.add()
	$text_format.Parse('score: 0.8', $detection_2)
	Local $results = $solution.process(_Mediapipe_MapOfStringAndVariant('input_dict', _Mediapipe_MapOfStringAndVariant('input_detections', $input_detections)))
	_AssertTrue($results.has("output_detections"))
	_AssertEqual($results("output_detections").detection.size(), 2)
	Local $expected_detection_1 = $detection_pb2.Detection()
	$text_format.Parse('score: 0.5, detection_id: 1', $expected_detection_1)
	Local $expected_detection_2 = $detection_pb2.Detection()
	$text_format.Parse('score: 0.8, detection_id: 2', $expected_detection_2)
	_AssertEqual($results("output_detections").detection(0).str(), $expected_detection_1.str())
	_AssertEqual($results("output_detections").detection(1).str(), $expected_detection_2.str())
EndFunc   ;==>test_valid_input_data_type_proto

Func _OnAutoItExit()
	_OpenCV_Unregister_And_Close()
	_Mediapipe_Unregister_And_Close()
EndFunc   ;==>_OnAutoItExit
