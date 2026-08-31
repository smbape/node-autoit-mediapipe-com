#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Change2CUI=y
#AutoIt3Wrapper_Au3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

;~ Sources:
;~     https://colab.research.google.com/github/google-ai-edge/mediapipe-samples/blob/7f3cf17410db91f8e084a46f7517df15bce3479a/examples/holistic_landmarker/python/[MediaPipe_Python_Tasks]_Holistic_Landmarker.ipynb
;~     https://github.com/google-ai-edge/mediapipe-samples/blob/7f3cf17410db91f8e084a46f7517df15bce3479a/examples/holistic_landmarker/python/[MediaPipe_Python_Tasks]_Holistic_Landmarker.ipynb

;~ Title: Holistic Landmarks Detection with MediaPipe Tasks

#include "..\..\..\..\..\autoit-mediapipe-com\udf\mediapipe_udf_utils.au3"
#include "..\..\..\..\..\autoit-opencv-com\udf\opencv_udf_utils.au3"

_Mediapipe_Open(_Mediapipe_FindDLL("opencv_world500*"), _Mediapipe_FindDLL("autoit_mediapipe_com-1.0.0-500*"))
_OpenCV_Open(_OpenCV_FindDLL("opencv_world500*"), _OpenCV_FindDLL("autoit_opencv_com500*"))
OnAutoItExitRegister("_OnAutoItExit")

; Where to download data files
Global Const $MEDIAPIPE_SAMPLES_DATA_PATH = _Mediapipe_FindFile("examples\data")

Global $download_utils = _Mediapipe_ObjCreate("mediapipe.tasks.autoit.core.download_utils")
_AssertIsObj($download_utils, "Failed to load mediapipe.tasks.autoit.core.download_utils")

; STEP 1: Import the necessary modules.
Global $mp = _Mediapipe_get()
_AssertIsObj($mp, "Failed to load mediapipe")

Global $cv = _OpenCV_get()
_AssertIsObj($cv, "Failed to load opencv")

Global $autoit = _Mediapipe_ObjCreate("mediapipe.tasks.autoit")
_AssertIsObj($autoit, "Failed to load mediapipe.tasks.autoit")

Global $vision = _Mediapipe_ObjCreate("mediapipe.tasks.autoit.vision")
_AssertIsObj($vision, "Failed to load mediapipe.tasks.autoit.vision")

Global $drawing_utils = _Mediapipe_ObjCreate("mediapipe.tasks.autoit.vision.drawing_utils")
_AssertIsObj($drawing_utils, "Failed to load mediapipe.tasks.autoit.vision.drawing_utils")

Global $drawing_styles = _Mediapipe_ObjCreate("mediapipe.tasks.autoit.vision.drawing_styles")
_AssertIsObj($drawing_styles, "Failed to load mediapipe.tasks.autoit.vision.drawing_styles")


Main()

Func Main()
	Local $_IMAGE_FILE = $MEDIAPIPE_SAMPLES_DATA_PATH & "\business-person.png"
	Local $_IMAGE_URL = "https://storage.googleapis.com/mediapipe-assets/business-person.png"
	Local $_MODEL_FILE = $MEDIAPIPE_SAMPLES_DATA_PATH & "\holistic_landmarker.task"
	Local $_MODEL_URL = "https://storage.googleapis.com/mediapipe-models/holistic_landmarker/holistic_landmarker/float16/1/holistic_landmarker.task"

	Local $url, $file_path

	Local $sample_files[] = [ _
			_Mediapipe_Tuple($_IMAGE_FILE, $_IMAGE_URL), _
			_Mediapipe_Tuple($_MODEL_FILE, $_MODEL_URL) _
			]
	For $config In $sample_files
		$file_path = $config[0]
		$url = $config[1]
		If Not FileExists($file_path) Then
			$download_utils.download($url, $file_path)
		EndIf
	Next

	; STEP 2: Create an HolisticLandmarker object.
	Local $base_options = $autoit.BaseOptions(_Mediapipe_Params("model_asset_path", $_MODEL_FILE))
	Local $options = $vision.HolisticLandmarkerOptions(_Mediapipe_Params( _
			"base_options", $base_options, _
			"output_face_blendshapes", True, _
			"output_segmentation_mask", True))
	Local $detector = $vision.HolisticLandmarker.create_from_options($options)

	; STEP 3: Load the input image.
	Local $image = $mp.Image.create_from_file($_IMAGE_FILE)

	; STEP 4: Detect holistic landmarks from the input image.
	Local $detection_result = $detector.detect($image)

	; STEP 5: Process the detection result. In this case, visualize it.
	Local $annotated_image = draw_landmarks_on_image($image.mat_view(), $detection_result)
	resize_and_show($annotated_image, "holistic_landmarker")
	$cv.waitKey()
EndFunc   ;==>Main

