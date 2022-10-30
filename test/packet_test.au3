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

Global $detection_pb2 = _Mediapipe_ObjCreate("mediapipe.framework.formats.detection_pb2")
_AssertTrue(IsObj($detection_pb2), "Failed to load mediapipe.framework.formats.detection_pb2")

Global $packet_creator = _Mediapipe_ObjCreate("mediapipe.autoit.packet_creator")
_AssertTrue(IsObj($packet_creator), "Failed to load mediapipe.autoit")

Global $packet_getter = _Mediapipe_ObjCreate("mediapipe.autoit.packet_getter")
_AssertTrue(IsObj($packet_getter), "Failed to load mediapipe.autoit")

Global $calculator_graph = _Mediapipe_ObjCreate("mediapipe.autoit._framework_bindings.calculator_graph")
_AssertTrue(IsObj($calculator_graph), "Failed to load mediapipe.autoit._framework_bindings")

Global $image_ = _Mediapipe_ObjCreate("mediapipe.autoit._framework_bindings.image")
_AssertTrue(IsObj($image_), "Failed to load mediapipe.autoit._framework_bindings")

Global $image_frame = _Mediapipe_ObjCreate("mediapipe.autoit._framework_bindings.image_frame")
_AssertTrue(IsObj($image_frame), "Failed to load mediapipe.autoit._framework_bindings")

Global $packet = _Mediapipe_ObjCreate("mediapipe.autoit._framework_bindings.packet")
_AssertTrue(IsObj($packet), "Failed to load mediapipe.autoit._framework_bindings")

Global $CalculatorGraph = $calculator_graph.CalculatorGraph
_AssertTrue(IsObj($CalculatorGraph), "Failed to load calculator_graph.CalculatorGraph")

Global $Image = $image_.Image
_AssertTrue(IsObj($Image), "Failed to load image.Image")

Global $ImageFrame = $image_frame.ImageFrame
_AssertTrue(IsObj($ImageFrame), "Failed to load image_frame.ImageFrame")

Test()

Func Test()
	test_empty_packet()
	test_boolean_packet()
	test_int_packet()
	test_int8_packet()
	test_int16_packet()
	test_int32_packet()
	test_int64_packet()
	test_uint8_packet()
	test_uint16_packet()
	test_uint32_packet()
	test_uint64_packet()
	test_float_packet()
	test_double_packet()
	test_detection_proto_packet()
	test_string_packet()
	test_int_array_packet()
	test_float_array_packet()
	test_int_vector_packet()
	test_float_vector_packet()
	test_image_vector_packet()
	test_string_vector_packet()
	test_packet_vector_packet()
	test_string_to_packet_map_packet()
	test_uint8_image_packet()
	test_uint16_image_packet()
	test_float_image_frame_packet()
	test_image_frame_packet_creation_copy_mode()
	test_image_frame_packet_creation_reference_mode()
	test_image_frame_packet_copy_creation_with_cropping()
	test_image_packet_creation_copy_mode()
	test_image_packet_creation_reference_mode()
	test_image_packet_copy_creation_with_cropping()
EndFunc   ;==>Test

Func test_empty_packet()
	Local $p = $packet.Packet()
	_AssertTrue($p.is_empty())
EndFunc   ;==>test_empty_packet

Func test_boolean_packet()
	Local $p = $packet_creator.create_bool(True)
	$p.timestamp = 0
	_AssertEqual($packet_getter.get_bool($p), True)
	_AssertEqual($p.timestamp.value, 0)
EndFunc   ;==>test_boolean_packet

Func test_int_packet()
	Local $p = $packet_creator.create_int(42)
	$p.timestamp = 0
	_AssertEqual($packet_getter.get_int($p), 42)
	_AssertEqual($p.timestamp.value, 0)
	Local $p2 = $packet_creator.create_int(1)
	$p2.timestamp = 0
	_AssertEqual($packet_getter.get_int($p2), 1)
	_AssertEqual($p2.timestamp.value, 0)
