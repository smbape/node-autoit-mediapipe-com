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

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

if(WIN32 AND MSVC)
  add_compile_options(/MP)
endif()

include(cmake/RequireOpenCV.cmake)
include(cmake/vcpkg_regex_replace_string.cmake)

if (POLICY CMP0135)
  cmake_policy(SET CMP0135 NEW) # set the timestamps of extracted contents to the time of extraction.
endif()

set(MEDIAPIPE_VERSION 0.10.14 CACHE STRING "Choose the mediapipe version.")
set_property(CACHE MEDIAPIPE_VERSION PROPERTY STRINGS "0.10.14" "0.9.3.0" "0.9.2.1" "0.9.1" "0.8.11" "0.8.10.2")
string(REPLACE "." "" MEDIAPIPE_DLLVERSION ${MEDIAPIPE_VERSION})

set(MEDIAPIPE_URL_HASH_SHA256_01014 9d46fa5363f5c4e11c3d1faec71b0746f15c5aab7b5460d0e5655d7af93c6957)
set(MEDIAPIPE_URL_HASH_SHA256_0930 7f2217a9d13bdd9056992dbdcbd29a290d8726f3f4b783c8eea34e4ce8421a35)
set(MEDIAPIPE_URL_HASH_SHA256_0921 39da28504f4977bff52ee186eb76f7982e006a42a853a8b0cdd5b756cb5f8c6e)
set(MEDIAPIPE_URL_HASH_SHA256_091 437de7632f37b95424106d689f9722c280a571fa452675a22c708cb851395ea7)
set(MEDIAPIPE_URL_HASH_SHA256_0811 5b331a46b459900d0789967f9e26e4a64d1466bc1e74dd0712eb3077358c5473)
set(MEDIAPIPE_URL_HASH_SHA256_08102 a312bf8e69dbe34d3b5c7ea226dcc122aa9e640cbfbf35e1be65d0150b35f1e5)

string(REPLACE "." ";" MEDIAPIPE_VERSION_LIST ${MEDIAPIPE_VERSION})
list(GET MEDIAPIPE_VERSION_LIST 0 MEDIAPIPE_VERSION_MAJOR)
list(GET MEDIAPIPE_VERSION_LIST 1 MEDIAPIPE_VERSION_MINOR)
list(GET MEDIAPIPE_VERSION_LIST 2 MEDIAPIPE_VERSION_PATCH)

cmake_path(RELATIVE_PATH CMAKE_CURRENT_BINARY_DIR BASE_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}" OUTPUT_VARIABLE CMAKE_CURRENT_RELATIVE_BINARY_DIR)
string(REGEX REPLACE "/$" "" CMAKE_CURRENT_RELATIVE_BINARY_DIR "${CMAKE_CURRENT_RELATIVE_BINARY_DIR}")

# Used in 001-mediapipe-src.patch.in
set(MEDIAPIPE_ADDON_PACKAGE "mediapipe/autoit")
set(MEDIAPIPE_ADDON_REPOSITORIES ":${CMAKE_CURRENT_RELATIVE_BINARY_DIR}/third_party/repositories.bzl")
set(MEDIAPIPE_ADDON_RULES_DEPENDENCIES "autoit_rules_dependencies")
configure_file("${CMAKE_CURRENT_SOURCE_DIR}/patches/001-mediapipe-src.patch.in" "${CMAKE_CURRENT_SOURCE_DIR}/patches/001-mediapipe-src.patch" @ONLY)

# Tell cmake that we will need mediapipe.
include(FetchContent)
FetchContent_Populate(mediapipe
  URL               https://fossies.org/linux/misc/mediapipe-${MEDIAPIPE_VERSION}.tar.gz
                    https://github.com/google-ai-edge/mediapipe/archive/refs/tags/v${MEDIAPIPE_VERSION}.tar.gz
  URL_HASH          SHA256=${MEDIAPIPE_URL_HASH_SHA256_${MEDIAPIPE_DLLVERSION}}
  PATCH_COMMAND     "${PATCH_EXECUTABLE}" -p 1 -d "<SOURCE_DIR>" -i "${CMAKE_CURRENT_SOURCE_DIR}/patches/001-mediapipe-src.patch"
)

file(CREATE_LINK "${CMAKE_CURRENT_SOURCE_DIR}" "${mediapipe_SOURCE_DIR}/${MEDIAPIPE_ADDON_PACKAGE}" SYMBOLIC)

