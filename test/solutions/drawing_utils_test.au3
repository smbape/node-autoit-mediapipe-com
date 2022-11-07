#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Change2CUI=y
#AutoIt3Wrapper_Au3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#include "..\..\autoit-mediapipe-com\udf\mediapipe_udf_utils.au3"
#include "..\..\autoit-opencv-com\udf\opencv_udf_utils.au3"
#include "..\_assert.au3"
#include "..\_mat_utils.au3"

$_mediapipe_build_type = "Release"
$_mediapipe_debug = 0
$_cv_build_type = "Release"
$_cv_debug = 0
_Mediapipe_Open_And_Register(_Mediapipe_FindDLL("opencv_world4*", "opencv-4.*\opencv"), _Mediapipe_FindDLL("autoit_mediapipe_com-*"))
_OpenCV_Open_And_Register(_OpenCV_FindDLL("opencv_world4*", "opencv-4.*\opencv"), _OpenCV_FindDLL("autoit_opencv_com4*"))
OnAutoItExitRegister("_OnAutoItExit")

Global $cv = _OpenCV_get()

Global $text_format = _Mediapipe_ObjCreate("google.protobuf.text_format")
_AssertTrue(IsObj($text_format), "Failed to load google.protobuf.text_format")

Global $detection_pb2 = _Mediapipe_ObjCreate("mediapipe.framework.formats.detection_pb2")
_AssertTrue(IsObj($detection_pb2), "Failed to load mediapipe.framework.formats.detection_pb2")

Global $landmark_pb2 = _Mediapipe_ObjCreate("mediapipe.framework.formats.landmark_pb2")
_AssertTrue(IsObj($landmark_pb2), "Failed to load mediapipe.framework.formats.landmark_pb2")

Global $drawing_utils = _Mediapipe_ObjCreate("mediapipe.autoit.solutions.drawing_utils")
_AssertTrue(IsObj($drawing_utils), "Failed to load mediapipe.autoit.solutions.drawing_utils")

Global $DEFAULT_BBOX_DRAWING_SPEC = $drawing_utils.DrawingSpec()
Global $DEFAULT_CONNECTION_DRAWING_SPEC = $drawing_utils.DrawingSpec()
Global $DEFAULT_CIRCLE_DRAWING_SPEC = $drawing_utils.DrawingSpec($drawing_utils.RED_COLOR)
Global $DEFAULT_AXIS_DRAWING_SPEC = $drawing_utils.DrawingSpec()
Global $DEFAULT_CYCLE_BORDER_COLOR[] = [224, 224, 224]

Test()

Func Test()
	test_draw_keypoints_only()
	test_draw_bboxs_only()
	test_draw_single_landmark_point('landmark {x: 0.1 y: 0.1}')
	test_draw_single_landmark_point('landmark {x: 0.1 y: 0.1} landmark {x: 0.5 y: 0.5 visibility: 0.0}')
	test_draw_landmarks_and_connections('landmark {x: 0.1 y: 0.5} landmark {x: 0.5 y: 0.1}')
	test_draw_landmarks_and_connections( _
			'landmark {x: 0.1 y: 0.5 presence: 0.5}' & @CRLF & _
			'landmark {x: 0.5 y: 0.1 visibility: 0.5}' _
			)
	test_draw_axis()
	test_draw_axis_zero_translation()
EndFunc   ;==>Test

