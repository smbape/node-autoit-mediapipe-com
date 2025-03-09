#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Change2CUI=y
#AutoIt3Wrapper_Au3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

;~ Sources:
;~     https://colab.research.google.com/github/google-ai-edge/mediapipe-samples/blob/8c1d61ad6eb12f1f98ed95c3c8b64cb9801f3230/examples/face_detector/python/face_detector.ipynb
;~     https://github.com/google-ai-edge/mediapipe-samples/blob/8c1d61ad6eb12f1f98ed95c3c8b64cb9801f3230/examples/face_detector/python/face_detector.ipynb

#include <GDIPlus.au3>
#include <GUIConstantsEx.au3>
#include "..\..\..\..\..\autoit-mediapipe-com\udf\mediapipe_udf_utils.au3"
#include "..\..\..\..\..\autoit-opencv-com\udf\opencv_udf_utils.au3"

_GDIPlus_Startup()
_Mediapipe_Open(_Mediapipe_FindDLL("opencv_world4110*"), _Mediapipe_FindDLL("autoit_mediapipe_com-*-4110*"))
_OpenCV_Open(_OpenCV_FindDLL("opencv_world4110*"), _OpenCV_FindDLL("autoit_opencv_com4110*"))
OnAutoItExitRegister("_OnAutoItExit")

; Where to download data files
Global Const $MEDIAPIPE_SAMPLES_DATA_PATH = _Mediapipe_FindFile("examples\data")
Global Const $_MODEL_FILE = $MEDIAPIPE_SAMPLES_DATA_PATH & "\blaze_face_short_range.tflite"

Setup()

; STEP 1: Import the necessary modules.
Global $mp = _Mediapipe_get()
_AssertIsObj($mp, "Failed to load mediapipe")

Global $cv = _OpenCV_get()
_AssertIsObj($cv, "Failed to load opencv")

Global $autoit = _Mediapipe_ObjCreate("mediapipe.tasks.autoit")
_AssertIsObj($autoit, "Failed to load mediapipe.tasks.autoit")

Global $vision = _Mediapipe_ObjCreate("mediapipe.tasks.autoit.vision")
_AssertIsObj($vision, "Failed to load mediapipe.tasks.autoit.vision")

#Region ### START Koda GUI section ### Form=
Global $FormGUI = GUICreate("face_detector", 1000, 647, 192, 95)

Global $InputImage = GUICtrlCreateInput($cv.samples.findFile("brother-sister-girl-family-boy-977170.jpg"), 230, 16, 449, 21)
Global $BtnImage = GUICtrlCreateButton("Image", 689, 14, 75, 25)

Global $BtnExec = GUICtrlCreateButton("Execute", 768, 14, 75, 25)

Global $LabelResult = GUICtrlCreateLabel("Face detection", 377, 60, 245, 20)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
Global $GroupResult = GUICtrlCreateGroup("", 20, 82, 958, 532)
Global $PicResult = GUICtrlCreatePic("", 25, 93, 948, 516)
GUICtrlCreateGroup("", -99, -99, 1, 1)

GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

Global $nMsg
Global $sImage

Main()

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			ExitLoop
		Case $BtnImage
			$sImage = ControlGetText($FormGUI, "", $InputImage)
			$sImage = FileOpenDialog("Select an image", $MEDIAPIPE_SAMPLES_DATA_PATH, "Image files (*.bmp;*.dlib;*.jpg;*.jpeg;*.png;*.pbm;*.pgm;*.ppm;*.pxm;*.pnm;*.pfm;*.sr;*.ras;*.tiff;*.tif;*.exr;*.hdr;.pic)", $FD_FILEMUSTEXIST, $sImage)
			If @error Then
				$sImage = ""
			Else
				ControlSetText($FormGUI, "", $InputImage, $sImage)
				Main()
			EndIf
		Case $BtnExec
			Main()
	EndSwitch
WEnd

Func Main()
	$sImage = ControlGetText($FormGUI, "", $InputImage)
	If $sImage == "" Then Return

	; STEP 2: Create an FaceDetector object.
	Local $base_options = $autoit.BaseOptions(_Mediapipe_Params("model_asset_path", $_MODEL_FILE))
	Local $options = $vision.FaceDetectorOptions(_Mediapipe_Params("base_options", $base_options))
	Local $detector = $vision.FaceDetector.create_from_options($options)

	; STEP 3: Load the input image.
	Local $image = $mp.Image.create_from_file($sImage)

	; STEP 4: Detect faces in the input image.
	Local $detection_result = $detector.detect($image)

	; STEP 5: Process the detection result. In this case, visualize it.
	Local $image_copy = $image.mat_view()

	; Compute the scale to make drawn elements visible when the image is resized for display
	Local $scale = 1 / _OpenCV_resizeRatio_ControlPic($image_copy, $FormGUI, $PicResult)

	Local $annotated_image = visualize($image_copy, $detection_result, $scale)
	Local $bgr_annotated_image = $cv.cvtColor($annotated_image, $CV_COLOR_RGB2BGR)

	_OpenCV_imshow_ControlPic($bgr_annotated_image, $FormGUI, $PicResult)
EndFunc   ;==>Main

Func Setup()
	; Tell mediapipe where to look its resource files
	_Mediapipe_SetResourceDir()

	Local $download_utils = _Mediapipe_ObjCreate("mediapipe.autoit.solutions.download_utils")
	_AssertIsObj($download_utils, "Failed to load mediapipe.autoit.solutions.download_utils")

	Local $_IMAGE_FILE = $MEDIAPIPE_SAMPLES_DATA_PATH & "\brother-sister-girl-family-boy-977170.jpg"
	Local $_IMAGE_URL = "https://i.imgur.com/Vu2Nqwb.jpg"
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

	Local $cv = _OpenCV_get()
	_AssertIsObj($cv, "Failed to load opencv")

	If FileExists($MEDIAPIPE_SAMPLES_DATA_PATH) Then
		$cv.samples.addSamplesDataSearchPath($MEDIAPIPE_SAMPLES_DATA_PATH)
	EndIf
EndFunc   ;==>Setup

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
	_GDIPlus_Shutdown()
EndFunc   ;==>_OnAutoItExit

Func _AssertIsObj($vVal, $sMsg)
	If Not IsObj($vVal) Then
		ConsoleWriteError($sMsg & @CRLF)
		Exit 0x7FFFFFFF
	EndIf
EndFunc   ;==>_AssertIsObj
