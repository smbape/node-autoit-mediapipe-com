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

$BuildType = if ($BuildType -eq "Debug") { "Debug" } else { "RelWithDebInfo" }

$OpenCVWorldDll = if ([string]::IsNullOrEmpty($OpenCVWorldDll)) { _OpenCV_FindDLL "opencv_world4*" "opencv-4.*\opencv" -BuildType $BuildType } else { $OpenCVWorldDll }
$OpenCVComDll = if ([string]::IsNullOrEmpty($OpenCVComDll)) { _OpenCV_FindDLL "autoit_opencv_com4*" -BuildType $BuildType } else { $OpenCVComDll }
$MediapipeComDll = if ([string]::IsNullOrEmpty($MediapipeComDll)) { _Mediapipe_FindDLL "autoit_mediapipe_com-*" -BuildType $BuildType } else { $MediapipeComDll }
$ResourceDir = if ([string]::IsNullOrEmpty($ResourceDir)) { _Mediapipe_FindResourceDir -BuildType $BuildType } else { $ResourceDir }
$Image = if ([string]::IsNullOrEmpty($Image)) { _Mediapipe_FindFile "examples\data\garrett-jackson-auTAb39ImXg-unsplash.jpg" } else { $Image }

function resize_and_show([string] $title, [Object] $image) {
    $DESIRED_HEIGHT = 480
    $DESIRED_WIDTH = 480
    $w = $image.width
    $h = $image.height

    if ($h -lt $w) {
        $h = $h / ($w / $DESIRED_WIDTH)
        $w = $DESIRED_WIDTH
    } else {
        $w = $w / ($h / $DESIRED_HEIGHT)
        $h = $DESIRED_HEIGHT
    }

    $interpolation = if ($DESIRED_WIDTH -gt $image.width -or $DESIRED_HEIGHT -gt $image.height) { $cv.INTER_CUBIC_ } else { $cv.INTER_AREA_ }

    $img = $cv.resize($image, @($w, $h), [OpenCvComInterop]::Params([ref] @{ interpolation = $interpolation }))
    $cv.imshow($title, $img.convertToShow())

    $img.width / $image.width
}

function Example() {

    $image_path = "$Image"
    $image = $cv.imread($image_path)

    # Preview the images.
    $ratio = resize_and_show -title "preview" -image $image

    $mp_face_detection = $mp.solutions.face_detection
    $mp_drawing = $mp.solutions.drawing_utils

    # Run MediaPipe Face Detection
    $face_detection = $mp_face_detection.FaceDetection()

    # Convert the BGR image to RGB and process it with MediaPipe Face Detection.
    $results = $face_detection.process($cv.cvtColor($image, $cv.COLOR_BGR2RGB_))
    if (-not $results["detections"]) {
        Write-Error "No face detection for $image_path"
        return
    }

    # enlarge/shrink drawings to keep them visible after resize
    $thickness = 2 / $ratio
    $keypoint_drawing_spec = $mp_drawing.DrawingSpec($mp_drawing.RED_COLOR, $thickness, $thickness)
    $bbox_drawing_spec = $mp_drawing.DrawingSpec($mp_drawing.WHITE_COLOR, $thickness, $thickness)

    # Draw face detections of each face.
    foreach ($detection in $results["detections"]) {
        $mp_drawing.draw_detection($image, $detection, $keypoint_drawing_spec, $bbox_drawing_spec)
    }

    resize_and_show -title "face detection" -image $image | Out-Null

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
