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

;~ Sources:
;~     https://github.com/google/mediapipe/blob/v0.9.1/mediapipe/python/solution_base_test.py

_Mediapipe_Open(_Mediapipe_FindDLL("opencv_world470*"), _Mediapipe_FindDLL("autoit_mediapipe_com-*-470*"))
_OpenCV_Open(_OpenCV_FindDLL("opencv_world470*"), _OpenCV_FindDLL("autoit_opencv_com470*"))
OnAutoItExitRegister("_OnAutoItExit")

_Mediapipe_SetResourceDir()

Global $text_format = _Mediapipe_ObjCreate("google.protobuf.text_format")
_AssertTrue(IsObj($text_format), "Failed to load google.protobuf.text_format")

Global $calculator_pb2 = _Mediapipe_ObjCreate("mediapipe.framework.calculator_pb2")
_AssertTrue(IsObj($calculator_pb2), "Failed to load mediapipe.framework.calculator_pb2")

Global $detection_pb2 = _Mediapipe_ObjCreate("mediapipe.framework.formats.detection_pb2")
_AssertTrue(IsObj($detection_pb2), "Failed to load mediapipe.framework.formats.detection_pb2")

Global $solution_base = _Mediapipe_ObjCreate("mediapipe.autoit.solution_base")
_AssertTrue(IsObj($solution_base), "Failed to load mediapipe.autoit.solution_base")

Global Const $CALCULATOR_OPTIONS_TEST_GRAPH_CONFIG = "" & @CRLF & _
		"  input_stream: 'image_in'" & @CRLF & _
		"  output_stream: 'image_out'" & @CRLF & _
		"  node {" & @CRLF & _
		"    name: 'ImageTransformation'" & @CRLF & _
		"    calculator: 'ImageTransformationCalculator'" & @CRLF & _
		"    input_stream: 'IMAGE:image_in'" & @CRLF & _
		"    output_stream: 'IMAGE:image_out'" & @CRLF & _
		"    options: {" & @CRLF & _
		"      [mediapipe.ImageTransformationCalculatorOptions.ext] {" & @CRLF & _
		"         output_width: 10" & @CRLF & _
		"         output_height: 10" & @CRLF & _
		"      }" & @CRLF & _
		"    }" & @CRLF & _
		"    node_options: {" & @CRLF & _
		"      [type.googleapis.com/mediapipe.ImageTransformationCalculatorOptions] {" & @CRLF & _
		"         output_width: 10" & @CRLF & _
		"         output_height: 10" & @CRLF & _
		"      }" & @CRLF & _
		"    }" & @CRLF & _
		"  }" & @CRLF & _
		""

Test()

