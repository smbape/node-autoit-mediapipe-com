<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [Mediapipe autoit udf](#mediapipe-autoit-udf)
- [Usage of the UDF](#usage-of-the-udf)
  - [Prerequisites](#prerequisites)
  - [Usage](#usage)
    - [AutoIt](#autoit)
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

  - Download and extract [opencv-4.6.0-vc14_vc15.exe](https://sourceforge.net/projects/opencvlibrary/files/4.6.0/opencv-4.6.0-vc14_vc15.exe/download) into a folder
  - Download and extract [autoit-opencv-4.6.0-com-v2.2.0.7z](https://github.com/smbape/node-autoit-opencv-com/releases/download/v2.2.0/autoit-opencv-4.6.0-com-v2.2.0.7z) into a folder
  - Download and extract [autoit-mediapipe-0.8.11-opencv-4.6.0-com-v0.1.0.7z](https://github.com/smbape/node-autoit-mediapipe-com/releases/download/v0.1.0/autoit-mediapipe-0.8.11-opencv-4.6.0-com-v0.1.0.7z) into a folder

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

_Mediapipe_Open_And_Register("opencv-4.6.0-vc14_vc15\opencv\build\x64\vc15\bin\opencv_world460.dll", "autoit-mediapipe-com\autoit_mediapipe_com-0.8.11-460.dll")
_OpenCV_Open_And_Register("opencv-4.6.0-vc14_vc15\opencv\build\x64\vc15\bin\opencv_world460.dll", "autoit-opencv-com\autoit_opencv_com460.dll")
OnAutoItExitRegister("_OnAutoItExit")

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
  _OpenCV_Unregister_And_Close()
  _Mediapipe_Unregister_And_Close()
EndFunc   ;==>_OnAutoItExit
```

## Running examples

Install [7-zip](https://www.7-zip.org/download.html) and add the 7-zip folder to you system PATH environment variable

Then, in [Git Bash](https://gitforwindows.org/), execute the following commands

```sh
# download autoit-mediapipe-0.8.11-opencv-4.6.0-com-v0.1.0.7z
curl -L 'https://github.com/smbape/node-autoit-mediapipe-com/releases/download/v0.1.0/autoit-mediapipe-0.8.11-opencv-4.6.0-com-v0.1.0.7z' -o autoit-mediapipe-0.8.11-opencv-4.6.0-com-v0.1.0.7z

# extract the content of autoit-mediapipe-0.8.11-opencv-4.6.0-com-v0.1.0.7z into a folder named autoit-mediapipe-com
7z x autoit-mediapipe-0.8.11-opencv-4.6.0-com-v0.1.0.7z -aoa -oautoit-mediapipe-com

# download autoit-opencv-4.6.0-com-v2.2.0.7z
curl -L 'https://github.com/smbape/node-autoit-opencv-com/releases/download/v2.2.0/autoit-opencv-4.6.0-com-v2.2.0.7z' -o autoit-opencv-4.6.0-com-v2.2.0.7z

# extract the content of autoit-opencv-4.6.0-com-v2.2.0.7z into a folder named autoit-opencv-com
7z x autoit-opencv-4.6.0-com-v2.2.0.7z -aoa -oautoit-opencv-com

# download opencv-4.6.0-vc14_vc15.exe
curl -L 'https://github.com/opencv/opencv/releases/download/4.6.0/opencv-4.6.0-vc14_vc15.exe' -o opencv-4.6.0-vc14_vc15.exe

# extract the content of opencv-4.6.0-vc14_vc15.exe into a folder named opencv-4.6.0-vc14_vc15
./opencv-4.6.0-vc14_vc15.exe -oopencv-4.6.0-vc14_vc15 -y

# download autoit-mediapipe-0.8.11-opencv-4.6.0-com-v0.1.0-src.zip
curl -L 'https://github.com/smbape/node-autoit-mediapipe-com/archive/refs/tags/v0.1.0.zip' -o autoit-mediapipe-0.8.11-opencv-4.6.0-com-v0.1.0-src.zip

# extract the examples folder of autoit-mediapipe-0.8.11-opencv-4.6.0-com-v0.1.0-src.zip
7z x autoit-mediapipe-0.8.11-opencv-4.6.0-com-v0.1.0-src.zip -aoa 'node-autoit-mediapipe-com-0.1.0\examples'
cp -rf node-autoit-mediapipe-com-0.1.0/* ./
rm -rf node-autoit-mediapipe-com-0.1.0
```

Now you can run any file in the `examples` folder.

## Developpement

### Prerequisites

  - Install [CMAKE >= 3.19](https://cmake.org/download/)
  - Install [visual studio >= 2017](https://visualstudio.microsoft.com/vs/community/)
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
