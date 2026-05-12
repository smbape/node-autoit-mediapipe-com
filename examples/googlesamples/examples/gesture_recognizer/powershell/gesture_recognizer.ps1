#requires -version 5.0

[CmdletBinding()]
param (
    [string[]] $ImageFileNames = $null,
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

$DefaultImageFileNames = @('thumbs_down.jpg', 'victory.jpg', 'thumbs_up.jpg', 'pointing_up.jpg')

$ImageFileNames = if ($ImageFileNames -eq $null -or @($ImageFileNames).Count -eq 0) { $DefaultImageFileNames } else { $ImageFileNames }


$mp = $null
$cv = $null
$autoit = $null
$vision = $null

$mp_hands = $null
$mp_drawing = $null
$mp_drawing_styles = $null


function Main() {
    # STEP 1: Import the necessary modules.
    $download_utils = [MediapipeComInterop]::ObjCreate("mediapipe.tasks.autoit.core.download_utils")
    $mp = [MediapipeComInterop]::ObjCreate("mediapipe")
    $cv = [OpenCvComInterop]::ObjCreate("cv")
    $autoit = [MediapipeComInterop]::ObjCreate("mediapipe.tasks.autoit")
    $vision = [MediapipeComInterop]::ObjCreate("mediapipe.tasks.autoit.vision")

    $mp_hands = $mp.tasks.vision.HandLandmarksConnections
    $mp_drawing = $mp.tasks.vision.drawing_utils
    $mp_drawing_styles = $mp.tasks.vision.drawing_styles

    $_MODEL_FILE = "$MEDIAPIPE_SAMPLES_DATA_PATH\gesture_recognizer.task"
    $_MODEL_URL = "https://storage.googleapis.com/mediapipe-models/gesture_recognizer/gesture_recognizer/float16/1/gesture_recognizer.task"

    $sample_files = @(
        @($_MODEL_FILE, $_MODEL_URL),
        $ImageFileNames
    )

    foreach ($i in (1..($sample_files.Count - 1))) {
        $config = $sample_files[$i] -split "@", 2
        if ($config.Count -eq 1) {
            $name = $config[0]
            $sample_files[$i] = @("$MEDIAPIPE_SAMPLES_DATA_PATH\$name", "https://storage.googleapis.com/mediapipe-tasks/gesture_recognizer/$name")
        } else {
            $name = $config[0]
            $url = $config[1]
            $sample_files[$i] = @("$MEDIAPIPE_SAMPLES_DATA_PATH\$name", $url)
        }
    }

    foreach ($i in (0..($ImageFileNames.Count - 1))) {
        $ImageFileNames[$i] = ($ImageFileNames[$i] -split "@", 2)[0]
    }

    foreach($config in $sample_files) {
        $file_path = $config[0]
        $url = $config[1]

        if (!(Test-Path -Path $file_path)) {
            $download_utils.download($url, $file_path)
        }
    }

    # STEP 2: Create a GestureRecognizer object.
    $base_options = $autoit.BaseOptions([MediapipeComInterop]::Params(@{model_asset_path = $_MODEL_FILE}))
    $options = $vision.GestureRecognizerOptions([MediapipeComInterop]::Params(@{base_options = $base_options}))
    $recognizer = $vision.GestureRecognizer.create_from_options($options)

    foreach ($image_file_name in $ImageFileNames) {
        # STEP 3: Load the input image.
        $image = $mp.Image.create_from_file("$MEDIAPIPE_SAMPLES_DATA_PATH\$image_file_name")

        # STEP 4: Recognize gestures in the input image.
        $recognition_result = $recognizer.recognize($image)

        # STEP 5: Process the result. In this case, visualize it.
        $top_gesture = $recognition_result.gestures[0][0]
        $hands_landmarks = $recognition_result.hand_landmarks
        Display-ImageWithGesturesAndHandLandmarks -Image $image -Gesture $top_gesture -HandsLandmarks $hands_landmarks
    }

    $cv.waitKey() | Out-Null
}

<#
Displays an image with the gesture category and its score along with the hand landmarks.
#>
function Display-ImageWithGesturesAndHandLandmarks($Image, $Gesture, $HandsLandmarks) {
    # Display gestures and hand landmarks.
    $annotated_image = $cv.cvtColor($Image.mat_view(), $cv.enums.COLOR_RGB2BGR)
    $title = "{0} ({1:f2})" -f $Gesture.category_name, $Gesture.score

    # Compute the scale to make drawn elements visible when the image is resized for display
    $scale = 1 / (Resize-And-Show -Image $annotated_image -NoShow)

    foreach ($hand_landmarks in $HandsLandmarks) {
        $mp_drawing.draw_landmarks(
                $annotated_image,
                $hand_landmarks,
                $mp_hands.HAND_CONNECTIONS,
                $mp_drawing_styles.get_default_hand_landmarks_style($scale),
                $mp_drawing_styles.get_default_hand_connections_style($scale))
    }

    Resize-And-Show -Image $annotated_image -Title $title | Out-Null
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
