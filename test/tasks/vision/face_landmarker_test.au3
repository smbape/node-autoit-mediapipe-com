#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Change2CUI=y
#AutoIt3Wrapper_Au3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

;~ Sources:
;~     https://github.com/google-ai-edge/mediapipe/blob/v0.10.14/mediapipe/tasks/python/test/vision/face_landmarker_test.py

#include "..\..\..\autoit-mediapipe-com\udf\mediapipe_udf_utils.au3"
#include "..\..\..\autoit-opencv-com\udf\opencv_udf_utils.au3"
#include "..\..\_assert.au3"
#include "..\..\_mat_utils.au3"
#include "..\..\_proto_utils.au3"
#include "..\..\_test_utils.au3"

_Mediapipe_Open(_Mediapipe_FindDLL("opencv_world4100*"), _Mediapipe_FindDLL("autoit_mediapipe_com-*-4100*"))
_OpenCV_Open(_OpenCV_FindDLL("opencv_world4100*"), _OpenCV_FindDLL("autoit_opencv_com4100*"))
OnAutoItExitRegister("_OnAutoItExit")

; Tell mediapipe where to look its resource files
_Mediapipe_SetResourceDir()

Global Const $download_utils = _Mediapipe_ObjCreate("mediapipe.autoit.solutions.download_utils")
_AssertIsObj($download_utils, "Failed to load mediapipe.autoit.solutions.download_utils")

Global Const $text_format = _Mediapipe_ObjCreate("google.protobuf.text_format")
_AssertIsObj($text_format, "Failed to load google.protobuf.text_format")

Global Const $classification_pb2 = _Mediapipe_ObjCreate("mediapipe.framework.formats.classification_pb2")
_AssertIsObj($classification_pb2, "Failed to load mediapipe.framework.formats.classification_pb2")

Global Const $landmark_pb2 = _Mediapipe_ObjCreate("mediapipe.framework.formats.landmark_pb2")
_AssertIsObj($landmark_pb2, "Failed to load mediapipe.framework.formats.landmark_pb2")

Global Const $image_module = _Mediapipe_ObjCreate("mediapipe.autoit._framework_bindings.image")
_AssertIsObj($image_module, "Failed to load mediapipe.autoit._framework_bindings.image")

Global Const $category_module = _Mediapipe_ObjCreate("mediapipe.tasks.autoit.components.containers.category")
_AssertIsObj($category_module, "Failed to load mediapipe.tasks.autoit.components.containers.category")

Global Const $landmark_module = _Mediapipe_ObjCreate("mediapipe.tasks.autoit.components.containers.landmark")
_AssertIsObj($landmark_module, "Failed to load mediapipe.tasks.autoit.components.containers.landmark")

Global Const $rect_module = _Mediapipe_ObjCreate("mediapipe.tasks.autoit.components.containers.rect")
_AssertIsObj($rect_module, "Failed to load mediapipe.tasks.autoit.components.containers.rect")

Global Const $base_options_module = _Mediapipe_ObjCreate("mediapipe.tasks.autoit.core.base_options")
_AssertIsObj($base_options_module, "Failed to load mediapipe.tasks.autoit.core.base_options")

Global Const $face_landmarker = _Mediapipe_ObjCreate("mediapipe.tasks.autoit.vision.face_landmarker")
_AssertIsObj($face_landmarker, "Failed to load mediapipe.tasks.autoit.vision.face_landmarker")

Global Const $image_processing_options_module = _Mediapipe_ObjCreate("mediapipe.tasks.autoit.vision.core.image_processing_options")
_AssertIsObj($image_processing_options_module, "Failed to load mediapipe.tasks.autoit.vision.core.image_processing_options")

Global Const $running_mode_module = _Mediapipe_ObjCreate("mediapipe.tasks.autoit.vision.core.vision_task_running_mode")
_AssertIsObj($running_mode_module, "Failed to load mediapipe.tasks.autoit.vision.core.vision_task_running_mode")

Global Const $FaceLandmarkerResult = $face_landmarker.FaceLandmarkerResult
Global Const $_BaseOptions = $base_options_module.BaseOptions
Global Const $_Category = $category_module.Category
Global Const $_Rect = $rect_module.Rect
Global Const $_Landmark = $landmark_module.Landmark
Global Const $_NormalizedLandmark = $landmark_module.NormalizedLandmark
Global Const $_Image = $image_module.Image
Global Const $_FaceLandmarker = $face_landmarker.FaceLandmarker
Global Const $_FaceLandmarkerOptions = $face_landmarker.FaceLandmarkerOptions
Global Const $_RUNNING_MODE = $running_mode_module.VisionTaskRunningMode
Global Const $_ImageProcessingOptions = $image_processing_options_module.ImageProcessingOptions