set(OpenCV_PLATFORM "windows_opencv")

set(OpenCV_INCLUDE_DIR "${OpenCV_DIR}/include")

set(OpenCV_LIBRARIES_DEBUG)
list(APPEND OpenCV_LIBRARIES_DEBUG "${OpenCV_DIR}/${OpenCV_VC_PATH}/lib/opencv_world${OpenCV_DLLVERSION}d.lib")
list(APPEND OpenCV_LIBRARIES_DEBUG "${OpenCV_DIR}/${OpenCV_VC_PATH}/bin/opencv_world${OpenCV_DLLVERSION}d.dll")
list(JOIN OpenCV_LIBRARIES_DEBUG "\",\n            \"" OpenCV_LIBRARIES_DEBUG)

set(OpenCV_LIBRARIES_RELEASE)
list(APPEND OpenCV_LIBRARIES_RELEASE "${OpenCV_DIR}/${OpenCV_VC_PATH}/lib/opencv_world${OpenCV_DLLVERSION}.lib")
list(APPEND OpenCV_LIBRARIES_RELEASE "${OpenCV_DIR}/${OpenCV_VC_PATH}/bin/opencv_world${OpenCV_DLLVERSION}.dll")
list(JOIN OpenCV_LIBRARIES_RELEASE "\",\n            \"" OpenCV_LIBRARIES_RELEASE)

configure_file("${CMAKE_CURRENT_SOURCE_DIR}/scripts/configure_bazel.js.in" "${CMAKE_CURRENT_SOURCE_DIR}/scripts/configure_bazel.js" @ONLY)

find_program(NODE_EXECUTABLE
  NAMES node
  REQUIRED
)

find_program(NPM_EXECUTABLE
  NAMES npm npm.cmd NAMES_PER_DIR
  REQUIRED
)

if(NOT EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/../node_modules")
  execute_process(
    COMMAND "${NPM_EXECUTABLE}" ci
    WORKING_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/.."
    COMMAND_ECHO STDERR
    COMMAND_ERROR_IS_FATAL ANY
  )
endif()

if (NOT mediapipe_autoit_SKIP_GENERATION)
  execute_process(
    COMMAND "${NODE_EXECUTABLE}" --unhandled-rejections=strict --trace-uncaught --trace-warnings scripts/configure_bazel.js
    WORKING_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}"
    COMMAND_ECHO STDERR
    COMMAND_ERROR_IS_FATAL ANY
  )
endif()

# Tell cmake that we will need autoit-opencv-com.
set(OPENCV_COM_VERSION 2.7.0)
set(OPENCV_COM_ARCHIVE "autoit-opencv-${OpenCV_VERSION}-com-v${OPENCV_COM_VERSION}.7z")
cmake_path(SET OPENCV_COM_SOURCE_DIR NORMALIZE "${CMAKE_CURRENT_SOURCE_DIR}/../../node-autoit-opencv-com")
if (EXISTS "${OPENCV_COM_SOURCE_DIR}/${OPENCV_COM_ARCHIVE}")
  set(OPENCV_COM_URL "${OPENCV_COM_SOURCE_DIR}/${OPENCV_COM_ARCHIVE}")
else()
  set(OPENCV_COM_URL "https://github.com/smbape/node-autoit-opencv-com/releases/download/v${OPENCV_COM_VERSION}/${OPENCV_COM_ARCHIVE}")
endif()
include(FetchContent)
FetchContent_Declare(autoit_opencv_com
  URL               "${OPENCV_COM_URL}"
  URL_HASH          SHA256=8d7f8aabce052c321ef58a70a5379f73ca0b57047ac1cba44439006510060996
  DOWNLOAD_DIR      "${CMAKE_CURRENT_SOURCE_DIR}/.."
  SOURCE_DIR        "${CMAKE_CURRENT_SOURCE_DIR}/../autoit-opencv-com"
)
FetchContent_MakeAvailable(autoit_opencv_com)

