<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [Mediapipe autoit udf](#mediapipe-autoit-udf)
  - [What is missing](#what-is-missing)
- [Usage of the UDF](#usage-of-the-udf)
  - [Prerequisites](#prerequisites)
  - [Usage](#usage)
    - [AutoIt](#autoit)
      - [With opencv COM+ binding](#with-opencv-com-binding)
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
  - Download and extract [autoit-mediapipe-0.8.11-opencv-4.6.0-com-v0.0.0.7z](https://github.com/smbape/node-autoit-mediapipe-com/releases/download/v0.0.0/autoit-mediapipe-0.8.11-opencv-4.6.0-com-v0.0.0.7z) into a folder

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

Example()

Func Example()
  Local $download_utils = _Mediapipe_ObjCreate("mediapipe.autoit.solutions.download_utils")
  If Not IsObj($download_utils) Then Return

  Local $mp_drawing = _Mediapipe_ObjCreate("mediapipe.autoit.solutions.drawing_utils")
  If Not IsObj($mp_drawing) Then Return

  Local $mp_selfie_segmentation = _Mediapipe_ObjCreate("mediapipe.autoit.solutions.selfie_segmentation")
  If Not IsObj($mp_selfie_segmentation) Then Return

  Local Const $cv = _OpenCV_get()
  If Not IsObj($cv) Then Return

  ; tell mediapipe to lookup for need files relatively to this udf
  _Mediapipe_SetResourceDir()

  $download_utils.download( _
      "https://github.com/tensorflow/tfjs-models/raw/master/face-detection/test_data/portrait.jpg", _
      @ScriptDir & "/testdata/portrait.jpg" _
      )

  Local $image_path = @ScriptDir & "/testdata/portrait.jpg"
  Local $image = $cv.imread($image_path)

  Local $selfie_segmentation = $mp_selfie_segmentation.SelfieSegmentation()
  Local $results = $selfie_segmentation.process($cv.cvtColor($image, $CV_COLOR_BGR2RGB))
  Local $segmentation_mask = $cv.multiply($results("segmentation_mask"), 255.0).convertTo($CV_32S)

  ; image and mask must have the same size and type to perform cv::min
  If $image.depth() <> $segmentation_mask.depth() Then
    $segmentation_mask = $segmentation_mask.convertTo($image.depth())
  EndIf

  ; set the background to black
  Local $image_mask[] = [$segmentation_mask, $segmentation_mask, $segmentation_mask]
  $image = $cv.min($image, $cv.merge($image_mask))

  $cv.imshow("selfie segmentation", $image)
  $cv.waitKey()
  $cv.destroyAllWindows()
EndFunc   ;==>Example

Func _OnAutoItExit()
  _OpenCV_Unregister_And_Close()
  _Mediapipe_Unregister_And_Close()
EndFunc   ;==>_OnAutoItExit
```

## Running examples

Install [7-zip](https://www.7-zip.org/download.html) and add the 7-zip folder to you system PATH environment variable

Then, in [Git Bash](https://gitforwindows.org/), execute the following commands

```sh
# download autoit-mediapipe-0.8.11-opencv-4.6.0-com-v0.0.0.7z
curl -L 'https://github.com/smbape/node-autoit-mediapipe-com/releases/download/v0.0.0/autoit-mediapipe-0.8.11-opencv-4.6.0-com-v0.0.0.7z' -o autoit-mediapipe-0.8.11-opencv-4.6.0-com-v0.0.0.7z

# extract the content of autoit-mediapipe-0.8.11-opencv-4.6.0-com-v0.0.0.7z into a folder named autoit-mediapipe-com
7z x autoit-mediapipe-0.8.11-opencv-4.6.0-com-v0.0.0.7z -aoa -oautoit-mediapipe-com

# download autoit-opencv-4.6.0-com-v2.1.0.7z
curl -L 'https://github.com/smbape/node-autoit-opencv-com/releases/download/v2.1.0/autoit-opencv-4.6.0-com-v2.1.0.7z' -o autoit-opencv-4.6.0-com-v2.1.0.7z

# extract the content of autoit-opencv-4.6.0-com-v2.1.0.7z into a folder named autoit-opencv-com
7z x autoit-opencv-4.6.0-com-v2.1.0.7z -aoa -oautoit-opencv-com

# download opencv-4.6.0-vc14_vc15.exe
curl -L 'https://github.com/opencv/opencv/releases/download/4.6.0/opencv-4.6.0-vc14_vc15.exe' -o opencv-4.6.0-vc14_vc15.exe

# extract the content of opencv-4.6.0-vc14_vc15.exe into a folder named opencv-4.6.0-vc14_vc15
./opencv-4.6.0-vc14_vc15.exe -oopencv-4.6.0-vc14_vc15 -y

# download autoit-mediapipe-0.8.11-opencv-4.6.0-com-v0.0.0-src.zip
curl -L 'https://github.com/smbape/node-autoit-mediapipe-com/archive/refs/tags/v0.0.0.zip' -o autoit-mediapipe-0.8.11-opencv-4.6.0-com-v0.0.0-src.zip

# extract the examples folder of autoit-mediapipe-0.8.11-opencv-4.6.0-com-v0.0.0-src.zip
7z x autoit-mediapipe-0.8.11-opencv-4.6.0-com-v0.0.0-src.zip -aoa 'node-autoit-mediapipe-com-0.0.0\examples'
cp -rf node-autoit-mediapipe-com-0.0.0/* ./
rm -rf node-autoit-mediapipe-com-0.0.0
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
