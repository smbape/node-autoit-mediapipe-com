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
$Image = if ([string]::IsNullOrEmpty($Image)) { _Mediapipe_FindFile "examples\data\ilya-mirnyy-fU3EJRO_qGY-unsplash.jpg" } else { $Image }

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

    # Preview the images.
    resize_and_show -title "preview" -image $image | Out-Null

    $mp_selfie_segmentation = $mp.solutions.selfie_segmentation

    # Show segmentation masks.
    $BG_COLOR = @(192, 192, 192) # gray
    $MASK_COLOR = @(255, 255, 255) # white

    # Run MediaPipe Face Mesh
    $selfie_segmentation = $mp_selfie_segmentation.SelfieSegmentation()

    # Convert the BGR image to RGB and process it with MediaPipe Selfie Segmentation.
    $results = $selfie_segmentation.process($cv.cvtColor($image, $cv.enums.COLOR_BGR2RGB))
    if (-not $results["segmentation_mask"]) {
        Write-Output "No selfie segmentation for $image_path"
        return
    }

    # Generate solid color images for showing the output selfie segmentation mask.
    $fg_image = [OpenCvComInterop]::ObjCreate("Mat").create($image.size(), $cv.core.cv_8UC3, $MASK_COLOR)
    $bg_image = [OpenCvComInterop]::ObjCreate("Mat").create($image.size(), $cv.core.cv_8UC3, $BG_COLOR)

    $segmentation_mask = $cv.compare($results["segmentation_mask"], 0.2, $cv.enums.CMP_GT)

    $output_image = $bg_image.copy()
    $fg_image.copyTo($segmentation_mask, $output_image) | Out-Null

    resize_and_show -title "Segmentation mask" -image $output_image | Out-Null

    # Blur the image background based on the segmentation mask.
    $blurred_image = $cv.GaussianBlur($image, @(55, 55), 0)
    $image.copyTo($segmentation_mask, $blurred_image) | Out-Null

    resize_and_show -title "Blurred background" -image $blurred_image | Out-Null

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