EndFunc   ;==>test_int_packet

Func test_int8_packet()
	Local $p = $packet_creator.create_int8(2 ^ 7 - 1)
	$p.timestamp = 0
	_AssertEqual($packet_getter.get_int($p), 2 ^ 7 - 1)
	_AssertEqual($p.timestamp.value, 0)
	Local $p2 = $packet_creator.create_int8(1)
	$p2.timestamp = 0
	_AssertEqual($packet_getter.get_int($p2), 1)
	_AssertEqual($p2.timestamp.value, 0)
EndFunc   ;==>test_int8_packet

Func test_int16_packet()
	Local $p = $packet_creator.create_int16(2 ^ 15 - 1)
	$p.timestamp = 0
	_AssertEqual($packet_getter.get_int($p), 2 ^ 15 - 1)
	_AssertEqual($p.timestamp.value, 0)
	Local $p2 = $packet_creator.create_int16(1)
	$p2.timestamp = 0
	_AssertEqual($packet_getter.get_int($p2), 1)
	_AssertEqual($p2.timestamp.value, 0)
EndFunc   ;==>test_int16_packet

Func test_int32_packet()
	Local $p = $packet_creator.create_int32(2 ^ 31 - 1)
	$p.timestamp = 0
	_AssertEqual($packet_getter.get_int($p), 2 ^ 31 - 1)
	_AssertEqual($p.timestamp.value, 0)
	Local $p2 = $packet_creator.create_int32(1)
	$p2.timestamp = 0
	_AssertEqual($packet_getter.get_int($p2), 1)
	_AssertEqual($p2.timestamp.value, 0)
EndFunc   ;==>test_int32_packet

Func test_int64_packet()
	Local $p = $packet_creator.create_int64(0x7FFFFFFFFFFFFFFF)
	$p.timestamp = 0
	_AssertEqual($packet_getter.get_int($p), 0x7FFFFFFFFFFFFFFF)
	_AssertEqual($p.timestamp.value, 0)
	Local $p2 = $packet_creator.create_int64(1)
	$p2.timestamp = 0
	_AssertEqual($packet_getter.get_int($p2), 1)
	_AssertEqual($p2.timestamp.value, 0)
EndFunc   ;==>test_int64_packet

Func test_uint8_packet()
	Local $p = $packet_creator.create_uint8(2 ^ 8 - 1)
	$p.timestamp = 0
	_AssertEqual($packet_getter.get_uint($p), 2 ^ 8 - 1)
	_AssertEqual($p.timestamp.value, 0)
	Local $p2 = $packet_creator.create_uint8(1)
	$p2.timestamp = 0
	_AssertEqual($packet_getter.get_uint($p2), 1)
	_AssertEqual($p2.timestamp.value, 0)
EndFunc   ;==>test_uint8_packet

Func test_uint16_packet()
	Local $p = $packet_creator.create_uint16(2 ^ 16 - 1)
	$p.timestamp = 0
	_AssertEqual($packet_getter.get_uint($p), 2 ^ 16 - 1)
	_AssertEqual($p.timestamp.value, 0)
	Local $p2 = $packet_creator.create_uint16(1)
	$p2.timestamp = 0
	_AssertEqual($packet_getter.get_uint($p2), 1)
	_AssertEqual($p2.timestamp.value, 0)
EndFunc   ;==>test_uint16_packet

Func test_uint32_packet()
	Local $p = $packet_creator.create_uint32(2 ^ 32 - 1)
	$p.timestamp = 0
	_AssertEqual($packet_getter.get_uint($p), 2 ^ 32 - 1)
	_AssertEqual($p.timestamp.value, 0)
	Local $p2 = $packet_creator.create_uint32(1)
	$p2.timestamp = 0
	_AssertEqual($packet_getter.get_uint($p2), 1)
	_AssertEqual($p2.timestamp.value, 0)