Func test_draw_keypoints_only()
	Local $detection = $text_format.Parse( _
			'location_data {' & @CRLF & _
			'  format: RELATIVE_BOUNDING_BOX' & @CRLF & _
			'  relative_keypoints {x: 0 y: 1}' & @CRLF & _
			'  relative_keypoints {x: 1 y: 0}}', _
			$detection_pb2.Detection())
	Local $image = _OpenCV_ObjCreate("Mat").zeros(100, 100, $CV_8UC3)
	Local $expected_result = $image.copy()

	$cv.circle($expected_result, _OpenCV_Point(0, 99), _
			$DEFAULT_CIRCLE_DRAWING_SPEC.circle_radius, _
			$DEFAULT_CIRCLE_DRAWING_SPEC.color, _
			$DEFAULT_CIRCLE_DRAWING_SPEC.thickness)
	$cv.circle($expected_result, _OpenCV_Point(99, 0), _
			$DEFAULT_CIRCLE_DRAWING_SPEC.circle_radius, _
			$DEFAULT_CIRCLE_DRAWING_SPEC.color, _
			$DEFAULT_CIRCLE_DRAWING_SPEC.thickness)

	$drawing_utils.draw_detection($image, $detection)

	_AssertMatEqual($image, $expected_result)
EndFunc   ;==>test_draw_keypoints_only

Func test_draw_bboxs_only()
	Local $detection = $text_format.Parse( _
			'location_data {' & @CRLF & _
			'  format: RELATIVE_BOUNDING_BOX' & @CRLF & _
			'  relative_bounding_box {xmin: 0 ymin: 0 width: 1 height: 1}}', _
			$detection_pb2.Detection())
	Local $image = _OpenCV_ObjCreate("Mat").zeros(100, 100, $CV_8UC3)
	Local $expected_result = $image.copy()

	$cv.rectangle($expected_result, _OpenCV_Point(0, 0), _OpenCV_Point(99, 99), _
			$DEFAULT_BBOX_DRAWING_SPEC.color, _
			$DEFAULT_BBOX_DRAWING_SPEC.thickness)
	$drawing_utils.draw_detection($image, $detection)
	_AssertMatEqual($image, $expected_result)
EndFunc   ;==>test_draw_bboxs_only

Func test_draw_single_landmark_point($landmark_list_text)
	Local $landmark_list = $text_format.Parse($landmark_list_text, $landmark_pb2.NormalizedLandmarkList())
	Local $image = _OpenCV_ObjCreate("Mat").zeros(100, 100, $CV_8UC3)
	Local $expected_result = $image.copy()

	$cv.circle($expected_result, _OpenCV_Point(10, 10), _
			$DEFAULT_CIRCLE_DRAWING_SPEC.circle_radius + 1, _
			$DEFAULT_CYCLE_BORDER_COLOR, _
			$DEFAULT_CIRCLE_DRAWING_SPEC.thickness)
	$cv.circle($expected_result, _OpenCV_Point(10, 10), _
			$DEFAULT_CIRCLE_DRAWING_SPEC.circle_radius, _
			$DEFAULT_CIRCLE_DRAWING_SPEC.color, _
			$DEFAULT_CIRCLE_DRAWING_SPEC.thickness)
	$drawing_utils.draw_landmarks($image, $landmark_list)
	_AssertMatEqual($image, $expected_result)
EndFunc   ;==>test_draw_single_landmark_point

Func test_draw_landmarks_and_connections($landmark_list_text)
	Local $landmark_list = $text_format.Parse($landmark_list_text, $landmark_pb2.NormalizedLandmarkList())
	Local $image = _OpenCV_ObjCreate("Mat").zeros(100, 100, $CV_8UC3)
	Local $expected_result = $image.copy()

	Local $start_point = _OpenCV_Point(10, 50)
	Local $end_point = _OpenCV_Point(50, 10)

	$cv.line($expected_result, $start_point, $end_point, _
			$DEFAULT_CONNECTION_DRAWING_SPEC.color, _
			$DEFAULT_CONNECTION_DRAWING_SPEC.thickness)
	$cv.circle($expected_result, $start_point, _
			$DEFAULT_CIRCLE_DRAWING_SPEC.circle_radius + 1, _
			$DEFAULT_CYCLE_BORDER_COLOR, _
			$DEFAULT_CIRCLE_DRAWING_SPEC.thickness)
	$cv.circle($expected_result, $end_point, _
			$DEFAULT_CIRCLE_DRAWING_SPEC.circle_radius + 1, _
			$DEFAULT_CYCLE_BORDER_COLOR, _
			$DEFAULT_CIRCLE_DRAWING_SPEC.thickness)
	$cv.circle($expected_result, $start_point, _
			$DEFAULT_CIRCLE_DRAWING_SPEC.circle_radius, _
			$DEFAULT_CIRCLE_DRAWING_SPEC.color, _
			$DEFAULT_CIRCLE_DRAWING_SPEC.thickness)
	$cv.circle($expected_result, $end_point, _
			$DEFAULT_CIRCLE_DRAWING_SPEC.circle_radius, _
			$DEFAULT_CIRCLE_DRAWING_SPEC.color, _
			$DEFAULT_CIRCLE_DRAWING_SPEC.thickness)

	$drawing_utils.draw_landmarks($image, $landmark_list, _Mediapipe_Tuple(_Mediapipe_Tuple(0, 1)))
	_AssertMatEqual($image, $expected_result)