Func Test()
	test_valid_input_data_type_proto()

	test_solution_process("" & @CRLF & _
			"  input_stream: 'image_in'" & @CRLF & _
			"  output_stream: 'image_out'" & @CRLF & _
			"  node {" & @CRLF & _
			"    calculator: 'ImageTransformationCalculator'" & @CRLF & _
			"    input_stream: 'IMAGE:image_in'" & @CRLF & _
			"    output_stream: 'IMAGE:transformed_image_in'" & @CRLF & _
			"  }" & @CRLF & _
			"  node {" & @CRLF & _
			"    calculator: 'ImageTransformationCalculator'" & @CRLF & _
			"    input_stream: 'IMAGE:transformed_image_in'" & @CRLF & _
			"    output_stream: 'IMAGE:image_out'" & @CRLF & _
			"  }" & @CRLF & _
			"")

	test_solution_process("" & @CRLF & _
			"  input_stream: 'image_in'" & @CRLF & _
			"  input_side_packet: 'allow_signal'" & @CRLF & _
			"  input_side_packet: 'rotation_degrees'" & @CRLF & _
			"  output_stream: 'image_out'" & @CRLF & _
			"  node {" & @CRLF & _
			"    calculator: 'ImageTransformationCalculator'" & @CRLF & _
			"    input_stream: 'IMAGE:image_in'" & @CRLF & _
			"    input_side_packet: 'ROTATION_DEGREES:rotation_degrees'" & @CRLF & _
			"    output_stream: 'IMAGE:transformed_image_in'" & @CRLF & _
			"  }" & @CRLF & _
			"  node {" & @CRLF & _
			"    calculator: 'GateCalculator'" & @CRLF & _
			"    input_stream: 'transformed_image_in'" & @CRLF & _
			"    input_side_packet: 'ALLOW:allow_signal'" & @CRLF & _
			"    output_stream: 'image_out_to_transform'" & @CRLF & _
			"  }" & @CRLF & _
			"  node {" & @CRLF & _
			"    calculator: 'ImageTransformationCalculator'" & @CRLF & _
			"    input_stream: 'IMAGE:image_out_to_transform'" & @CRLF & _
			"    input_side_packet: 'ROTATION_DEGREES:rotation_degrees'" & @CRLF & _
			"    output_stream: 'IMAGE:image_out'" & @CRLF & _
			"  }" & @CRLF & _
			"", _Mediapipe_MapOfStringAndVariant( _
			"allow_signal", True, _
			"rotation_degrees", 0 _
			))

	test_modifying_calculator_proto2_options()
	test_modifying_calculator_proto3_node_options()
	test_adding_calculator_options()

	test_solution_reset("" & @CRLF & _
			"  input_stream: 'image_in'" & @CRLF & _
			"  output_stream: 'image_out'" & @CRLF & _
			"  node {" & @CRLF & _
			"    calculator: 'ImageTransformationCalculator'" & @CRLF & _
			"    input_stream: 'IMAGE:image_in'" & @CRLF & _
			"    output_stream: 'IMAGE:transformed_image_in'" & @CRLF & _
			"  }" & @CRLF & _
			"  node {" & @CRLF & _
			"    calculator: 'ImageTransformationCalculator'" & @CRLF & _
			"    input_stream: 'IMAGE:transformed_image_in'" & @CRLF & _
			"    output_stream: 'IMAGE:image_out'" & @CRLF & _
			"  }" & @CRLF & _
			"", Default)

	test_solution_reset("" & @CRLF & _
			"  input_stream: 'image_in'" & @CRLF & _
			"  input_side_packet: 'allow_signal'" & @CRLF & _
			"  input_side_packet: 'rotation_degrees'" & @CRLF & _
			"  output_stream: 'image_out'" & @CRLF & _
			"  node {" & @CRLF & _
			"    calculator: 'ImageTransformationCalculator'" & @CRLF & _
			"    input_stream: 'IMAGE:image_in'" & @CRLF & _
			"    input_side_packet: 'ROTATION_DEGREES:rotation_degrees'" & @CRLF & _
			"    output_stream: 'IMAGE:transformed_image_in'" & @CRLF & _
			"  }" & @CRLF & _
			"  node {" & @CRLF & _
			"    calculator: 'GateCalculator'" & @CRLF & _
			"    input_stream: 'transformed_image_in'" & @CRLF & _
			"    input_side_packet: 'ALLOW:allow_signal'" & @CRLF & _
			"    output_stream: 'image_out_to_transform'" & @CRLF & _
			"  }" & @CRLF & _
			"  node {" & @CRLF & _
			"    calculator: 'ImageTransformationCalculator'" & @CRLF & _
			"    input_stream: 'IMAGE:image_out_to_transform'" & @CRLF & _
			"    input_side_packet: 'ROTATION_DEGREES:rotation_degrees'" & @CRLF & _
			"    output_stream: 'IMAGE:image_out'" & @CRLF & _
			"  }" & @CRLF & _
			"", _Mediapipe_MapOfStringAndVariant( _
			"allow_signal", True, _
			"rotation_degrees", 0 _
			))

	test_solution_stream_type_hints()
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

	Local $config_proto = $text_format.Parse($text_config, $calculator_pb2.CalculatorGraphConfig())
	Local $solution = $solution_base.SolutionBase($config_proto)

	Local $input_detections = $detection_pb2.DetectionList()
	Local $detection_1 = $input_detections.detection.add()
	$text_format.Parse('score: 0.5', $detection_1)
	Local $detection_2 = $input_detections.detection.add()
	$text_format.Parse('score: 0.8', $detection_2)
	Local $results = $solution.process(_Mediapipe_MapOfStringAndVariant('input_detections', $input_detections))
	$solution = 0 ; check that outputs does not reference internal data
	_AssertTrue($results.has("output_detections"))
	_AssertEqual($results("output_detections").detection.size(), 2)
	Local $expected_detection_1 = $detection_pb2.Detection()
	$text_format.Parse('score: 0.5, detection_id: 1', $expected_detection_1)
	Local $expected_detection_2 = $detection_pb2.Detection()
	$text_format.Parse('score: 0.8, detection_id: 2', $expected_detection_2)
	_AssertEqual($results("output_detections").detection(0).__str__(), $expected_detection_1.__str__())
	_AssertEqual($results("output_detections").detection(1).__str__(), $expected_detection_2.__str__())
EndFunc   ;==>test_valid_input_data_type_proto

Func test_solution_process($text_config, $side_inputs = Default)
	_process_and_verify( _
			$text_format.Parse($text_config, $calculator_pb2.CalculatorGraphConfig()), _
			$side_inputs)
EndFunc   ;==>test_solution_process

Func test_modifying_calculator_proto2_options()
	Local $config_proto = $text_format.Parse($CALCULATOR_OPTIONS_TEST_GRAPH_CONFIG, $calculator_pb2.CalculatorGraphConfig())

	; To test proto2 options only, remove the proto3 node_options field from the
	; graph config.
	_AssertEqual("ImageTransformation", $config_proto.node(0).name)
	$config_proto.node(0).ClearField("node_options")
	_process_and_verify($config_proto, Default, _Mediapipe_MapOfStringAndVariant( _
			"ImageTransformation.output_width", 0, _
			"ImageTransformation.output_height", 0 _
			))
