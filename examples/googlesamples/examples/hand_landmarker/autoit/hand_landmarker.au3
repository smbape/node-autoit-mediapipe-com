#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Change2CUI=y
#AutoIt3Wrapper_Au3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#include "..\..\..\..\..\autoit-mediapipe-com\udf\mediapipe_udf_utils.au3"
#include "..\..\..\..\..\autoit-opencv-com\udf\opencv_udf_utils.au3"
#include "..\..\..\..\..\test\_assert.au3"

;~ Sources:
;~     https://colab.research.google.com/github/googlesamples/mediapipe/blob/7d956461efb88e7601de5a4ae55d5a954b093589/examples/hand_landmarker/python/hand_landmarker.ipynb
;~     https://github.com/googlesamples/mediapipe/blob/7d956461efb88e7601de5a4ae55d5a954b093589/examples/hand_landmarker/python/hand_landmarker.ipynb

_Mediapipe_Open(_Mediapipe_FindDLL("opencv_world470*"), _Mediapipe_FindDLL("autoit_mediapipe_com-*-470*"))
_OpenCV_Open(_OpenCV_FindDLL("opencv_world470*"), _OpenCV_FindDLL("autoit_opencv_com470*"))
OnAutoItExitRegister("_OnAutoItExit")

_Mediapipe_SetResourceDir()

Global Const $MEDIAPIPE_SAMPLES_DATA_PATH = _OpenCV_FindFile("examples\data")

Global $download_utils = _Mediapipe_ObjCreate("mediapipe.autoit.solutions.download_utils")
_AssertIsObj($download_utils, "Failed to load mediapipe.autoit.solutions.download_utils")

; STEP 1: Import the necessary modules.
Global $mp = _Mediapipe_get()
_AssertIsObj($mp, "Failed to load mediapipe")

Global $cv = _OpenCV_get()
_AssertIsObj($mp, "Failed to load opencv")

Global $solutions = _Mediapipe_ObjCreate("mediapipe.solutions")
_AssertIsObj($solutions, "Failed to load mediapipe.solutions")

Global $landmark_pb2 = _Mediapipe_ObjCreate("mediapipe.framework.formats.landmark_pb2")
_AssertIsObj($landmark_pb2, "Failed to load mediapipe.framework.formats.landmark_pb2")

Global $autoit = _Mediapipe_ObjCreate("mediapipe.tasks.autoit")
_AssertIsObj($autoit, "Failed to load mediapipe.tasks.autoit")

Global $vision = _Mediapipe_ObjCreate("mediapipe.tasks.autoit.vision")
_AssertIsObj($vision, "Failed to load mediapipe.tasks.autoit.vision")

Global $mp_hands = $mp.solutions.hands
Global $mp_drawing = $mp.solutions.drawing_utils
Global $mp_drawing_styles = $mp.solutions.drawing_styles

Main()

Func Main()
	Local $IMAGE_FILE = $MEDIAPIPE_SAMPLES_DATA_PATH & "\woman_hands.jpg"
	Local $IMAGE_URL = "https://storage.googleapis.com/mediapipe-tasks/hand_landmarker/woman_hands.jpg"
	Local $MODEL_FILE = $MEDIAPIPE_SAMPLES_DATA_PATH & "\hand_landmarker.task"
	Local $MODEL_URL = "https://storage.googleapis.com/mediapipe-tasks/hand_landmarker/hand_landmarker.task"

	Local $url, $file_path

	Local $sample_files[] = [ _
			_Mediapipe_Tuple($IMAGE_FILE, $IMAGE_URL), _
			_Mediapipe_Tuple($MODEL_FILE, $MODEL_URL) _
			]
	For $config In $sample_files
		$file_path = $config[0]
		$url = $config[1]
		If Not FileExists($file_path) Then
			$download_utils.download($url, $file_path)
		EndIf
	Next

	; STEP 2: Create an ImageClassifier object.
	Local $base_options = $autoit.BaseOptions(_Mediapipe_Params("model_asset_path", $MODEL_FILE))
	Local $options = $vision.HandLandmarkerOptions(_Mediapipe_Params("base_options", $base_options, _
		                                       "num_hands", 2))
	Local $detector = $vision.HandLandmarker.create_from_options($options)

	; STEP 3: Load the input image.
	Local $image = $mp.Image.create_from_file($IMAGE_FILE)

	; STEP 4: Detect hand landmarks from the input image.
	Local $detection_result = $detector.detect($image)

	; STEP 5: Process the classification result. In this case, visualize it.
	Local $annotated_image = draw_landmarks_on_image($image.mat_view(), $detection_result)
	resize_and_show($cv.cvtColor($annotated_image, $CV_COLOR_RGB2BGR))
	$cv.waitKey()
EndFunc   ;==>Main

Func draw_landmarks_on_image($rgb_image, $detection_result)
	Local $scale = 1 / resize_and_show($rgb_image, Default, False)

	Local $MARGIN = 10 * $scale  ; pixels
	Local $FONT_SIZE = 1 * $scale
	Local $FONT_THICKNESS = 1 * $scale
	Local $HANDEDNESS_TEXT_COLOR = _OpenCV_Scalar(88, 205, 54) ; vibrant green

	Local $hand_landmarks_list = $detection_result.hand_landmarks
	Local $handedness_list = $detection_result.handedness
	Local $annotated_image = $rgb_image.copy()
	Local $width = $annotated_image.width
	Local $height = $annotated_image.height

	Local $hand_landmarks, $handedness, $hand_landmarks_proto
	Local $min_x, $min_y, $text_x, $text_y

	; Loop through the detected hands to visualize.
	For $idx = 0 To $hand_landmarks_list.size() - 1
		$hand_landmarks = $hand_landmarks_list($idx)
		$handedness = $handedness_list($idx)
		$min_x = 1
		$min_y = 1

		; Draw the hand landmarks.
		$hand_landmarks_proto = $landmark_pb2.NormalizedLandmarkList()
		For $landmark In $hand_landmarks
			$hand_landmarks_proto.landmark.append($landmark_pb2.NormalizedLandmark(_Mediapipe_Params("x", $landmark.x, "y", $landmark.y, "z", $landmark.z)))
			If $landmark.x < $min_x Then $min_x = $landmark.x
			If $landmark.y < $min_y Then $min_y = $landmark.y
		Next

		$solutions.drawing_utils.draw_landmarks( _
				$annotated_image, _
				$hand_landmarks_proto, _
				$solutions.hands.HAND_CONNECTIONS, _
				$solutions.drawing_styles.get_default_hand_landmarks_style($scale), _
				$solutions.drawing_styles.get_default_hand_connections_style($scale))

		; Get the top left corner of the detected hand's bounding box.
		$text_x = $min_x * $width
		$text_y = $min_y * $height - $MARGIN

		; Draw handedness (left or right hand) on the image.
		$cv.putText($annotated_image, $handedness[0].category_name, _
				_OpenCV_Point($text_x, $text_y), $CV_FONT_HERSHEY_DUPLEX, _
				$FONT_SIZE, $HANDEDNESS_TEXT_COLOR, $FONT_THICKNESS, $CV_LINE_AA)
	Next

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
