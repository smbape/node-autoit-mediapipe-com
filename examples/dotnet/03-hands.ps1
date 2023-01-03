#requires -version 5.0

[CmdletBinding()]
param (
    [string] $Image = $null,
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
trap { throw $Error[0] }

Import-Module "$PSScriptRoot\mediapipe_utils.psm1" -ArgumentList $BuildType
Import-Module ( _Mediapipe_FindFile -Path "opencv_utils.psm1" -SearchPaths @(".", "autoit-opencv-com", "autoit-opencv-com\dotnet") ) -ArgumentList $BuildType

$BuildType = if ($BuildType -eq "Debug") { "Debug" } else { "Release" }

$OpenCVWorldDll = if ([string]::IsNullOrEmpty($OpenCVWorldDll)) { _OpenCV_FindDLL "opencv_world470*" -BuildType $BuildType } else { $OpenCVWorldDll }
$OpenCVComDll = if ([string]::IsNullOrEmpty($OpenCVComDll)) { _OpenCV_FindDLL "autoit_opencv_com470*" -BuildType $BuildType } else { $OpenCVComDll }
$MediapipeComDll = if ([string]::IsNullOrEmpty($MediapipeComDll)) { _Mediapipe_FindDLL "autoit_mediapipe_com-*-470*" -BuildType $BuildType } else { $MediapipeComDll }
$ResourceDir = if ([string]::IsNullOrEmpty($ResourceDir)) { _Mediapipe_FindResourceDir -BuildType $BuildType } else { $ResourceDir }
$Image = if ([string]::IsNullOrEmpty($Image)) { _Mediapipe_FindFile "examples\data\brooke-cagle-mt2fyrdXxzk-unsplash.jpg" } else { $Image }

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
    $image_path = "$Image"
    $image = $cv.imread($image_path)

    $mp_hands = $mp.solutions.hands
    $mp_drawing = $mp.solutions.drawing_utils
    $mp_drawing_styles = $mp.solutions.drawing_styles

    # Preview the images.
    $ratio = resize_and_show -title "preview" -image $image
    $scale = 1 / $ratio

    # Run MediaPipe Hands
    $hands = $mp_hands.Hands([MediapipeComInterop]::Params([ref] @{
        static_image_mode = $true;
        max_num_hands = 2;
        min_detection_confidence = 0.7
    }))

    # Convert the BGR image to RGB, flip the image around y-axis for correct
    # handedness output and process it with MediaPipe Hands.
    $results = $hands.process($cv.flip($cv.cvtColor($image, $cv.enums.COLOR_BGR2RGB), 1))

    Write-Output "Handedness of $image_path"
    foreach ($classificationList in $results["multi_handedness"]) {
        foreach ($classification in $classificationList.classification) {
            Write-Output $classification.__str__()
        }
    }

    if (-not $results["multi_hand_landmarks"]) {
        Write-Output "No hand detection for $image_path"
    }

    # Draw hand landmarks of each hand.
    Write-Output "Hand landmarks of ${image_path}:"
    $image_width = $image.width
    $image_height = $image.height
    $annotated_image = $cv.flip($image.copy(), 1)

    # Draw face detections of each face.
    foreach ($hand_landmarks in $results["multi_hand_landmarks"]) {
        # Print index finger tip coordinates.
        Write-Output `
                "Index finger tip coordinate: ( `
                $($hand_landmarks.landmark($mp_hands.HandLandmark.INDEX_FINGER_TIP).x * $image_width), `
                $($hand_landmarks.landmark($mp_hands.HandLandmark.INDEX_FINGER_TIP).y * $image_height))"
        $mp_drawing.draw_landmarks(
                $annotated_image,
                $hand_landmarks,
                $mp_hands.HAND_CONNECTIONS,
                $mp_drawing_styles.get_default_hand_landmarks_style($scale),
                $mp_drawing_styles.get_default_hand_connections_style($scale))
    }

    resize_and_show -title "hands" -image $annotated_image | Out-Null

    $cv.waitKey() | Out-Null
    $cv.destroyAllWindows()
}

[MediapipeComInterop]::DllOpen($OpenCVWorldDll, $MediapipeComDll)
[OpenCvComInterop]::DllOpen($OpenCVWorldDll, $OpenCVComDll)

if ($Register) {
    [MediapipeComInterop]::Register()
    [OpenCvComInterop]::Register()
}

$resource_util = [MediapipeComInterop]::ObjCreate("mediapipe.autoit._framework_bindings.resource_util")
$resource_util.set_resource_dir($ResourceDir)

$cv = [OpenCvComInterop]::ObjCreate("cv")
$mp = [MediapipeComInterop]::ObjCreate("mediapipe")

Example

if ($Unregister) {
    [OpenCvComInterop]::Unregister()
    [MediapipeComInterop]::Unregister()
}

[OpenCvComInterop]::DllClose()
[MediapipeComInterop]::DllClose()
