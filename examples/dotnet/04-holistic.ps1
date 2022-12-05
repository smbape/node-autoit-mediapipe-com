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
$Image = if ([string]::IsNullOrEmpty($Image)) { _Mediapipe_FindFile "examples\data\thao-lee-v4zceVZ5HK8-unsplash.jpg" } else { $Image }

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

    $interpolation = if ($DESIRED_WIDTH -gt $width -or $DESIRED_HEIGHT -gt $height) { $cv.INTER_CUBIC_ } else { $cv.INTER_AREA_ }

    $img = $cv.resize($image, @($w, $h), [OpenCvComInterop]::Params([ref] @{ interpolation = $interpolation }))
    $cv.imshow($title, $img.convertToShow())
    $w / $width
}

function Example() {
    $image_path = "$Image"
    $image = $cv.imread($image_path)

    $mp_holistic = $mp.solutions.holistic
    $mp_drawing = $mp.solutions.drawing_utils
    $mp_drawing_styles = $mp.solutions.drawing_styles

    # Preview the images.
    $ratio = resize_and_show -title "preview" -image $image
    $scale = 1 / $ratio

    # Run MediaPipe Holistic and draw pose landmarks.
    $holistic = $mp_holistic.Holistic([MediapipeComInterop]::Params([ref] @{
        static_image_mode = $true;
        min_detection_confidence = 0.7;
        model_complexity = 2
    }))

    # Convert the BGR image to RGB and process it with MediaPipe Holistic.
    $results = $holistic.process($cv.cvtColor($image, $cv.COLOR_BGR2RGB_))

    if (-not $results["pose_landmarks"]) {
        Write-Output "No holistic detection for $image_path"
    }

    # enlarge/shrink drawings to keep them visible after resize
    $landmark_drawing_spec = $mp_drawing.DrawingSpec($mp_drawing.RED_COLOR)
    $landmark_drawing_spec.thickness *= $scale
    $landmark_drawing_spec.circle_radius *= $scale

    $connection_drawing_spec = $mp_drawing.DrawingSpec()
    $connection_drawing_spec.thickness *= $scale
    $connection_drawing_spec.circle_radius *= $scale

    # Print nose coordinates.
    $image_width = $image.width
    $image_height = $image.height
    Write-Output  `
            "Nose coordinates: ( `
            $($results["pose_landmarks"].landmark($mp_holistic.PoseLandmark.NOSE).x * $image_width), `
            $($results["pose_landmarks"].landmark($mp_holistic.PoseLandmark.NOSE).y * $image_height) )"

    # Draw pose landmarks.
    Write-Output "Pose landmarks of ${image_path}:"
    $annotated_image = $image.copy()
    $mp_drawing.draw_landmarks($annotated_image, $results["left_hand_landmarks"], $mp_holistic.HAND_CONNECTIONS, $landmark_drawing_spec)
    $mp_drawing.draw_landmarks($annotated_image, $results["right_hand_landmarks"], $mp_holistic.HAND_CONNECTIONS, $landmark_drawing_spec)
    $mp_drawing.draw_landmarks(
            $annotated_image,
            $results["face_landmarks"],
            $mp_holistic.FACEMESH_TESSELATION,
            [MediapipeComInterop]::Params([ref] @{
                landmark_drawing_spec = $null;
                connection_drawing_spec = $mp_drawing_styles.get_default_face_mesh_tesselation_style($scale)
            }))
    $mp_drawing.draw_landmarks(
            $annotated_image,
            $results["pose_landmarks"],
            $mp_holistic.POSE_CONNECTIONS,
            [MediapipeComInterop]::Params([ref] @{
                landmark_drawing_spec = $mp_drawing_styles.get_default_pose_landmarks_style($scale);
                connection_drawing_spec = $connection_drawing_spec
            }))

    resize_and_show -title "holistic" -image $annotated_image | Out-Null

    # Run MediaPipe Holistic withenable_segmentation=$true` to get pose segmentation.
    $holistic = $mp_holistic.Holistic([MediapipeComInterop]::Params([ref] @{
        static_image_mode = $true;
        enable_segmentation = $true
    }))

    $results = $holistic.process($cv.cvtColor($image, $cv.COLOR_BGR2RGB_))

    # Draw pose segmentation.
    Write-Output "Pose segmentation of ${image_path}:"
    $annotated_image = $image.copy()
    $red_img = [OpenCvComInterop]::ObjCreate("Mat").create($image.rows, $image.cols, $cv.core.cv_32FC3, @(255, 255, 255))
    $segm_2class = $cv.add($cv.multiply($results["segmentation_mask"], 0.8), 0.2)
    $segm_2class = $cv.merge(@($segm_2class, $segm_2class, $segm_2class))
    $annotated_image = $cv.multiply($annotated_image.convertTo($cv.core.cv_32F), $segm_2class)
    $red_img = $cv.multiply($red_img, $cv.subtract(1.0, $segm_2class))
    $annotated_image = $cv.add($annotated_image, $red_img)
    resize_and_show -title "segmentation" -image $annotated_image | Out-Null

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