EndFunc   ;==>test_uint32_packet

Func test_uint64_packet()
	Local $p = $packet_creator.create_uint64(Ptr(0xFFFFFFFFFFFFFFFF))
	$p.timestamp = 0
	_AssertEqual(Ptr($packet_getter.get_uint($p)), Ptr(0xFFFFFFFFFFFFFFFF))
	_AssertEqual($p.timestamp.value, 0)
	Local $p2 = $packet_creator.create_uint64(1)
	$p2.timestamp = 0
	_AssertEqual($packet_getter.get_uint($p2), 1)
	_AssertEqual($p2.timestamp.value, 0)
EndFunc   ;==>test_uint64_packet

Func test_float_packet()
	Local $p = $packet_creator.create_float(0.42)
	$p.timestamp = 0
	_AssertAlmostEqual($packet_getter.get_float($p), 0.42)
	_AssertEqual($p.timestamp.value, 0)
EndFunc   ;==>test_float_packet

Func test_double_packet()
	Local $p = $packet_creator.create_double(0.42)
	$p.timestamp = 0
	_AssertAlmostEqual($packet_getter.get_float($p), 0.42)
	_AssertEqual($p.timestamp.value, 0)
EndFunc   ;==>test_double_packet

Func test_detection_proto_packet()
	Local $detection = $detection_pb2.Detection()

	$text_format.Parse("score: 0.5", $detection)
	$text_format.Parse("score: 0.6", $detection)

	Local $proto_packet = $packet_creator.create_proto($detection)

	Local $output_proto = $packet_getter.get_proto($proto_packet)

	Local $p = $packet_creator.create_proto($detection).at(100)

	Local $cmessage = _Mediapipe_ObjCreate("google.protobuf.autoit.cmessage")
	_AssertTrue(IsObj($cmessage), "Failed to load google.protobuf.autoit.cmessage")

	Local $scores = $cmessage.GetFieldValue($detection, "score")
	_AssertEqual($scores.size(), 2)

	; index access
	_AssertAlmostEqual($scores(0), 0.5)
	_AssertAlmostEqual($scores(1), 0.6)

	; loop access
	Local $size = 0
	For $score In $scores
		If $size == 0 Then
			_AssertAlmostEqual($score, 0.5)
		Else
			_AssertAlmostEqual($score, 0.6)
		EndIf
		$size += 1
	Next

	_AssertEqual($size, 2)

	$scores = $detection.score
	_AssertEqual($scores.size(), 2)

	; index access
	_AssertAlmostEqual($scores(0), 0.5)
	_AssertAlmostEqual($scores(1), 0.6)

	; loop access
	$size = 0
	For $score In $scores
		If $size == 0 Then
			_AssertAlmostEqual($score, 0.5)
		Else
			_AssertAlmostEqual($score, 0.6)
		EndIf
		$size += 1
	Next

	_AssertEqual($size, 2)
	#forceref $p, $output_proto
EndFunc   ;==>test_detection_proto_packet

Func test_string_packet()
	Local $p = $packet_creator.create_string("abc").at(100)
	_AssertEqual($packet_getter.get_str($p), "abc")
	_AssertEqual($p.timestamp.value, 100)
	$p.timestamp = 200
	_AssertEqual($p.timestamp.value, 200)
EndFunc   ;==>test_string_packet

Func test_int_array_packet()
	Local $aArr = [1, 2, 3]
	Local $p = $packet_creator.create_int_array($aArr).at(100)
	_AssertEqual($p.timestamp.value, 100)
EndFunc   ;==>test_int_array_packet

Func test_float_array_packet()
	Local $aArr = [0.1, 0.2, 0.3]
	Local $p = $packet_creator.create_float_array($aArr).at(100)
	_AssertEqual($p.timestamp.value, 100)
EndFunc   ;==>test_float_array_packet

