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
;~     https://colab.research.google.com/github/googlesamples/mediapipe/blob/7d956461efb88e7601de5a4ae55d5a954b093589/examples/face_detector/python/face_detector.ipynb
;~     https://github.com/googlesamples/mediapipe/blob/7d956461efb88e7601de5a4ae55d5a954b093589/examples/face_detector/python/face_detector.ipynb

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

Global $autoit = _Mediapipe_ObjCreate("mediapipe.tasks.autoit")
_AssertIsObj($autoit, "Failed to load mediapipe.tasks.autoit")

Global $vision = _Mediapipe_ObjCreate("mediapipe.tasks.autoit.vision")
_AssertIsObj($vision, "Failed to load mediapipe.tasks.autoit.vision")

Main()

Func Main()
	Local $_IMAGE_FILE = $MEDIAPIPE_SAMPLES_DATA_PATH & "\brother-sister-girl-family-boy-977170.jpg"
	Local $_IMAGE_URL = "https://i.imgur.com/Vu2Nqwb.jpg"
	Local $_MODEL_FILE = $MEDIAPIPE_SAMPLES_DATA_PATH & "\face_detection_short_range.tflite"
	Local $_MODEL_URL = "https://storage.googleapis.com/mediapipe-assets/face_detection_short_range.tflite?generation=1677044301978921"

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

	Local $scale = 1 / resize_and_show($cv.imread($_IMAGE_FILE), Default, False)

	; STEP 2: Create an FaceDetector object.
	Local $base_options = $autoit.BaseOptions(_Mediapipe_Params("model_asset_path", $_MODEL_FILE))
	Local $options = $vision.FaceDetectorOptions(_Mediapipe_Params("base_options", $base_options))
	Local $detector = $vision.FaceDetector.create_from_options($options)

	; STEP 3: Load the input image.
	Local $image = $mp.Image.create_from_file($_IMAGE_FILE)

	; STEP 4: Detect faces in the input image.
	Local $detection_result = $detector.detect($image)

	; STEP 5: Process the detection result. In this case, visualize it.
	Local $image_copy = $image.mat_view()
	Local $annotated_image = visualize($image_copy, $detection_result, $scale)
	Local $rgb_annotated_image = $cv.cvtColor($annotated_image, $CV_COLOR_RGB2BGR)
	resize_and_show($rgb_annotated_image, "face_detector")
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
	Return _OpenCV_Tuple($x_px, $y_px)
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
	Local $MARGIN = 10 * $scale; pixels
	Local $ROW_SIZE = 10 ; pixels
	Local $FONT_SIZE = $scale
	Local $FONT_THICKNESS = $scale
	Local $TEXT_COLOR = _OpenCV_Scalar(255, 0, 0)  ; red

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
		$cv.rectangle($annotated_image, $start_point, $end_point, $TEXT_COLOR, 3)

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
