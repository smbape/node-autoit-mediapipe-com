#requires -version 5.0

[CmdletBinding()]
param (
    [string] $ImageFile = $null,
    [string] $ImageUrl = $null,
    [string] $BuildType = $Env:BUILD_TYPE,
    [string] $OpenCVWorldDll = $null,
    [string] $OpenCVComDll = $null,
    [string] $MediapipeComDll = $null,
    [string] $ResourceDir = $null,
    [switch] $Register,
    [switch] $Unregister
)
# "pwsh.exe -ExecutionPolicy UnRestricted -File $PSCommandPath"

$ErrorActionPreference = "Stop"
Set-StrictMode -Version 3.0
trap { Write-Host $Error.ScriptStackTrace -Foreground "DarkGray"; throw $Error[0] }

Import-Module "$PSScriptRoot\..\..\..\..\dotnet\mediapipe_utils.psm1" -ArgumentList $BuildType
Import-Module ( _Mediapipe_FindFile -Path "opencv_utils.psm1" -SearchPaths @(".", "autoit-opencv-com", "autoit-opencv-com\dotnet") ) -ArgumentList $BuildType

$BuildType = if ($BuildType -eq "Debug") { "Debug" } else { "Release" }

$OpenCVWorldDll = if ([string]::IsNullOrEmpty($OpenCVWorldDll)) { _OpenCV_FindDLL "opencv_world4130*" -BuildType $BuildType } else { $OpenCVWorldDll }
$OpenCVComDll = if ([string]::IsNullOrEmpty($OpenCVComDll)) { _OpenCV_FindDLL "autoit_opencv_com4130*" -BuildType $BuildType } else { $OpenCVComDll }
$MediapipeComDll = if ([string]::IsNullOrEmpty($MediapipeComDll)) { _Mediapipe_FindDLL "autoit_mediapipe_com-*-4130*" -BuildType $BuildType } else { $MediapipeComDll }

# Where to download data files
$MEDIAPIPE_SAMPLES_DATA_PATH = _Mediapipe_FindFile("examples\data")

$DefaultImageFile = "$MEDIAPIPE_SAMPLES_DATA_PATH\brother-sister-girl-family-boy-977170.jpg"
$DefaultImageUrl = "https://i.imgur.com/Vu2Nqwb.jpg"

$ImageFile = if ([string]::IsNullOrEmpty($ImageFile)) { $DefaultImageFile } else { $ImageFile }
$ImageUrl = if ([string]::IsNullOrEmpty($ImageUrl)) { $DefaultImageUrl } else { $ImageUrl }


$mp = $null
$cv = $null
$autoit = $null
$vision = $null


function Main() {
    # STEP 1: Import the necessary modules.
    $download_utils = [MediapipeComInterop]::ObjCreate("mediapipe.tasks.autoit.core.download_utils")
    $mp = [MediapipeComInterop]::ObjCreate("mediapipe")
    $cv = [OpenCvComInterop]::ObjCreate("cv")
    $autoit = [MediapipeComInterop]::ObjCreate("mediapipe.tasks.autoit")
    $vision = [MediapipeComInterop]::ObjCreate("mediapipe.tasks.autoit.vision")

    $_IMAGE_FILE = $ImageFile
    $_IMAGE_URL = $ImageUrl
    $_MODEL_FILE = "$MEDIAPIPE_SAMPLES_DATA_PATH\blaze_face_short_range.tflite"
    $_MODEL_URL = "https://storage.googleapis.com/mediapipe-models/face_detector/blaze_face_short_range/float16/1/blaze_face_short_range.tflite"

    $sample_files = @(
        @($_IMAGE_FILE, $_IMAGE_URL),
        @($_MODEL_FILE, $_MODEL_URL)
    )

    foreach($config in $sample_files) {
        $file_path = $config[0]
        $url = $config[1]

        if (!(Test-Path -Path $file_path)) {
            $download_utils.download($url, $file_path)
        }
    }

    # STEP 2: Create a FaceDetector object.
    $base_options = $autoit.BaseOptions([MediapipeComInterop]::Params(@{model_asset_path = $_MODEL_FILE}))
    $options = $vision.FaceDetectorOptions([MediapipeComInterop]::Params(@{base_options = $base_options}))
    $detector = $vision.FaceDetector.create_from_options($options)

    # STEP 3: Load the input image.
    $image = $mp.Image.create_from_file($_IMAGE_FILE)

    # Compute the scale to make drawn elements visible when the image is resized for display
    $scale = 1 / (Resize-And-Show -Image $image.mat_view() -NoShow)

    # STEP 4: Detect faces in the input image.
    $detection_result = $detector.detect($image)

    # STEP 5: Process the detection result. In this case, visualize it.
    $annotated_image = Visualize -RGBImage $image.mat_view() -DetectionResult $detection_result -Scale $scale
    Resize-And-Show -Image $annotated_image -Title "face_detector" | Out-Null
    $cv.waitKey() | Out-Null
}

