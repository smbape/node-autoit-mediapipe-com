cmake_minimum_required(VERSION 3.19)

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

# https://github.com/scivision/cmake-patch-file/blob/main/cmake/PatchFile.cmake
if(WIN32)
  # prioritize Git Patch on Windows as other Patches may be very old and incompatible.
  find_package(Git)
  if(Git_FOUND)
    get_filename_component(GIT_DIR ${GIT_EXECUTABLE} DIRECTORY)
    get_filename_component(GIT_DIR ${GIT_DIR} DIRECTORY)
  endif()
endif()

find_program(PATCH
  NAMES patch
  HINTS ${GIT_DIR}
  PATH_SUFFIXES usr/bin
)

if(NOT PATCH)
  message(FATAL_ERROR "Did not find GNU Patch")
endif()

if("${CMAKE_BUILD_TYPE}" STREQUAL Debug)
  set(CMODE dbg)
else()
  set(CMODE opt)
endif()

find_package(Python COMPONENTS Interpreter REQUIRED)
string(REPLACE / // PYTHON_BIN_PATH "${Python_EXECUTABLE}")

set(BAZEL_BUILD bazel
  --output_user_root=C:/_bazel_
  build -c ${CMODE}
  --strip=never
  --define MEDIAPIPE_DISABLE_GPU=1
  --action_env "PYTHON_BIN_PATH=${PYTHON_BIN_PATH}"
  --verbose_failures
  --keep_going
)

# Tell cmake that we will need opencv.
get_filename_component(OPENCV_DOWNLOAD_DIR "${CMAKE_CURRENT_SOURCE_DIR}" DIRECTORY)
set(OPENCV_VERSION        4.6.0)
string(REPLACE . "" OPENCV_VERSION_POSTFIX "${OPENCV_VERSION}")
set(OPENCV_DOWNLOAD_NAME  opencv-${OPENCV_VERSION}-vc14_vc15.exe)
set(OPENCV_URL            https://github.com/opencv/opencv/releases/download/${OPENCV_VERSION}/${OPENCV_DOWNLOAD_NAME})
set(OPENCV_URL_HASH       SHA256=3fb046e14dc5b50719a86ea0395b5b1e3299e2343111ebd2e31828aa31d6d477)

if("${CMAKE_BUILD_TYPE}" STREQUAL Debug)
  set(OPENCV_VERSION_POSTFIX "${OPENCV_VERSION_POSTFIX}d")
endif()

include(FetchContent)
FetchContent_Declare(opencv
  URL                 ${OPENCV_URL}
  URL_HASH            ${OPENCV_URL_HASH}
  DOWNLOAD_NO_EXTRACT TRUE
  DOWNLOAD_DIR        "${OPENCV_DOWNLOAD_DIR}"
  SOURCE_DIR          "${OPENCV_DOWNLOAD_DIR}"
  PATCH_COMMAND       "<DOWNLOAD_DIR>/${OPENCV_DOWNLOAD_NAME}" "-o<DOWNLOAD_DIR>/opencv-${OPENCV_VERSION}-vc14_vc15" -y
)

include(FetchContent)
FetchContent_Declare(opencv-patch
  URL                 ${OPENCV_URL}
  URL_HASH            ${OPENCV_URL_HASH}
  DOWNLOAD_NO_EXTRACT TRUE
  DOWNLOAD_DIR        "${OPENCV_DOWNLOAD_DIR}"
  SOURCE_DIR          "${OPENCV_DOWNLOAD_DIR}"
  PATCH_COMMAND       "${PATCH}" -p 1 -d "<DOWNLOAD_DIR>/opencv-${OPENCV_VERSION}-vc14_vc15/opencv/sources/"
                        -i "${CMAKE_CURRENT_SOURCE_DIR}/patches/001-opencv-src.patch"
)

# Tell cmake that we will need mediapipe.
set(MEDIAPIPE_VERSION 0.8.11)

# Used in 001-mediapipe-src.patch.in
get_filename_component(OPENCV_DOWNLOAD_DIR_ESC "${OPENCV_DOWNLOAD_DIR}" REALPATH)
file(TO_NATIVE_PATH "${OPENCV_DOWNLOAD_DIR_ESC}" OPENCV_DOWNLOAD_DIR_ESC)
string(REPLACE \\ \\\\ OPENCV_DOWNLOAD_DIR_ESC "${OPENCV_DOWNLOAD_DIR_ESC}")
string(REPLACE . "" OPENCV_VERSION_ "${OPENCV_VERSION}")
configure_file("${CMAKE_CURRENT_SOURCE_DIR}/patches/001-mediapipe-src.patch.in" "${CMAKE_CURRENT_SOURCE_DIR}/patches/001-mediapipe-src.patch" @ONLY)

include(FetchContent)
FetchContent_Declare(mediapipe
  URL               https://fossies.org/linux/misc/mediapipe-${MEDIAPIPE_VERSION}.tar.gz
                    https://github.com/google/mediapipe/archive/refs/tags/v${MEDIAPIPE_VERSION}.tar.gz
  URL_HASH          SHA256=5b331a46b459900d0789967f9e26e4a64d1466bc1e74dd0712eb3077358c5473
  PATCH_COMMAND     "${PATCH}" -p 1 -d "<SOURCE_DIR>" -i "${CMAKE_CURRENT_SOURCE_DIR}/patches/001-mediapipe-src.patch"
)

# Tell cmake that we will need autoit-opencv-com.
include(ExternalProject)
ExternalProject_Add(autoit-opencv-com
  URL               https://github.com/smbape/node-autoit-opencv-com/releases/download/v2.1.0/autoit-opencv-${OPENCV_VERSION}-com-v2.1.0.7z
  URL_HASH          SHA256=e6f70b1ea79be92db72e4a93b9ec07926ef0db3752af308cd0448572c009ab8f
  DOWNLOAD_NO_EXTRACT TRUE
  DOWNLOAD_DIR      "${OPENCV_DOWNLOAD_DIR}"
  SOURCE_DIR        "${OPENCV_DOWNLOAD_DIR}"
  CONFIGURE_COMMAND ""
  BUILD_COMMAND     ""
  INSTALL_COMMAND   7z x "<DOWNLOAD_DIR>/autoit-opencv-${OPENCV_VERSION}-com-v2.1.0.7z" -aoa "-o<DOWNLOAD_DIR>/autoit-opencv-com" -y
)

FetchContent_Populate(opencv)
FetchContent_Populate(opencv-patch)
FetchContent_Populate(mediapipe)

set(mediapipe_BINARY_DIR "${mediapipe_SOURCE_DIR}/bazel-out/x64_windows-${CMODE}/bin")

# generate source files
if(
  (NOT EXISTS "${mediapipe_BINARY_DIR}/external/com_google_protobuf/any_proto-descriptor-set.proto.bin") OR
  (NOT EXISTS "${mediapipe_SOURCE_DIR}/bazel-mediapipe-src/external/com_google_protobuf/src")
)
  execute_process(
    COMMAND "${Python_EXECUTABLE}" -m pip install numpy
    WORKING_DIRECTORY "${mediapipe_SOURCE_DIR}"
    COMMAND_ECHO STDERR
    COMMAND_ERROR_IS_FATAL ANY
  )

  execute_process(
    COMMAND ${BAZEL_BUILD} mediapipe/python:builtin_calculators
    WORKING_DIRECTORY "${mediapipe_SOURCE_DIR}"
    COMMAND_ECHO STDERR
    COMMAND_ERROR_IS_FATAL ANY
  )
endif()

execute_process(
  COMMAND node --unhandled-rejections=strict --trace-uncaught --trace-warnings src/gen.js --skip=vs
  WORKING_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/.."
  COMMAND_ECHO STDERR
  COMMAND_ERROR_IS_FATAL ANY
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

# Build resource file needed by bazel
add_library(${PROJECT_NAME}_res OBJECT ${SRC_FILES})
target_include_directories(${PROJECT_NAME}_res PUBLIC "src")
target_include_directories(${PROJECT_NAME}_res PUBLIC "generated")

file(GLOB_RECURSE project_source_headers
  "src/*.h*"
  "generated/*.h*"
)

file(GLOB_RECURSE project_source_files
  "src/*.c"
  "src/*.cc"
  "src/*.cpp"
  "src/*.cxx"
  "generated/*.c"
  "generated/*.cc"
  "generated/*.cpp"
  "generated/*.cxx"
)

file(CREATE_LINK "${CMAKE_CURRENT_SOURCE_DIR}" "${mediapipe_SOURCE_DIR}/mediapipe/autoit" SYMBOLIC)

# https://samthursfield.wordpress.com/2015/11/21/cmake-dependencies-between-targets-and-files-and-custom-commands/

set(PROJECT_PCH "${mediapipe_BINARY_DIR}/mediapipe/autoit/_pch_autoit_mediapipe_com-${MEDIAPIPE_VERSION}-${OPENCV_VERSION_POSTFIX}.pch")
add_custom_command(OUTPUT "${PROJECT_PCH}"
  COMMAND           ${BAZEL_BUILD} mediapipe/autoit:lib_pch
  COMMAND           cmake -E touch "${PROJECT_PCH}"
  WORKING_DIRECTORY "${mediapipe_SOURCE_DIR}"
  DEPENDS           ${project_source_headers}
  VERBATIM
)
add_custom_target(${PROJECT_NAME}_lib_pch DEPENDS "${PROJECT_PCH}")

set(PROJECT_LIBRARY "${mediapipe_BINARY_DIR}/mediapipe/autoit/autoit_mediapipe_com-${MEDIAPIPE_VERSION}-${OPENCV_VERSION_POSTFIX}.dll")
add_custom_command(OUTPUT "${PROJECT_LIBRARY}"
  COMMAND           ${BAZEL_BUILD} mediapipe/autoit:lib
  COMMAND           cmake -E touch "${PROJECT_LIBRARY}"
  WORKING_DIRECTORY "${mediapipe_SOURCE_DIR}"
  DEPENDS           ${PROJECT_NAME}_res ${PROJECT_NAME}_lib_pch "${PROJECT_PCH}" ${project_source_files}
  VERBATIM
)
add_custom_target(${PROJECT_NAME}_lib DEPENDS "${PROJECT_LIBRARY}")

add_custom_target(${PROJECT_NAME} ALL DEPENDS ${PROJECT_NAME}_lib autoit-opencv-com)

foreach(item
  "mediapipe/modules/objectron/object_detection_oidv4_labelmap.txt"
  "mediapipe/modules/hand_landmark/handedness.txt"
)
  get_filename_component(item_target "${item}" NAME_WLE)

  # copy ${mediapipe_SOURCE_DIR}/${item} to ${mediapipe_BINARY_DIR}/${item}
  add_custom_command(OUTPUT "${mediapipe_BINARY_DIR}/${item}"
    COMMAND "${CMAKE_COMMAND}" -E copy_if_different
      "${mediapipe_SOURCE_DIR}/${item}"
      "${mediapipe_BINARY_DIR}/${item}"
    DEPENDS ${PROJECT_NAME}_lib
    VERBATIM
  )
  add_custom_target(${item_target} DEPENDS "${mediapipe_BINARY_DIR}/${item}")

  add_dependencies(${PROJECT_NAME} ${item_target})
endforeach()
