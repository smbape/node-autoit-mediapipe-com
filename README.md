# Mediapipe autoit udf

Partial COM+ binding to [mediapipe](https://github.com/google-ai-edge/mediapipe)

> [!WARNING]
> From the maintainers of mediapipe:
> [I doubt there is any plan there to evolve the python API, the project focus has shifted long ago. Choose your steps wisely](https://github.com/google-ai-edge/mediapipe/issues/5457#issuecomment-2896920046)
> In other words, do not rely too much on mediaipe python.
> And since this library is base on [mediapipe python](https://pypi.org/project/mediapipe/), well, `choose your steps wisely`

## Table Of Contents

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [Installation](#installation)
- [Usage](#usage)
  - [AutoIt](#autoit)
    - [Face Detection with MediaPipe Tasks](#face-detection-with-mediapipe-tasks)
    - [Face Landmarks Detection with MediaPipe Tasks](#face-landmarks-detection-with-mediapipe-tasks)
    - [Face Stylizer](#face-stylizer)
    - [Gesture Recognizer with MediaPipe Tasks](#gesture-recognizer-with-mediapipe-tasks)
    - [Hand Landmarks Detection with MediaPipe Tasks](#hand-landmarks-detection-with-mediapipe-tasks)
    - [Image Classifier with MediaPipe Tasks](#image-classifier-with-mediapipe-tasks)
    - [Image Embedding with MediaPipe Tasks](#image-embedding-with-mediapipe-tasks)
    - [Image Segmenter](#image-segmenter)
    - [Interactive Image Segmenter](#interactive-image-segmenter)
    - [Language Detector with MediaPipe Tasks](#language-detector-with-mediapipe-tasks)
    - [Object Detection with MediaPipe Tasks](#object-detection-with-mediapipe-tasks)
    - [Pose Landmarks Detection with MediaPipe Tasks](#pose-landmarks-detection-with-mediapipe-tasks)
    - [Text Classifier with MediaPipe Tasks](#text-classifier-with-mediapipe-tasks)
    - [Text Embedding with MediaPipe Tasks](#text-embedding-with-mediapipe-tasks)
  - [PowerShell](#powershell)
  - [csharp](#csharp)
    - [Runtime example](#runtime-example)
    - [Compile time example](#compile-time-example)
- [Running examples](#running-examples)
- [Developpement](#developpement)
  - [Prerequisites](#prerequisites)
  - [Environment](#environment)
  - [Generate the UDF files](#generate-the-udf-files)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## Installation

  - Download and extract [opencv-4.11.0-windows.exe](https://opencv.org/releases/) into a folder
  - Download and extract [autoit-opencv-4.11.0-com-v2.7.0.7z](https://github.com/smbape/node-autoit-opencv-com/releases/download/v2.7.0/autoit-opencv-4.11.0-com-v2.7.0.7z) into a folder
  - Download and extract [autoit-mediapipe-0.10.24-opencv-4.11.0-com-v0.4.1.7z](https://github.com/smbape/node-autoit-mediapipe-com/releases/download/v0.4.1/autoit-mediapipe-0.10.24-opencv-4.11.0-com-v0.4.1.7z) into a folder

## Usage

### AutoIt

<!-- EXAMPLES_START generated examples please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN node scripts/update-readme.js TO UPDATE -->

#### Face Detection with MediaPipe Tasks

```autoit
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Change2CUI=y
#AutoIt3Wrapper_Au3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

;~ Sources:
;~     https://colab.research.google.com/github/google-ai-edge/mediapipe-samples/blob/8c1d61ad6eb12f1f98ed95c3c8b64cb9801f3230/examples/face_detector/python/face_detector.ipynb
;~     https://github.com/google-ai-edge/mediapipe-samples/blob/8c1d61ad6eb12f1f98ed95c3c8b64cb9801f3230/examples/face_detector/python/face_detector.ipynb

;~ Title: Face Detection with MediaPipe Tasks

#include "autoit-mediapipe-com\udf\mediapipe_udf_utils.au3"
#include "autoit-opencv-com\udf\opencv_udf_utils.au3"

_Mediapipe_Open("opencv-4.11.0-windows\opencv\build\x64\vc16\bin\opencv_world4110.dll", "autoit-mediapipe-com\autoit_mediapipe_com-0.10.24-4110.dll")
_OpenCV_Open("opencv-4.11.0-windows\opencv\build\x64\vc16\bin\opencv_world4110.dll", "autoit-opencv-com\autoit_opencv_com4110.dll")
OnAutoItExitRegister("_OnAutoItExit")

; Tell mediapipe where to look its resource files
_Mediapipe_SetResourceDir()

; Where to download data files
Global Const $MEDIAPIPE_SAMPLES_DATA_PATH = @ScriptDir & "\examples\data"

; STEP 1: Import the necessary modules.
Global $download_utils = _Mediapipe_ObjCreate("mediapipe.autoit.solutions.download_utils")
_AssertIsObj($download_utils, "Failed to load mediapipe.autoit.solutions.download_utils")

Global $mp = _Mediapipe_get()
_AssertIsObj($mp, "Failed to load mediapipe")

Global $cv = _OpenCV_get()
_AssertIsObj($cv, "Failed to load opencv")

Global $autoit = _Mediapipe_ObjCreate("mediapipe.tasks.autoit")
_AssertIsObj($autoit, "Failed to load mediapipe.tasks.autoit")

Global $vision = _Mediapipe_ObjCreate("mediapipe.tasks.autoit.vision")
_AssertIsObj($vision, "Failed to load mediapipe.tasks.autoit.vision")

Main()

Func Main()
	Local $_IMAGE_FILE = $MEDIAPIPE_SAMPLES_DATA_PATH & "\brother-sister-girl-family-boy-977170.jpg"
	Local $_IMAGE_URL = "https://i.imgur.com/Vu2Nqwb.jpg"
	Local $_MODEL_FILE = $MEDIAPIPE_SAMPLES_DATA_PATH & "\blaze_face_short_range.tflite"
	Local $_MODEL_URL = "https://storage.googleapis.com/mediapipe-models/face_detector/blaze_face_short_range/float16/1/blaze_face_short_range.tflite"

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

	; STEP 2: Create an FaceDetector object.
	Local $base_options = $autoit.BaseOptions(_Mediapipe_Params("model_asset_path", $_MODEL_FILE))
	Local $options = $vision.FaceDetectorOptions(_Mediapipe_Params("base_options", $base_options))
	Local $detector = $vision.FaceDetector.create_from_options($options)

	; STEP 3: Load the input image.
	Local $image = $mp.Image.create_from_file($_IMAGE_FILE)

	; Compute the scale to make drawn elements visible when the image is resized for display
	Local $scale = 1 / resize_and_show($image, Default, False)

	; STEP 4: Detect faces in the input image.
	Local $detection_result = $detector.detect($image)

	; STEP 5: Process the detection result. In this case, visualize it.
	Local $image_copy = $image.mat_view()
	Local $annotated_image = visualize($image_copy, $detection_result, $scale)
	Local $bgr_annotated_image = $cv.cvtColor($annotated_image, $CV_COLOR_RGB2BGR)
	resize_and_show($bgr_annotated_image, "face_detector")
	$cv.waitKey()
EndFunc   ;==>Main

Func isclose($a, $b)
	Return Abs($a - $b) <= 1E-6
EndFunc   ;==>isclose

; Checks if the float value is between 0 and 1.
Func is_valid_normalized_value($value)
	Return $value >= 0 And $value <= 1 Or isclose(0, $value) Or isclose(1, $value)
EndFunc   ;==>is_valid_normalized_value

#cs
Converts normalized value pair to pixel coordinates.
#ce
Func _normalized_to_pixel_coordinates($normalized_x, $normalized_y, $image_width, $image_height)
	If Not (is_valid_normalized_value($normalized_x) And is_valid_normalized_value($normalized_y)) Then
		; TODO: Draw coordinates even if it's outside of the image bounds.
		Return Default
	EndIf

	Local $x_px = _Min(Floor($normalized_x * $image_width), $image_width - 1)
	Local $y_px = _Min(Floor($normalized_y * $image_height), $image_height - 1)
	Return _OpenCV_Point($x_px, $y_px)
EndFunc   ;==>_normalized_to_pixel_coordinates

#cs
Draws bounding boxes and keypoints on the input image and return it.
Args:
	image: The input RGB image.
	detection_result: The list of all "Detection" entities to be visualize.
Returns:
	Image with bounding boxes.
#ce
Func visualize($image, $detection_result, $scale = 1.0)
	Local $MARGIN = 10 * $scale ; pixels
	Local $ROW_SIZE = 10 ; pixels
	Local $FONT_SIZE = $scale
	Local $FONT_THICKNESS = 2 * $scale
	Local $TEXT_COLOR = _OpenCV_Scalar(255, 0, 0)  ; red

	Local $bbox_thickness = 3 * $scale

	Local $keypoint_color = _OpenCV_Scalar(0, 255, 0)
	Local $keypoint_thickness = 2 * $scale
	Local $keypoint_radius = 2 * $scale

	Local $annotated_image = $image.copy()
	Local $width = $image.width
	Local $height = $image.height

	Local $bbox, $start_point, $end_point, $keypoint_px

	Local $category, $category_name, $probability, $result_text, $text_location

	For $detection In $detection_result.detections
		; Draw bounding_box
		$bbox = $detection.bounding_box
		$start_point = _OpenCV_Point($bbox.origin_x, $bbox.origin_y)
		$end_point = _OpenCV_Point($bbox.origin_x + $bbox.width, $bbox.origin_y + $bbox.height)
		$cv.rectangle($annotated_image, $start_point, $end_point, $TEXT_COLOR, $bbox_thickness)

		; Draw keypoints
		For $keypoint In $detection.keypoints
			$keypoint_px = _normalized_to_pixel_coordinates($keypoint.x, $keypoint.y, $width, $height)
			$cv.circle($annotated_image, $keypoint_px, $keypoint_thickness, $keypoint_color, $keypoint_radius)
		Next

		; Draw label and score
		$category = $detection.categories(0)
		$category_name = $category.category_name
		$probability = Round($category.score, 2)
		$result_text = $category_name & ' (' & $probability & ')'
		$text_location = _OpenCV_Point($MARGIN + $bbox.origin_x, $MARGIN + $ROW_SIZE + $bbox.origin_y)
		$cv.putText($annotated_image, $result_text, $text_location, $CV_FONT_HERSHEY_PLAIN, $FONT_SIZE, $TEXT_COLOR, $FONT_THICKNESS)
	Next

	Return $annotated_image
EndFunc   ;==>visualize

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

```

#### Face Landmarks Detection with MediaPipe Tasks

```autoit
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Change2CUI=y
#AutoIt3Wrapper_Au3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

;~ Sources:
;~     https://colab.research.google.com/github/google-ai-edge/mediapipe-samples/blob/8c1d61ad6eb12f1f98ed95c3c8b64cb9801f3230/examples/face_landmarker/python/%5BMediaPipe_Python_Tasks%5D_Face_Landmarker.ipynb
;~     https://github.com/google-ai-edge/mediapipe-samples/blob/8c1d61ad6eb12f1f98ed95c3c8b64cb9801f3230/examples/face_landmarker/python/%5BMediaPipe_Python_Tasks%5D_Face_Landmarker.ipynb

;~ Title: Face Landmarks Detection with MediaPipe Tasks

#include "autoit-mediapipe-com\udf\mediapipe_udf_utils.au3"
#include "autoit-opencv-com\udf\opencv_udf_utils.au3"

_Mediapipe_Open("opencv-4.11.0-windows\opencv\build\x64\vc16\bin\opencv_world4110.dll", "autoit-mediapipe-com\autoit_mediapipe_com-0.10.24-4110.dll")
_OpenCV_Open("opencv-4.11.0-windows\opencv\build\x64\vc16\bin\opencv_world4110.dll", "autoit-opencv-com\autoit_opencv_com4110.dll")
OnAutoItExitRegister("_OnAutoItExit")

; Tell mediapipe where to look its resource files
_Mediapipe_SetResourceDir()

; Where to download data files
Global Const $MEDIAPIPE_SAMPLES_DATA_PATH = @ScriptDir & "\examples\data"

; STEP 1: Import the necessary modules.
Global $download_utils = _Mediapipe_ObjCreate("mediapipe.autoit.solutions.download_utils")
_AssertIsObj($download_utils, "Failed to load mediapipe.autoit.solutions.download_utils")

Global $solutions = _Mediapipe_ObjCreate("mediapipe.solutions")
_AssertIsObj($solutions, "Failed to load mediapipe.solutions")

Global $landmark_pb2 = _Mediapipe_ObjCreate("mediapipe.framework.formats.landmark_pb2")
_AssertIsObj($landmark_pb2, "Failed to load mediapipe.framework.formats.landmark_pb2")

Global $autoit = _Mediapipe_ObjCreate("mediapipe.tasks.autoit")
_AssertIsObj($autoit, "Failed to load mediapipe.tasks.autoit")

Global $vision = _Mediapipe_ObjCreate("mediapipe.tasks.autoit.vision")
_AssertIsObj($vision, "Failed to load mediapipe.tasks.autoit.vision")

Global $mp = _Mediapipe_get()
_AssertIsObj($mp, "Failed to load mediapipe")

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

	; STEP 2: Create an FaceLandmarker object.
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
	Local $annotated_image = draw_landmarks_on_image($cv.cvtColor($image.mat_view(), $CV_COLOR_RGB2BGR), $detection_result)
	resize_and_show($annotated_image)
	$cv.waitKey()
EndFunc   ;==>Main

Func draw_landmarks_on_image($rgb_image, $detection_result)
	; Compute the scale to make drawn elements visible when the image is resized for display
	Local $scale = 1 / resize_and_show($rgb_image, Default, False)

	Local $face_landmarks_list = $detection_result.face_landmarks
	Local $annotated_image = $rgb_image.copy()

	Local $face_landmarks_proto

	; Loop through the detected faces to visualize.
	For $face_landmarks In $face_landmarks_list

		; Draw the face landmarks.
		$face_landmarks_proto = $landmark_pb2.NormalizedLandmarkList()

		For $landmark In $face_landmarks
			$face_landmarks_proto.landmark.append($landmark_pb2.NormalizedLandmark(_Mediapipe_Params("x", $landmark.x, "y", $landmark.y, "z", $landmark.z)))
		Next

		$solutions.drawing_utils.draw_landmarks(_Mediapipe_Params( _
				"image", $annotated_image, _
				"landmark_list", $face_landmarks_proto, _
				"connections", $solutions.face_mesh.FACEMESH_TESSELATION, _
				"landmark_drawing_spec", Null, _
				"connection_drawing_spec", $solutions.drawing_styles.get_default_face_mesh_tesselation_style($scale)))
		$solutions.drawing_utils.draw_landmarks(_Mediapipe_Params( _
				"image", $annotated_image, _
				"landmark_list", $face_landmarks_proto, _
				"connections", $solutions.face_mesh.FACEMESH_CONTOURS, _
				"landmark_drawing_spec", Null, _
				"connection_drawing_spec", $solutions.drawing_styles.get_default_face_mesh_contours_style(1, $scale)))
		$solutions.drawing_utils.draw_landmarks(_Mediapipe_Params( _
				"image", $annotated_image, _
				"landmark_list", $face_landmarks_proto, _
				"connections", $solutions.face_mesh.FACEMESH_IRISES, _
				"landmark_drawing_spec", Null, _
				"connection_drawing_spec", $solutions.drawing_styles.get_default_face_mesh_iris_connections_style($scale)))
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

```

#### Face Stylizer

```autoit
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Change2CUI=y
#AutoIt3Wrapper_Au3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

;~ Sources:
;~     https://colab.research.google.com/github/google-ai-edge/mediapipe-samples/blob/8c1d61ad6eb12f1f98ed95c3c8b64cb9801f3230/examples/face_stylizer/python/face_stylizer.ipynb
;~     https://github.com/google-ai-edge/mediapipe-samples/blob/8c1d61ad6eb12f1f98ed95c3c8b64cb9801f3230/examples/face_stylizer/python/face_stylizer.ipynb

;~ Title: Face Stylizer

#include "autoit-mediapipe-com\udf\mediapipe_udf_utils.au3"
#include "autoit-opencv-com\udf\opencv_udf_utils.au3"

_Mediapipe_Open("opencv-4.11.0-windows\opencv\build\x64\vc16\bin\opencv_world4110.dll", "autoit-mediapipe-com\autoit_mediapipe_com-0.10.24-4110.dll")
_OpenCV_Open("opencv-4.11.0-windows\opencv\build\x64\vc16\bin\opencv_world4110.dll", "autoit-opencv-com\autoit_opencv_com4110.dll")
OnAutoItExitRegister("_OnAutoItExit")

; Tell mediapipe where to look its resource files
_Mediapipe_SetResourceDir()

; Where to download data files
Global Const $MEDIAPIPE_SAMPLES_DATA_PATH = @ScriptDir & "\examples\data"

; STEP 1: Import the necessary modules.
Global $download_utils = _Mediapipe_ObjCreate("mediapipe.autoit.solutions.download_utils")
_AssertIsObj($download_utils, "Failed to load mediapipe.autoit.solutions.download_utils")

Global $autoit = _Mediapipe_ObjCreate("mediapipe.tasks.autoit")
_AssertIsObj($autoit, "Failed to load mediapipe.tasks.autoit")

Global $vision = _Mediapipe_ObjCreate("mediapipe.tasks.autoit.vision")
_AssertIsObj($vision, "Failed to load mediapipe.tasks.autoit.vision")

Global $mp = _Mediapipe_get()
_AssertIsObj($mp, "Failed to load mediapipe")

Global $cv = _OpenCV_get()
_AssertIsObj($cv, "Failed to load opencv")

Main()

Func Main()
	Local $_IMAGE_FILE = $MEDIAPIPE_SAMPLES_DATA_PATH & "\business-person.png"
	Local $_IMAGE_URL = "https://storage.googleapis.com/mediapipe-assets/business-person.png"
	Local $_MODEL_FILE = $MEDIAPIPE_SAMPLES_DATA_PATH & "\face_stylizer_color_sketch.task"
	Local $_MODEL_URL = "https://storage.googleapis.com/mediapipe-models/face_stylizer/blaze_face_stylizer/float32/latest/face_stylizer_color_sketch.task"

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

	; Preview the images.
	resize_and_show($cv.imread($_IMAGE_FILE), "face_stylizer: preview")

	; STEP 2: Create an FaceLandmarker object.
	Local $base_options = $autoit.BaseOptions(_Mediapipe_Params("model_asset_path", $_MODEL_FILE))
	Local $options = $vision.FaceStylizerOptions(_Mediapipe_Params("base_options", $base_options))
	Local $stylizer = $vision.FaceStylizer.create_from_options($options)

	; STEP 3: Load the input image.
	Local $image = $mp.Image.create_from_file($_IMAGE_FILE)

	; STEP 4: Retrieve the stylized image
	Local $stylized_image = $stylizer.stylize($image)

	; STEP 5: Show the stylized image
	Local $rgb_stylized_image = $cv.cvtColor($stylized_image.mat_view(), $CV_COLOR_RGB2BGR)
	resize_and_show($rgb_stylized_image, "face_stylizer: stylized")
	$cv.waitKey()
EndFunc   ;==>Main

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

```

#### Gesture Recognizer with MediaPipe Tasks

```autoit
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

#include "autoit-mediapipe-com\udf\mediapipe_udf_utils.au3"
#include "autoit-opencv-com\udf\opencv_udf_utils.au3"

_Mediapipe_Open("opencv-4.11.0-windows\opencv\build\x64\vc16\bin\opencv_world4110.dll", "autoit-mediapipe-com\autoit_mediapipe_com-0.10.24-4110.dll")
_OpenCV_Open("opencv-4.11.0-windows\opencv\build\x64\vc16\bin\opencv_world4110.dll", "autoit-opencv-com\autoit_opencv_com4110.dll")
OnAutoItExitRegister("_OnAutoItExit")

; Tell mediapipe where to look its resource files
_Mediapipe_SetResourceDir()

; Where to download data files
Global Const $MEDIAPIPE_SAMPLES_DATA_PATH = @ScriptDir & "\examples\data"

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

```

#### Hand Landmarks Detection with MediaPipe Tasks

```autoit
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Change2CUI=y
#AutoIt3Wrapper_Au3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

;~ Sources:
;~     https://colab.research.google.com/github/google-ai-edge/mediapipe-samples/blob/8c1d61ad6eb12f1f98ed95c3c8b64cb9801f3230/examples/hand_landmarker/python/hand_landmarker.ipynb
;~     https://github.com/google-ai-edge/mediapipe-samples/blob/8c1d61ad6eb12f1f98ed95c3c8b64cb9801f3230/examples/hand_landmarker/python/hand_landmarker.ipynb

;~ Title: Hand Landmarks Detection with MediaPipe Tasks

#include "autoit-mediapipe-com\udf\mediapipe_udf_utils.au3"
#include "autoit-opencv-com\udf\opencv_udf_utils.au3"

_Mediapipe_Open("opencv-4.11.0-windows\opencv\build\x64\vc16\bin\opencv_world4110.dll", "autoit-mediapipe-com\autoit_mediapipe_com-0.10.24-4110.dll")
_OpenCV_Open("opencv-4.11.0-windows\opencv\build\x64\vc16\bin\opencv_world4110.dll", "autoit-opencv-com\autoit_opencv_com4110.dll")
OnAutoItExitRegister("_OnAutoItExit")

; Tell mediapipe where to look its resource files
_Mediapipe_SetResourceDir()

; Where to download data files
Global Const $MEDIAPIPE_SAMPLES_DATA_PATH = @ScriptDir & "\examples\data"

Global $download_utils = _Mediapipe_ObjCreate("mediapipe.autoit.solutions.download_utils")
_AssertIsObj($download_utils, "Failed to load mediapipe.autoit.solutions.download_utils")

; STEP 1: Import the necessary modules.
Global $mp = _Mediapipe_get()
_AssertIsObj($mp, "Failed to load mediapipe")

Global $cv = _OpenCV_get()
_AssertIsObj($cv, "Failed to load opencv")

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
	Local $_IMAGE_FILE = $MEDIAPIPE_SAMPLES_DATA_PATH & "\woman_hands.jpg"
	Local $_IMAGE_URL = "https://storage.googleapis.com/mediapipe-tasks/hand_landmarker/woman_hands.jpg"
	Local $_MODEL_FILE = $MEDIAPIPE_SAMPLES_DATA_PATH & "\hand_landmarker.task"
	Local $_MODEL_URL = "https://storage.googleapis.com/mediapipe-models/hand_landmarker/hand_landmarker/float16/1/hand_landmarker.task"

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

	; STEP 2: Create an ImageClassifier object.
	Local $base_options = $autoit.BaseOptions(_Mediapipe_Params("model_asset_path", $_MODEL_FILE))
	Local $options = $vision.HandLandmarkerOptions(_Mediapipe_Params("base_options", $base_options, _
			"num_hands", 2))
	Local $detector = $vision.HandLandmarker.create_from_options($options)

	; STEP 3: Load the input image.
	Local $image = $mp.Image.create_from_file($_IMAGE_FILE)

	; STEP 4: Detect hand landmarks from the input image.
	Local $detection_result = $detector.detect($image)

	; STEP 5: Process the classification result. In this case, visualize it.
	Local $annotated_image = draw_landmarks_on_image($cv.cvtColor($image.mat_view(), $CV_COLOR_RGB2BGR), $detection_result)
	resize_and_show($annotated_image, "hand_landmarker")
	$cv.waitKey()
EndFunc   ;==>Main

Func draw_landmarks_on_image($rgb_image, $detection_result)
	; Compute the scale to make drawn elements visible when the image is resized for display
	Local $scale = 1 / resize_and_show($rgb_image, Default, False)

	Local $MARGIN = 10 * $scale  ; pixels
	Local $FONT_SIZE = $scale
	Local $FONT_THICKNESS = 2 * $scale
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
		$cv.putText($annotated_image, $handedness(0).category_name, _
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

Func _AssertIsObj($vVal, $sMsg)
	If Not IsObj($vVal) Then
		ConsoleWriteError($sMsg & @CRLF)
		Exit 0x7FFFFFFF
	EndIf
EndFunc   ;==>_AssertIsObj

```

#### Image Classifier with MediaPipe Tasks

```autoit
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Change2CUI=y
#AutoIt3Wrapper_Au3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

;~ Sources:
;~     https://colab.research.google.com/github/google-ai-edge/mediapipe-samples/blob/8c1d61ad6eb12f1f98ed95c3c8b64cb9801f3230/examples/image_classification/python/image_classifier.ipynb
;~     https://github.com/google-ai-edge/mediapipe-samples/blob/8c1d61ad6eb12f1f98ed95c3c8b64cb9801f3230/examples/image_classification/python/image_classifier.ipynb

;~ Title: Image Classifier with MediaPipe Tasks

#include "autoit-mediapipe-com\udf\mediapipe_udf_utils.au3"
#include "autoit-opencv-com\udf\opencv_udf_utils.au3"

_Mediapipe_Open("opencv-4.11.0-windows\opencv\build\x64\vc16\bin\opencv_world4110.dll", "autoit-mediapipe-com\autoit_mediapipe_com-0.10.24-4110.dll")
_OpenCV_Open("opencv-4.11.0-windows\opencv\build\x64\vc16\bin\opencv_world4110.dll", "autoit-opencv-com\autoit_opencv_com4110.dll")
OnAutoItExitRegister("_OnAutoItExit")

; Tell mediapipe where to look its resource files
_Mediapipe_SetResourceDir()

; Where to download data files
Global Const $MEDIAPIPE_SAMPLES_DATA_PATH = @ScriptDir & "\examples\data"

Global $download_utils = _Mediapipe_ObjCreate("mediapipe.autoit.solutions.download_utils")
_AssertIsObj($download_utils, "Failed to load mediapipe.autoit.solutions.download_utils")

; STEP 1: Import the necessary modules.
Global $mp = _Mediapipe_get()
_AssertIsObj($mp, "Failed to load mediapipe")

Global $cv = _OpenCV_get()
_AssertIsObj($cv, "Failed to load opencv")

Global $autoit = _Mediapipe_ObjCreate("mediapipe.tasks.autoit")
_AssertIsObj($autoit, "Failed to load mediapipe.tasks.autoit")

Global $vision = _Mediapipe_ObjCreate("mediapipe.tasks.autoit.vision")
_AssertIsObj($vision, "Failed to load mediapipe.tasks.autoit.vision")

Main()

Func Main()
	Local $IMAGE_FILENAMES[] = ['burger.jpg', 'cat.jpg']

	Local $url, $file_path

	For $name In $IMAGE_FILENAMES
		$file_path = $MEDIAPIPE_SAMPLES_DATA_PATH & "\" & $name
		$url = "https://storage.googleapis.com/mediapipe-tasks/image_classifier/" & $name
		If Not FileExists($file_path) Then
			$download_utils.download($url, $file_path)
		EndIf
	Next

	Local $_MODEL_FILE = $MEDIAPIPE_SAMPLES_DATA_PATH & "\efficientnet_lite0.tflite"
	If Not FileExists($_MODEL_FILE) Then
		$download_utils.download("https://storage.googleapis.com/mediapipe-models/image_classifier/efficientnet_lite0/float32/1/efficientnet_lite0.tflite", $_MODEL_FILE)
	EndIf

	; STEP 2: Create an ImageClassifier object.
	Local $base_options = $autoit.BaseOptions(_Mediapipe_Params("model_asset_path", $_MODEL_FILE))
	Local $options = $vision.ImageClassifierOptions(_Mediapipe_Params("base_options", $base_options, "max_results", 4))
	Local $classifier = $vision.ImageClassifier.create_from_options($options)
	Local $image, $classification_result, $top_category, $title

	For $image_name In $IMAGE_FILENAMES
		; STEP 3: Load the input image.
		$image = $mp.Image.create_from_file($MEDIAPIPE_SAMPLES_DATA_PATH & "\" & $image_name)

		; STEP 4: Classify the input image.
		$classification_result = $classifier.classify($image)

		; STEP 5: Process the classification result. In this case, visualize it.
		$top_category = $classification_result.classifications(0).categories(0)
		$title = StringFormat("%s (%.2f)", $top_category.category_name, $top_category.score)
		resize_and_show($cv.cvtColor($image.mat_view(), $CV_COLOR_RGB2BGR), $title)
	Next

	$cv.waitKey()
EndFunc   ;==>Main

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

```

#### Image Embedding with MediaPipe Tasks

```autoit
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Change2CUI=y
#AutoIt3Wrapper_Au3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

;~ Sources:
;~     https://colab.research.google.com/github/google-ai-edge/mediapipe-samples/blob/8c1d61ad6eb12f1f98ed95c3c8b64cb9801f3230/examples/image_embedder/python/image_embedder.ipynb
;~     https://github.com/google-ai-edge/mediapipe-samples/blob/8c1d61ad6eb12f1f98ed95c3c8b64cb9801f3230/examples/image_embedder/python/image_embedder.ipynb

;~ Title: Image Embedding with MediaPipe Tasks

#include "autoit-mediapipe-com\udf\mediapipe_udf_utils.au3"
#include "autoit-opencv-com\udf\opencv_udf_utils.au3"

_Mediapipe_Open("opencv-4.11.0-windows\opencv\build\x64\vc16\bin\opencv_world4110.dll", "autoit-mediapipe-com\autoit_mediapipe_com-0.10.24-4110.dll")
_OpenCV_Open("opencv-4.11.0-windows\opencv\build\x64\vc16\bin\opencv_world4110.dll", "autoit-opencv-com\autoit_opencv_com4110.dll")
OnAutoItExitRegister("_OnAutoItExit")

; Tell mediapipe where to look its resource files
_Mediapipe_SetResourceDir()

; Where to download data files
Global Const $MEDIAPIPE_SAMPLES_DATA_PATH = @ScriptDir & "\examples\data"

Global $download_utils = _Mediapipe_ObjCreate("mediapipe.autoit.solutions.download_utils")
_AssertIsObj($download_utils, "Failed to load mediapipe.autoit.solutions.download_utils")

; STEP 1: Import the necessary modules.
Global $mp = _Mediapipe_get()
_AssertIsObj($mp, "Failed to load mediapipe")

Global $cv = _OpenCV_get()
_AssertIsObj($cv, "Failed to load opencv")

Global $autoit = _Mediapipe_ObjCreate("mediapipe.tasks.autoit")
_AssertIsObj($autoit, "Failed to load mediapipe.tasks.autoit")

Global $vision = _Mediapipe_ObjCreate("mediapipe.tasks.autoit.vision")
_AssertIsObj($vision, "Failed to load mediapipe.tasks.autoit.vision")

Global $cosine_similarity = _Mediapipe_ObjCreate("mediapipe.tasks.autoit.components.utils.cosine_similarity")
_AssertIsObj($cosine_similarity, "Failed to load mediapipe.tasks.autoit.components.utils.cosine_similarity")

Main()

Func Main()
	Local $IMAGE_FILENAMES[] = ['burger.jpg', 'burger_crop.jpg']

	Local $url, $file_path

	For $name In $IMAGE_FILENAMES
		$file_path = $MEDIAPIPE_SAMPLES_DATA_PATH & "\" & $name
		$url = "https://storage.googleapis.com/mediapipe-assets/" & $name
		If Not FileExists($file_path) Then
			$download_utils.download($url, $file_path)
		EndIf
	Next

	Local $_MODEL_FILE = $MEDIAPIPE_SAMPLES_DATA_PATH & "\mobilenet_v3_small.tflite"
	If Not FileExists($_MODEL_FILE) Then
		$download_utils.download("https://storage.googleapis.com/mediapipe-models/image_embedder/mobilenet_v3_small/float32/1/mobilenet_v3_small.tflite", $_MODEL_FILE)
	EndIf

	; Create options for Image Embedder
	Local $base_options = $autoit.BaseOptions(_Mediapipe_Params("model_asset_path", $_MODEL_FILE))
	Local $l2_normalize = True ;@param {type:"boolean"}
	Local $quantize = True ;@param {type:"boolean"}
	Local $options = $vision.ImageEmbedderOptions(_Mediapipe_Params( _
			"base_options", $base_options, _
			"l2_normalize", $l2_normalize, _
			"quantize", $quantize))

	; Create Image Embedder
	Local $embedder = $vision.ImageEmbedder.create_from_options($options)

	; Format images for MediaPipe
	Local $first_image = $mp.Image.create_from_file($MEDIAPIPE_SAMPLES_DATA_PATH & "\" & $IMAGE_FILENAMES[0])
	Local $second_image = $mp.Image.create_from_file($MEDIAPIPE_SAMPLES_DATA_PATH & "\" & $IMAGE_FILENAMES[1])
	Local $first_embedding_result = $embedder.embed($first_image)
	Local $second_embedding_result = $embedder.embed($second_image)

	Local $similarity = $cosine_similarity.cosine_similarity($first_embedding_result.embeddings(0), $second_embedding_result.embeddings(0))
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $similarity = ' & $similarity & @CRLF) ;### Debug Console

	resize_and_show($cv.cvtColor($first_image.mat_view(), $CV_COLOR_RGB2BGR), $IMAGE_FILENAMES[0])
	resize_and_show($cv.cvtColor($second_image.mat_view(), $CV_COLOR_RGB2BGR), $IMAGE_FILENAMES[1])
	$cv.waitKey()
EndFunc   ;==>Main

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

```

#### Image Segmenter

```autoit
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Change2CUI=y
#AutoIt3Wrapper_Au3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

;~ Sources:
;~     https://colab.research.google.com/github/google-ai-edge/mediapipe-samples/blob/8c1d61ad6eb12f1f98ed95c3c8b64cb9801f3230/examples/image_segmentation/python/image_segmentation.ipynb
;~     https://github.com/google-ai-edge/mediapipe-samples/blob/8c1d61ad6eb12f1f98ed95c3c8b64cb9801f3230/examples/image_segmentation/python/image_segmentation.ipynb

;~ Title: Image Segmenter

#include "autoit-mediapipe-com\udf\mediapipe_udf_utils.au3"
#include "autoit-opencv-com\udf\opencv_udf_utils.au3"

_Mediapipe_Open("opencv-4.11.0-windows\opencv\build\x64\vc16\bin\opencv_world4110.dll", "autoit-mediapipe-com\autoit_mediapipe_com-0.10.24-4110.dll")
_OpenCV_Open("opencv-4.11.0-windows\opencv\build\x64\vc16\bin\opencv_world4110.dll", "autoit-opencv-com\autoit_opencv_com4110.dll")
OnAutoItExitRegister("_OnAutoItExit")

; Tell mediapipe where to look its resource files
_Mediapipe_SetResourceDir()

; Where to download data files
Global Const $MEDIAPIPE_SAMPLES_DATA_PATH = @ScriptDir & "\examples\data"

Global $download_utils = _Mediapipe_ObjCreate("mediapipe.autoit.solutions.download_utils")
_AssertIsObj($download_utils, "Failed to load mediapipe.autoit.solutions.download_utils")

; STEP 1: Import the necessary modules.
Global $mp = _Mediapipe_get()
_AssertIsObj($mp, "Failed to load mediapipe")

Global $cv = _OpenCV_get()
_AssertIsObj($cv, "Failed to load opencv")

Global $autoit = _Mediapipe_ObjCreate("mediapipe.tasks.autoit")
_AssertIsObj($autoit, "Failed to load mediapipe.tasks.autoit")

Global $vision = _Mediapipe_ObjCreate("mediapipe.tasks.autoit.vision")
_AssertIsObj($vision, "Failed to load mediapipe.tasks.autoit.vision")

Main()

Func Main()
	Local $IMAGE_FILENAMES[] = ['segmentation_input_rotation0.jpg']

	Local $url, $file_path

	For $name In $IMAGE_FILENAMES
		$file_path = $MEDIAPIPE_SAMPLES_DATA_PATH & "\" & $name
		$url = "https://storage.googleapis.com/mediapipe-assets/" & $name
		If Not FileExists($file_path) Then
			$download_utils.download($url, $file_path)
		EndIf
	Next

	Local $_MODEL_FILE = $MEDIAPIPE_SAMPLES_DATA_PATH & "\deeplab_v3.tflite"
	If Not FileExists($_MODEL_FILE) Then
		$download_utils.download("https://storage.googleapis.com/mediapipe-models/image_segmenter/deeplab_v3/float32/1/deeplab_v3.tflite", $_MODEL_FILE)
	EndIf

	Local $BG_COLOR = _OpenCV_Scalar(192, 192, 192) ; gray
	Local $FG_COLOR = _OpenCV_Scalar(255, 255, 255) ; white

	; Create the options that will be used for ImageSegmenter
	Local $base_options = $autoit.BaseOptions(_Mediapipe_Params("model_asset_path", $_MODEL_FILE))
	Local $options = $vision.ImageSegmenterOptions(_Mediapipe_Params("base_options", $base_options, _
			"output_category_mask", True))

	; Create the image segmenter
	Local $segmenter = $vision.ImageSegmenter.create_from_options($options)

	Local $image, $segmentation_result, $category_mask, $image_data
	Local $fg_image, $bg_image, $fg_mask
	Local $output_image, $blurred_image

	; Loop through demo image(s)
	For $image_file_name In $IMAGE_FILENAMES
		; Create the MediaPipe image file that will be segmented
		$image = $mp.Image.create_from_file($MEDIAPIPE_SAMPLES_DATA_PATH & "\" & $image_file_name)

		; Retrieve the masks for the segmented image
		$segmentation_result = $segmenter.segment($image)
		$category_mask = $segmentation_result.category_mask

		; mediapipe uses RGB images while opencv uses BGR images
		$image_data = $cv.cvtColor($image.mat_view(), $CV_COLOR_RGB2BGR)

		; Generate solid color images for showing the output segmentation mask.
		$fg_image = $cv.Mat.create($image_data.size(), $CV_8UC3, $FG_COLOR)
		$bg_image = $cv.Mat.create($image_data.size(), $CV_8UC3, $BG_COLOR)

		; The foreground mask corresponds to all 'i' pixels where category_mask[i] > 0.2
		$fg_mask = $cv.compare($category_mask.mat_view(), 0.2, $CV_CMP_GT)

		; Draw fg_image on bg_image only where fg_mask should apply
		$output_image = $bg_image.copy()
		$fg_image.copyTo($fg_mask, $output_image)
		resize_and_show($output_image, 'Segmentation mask of ' & $image_file_name)

		; Blur the image only where fg_mask should not apply
		$blurred_image = $cv.GaussianBlur($image_data, _OpenCV_Size(55, 55), 0)
		$image_data.copyTo($fg_mask, $blurred_image)
		resize_and_show($blurred_image, 'Blurred background of ' & $image_file_name)
	Next

	$cv.waitKey()
EndFunc   ;==>Main

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

```

#### Interactive Image Segmenter

```autoit
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Change2CUI=y
#AutoIt3Wrapper_Au3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

;~ Sources:
;~     https://colab.research.google.com/github/google-ai-edge/mediapipe-samples/blob/8c1d61ad6eb12f1f98ed95c3c8b64cb9801f3230/examples/interactive_segmentation/python/interactive_segmenter.ipynb
;~     https://github.com/google-ai-edge/mediapipe-samples/blob/8c1d61ad6eb12f1f98ed95c3c8b64cb9801f3230/examples/interactive_segmentation/python/interactive_segmenter.ipynb

;~ Title: Interactive Image Segmenter

#include "autoit-mediapipe-com\udf\mediapipe_udf_utils.au3"
#include "autoit-opencv-com\udf\opencv_udf_utils.au3"

_Mediapipe_Open("opencv-4.11.0-windows\opencv\build\x64\vc16\bin\opencv_world4110.dll", "autoit-mediapipe-com\autoit_mediapipe_com-0.10.24-4110.dll")
_OpenCV_Open("opencv-4.11.0-windows\opencv\build\x64\vc16\bin\opencv_world4110.dll", "autoit-opencv-com\autoit_opencv_com4110.dll")
OnAutoItExitRegister("_OnAutoItExit")

; Tell mediapipe where to look its resource files
_Mediapipe_SetResourceDir()

; Where to download data files
Global Const $MEDIAPIPE_SAMPLES_DATA_PATH = @ScriptDir & "\examples\data"

Global $download_utils = _Mediapipe_ObjCreate("mediapipe.autoit.solutions.download_utils")
_AssertIsObj($download_utils, "Failed to load mediapipe.autoit.solutions.download_utils")

; STEP 1: Import the necessary modules.
Global $mp = _Mediapipe_get()
_AssertIsObj($mp, "Failed to load mediapipe")

Global $cv = _OpenCV_get()
_AssertIsObj($cv, "Failed to load opencv")

Global $autoit = _Mediapipe_ObjCreate("mediapipe.tasks.autoit")
_AssertIsObj($autoit, "Failed to load mediapipe.tasks.autoit")

Global $vision = _Mediapipe_ObjCreate("mediapipe.tasks.autoit.vision")
_AssertIsObj($vision, "Failed to load mediapipe.tasks.autoit.vision")

Global $containers = _Mediapipe_ObjCreate("mediapipe.tasks.autoit.components.containers")
_AssertIsObj($containers, "Failed to load mediapipe.tasks.autoit.components.containers")

Main()

Func Main()
	Local $IMAGE_FILENAMES[] = ['cats_and_dogs.jpg']

	Local $url, $file_path

	For $name In $IMAGE_FILENAMES
		$file_path = $MEDIAPIPE_SAMPLES_DATA_PATH & "\" & $name
		$url = "https://storage.googleapis.com/mediapipe-assets/" & $name
		If Not FileExists($file_path) Then
			$download_utils.download($url, $file_path)
		EndIf
	Next

	Local $_MODEL_FILE = $MEDIAPIPE_SAMPLES_DATA_PATH & "\magic_touch.tflite"
	If Not FileExists($_MODEL_FILE) Then
		$download_utils.download("https://storage.googleapis.com/mediapipe-models/interactive_segmenter/magic_touch/float32/1/magic_touch.tflite", $_MODEL_FILE)
	EndIf

	Local $x = 0.68 ;@param {type:"slider", min:0, max:1, step:0.01}
	Local $y = 0.68 ;@param {type:"slider", min:0, max:1, step:0.01}

	Local $BG_COLOR = _OpenCV_Scalar(192, 192, 192) ; gray
	Local $FG_COLOR = _OpenCV_Scalar(255, 255, 255) ; white
	Local $OVERLAY_COLOR = _OpenCV_Scalar(100, 100, 0) ; cyan

	Local $RegionOfInterest_Format = $vision.InteractiveSegmenterRegionOfInterest_Format
	Local $RegionOfInterest = $vision.InteractiveSegmenterRegionOfInterest
	Local $NormalizedKeypoint = $containers.keypoint.NormalizedKeypoint

	; Create the options that will be used for InteractiveSegmenter
	Local $base_options = $autoit.BaseOptions(_Mediapipe_Params("model_asset_path", $_MODEL_FILE))
	Local $options = $vision.InteractiveSegmenterOptions(_Mediapipe_Params("base_options", $base_options, _
			"output_category_mask", True))

	; Create the interactive segmenter
	Local $segmenter = $vision.InteractiveSegmenter.create_from_options($options)

	Local $image, $roi, $segmentation_result, $category_mask, $image_data
	Local $fg_image, $bg_image, $fg_mask
	Local $output_image, $blurred_image, $overlayed_image
	Local $keypoint_px, $alpha

	Local $color = _OpenCV_Scalar(255, 255, 0)
	Local $thickness, $radius, $scale

	; Loop through demo image(s)
	For $image_file_name In $IMAGE_FILENAMES
		; Create the MediaPipe image file that will be segmented
		$image = $mp.Image.create_from_file($MEDIAPIPE_SAMPLES_DATA_PATH & "\" & $image_file_name)

		; Retrieve the masks for the segmented image
		$roi = $RegionOfInterest(_Mediapipe_Params("format", $RegionOfInterest_Format.KEYPOINT, _
				"keypoint", $NormalizedKeypoint($x, $y)))
		$segmentation_result = $segmenter.segment($image, $roi)
		$category_mask = $segmentation_result.category_mask

		; mediapipe uses RGB images while opencv uses BGR images
		$image_data = $cv.cvtColor($image.mat_view(), $CV_COLOR_RGB2BGR)

		; Generate solid color images for showing the output segmentation mask.
		$fg_image = $cv.Mat.create($image_data.size(), $CV_8UC3, $FG_COLOR)
		$bg_image = $cv.Mat.create($image_data.size(), $CV_8UC3, $BG_COLOR)

		; The foreground mask corresponds to all 'i' pixels where category_mask[i] > 0.2
		$fg_mask = $cv.compare($category_mask.mat_view(), 0.1, $CV_CMP_GT)

		; Draw fg_image on bg_image only where fg_mask should apply
		$output_image = $bg_image.copy()
		$fg_image.copyTo($fg_mask, $output_image)

		; Compute the point of interest coordinates
		$keypoint_px = _normalized_to_pixel_coordinates($x, $y, $image.width, $image.height)

		; Compute the scale to make drawn elements visible when the image is resized for display
		$scale = 1 / resize_and_show($image, Default, False)

		$thickness = 10 * $scale
		$radius = 2 * $scale

		; Draw a circle to denote the point of interest
		$cv.circle($output_image, $keypoint_px, $thickness, $color, $radius)

		; Display the segmented image
		resize_and_show($output_image, 'Segmentation mask of ' & $image_file_name)

		; Blur the image only where fg_mask should not apply
		$blurred_image = $cv.GaussianBlur($image_data, _OpenCV_Size(55, 55), 0)
		$image_data.copyTo($fg_mask, $blurred_image)

		; Draw a circle to denote the point of interest
		$cv.circle($blurred_image, $keypoint_px, $thickness, $color, $radius)

		; Display the blurred image
		resize_and_show($blurred_image, 'Blurred background of ' & $image_file_name)

		; Create an overlay image with the desired color (e.g., (255, 0, 0) for red)
		$overlayed_image = $cv.Mat.create($image_data.size(), $CV_8UC3, $OVERLAY_COLOR)

		; Create an alpha channel based on the segmentation mask with the desired opacity (e.g., 0.7 for 70%)
		; fg_mask values are 0 where the mask should not apply and 255 where it should
		; multiplying by 0.7 / 255.0 gives values that are 0 where the mask should not apply and 0.7 where it should
		$alpha = $fg_mask.convertTo($CV_32F, Null, 0.7 / 255.0)

		; repeat the alpha mask for each image channel color
		$alpha = $cv.merge(_OpenCV_Tuple($alpha, $alpha, $alpha))

		; Blend the original image and the overlay image based on the alpha channel
		$overlayed_image = $cv.add($cv.multiply($image_data, $cv.subtract(1.0, $alpha), Null, Default, $CV_32F), $cv.multiply($overlayed_image, $alpha, Null, Default, $CV_32F))

		; Draw a circle to denote the point of interest
		$cv.circle($overlayed_image, $keypoint_px, $thickness, $color, $radius)

		; Display the overlayed image
		resize_and_show($overlayed_image, 'Overlayed foreground of ' & $image_file_name)
	Next

	$cv.waitKey()
EndFunc   ;==>Main

Func isclose($a, $b)
	Return Abs($a - $b) <= 1E-6
EndFunc   ;==>isclose

; Checks if the float value is between 0 and 1.
Func is_valid_normalized_value($value)
	Return ($value > 0 Or isclose(0, $value)) And ($value < 1 Or isclose(1, $value))
EndFunc   ;==>is_valid_normalized_value

#cs
Converts normalized value pair to pixel coordinates.
#ce
Func _normalized_to_pixel_coordinates($normalized_x, $normalized_y, $image_width, $image_height)
	If Not (is_valid_normalized_value($normalized_x) And is_valid_normalized_value($normalized_y)) Then
		; TODO: Draw coordinates even if it's outside of the image bounds.
		Return Default
	EndIf

	Local $x_px = _Min(Floor($normalized_x * $image_width), $image_width - 1)
	Local $y_px = _Min(Floor($normalized_y * $image_height), $image_height - 1)
	Return _OpenCV_Point($x_px, $y_px)
EndFunc   ;==>_normalized_to_pixel_coordinates

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

```

#### Language Detector with MediaPipe Tasks

```autoit
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Change2CUI=y
#AutoIt3Wrapper_Au3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

;~ Sources:
;~     https://colab.research.google.com/github/google-ai-edge/mediapipe-samples/blob/8c1d61ad6eb12f1f98ed95c3c8b64cb9801f3230/examples/language_detector/python/%5BMediaPipe_Python_Tasks%5D_Language_Detector.ipynb
;~     https://github.com/google-ai-edge/mediapipe-samples/blob/8c1d61ad6eb12f1f98ed95c3c8b64cb9801f3230/examples/language_detector/python/%5BMediaPipe_Python_Tasks%5D_Language_Detector.ipynb

;~ Title: Language Detector with MediaPipe Tasks

#include "autoit-mediapipe-com\udf\mediapipe_udf_utils.au3"
#include "autoit-opencv-com\udf\opencv_udf_utils.au3"

_Mediapipe_Open("opencv-4.11.0-windows\opencv\build\x64\vc16\bin\opencv_world4110.dll", "autoit-mediapipe-com\autoit_mediapipe_com-0.10.24-4110.dll")
OnAutoItExitRegister("_OnAutoItExit")

; Tell mediapipe where to look its resource files
_Mediapipe_SetResourceDir()

; Where to download data files
Global Const $MEDIAPIPE_SAMPLES_DATA_PATH = @ScriptDir & "\examples\data"

; STEP 1: Import the necessary modules.
Global $download_utils = _Mediapipe_ObjCreate("mediapipe.autoit.solutions.download_utils")
_AssertIsObj($download_utils, "Failed to load mediapipe.autoit.solutions.download_utils")

Global $autoit = _Mediapipe_ObjCreate("mediapipe.tasks.autoit")
_AssertIsObj($autoit, "Failed to load mediapipe.tasks.autoit")

Global $text = _Mediapipe_ObjCreate("mediapipe.tasks.autoit.text")
_AssertIsObj($text, "Failed to load mediapipe.tasks.autoit.text")

Main()

Func Main()
	Local $_MODEL_FILE = $MEDIAPIPE_SAMPLES_DATA_PATH & "\language_detector.tflite"
	Local $_MODEL_URL = "https://storage.googleapis.com/mediapipe-models/language_detector/language_detector/float32/latest/language_detector.tflite"

	Local $url, $file_path

	Local $sample_files[] = [ _
			_Mediapipe_Tuple($_MODEL_FILE, $_MODEL_URL) _
			]
	For $config In $sample_files
		$file_path = $config[0]
		$url = $config[1]
		If Not FileExists($file_path) Then
			$download_utils.download($url, $file_path)
		EndIf
	Next

	; Define the input text that you wants the model to classify.
	Local $INPUT_TEXT = "分久必合合久必分" ;@param {type:"string"}

	; STEP 2: Create a LanguageDetector object.
	Local $base_options = $autoit.BaseOptions(_Mediapipe_Params("model_asset_path", $_MODEL_FILE))
	Local $options = $text.LanguageDetectorOptions(_Mediapipe_Params("base_options", $base_options))
	Local $detector = $text.LanguageDetector.create_from_options($options)

	; STEP 3: Get the language detcetion result for the input text.
	Local $detection_result = $detector.detect($INPUT_TEXT)

	; STEP 4: Process the detection result and print the languages detected and their scores.
	For $detection In $detection_result.detections
		ConsoleWrite(StringFormat("%s: (%.2f)", $detection.language_code, $detection.probability) & @CRLF)
	Next
EndFunc   ;==>Main

Func _OnAutoItExit()
	_Mediapipe_Close()
EndFunc   ;==>_OnAutoItExit

Func _AssertIsObj($vVal, $sMsg)
	If Not IsObj($vVal) Then
		ConsoleWriteError($sMsg & @CRLF)
		Exit 0x7FFFFFFF
	EndIf
EndFunc   ;==>_AssertIsObj

```

#### Object Detection with MediaPipe Tasks

```autoit
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Change2CUI=y
#AutoIt3Wrapper_Au3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

;~ Sources:
;~     https://colab.research.google.com/github/google-ai-edge/mediapipe-samples/blob/8c1d61ad6eb12f1f98ed95c3c8b64cb9801f3230/examples/object_detection/python/object_detector.ipynb
;~     https://github.com/google-ai-edge/mediapipe-samples/blob/8c1d61ad6eb12f1f98ed95c3c8b64cb9801f3230/examples/object_detection/python/object_detector.ipynb

;~ Title: Object Detection with MediaPipe Tasks

#include "autoit-mediapipe-com\udf\mediapipe_udf_utils.au3"
#include "autoit-opencv-com\udf\opencv_udf_utils.au3"

_Mediapipe_Open("opencv-4.11.0-windows\opencv\build\x64\vc16\bin\opencv_world4110.dll", "autoit-mediapipe-com\autoit_mediapipe_com-0.10.24-4110.dll")
_OpenCV_Open("opencv-4.11.0-windows\opencv\build\x64\vc16\bin\opencv_world4110.dll", "autoit-opencv-com\autoit_opencv_com4110.dll")
OnAutoItExitRegister("_OnAutoItExit")

; Tell mediapipe where to look its resource files
_Mediapipe_SetResourceDir()

; Where to download data files
Global Const $MEDIAPIPE_SAMPLES_DATA_PATH = @ScriptDir & "\examples\data"

Global $download_utils = _Mediapipe_ObjCreate("mediapipe.autoit.solutions.download_utils")
_AssertIsObj($download_utils, "Failed to load mediapipe.autoit.solutions.download_utils")

; STEP 1: Import the necessary modules.
Global $mp = _Mediapipe_get()
_AssertIsObj($mp, "Failed to load mediapipe")

Global $cv = _OpenCV_get()
_AssertIsObj($cv, "Failed to load opencv")

Global $autoit = _Mediapipe_ObjCreate("mediapipe.tasks.autoit")
_AssertIsObj($autoit, "Failed to load mediapipe.tasks.autoit")

Global $vision = _Mediapipe_ObjCreate("mediapipe.tasks.autoit.vision")
_AssertIsObj($vision, "Failed to load mediapipe.tasks.autoit.vision")

Main()

Func Main()
	Local $_IMAGE_FILE = $MEDIAPIPE_SAMPLES_DATA_PATH & "\cat_and_dog.jpg"
	Local $_IMAGE_URL = "https://storage.googleapis.com/mediapipe-tasks/object_detector/cat_and_dog.jpg"
	Local $_MODEL_FILE = $MEDIAPIPE_SAMPLES_DATA_PATH & "\efficientdet_lite0.tflite"
	Local $_MODEL_URL = "https://storage.googleapis.com/mediapipe-models/object_detector/efficientdet_lite0/int8/1/efficientdet_lite0.tflite"

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

	; STEP 2: Create an ObjectDetector object.
	Local $base_options = $autoit.BaseOptions(_Mediapipe_Params("model_asset_path", $_MODEL_FILE))
	Local $options = $vision.ObjectDetectorOptions(_Mediapipe_Params("base_options", $base_options, _
			"score_threshold", 0.5))
	Local $detector = $vision.ObjectDetector.create_from_options($options)

	; STEP 3: Load the input image.
	Local $image = $mp.Image.create_from_file($_IMAGE_FILE)

	; Compute the scale to make drawn elements visible when the image is resized for display
	Local $scale = 1 / resize_and_show($image.mat_view(), Default, False)

	; STEP 4: Detect objects in the input image.
	Local $detection_result = $detector.detect($image)

	; STEP 5: Process the detection result. In this case, visualize it.
	Local $image_copy = $image.mat_view()
	Local $annotated_image = visualize($image_copy, $detection_result, $scale)
	Local $bgr_annotated_image = $cv.cvtColor($annotated_image, $CV_COLOR_RGB2BGR)
	resize_and_show($bgr_annotated_image, "object_detection")
	$cv.waitKey()

	; STEP 6: Closes the detector explicitly when the detector is not used ina context.
	$detector.close()
EndFunc   ;==>Main

#cs
Draws bounding boxes and keypoints on the input image and return it.
Args:
	image: The input RGB image.
	detection_result: The list of all "Detection" entities to be visualize.
	scale: Scale to keep drawing visible after resize
Returns:
	Image with bounding boxes.
#ce
Func visualize($image, $detection_result, $scale = 1.0)
	Local $MARGIN = 10 * $scale ; pixels
	Local $ROW_SIZE = 10 ; pixels
	Local $FONT_SIZE = $scale
	Local $FONT_THICKNESS = $scale
	Local $TEXT_COLOR = _OpenCV_Scalar(255, 0, 0)  ; red

	Local $bbox, $start_point, $end_point

	Local $category, $category_name, $probability, $result_text, $text_location

	For $detection In $detection_result.detections
		; Draw bounding_box
		$bbox = $detection.bounding_box
		$start_point = _OpenCV_Point($bbox.origin_x, $bbox.origin_y)
		$end_point = _OpenCV_Point($bbox.origin_x + $bbox.width, $bbox.origin_y + $bbox.height)
		$cv.rectangle($image, $start_point, $end_point, $TEXT_COLOR, 3)

		; Draw label and score
		$category = $detection.categories(0)
		$category_name = $category.category_name
		$probability = Round($category.score, 2)
		$result_text = $category_name & ' (' & $probability & ')'
		$text_location = _OpenCV_Point($MARGIN + $bbox.origin_x, $MARGIN + $ROW_SIZE + $bbox.origin_y)
		$cv.putText($image, $result_text, $text_location, $CV_FONT_HERSHEY_PLAIN, $FONT_SIZE, $TEXT_COLOR, $FONT_THICKNESS)
	Next

	Return $image
EndFunc   ;==>visualize

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

```

#### Pose Landmarks Detection with MediaPipe Tasks

```autoit
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Change2CUI=y
#AutoIt3Wrapper_Au3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

;~ Sources:
;~     https://colab.research.google.com/github/google-ai-edge/mediapipe-samples/blob/8c1d61ad6eb12f1f98ed95c3c8b64cb9801f3230/examples/pose_landmarker/python/%5BMediaPipe_Python_Tasks%5D_Pose_Landmarker.ipynb
;~     https://github.com/google-ai-edge/mediapipe-samples/blob/8c1d61ad6eb12f1f98ed95c3c8b64cb9801f3230/examples/pose_landmarker/python/%5BMediaPipe_Python_Tasks%5D_Pose_Landmarker.ipynb

;~ Title: Pose Landmarks Detection with MediaPipe Tasks

#include "autoit-mediapipe-com\udf\mediapipe_udf_utils.au3"
#include "autoit-opencv-com\udf\opencv_udf_utils.au3"

_Mediapipe_Open("opencv-4.11.0-windows\opencv\build\x64\vc16\bin\opencv_world4110.dll", "autoit-mediapipe-com\autoit_mediapipe_com-0.10.24-4110.dll")
_OpenCV_Open("opencv-4.11.0-windows\opencv\build\x64\vc16\bin\opencv_world4110.dll", "autoit-opencv-com\autoit_opencv_com4110.dll")
OnAutoItExitRegister("_OnAutoItExit")

; Tell mediapipe where to look its resource files
_Mediapipe_SetResourceDir()

; Where to download data files
Global Const $MEDIAPIPE_SAMPLES_DATA_PATH = @ScriptDir & "\examples\data"

; STEP 1: Import the necessary modules.
Global $mp = _Mediapipe_get()
_AssertIsObj($mp, "Failed to load mediapipe")

Global $cv = _OpenCV_get()
_AssertIsObj($cv, "Failed to load opencv")

Global $download_utils = _Mediapipe_ObjCreate("mediapipe.autoit.solutions.download_utils")
_AssertIsObj($download_utils, "Failed to load mediapipe.autoit.solutions.download_utils")

Global $solutions = _Mediapipe_ObjCreate("mediapipe.solutions")
_AssertIsObj($solutions, "Failed to load mediapipe.solutions")

Global $landmark_pb2 = _Mediapipe_ObjCreate("mediapipe.framework.formats.landmark_pb2")
_AssertIsObj($landmark_pb2, "Failed to load mediapipe.framework.formats.landmark_pb2")

Global $autoit = _Mediapipe_ObjCreate("mediapipe.tasks.autoit")
_AssertIsObj($autoit, "Failed to load mediapipe.tasks.autoit")

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

	; STEP 2: Create an PoseLandmarker object.
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
	resize_and_show($cv.cvtColor($annotated_image, $CV_COLOR_RGB2BGR), "Pose Landmarks Detection with MediaPipe Tasks : Image")

	; Visualize the pose segmentation mask.
	Local $segmentation_mask = $detection_result.segmentation_masks(0).mat_view()
	resize_and_show($segmentation_mask, "Pose Landmarks Detection with MediaPipe Tasks : Mask")

	$cv.waitKey()
EndFunc   ;==>Main

Func draw_landmarks_on_image($rgb_image, $detection_result)
	; Compute the scale to make drawn elements visible when the image is resized for display
	Local $scale = 1 / resize_and_show($rgb_image, Default, False)

	Local $pose_landmarks_list = $detection_result.pose_landmarks
	Local $annotated_image = $rgb_image
	Local $pose_landmarks_proto

	; Loop through the detected poses to visualize.
	For $pose_landmarks In $pose_landmarks_list

		; Draw the pose landmarks.
		$pose_landmarks_proto = $landmark_pb2.NormalizedLandmarkList()

		For $landmark In $pose_landmarks
			$pose_landmarks_proto.landmark.append($landmark_pb2.NormalizedLandmark(_Mediapipe_Params("x", $landmark.x, "y", $landmark.y, "z", $landmark.z)))
		Next

		$solutions.drawing_utils.draw_landmarks( _
				$annotated_image, _
				$pose_landmarks_proto, _
				$solutions.pose.POSE_CONNECTIONS, _
				$solutions.drawing_styles.get_default_pose_landmarks_style($scale))
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

```

#### Text Classifier with MediaPipe Tasks

```autoit
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Change2CUI=y
#AutoIt3Wrapper_Au3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

;~ Sources:
;~     https://colab.research.google.com/github/google-ai-edge/mediapipe-samples/blob/8c1d61ad6eb12f1f98ed95c3c8b64cb9801f3230/examples/text_classification/python/text_classifier.ipynb
;~     https://github.com/google-ai-edge/mediapipe-samples/blob/8c1d61ad6eb12f1f98ed95c3c8b64cb9801f3230/examples/text_classification/python/text_classifier.ipynb

;~ Title: Text Classifier with MediaPipe Tasks

#include "autoit-mediapipe-com\udf\mediapipe_udf_utils.au3"

_Mediapipe_Open("opencv-4.11.0-windows\opencv\build\x64\vc16\bin\opencv_world4110.dll", "autoit-mediapipe-com\autoit_mediapipe_com-0.10.24-4110.dll")
OnAutoItExitRegister("_OnAutoItExit")

; Tell mediapipe where to look its resource files
_Mediapipe_SetResourceDir()

; Where to download data files
Global Const $MEDIAPIPE_SAMPLES_DATA_PATH = @ScriptDir & "\examples\data"

Global $download_utils = _Mediapipe_ObjCreate("mediapipe.autoit.solutions.download_utils")
_AssertIsObj($download_utils, "Failed to load mediapipe.autoit.solutions.download_utils")

; STEP 1: Import the necessary modules.
Global $mp = _Mediapipe_get()
_AssertIsObj($mp, "Failed to load mediapipe")

Global $autoit = _Mediapipe_ObjCreate("mediapipe.tasks.autoit")
_AssertIsObj($autoit, "Failed to load mediapipe.tasks.autoit")

Global $text = _Mediapipe_ObjCreate("mediapipe.tasks.autoit.text")
_AssertIsObj($text, "Failed to load mediapipe.tasks.autoit.text")

Main()

Func Main()
	Local $_MODEL_FILE = $MEDIAPIPE_SAMPLES_DATA_PATH & "\bert_classifier.tflite"
	If Not FileExists($_MODEL_FILE) Then
		$download_utils.download("https://storage.googleapis.com/mediapipe-models/text_classifier/bert_classifier/float32/1/bert_classifier.tflite", $_MODEL_FILE)
	EndIf

	; Define the input text that you want the model to classify.
	Local $INPUT_TEXT = "I'm looking forward to what will come next."

	; STEP 2: Create a TextClassifier object.
	Local $base_options = $autoit.BaseOptions(_Mediapipe_Params("model_asset_path", $_MODEL_FILE))
	Local $options = $text.TextClassifierOptions(_Mediapipe_Params("base_options", $base_options))
	Local $classifier = $text.TextClassifier.create_from_options($options)

	; STEP 3: Classify the input text.
	Local $classification_result = $classifier.classify($INPUT_TEXT)

	; STEP 4: Process the classification result. In this case, print out the most likely category.
	Local $top_category = $classification_result.classifications(0).categories(0)
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : ' & StringFormat('%s (%.2f)', $top_category.category_name, $top_category.score) & @CRLF) ;### Debug Console
EndFunc   ;==>Main

Func _OnAutoItExit()
	_Mediapipe_Close()
EndFunc   ;==>_OnAutoItExit

Func _AssertIsObj($vVal, $sMsg)
	If Not IsObj($vVal) Then
		ConsoleWriteError($sMsg & @CRLF)
		Exit 0x7FFFFFFF
	EndIf
EndFunc   ;==>_AssertIsObj

```

#### Text Embedding with MediaPipe Tasks

```autoit
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Change2CUI=y
#AutoIt3Wrapper_Au3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

;~ Sources:
;~     https://colab.research.google.com/github/google-ai-edge/mediapipe-samples/blob/8c1d61ad6eb12f1f98ed95c3c8b64cb9801f3230/examples/text_embedder/python/text_embedder.ipynb
;~     https://github.com/google-ai-edge/mediapipe-samples/blob/8c1d61ad6eb12f1f98ed95c3c8b64cb9801f3230/examples/text_embedder/python/text_embedder.ipynb

;~ Title: Text Embedding with MediaPipe Tasks

#include "autoit-mediapipe-com\udf\mediapipe_udf_utils.au3"
#include "autoit-opencv-com\udf\opencv_udf_utils.au3"

_Mediapipe_Open("opencv-4.11.0-windows\opencv\build\x64\vc16\bin\opencv_world4110.dll", "autoit-mediapipe-com\autoit_mediapipe_com-0.10.24-4110.dll")
OnAutoItExitRegister("_OnAutoItExit")

; Tell mediapipe where to look its resource files
_Mediapipe_SetResourceDir()

; Where to download data files
Global Const $MEDIAPIPE_SAMPLES_DATA_PATH = @ScriptDir & "\examples\data"

Global $download_utils = _Mediapipe_ObjCreate("mediapipe.autoit.solutions.download_utils")
_AssertIsObj($download_utils, "Failed to load mediapipe.autoit.solutions.download_utils")

; STEP 1: Import the necessary modules.
Global $mp = _Mediapipe_get()
_AssertIsObj($mp, "Failed to load mediapipe")

Global $autoit = _Mediapipe_ObjCreate("mediapipe.tasks.autoit")
_AssertIsObj($autoit, "Failed to load mediapipe.tasks.autoit")

Global $text = _Mediapipe_ObjCreate("mediapipe.tasks.autoit.text")
_AssertIsObj($text, "Failed to load mediapipe.tasks.autoit.text")

Main()

Func Main()
	Local $_MODEL_FILE = $MEDIAPIPE_SAMPLES_DATA_PATH & "\bert_embedder.tflite"
	If Not FileExists($_MODEL_FILE) Then
		$download_utils.download("https://storage.googleapis.com/mediapipe-models/text_embedder/bert_embedder/float32/1/bert_embedder.tflite", $_MODEL_FILE)
	EndIf

	; Create your base options with the model that was downloaded earlier
	Local $base_options = $autoit.BaseOptions(_Mediapipe_Params("model_asset_path", $_MODEL_FILE))

	; Set your values for using normalization and quantization
	Local $l2_normalize = True ;@param {type:"boolean"}
	Local $quantize = False ;@param {type:"boolean"}

	; Create the final set of options for the Embedder
	Local $options = $text.TextEmbedderOptions(_Mediapipe_Params( _
			"base_options", $base_options, "l2_normalize", $l2_normalize, "quantize", $quantize))

	Local $embedder = $text.TextEmbedder.create_from_options($options)

	; Retrieve the first and second sets of text that will be compared
	Local $first_text = "I'm feeling so good" ;@param {type:"string"}
	Local $second_text = "I'm okay I guess" ;@param {type:"string"}

	; Convert both sets of text to embeddings
	Local $first_embedding_result = $embedder.embed($first_text)
	Local $second_embedding_result = $embedder.embed($second_text)

	; Retrieve the cosine similarity value from both sets of text, then take the
	; cosine of that value to receie a decimal similarity value.
	Local $similarity = $text.TextEmbedder.cosine_similarity($first_embedding_result.embeddings(0), _
			$second_embedding_result.embeddings(0))
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $similarity = ' & $similarity & @CRLF) ;### Debug Console
EndFunc   ;==>Main

Func _OnAutoItExit()
	_Mediapipe_Close()
EndFunc   ;==>_OnAutoItExit

Func _AssertIsObj($vVal, $sMsg)
	If Not IsObj($vVal) Then
		ConsoleWriteError($sMsg & @CRLF)
		Exit 0x7FFFFFFF
	EndIf
EndFunc   ;==>_AssertIsObj

```

<!-- EXAMPLES_END generated examples please keep comment here to allow auto update -->

### PowerShell

`powershell.exe -ExecutionPolicy UnRestricted -File example.ps1`

```powershell
#requires -version 5.0

Import-Module .\autoit-mediapipe-com\dotnet\mediapipe_utils.psm1
Import-Module .\autoit-opencv-com\dotnet\opencv_utils.psm1

function resize_and_show([string] $title, [Object] $image) {
    $DESIRED_HEIGHT = 480
    $DESIRED_WIDTH = 480
    $w = $image.width
    $h = $image.height
    $width = $w
    $height = $h

    if ($h -lt $w) {
        $h = $h / ($w / $DESIRED_WIDTH)
        $w = $DESIRED_WIDTH
    } else {
        $w = $w / ($h / $DESIRED_HEIGHT)
        $h = $DESIRED_HEIGHT
    }

    $interpolation = if ($DESIRED_WIDTH -gt $width -or $DESIRED_HEIGHT -gt $height) { $cv.enums.INTER_CUBIC } else { $cv.enums.INTER_AREA }

    $img = $cv.resize($image, @($w, $h), [OpenCvComInterop]::Params([ref] @{ interpolation = $interpolation }))
    $cv.imshow($title, $img.convertToShow())
    $w / $width
}

function Example() {
    $image_path = _Mediapipe_FindFile "examples\data\garrett-jackson-auTAb39ImXg-unsplash.jpg"
    $image = $cv.imread($image_path)

    $mp_face_mesh = $mp.solutions.face_mesh
    $mp_drawing = $mp.solutions.drawing_utils
    $mp_drawing_styles = $mp.solutions.drawing_styles

    # Preview the images.
    $ratio = resize_and_show -title "preview" -image $image
    $scale = 1 / $ratio

    # Run MediaPipe Face Detection
    $face_mesh = $mp_face_mesh.FaceMesh([MediapipeComInterop]::Params([ref] @{
        static_image_mode = $true;
        refine_landmarks = $true;
        max_num_faces = 2;
        min_detection_confidence = 0.5
    }))

    # Convert the BGR image to RGB and process it with MediaPipe Face Mesh.
    $results = $face_mesh.process($cv.cvtColor($image, $cv.enums.COLOR_BGR2RGB))
    If (-not $results["multi_face_landmarks"]) {
        Write-Error "No face detection for $image_path"
        return
    }

    $annotated_image = $image.copy()

    # Draw face detections of each face.
    foreach ($face_landmarks in $results["multi_face_landmarks"]) {
        $mp_drawing.draw_landmarks([MediapipeComInterop]::Params([ref] @{
                image =  $annotated_image;
                landmark_list =  $face_landmarks;
                connections =  $mp_face_mesh.FACEMESH_TESSELATION;
                landmark_drawing_spec =  $null;
                connection_drawing_spec = $mp_drawing_styles.get_default_face_mesh_tesselation_style($scale)}))
        $mp_drawing.draw_landmarks([MediapipeComInterop]::Params([ref] @{
                image =  $annotated_image;
                landmark_list =  $face_landmarks;
                connections =  $mp_face_mesh.FACEMESH_CONTOURS;
                landmark_drawing_spec =  $null;
                connection_drawing_spec = $mp_drawing_styles.get_default_face_mesh_contours_style(0, $scale)}))
        $mp_drawing.draw_landmarks([MediapipeComInterop]::Params([ref] @{
                image =  $annotated_image;
                landmark_list =  $face_landmarks;
                connections =  $mp_face_mesh.FACEMESH_IRISES;
                landmark_drawing_spec =  $null;
                connection_drawing_spec = $mp_drawing_styles.get_default_face_mesh_iris_connections_style($scale)}))
    }

    resize_and_show -title "face mesh" -image $annotated_image | Out-Null

    $cv.waitKey() | Out-Null
    $cv.destroyAllWindows()
}

[MediapipeComInterop]::DllOpen("opencv-4.11.0-windows\opencv\build\x64\vc16\bin\opencv_world4110.dll", "autoit-mediapipe-com\autoit_mediapipe_com-0.10.24-4110.dll")
[OpenCvComInterop]::DllOpen("opencv-4.11.0-windows\opencv\build\x64\vc16\bin\opencv_world4110.dll", "autoit-opencv-com\autoit_opencv_com4110.dll")

$resource_util = [MediapipeComInterop]::ObjCreate("mediapipe.autoit._framework_bindings.resource_util")
$resource_util.set_resource_dir("autoit-mediapipe-com")

$cv = [OpenCvComInterop]::ObjCreate("cv")
$mp = [MediapipeComInterop]::ObjCreate("mediapipe")

Example

[MediapipeComInterop]::DllClose()
[OpenCvComInterop]::DllClose()
```

### csharp

Open `x64 Native Tools Command Prompt for VS 2022`


#### Runtime example

`csc.exe example-runtime.cs autoit-opencv-com\dotnet\OpenCvComInterop.cs autoit-mediapipe-com\dotnet\MediapipeComInterop.cs && example-runtime.exe`

```cs
using System;
using System.Collections;
using System.ComponentModel;
using System.Runtime.InteropServices;

public static class Test
{
    private static readonly int DISP_E_PARAMNOTFOUND = -2147352572;

    private static readonly int DESIRED_HEIGHT = 480;
    private static readonly int DESIRED_WIDTH = 480;

    private static void Example()
    {
        var cv = OpenCvComInterop.ObjCreate("cv");
        if (ReferenceEquals(cv, null))
        {
            throw new Win32Exception(Marshal.GetLastWin32Error(), "Failed to create cv com");
        }

        var mp = MediapipeComInterop.ObjCreate("mediapipe");
        if (ReferenceEquals(mp, null))
        {
            throw new Win32Exception(Marshal.GetLastWin32Error(), "Failed to create mp com");
        }

        var image_path = OpenCvComInterop.FindFile("examples\\data\\garrett-jackson-auTAb39ImXg-unsplash.jpg");
        var image = cv.imread(image_path);

        // Preview the images.
        var ratio = ResizeAndShow(cv, "preview", image);

        var mp_face_detection = mp.solutions.face_detection;
        var mp_drawing = mp.solutions.drawing_utils;

        // Run MediaPipe Face Detection
        var face_detection = mp_face_detection.FaceDetection.create();

        // Convert the BGR image to RGB and process it with MediaPipe Face Detection.
        var results = face_detection.process(cv.cvtColor(image, cv.enums.COLOR_BGR2RGB));
        if (DISP_E_PARAMNOTFOUND.Equals(results["detections"]))
        {
            Console.Error.WriteLine("No face detection for " + image_path);
            return;
        }

        // enlarge/shrink drawings to keep them visible after resize
        var thickness = 2 / ratio;
        var keypoint_drawing_spec = mp_drawing.DrawingSpec.create(mp_drawing.RED_COLOR, thickness, thickness);
        var bbox_drawing_spec = mp_drawing.DrawingSpec.create(mp_drawing.WHITE_COLOR, thickness, thickness);

        // Draw face detections of each face.
        foreach (var detection in results["detections"])
        {
            mp_drawing.draw_detection(image, detection, keypoint_drawing_spec, bbox_drawing_spec);
        }

        ResizeAndShow(cv, "face detection", image);

        cv.waitKey();
        cv.destroyAllWindows();
    }

    private static float ResizeAndShow(dynamic cv, string title, dynamic image)
    {
        float w = image.width;
        float h = image.height;

        if (h < w)
        {
            h = h / (w / DESIRED_WIDTH);
            w = DESIRED_WIDTH;
        }
        else
        {
            w = w / (h / DESIRED_HEIGHT);
            h = DESIRED_HEIGHT;
        }

        int interpolation = DESIRED_WIDTH > image.width || DESIRED_HEIGHT > image.height ? cv.enums.INTER_CUBIC : cv.enums.INTER_AREA;

        dynamic[] size = { w, h };
        var kwargs = new Hashtable() {
            { "interpolation", interpolation },
        };

        dynamic img = cv.resize(image, size, OpenCvComInterop.Params(ref kwargs));
        cv.imshow(title, img.convertToShow());

        return (float)img.width / image.width;
    }

    static void Main(String[] args)
    {
        OpenCvComInterop.DllOpen(
            "opencv-4.11.0-windows\\opencv\\build\\x64\\vc16\\bin\\opencv_world4110.dll",
            "autoit-opencv-com\\autoit_opencv_com4110.dll"
        );

        MediapipeComInterop.DllOpen(
            "opencv-4.11.0-windows\\opencv\\build\\x64\\vc16\\bin\\opencv_world4110.dll",
            "autoit-mediapipe-com\\autoit_mediapipe_com-0.10.24-4110.dll"
        );

        var resourceDir = MediapipeComInterop.FindResourceDir();
        var resource_util = MediapipeComInterop.ObjCreate("mediapipe.autoit._framework_bindings.resource_util");
        resource_util.set_resource_dir(resourceDir);

        Example();

        MediapipeComInterop.DllClose();
        OpenCvComInterop.DllClose();
    }
}
```

#### Compile time example

`csc.exe example-compile.cs /link:autoit-opencv-com\dotnet\OpenCV.InteropServices.dll /link:autoit-mediapipe-com\dotnet\Mediapipe.InteropServices.dll autoit-opencv-com\dotnet\OpenCvComInterop.cs autoit-mediapipe-com\dotnet\MediapipeComInterop.cs && example-compile.exe`

```cs
using System;
using System.Collections;
using System.ComponentModel;
using System.Runtime.InteropServices;
using Mediapipe.InteropServices;
using Cv_Object = OpenCV.InteropServices.Cv_Object;
using ICv_Object = OpenCV.InteropServices.ICv_Object;

public static class Test
{
#if DEBUG
    private static readonly string DEBUG_PREFIX = "d";
#else
    private static readonly string DEBUG_PREFIX = "";
#endif

    private static readonly int DISP_E_PARAMNOTFOUND = -2147352572;

    private static readonly int DESIRED_HEIGHT = 480;
    private static readonly int DESIRED_WIDTH = 480;

    private static void Example()
    {
        ICv_Object cv = new Cv_Object();
        IMediapipe_Object mp = new Mediapipe_Object();

        var image_path = OpenCvComInterop.FindFile("examples\\data\\garrett-jackson-auTAb39ImXg-unsplash.jpg");
        var image = cv.imread(image_path);

        // Preview the images.
        var ratio = ResizeAndShow(cv, "preview", image);

        var mp_face_detection = mp.solutions.face_detection;
        var mp_drawing = mp.solutions.drawing_utils;

        // Run MediaPipe Face Detection
        var face_detection = mp_face_detection.FaceDetection;

        // Convert the BGR image to RGB and process it with MediaPipe Face Detection.
        var results = face_detection.process(cv.cvtColor(image, cv.enums.COLOR_BGR2RGB));
        if (DISP_E_PARAMNOTFOUND.Equals(results["detections"]))
        {
            Console.Error.WriteLine("No face detection for " + image_path);
            return;
        }

        // enlarge/shrink drawings to keep them visible after resize
        var thickness = 2 / ratio;
        var keypoint_drawing_spec = mp_drawing.DrawingSpec[mp_drawing.RED_COLOR, thickness, thickness];
        var bbox_drawing_spec = mp_drawing.DrawingSpec[mp_drawing.WHITE_COLOR, thickness, thickness];

        // Draw face detections of each face.
        foreach (var detection in results["detections"])
        {
            mp_drawing.draw_detection(image, detection, keypoint_drawing_spec, bbox_drawing_spec);
        }

        ResizeAndShow(cv, "face detection", image);

        cv.waitKey();
        cv.destroyAllWindows();
    }

    private static float ResizeAndShow(dynamic cv, string title, dynamic image)
    {
        float w = image.width;
        float h = image.height;

        if (h < w)
        {
            h = h / (w / DESIRED_WIDTH);
            w = DESIRED_WIDTH;
        }
        else
        {
            w = w / (h / DESIRED_HEIGHT);
            h = DESIRED_HEIGHT;
        }

        int interpolation = DESIRED_WIDTH > image.width || DESIRED_HEIGHT > image.height ? cv.enums.INTER_CUBIC : cv.enums.INTER_AREA;

        dynamic[] size = { w, h };
        var kwargs = new Hashtable() {
            { "interpolation", interpolation },
        };

        dynamic img = cv.resize(image, size, OpenCvComInterop.Params(ref kwargs));
        cv.imshow(title, img.convertToShow());

        return (float)img.width / image.width;
    }

    static void Main(String[] args)
    {
        OpenCvComInterop.DllOpen(
            "opencv-4.11.0-windows\\opencv\\build\\x64\\vc16\\bin\\opencv_world4110.dll",
            "autoit-opencv-com\\autoit_opencv_com4110.dll"
        );

        MediapipeComInterop.DllOpen(
            "opencv-4.11.0-windows\\opencv\\build\\x64\\vc16\\bin\\opencv_world4110.dll",
            "autoit-mediapipe-com\\autoit_mediapipe_com-0.10.24-4110.dll"
        );

        // To make registration free works with compile time COM classes
        // the activated context needs to have all the dependencies of our application.
        // Therefore, there is a mediapipe.sxs.manifest file which declares all the dependencies
        // of our application.
        var manifest = MediapipeComInterop.FindFile($"mediapipe{DEBUG_PREFIX}.sxs.manifest", new string[] {
            ".",
            "autoit-mediapipe-com",
            "autoit-mediapipe-com\\udf"
        });

        // Make opencv com and mediapipe com to use this manifest instead of the one embeded in their respective dll
        Environment.SetEnvironmentVariable("OPENCV_ACTCTX_MANIFEST", manifest);
        Environment.SetEnvironmentVariable("MEDIAPIPE_ACTCTX_MANIFEST", manifest);

        MediapipeComInterop.DllActivateManifest();

        var resourceDir = MediapipeComInterop.FindResourceDir();
        IMediapipe_Autoit__framework_bindings_Resource_util_Object resource_util = new Mediapipe_Autoit__framework_bindings_Resource_util_Object();
        resource_util.set_resource_dir(resourceDir);

        Example();

        MediapipeComInterop.DllDeactivateActCtx();

        MediapipeComInterop.DllClose();
        OpenCvComInterop.DllClose();
    }
}
```

## Running examples

Install [7-zip](https://www.7-zip.org/download.html) and add the 7-zip folder to you system PATH environment variable

Then, in [Git Bash](https://gitforwindows.org/), execute the following commands

```sh
# download autoit-mediapipe-0.10.24-opencv-4.11.0-com-v0.4.1.7z
curl -L 'https://github.com/smbape/node-autoit-mediapipe-com/releases/download/v0.4.1/autoit-mediapipe-0.10.24-opencv-4.11.0-com-v0.4.1.7z' -o autoit-mediapipe-0.10.24-opencv-4.11.0-com-v0.4.1.7z

# extract the content of autoit-mediapipe-0.10.24-opencv-4.11.0-com-v0.4.1.7z into a folder named autoit-mediapipe-com
7z x autoit-mediapipe-0.10.24-opencv-4.11.0-com-v0.4.1.7z -aoa -oautoit-mediapipe-com

# download autoit-opencv-4.11.0-com-v2.7.0.7z
curl -L 'https://github.com/smbape/node-autoit-opencv-com/releases/download/v2.7.0/autoit-opencv-4.11.0-com-v2.7.0.7z' -o autoit-opencv-4.11.0-com-v2.7.0.7z

# extract the content of autoit-opencv-4.11.0-com-v2.7.0.7z into a folder named autoit-opencv-com
7z x autoit-opencv-4.11.0-com-v2.7.0.7z -aoa -oautoit-opencv-com

# download opencv-4.11.0-windows.exe
curl -L 'https://github.com/opencv/opencv/releases/download/4.11.0/opencv-4.11.0-windows.exe' -o opencv-4.11.0-windows.exe

# extract the content of opencv-4.11.0-windows.exe into a folder named opencv-4.11.0-windows
./opencv-4.11.0-windows.exe -oopencv-4.11.0-windows -y

# download autoit-mediapipe-0.10.24-opencv-4.11.0-com-v0.4.1-src.zip
curl -L 'https://github.com/smbape/node-autoit-mediapipe-com/archive/refs/tags/v0.4.1.zip' -o autoit-mediapipe-0.10.24-opencv-4.11.0-com-v0.4.1-src.zip

# extract the examples folder of autoit-mediapipe-0.10.24-opencv-4.11.0-com-v0.4.1-src.zip
7z x autoit-mediapipe-0.10.24-opencv-4.11.0-com-v0.4.1-src.zip -aoa 'node-autoit-mediapipe-com-0.4.1\examples'
cp -rf node-autoit-mediapipe-com-0.4.1/* ./
rm -rf node-autoit-mediapipe-com-0.4.1

# download mediapipe-0.10.24-src.tar.gz
curl -L 'https://github.com/google-ai-edge/mediapipe/archive/refs/tags/v0.10.24.tar.gz' -o mediapipe-0.10.24-src.tar.gz

# extract the mediapipe/tasks/testdata folder of mediapipe-0.10.24-src.tar.gz
tar xzf mediapipe-0.10.24-src.tar.gz 'mediapipe-0.10.24/mediapipe/tasks/testdata'
cp -rf mediapipe-0.10.24/* ./
rm -rf mediapipe-0.10.24

```

Now you can run any file in the `examples` folder.

## Developpement

### Prerequisites

  - Install [Bazel](https://bazel.build/install/windows)
  - Install [Visual Studio 2022 >= 17.13.0 with .NET Desktop and C++ Desktop](https://visualstudio.microsoft.com/fr/downloads/)
  - Install [Git for Windows](https://gitforwindows.org/)
  - Install [nodejs](https://nodejs.org/en/download/)
  - Install [Python >= 3.8](https://www.python.org/downloads/)

### Environment

In Git BASH, excute the following commands

```sh
# get the source files
git clone https://github.com/smbape/node-autoit-mediapipe-com
cd node-autoit-mediapipe-com

# Install nodejs dependencies
npm ci
```

### Generate the UDF files

```sh
cmd.exe //c 'autoit-mediapipe-com\build.bat'
```