function Is-Close([double] $lhs, [double] $rhs) {
    [Math]::Abs($lhs - $rhs) -le 1e-6
}

<#
.Synopsis
    Checks if the float value is between 0 and 1.
#>
function Is-ValidNormalizedValue([double] $value) {
    ($value -ge 0) -and ($value -le 1) -or (Is-Close -lhs 0 -rhs $value) -or (Is-Close -lhs 1 -rhs $value)
}

<#
.Synopsis
    Converts normalized value pair to pixel coordinates.
#>
function Get-NormalizedToPixelCoordinates($normalized_x, $normalized_y, $image_width, $image_height) {
    if (-not ((Is-ValidNormalizedValue $normalized_x) -and (Is-ValidNormalizedValue $normalized_y))) {
        # TODO: Draw coordinates even if it's outside of the image bounds.
        $null
        return
    }

    $x_px = [Math]::Min([Math]::Floor($normalized_x * $image_width), $image_width - 1)
    $y_px = [Math]::Min([Math]::Floor($normalized_y * $image_height), $image_height - 1)

    $x_px, $y_px
}

function Visualize($RGBImage, $DetectionResult, $Scale = 1.0) {
    $MARGIN = 10 * $Scale # pixels
    $ROW_SIZE = 10 # pixels
    $FONT_SIZE = $Scale
    $FONT_THICKNESS = 2 * $Scale
    $TEXT_COLOR = @(0, 0, 255)  # red

    $bbox_thickness = 3 * $Scale

    $keypoint_color = @(0, 255, 0)
    $keypoint_thickness = 2 * $Scale
    $keypoint_radius = 2 * $Scale

    $annotated_image = $cv.cvtColor($RGBImage, $cv.enums.COLOR_RGB2BGR)
    $width = $RGBImage.width
    $height = $RGBImage.height

    foreach ($detection in $DetectionResult.detections) {
        # Draw bounding_box
        $bbox = $detection.bounding_box
        $start_point = $bbox.origin_x, $bbox.origin_y
        $end_point = ($bbox.origin_x + $bbox.width), ($bbox.origin_y + $bbox.height)
        $cv.rectangle($annotated_image, $start_point, $end_point, $TEXT_COLOR, $bbox_thickness) | Out-Null

        # Draw keypoints
        foreach ($keypoint in $detection.keypoints) {
            $keypoint_px = Get-NormalizedToPixelCoordinates $keypoint.x $keypoint.y $width $height
            $cv.circle($annotated_image, $keypoint_px, $keypoint_thickness, $keypoint_color, $keypoint_radius) | Out-Null
        }

        # Draw label and score
        $category = $detection.categories(0)
        $category_name = $category.category_name
        $probability = [Math]::Round($category.score, 2)
        $result_text = "$category_name($probability)"
        $text_location = @(($MARGIN + $bbox.origin_x), ($MARGIN + $ROW_SIZE + $bbox.origin_y))
        $cv.putText($annotated_image, $result_text, $text_location, $cv.enums.FONT_HERSHEY_PLAIN, $FONT_SIZE, $TEXT_COLOR, $FONT_THICKNESS) | Out-Null
    }

    $annotated_image
}

function Resize-And-Show($Image, $Title = $null, [switch] $NoShow) {
    $DESIRED_HEIGHT = 480
    $DESIRED_WIDTH = 480
    $w = $Image.width
    $h = $Image.height

    if ($h -lt $w) {
        $h = $h / ($w / $DESIRED_WIDTH)
        $w = $DESIRED_WIDTH
    } else {
        $w = $w / ($h / $DESIRED_HEIGHT)
        $h = $DESIRED_HEIGHT
    }

    $interpolation = if ($DESIRED_WIDTH -gt $image.width -or $DESIRED_HEIGHT -gt $image.height) { $cv.enums.INTER_CUBIC } else { $cv.enums.INTER_AREA }

    if (!$NoShow) {
        $Title = if ([string]::IsNullOrEmpty($Title)) { "" } else { $Title }
        $img = $cv.resize($Image, @($w, $h), [OpenCvComInterop]::Params(@{ interpolation = $interpolation }))
        $cv.imshow($Title, $img.convertToShow())
    }

    $w / $Image.width
}

[MediapipeComInterop]::DllOpen($OpenCVWorldDll, $MediapipeComDll)
[OpenCvComInterop]::DllOpen($OpenCVWorldDll, $OpenCVComDll)

if ($Register) {
    [MediapipeComInterop]::Register()
    [OpenCvComInterop]::Register()

}

Main

if ($Unregister) {
    [OpenCvComInterop]::Unregister()
    [MediapipeComInterop]::Unregister()

}

[OpenCvComInterop]::DllClose()
[MediapipeComInterop]::DllClose()