Func test_int_vector_packet()
	Local $aArr = [1, 2, 3]
	Local $p = $packet_creator.create_int_vector($aArr).at(100)
	_AssertEqual($packet_getter.get_int_list($p), $aArr)
	_AssertEqual($p.timestamp.value, 100)
EndFunc   ;==>test_int_vector_packet

Func test_float_vector_packet()
	Local $aArr = [0.1, 0.2, 0.3]
	Local $p = $packet_creator.create_float_vector($aArr).at(100)
	Local $output_list = $packet_getter.get_float_list($p)
	_AssertAlmostEqual($output_list[0], 0.1)
	_AssertAlmostEqual($output_list[1], 0.2)
	_AssertAlmostEqual($output_list[2], 0.3)
	_AssertEqual($p.timestamp.value, 100)
EndFunc   ;==>test_float_vector_packet

Func test_image_vector_packet()
	Local $w = 80, $h = 40, $offset = 10
	Local $mat = _RandomImage($w, $h, $CV_8UC3, 0, 2 ^ 8)
	Local $roi = _OpenCV_ObjCreate("cv.Mat").create($mat, _OpenCV_Rect($offset, $offset, $w - 2 * $offset, $h - 2 * $offset))
	Local $images = [$Image($mat), $Image($roi)]
	Local $p = $packet_creator.create_image_vector($images).at(100)
	Local $output_list = $packet_getter.get_image_list($p)
	_AssertLen($output_list, 2)
	_AssertMatEqual($output_list[0].mat_view(), $mat)
	_AssertMatEqual($output_list[1].mat_view(), $roi)
	_AssertEqual($p.timestamp.value, 100)
EndFunc   ;==>test_image_vector_packet

Func test_string_vector_packet()
	Local $p = $packet_creator.create_string_vector(_Mediapipe_Tuple("a", "b", "c")).at(100)
	Local $output_list = $packet_getter.get_str_list($p)
	_AssertEqual($output_list[0], "a")
	_AssertEqual($output_list[1], "b")
	_AssertEqual($output_list[2], "c")
	_AssertEqual($p.timestamp.value, 100)
EndFunc   ;==>test_string_vector_packet

Func test_packet_vector_packet()
	Local $p = $packet_creator.create_packet_vector(_Mediapipe_Tuple( _
			$packet_creator.create_float(0.42), _
			$packet_creator.create_int(42), _
			$packet_creator.create_string("42") _
			)).at(100)
	Local $output_list = $packet_getter.get_packet_list($p)
	_AssertAlmostEqual($packet_getter.get_float($output_list[0]), 0.42)
	_AssertEqual($packet_getter.get_int($output_list[1]), 42)
	_AssertEqual($packet_getter.get_str($output_list[2]), "42")
	_AssertEqual($p.timestamp.value, 100)
EndFunc   ;==>test_packet_vector_packet

Func test_string_to_packet_map_packet()
	Local $p = $packet_creator.create_string_to_packet_map(_Mediapipe_MapOfStringAndPacket( _
			"float", $packet_creator.create_float(0.42), _
			"int", $packet_creator.create_int(42), _
			"string", $packet_creator.create_string("42") _
			)).at(100)
	Local $output_list = $packet_getter.get_str_to_packet_dict($p)
	_AssertAlmostEqual($packet_getter.get_float($output_list("float")), 0.42)
	_AssertEqual($packet_getter.get_int($output_list("int")), 42)
	_AssertEqual($packet_getter.get_str($output_list("string")), "42")
	_AssertEqual($p.timestamp.value, 100)
EndFunc   ;==>test_string_to_packet_map_packet