Global Const $_FACE_LANDMARKER_BUNDLE_ASSET_FILE = 'face_landmarker_v2.task'
Global Const $_PORTRAIT_IMAGE = 'portrait.jpg'
Global Const $_CAT_IMAGE = 'cat.jpg'
Global Const $_PORTRAIT_EXPECTED_FACE_LANDMARKS = 'portrait_expected_face_landmarks.pbtxt'
Global Const $_PORTRAIT_EXPECTED_BLENDSHAPES = 'portrait_expected_blendshapes.pbtxt'
Global Const $_LANDMARKS_MARGIN = 0.03
Global Const $_BLENDSHAPES_MARGIN = 0.13
Global Const $_FACIAL_TRANSFORMATION_MATRIX_MARGIN = 0.02

Global Const $FILE_CONTENT = 1
Global Const $FILE_NAME = 2

Global $test_image
Global $model_path

Test()

Func Test()
	Local Const $_TEST_DATA_DIR = _Mediapipe_FindResourceDir() & "\mediapipe\tasks\testdata\vision"
	Local $url, $file_path

	Local $test_files[] = [ _
			$_FACE_LANDMARKER_BUNDLE_ASSET_FILE, _
			$_PORTRAIT_IMAGE, _
			$_CAT_IMAGE, _
			$_PORTRAIT_EXPECTED_FACE_LANDMARKS, _
			$_PORTRAIT_EXPECTED_BLENDSHAPES _
			]
	For $name In $test_files
		If IsArray($name) Then
			$url = $name[1]
			$name = $name[0]
		Else
			$url = "https://storage.googleapis.com/mediapipe-assets/" & $name
		EndIf
		If Not FileExists(get_test_data_path($name)) Then
			$file_path = $_TEST_DATA_DIR & "\" & $name
			$download_utils.download($url, $file_path)
		EndIf
	Next

	$test_image = $_Image.create_from_file(get_test_data_path($_PORTRAIT_IMAGE))
	$model_path = get_test_data_path($_FACE_LANDMARKER_BUNDLE_ASSET_FILE)

	test_create_from_file_succeeds_with_valid_model_path()
	test_create_from_options_succeeds_with_valid_model_path()
	test_create_from_options_succeeds_with_valid_model_content()

	test_detect( _
			$FILE_NAME, _
			$_FACE_LANDMARKER_BUNDLE_ASSET_FILE, _
			_get_expected_face_landmarks($_PORTRAIT_EXPECTED_FACE_LANDMARKS), _
			Default, _
			Default _
			)
	test_detect( _
			$FILE_CONTENT, _
			$_FACE_LANDMARKER_BUNDLE_ASSET_FILE, _
			_get_expected_face_landmarks($_PORTRAIT_EXPECTED_FACE_LANDMARKS), _
			Default, _
			Default _
			)

	test_empty_detection_outputs()

	test_detect_for_video( _
			$_FACE_LANDMARKER_BUNDLE_ASSET_FILE, _
			_get_expected_face_landmarks($_PORTRAIT_EXPECTED_FACE_LANDMARKS), _
			Default, _
			Default _
			)

EndFunc   ;==>Test

Func test_create_from_file_succeeds_with_valid_model_path()
	; Creates with default option and valid model file successfully.
	Local $landmarker = $_FaceLandmarker.create_from_model_path($model_path)
	_AssertIsInstance($landmarker, $_FaceLandmarker)
	$landmarker.close()
EndFunc   ;==>test_create_from_file_succeeds_with_valid_model_path

Func test_create_from_options_succeeds_with_valid_model_path()
	; Creates with options containing model file successfully.
	Local $base_options = $_BaseOptions(_Mediapipe_Params("model_asset_path", $model_path))
	Local $options = $_FaceLandmarkerOptions(_Mediapipe_Params("base_options", $base_options))
	Local $landmarker = $_FaceLandmarker.create_from_options($options)
	_AssertIsInstance($landmarker, $_FaceLandmarker)
	$landmarker.close()
EndFunc   ;==>test_create_from_options_succeeds_with_valid_model_path