EndFunc   ;==>test_draw_landmarks_and_connections

Func test_draw_axis()
	Local $image = _OpenCV_ObjCreate("Mat").zeros(100, 100, $CV_8UC3)
	Local $expected_result = $image.copy()

	Local $origin[] = [50, 50]
	Local $x_axis[] = [75, 50]
	Local $y_axis[] = [50, 23]
	Local $z_axis[] = [50, 77]

	$cv.arrowedLine($expected_result, $origin, $x_axis, $drawing_utils.RED_COLOR, _
			$DEFAULT_AXIS_DRAWING_SPEC.thickness)
	$cv.arrowedLine($expected_result, $origin, $y_axis, $drawing_utils.GREEN_COLOR, _
			$DEFAULT_AXIS_DRAWING_SPEC.thickness)
	$cv.arrowedLine($expected_result, $origin, $z_axis, $drawing_utils.BLUE_COLOR, _
			$DEFAULT_AXIS_DRAWING_SPEC.thickness)

	Local $r = Sqrt(2) / 2
	Local $rotation = _OpenCV_ObjCreate("Mat").createFromVectorOfVec3d(_OpenCV_Tuple( _
			_OpenCV_Tuple(1, 0, 0), _
			_OpenCV_Tuple(0, $r, -$r), _
			_OpenCV_Tuple(0, $r, $r) _
			))
	Local $translation = _OpenCV_ObjCreate("Mat").createFromVec3d(_OpenCV_Tuple(0, 0, -0.2))
	$drawing_utils.draw_axis($image, $rotation, $translation)
	_AssertMatEqual($image, $expected_result)
EndFunc   ;==>test_draw_axis

Func test_draw_axis_zero_translation()
	Local $image = _OpenCV_ObjCreate("Mat").zeros(100, 100, $CV_8UC3)
	Local $expected_result = $image.copy()

	Local $origin[] = [50, 50]
	Local $x_axis[] = [0, 50]
	Local $y_axis[] = [50, 100]
	Local $z_axis[] = [50, 50]

	$cv.arrowedLine($expected_result, $origin, $x_axis, $drawing_utils.RED_COLOR, _
			$DEFAULT_AXIS_DRAWING_SPEC.thickness)
	$cv.arrowedLine($expected_result, $origin, $y_axis, $drawing_utils.GREEN_COLOR, _
			$DEFAULT_AXIS_DRAWING_SPEC.thickness)
	$cv.arrowedLine($expected_result, $origin, $z_axis, $drawing_utils.BLUE_COLOR, _
			$DEFAULT_AXIS_DRAWING_SPEC.thickness)

	Local $rotation = _OpenCV_ObjCreate("Mat").eye(3, $CV_64F)
	Local $translation = _OpenCV_ObjCreate("Mat").zeros(3, $CV_64F)
	$drawing_utils.draw_axis($image, $rotation, $translation)
	_AssertMatEqual($image, $expected_result)
EndFunc   ;==>test_draw_axis_zero_translation

Func _OnAutoItExit()
	_OpenCV_Unregister_And_Close()
	_Mediapipe_Unregister_And_Close()
EndFunc   ;==>_OnAutoItExit
