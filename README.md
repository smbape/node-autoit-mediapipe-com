<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [Dlib autoit udf](#dlib-autoit-udf)
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

# Dlib autoit udf

Partial COM+ binding to [dlib](http://dlib.net/)

## What is missing
  - Images operations: These look redundant with [OpenCV](https://opencv.org/). I hope they can be found in the [OpenCV COM+ binding](https://github.com/smbape/node-autoit-dlib-com)

# Usage of the UDF

## Prerequisites

  - Download and extract [opencv-4.6.0-vc14_vc15.exe](https://sourceforge.net/projects/opencvlibrary/files/4.6.0/opencv-4.6.0-vc14_vc15.exe/download) into a folder
  - Download and extract [autoit-dlib-19.24.0-opencv-4.6.0-com-v1.1.0.7z](https://github.com/smbape/node-autoit-dlib-com/releases/download/v1.1.0/autoit-dlib-19.24.0-opencv-4.6.0-com-v1.1.0.7z) into a folder

## Usage

### AutoIt

```autoit
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Change2CUI=y
#AutoIt3Wrapper_Au3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#include <Misc.au3>
#include "autoit-dlib-com\udf\dlib_udf_utils.au3"

_Dlib_Open_And_Register("opencv-4.6.0-vc14_vc15\opencv\build\x64\vc15\bin\opencv_world460.dll", "autoit-dlib-com\autoit_dlib_com-19.24.0-460.dll")
OnAutoItExitRegister("_OnAutoItExit")

Example()

Func Example()
  Local Const $dlib = _Dlib_get()
  If Not IsObj($dlib) Then Return

  Local $detector = $dlib.get_frontal_face_detector()
  Local $win = _Dlib_ObjCreate("image_window")

  Local $image_path = _Dlib_FindFile("examples\faces\2008_002470.jpg")
  Local $img = $dlib.load_rgb_image($image_path)

  $win.set_image($img)

  ; The 1 in the second argument indicates that we should upsample the image
  ; 1 time.  This will make everything bigger and allow us to detect more
  ; faces.
  Local $dets = $detector.call($img, 1)
  ConsoleWrite("Number of faces detected: " & UBound($dets) & @CRLF)

  Local $d
  For $i = 0 To UBound($dets) - 1
    $d = $dets[$i]
    ConsoleWrite(StringFormat("Detection %d: Left: %d Top: %d Right: %d Bottom: %d", _
        $i, $d.left(), $d.top(), $d.right(), $d.bottom()) & @CRLF)
  Next

  $win.add_overlay($dets)
  hit_to_continue()
EndFunc   ;==>Example

Func hit_to_continue()
  ToolTip("Hit ESC to continue", 0, 0)
  ConsoleWrite("Hit ESC to continue" & @CRLF)
  Do
    Sleep(50)
  Until _IsPressed("1B")
EndFunc   ;==>hit_to_continue

Func _OnAutoItExit()
  _Dlib_Unregister_And_Close()
EndFunc   ;==>_OnAutoItExit
```

#### With opencv COM+ binding

```autoit
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Change2CUI=y
#AutoIt3Wrapper_Au3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#include <Misc.au3>
#include "autoit-dlib-com\udf\dlib_udf_utils.au3"
#include "autoit-opencv-com\udf\opencv_udf_utils.au3"

_Dlib_Open_And_Register("opencv-4.6.0-vc14_vc15\opencv\build\x64\vc15\bin\opencv_world460.dll", "autoit-dlib-com\autoit_dlib_com-19.24.0-460.dll")
_OpenCV_Open_And_Register("opencv-4.6.0-vc14_vc15\opencv\build\x64\vc15\bin\opencv_world460.dll", "autoit-opencv-com\autoit_opencv_com460.dll")
OnAutoItExitRegister("_OnAutoItExit")

Example()

Func Example()
  Local Const $dlib = _Dlib_get()
  If Not IsObj($dlib) Then Return

  Local Const $cv = _OpenCV_get()
  If Not IsObj($cv) Then Return

  Local $detector = $dlib.get_frontal_face_detector()
  Local $cam = _OpenCV_ObjCreate("VideoCapture").create(0)
  Local $color_green = _OpenCV_Tuple(0, 255, 0)
  Local $line_width = 3
  Local $img, $dets, $det

  While True
    If $cam.read() Then
      $img = $cv.extended[1]
      $dets = $detector.call($img)

      For $i = 0 To UBound($dets) - 1
        $det = $dets[$i]
        $cv.rectangle($img, _OpenCV_Tuple($det.left(), $det.top()), _OpenCV_Tuple($det.right(), $det.bottom()), $color_green, $line_width)
      Next

      ;; Flip the image horizontally to give the mirror impression
      $cv.imshow("my webcam", $cv.flip($img, 1))
    EndIf

    If _IsPressed("1B") Then
      ExitLoop  ; esc to quit
    EndIf

    Sleep(1)
  WEnd

  $cv.destroyAllWindows()
EndFunc   ;==>Example

Func _OnAutoItExit()
  _OpenCV_Unregister_And_Close()
  _Dlib_Unregister_And_Close()
EndFunc   ;==>_OnAutoItExit
```

## Running examples

Install [7-zip](https://www.7-zip.org/download.html) and add the 7-zip folder to you system PATH environment variable

Then, in [Git Bash](https://gitforwindows.org/), execute the following commands

```sh
# download autoit-dlib-19.24.0-opencv-4.6.0-com-v1.1.0.7z
curl -L 'https://github.com/smbape/node-autoit-dlib-com/releases/download/v1.1.0/autoit-dlib-19.24.0-opencv-4.6.0-com-v1.1.0.7z' -o autoit-dlib-19.24.0-opencv-4.6.0-com-v1.1.0.7z

# extract the content of autoit-dlib-19.24.0-opencv-4.6.0-com-v1.1.0.7z into a folder named autoit-dlib-com
7z x autoit-dlib-19.24.0-opencv-4.6.0-com-v1.1.0.7z -aoa -oautoit-dlib-com

# download autoit-opencv-4.6.0-com-v2.1.0.7z
curl -L 'https://github.com/smbape/node-autoit-opencv-com/releases/download/v2.1.0/autoit-opencv-4.6.0-com-v2.1.0.7z' -o autoit-opencv-4.6.0-com-v2.1.0.7z

# extract the content of autoit-opencv-4.6.0-com-v2.1.0.7z into a folder named autoit-opencv-com
7z x autoit-opencv-4.6.0-com-v2.1.0.7z -aoa -oautoit-opencv-com

# download opencv-4.6.0-vc14_vc15.exe
curl -L 'https://github.com/opencv/opencv/releases/download/4.6.0/opencv-4.6.0-vc14_vc15.exe' -o opencv-4.6.0-vc14_vc15.exe

# extract the content of opencv-4.6.0-vc14_vc15.exe into a folder named opencv-4.6.0-vc14_vc15
./opencv-4.6.0-vc14_vc15.exe -oopencv-4.6.0-vc14_vc15 -y

# download autoit-dlib-19.24.0-opencv-4.6.0-com-v1.1.0-src.zip
curl -L 'https://github.com/smbape/node-autoit-dlib-com/archive/refs/tags/v1.1.0.zip' -o autoit-dlib-19.24.0-opencv-4.6.0-com-v1.1.0-src.zip

# extract the examples folder of autoit-dlib-19.24.0-opencv-4.6.0-com-v1.1.0-src.zip
7z x autoit-dlib-19.24.0-opencv-4.6.0-com-v1.1.0-src.zip -aoa 'node-autoit-dlib-com-1.1.0\examples'
cp -rf node-autoit-dlib-com-1.1.0/* ./
rm -rf node-autoit-dlib-com-1.1.0

# download dlib-v19.24-src.zip
curl -L 'https://github.com/davisking/dlib/archive/refs/tags/v19.24.zip' -o dlib-v19.24-src.zip

# extract the examples\faces and examples\video_frames folders of dlib-v19.24-src.zip
7z x dlib-v19.24-src.zip -aoa 'dlib-19.24\examples\faces' 'dlib-19.24\examples\video_frames'
cp -rf dlib-19.24/* ./
rm -rf dlib-19.24

# create the data dir
mkdir examples/data
```

Now you can run any file in the `examples` folder.

## Developpement

### Prerequisites

  - Install [CMAKE >= 3.16](https://cmake.org/download/)
  - Install [visual studio >= 2017](https://visualstudio.microsoft.com/vs/community/)
  - Install [Git for Windows](https://gitforwindows.org/)
  - Install [nodejs](https://nodejs.org/en/download/)
  - Install [Python >= 3.8](https://www.python.org/downloads/)

### Environment

In Git BASH, excute the following commands

```sh
# get the source files
git clone https://github.com/smbape/node-autoit-dlib-com
cd node-autoit-dlib-com

# Install nodejs dependencies
npm ci
```

### Generate the UDF files

```sh
cmd.exe //c 'autoit-dlib-com\build.bat'
```
