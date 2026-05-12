#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Change2CUI=y
#AutoIt3Wrapper_Au3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

;~ Sources:
;~     https://colab.research.google.com/github/google-ai-edge/mediapipe-samples/blob/3d23f0e459907af064c3e7494dbb180851e1694c/examples/face_landmarker/python/%5BMediaPipe_Python_Tasks%5D_Face_Landmarker.ipynb
;~     https://github.com/google-ai-edge/mediapipe-samples/blob/3d23f0e459907af064c3e7494dbb180851e1694c/examples/face_landmarker/python/%5BMediaPipe_Python_Tasks%5D_Face_Landmarker.ipynb

;~ Title: Face Landmarks Detection with MediaPipe Tasks

#include "..\..\..\..\..\autoit-mediapipe-com\udf\mediapipe_udf_utils.au3"
#include "..\..\..\..\..\autoit-opencv-com\udf\opencv_udf_utils.au3"

_Mediapipe_Open(_Mediapipe_FindDLL("opencv_world4130*"), _Mediapipe_FindDLL("autoit_mediapipe_com-*-4130*"))
_OpenCV_Open(_OpenCV_FindDLL("opencv_world4130*"), _OpenCV_FindDLL("autoit_opencv_com4130*"))
OnAutoItExitRegister("_OnAutoItExit")

; Where to download data files
Global Const $MEDIAPIPE_SAMPLES_DATA_PATH = _Mediapipe_FindFile("examples\data")

; STEP 1: Import the necessary modules.
Global $download_utils = _Mediapipe_ObjCreate("mediapipe.tasks.autoit.core.download_utils")
_AssertIsObj($download_utils, "Failed to load mediapipe.tasks.autoit.core.download_utils")

Global $mp = _Mediapipe_get()
_AssertIsObj($mp, "Failed to load mediapipe")

Global $autoit = _Mediapipe_ObjCreate("mediapipe.tasks.autoit")
_AssertIsObj($autoit, "Failed to load mediapipe.tasks.autoit")

Global $vision = _Mediapipe_ObjCreate("mediapipe.tasks.autoit.vision")
_AssertIsObj($vision, "Failed to load mediapipe.tasks.autoit.vision")

Global $drawing_utils = _Mediapipe_ObjCreate("mediapipe.tasks.autoit.vision.drawing_utils")
_AssertIsObj($drawing_utils, "Failed to load mediapipe.tasks.autoit.vision.drawing_utils")

Global $drawing_styles = _Mediapipe_ObjCreate("mediapipe.tasks.autoit.vision.drawing_styles")
_AssertIsObj($drawing_styles, "Failed to load mediapipe.tasks.autoit.vision.drawing_styles")

Global $cv = _OpenCV_get()
_AssertIsObj($cv, "Failed to load opencv")

Main()

Func Main()
	Local $_IMAGE_FILE = $MEDIAPIPE_SAMPLES_DATA_PATH & "\business-person.png"
	Local $_IMAGE_URL = "https://storage.googleapis.com/mediapipe-assets/business-person.png"
	Local $_MODEL_FILE = $MEDIAPIPE_SAMPLES_DATA_PATH & "\face_landmarker.task"
	Local $_MODEL_URL = "https://storage.googleapis.com/mediapipe-models/face_landmarker/face_landmarker/float16/1/face_landmarker.task"

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

	; STEP 2: Create a FaceLandmarker object.
	Local $base_options = $autoit.BaseOptions(_Mediapipe_Params("model_asset_path", $_MODEL_FILE))
	Local $options = $vision.FaceLandmarkerOptions(_Mediapipe_Params("base_options", $base_options, _
			"output_face_blendshapes", True, _
			"output_facial_transformation_matrixes", True, _
			"num_faces", 1))
	Local $detector = $vision.FaceLandmarker.create_from_options($options)

	; STEP 3: Load the input image.
	Local $image = $mp.Image.create_from_file($_IMAGE_FILE)

	; STEP 4: Detect hand landmarks from the input image.
	Local $detection_result = $detector.detect($image)

	; STEP 5: Process the classification result. In this case, visualize it.
	Local $annotated_image = draw_landmarks_on_image($image.mat_view(), $detection_result)
	resize_and_show($annotated_image)
	$cv.waitKey()
EndFunc   ;==>Main

Func draw_landmarks_on_image($image, $detection_result)
	; Compute the scale to make drawn elements visible when the image is resized for display
	Local $scale = 1 / resize_and_show($image, Default, False)

	Local $face_landmarks_list = $detection_result.face_landmarks
	Local $annotated_image = $cv.cvtColor($image, $CV_COLOR_RGB2BGR)

	; Loop through the detected faces to visualize.
	For $face_landmarks In $face_landmarks_list

		; Draw the face landmarks.

		$drawing_utils.draw_landmarks(_Mediapipe_Params( _
				"image", $annotated_image, _
				"landmark_list", $face_landmarks, _
				"connections", $vision.FaceLandmarksConnections.FACE_LANDMARKS_TESSELATION, _
				"landmark_drawing_spec", Null, _
				"connection_drawing_spec", $drawing_styles.get_default_face_mesh_tesselation_style($scale)))
		$drawing_utils.draw_landmarks(_Mediapipe_Params( _
				"image", $annotated_image, _
				"landmark_list", $face_landmarks, _
				"connections", $vision.FaceLandmarksConnections.FACE_LANDMARKS_CONTOURS, _
				"landmark_drawing_spec", Null, _
				"connection_drawing_spec", $drawing_styles.get_default_face_mesh_contours_style(1, $scale)))
		$drawing_utils.draw_landmarks(_Mediapipe_Params( _
				"image", $annotated_image, _
				"landmark_list", $face_landmarks, _
				"connections", $vision.FaceLandmarksConnections.FACE_LANDMARKS_LEFT_IRIS, _
				"landmark_drawing_spec", Null, _
				"connection_drawing_spec", $drawing_styles.get_default_face_mesh_iris_connections_style($scale)))
		$drawing_utils.draw_landmarks(_Mediapipe_Params( _
				"image", $annotated_image, _
				"landmark_list", $face_landmarks, _
				"connections", $vision.FaceLandmarksConnections.FACE_LANDMARKS_RIGHT_IRIS, _
				"landmark_drawing_spec", Null, _
				"connection_drawing_spec", $drawing_styles.get_default_face_mesh_iris_connections_style($scale)))
	Next

	Return $annotated_image
EndFunc   ;==>draw_landmarks_on_image

Func resize_and_show($image, $title = Default, $show = Default)
	If $title == Default Then $title = ""
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