# update version in files
vcpkg_regex_replace_string("${CMAKE_CURRENT_SOURCE_DIR}/BUILD" "OPENCV_VERSION = \"[0-9]+\"  # [0-9]+\\.[0-9]+\\.[0-9]+" "OPENCV_VERSION = \"${OpenCV_DLLVERSION}\"  # ${OpenCV_VERSION}")
vcpkg_regex_replace_string("${CMAKE_CURRENT_SOURCE_DIR}/BUILD" "MEDIAPIPE_VERSION = \"[0-9]+(\\.[0-9]+)+\"" "MEDIAPIPE_VERSION = \"${MEDIAPIPE_VERSION}\"")
vcpkg_regex_replace_string("${CMAKE_CURRENT_SOURCE_DIR}/src/autoit_def.h" "#define AUTOIT_LIB_VERSION [0-9]+(\\.[0-9]+)+" "#define AUTOIT_LIB_VERSION ${MEDIAPIPE_VERSION}")
vcpkg_regex_replace_string("${CMAKE_CURRENT_SOURCE_DIR}/../src/gen.js" "MEDIAPIPE_VERSION = \"[0-9]+(\\.[0-9]+)+\"" "MEDIAPIPE_VERSION = \"${MEDIAPIPE_VERSION}\"")
vcpkg_regex_replace_string("${CMAKE_CURRENT_SOURCE_DIR}/../src/gen.js" "OPENCV_COM_VERSION = \"[0-9]+\\.[0-9]+\\.[0-9]+\"" "OPENCV_COM_VERSION = \"${OPENCV_COM_VERSION}\"")
vcpkg_regex_replace_string("${CMAKE_CURRENT_SOURCE_DIR}/../README.md" "(autoit-opencv-com/releases/download/|autoit-opencv-[0-9]+\\.[0-9]+\\.[0-9]+-com-)v[0-9]+\\.[0-9]+\\.[0-9]+" "\\1v${OPENCV_COM_VERSION}")

vcpkg_regex_replace_string("${CMAKE_CURRENT_SOURCE_DIR}/udf/mediapiped.sxs.manifest"
  "name=\"autoit_opencv_com[0-9]+d.sxs\" version=\"[0-9]+\\.[0-9]+\\.[0-9]+\\.[0-9]+\""
  "name=\"autoit_opencv_com${OpenCV_DLLVERSION}d.sxs\" version=\"${OPENCV_COM_VERSION}.0\""
)

vcpkg_regex_replace_string("${CMAKE_CURRENT_SOURCE_DIR}/udf/mediapipe.sxs.manifest"
  "name=\"autoit_opencv_com[0-9]+.sxs\" version=\"[0-9]+\\.[0-9]+\\.[0-9]+\\.[0-9]+\""
  "name=\"autoit_opencv_com${OpenCV_DLLVERSION}.sxs\" version=\"${OPENCV_COM_VERSION}.0\""
)

vcpkg_regex_replace_string("${CMAKE_CURRENT_SOURCE_DIR}/../scripts/manual.sh"
  "echo '[a-z0-9]+ (mediapipe-[^']+)' \\| sha256sum"
  "echo '${MEDIAPIPE_URL_HASH_SHA256_${MEDIAPIPE_DLLVERSION}} \\1' | sha256sum"
)