Func test_create_from_options_succeeds_with_valid_model_content()
	; Creates with options containing model content successfully.
	Local $model_content = read_file_into_buffer($model_path)
	Local $base_options = $_BaseOptions(_Mediapipe_Params("model_asset_buffer", $model_content))
	Local $options = $_FaceLandmarkerOptions(_Mediapipe_Params("base_options", $base_options))
	Local $landmarker = $_FaceLandmarker.create_from_options($options)
	_AssertIsInstance($landmarker, $_FaceLandmarker)
	$landmarker.close()
EndFunc   ;==>test_create_from_options_succeeds_with_valid_model_content

Func test_detect( _
		$model_file_type, _
		$model_name, _
		$expected_face_landmarks, _
		$expected_face_blendshapes, _
		$expected_facial_transformation_matrixes _
		)
	Local $model_path = get_test_data_path($model_name)
	Local $base_options, $model_content

	; Creates face landmarker.
	If $model_file_type == $FILE_NAME Then
		$base_options = $_BaseOptions(_Mediapipe_Params("model_asset_path", $model_path))
	ElseIf $model_file_type == $FILE_CONTENT Then
		$model_content = read_file_into_buffer($model_path)
		$base_options = $_BaseOptions(_Mediapipe_Params("model_asset_buffer", $model_content))
	EndIf

	Local $options = $_FaceLandmarkerOptions(_Mediapipe_Params( _
			"base_options", $base_options, _
			"output_face_blendshapes", $expected_face_blendshapes <> Default, _
			"output_facial_transformation_matrixes", $expected_facial_transformation_matrixes <> Default _
			))
	Local $landmarker = $_FaceLandmarker.create_from_options($options)

	; Performs face landmarks detection on the input.
	Local $detection_result = $landmarker.detect($test_image)

	; Comparing results.
	If $expected_face_landmarks <> Default Then
		_expect_landmarks_correct($detection_result.face_landmarks, $expected_face_landmarks)
	EndIf

	If $expected_face_blendshapes <> Default Then
		_expect_blendshapes_correct($detection_result.face_blendshapes, $expected_face_blendshapes)
	EndIf

	If $expected_facial_transformation_matrixes <> Default Then
		_expect_facial_transformation_matrixes_correct($detection_result.facial_transformation_matrixes, $expected_facial_transformation_matrixes)
	EndIf

	; Closes the face landmarker explicitly when the face landmarker is not used in a context.
	$landmarker.close()
EndFunc   ;==>test_detect

Func test_empty_detection_outputs()
	Local $options = $_FaceLandmarkerOptions(_Mediapipe_Params( _
			"base_options", $_BaseOptions(_Mediapipe_Params("model_asset_path", $model_path)) _
			))

	Local $landmarker = $_FaceLandmarker.create_from_options($options)

	; Load the image with no faces.
	Local $no_faces_test_image = $_Image.create_from_file(get_test_data_path($_CAT_IMAGE))

	; Performs face landmarks detection on the input.
	Local $detection_result = $landmarker.detect($no_faces_test_image)

	_AssertEmpty($detection_result.face_landmarks)
	_AssertEmpty($detection_result.face_blendshapes)
	_AssertEmpty($detection_result.facial_transformation_matrixes)

	; Closes the face landmarker explicitly when the face landmarker is not used in a context.
	$landmarker.close()
EndFunc   ;==>test_empty_detection_outputs

Func test_detect_for_video( _
		$model_name, _
		$expected_face_landmarks, _
		$expected_face_blendshapes, _
		$expected_facial_transformation_matrixes _
		)
	; Creates face landmarker.
	Local $model_path = get_test_data_path($model_name)
	Local $base_options = $_BaseOptions(_Mediapipe_Params("model_asset_path", $model_path))

	Local $options = $_FaceLandmarkerOptions(_Mediapipe_Params( _
			"base_options", $base_options, _
			"running_mode", $_RUNNING_MODE.VIDEO, _
			"output_face_blendshapes", $expected_face_blendshapes <> Default, _
			"output_facial_transformation_matrixes", $expected_facial_transformation_matrixes <> Default _
			))


	Local $landmarker = $_FaceLandmarker.create_from_options($options)

	Local $detection_result
	For $timestamp = 0 To (300 - 30) Step 30
		; Performs face landmarks detection on the input.
		$detection_result = $landmarker.detect_for_video($test_image, $timestamp)

		; Comparing results.
		If $expected_face_landmarks <> Default Then
			_expect_landmarks_correct($detection_result.face_landmarks, $expected_face_landmarks)
		EndIf

		If $expected_face_blendshapes <> Default Then
			_expect_blendshapes_correct($detection_result.face_blendshapes, $expected_face_blendshapes)
		EndIf

		If $expected_facial_transformation_matrixes <> Default Then
			_expect_facial_transformation_matrixes_correct($detection_result.facial_transformation_matrixes, $expected_facial_transformation_matrixes)
		EndIf
	Next

	; Closes the face landmarker explicitly when the face landmarker is not used in a context.
	$landmarker.close()
