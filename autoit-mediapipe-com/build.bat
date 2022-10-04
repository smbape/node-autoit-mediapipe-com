@ECHO OFF
SETLOCAL enabledelayedexpansion

PUSHD "%~dp0"
CD /d %CD%
SET "PATH=%CD%;%PATH%"
SET "CWD=%CD%"

SET skip_node=0
SET skip_build=0
SET TARGET=ALL_BUILD

SET nparms=20
:LOOP
IF %nparms%==0 GOTO :MAIN
IF [%1] == [nojs] SET skip_node=1
IF [%1] == [-g] SET skip_build=1
SET /a nparms -=1
SHIFT
GOTO LOOP

:MAIN
SET ARCH=x64
SET OS_MODE= Win64
SET BUILD_FOLDER=build_x64
SET BUILD_ARCH=-A x64

IF NOT DEFINED CMAKE_BUILD_TYPE SET CMAKE_BUILD_TYPE=Release
SET GENERAL_CMAKE_CONFIG_FLAGS=%GENERAL_CMAKE_CONFIG_FLAGS% -DCMAKE_BUILD_TYPE:STRING="%CMAKE_BUILD_TYPE%" -DCMAKE_INSTALL_PREFIX:STRING=install

::Find CMake
SET CMAKE="cmake.exe"
IF EXIST "%PROGRAMFILES_DIR_X86%\CMake\bin\cmake.exe" SET CMAKE="%PROGRAMFILES_DIR_X86%\CMake\bin\cmake.exe"
IF EXIST "%PROGRAMFILES_DIR%\CMake\bin\cmake.exe" SET CMAKE="%PROGRAMFILES_DIR%\CMake\bin\cmake.exe"
IF EXIST "%PROGRAMW6432%\CMake\bin\cmake.exe" SET CMAKE="%PROGRAMW6432%\CMake\bin\cmake.exe"

::Find Visual Studio
FOR /F "usebackq tokens=* USEBACKQ" %%F IN (`vswhere.exe -legacy -version [10.0^,^) -property installationVersion -latest`) DO SET VS_VERSION=%%F

FOR /F "usebackq tokens=* USEBACKQ" %%F IN (`vswhere.exe -version [16.0^,^) -property installationPath -latest`) DO (
    SET CMAKE_CONF="Visual Studio %VS_VERSION:~0,2%" -A x64
    rem CALL "%%F\VC\Auxiliary\Build\vcvars64.bat"
    GOTO MAKE
    EXIT /b %ERRORLEVEL%
)

FOR /F "usebackq tokens=* USEBACKQ" %%F IN (`vswhere.exe -version [15.0^,16.0^) -property installationPath -latest`) DO (
    SET CMAKE_CONF="Visual Studio %VS_VERSION:~0,2% Win64"
    rem CALL "%%F\VC\Auxiliary\Build\vcvars64.bat"
    GOTO MAKE
    EXIT /b %ERRORLEVEL%
)

FOR /F "usebackq tokens=* USEBACKQ" %%F IN (`vswhere.exe -legacy -version [10.0^,15.0^) -property installationPath -latest`) DO (
    SET CMAKE_CONF="Visual Studio %VS_VERSION:~0,2% Win64"
    rem CALL "%%F\VC\vcvarsall.bat" x64
    GOTO MAKE
    EXIT /b %ERRORLEVEL%
)

ECHO Unable to find a visual studio version
SET ERROR=1
GOTO END

:MAKE
SET ERROR=0

:DOWNLOAD_OPENCV
SET _skip_build=%skip_build%
SET skip_build=0
SET TARGET=mediapipe
CALL :MAKE_CONFIG
SET ERROR=%ERRORLEVEL%
SET TARGET=ALL_BUILD
SET skip_build=%_skip_build%
CD /d %CWD%

IF NOT EXIST "%CD%\%BUILD_FOLDER%\mediapipe-prefix\src\mediapipe\mediapipe\autoit" (
    mklink /j "%CD%\%BUILD_FOLDER%\mediapipe-prefix\src\mediapipe\mediapipe\autoit" "%CD%"
)

IF "%ERROR%" == "0" GOTO GEN_SOURCES
GOTO END

:GEN_SOURCES
IF [%skip_node%] == [1] GOTO MAKE_CONFIG
node --unhandled-rejections=strict --trace-uncaught --trace-warnings ..\src\gen.js --skip=vs
SET ERROR=%ERRORLEVEL%
IF "%ERROR%" == "0" GOTO MAKE_CONFIG
GOTO END

:MAKE_CONFIG
IF [%skip_config%] == [1] GOTO BUILD

IF NOT EXIST %BUILD_FOLDER% mkdir %BUILD_FOLDER%
cd %BUILD_FOLDER%
rem IF EXIST "CMakeCache.txt" del CMakeCache.txt

:RUN_CMAKE
%CMAKE% -G %CMAKE_CONF% %GENERAL_CMAKE_CONFIG_FLAGS% ..\
SET ERROR=%ERRORLEVEL%
IF "%ERROR%" == "0" GOTO BUILD
GOTO END

:BUILD
IF [%skip_build%] == [1] GOTO END
%CMAKE% --build . --config %CMAKE_BUILD_TYPE% --target %TARGET%
SET ERROR=%ERRORLEVEL%

:END
POPD
EXIT /B %ERROR%
