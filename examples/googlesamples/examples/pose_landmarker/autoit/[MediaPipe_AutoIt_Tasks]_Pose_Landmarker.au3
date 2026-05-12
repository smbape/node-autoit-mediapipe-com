#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Change2CUI=y
#AutoIt3Wrapper_Au3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

;~ Sources:
;~     https://colab.research.google.com/github/google-ai-edge/mediapipe-samples/blob/3d23f0e459907af064c3e7494dbb180851e1694c/examples/pose_landmarker/python/%5BMediaPipe_Python_Tasks%5D_Pose_Landmarker.ipynb
;~     https://github.com/google-ai-edge/mediapipe-samples/blob/3d23f0e459907af064c3e7494dbb180851e1694c/examples/pose_landmarker/python/%5BMediaPipe_Python_Tasks%5D_Pose_Landmarker.ipynb

;~ Title: Pose Landmarks Detection with MediaPipe Tasks

#include "..\..\..\..\..\autoit-mediapipe-com\udf\mediapipe_udf_utils.au3"
#include "..\..\..\..\..\autoit-opencv-com\udf\opencv_udf_utils.au3"

_Mediapipe_Open(_Mediapipe_FindDLL("opencv_world4130*"), _Mediapipe_FindDLL("autoit_mediapipe_com-*-4130*"))
_OpenCV_Open(_OpenCV_FindDLL("opencv_world4130*"), _OpenCV_FindDLL("autoit_opencv_com4130*"))
OnAutoItExitRegister("_OnAutoItExit")

; Where to download data files
Global Const $MEDIAPIPE_SAMPLES_DATA_PATH = _Mediapipe_FindFile("examples\data")

; STEP 1: Import the necessary modules.
Global $mp = _Mediapipe_get()
_AssertIsObj($mp, "Failed to load mediapipe")

Global $cv = _OpenCV_get()
_AssertIsObj($cv, "Failed to load opencv")

Global $download_utils = _Mediapipe_ObjCreate("mediapipe.tasks.autoit.core.download_utils")
_AssertIsObj($download_utils, "Failed to load mediapipe.tasks.autoit.core.download_utils")

Global $autoit = _Mediapipe_ObjCreate("mediapipe.tasks.autoit")
_AssertIsObj($autoit, "Failed to load mediapipe.tasks.autoit")

Global $drawing_utils = _Mediapipe_ObjCreate("mediapipe.tasks.autoit.vision.drawing_utils")
_AssertIsObj($drawing_utils, "Failed to load mediapipe.tasks.autoit.vision.drawing_utils")

Global $drawing_styles = _Mediapipe_ObjCreate("mediapipe.tasks.autoit.vision.drawing_styles")
_AssertIsObj($drawing_styles, "Failed to load mediapipe.tasks.autoit.vision.drawing_styles")

Global $vision = _Mediapipe_ObjCreate("mediapipe.tasks.autoit.vision")
_AssertIsObj($vision, "Failed to load mediapipe.tasks.autoit.vision")

Main()

Func Main()
	Local $_IMAGE_FILE = $MEDIAPIPE_SAMPLES_DATA_PATH & "\girl-4051811_960_720.jpg"
	Local $_IMAGE_URL = "https://cdn.pixabay.com/photo/2019/03/12/20/39/girl-4051811_960_720.jpg"
	Local $_MODEL_FILE = $MEDIAPIPE_SAMPLES_DATA_PATH & "\pose_landmarker_heavy.task"
	Local $_MODEL_URL = "https://storage.googleapis.com/mediapipe-models/pose_landmarker/pose_landmarker_heavy/float16/1/pose_landmarker_heavy.task"

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

	; STEP 2: Create a PoseLandmarker object.
	Local $base_options = $autoit.BaseOptions(_Mediapipe_Params("model_asset_path", $_MODEL_FILE))
	Local $options = $vision.PoseLandmarkerOptions(_Mediapipe_Params( _
			"base_options", $base_options, _
			"output_segmentation_masks", True))
	Local $detector = $vision.PoseLandmarker.create_from_options($options)

	; STEP 3: Load the input image.
	Local $image = $mp.Image.create_from_file($_IMAGE_FILE)

	; STEP 4: Detect pose landmarks from the input image.
	Local $detection_result = $detector.detect($image)

	; STEP 5: Process the detection result. In this case, visualize it.
	Local $annotated_image = draw_landmarks_on_image($image.mat_view(), $detection_result)

	; Display the image
	resize_and_show($annotated_image, "Pose Landmarks Detection with MediaPipe Tasks : Image")

	; Visualize the pose segmentation mask.
	Local $segmentation_mask = $detection_result.segmentation_masks(0).mat_view()
	resize_and_show($segmentation_mask, "Pose Landmarks Detection with MediaPipe Tasks : Mask")

	$cv.waitKey()
EndFunc   ;==>Main

Func draw_landmarks_on_image($rgb_image, $detection_result)
	; Compute the scale to make drawn elements visible when the image is resized for display
	Local $scale = 1 / resize_and_show($rgb_image, Default, False)

	Local $pose_landmarks_list = $detection_result.pose_landmarks
	Local $annotated_image = $cv.cvtColor($rgb_image, $CV_COLOR_RGB2BGR)
	Local $pose_landmark_style = $drawing_styles.get_default_pose_landmarks_style($scale)
	Local $pose_connection_style = $drawing_utils.DrawingSpec(_Mediapipe_Params("color", _Mediapipe_Tuple(0, 255, 0), "thickness", 2))

	; Loop through the detected poses to visualize.
	For $pose_landmarks In $pose_landmarks_list

		; Draw the pose landmarks.
		$drawing_utils.draw_landmarks(_Mediapipe_Params( _
				"image", $annotated_image, _
				"landmark_list", $pose_landmarks, _
				"connections", $vision.PoseLandmarksConnections.POSE_LANDMARKS, _
				"landmark_drawing_spec", $pose_landmark_style, _
				"connection_drawing_spec", $pose_connection_style))
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