EndFunc   ;==>test_modifying_calculator_proto2_options

Func test_modifying_calculator_proto3_node_options()
	Local $config_proto = $text_format.Parse($CALCULATOR_OPTIONS_TEST_GRAPH_CONFIG, $calculator_pb2.CalculatorGraphConfig())

	; To test proto3 node options only, remove the proto2 options field from the
	; graph config.
	_AssertEqual("ImageTransformation", $config_proto.node(0).name)
	$config_proto.node(0).ClearField("options")
	_process_and_verify($config_proto, Default, _Mediapipe_MapOfStringAndVariant( _
			"ImageTransformation.output_width", 0, _
			"ImageTransformation.output_height", 0 _
			))
EndFunc   ;==>test_modifying_calculator_proto3_node_options

Func test_adding_calculator_options()
	Local $config_proto = $text_format.Parse($CALCULATOR_OPTIONS_TEST_GRAPH_CONFIG, $calculator_pb2.CalculatorGraphConfig())

	; To test a calculator with no options field, remove both proto2 options and
	; proto3 node_options fields from the graph config.
	_AssertEqual("ImageTransformation", $config_proto.node(0).name)
	$config_proto.node(0).ClearField("options")
	$config_proto.node(0).ClearField("node_options")
	_process_and_verify($config_proto, Default, _Mediapipe_MapOfStringAndVariant( _
			"ImageTransformation.output_width", 0, _
			"ImageTransformation.output_height", 0 _
			))
EndFunc   ;==>test_adding_calculator_options

Func test_solution_reset($text_config, $side_inputs)
	Local $config_proto = $text_format.Parse($text_config, $calculator_pb2.CalculatorGraphConfig())
	Local $input_image = _RandomImage(3, 3, $CV_8UC3, 0, 27)
	Local $solution = $solution_base.SolutionBase(_Mediapipe_Params( _
			"graph_config", $config_proto, _
			"side_inputs", $side_inputs _
			))

	Local $outputs

	For $i = 0 To 9
		$outputs = $solution.process($input_image)
		_AssertMatEqual($input_image, $outputs("image_out"))
		$solution.reset()
	Next
EndFunc   ;==>test_solution_reset

Func test_solution_stream_type_hints()
	Local $text_config = "" & @CRLF & _
			"  input_stream: 'union_type_image_in'" & @CRLF & _
			"  output_stream: 'image_type_out'" & @CRLF & _
			"  node {" & @CRLF & _
			"    calculator: 'ToImageCalculator'" & @CRLF & _
			"    input_stream: 'IMAGE:union_type_image_in'" & @CRLF & _
			"    output_stream: 'IMAGE:image_type_out'" & @CRLF & _
			"  }" & @CRLF & _
			"" & @CRLF

	Local $config_proto = $text_format.Parse($text_config, $calculator_pb2.CalculatorGraphConfig())
	Local $input_image = _RandomImage(3, 3, $CV_8UC3, 0, 27)

	Local $outputs

	Local $solution = $solution_base.SolutionBase(_Mediapipe_Params( _
			"graph_config", $config_proto, _
			"stream_type_hints", _Mediapipe_Map("String", "PacketDataType", _
			"union_type_image_in", $MEDIAPIPE_AUTOIT_SOLUTION_BASE_PACKET_DATA_TYPE_IMAGE _
			) _
			))

	For $i = 0 To 19
		$outputs = $solution.process($input_image)
		_AssertMatEqual($input_image, $outputs("image_type_out"))
	Next

	Local $solution2 = $solution_base.SolutionBase(_Mediapipe_Params( _
			"graph_config", $config_proto, _
			"stream_type_hints", _Mediapipe_Map("String", "PacketDataType", _
			"union_type_image_in", $MEDIAPIPE_AUTOIT_SOLUTION_BASE_PACKET_DATA_TYPE_IMAGE_FRAME _
			) _
			))

	For $i = 0 To 19
		$outputs = $solution2.process($input_image)
		_AssertMatEqual($input_image, $outputs("image_type_out"))
	Next
EndFunc   ;==>test_solution_stream_type_hints

Func _process_and_verify($config_proto, $side_inputs = Default, $calculator_params = Default)
	Local $input_image = _RandomImage(3, 3, $CV_8UC3, 0, 27)
	Local $solution = $solution_base.SolutionBase(_Mediapipe_Params( _
			"graph_config", $config_proto, _
			"side_inputs", $side_inputs, _
			"calculator_params", $calculator_params _
			))

	Local $outputs = $solution.process($input_image)
	Local $outputs2 = $solution.process(_Mediapipe_MapOfStringAndVariant("image_in", $input_image))
	$solution = 0 ; check that outputs does not reference internal data
	_AssertMatEqual($input_image, $outputs("image_out"))
	_AssertMatEqual($input_image, $outputs2("image_out"))
EndFunc   ;==>_process_and_verify

Func _OnAutoItExit()
	_OpenCV_Close()
	_Mediapipe_Close()
EndFunc   ;==>_OnAutoItExit
