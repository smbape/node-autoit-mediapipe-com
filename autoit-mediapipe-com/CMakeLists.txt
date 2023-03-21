cmake_minimum_required(VERSION 3.19)

# Name of the project (will be the name of the plugin)
project(autoit_mediapipe_com)

set(DEFAULT_BUILD_TYPE "Release")

if(NOT DEFINED CMAKE_BUILD_TYPE)
  message(STATUS "Setting build type to '${DEFAULT_BUILD_TYPE}' as none was specified.")
  set(CMAKE_BUILD_TYPE "${DEFAULT_BUILD_TYPE}" CACHE STRING "Choose the type of build.")
endif()

# Set the possible values of build type for cmake-gui
set(CMAKE_CONFIGURATION_TYPES "Debug;Release;MinSizeRel;RelWithDebInfo" CACHE STRING "Configs" FORCE)
set_property(CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS "${CMAKE_CONFIGURATION_TYPES}")

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

if(WIN32 AND MSVC)
  add_compile_options(/MP)
endif()

include(cmake/RequireOpenCV.cmake)
include(cmake/vcpkg_regex_replace_string.cmake)

set(MEDIAPIPE_VERSION 0.9.1 CACHE STRING "Choose the dlib version.")
set_property(CACHE MEDIAPIPE_VERSION PROPERTY STRINGS "0.9.2.1" "0.9.1" "0.8.11" "0.8.10.2")
string(REPLACE "." "" MEDIAPIPE_DLLVERSION ${MEDIAPIPE_VERSION})

set(MEDIAPIPE_URL_HASH_SHA256_0921 39da28504f4977bff52ee186eb76f7982e006a42a853a8b0cdd5b756cb5f8c6e)
set(MEDIAPIPE_URL_HASH_SHA256_091 437de7632f37b95424106d689f9722c280a571fa452675a22c708cb851395ea7)
set(MEDIAPIPE_URL_HASH_SHA256_0811 5b331a46b459900d0789967f9e26e4a64d1466bc1e74dd0712eb3077358c5473)
set(MEDIAPIPE_URL_HASH_SHA256_08102 a312bf8e69dbe34d3b5c7ea226dcc122aa9e640cbfbf35e1be65d0150b35f1e5)

string(REPLACE "." ";" MEDIAPIPE_VERSION_LIST ${MEDIAPIPE_VERSION})
list(GET MEDIAPIPE_VERSION_LIST 0 MEDIAPIPE_VERSION_MAJOR)
list(GET MEDIAPIPE_VERSION_LIST 1 MEDIAPIPE_VERSION_MINOR)
list(GET MEDIAPIPE_VERSION_LIST 2 MEDIAPIPE_VERSION_PATCH)

# Used in 001-mediapipe-src.patch.in
file(TO_NATIVE_PATH "${OpenCV_DIR}" OpenCV_DIR_ESC)
string(REPLACE \\ \\\\ OpenCV_DIR_ESC "${OpenCV_DIR_ESC}")
configure_file("${CMAKE_CURRENT_SOURCE_DIR}/patches/001-mediapipe-src.patch.in" "${CMAKE_CURRENT_SOURCE_DIR}/patches/001-mediapipe-src.patch" @ONLY)

# Tell cmake that we will need mediapipe.
include(FetchContent)
FetchContent_Declare(mediapipe
  URL               https://fossies.org/linux/misc/mediapipe-${MEDIAPIPE_VERSION}.tar.gz
                    https://github.com/google/mediapipe/archive/refs/tags/v${MEDIAPIPE_VERSION}.tar.gz
  URL_HASH          SHA256=${MEDIAPIPE_URL_HASH_SHA256_${MEDIAPIPE_DLLVERSION}}
  PATCH_COMMAND     "${PATCH}" -p 1 -d "<SOURCE_DIR>" -i "${CMAKE_CURRENT_SOURCE_DIR}/patches/001-mediapipe-src.patch"
)
FetchContent_Populate(mediapipe)