Func test_uint8_image_packet()
	Local $uint8_img = _RandomImage(Floor(Random(3, 100)), Floor(Random(3, 100)), $CV_8UC3, 0, 2 ^ 8)
	Local $image_frame_packet = $packet_creator.create_image_frame($ImageFrame($uint8_img))
	Local $output_image_frame = $packet_getter.get_image_frame($image_frame_packet)
	_AssertMatEqual($output_image_frame.mat_view(), $uint8_img)
	Local $image_packet = $packet_creator.create_image($Image($uint8_img))
	Local $output_image = $packet_getter.get_image($image_packet)
	_AssertMatEqual($output_image.mat_view(), $uint8_img)
EndFunc   ;==>test_uint8_image_packet

Func test_uint16_image_packet()
	Local $uint16_img = _RandomImage(Floor(Random(3, 100)), Floor(Random(3, 100)), $CV_16UC4, 0, 2 ^ 16)
	Local $image_frame_packet = $packet_creator.create_image_frame($ImageFrame($uint16_img))
	Local $output_image_frame = $packet_getter.get_image_frame($image_frame_packet)
	_AssertMatEqual($output_image_frame.mat_view(), $uint16_img)
	Local $image_packet = $packet_creator.create_image($Image($uint16_img))
	Local $output_image = $packet_getter.get_image($image_packet)
	_AssertMatEqual($output_image.mat_view(), $uint16_img)
EndFunc   ;==>test_uint16_image_packet

Func test_float_image_frame_packet()
	Local $float_img = _RandomImage(Floor(Random(3, 100)), Floor(Random(3, 100)), $CV_32FC2, 0, 1)
	Local $image_frame_packet = $packet_creator.create_image_frame($ImageFrame($float_img))
	Local $output_image_frame = $packet_getter.get_image_frame($image_frame_packet)
	_AssertMatAlmostEqual($output_image_frame.mat_view(), $float_img)
	Local $image_packet = $packet_creator.create_image($Image($float_img))
	Local $output_image = $packet_getter.get_image($image_packet)
	_AssertMatAlmostEqual($output_image.mat_view(), $float_img)
EndFunc   ;==>test_float_image_frame_packet

Func test_image_frame_packet_creation_copy_mode()
	Local $w = Floor(Random(3, 100)), $h = Floor(Random(3, 100)), $channels = 3
	Local $rgb_data = _RandomImage($w, $h, CV_MAKETYPE($CV_8U, $channels), 0, 2 ^ 8)

	Local $p = $packet_creator.create_image_frame($rgb_data)

	Local $output_frame = $packet_getter.get_image_frame($p)
	_AssertEqual($output_frame.height, $h)
	_AssertEqual($output_frame.width, $w)
	_AssertEqual($output_frame.channels, $channels)
	_AssertMatEqual($output_frame.mat_view(), $rgb_data)
EndFunc   ;==>test_image_frame_packet_creation_copy_mode

Func test_image_frame_packet_creation_reference_mode()
	Local $w = Floor(Random(3, 100)), $h = Floor(Random(3, 100)), $channels = 3
	Local $rgb_data = _RandomImage($w, $h, CV_MAKETYPE($CV_8U, $channels), 0, 2 ^ 8)

	Local $text_config = _
			"node {" & @CRLF & _
			"  calculator: 'PassThroughCalculator'" & @CRLF & _
			"  input_side_packet: 'in'" & @CRLF & _
			"  output_side_packet: 'out'" & @CRLF & _
			"}"

	Local $graph = $CalculatorGraph(_Mediapipe_Params("graph_config", $text_config))
	$graph.start_run(_Mediapipe_MapOfStringAndPacket("in", $packet_creator.create_image_frame($rgb_data)))
	$graph.wait_until_done()
	Local $output_packet = $graph.get_output_side_packet("out")
	; The pixel data of the output image frame packet should still be valid
	; after the graph and the original rgb_data data are deleted.
	_AssertMatEqual($packet_getter.get_image_frame($output_packet).mat_view(), $rgb_data)
EndFunc   ;==>test_image_frame_packet_creation_reference_mode

