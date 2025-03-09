#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Change2CUI=y
#AutoIt3Wrapper_Au3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

;~ Sources:
;~     https://colab.research.google.com/github/google-ai-edge/mediapipe-samples/blob/8c1d61ad6eb12f1f98ed95c3c8b64cb9801f3230/examples/gesture_recognizer/python/gesture_recognizer.ipynb
;~     https://github.com/google-ai-edge/mediapipe-samples/blob/8c1d61ad6eb12f1f98ed95c3c8b64cb9801f3230/examples/gesture_recognizer/python/gesture_recognizer.ipynb

;~ Title: Gesture Recognizer with MediaPipe Tasks

#include "..\..\..\..\..\autoit-mediapipe-com\udf\mediapipe_udf_utils.au3"
#include "..\..\..\..\..\autoit-opencv-com\udf\opencv_udf_utils.au3"

_Mediapipe_Open(_Mediapipe_FindDLL("opencv_world4110*"), _Mediapipe_FindDLL("autoit_mediapipe_com-*-4110*"))
_OpenCV_Open(_OpenCV_FindDLL("opencv_world4110*"), _OpenCV_FindDLL("autoit_opencv_com4110*"))
OnAutoItExitRegister("_OnAutoItExit")

; Tell mediapipe where to look its resource files
_Mediapipe_SetResourceDir()

; Where to download data files
Global Const $MEDIAPIPE_SAMPLES_DATA_PATH = _Mediapipe_FindFile("examples\data")

Global $download_utils = _Mediapipe_ObjCreate("mediapipe.autoit.solutions.download_utils")
_AssertIsObj($download_utils, "Failed to load mediapipe.autoit.solutions.download_utils")

; STEP 1: Import the necessary modules.
Global $mp = _Mediapipe_get()
_AssertIsObj($mp, "Failed to load mediapipe")

Global $cv = _OpenCV_get()
_AssertIsObj($cv, "Failed to load opencv")

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
	Local $IMAGE_FILENAMES[] = ['thumbs_down.jpg', 'victory.jpg', 'thumbs_up.jpg', 'pointing_up.jpg']
	Local $_MODEL_FILE = $MEDIAPIPE_SAMPLES_DATA_PATH & "\gesture_recognizer.task"
	Local $_MODEL_URL = "https://storage.googleapis.com/mediapipe-models/gesture_recognizer/gesture_recognizer/float16/1/gesture_recognizer.task"

	Local $sample_files[UBound($IMAGE_FILENAMES) + 1]

	$sample_files[0] = _Mediapipe_Tuple($_MODEL_FILE, $_MODEL_URL)

	Local $url, $file_path, $name

	For $i = 0 To UBound($IMAGE_FILENAMES) - 1
		$name = $IMAGE_FILENAMES[$i]
		$file_path = $MEDIAPIPE_SAMPLES_DATA_PATH & "\" & $name
		$url = "https://storage.googleapis.com/mediapipe-tasks/gesture_recognizer/" & $name
		$sample_files[$i + 1] = _Mediapipe_Tuple($file_path, $url)
	Next

	For $config In $sample_files
		$file_path = $config[0]
		$url = $config[1]
		If Not FileExists($file_path) Then
			$download_utils.download($url, $file_path)
		EndIf
	Next

	; STEP 2: Create an GestureRecognizer object.
	Local $base_options = $autoit.BaseOptions(_Mediapipe_Params("model_asset_path", $_MODEL_FILE))
	Local $options = $vision.GestureRecognizerOptions(_Mediapipe_Params("base_options", $base_options))
	Local $recognizer = $vision.GestureRecognizer.create_from_options($options)

	Local $image, $recognition_result, $top_gesture, $hands_landmarks

	For $image_file_name In $IMAGE_FILENAMES
		; STEP 3: Load the input image.
		$image = $mp.Image.create_from_file($MEDIAPIPE_SAMPLES_DATA_PATH & "\" & $image_file_name)

		; STEP 4: Recognize gestures in the input image.
		$recognition_result = $recognizer.recognize($image)

		; STEP 5: Process the result. In this case, visualize it.
		$top_gesture = $recognition_result.gestures(0) (0)
		$hands_landmarks = $recognition_result.hand_landmarks
		display_image_with_gestures_and_hand_landmarks($image, $top_gesture, $hands_landmarks)
	Next

	$cv.waitKey()
EndFunc   ;==>Main

#cs
Displays an image with the gesture category and its score along with the hand landmarks.
#ce
Func display_image_with_gestures_and_hand_landmarks($image, $gesture, $hands_landmarks)
	; Display gestures and hand landmarks.
	Local $annotated_image = $cv.cvtColor($image.mat_view(), $CV_COLOR_RGB2BGR)
	Local $title = StringFormat("%s (%.2f)", $gesture.category_name, $gesture.score)

	; Compute the scale to make drawn elements visible when the image is resized for display
	Local $scale = 1 / resize_and_show($annotated_image, Default, False)

	Local $hand_landmarks_proto
	For $hand_landmarks In $hands_landmarks
		$hand_landmarks_proto = $landmark_pb2.NormalizedLandmarkList()

		For $landmark In $hand_landmarks
			$hand_landmarks_proto.landmark.append($landmark_pb2.NormalizedLandmark(_Mediapipe_Params("x", $landmark.x, "y", $landmark.y, "z", $landmark.z)))
		Next

		$mp_drawing.draw_landmarks( _
				$annotated_image, _
				$hand_landmarks_proto, _
				$mp_hands.HAND_CONNECTIONS, _
				$mp_drawing_styles.get_default_hand_landmarks_style($scale), _
				$mp_drawing_styles.get_default_hand_connections_style($scale))
	Next

	resize_and_show($annotated_image, $title)
EndFunc   ;==>display_image_with_gestures_and_hand_landmarks

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