# Tell cmake that we will need autoit-opencv-com.
set(OPENCV_COM_VERSION 2.4.0)
include(ExternalProject)
ExternalProject_Add(autoit_opencv_com
  URL               https://github.com/smbape/node-autoit-opencv-com/releases/download/v${OPENCV_COM_VERSION}/autoit-opencv-${OpenCV_VERSION}-com-v${OPENCV_COM_VERSION}.7z
  URL_HASH          SHA256=94ef0c9e4105c808595f4fae135c912ca6776618c8734b2742bda76658bfc7be
  DOWNLOAD_NO_EXTRACT TRUE
  DOWNLOAD_DIR      "${CMAKE_CURRENT_SOURCE_DIR}/.."
  SOURCE_DIR        "${CMAKE_CURRENT_SOURCE_DIR}/../autoit-opencv-com"
  CONFIGURE_COMMAND ""
  BUILD_COMMAND     ""
  INSTALL_COMMAND   7z x "<DOWNLOAD_DIR>/autoit-opencv-${OpenCV_VERSION}-com-v${OPENCV_COM_VERSION}.7z" -aoa "-o<SOURCE_DIR>" -y
)
ExternalProject_Get_property(autoit_opencv_com SOURCE_DIR)
set(autoit_opencv_com_SOURCE_DIR ${SOURCE_DIR})
unset(SOURCE_DIR)
set(OpenCVCOM_ASSEMBLY_DLL "${autoit_opencv_com_SOURCE_DIR}/dotnet/OpenCV.InteropServices.dll")
file(TO_NATIVE_PATH "${OpenCVCOM_ASSEMBLY_DLL}" OpenCVCOM_ASSEMBLY_DLL)

find_package(Python COMPONENTS Interpreter REQUIRED)

# update version in files
vcpkg_regex_replace_string("${CMAKE_CURRENT_SOURCE_DIR}/BUILD" "OPENCV_VERSION = \"[0-9]+\"  # [0-9]+\\.[0-9]+\\.[0-9]+" "OPENCV_VERSION = \"${OpenCV_DLLVERSION}\"  # ${OpenCV_VERSION}")
vcpkg_regex_replace_string("${CMAKE_CURRENT_SOURCE_DIR}/BUILD" "MEDIAPIPE_VERSION = \"[0-9]+(\\.[0-9]+)+\"" "MEDIAPIPE_VERSION = \"${MEDIAPIPE_VERSION}\"")
vcpkg_regex_replace_string("${CMAKE_CURRENT_SOURCE_DIR}/install.bat" "\\\\x64\\\\vc[^\\\\]+\\\\bin" "\\\\${OpenCV_VC_PATH_ESC}\\\\bin")
vcpkg_regex_replace_string("${CMAKE_CURRENT_SOURCE_DIR}/src/autoit_def.h" "#define AUTOIT_LIB_VERSION [0-9]+(\\.[0-9]+)+" "#define AUTOIT_LIB_VERSION ${MEDIAPIPE_VERSION}")
vcpkg_regex_replace_string("${CMAKE_CURRENT_SOURCE_DIR}/udf/mediapipe_udf.au3" "opencv_world[0-9]+" "opencv_world${OpenCV_DLLVERSION}")
vcpkg_regex_replace_string("${CMAKE_CURRENT_SOURCE_DIR}/../src/gen.js" "MEDIAPIPE_VERSION = \"[0-9]+(\\.[0-9]+)+\"" "MEDIAPIPE_VERSION = \"${MEDIAPIPE_VERSION}\"")
vcpkg_regex_replace_string("${CMAKE_CURRENT_SOURCE_DIR}/../src/gen.js" "OPENCV_COM_VERSION = \"[0-9]+\\.[0-9]+\\.[0-9]+\"" "OPENCV_COM_VERSION = \"${OPENCV_COM_VERSION}\"")
vcpkg_regex_replace_string("${CMAKE_CURRENT_SOURCE_DIR}/../README.md" "opencv-[0-9]+\\.[0-9]+\\.[0-9]+-(vc14_vc15|windows)\\.(exe|zip)" "${OpenCV_DOWNLOAD_NAME}")
vcpkg_regex_replace_string("${CMAKE_CURRENT_SOURCE_DIR}/../README.md" "opencv-[0-9]+\\.[0-9]+\\.[0-9]+-(vc14_vc15|windows)" "${OpenCV_OUTPUT_DIR}")
vcpkg_regex_replace_string("${CMAKE_CURRENT_SOURCE_DIR}/../README.md" "/opencv/releases/download/[0-9]+\\.[0-9]+\\.[0-9]+/" "/opencv/releases/download/${OpenCV_VERSION}/")
vcpkg_regex_replace_string("${CMAKE_CURRENT_SOURCE_DIR}/../README.md" "\\\\x64\\\\vc[^\\\\]+\\\\bin" "\\\\${OpenCV_VC_PATH_ESC}\\\\bin")
vcpkg_regex_replace_string("${CMAKE_CURRENT_SOURCE_DIR}/../README.md" "\\\\\\\\x64\\\\\\\\vc[^\\\\]+\\\\\\\\bin" "\\\\\\\\${OpenCV_VC_PATH_ESC_ESC}\\\\\\\\bin")
vcpkg_regex_replace_string("${CMAKE_CURRENT_SOURCE_DIR}/../README.md" "(autoit-opencv-com/releases/download/|autoit-opencv-[0-9]+\\.[0-9]+\\.[0-9]+-com-)v[0-9]+\\.[0-9]+\\.[0-9]+" "\\1v${OPENCV_COM_VERSION}")