Func test_image_frame_packet_copy_creation_with_cropping()
	Local $w = Floor(Random(40, 100)), $h = Floor(Random(40, 100)), $channels = 3, $offset = 10
	Local $rgb_data = _RandomImage($w, $h, CV_MAKETYPE($CV_8U, $channels), 0, 2 ^ 8)
	Local $rgb_data_cropped = _OpenCV_ObjCreate("cv.Mat").create($rgb_data, _OpenCV_Rect($offset, $offset, $w - 2 * $offset, $h - 2 * $offset))

	Local $p = $packet_creator.create_image_frame($rgb_data_cropped)
	Local $output_frame = $packet_getter.get_image_frame($p)
	_AssertEqual($output_frame.height, $h - 2 * $offset)
	_AssertEqual($output_frame.width, $w - 2 * $offset)
	_AssertEqual($output_frame.channels, $channels)
	_AssertMatEqual($rgb_data_cropped, $output_frame.mat_view())
EndFunc   ;==>test_image_frame_packet_copy_creation_with_cropping

Func test_image_packet_creation_copy_mode()
	Local $w = Floor(Random(3, 100)), $h = Floor(Random(3, 100)), $channels = 3
	Local $rgb_data = _RandomImage($w, $h, CV_MAKETYPE($CV_8U, $channels), 0, 2 ^ 8)
	Local $p = $packet_creator.create_image($rgb_data)

	Local $output_image = $packet_getter.get_image($p)
	_AssertEqual($output_image.height, $h)
	_AssertEqual($output_image.width, $w)
	_AssertEqual($output_image.channels, $channels)
	_AssertMatEqual($output_image.mat_view(), $rgb_data)
EndFunc   ;==>test_image_packet_creation_copy_mode

Func test_image_packet_creation_reference_mode()
	Local $w = Floor(Random(3, 100)), $h = Floor(Random(3, 100)), $channels = 3
	Local $rgb_data = _RandomImage($w, $h, CV_MAKETYPE($CV_8U, $channels), 0, 2 ^ 8)

	Local $text_config = _
			"node {" & @CRLF & _
			"  calculator: 'PassThroughCalculator'" & @CRLF & _
			"  input_side_packet: 'in'" & @CRLF & _
			"  output_side_packet: 'out'" & @CRLF & _
			"}"

	Local $graph = $CalculatorGraph(_Mediapipe_Params("graph_config", $text_config))
	$graph.start_run(_Mediapipe_MapOfStringAndPacket("in", $packet_creator.create_image($rgb_data)))
	$graph.wait_until_done()
	Local $output_packet = $graph.get_output_side_packet("out")
	_AssertMatEqual($packet_getter.get_image($output_packet).mat_view(), $rgb_data)
EndFunc   ;==>test_image_packet_creation_reference_mode

Func test_image_packet_copy_creation_with_cropping()
	Local $w = Floor(Random(40, 100)), $h = Floor(Random(40, 100)), $channels = 3, $offset = 10
	Local $rgb_data = _RandomImage($w, $h, CV_MAKETYPE($CV_8U, $channels), 0, 2 ^ 8)
	Local $rgb_data_cropped = _OpenCV_ObjCreate("cv.Mat").create($rgb_data, _OpenCV_Rect($offset, $offset, $w - 2 * $offset, $h - 2 * $offset))

	Local $p = $packet_creator.create_image($rgb_data_cropped)
	Local $output_image = $packet_getter.get_image($p)
	_AssertEqual($output_image.height, $h - 2 * $offset)
	_AssertEqual($output_image.width, $w - 2 * $offset)
	_AssertEqual($output_image.channels, $channels)
	_AssertMatEqual($rgb_data_cropped, $output_image.mat_view())
EndFunc   ;==>test_image_packet_copy_creation_with_cropping

Func _OnAutoItExit()
	_OpenCV_Unregister_And_Close()
	_Mediapipe_Unregister_And_Close()
EndFunc   ;==>_OnAutoItExit
