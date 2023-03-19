<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [Mediapipe autoit udf](#mediapipe-autoit-udf)
- [Usage of the UDF](#usage-of-the-udf)
  - [Prerequisites](#prerequisites)
  - [Usage](#usage)
    - [AutoIt](#autoit)
    - [PowerShell](#powershell)
    - [csharp](#csharp)
      - [Runtime example](#runtime-example)
      - [Compile time example](#compile-time-example)
  - [Running examples](#running-examples)
  - [Developpement](#developpement)
    - [Prerequisites](#prerequisites-1)
    - [Environment](#environment)
    - [Generate the UDF files](#generate-the-udf-files)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

# Mediapipe autoit udf

Partial COM+ binding to [mediapipe](https://google.github.io/mediapipe/)

# Usage of the UDF

## Prerequisites

  - Download and extract [opencv-4.7.0-windows.exe](https://opencv.org/releases/) into a folder
  - Download and extract [autoit-opencv-4.7.0-com-v2.3.1.7z](https://github.com/smbape/node-autoit-opencv-com/releases/download/v2.3.1/autoit-opencv-4.7.0-com-v2.3.1.7z) into a folder
  - Download and extract [autoit-mediapipe-0.9.1-opencv-4.7.0-com-v0.3.0.7z](https://github.com/smbape/node-autoit-mediapipe-com/releases/download/v0.3.0/autoit-mediapipe-0.9.1-opencv-4.7.0-com-v0.3.0.7z) into a folder

## Usage

### AutoIt

```autoit
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Change2CUI=y
#AutoIt3Wrapper_Au3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#include "autoit-mediapipe-com\udf\mediapipe_udf_utils.au3"
#include "autoit-opencv-com\udf\opencv_udf_utils.au3"

_Mediapipe_Open("opencv-4.7.0-windows\opencv\build\x64\vc16\bin\opencv_world470.dll", "autoit-mediapipe-com\autoit_mediapipe_com-0.9.1-470.dll")
_OpenCV_Open("opencv-4.7.0-windows\opencv\build\x64\vc16\bin\opencv_world470.dll", "autoit-opencv-com\autoit_opencv_com470.dll")
OnAutoItExitRegister("_OnAutoItExit")

; Tell mediapipe where to look its resource files
_Mediapipe_SetResourceDir()

Global $mp = _Mediapipe_get()
If Not IsObj($mp) Then
  ConsoleWriteError("Failed to load mediapipe" & @CRLF)
  Exit
EndIf

Global $cv = _OpenCV_get()
If Not IsObj($cv) Then
  ConsoleWriteError("Failed to load opencv" & @CRLF)
  Exit
EndIf

Example()

Func Example()
  Local $download_utils = $mp.solutions.download_utils

  $download_utils.download( _
      "https://github.com/tensorflow/tfjs-models/raw/master/face-detection/test_data/portrait.jpg", _
      @ScriptDir & "/testdata/portrait.jpg" _
      )

  Local $mp_face_mesh = $mp.solutions.face_mesh
  Local $mp_drawing = $mp.solutions.drawing_utils
  Local $mp_drawing_styles = $mp.solutions.drawing_styles

  Local $image_path = @ScriptDir & "/testdata/portrait.jpg"
  Local $image = $cv.imread($image_path)

  ; Preview the images.
  Local $ratio = resize_and_show("preview", $image)
  Local $scale = 1 / $ratio

  ; Run MediaPipe Face Mesh
  Local $face_mesh = $mp_face_mesh.FaceMesh(_Mediapipe_Params( _
      "static_image_mode", True, _
      "refine_landmarks", True, _
      "max_num_faces", 2, _
      "min_detection_confidence", 0.5 _
      ))

  ; Convert the BGR image to RGB and process it with MediaPipe Face Mesh.
  Local $results = $face_mesh.process($cv.cvtColor($image, $CV_COLOR_BGR2RGB))
  If $results("multi_face_landmarks") == Default Then
    ConsoleWrite("No face detection for " & $image_path & @CRLF)
    Return
  EndIf

  Local $annotated_image = $image.copy()

  ; Draw face detections of each face.
  For $face_landmarks In $results("multi_face_landmarks")
    $mp_drawing.draw_landmarks(_Mediapipe_Params( _
        "image", $annotated_image, _
        "landmark_list", $face_landmarks, _
        "connections", $mp_face_mesh.FACEMESH_TESSELATION, _
        "landmark_drawing_spec", Null, _
        "connection_drawing_spec", $mp_drawing_styles.get_default_face_mesh_tesselation_style($scale)))
    $mp_drawing.draw_landmarks(_Mediapipe_Params( _
        "image", $annotated_image, _
        "landmark_list", $face_landmarks, _
        "connections", $mp_face_mesh.FACEMESH_CONTOURS, _
        "landmark_drawing_spec", Null, _
        "connection_drawing_spec", $mp_drawing_styles.get_default_face_mesh_contours_style($scale)))
    $mp_drawing.draw_landmarks(_Mediapipe_Params( _
        "image", $annotated_image, _
        "landmark_list", $face_landmarks, _
        "connections", $mp_face_mesh.FACEMESH_IRISES, _
        "landmark_drawing_spec", Null, _
        "connection_drawing_spec", $mp_drawing_styles.get_default_face_mesh_iris_connections_style($scale)))
  Next

  resize_and_show("face mesh", $annotated_image)

  ; display images until a keyboard action is detected
  $cv.waitKey()
  $cv.destroyAllWindows()
EndFunc   ;==>Example

Func resize_and_show($title, $image)
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

  Local $img = $cv.resize($image, _OpenCV_Size($w, $h), _OpenCV_Params("interpolation", $interpolation))
  $cv.imshow($title, $img.convertToShow())

  Return $img.width / $image.width
EndFunc   ;==>resize_and_show

Func _OnAutoItExit()
  _OpenCV_Close()
  _Mediapipe_Close()
EndFunc   ;==>_OnAutoItExit
```

### PowerShell

`powershell.exe -ExecutionPolicy UnRestricted -File example.ps1`

```powershell
#requires -version 5.0

Import-Module .\autoit-mediapipe-com\dotnet\mediapipe_utils.psm1
Import-Module .\autoit-opencv-com\dotnet\opencv_utils.psm1

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
    $image_path = _Mediapipe_FindFile "examples\data\garrett-jackson-auTAb39ImXg-unsplash.jpg"
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
    $results = $face_mesh.process($cv.cvtColor($image, $cv.enums.COLOR_BGR2RGB))
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

[MediapipeComInterop]::DllOpen("opencv-4.7.0-windows\opencv\build\x64\vc16\bin\opencv_world470.dll", "autoit-mediapipe-com\autoit_mediapipe_com-0.9.1-470.dll")
[OpenCvComInterop]::DllOpen("opencv-4.7.0-windows\opencv\build\x64\vc16\bin\opencv_world470.dll", "autoit-opencv-com\autoit_opencv_com470.dll")

$resource_util = [MediapipeComInterop]::ObjCreate("mediapipe.autoit._framework_bindings.resource_util")
$resource_util.set_resource_dir("autoit-mediapipe-com")

$cv = [OpenCvComInterop]::ObjCreate("cv")
$mp = [MediapipeComInterop]::ObjCreate("mediapipe")

Example

[MediapipeComInterop]::DllClose()
[OpenCvComInterop]::DllClose()
```
### csharp

Open `x64 Native Tools Command Prompt for VS 2022`


#### Runtime example

`csc.exe example-runtime.cs autoit-opencv-com\dotnet\OpenCvComInterop.cs autoit-mediapipe-com\dotnet\MediapipeComInterop.cs && example-runtime.exe`

```cs
using System;
using System.Collections;
using System.ComponentModel;
using System.Runtime.InteropServices;

public static class Test
{
    private static readonly int DISP_E_PARAMNOTFOUND = -2147352572;

    private static readonly int DESIRED_HEIGHT = 480;
    private static readonly int DESIRED_WIDTH = 480;

    private static void Example()
    {
        var cv = OpenCvComInterop.ObjCreate("cv");
        if (ReferenceEquals(cv, null))
        {
            throw new Win32Exception(Marshal.GetLastWin32Error(), "Failed to create cv com");
        }

        var mp = MediapipeComInterop.ObjCreate("mediapipe");
        if (ReferenceEquals(mp, null))
        {
            throw new Win32Exception(Marshal.GetLastWin32Error(), "Failed to create mp com");
        }

        var image_path = OpenCvComInterop.FindFile("examples\\data\\garrett-jackson-auTAb39ImXg-unsplash.jpg");
        var image = cv.imread(image_path);

        // Preview the images.
        var ratio = ResizeAndShow(cv, "preview", image);

        var mp_face_detection = mp.solutions.face_detection;
        var mp_drawing = mp.solutions.drawing_utils;

        // Run MediaPipe Face Detection
        var face_detection = mp_face_detection.FaceDetection.create();

        // Convert the BGR image to RGB and process it with MediaPipe Face Detection.
        var results = face_detection.process(cv.cvtColor(image, cv.enums.COLOR_BGR2RGB));
        if (DISP_E_PARAMNOTFOUND.Equals(results["detections"]))
        {
            Console.Error.WriteLine("No face detection for " + image_path);
            return;
        }

        // enlarge/shrink drawings to keep them visible after resize
        var thickness = 2 / ratio;
        var keypoint_drawing_spec = mp_drawing.DrawingSpec.create(mp_drawing.RED_COLOR, thickness, thickness);
        var bbox_drawing_spec = mp_drawing.DrawingSpec.create(mp_drawing.WHITE_COLOR, thickness, thickness);

        // Draw face detections of each face.
        foreach (var detection in results["detections"])
        {
            mp_drawing.draw_detection(image, detection, keypoint_drawing_spec, bbox_drawing_spec);
        }

        ResizeAndShow(cv, "face detection", image);

        cv.waitKey();
        cv.destroyAllWindows();
    }

    private static float ResizeAndShow(dynamic cv, string title, dynamic image)
    {
        float w = image.width;
        float h = image.height;

        if (h < w)
        {
            h = h / (w / DESIRED_WIDTH);
            w = DESIRED_WIDTH;
        }
        else
        {
            w = w / (h / DESIRED_HEIGHT);
            h = DESIRED_HEIGHT;
        }

        int interpolation = DESIRED_WIDTH > image.width || DESIRED_HEIGHT > image.height ? cv.enums.INTER_CUBIC : cv.enums.INTER_AREA;

        dynamic[] size = { w, h };
        var kwargs = new Hashtable() {
            { "interpolation", interpolation },
        };

        dynamic img = cv.resize(image, size, OpenCvComInterop.Params(ref kwargs));
        cv.imshow(title, img.convertToShow());

        return (float)img.width / image.width;
    }

    static void Main(String[] args)
    {
        OpenCvComInterop.DllOpen(
            "opencv-4.7.0-windows\\opencv\\build\\x64\\vc16\\bin\\opencv_world470.dll",
            "autoit-opencv-com\\autoit_opencv_com470.dll"
        );

        MediapipeComInterop.DllOpen(
            "opencv-4.7.0-windows\\opencv\\build\\x64\\vc16\\bin\\opencv_world470.dll",
            "autoit-mediapipe-com\\autoit_mediapipe_com-0.9.1-470.dll"
        );

        var resourceDir = MediapipeComInterop.FindResourceDir();
        var resource_util = MediapipeComInterop.ObjCreate("mediapipe.autoit._framework_bindings.resource_util");
        resource_util.set_resource_dir(resourceDir);

        Example();

        MediapipeComInterop.DllClose();
        OpenCvComInterop.DllClose();
    }
}
```

#### Compile time example

`csc.exe example-compile.cs /link:autoit-opencv-com\dotnet\OpenCV.InteropServices.dll /link:autoit-mediapipe-com\dotnet\Mediapipe.InteropServices.dll autoit-opencv-com\dotnet\OpenCvComInterop.cs autoit-mediapipe-com\dotnet\MediapipeComInterop.cs && example-compile.exe`

```cs
using System;
using System.Collections;
using System.ComponentModel;
using System.Runtime.InteropServices;
using Mediapipe.InteropServices;
using Cv_Object = OpenCV.InteropServices.Cv_Object;
using ICv_Object = OpenCV.InteropServices.ICv_Object;

public static class Test
{
#if DEBUG
    private static readonly string DEBUG_PREFIX = "d";
#else
    private static readonly string DEBUG_PREFIX = "";
#endif

    private static readonly int DISP_E_PARAMNOTFOUND = -2147352572;

    private static readonly int DESIRED_HEIGHT = 480;
    private static readonly int DESIRED_WIDTH = 480;

    private static void Example()
    {
        ICv_Object cv = new Cv_Object();
        IMediapipe_Object mp = new Mediapipe_Object();

        var image_path = OpenCvComInterop.FindFile("examples\\data\\garrett-jackson-auTAb39ImXg-unsplash.jpg");
        var image = cv.imread(image_path);

        // Preview the images.
        var ratio = ResizeAndShow(cv, "preview", image);

        var mp_face_detection = mp.solutions.face_detection;
        var mp_drawing = mp.solutions.drawing_utils;

        // Run MediaPipe Face Detection
        var face_detection = mp_face_detection.FaceDetection;

        // Convert the BGR image to RGB and process it with MediaPipe Face Detection.
        var results = face_detection.process(cv.cvtColor(image, cv.enums.COLOR_BGR2RGB));
        if (DISP_E_PARAMNOTFOUND.Equals(results["detections"]))
        {
            Console.Error.WriteLine("No face detection for " + image_path);
            return;
        }

        // enlarge/shrink drawings to keep them visible after resize
        var thickness = 2 / ratio;
        var keypoint_drawing_spec = mp_drawing.DrawingSpec[mp_drawing.RED_COLOR, thickness, thickness];
        var bbox_drawing_spec = mp_drawing.DrawingSpec[mp_drawing.WHITE_COLOR, thickness, thickness];

        // Draw face detections of each face.
        foreach (var detection in results["detections"])
        {
            mp_drawing.draw_detection(image, detection, keypoint_drawing_spec, bbox_drawing_spec);
        }

        ResizeAndShow(cv, "face detection", image);

        cv.waitKey();
        cv.destroyAllWindows();
    }

    private static float ResizeAndShow(dynamic cv, string title, dynamic image)
    {
        float w = image.width;
        float h = image.height;

        if (h < w)
        {
            h = h / (w / DESIRED_WIDTH);
            w = DESIRED_WIDTH;
        }
        else
        {
            w = w / (h / DESIRED_HEIGHT);
            h = DESIRED_HEIGHT;
        }

        int interpolation = DESIRED_WIDTH > image.width || DESIRED_HEIGHT > image.height ? cv.enums.INTER_CUBIC : cv.enums.INTER_AREA;

        dynamic[] size = { w, h };
        var kwargs = new Hashtable() {
            { "interpolation", interpolation },
        };

        dynamic img = cv.resize(image, size, OpenCvComInterop.Params(ref kwargs));
        cv.imshow(title, img.convertToShow());

        return (float)img.width / image.width;
    }

    static void Main(String[] args)
    {
        OpenCvComInterop.DllOpen(
            "opencv-4.7.0-windows\\opencv\\build\\x64\\vc16\\bin\\opencv_world470.dll",
            "autoit-opencv-com\\autoit_opencv_com470.dll"
        );

        MediapipeComInterop.DllOpen(
            "opencv-4.7.0-windows\\opencv\\build\\x64\\vc16\\bin\\opencv_world470.dll",
            "autoit-mediapipe-com\\autoit_mediapipe_com-0.9.1-470.dll"
        );

        // To make registration free works with compile time COM classes
        // the activated context needs to have all the dependencies of our application.
        // Therefore, there is a mediapipe.sxs.manifest file which declares all the dependencies
        // of our application.
        var manifest = MediapipeComInterop.FindFile($"mediapipe{DEBUG_PREFIX}.sxs.manifest", new string[] {
            ".",
            "autoit-mediapipe-com",
            "autoit-mediapipe-com\\udf"
        });

        // Make opencv com and mediapipe com to use this manifest instead of the one embeded in their respective dll
        Environment.SetEnvironmentVariable("OPENCV_ACTCTX_MANIFEST", manifest);
        Environment.SetEnvironmentVariable("MEDIAPIPE_ACTCTX_MANIFEST", manifest);

        MediapipeComInterop.DllActivateManifest();

        var resourceDir = MediapipeComInterop.FindResourceDir();
        IMediapipe_Autoit__framework_bindings_Resource_util_Object resource_util = new Mediapipe_Autoit__framework_bindings_Resource_util_Object();
        resource_util.set_resource_dir(resourceDir);

        Example();

        MediapipeComInterop.DllDeactivateActCtx();

        MediapipeComInterop.DllClose();
        OpenCvComInterop.DllClose();
    }
}
```

## Running examples

Install [7-zip](https://www.7-zip.org/download.html) and add the 7-zip folder to you system PATH environment variable

Then, in [Git Bash](https://gitforwindows.org/), execute the following commands

```sh
# download autoit-mediapipe-0.9.1-opencv-4.7.0-com-v0.3.0.7z
curl -L 'https://github.com/smbape/node-autoit-mediapipe-com/releases/download/v0.3.0/autoit-mediapipe-0.9.1-opencv-4.7.0-com-v0.3.0.7z' -o autoit-mediapipe-0.9.1-opencv-4.7.0-com-v0.3.0.7z

# extract the content of autoit-mediapipe-0.9.1-opencv-4.7.0-com-v0.3.0.7z into a folder named autoit-mediapipe-com
7z x autoit-mediapipe-0.9.1-opencv-4.7.0-com-v0.3.0.7z -aoa -oautoit-mediapipe-com

# download autoit-opencv-4.7.0-com-v2.3.1.7z
curl -L 'https://github.com/smbape/node-autoit-opencv-com/releases/download/v2.3.1/autoit-opencv-4.7.0-com-v2.3.1.7z' -o autoit-opencv-4.7.0-com-v2.3.1.7z

# extract the content of autoit-opencv-4.7.0-com-v2.3.1.7z into a folder named autoit-opencv-com
7z x autoit-opencv-4.7.0-com-v2.3.1.7z -aoa -oautoit-opencv-com

# download opencv-4.7.0-windows.exe
curl -L 'https://github.com/opencv/opencv/releases/download/4.7.0/opencv-4.7.0-windows.exe' -o opencv-4.7.0-windows.exe

# extract the content of opencv-4.7.0-windows.exe into a folder named opencv-4.7.0-windows
./opencv-4.7.0-windows.exe -oopencv-4.7.0-windows -y

# download autoit-mediapipe-0.9.1-opencv-4.7.0-com-v0.3.0-src.zip
curl -L 'https://github.com/smbape/node-autoit-mediapipe-com/archive/refs/tags/v0.3.0.zip' -o autoit-mediapipe-0.9.1-opencv-4.7.0-com-v0.3.0-src.zip

# extract the examples folder of autoit-mediapipe-0.9.1-opencv-4.7.0-com-v0.3.0-src.zip
7z x autoit-mediapipe-0.9.1-opencv-4.7.0-com-v0.3.0-src.zip -aoa 'node-autoit-mediapipe-com-0.3.0\examples'
cp -rf node-autoit-mediapipe-com-0.3.0/* ./
rm -rf node-autoit-mediapipe-com-0.3.0
```

Now you can run any file in the `examples` folder.

## Developpement

### Prerequisites

  - Install [CMAKE >= 3.19](https://cmake.org/download/)
  - Install [visual studio >= 2017, <= 2022 17.3.6](https://visualstudio.microsoft.com/vs/community/) Mediapipe does not build with version >= 17.3.6. I reported a [bug](https://developercommunity.visualstudio.com/t/Linking-failed-after-1736/10227061) to the Developer community, but it was ignored and closed.
  - Install [Git for Windows](https://gitforwindows.org/)
  - Install [nodejs](https://nodejs.org/en/download/)
  - Install [Python >= 3.8](https://www.python.org/downloads/)

### Environment

In Git BASH, excute the following commands

```sh
# get the source files
git clone https://github.com/smbape/node-autoit-mediapipe-com
cd node-autoit-mediapipe-com

# Install nodejs dependencies
npm ci
```

### Generate the UDF files

```sh
cmd.exe //c 'autoit-mediapipe-com\build.bat'
```