vcpkg_regex_replace_string("${CMAKE_CURRENT_SOURCE_DIR}/udf/mediapiped.sxs.manifest"
  "name=\"autoit_opencv_com[0-9]+d.sxs\" version=\"[0-9]+\\.[0-9]+\\.[0-9]+\\.[0-9]+\""
  "name=\"autoit_opencv_com${OpenCV_DLLVERSION}d.sxs\" version=\"${OPENCV_COM_VERSION}.0\""
)

vcpkg_regex_replace_string("${CMAKE_CURRENT_SOURCE_DIR}/udf/mediapipe.sxs.manifest"
  "name=\"autoit_opencv_com[0-9]+.sxs\" version=\"[0-9]+\\.[0-9]+\\.[0-9]+\\.[0-9]+\""
  "name=\"autoit_opencv_com${OpenCV_DLLVERSION}.sxs\" version=\"${OPENCV_COM_VERSION}.0\""
)

file(GLOB_RECURSE files_to_change
  dotnet/MediapipeComInterop.cs
  src/mediapipeCOM.rc
  udf/mediapipe_udf.au3
  udf/mediapipe_udf_utils.au3
  udf/mediapipe.sxs.manifest
  udf/mediapiped.sxs.manifest
  install.bat
  ../scripts/build.js
  ../src/gen.js
  ../README.md
)
foreach(item ${files_to_change})
  vcpkg_regex_replace_string("${item}" "autoit_mediapipe_com-[0-9]+(\\.[0-9]+)+-[0-9]+" "autoit_mediapipe_com-${MEDIAPIPE_VERSION}-${OpenCV_DLLVERSION}")
  vcpkg_regex_replace_string("${item}" "(opencv_world|autoit_opencv_com|opencv_videoio_ffmpeg)[0-9]+" "\\1${OpenCV_DLLVERSION}")
  vcpkg_regex_replace_string("${item}" "mediapipe-[0-9]+(\\.[0-9]+)+" "mediapipe-${MEDIAPIPE_VERSION}")
  vcpkg_regex_replace_string("${item}" "opencv-[0-9]+\\.[0-9]+\\.[0-9]+" "opencv-${OpenCV_VERSION}")
endforeach()

file(GLOB_RECURSE files_to_change "../test/*.au3" "../examples/*.au3" "../examples/*.cs" "../examples/*.ps1")
foreach(item ${files_to_change})
  vcpkg_regex_replace_string("${item}" "/v[0-9]+\\.[0-9]+\\.[0-9]+/mediapipe/" "/v${MEDIAPIPE_VERSION}/mediapipe/")