EndFunc   ;==>test_detect_for_video

Func _get_expected_face_landmarks($file_path)
	Local $proto_file_path = get_test_data_path($file_path)
	Local $proto = $landmark_pb2.NormalizedLandmarkList.create()
	$text_format.Parse(FileRead($proto_file_path), $proto)

	Local $face_landmarks_results[1][$proto.landmark.size()]

	Local $i = 0
	For $landmark In $proto.landmark
		$face_landmarks_results[0][$i] = $_NormalizedLandmark.create_from_pb2($landmark)
		$i += 1
	Next

	Return $face_landmarks_results
EndFunc   ;==>_get_expected_face_landmarks

Func _get_expected_face_blendshapes($file_path)
	Local $proto_file_path = get_test_data_path($file_path)
	Local $proto = $classification_pb2.ClassificationList.create()
	$text_format.Parse(FileRead($proto_file_path), $proto)

	Local $face_blendshapes_results[1][$proto.classification.size()]

	Local $i = 0
	For $face_blendshapes In $proto.classification
		$face_blendshapes_results[0][$i] = $_Category.create_from_pb2($face_blendshapes)
		$i += 1
	Next

	Return $face_blendshapes_results
EndFunc   ;==>_get_expected_face_blendshapes

Func _get_expected_facial_transformation_matrixes()
	Local Static $Mat = _Mediapipe_ObjCreate("cv.Mat")

	Local $matrix[][] = [ _
			[0.9995292, -0.01294756, 0.038823195, -0.3691378], _
			[0.0072318087, 0.9937692, -0.1101321, 22.75809], _
			[-0.03715533, 0.11070588, 0.99315894, -65.765925], _
			[0, 0, 0, 1] _
			]

	$matrix = $Mat.createFromArray($matrix)

	Local $facial_transformation_matrixes_results[] = [$matrix]
	Return $facial_transformation_matrixes_results
EndFunc   ;==>_get_expected_facial_transformation_matrixes

Func _expect_landmarks_correct($actual_landmarks, $expected_landmarks)
	; Expects to have the same number of faces detected.
	_AssertLen($actual_landmarks, UBound($expected_landmarks))

	Local $i, $j

	$i = 0
	For $actual_landmark In $actual_landmarks
		$j = 0
		For $elem In $actual_landmark
			_AssertAlmostEqual($elem.x, $expected_landmarks[$i][$j].x, $_LANDMARKS_MARGIN)
			_AssertAlmostEqual($elem.y, $expected_landmarks[$i][$j].y, $_LANDMARKS_MARGIN)
			$j = $j + 1
		Next
		$i += 1
	Next
EndFunc   ;==>_expect_landmarks_correct

Func _expect_blendshapes_correct($actual_blendshapes, $expected_blendshapes)
	; Expects to have the same number of blendshapes.
	_AssertLen($actual_blendshapes, UBound($expected_blendshapes))

	Local $i, $j

	$i = 0
	For $actual_blendshape In $actual_blendshapes
		$j = 0
		For $elem In $actual_blendshape
			_AssertEqual($elem.index, $expected_blendshapes[$i][$j].index)
			_AssertEqual($elem.category_name, $expected_blendshapes[$i][$j].category_name)
			_AssertAlmostEqual( _
					$elem.score, _
					$expected_blendshapes[$i][$j].score, _
					$_BLENDSHAPES_MARGIN _
					)
			$j += 1
		Next
		$i += 1
	Next
EndFunc   ;==>_expect_blendshapes_correct

Func _expect_facial_transformation_matrixes_correct($actual_matrix_list, $expected_matrix_list)
	_AssertLen($actual_matrix_list, UBound($expected_matrix_list))

	Local $i = 0
	For $elem In $actual_matrix_list
		_AssertMatAlmostEqual($elem, $expected_matrix_list[$i], $_FACIAL_TRANSFORMATION_MATRIX_MARGIN)
		$i += 1
	Next
EndFunc   ;==>_expect_facial_transformation_matrixes_correct

Func _OnAutoItExit()
	_OpenCV_Close()
	_Mediapipe_Close()
EndFunc   ;==>_OnAutoItExit
