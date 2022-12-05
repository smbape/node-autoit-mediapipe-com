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
    $results = $face_mesh.process($cv.cvtColor($image, $cv.COLOR_BGR2RGB_))
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
                connection_drawing_spec = $mp_drawing_styles.get_default_face_mesh_contours_style($scale)}))
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