endforeach()

set(EXECUTABLE_OUTPUT_PATH "${CMAKE_BINARY_DIR}/bin" CACHE PATH "Output directory for applications")
set(LIBRARY_OUTPUT_PATH "${CMAKE_BINARY_DIR}/lib" CACHE PATH "Output directory for libraries")

if("${CMAKE_BUILD_TYPE}" STREQUAL Debug)
  set(CMODE dbg)
else()
  set(CMODE opt)
endif()

set(mediapipe_BINARY_DIR "${mediapipe_SOURCE_DIR}/bazel-out/x64_windows-${CMODE}/bin")

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
  COMMAND node --unhandled-rejections=strict --trace-uncaught --trace-warnings src/gen.js
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

file(GLOB_RECURSE project_build_files
  "rules_impl/*"
)

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

set(PROJECT_COM_NAME "autoit_mediapipe_com-${MEDIAPIPE_VERSION}-${OpenCV_DLLVERSION}${OpenCV_BUILD_DEBUG_POSTFIX}")

set(PROJECT_PCH "${mediapipe_BINARY_DIR}/mediapipe/autoit/_pch_${PROJECT_COM_NAME}.pch")
add_custom_command(OUTPUT "${PROJECT_PCH}"
  COMMAND           ${BAZEL_BUILD} mediapipe/autoit:lib_pch
  COMMAND           cmake -E touch "${PROJECT_PCH}"
  WORKING_DIRECTORY "${mediapipe_SOURCE_DIR}"
  DEPENDS           ${project_source_headers} ${project_build_files}
  VERBATIM
)
add_custom_target(${PROJECT_NAME}_lib_pch DEPENDS "${PROJECT_PCH}")

set(PROJECT_LIBRARY "${mediapipe_BINARY_DIR}/mediapipe/autoit/${PROJECT_COM_NAME}.dll")
add_custom_command(OUTPUT "${PROJECT_LIBRARY}"
  COMMAND           ${BAZEL_BUILD} mediapipe/autoit:lib
  COMMAND           cmake -E touch "${PROJECT_LIBRARY}"
  WORKING_DIRECTORY "${mediapipe_SOURCE_DIR}"
  DEPENDS           ${PROJECT_NAME}_res ${PROJECT_NAME}_lib_pch "${PROJECT_PCH}" ${project_source_files} ${project_build_files}
  VERBATIM
)
add_custom_target(${PROJECT_NAME}_lib DEPENDS "${PROJECT_LIBRARY}")

add_custom_target(${PROJECT_NAME} ALL DEPENDS ${PROJECT_NAME}_lib autoit_opencv_com)

string(REPLACE ".dll" ".sxs.manifest" PROJECT_MANIFEST "${PROJECT_LIBRARY}")
add_custom_command(
  TARGET ${PROJECT_NAME}
  POST_BUILD
  COMMAND mt.exe -manifest \"${PROJECT_MANIFEST}\" -validate_manifest
  COMMAND attrib -r \"${PROJECT_LIBRARY}\"
  COMMAND mt.exe -manifest \"${PROJECT_MANIFEST}\" -outputresource:\"${PROJECT_LIBRARY}\"\;\#2
  COMMAND attrib +r \"${PROJECT_LIBRARY}\"

  COMMAND "${CMAKE_COMMAND}" -P "${CMAKE_CURRENT_SOURCE_DIR}/cmake/glob_copy.cmake" --
    "${mediapipe_BINARY_DIR}/mediapipe/autoit/${PROJECT_COM_NAME}*.dll"
    "${mediapipe_BINARY_DIR}/mediapipe/autoit/${PROJECT_COM_NAME}*.lib"
    "${mediapipe_BINARY_DIR}/mediapipe/autoit/${PROJECT_COM_NAME}*.exp"
    "${mediapipe_BINARY_DIR}/mediapipe/autoit/${PROJECT_COM_NAME}*.pdb"
    "${PROJECT_MANIFEST}"
    "${EXECUTABLE_OUTPUT_PATH}/${CMAKE_BUILD_TYPE}"

  COMMENT "Adding manifest..." 
)

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