Func draw_landmarks_on_image($rgb_image, $detection_result)
	; Compute the scale to make drawn elements visible when the image is resized for display
	Local $scale = 1 / resize_and_show($rgb_image, Default, False)


	Local $pose_landmarks = $detection_result.pose_landmarks
	Local $face_landmarks = $detection_result.face_landmarks
	Local $left_hand_landmarks = $detection_result.left_hand_landmarks
	Local $right_hand_landmarks = $detection_result.right_hand_landmarks
	Local $annotated_image = $cv.cvtColor($rgb_image, $CV_COLOR_RGB2BGR)

	; Draw pose landmarks.
	Local $pose_landmark_style, $pose_connection_style
	If $pose_landmarks.size() <> 0 Then
		$pose_landmark_style = $drawing_styles.get_default_pose_landmarks_style($scale)
		$pose_connection_style = $drawing_utils.DrawingSpec(_Mediapipe_Params("color", _OpenCV_Scalar(0, 255, 0), "thickness", 2 * $scale))
		$drawing_utils.draw_landmarks(_Mediapipe_Params( _
				"image", $annotated_image, _
				"landmark_list", $pose_landmarks, _
				"connections", $vision.PoseLandmarksConnections.POSE_LANDMARKS, _
				"landmark_drawing_spec", $pose_landmark_style, _
				"connection_drawing_spec", $pose_connection_style))
	EndIf

	; Draw face landmarks.
	If $face_landmarks.size() <> 0 Then
		$drawing_utils.draw_landmarks(_Mediapipe_Params( _
				"image", $annotated_image, _
				"landmark_list", $face_landmarks, _
				"connections", $vision.FaceLandmarksConnections.FACE_LANDMARKS_TESSELATION, _
				"landmark_drawing_spec", Null, _
				"connection_drawing_spec", $drawing_styles.get_default_face_mesh_tesselation_style(_Mediapipe_Params("scale", $scale))))
		$drawing_utils.draw_landmarks(_Mediapipe_Params( _
				"image", $annotated_image, _
				"landmark_list", $face_landmarks, _
				"connections", $vision.FaceLandmarksConnections.FACE_LANDMARKS_CONTOURS, _
				"landmark_drawing_spec", Null, _
				"connection_drawing_spec", $drawing_styles.get_default_face_mesh_contours_style(_Mediapipe_Params("scale", $scale))))
		$drawing_utils.draw_landmarks(_Mediapipe_Params( _
				"image", $annotated_image, _
				"landmark_list", $face_landmarks, _
				"connections", $vision.FaceLandmarksConnections.FACE_LANDMARKS_LEFT_IRIS, _
				"landmark_drawing_spec", Null, _
				"connection_drawing_spec", $drawing_styles.get_default_face_mesh_iris_connections_style(_Mediapipe_Params("scale", $scale))))
		$drawing_utils.draw_landmarks(_Mediapipe_Params( _
				"image", $annotated_image, _
				"landmark_list", $face_landmarks, _
				"connections", $vision.FaceLandmarksConnections.FACE_LANDMARKS_RIGHT_IRIS, _
				"landmark_drawing_spec", Null, _
				"connection_drawing_spec", $drawing_styles.get_default_face_mesh_iris_connections_style(_Mediapipe_Params("scale", $scale))))
	EndIf

	; Draw hand landmarks.
	If $left_hand_landmarks.size() <> 0 Then
		$drawing_utils.draw_landmarks(_Mediapipe_Params( _
				"image", $annotated_image, _
				"landmark_list", $left_hand_landmarks, _
				"connections", $vision.HandLandmarksConnections.HAND_CONNECTIONS, _
				"landmark_drawing_spec", $drawing_styles.get_default_hand_landmarks_style(_Mediapipe_Params("scale", $scale)), _
				"connection_drawing_spec", $drawing_styles.get_default_hand_connections_style(_Mediapipe_Params("scale", $scale))))
	EndIf

	If $right_hand_landmarks.size() <> 0 Then
		$drawing_utils.draw_landmarks(_Mediapipe_Params( _
				"image", $annotated_image, _
				"landmark_list", $right_hand_landmarks, _
				"connections", $vision.HandLandmarksConnections.HAND_CONNECTIONS, _
				"landmark_drawing_spec", $drawing_styles.get_default_hand_landmarks_style(_Mediapipe_Params("scale", $scale)), _
				"connection_drawing_spec", $drawing_styles.get_default_hand_connections_style(_Mediapipe_Params("scale", $scale))))
	EndIf

	Return $annotated_image
EndFunc   ;==>draw_landmarks_on_image

Func resize_and_show($image, $title = Default, $show = Default)
	If $title == Default Then $title = "image"
	If $show == Default Then $show = True

	Local Const $DESIRED_HEIGHT = 480
	Local Const $DESIRED_WIDTH = 480
	Local $w = $image.width
	Local $h = $image.height

	If $h < $w Then
		$h = $h / ($w / $DESIRED_WIDTH)
		$w = $DESIRED_WIDTH
	Else
		$w = $w / ($h / $DESIRED_HEIGHT)
		$h = $DESIRED_HEIGHT
	EndIf

	Local $interpolation = ($DESIRED_WIDTH > $image.width Or $DESIRED_HEIGHT > $image.height) ? $CV_INTER_CUBIC : $CV_INTER_AREA

	If $show Then
		Local $img = $cv.resize($image, _OpenCV_Size($w, $h), _OpenCV_Params("interpolation", $interpolation))
		$cv.imshow($title, $img.convertToShow())
	EndIf

	Return $w / $image.width
EndFunc   ;==>resize_and_show

Func _OnAutoItExit()
	_OpenCV_Close()
	_Mediapipe_Close()
EndFunc   ;==>_OnAutoItExit

Func _AssertIsObj($vVal, $sMsg)
	If Not IsObj($vVal) Then
		ConsoleWriteError($sMsg & @CRLF)
		Exit 0x7FFFFFFF
	EndIf
EndFunc   ;==>_AssertIsObj