file(GLOB_RECURSE files_to_change
  dotnet/*.cs
  src/mediapipeCOM.rc
  udf/*.au3
  udf/*.sxs.manifest
  install.bat
  ../scripts/build.js
  ../scripts/manual.sh
  ../src/gen.js
  ../README.md

  ../test/*.au3
  ../examples/*.au3
  ../examples/*.cs
  ../examples/*.ps1
)
foreach(item ${files_to_change})
  vcpkg_regex_replace_string("${item}" "autoit_mediapipe_com-[0-9]+(\\.[0-9]+)+-[0-9]+" "autoit_mediapipe_com-${MEDIAPIPE_VERSION}-${OpenCV_DLLVERSION}")
  vcpkg_regex_replace_string("${item}" "mediapipe-[0-9]+(\\.[0-9]+)+" "mediapipe-${MEDIAPIPE_VERSION}")
  vcpkg_regex_replace_string("${item}" "/v[0-9]+(\\.[0-9]+)+/mediapipe/" "/v${MEDIAPIPE_VERSION}/mediapipe/")
  vcpkg_regex_replace_string("${item}" "(/google-ai-edge/mediapipe/archive/refs/tags/v)[0-9]+(\\.[0-9]+)+" "\\1${MEDIAPIPE_VERSION}")
  vcpkg_regex_replace_string("${item}" "autoit_mediapipe_com-\\*-[0-9]+\\*" "autoit_mediapipe_com-*-${OpenCV_DLLVERSION}*")

  vcpkg_regex_replace_string("${item}" "(https://docs\\.opencv\\.org/|https://github\\.com/opencv/opencv/blob/|opencv-)[0-9]+\\.[0-9]+\\.[0-9]+/" "\\1${OpenCV_VERSION}/")
  vcpkg_regex_replace_string("${item}" "opencv-[0-9]+\\.[0-9]+\\.[0-9]+-(vc14_vc15|windows)\\.(exe|zip)" "${OpenCV_DOWNLOAD_NAME}")
  vcpkg_regex_replace_string("${item}" "opencv-[0-9]+\\.[0-9]+\\.[0-9]+-(vc14_vc15|windows)" "${OpenCV_OUTPUT_DIR}")
  vcpkg_regex_replace_string("${item}" "opencv-[0-9]+\\.[0-9]+\\.[0-9]+" "opencv-${OpenCV_VERSION}")
  vcpkg_regex_replace_string("${item}" "(opencv_world|autoit_opencv_com|opencv_videoio_ffmpeg)[0-9]+" "\\1${OpenCV_DLLVERSION}")
  vcpkg_regex_replace_string("${item}" "/opencv/releases/download/[0-9]+\\.[0-9]+\\.[0-9]+/" "/opencv/releases/download/${OpenCV_VERSION}/")
  vcpkg_regex_replace_string("${item}" "\\\\x64\\\\vc[^\\\\]+\\\\bin" "\\\\${OpenCV_VC_PATH_ESC}\\\\bin")
endforeach()

set(EXECUTABLE_OUTPUT_PATH "${CMAKE_BINARY_DIR}/bin" CACHE PATH "Output directory for applications")
set(LIBRARY_OUTPUT_PATH "${CMAKE_BINARY_DIR}/lib" CACHE PATH "Output directory for libraries")

if("${CMAKE_BUILD_TYPE}" STREQUAL "Debug")
  set(CMODE dbg)
else()
  set(CMODE opt)
endif()

set(mediapipe_BINARY_DIR "${mediapipe_SOURCE_DIR}/bazel-out/x64_windows-${CMODE}/bin")

include(cmake/UsePython3Venv.cmake)

# Needed python packages
pip_install(absl-py mediapipe numpy opencv-python)

# Avoid long paths on windows
# https://bazel.build/remote/output-directories#layout
set(OUTPUT_USER_ROOT "C:/_bazel_" CACHE PATH "Bazel output user root")

option(MEDIAPIPE_DISABLE_GPU "Disable GPU support" ON)

find_program(BAZEL_EXECUTABLE
  NAMES bazel
  DOC 
  REQUIRED "Bazel executable"
)

set(BAZEL_BUILD "${BAZEL_EXECUTABLE}"
  "--output_user_root=${OUTPUT_USER_ROOT}"
  build -c ${CMODE}
  --strip=never
  --action_env "PYTHON_BIN_PATH=${PYTHON_BIN_PATH}"
  --verbose_failures
)

if (MEDIAPIPE_DISABLE_GPU)
  list(APPEND BAZEL_BUILD --define MEDIAPIPE_DISABLE_GPU=1)
endif()

if (ENABLE_ODML_CONVERTER)
  list(APPEND BAZEL_BUILD --define ENABLE_ODML_CONVERTER=1)
endif()

# list(APPEND BAZEL_BUILD --keep_going)

# generate source files
if(
  ${VIRTUAL_ENV_created} OR
  (NOT EXISTS "${mediapipe_BINARY_DIR}/external/com_google_protobuf/any_proto-descriptor-set.proto.bin") OR
  (NOT EXISTS "${mediapipe_SOURCE_DIR}/bazel-mediapipe-src/external/com_google_protobuf/src")
)
  execute_process(
    COMMAND ${BAZEL_BUILD} mediapipe/python:builtin_calculators
    WORKING_DIRECTORY "${mediapipe_SOURCE_DIR}"
    COMMAND_ECHO STDERR
    COMMAND_ERROR_IS_FATAL ANY
  )
endif()

option(SKIP_bindings_generation "Skip binding files generation" OFF)

if (NOT SKIP_bindings_generation)
  set(src_gen_cmd "${NODE_EXECUTABLE}" --unhandled-rejections=strict --trace-uncaught --trace-warnings src/gen.js)

  if (ENABLE_ODML_CONVERTER)
    list(APPEND src_gen_cmd -DENABLE_ODML_CONVERTER)
  endif()

  execute_process(
    COMMAND ${src_gen_cmd}
    WORKING_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/.."
    COMMAND_ECHO STDERR
    COMMAND_ERROR_IS_FATAL ANY
  )
endif()

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

file(GLOB_RECURSE project_rules_files
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

# https://samthursfield.wordpress.com/2015/11/21/cmake-dependencies-between-targets-and-files-and-custom-commands/

set(BAZEL_OUTPUT_LIBNAME "autoit_mediapipe_com-${MEDIAPIPE_VERSION}-${OpenCV_DLLVERSION}")
set(BAZEL_OUTPUT_NAME "${BAZEL_OUTPUT_LIBNAME}${OpenCV_BUILD_DEBUG_POSTFIX}")

set(PROJECT_LIBRARY "${mediapipe_BINARY_DIR}/${MEDIAPIPE_ADDON_PACKAGE}/${BAZEL_OUTPUT_NAME}${CMAKE_SHARED_LIBRARY_SUFFIX}")
add_custom_command(OUTPUT "${PROJECT_LIBRARY}"
  COMMAND           ${BAZEL_BUILD} ${MEDIAPIPE_ADDON_PACKAGE}:lib
  WORKING_DIRECTORY "${mediapipe_SOURCE_DIR}"
  DEPENDS           ${project_source_files} ${project_rules_files}
  VERBATIM
  USES_TERMINAL
)
add_custom_target(${PROJECT_NAME}_lib DEPENDS "${PROJECT_LIBRARY}")

add_custom_target(${PROJECT_NAME} ALL DEPENDS ${PROJECT_NAME}_lib autoit_opencv_com)

string(REPLACE ".dll" ".sxs.manifest" PROJECT_MANIFEST "${PROJECT_LIBRARY}")
add_custom_command(TARGET ${PROJECT_NAME} POST_BUILD
  COMMAND mt.exe -manifest \"${PROJECT_MANIFEST}\" -validate_manifest
  COMMAND attrib -r \"${PROJECT_LIBRARY}\"
  COMMAND mt.exe -manifest \"${PROJECT_MANIFEST}\" -outputresource:\"${PROJECT_LIBRARY}\"\;\#2
  COMMAND attrib +r \"${PROJECT_LIBRARY}\"

  COMMAND "${CMAKE_COMMAND}" -P "${CMAKE_CURRENT_SOURCE_DIR}/cmake/glob_copy.cmake" --
    "${mediapipe_BINARY_DIR}/${MEDIAPIPE_ADDON_PACKAGE}/${BAZEL_OUTPUT_NAME}*.dll"
    "${mediapipe_BINARY_DIR}/${MEDIAPIPE_ADDON_PACKAGE}/${BAZEL_OUTPUT_NAME}*.lib"
    "${mediapipe_BINARY_DIR}/${MEDIAPIPE_ADDON_PACKAGE}/${BAZEL_OUTPUT_NAME}*.exp"
    "${mediapipe_BINARY_DIR}/${MEDIAPIPE_ADDON_PACKAGE}/${BAZEL_OUTPUT_NAME}*.pdb"
    "${PROJECT_MANIFEST}"
    "${EXECUTABLE_OUTPUT_PATH}/${CMAKE_BUILD_TYPE}"

  COMMENT "Adding manifest..." 
)

foreach(item
  "mediapipe/modules/objectron/object_detection_oidv4_labelmap.txt"
  "mediapipe/modules/hand_landmark/handedness.txt"
)
  get_filename_component(item_target "${item}" NAME_WLE)
  set(item_output "${mediapipe_BINARY_DIR}/${item}")

  # copy ${mediapipe_SOURCE_DIR}/${item} to ${mediapipe_BINARY_DIR}/${item}
  add_custom_command(OUTPUT "${item_output}"
    COMMAND "${CMAKE_COMMAND}" -E copy_if_different
      "${mediapipe_SOURCE_DIR}/${item}"
      "${mediapipe_BINARY_DIR}/${item}"
    DEPENDS ${PROJECT_NAME}_lib
    VERBATIM
  )
  add_custom_target(${item_target} DEPENDS "${item_output}")

  add_dependencies(${PROJECT_NAME} ${item_target})

  unset(item_output)
  unset(item_target)
endforeach()

include(cmake/get_temp_dir.cmake)
get_temp_dir(TEMPDIR)

if (TEMPDIR)
  set(mediapipe_SOLUTIONS_DIR "${mediapipe_SOURCE_DIR}/mediapipe/python/solutions")

  set(item_target test_on_video_fullasl_hand_full_npz)
  set(item_test_data "${CMAKE_SOURCE_DIR}/../test/solutions/testdata")
  set(item_output "${item_test_data}/test_on_video_fullasl_hand.full.yml")

  include(ExternalProject)
  ExternalProject_Add(
      asl_hand_25fps_mp4
      URL https://github.com/tensorflow/tfjs-models/raw/master/hand-pose-detection/test_data/asl_hand.25fps.mp4
      URL_HASH SHA256=57c10fb1eb76639edf43e9675213dcc495c51851e32a3592cacaa9437be4f37e
      DOWNLOAD_NO_EXTRACT TRUE
      DOWNLOAD_DIR      "${mediapipe_SOLUTIONS_DIR}/testdata"
      SOURCE_DIR        "${mediapipe_SOLUTIONS_DIR}/testdata"
      CONFIGURE_COMMAND ""
      BUILD_COMMAND     ""
      INSTALL_COMMAND   "${CMAKE_COMMAND}" -E copy_if_different "<DOWNLOAD_DIR>/asl_hand.25fps.mp4" "${item_test_data}/asl_hand.25fps.mp4"
  )

  add_custom_command(OUTPUT "${item_output}"
    COMMAND "${Python3_EXECUTABLE}" hands_test.py -- -k test_on_video 2> NUL || type NUL > NUL
    COMMAND "${Python3_EXECUTABLE}" "${CMAKE_SOURCE_DIR}/../test/solutions/npz_convert.py" "${TEMPDIR}/test_on_video_fullasl_hand.full.npz" -o "${item_output}"
    DEPENDS ${PROJECT_NAME}_lib asl_hand_25fps_mp4
    WORKING_DIRECTORY "${mediapipe_SOLUTIONS_DIR}"
    VERBATIM
  )
  add_custom_target(${item_target} DEPENDS "${item_output}")

  add_dependencies(${PROJECT_NAME} ${item_target})

  set(item_target test_on_video_fullpose_squats_npz)
  set(item_test_data "${CMAKE_SOURCE_DIR}/../test/solutions/testdata")
  set(item_output "${item_test_data}/test_on_video_fullpose_squats.full.yml")

  include(ExternalProject)
  ExternalProject_Add(
      pose_squats_mp4
      URL https://github.com/tensorflow/tfjs-models/raw/master/pose-detection/test_data/pose_squats.mp4
      URL_HASH SHA256=ea9151e447b301985d5d65666551ef863b369a2e0f3a71ddd58abef2e722f96a
      DOWNLOAD_NO_EXTRACT TRUE
      DOWNLOAD_DIR      "${mediapipe_SOLUTIONS_DIR}/testdata"
      SOURCE_DIR        "${mediapipe_SOLUTIONS_DIR}/testdata"
      CONFIGURE_COMMAND ""
      BUILD_COMMAND     ""
      INSTALL_COMMAND   "${CMAKE_COMMAND}" -E copy_if_different "<DOWNLOAD_DIR>/pose_squats.mp4" "${item_test_data}/pose_squats.mp4"
  )

  add_custom_command(OUTPUT "${item_output}"
    COMMAND "${Python3_EXECUTABLE}" pose_test.py -- -k test_on_video 2> NUL || type NUL > NUL
    COMMAND "${Python3_EXECUTABLE}" "${CMAKE_SOURCE_DIR}/../test/solutions/npz_convert.py" "${TEMPDIR}/test_on_video_fullpose_squats.full.npz" -o "${item_output}"
    DEPENDS ${PROJECT_NAME}_lib pose_squats_mp4
    WORKING_DIRECTORY "${mediapipe_SOLUTIONS_DIR}"
    VERBATIM
  )
  add_custom_target(${item_target} DEPENDS "${item_output}")

  add_dependencies(${PROJECT_NAME} ${item_target})

  unset(item_output)
  unset(item_target)
endif()

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

set(OpenCVCOM_ASSEMBLY_DLL "${autoit_opencv_com_SOURCE_DIR}/dotnet/OpenCV.InteropServices.dll")
file(TO_NATIVE_PATH "${OpenCVCOM_ASSEMBLY_DLL}" OpenCVCOM_ASSEMBLY_DLL)

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