if (CMAKE_GENERATOR MATCHES "Visual Studio")
# ===============
# C# Interop target
# ===============
include(CSharpUtilities)
enable_language(CSharp)

file(GLOB_RECURSE cs_files "dotnet/*.cs")
add_library(interop_mediapipe SHARED ${cs_files})

set_target_properties(interop_mediapipe PROPERTIES
  OUTPUT_NAME "interop.mediapipe-${MEDIAPIPE_VERSION_MAJOR}"
  DEBUG_POSTFIX "${OpenCV_DEBUG_POSTFIX}"
  VS_DOTNET_REFERENCES "Microsoft.CSharp;System"
)

foreach( BUILD_TYPE ${CMAKE_CONFIGURATION_TYPES} )
  string( TOUPPER ${BUILD_TYPE} BUILD_TYPE_UPPER )
  set_target_properties(interop_mediapipe PROPERTIES RUNTIME_OUTPUT_DIRECTORY_${BUILD_TYPE_UPPER} "${EXECUTABLE_OUTPUT_PATH}/${BUILD_TYPE}/dotnet")
endforeach()

# Always generate debug files
if(MSVC AND NOT "${CMAKE_BUILD_TYPE}" STREQUAL "Debug")
  target_compile_options(interop_mediapipe PRIVATE "-debug:pdbonly")
endif()

# ===============
# C# Assembly target
# ===============
set(ASSEMBLY_DLL "${CMAKE_CURRENT_SOURCE_DIR}/generated/dotnet/Mediapipe.InteropServices.dll")
file(TO_NATIVE_PATH "${ASSEMBLY_DLL}" ASSEMBLY_DLL)
file(TO_NATIVE_PATH "generated/mediapipeCOM.tlb" TYPELIB)
add_custom_command(OUTPUT "${ASSEMBLY_DLL}"
  COMMAND           tlbimp.exe
                    "/out:${ASSEMBLY_DLL}"
                    /VariantBoolFieldToBool
                    /strictref
                    # /noclassmembers
                    /machine:X64
                    "${TYPELIB}"
  # COMMAND           cmake -E touch "${ASSEMBLY_DLL}"
  WORKING_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}"
  DEPENDS           "${TYPELIB}"
  VERBATIM
)
add_custom_target(cs_assembly DEPENDS "${ASSEMBLY_DLL}")

# ===============
# cs_test target
# ===============
include(CSharpUtilities)
enable_language(CSharp)

file(GLOB test_files "test/*.cs" "dotnet/*.cs")
add_executable(cs_test ${test_files} "${autoit_opencv_com_SOURCE_DIR}/dotnet/OpenCvComInterop.cs")

set_target_properties(cs_test PROPERTIES
  RUNTIME_OUTPUT_DIRECTORY "${EXECUTABLE_OUTPUT_PATH}"
  DEBUG_POSTFIX "${OpenCV_DEBUG_POSTFIX}"
  VS_GLOBAL_EnableUnmanagedDebugging "true"
  VS_DEBUGGER_ENVIRONMENT "PATH=${OpenCV_BIN_NATIVE_PATH};%PATH%"
  VS_DOTNET_REFERENCES "Microsoft.CSharp;System;System.Core"
  VS_DOTNET_REFERENCE_OpenCVCOM "${OpenCVCOM_ASSEMBLY_DLL}"
  VS_DOTNET_REFERENCEPROP_OpenCVCOM_TAG_EmbedInteropTypes "True"
  VS_DOTNET_REFERENCE_Mediapipe "${ASSEMBLY_DLL}"
  VS_DOTNET_REFERENCEPROP_Mediapipe_TAG_EmbedInteropTypes "True"
)

add_dependencies(cs_test cs_assembly)

# Always generate debug files
if(MSVC AND NOT "${CMAKE_BUILD_TYPE}" STREQUAL "Debug")
  target_compile_options(cs_test PRIVATE "-debug:pdbonly")
endif()

endif()
