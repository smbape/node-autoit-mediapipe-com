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

$DefaultImageFile = "$MEDIAPIPE_SAMPLES_DATA_PATH\business-person.png"
$DefaultImageUrl = "https://storage.googleapis.com/mediapipe-assets/business-person.png"

$ImageFile = if ([string]::IsNullOrEmpty($ImageFile)) { $DefaultImageFile } else { $ImageFile }
$ImageUrl = if ([string]::IsNullOrEmpty($ImageUrl)) { $DefaultImageUrl } else { $ImageUrl }


$mp = $null
$cv = $null
$autoit = $null
$vision = $null
$drawing_utils = $null
$drawing_styles = $null


function Main() {
    # STEP 1: Import the necessary modules.
    $download_utils = [MediapipeComInterop]::ObjCreate("mediapipe.tasks.autoit.core.download_utils")
    $mp = [MediapipeComInterop]::ObjCreate("mediapipe")
    $cv = [OpenCvComInterop]::ObjCreate("cv")
    $autoit = [MediapipeComInterop]::ObjCreate("mediapipe.tasks.autoit")
    $vision = [MediapipeComInterop]::ObjCreate("mediapipe.tasks.autoit.vision")
    $drawing_utils = [MediapipeComInterop]::ObjCreate("mediapipe.tasks.autoit.vision.drawing_utils")
    $drawing_styles = [MediapipeComInterop]::ObjCreate("mediapipe.tasks.autoit.vision.drawing_styles")

    $_IMAGE_FILE = $ImageFile
    $_IMAGE_URL = $ImageUrl
    $_MODEL_FILE = "$MEDIAPIPE_SAMPLES_DATA_PATH\face_landmarker.task"
    $_MODEL_URL = "https://storage.googleapis.com/mediapipe-models/face_landmarker/face_landmarker/float16/1/face_landmarker.task"

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

    # STEP 2: Create a FaceLandmarker object.
    $base_options = $autoit.BaseOptions([MediapipeComInterop]::Params(@{model_asset_path = $_MODEL_FILE}))
    $options = $vision.FaceLandmarkerOptions([MediapipeComInterop]::Params(@{base_options = $base_options
            output_face_blendshapes = $true
            output_facial_transformation_matrixes = $true
            num_faces = 1}))
    $detector = $vision.FaceLandmarker.create_from_options($options)

    # STEP 3: Load the input image.
    $image = $mp.Image.create_from_file($_IMAGE_FILE)

    # Compute the scale to make drawn elements visible when the image is resized for display
    $scale = 1 / (Resize-And-Show -Image $image.mat_view() -NoShow)

    # STEP 4: Detect hand landmarks from the input image.
    $detection_result = $detector.detect($image)

    # STEP 5: Process the classification result. In this case, visualize it.
    $annotated_image = Draw-LandmarksOnImage -Image $image.mat_view() -DetectionResult $detection_result
    Resize-And-Show -Image $annotated_image -Title "face_landmarker" | Out-Null
    $cv.waitKey() | Out-Null
}

function Draw-LandmarksOnImage($Image, $DetectionResult) {
    # Compute the scale to make drawn elements visible when the image is resized for display
    $scale = 1 / (Resize-And-Show -Image $Image -NoShow)

    $face_landmarks_list = $DetectionResult.face_landmarks
    $annotated_image = $cv.cvtColor($Image, $cv.enums.COLOR_RGB2BGR)

    # Loop through the detected faces to visualize.
    foreach ($face_landmarks In $face_landmarks_list) {

        # Draw the face landmarks.

        $drawing_utils.draw_landmarks([MediapipeComInterop]::Params(@{
            image = $annotated_image
            landmark_list = $face_landmarks
            connections = $vision.FaceLandmarksConnections.FACE_LANDMARKS_TESSELATION
            landmark_drawing_spec = [DBNull]::Value
            connection_drawing_spec = $drawing_styles.get_default_face_mesh_tesselation_style($scale)}))
        $drawing_utils.draw_landmarks([MediapipeComInterop]::Params(@{
            image = $annotated_image
            landmark_list = $face_landmarks
            connections = $vision.FaceLandmarksConnections.FACE_LANDMARKS_CONTOURS
            landmark_drawing_spec = [DBNull]::Value
            connection_drawing_spec = $drawing_styles.get_default_face_mesh_contours_style(1, $scale)}))
        $drawing_utils.draw_landmarks([MediapipeComInterop]::Params(@{
            image = $annotated_image
            landmark_list = $face_landmarks
            connections = $vision.FaceLandmarksConnections.FACE_LANDMARKS_LEFT_IRIS
            landmark_drawing_spec = [DBNull]::Value
            connection_drawing_spec = $drawing_styles.get_default_face_mesh_iris_connections_style($scale)}))
        $drawing_utils.draw_landmarks([MediapipeComInterop]::Params(@{
            image = $annotated_image
            landmark_list = $face_landmarks
            connections = $vision.FaceLandmarksConnections.FACE_LANDMARKS_RIGHT_IRIS
            landmark_drawing_spec = [DBNull]::Value
            connection_drawing_spec = $drawing_styles.get_default_face_mesh_iris_connections_style($scale)}))
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
