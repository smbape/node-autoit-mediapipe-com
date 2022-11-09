cmake_minimum_required(VERSION 3.16)

# Name of the project (will be the name of the plugin)
project(autoit_mediapipe_com)

set(DEFAULT_BUILD_TYPE "Release")

if(NOT CMAKE_BUILD_TYPE AND NOT CMAKE_CONFIGURATION_TYPES)
  message(STATUS "Setting build type to '${DEFAULT_BUILD_TYPE}' as none was specified.")
  set(CMAKE_BUILD_TYPE "${DEFAULT_BUILD_TYPE}" CACHE STRING "Choose the type of build." FORCE)
  # Set the possible values of build type for cmake-gui
  set_property(CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS "Debug" "Release" "MinSizeRel" "RelWithDebInfo")
endif()

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

add_compile_options(/MP)

set(MEDIAPIPE_VERSION 0.8.11)

set(OPENCV_DOWNLOAD_DIR "${CMAKE_CURRENT_SOURCE_DIR}/..")
set(OPENCV_VERSION 4.6.0)
string(REPLACE . "" OPENCV_VERSION_ "${OPENCV_VERSION}")

get_filename_component(OPENCV_DOWNLOAD_DIR_ESC "${OPENCV_DOWNLOAD_DIR}" REALPATH)
file(TO_NATIVE_PATH "${OPENCV_DOWNLOAD_DIR_ESC}" OPENCV_DOWNLOAD_DIR_ESC)
string(REPLACE \\ \\\\ OPENCV_DOWNLOAD_DIR_ESC "${OPENCV_DOWNLOAD_DIR_ESC}")

set(PROJECT_BUILD_STEPS_FILE "${CMAKE_CURRENT_SOURCE_DIR}/project_build_steps.cmake")

# install PyPI Python mediapipe using pip
set(MEDIAPIPE_PYTHON_INIT "${CMAKE_CURRENT_BINARY_DIR}/.pip/mediapipe/__init__.py")
find_package(Python COMPONENTS Interpreter REQUIRED)
add_custom_command(OUTPUT "${MEDIAPIPE_PYTHON_INIT}"
  COMMAND "${Python_EXECUTABLE}" -m pip install --no-deps -t "${CMAKE_CURRENT_BINARY_DIR}/.pip" -U mediapipe==${MEDIAPIPE_VERSION}
)
add_custom_target(mediapipe-python DEPENDS "${MEDIAPIPE_PYTHON_INIT}")
file(DOWNLOAD
  https://github.com/tensorflow/tfjs-models/raw/master/face-detection/test_data/portrait.jpg
  "${CMAKE_CURRENT_SOURCE_DIR}/../test/solutions/testdata/portrait.jpg")


# Tell cmake we will need opencv.
include(ExternalProject)
ExternalProject_Add(opencv
  URL               https://github.com/opencv/opencv/releases/download/${OPENCV_VERSION}/opencv-${OPENCV_VERSION}-vc14_vc15.exe
  URL_HASH          SHA256=3fb046e14dc5b50719a86ea0395b5b1e3299e2343111ebd2e31828aa31d6d477
  DOWNLOAD_NO_EXTRACT TRUE
  DOWNLOAD_DIR      "${OPENCV_DOWNLOAD_DIR}"
  CONFIGURE_COMMAND "${OPENCV_DOWNLOAD_DIR}/opencv-${OPENCV_VERSION}-vc14_vc15.exe" "-o${OPENCV_DOWNLOAD_DIR}/opencv-${OPENCV_VERSION}-vc14_vc15" -y
  BUILD_COMMAND     patch -p 1 -d "${OPENCV_DOWNLOAD_DIR}/opencv-${OPENCV_VERSION}-vc14_vc15/opencv/sources/" -i "${CMAKE_CURRENT_SOURCE_DIR}/patches/001-opencv-src.patch"
  INSTALL_COMMAND   ""
)

configure_file("${CMAKE_CURRENT_SOURCE_DIR}/patches/001-mediapipe-src.patch.in" "${CMAKE_CURRENT_SOURCE_DIR}/patches/001-mediapipe-src.patch" @ONLY)

# Tell cmake we will need mediapipe.
include(ExternalProject)
ExternalProject_Add(mediapipe
  URL               https://fossies.org/linux/misc/mediapipe-${MEDIAPIPE_VERSION}.tar.gz
                    https://github.com/google/mediapipe/archive/refs/tags/v${MEDIAPIPE_VERSION}.tar.gz
  URL_HASH          SHA256=5b331a46b459900d0789967f9e26e4a64d1466bc1e74dd0712eb3077358c5473
  PATCH_COMMAND
    "${CMAKE_COMMAND}"
    "-DSOURCE_DIR=<SOURCE_DIR>"
    "-DPATCH_FILE=${CMAKE_CURRENT_SOURCE_DIR}/patches/001-mediapipe-src.patch"
    -DBUILD_STEP=patch
    -P "${PROJECT_BUILD_STEPS_FILE}"
  CONFIGURE_COMMAND ""
  BUILD_COMMAND     ""
  INSTALL_COMMAND   ""
  DEPENDS           opencv
                    mediapipe-python
)

# Tell cmake we will need autoit-opencv-com.
include(ExternalProject)
ExternalProject_Add(autoit-opencv-com
  URL               https://github.com/smbape/node-autoit-opencv-com/releases/download/v2.1.0/autoit-opencv-${OPENCV_VERSION}-com-v2.1.0.7z
  URL_HASH          SHA256=e6f70b1ea79be92db72e4a93b9ec07926ef0db3752af308cd0448572c009ab8f
  DOWNLOAD_NO_EXTRACT TRUE
  DOWNLOAD_DIR      "${OPENCV_DOWNLOAD_DIR}"
  CONFIGURE_COMMAND ""
  BUILD_COMMAND     ""
  INSTALL_COMMAND   7z x "${OPENCV_DOWNLOAD_DIR}/autoit-opencv-${OPENCV_VERSION}-com-v2.1.0.7z" -aoa "-o${OPENCV_DOWNLOAD_DIR}/autoit-opencv-com" -y
  DEPENDS           opencv
)

add_definitions(-DMEDIAPIPE_VERSION=${MEDIAPIPE_VERSION})
add_definitions(-DCVAPI_EXPORTS)

file(GLOB_RECURSE project_source_resources "src/*.rc" "src/*.rgs")
file(GLOB_RECURSE project_source_headers "src/targetver.h")
file(GLOB_RECURSE project_generated_resources "generated/*.rc" "generated/*.rgs")

set(SRC_FILES
  ${project_source_resources}
  ${project_source_headers}
  ${project_generated_resources}
)

source_group("Source Resources" FILES ${project_source_resources})
source_group("Source Headers" FILES ${project_source_headers})
source_group("Generated Resources" FILES ${project_generated_resources})

# Build a shared library named as the project
add_library(${PROJECT_NAME} OBJECT ${SRC_FILES})
target_include_directories(${PROJECT_NAME} PUBLIC "src")
target_include_directories(${PROJECT_NAME} PUBLIC "generated")
