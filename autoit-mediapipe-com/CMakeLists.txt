cmake_minimum_required(VERSION 3.19)

# Name of the project (will be the name of the plugin)
project(autoit_mediapipe_com)

set(target_name ${PROJECT_NAME})

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

set(Mediapipe_VERSION 1.0.0 CACHE STRING "Choose the mediapipe version.")
set_property(CACHE Mediapipe_VERSION PROPERTY STRINGS "1.0.0")
string(REPLACE "." "" MEDIAPIPE_DLLVERSION ${Mediapipe_VERSION})

set(MEDIAPIPE_URL_HASH_SHA256_100 6343314dad0f4112610807ca723eee63feea00711dc2be9360928b6f0a5eba12)

string(REPLACE "." ";" Mediapipe_VERSION_LIST ${Mediapipe_VERSION})
list(GET Mediapipe_VERSION_LIST 0 Mediapipe_VERSION_MAJOR)
list(GET Mediapipe_VERSION_LIST 1 Mediapipe_VERSION_MINOR)
list(GET Mediapipe_VERSION_LIST 2 Mediapipe_VERSION_PATCH)

cmake_path(RELATIVE_PATH CMAKE_CURRENT_BINARY_DIR BASE_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}" OUTPUT_VARIABLE CMAKE_CURRENT_RELATIVE_BINARY_DIR)
string(REGEX REPLACE "/$" "" CMAKE_CURRENT_RELATIVE_BINARY_DIR "${CMAKE_CURRENT_RELATIVE_BINARY_DIR}")

# Used in 001-mediapipe-src.patch.in
set(MEDIAPIPE_ADDON_PACKAGE "mediapipe/autoit")
set(MEDIAPIPE_ADDON_REPOSITORIES ":${CMAKE_CURRENT_RELATIVE_BINARY_DIR}/third_party/repositories.bzl")
set(MEDIAPIPE_ADDON_RULES_DEPENDENCIES "autoit_rules_dependencies")
configure_file("${CMAKE_CURRENT_SOURCE_DIR}/patches/001-mediapipe-src.patch.in" "${CMAKE_CURRENT_SOURCE_DIR}/patches/001-mediapipe-src.patch" @ONLY NEWLINE_STYLE LF)

# Tell cmake that we will need mediapipe.
include(FetchContent)
FetchContent_Populate(mediapipe
    URL             https://fossies.org/linux/misc/mediapipe-${Mediapipe_VERSION}.tar.gz
                    https://github.com/google-ai-edge/mediapipe/archive/refs/tags/v${Mediapipe_VERSION}.tar.gz
    URL_HASH        SHA256=${MEDIAPIPE_URL_HASH_SHA256_${MEDIAPIPE_DLLVERSION}}
    PATCH_COMMAND   "${PATCH_EXECUTABLE}" -p1 -d "<SOURCE_DIR>" -i "${CMAKE_CURRENT_SOURCE_DIR}/patches/001-mediapipe-src.patch"
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
set(OpenCV_COM_URL_HASH_4140 fa3c8514262546ffd7085ea61d7fc8ea5645da64a6f0d8bd66e5afaf75b8ed20)
set(OpenCV_COM_VERSION_RELEASE_4140 1)
set(OpenCV_COM_URL_HASH_500  6dd5b7b5058e2aac18f1a6b81c48725604b292480ee12a0a42f8a1281b50bff8)
set(OpenCV_COM_VERSION_RELEASE_500 1)
set(OpenCV_COM_VERSION ${OpenCV_VERSION}-${OpenCV_COM_VERSION_RELEASE_${OpenCV_DLLVERSION}})
set(OpenCV_COM_ARCHIVE "autoit-opencv-com-${OpenCV_COM_VERSION}.7z")
cmake_path(SET OpenCV_COM_SOURCE_DIR NORMALIZE "${CMAKE_CURRENT_SOURCE_DIR}/../../node-autoit-opencv-com")
if (EXISTS "${OpenCV_COM_SOURCE_DIR}/${OpenCV_COM_ARCHIVE}")
    set(OpenCV_COM_URL "${OpenCV_COM_SOURCE_DIR}/${OpenCV_COM_ARCHIVE}")
else()
    set(OpenCV_COM_URL "https://github.com/smbape/node-autoit-opencv-com/releases/download/v${OpenCV_COM_VERSION}/${OpenCV_COM_ARCHIVE}")
endif()
include(FetchContent)
FetchContent_Populate(autoit_opencv_com
    URL               "${OpenCV_COM_URL}"
    URL_HASH          SHA256=${OpenCV_COM_URL_HASH_${OpenCV_DLLVERSION}}
    DOWNLOAD_DIR      "${CMAKE_CURRENT_SOURCE_DIR}/.."
    SOURCE_DIR        "${CMAKE_CURRENT_SOURCE_DIR}/../autoit-opencv-com"
)

# update version in files
vcpkg_regex_replace_string("${CMAKE_CURRENT_SOURCE_DIR}/BUILD" "OPENCV_VERSION = \"[0-9]+\"  # [0-9]+\\.[0-9]+\\.[0-9]+" "OPENCV_VERSION = \"${OpenCV_DLLVERSION}\"  # ${OpenCV_VERSION}")
vcpkg_regex_replace_string("${CMAKE_CURRENT_SOURCE_DIR}/BUILD" "MEDIAPIPE_VERSION = \"[0-9]+(\\.[0-9]+)+\"" "MEDIAPIPE_VERSION = \"${Mediapipe_VERSION}\"")
vcpkg_regex_replace_string("${CMAKE_CURRENT_SOURCE_DIR}/src/autoit_def.h" "#define AUTOIT_LIB_VERSION [0-9]+(\\.[0-9]+)+" "#define AUTOIT_LIB_VERSION ${Mediapipe_VERSION}")
vcpkg_regex_replace_string("${CMAKE_CURRENT_SOURCE_DIR}/../src/gen.js" "Mediapipe_VERSION = \"[0-9]+(\\.[0-9]+)+\"" "Mediapipe_VERSION = \"${Mediapipe_VERSION}\"")
vcpkg_regex_replace_string("${CMAKE_CURRENT_SOURCE_DIR}/../src/gen.js" "OpenCV_COM_VERSION = \"[0-9]+\\.[0-9]+\\.[0-9]+\"" "OpenCV_COM_VERSION = \"${OpenCV_COM_VERSION}\"")
vcpkg_regex_replace_string("${CMAKE_CURRENT_SOURCE_DIR}/../README.md" "(autoit-opencv-com/releases/download/|autoit-opencv-[0-9]+\\.[0-9]+\\.[0-9]+-com-)v[0-9]+\\.[0-9]+\\.[0-9]+" "\\1v${OpenCV_COM_VERSION}")

vcpkg_regex_replace_string("${CMAKE_CURRENT_SOURCE_DIR}/udf/mediapiped.sxs.manifest"
    "name=\"autoit_opencv_com[0-9]+d.sxs\" version=\"[^\"\\s*]+\""
    "name=\"autoit_opencv_com${OpenCV_DLLVERSION}d.sxs\" version=\"${OpenCV_VERSION}.${OpenCV_COM_VERSION_RELEASE_${OpenCV_DLLVERSION}}\""
)

vcpkg_regex_replace_string("${CMAKE_CURRENT_SOURCE_DIR}/udf/mediapipe.sxs.manifest"
    "name=\"autoit_opencv_com[0-9]+.sxs\" version=\"[^\"\\s*]+\""
    "name=\"autoit_opencv_com${OpenCV_DLLVERSION}.sxs\" version=\"${OpenCV_VERSION}.${OpenCV_COM_VERSION_RELEASE_${OpenCV_DLLVERSION}}\""
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
    ../scripts/update-readme.js
    ../src/gen.js
    ../README.md

    ../test/*.au3
    ../examples/*.au3
    ../examples/*.cs
    ../examples/*.ps1
    ../examples/*.psm1
)
foreach(item ${files_to_change})
    vcpkg_regex_replace_string("${item}" "autoit_mediapipe_com-[0-9]+(\\.[0-9]+)+-[0-9]+" "autoit_mediapipe_com-${Mediapipe_VERSION}-${OpenCV_DLLVERSION}")
    vcpkg_regex_replace_string("${item}" "mediapipe-[0-9]+(\\.[0-9]+)+" "mediapipe-${Mediapipe_VERSION}")
    vcpkg_regex_replace_string("${item}" "/v[0-9]+(\\.[0-9]+)+/mediapipe/" "/v${Mediapipe_VERSION}/mediapipe/")
    vcpkg_regex_replace_string("${item}" "(/google-ai-edge/mediapipe/archive/refs/tags/v)[0-9]+(\\.[0-9]+)+" "\\1${Mediapipe_VERSION}")

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
    set(COMPILATION_MODE dbg)
else()
    set(COMPILATION_MODE opt)
endif()

set(mediapipe_BINARY_DIR "${mediapipe_SOURCE_DIR}/bazel-out/x64_windows-${COMPILATION_MODE}/bin")

include(cmake/UsePython3Venv.cmake)

# Needed python packages
math(EXPR Mediapipe_NEXT_VERSION_MAJOR "${Mediapipe_VERSION_MAJOR} + 1")
pip_install(absl-py "mediapipe>=${Mediapipe_VERSION},<${Mediapipe_NEXT_VERSION_MAJOR}.0.0" numpy opencv-python)

if (WIN32)
    # Avoid long paths on windows
    # https://bazel.build/remote/output-directories#layout
    set(OUTPUT_USER_ROOT "C:/_bazel_" CACHE PATH "Bazel output user root")
endif()

find_program(BAZEL_EXECUTABLE
    NAMES bazelisk bazel
    DOC "Bazel executable"
    REQUIRED
)

option(MEDIAPIPE_DISABLE_GPU "Disable GPU support" ON)

if (WIN32 AND NOT MEDIAPIPE_DISABLE_GPU)
    message(FATAL_ERROR "GPU Delegate is not yet supported for Windows")
endif()

set(BAZEL_GPU_OPTIONS)

if (MEDIAPIPE_DISABLE_GPU)
    list(APPEND BAZEL_GPU_OPTIONS --define MEDIAPIPE_DISABLE_GPU=1)
else()
    list(APPEND BAZEL_GPU_OPTIONS
        --copt=-DTFLITE_GPU_EXTRA_GLES_DEPS
        --copt=-DMEDIAPIPE_OMIT_EGL_WINDOW_BIT
        --copt=-DMESA_EGL_NO_X11_HEADERS
        --copt=-DEGL_NO_X11
    )

    if (CMAKE_SYSTEM_NAME STREQUAL "Darwin")
        list(APPEND BAZEL_GPU_OPTIONS --copt=-DMEDIAPIPE_GPU_BUFFER_USE_CV_PIXEL_BUFFER)
    endif()
endif()

set(BAZEL_BUILD
    "${BAZEL_EXECUTABLE}"
)

if (DEFINED OUTPUT_USER_ROOT)
    list(APPEND BAZEL_BUILD "--output_user_root=${OUTPUT_USER_ROOT}")
endif()

if (DEFINED OUTPUT_BASE)
    list(APPEND BAZEL_BUILD "--output_base=${OUTPUT_BASE}")
endif()

string(REPLACE ";" "$<SEMICOLON>" ENV_PATH "$ENV{PATH}")

set(BAZEL_ENV
    "PATH=${ENV_PATH}"
    "CC=${CMAKE_C_COMPILER}"
    "CXX=${CMAKE_CXX_COMPILER}"
)

if (UNIX)
    # [Running bazel in a subshell causes subshell to hang](https://github.com/bazelbuild/bazel/issues/19309)
    execute_process(
        COMMAND           "${CMAKE_COMMAND}" -E env ${BAZEL_ENV} -- ${BAZEL_BUILD} info server_pid
        WORKING_DIRECTORY "${mediapipe_SOURCE_DIR}"
    )
endif()

list(APPEND BAZEL_BUILD
    build -c ${COMPILATION_MODE}
    --strip=never
    --verbose_failures

    # -s

    # #import "C:\Windows\System32\scrrun.dll" will cause a scrrun.tlh not found error
    # disable parse_showincludes to avoid that error
    --features=-parse_showincludes

    # --keep_going

    # https://github.com/bazelbuild/bazel/issues/8444#issuecomment-513204396
    # --spawn_strategy=local
)

set(BAZEL_BUILD_OPTIONS
    "--repo_env=HERMETIC_PYTHON_VERSION=${Python3_VERSION_MAJOR}.${Python3_VERSION_MINOR}"
    "--action_env=PYTHON_BIN_PATH=${Python3_EXECUTABLE}"
    "--python_path=${Python3_EXECUTABLE}"
)

if (WIN32 AND CMAKE_CXX_COMPILER_ID STREQUAL "Clang" AND NOT DEFINED ENV{BAZEL_LLVM})
    cmake_path(GET CMAKE_C_COMPILER PARENT_PATH BAZEL_LLVM)
    cmake_path(GET BAZEL_LLVM PARENT_PATH BAZEL_LLVM)
    list(APPEND BAZEL_ENV "BAZEL_LLVM=${BAZEL_LLVM}")
    list(APPEND BAZEL_BUILD_OPTIONS
        --extra_toolchains=@local_config_cc//:cc-toolchain-x64_windows-clang-cl
        --extra_execution_platforms=//:x64_windows-clang-cl
    )
endif()

if (MSVC)
    list(APPEND BAZEL_BUILD_OPTIONS --define=protobuf_allow_msvc=true)
endif()

if (CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
    # https://man.freebsd.org/cgi/man.cgi?query=gcc11&sektion=1&manpath=freebsd-release-ports
    if (CMAKE_CXX_COMPILER_VERSION VERSION_LESS "11")
        list(APPEND BAZEL_BUILD_OPTIONS --define xnn_enable_avxvnni=false)
    endif()

    enable_language(ASM-ATT)

    if ((CMAKE_CXX_COMPILER_VERSION VERSION_EQUAL "11" OR CMAKE_CXX_COMPILER_VERSION VERSION_GREATER "11") AND CMAKE_CXX_COMPILER_VERSION VERSION_LESS "12" AND CMAKE_ASM-ATT_COMPILER_ID STREQUAL "GNU")
        # binutils gained VNNI support in 2.36
        # https://github.com/google/XNNPACK/issues/6389#issuecomment-2356299909

        execute_process(
            COMMAND sh -c "${CMAKE_ASM-ATT_COMPILER} --version | sed -rn 's/GNU[[:space:]][Aa]ssembler[[:space:]].*[[:space:]]([0-9])/\\1/p'"
            OUTPUT_VARIABLE CMAKE_ASM-ATT_COMPILER_VERSION
        )

        if (NOT CMAKE_ASM-ATT_COMPILER_VERSION VERSION_GREATER_EQUAL "2.36")
            list(APPEND BAZEL_BUILD_OPTIONS --define xnn_enable_avxvnni=false)
        endif()
    endif()

    # https://man.freebsd.org/cgi/man.cgi?query=gcc12&sektion=1&manpath=freebsd-release-ports
    if (CMAKE_CXX_COMPILER_VERSION VERSION_LESS "12")
        list(APPEND BAZEL_BUILD_OPTIONS --define xnn_enable_avx512fp16=false)
    endif()

    # https://man.freebsd.org/cgi/man.cgi?query=gcc13&sektion=1&manpath=freebsd-release-ports
    if (CMAKE_CXX_COMPILER_VERSION VERSION_LESS "13")
        list(APPEND BAZEL_BUILD_OPTIONS --define xnn_enable_avxvnniint8=false)
    endif()
endif()

set(BAZEL_BUILD_EXTRA_OPTIONS "" CACHE INTERNAL "Bazel build options")
if (BAZEL_BUILD_EXTRA_OPTIONS)
    list(APPEND BAZEL_BUILD_OPTIONS ${BAZEL_BUILD_EXTRA_OPTIONS})
endif()

list(APPEND BAZEL_BUILD ${BAZEL_GPU_OPTIONS} ${BAZEL_BUILD_OPTIONS})

# Make sure bazel-out is a symbolic link
# add_custom_command will create the directory needed to store OUTPUT.
# However, bazel creates bazel-out as a symbolic link in the output_user_root directory.
# If bazel-out already exists, bazel won't touch it, and generated files will be inacessible.
# The choosen work around is to delete bazel-out if it is not a symbolic link.
# Therefore, allowing bazel to create the symbolic link
set(invalid_SYMLINKS)
foreach(directory IN ITEMS bazel-bin bazel-out bazel-mediapipe-src)
    if (NOT IS_SYMLINK "${mediapipe_SOURCE_DIR}/${directory}")
        list(APPEND invalid_SYMLINKS "${mediapipe_SOURCE_DIR}/${directory}")
    endif()
endforeach()
set(ensure_SYMBOLIC_BAZEL_SYMLINKS "${CMAKE_COMMAND}" -E)
if (invalid_SYMLINKS)
    list(APPEND ensure_SYMBOLIC_BAZEL_SYMLINKS rm -rf ${invalid_SYMLINKS})
else()
    list(APPEND ensure_SYMBOLIC_BAZEL_SYMLINKS echo "Checked symlinks")
endif()

set(mediapipe_source_OUTPUT "${mediapipe_BINARY_DIR}/mediapipe/tasks/c/${CMAKE_SHARED_LIBRARY_PREFIX}mediapipe_source${CMAKE_SHARED_LIBRARY_SUFFIX}")

add_custom_command(OUTPUT "${mediapipe_source_OUTPUT}"
    COMMAND           ${ensure_SYMBOLIC_BAZEL_SYMLINKS}
    COMMAND           "${CMAKE_COMMAND}" -E echo ${BAZEL_BUILD} //mediapipe/tasks/c:mediapipe_source
    COMMAND           "${CMAKE_COMMAND}" -E env ${BAZEL_ENV} -- ${BAZEL_BUILD} //mediapipe/tasks/c:mediapipe_source
    COMMAND           "${CMAKE_COMMAND}" -E touch_nocreate "${mediapipe_source_OUTPUT}"
    WORKING_DIRECTORY "${mediapipe_SOURCE_DIR}"
    VERBATIM
    USES_TERMINAL
)
add_custom_target(${target_name}_mediapipe_source DEPENDS "${mediapipe_source_OUTPUT}")

set(src_gen_cmd "${NODE_EXECUTABLE}" --unhandled-rejections=strict --trace-uncaught --trace-warnings src/gen.js)

file(GLOB_RECURSE project_source_headers
    "src/*.h"
    "src/*.hh"
    "src/*.hpp"
    "src/*.hxx"
)

file(GLOB_RECURSE generator_files
    "../src/*.js"
)

set(generated_OUTPUT "${CMAKE_CURRENT_SOURCE_DIR}/generated/autoit_bridge_generated.cpp")
add_custom_command(OUTPUT "${generated_OUTPUT}"
    COMMAND           "${CMAKE_COMMAND}" -E echo ${src_gen_cmd}
    COMMAND           "${CMAKE_COMMAND}" -E env "PATH=${ENV_PATH}" "CMAKE_BINARY_DIR=${CMAKE_BINARY_DIR}" "Python3_EXECUTABLE=${Python3_EXECUTABLE}" -- ${src_gen_cmd}
    COMMAND           "${CMAKE_COMMAND}" -E touch_nocreate "${generated_OUTPUT}"
    WORKING_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/.."
    DEPENDS           ${project_source_headers} ${target_name}_mediapipe_source ${generator_files}
    VERBATIM
    USES_TERMINAL
)
add_custom_target(${target_name}_generated DEPENDS "${generated_OUTPUT}")

add_definitions(-DMediapipe_VERSION=${Mediapipe_VERSION})
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
add_library(${target_name}_res OBJECT ${SRC_FILES})
target_include_directories(${target_name}_res PUBLIC "src")
target_include_directories(${target_name}_res PUBLIC "generated")

file(GLOB_RECURSE project_rules_files
    "rules_impl/*"
    "scripts/configure_bazel.js"
)

file(GLOB_RECURSE project_source_headers
    "src/*.h"
    "src/*.hh"
    "src/*.hpp"
    "src/*.hxx"
)

file(GLOB_RECURSE project_source_files
    "src/*.c"
    "src/*.cc"
    "src/*.cpp"
    "src/*.cxx"
)

file(GLOB_RECURSE project_generated_headers
    "generated/*.h"
    "generated/*.hh"
    "generated/*.hpp"
    "generated/*.hxx"
)

file(GLOB_RECURSE project_generated_files
    "generated/*.c"
    "generated/*.cc"
    "generated/*.cpp"
    "generated/*.cxx"
)

set(project_depends_files
    ${project_source_headers}
    ${project_source_files}
    ${project_generated_headers}
    ${project_generated_files}
    ${project_rules_files}
)

# https://samthursfield.wordpress.com/2015/11/21/cmake-dependencies-between-targets-and-files-and-custom-commands/

set(BAZEL_OUTPUT_LIBNAME "autoit_mediapipe_com-${Mediapipe_VERSION}-${OpenCV_DLLVERSION}")
set(BAZEL_OUTPUT_NAME "${BAZEL_OUTPUT_LIBNAME}${OpenCV_BUILD_DEBUG_POSTFIX}")

set(resource_objects "$<TARGET_OBJECTS:${target_name}_res>")
set(resource_objects "$<LIST:TRANSFORM,${resource_objects},REPLACE,${CMAKE_CURRENT_SOURCE_DIR},${MEDIAPIPE_ADDON_PACKAGE}>")
set(resource_objects "$<LIST:TRANSFORM,${resource_objects},PREPEND,    \">")
set(resource_objects "$<LIST:TRANSFORM,${resource_objects},APPEND,\">")
set(resource_objects "$<JOIN:${resource_objects},\",\n    \">")
set(resource_objects "[\n${resource_objects}\n]")

file (GENERATE
    OUTPUT "${CMAKE_CURRENT_SOURCE_DIR}/rules_impl/resources_objects_$<CONFIG>.bzl" 
    CONTENT "TARGET_OBJECTS = ${resource_objects}"
)

set(BAZEL_OUTPUT_LIBRARY "${mediapipe_BINARY_DIR}/${MEDIAPIPE_ADDON_PACKAGE}/${BAZEL_OUTPUT_NAME}${CMAKE_SHARED_LIBRARY_SUFFIX}")
add_custom_command(OUTPUT "${BAZEL_OUTPUT_LIBRARY}"
    COMMAND           ${ensure_SYMBOLIC_BAZEL_SYMLINKS}
    COMMAND           "${CMAKE_COMMAND}" -E echo ${BAZEL_BUILD} ${MEDIAPIPE_ADDON_PACKAGE}:lib
    COMMAND           "${CMAKE_COMMAND}" -E env ${BAZEL_ENV} -- ${BAZEL_BUILD} ${MEDIAPIPE_ADDON_PACKAGE}:lib
    WORKING_DIRECTORY "${mediapipe_SOURCE_DIR}"
    DEPENDS           ${project_depends_files} ${target_name}_generated ${target_name}_res
    VERBATIM
    USES_TERMINAL
)
add_custom_target(${target_name}_lib DEPENDS "${BAZEL_OUTPUT_LIBRARY}" ${project_depends_files})

add_custom_target(${target_name} ALL DEPENDS ${target_name}_lib)

string(REPLACE ".dll" ".sxs.manifest" PROJECT_MANIFEST "${BAZEL_OUTPUT_LIBRARY}")
add_custom_command(TARGET ${target_name} POST_BUILD
    COMMAND mt.exe -manifest \"${PROJECT_MANIFEST}\" -validate_manifest
    COMMAND attrib -r \"${BAZEL_OUTPUT_LIBRARY}\"
    COMMAND mt.exe -manifest \"${PROJECT_MANIFEST}\" -outputresource:\"${BAZEL_OUTPUT_LIBRARY}\"\;\#2
    COMMAND attrib +r \"${BAZEL_OUTPUT_LIBRARY}\"

    COMMAND "${CMAKE_COMMAND}" -P "${CMAKE_CURRENT_SOURCE_DIR}/cmake/glob_copy.cmake" --
        "${mediapipe_BINARY_DIR}/${MEDIAPIPE_ADDON_PACKAGE}/${BAZEL_OUTPUT_NAME}*.dll"
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
        DEPENDS ${target_name}_lib
        VERBATIM
    )
    add_custom_target(${item_target} DEPENDS "${item_output}")

    add_dependencies(${target_name} ${item_target})

    unset(item_output)
    unset(item_target)
endforeach()

# ===============
# C# Interop target
# ===============
option(BUILD_mediapipe_csharp_bindings "Build the C# bindings" ON)
if (CMAKE_GENERATOR MATCHES "Visual Studio" AND BUILD_mediapipe_csharp_bindings)
include(CSharpUtilities)
enable_language(CSharp)

file(GLOB_RECURSE cs_files "dotnet/*.cs")
add_library(interop_mediapipe SHARED ${cs_files})

set_target_properties(interop_mediapipe PROPERTIES
    OUTPUT_NAME "interop.mediapipe-${Mediapipe_VERSION_MAJOR}"
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

file(GLOB dotnet_files  "dotnet/*.cs")
list(APPEND dotnet_files "${autoit_opencv_com_SOURCE_DIR}/dotnet/OpenCvComInterop.cs")

set(OpenCVCOM_ASSEMBLY_DLL "${autoit_opencv_com_SOURCE_DIR}/dotnet/OpenCV.InteropServices.dll")
file(TO_NATIVE_PATH "${OpenCVCOM_ASSEMBLY_DLL}" OpenCVCOM_ASSEMBLY_DLL)

file(GLOB test_files "test/*.cs")
add_executable(cs_test ${test_files} ${dotnet_files})
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


file(GLOB_RECURSE googlesamples
    "../examples/googlesamples/*.cs"
)
list(FILTER googlesamples EXCLUDE REGEX "^[.]")

foreach(cs_file IN LISTS googlesamples)
    cmake_path(GET cs_file STEM cs_target_name)
    set(cs_target_name "googlesamples_${cs_target_name}")
    string(REGEX REPLACE "[^_a-zA-Z0-9.+-]" "_" cs_target_name "${cs_target_name}")

    add_executable(${cs_target_name} ${cs_file} ${dotnet_files})
    set_target_properties(${cs_target_name} PROPERTIES
        RUNTIME_OUTPUT_DIRECTORY "${EXECUTABLE_OUTPUT_PATH}"
        DEBUG_POSTFIX "${OpenCV_DEBUG_POSTFIX}"
        VS_GLOBAL_EnableUnmanagedDebugging "true"
        VS_DEBUGGER_ENVIRONMENT "PATH=${OpenCV_BIN_NATIVE_PATH};%PATH%"
        VS_DOTNET_REFERENCES "Microsoft.CSharp;System;System.Core;System.Windows.Forms"
        VS_DOTNET_REFERENCE_OpenCVCOM "${OpenCVCOM_ASSEMBLY_DLL}"
        VS_DOTNET_REFERENCEPROP_OpenCVCOM_TAG_EmbedInteropTypes "True"
        VS_DOTNET_REFERENCE_Mediapipe "${ASSEMBLY_DLL}"
        VS_DOTNET_REFERENCEPROP_Mediapipe_TAG_EmbedInteropTypes "True"
    )
    add_dependencies(${cs_target_name} cs_assembly)

    # Always generate debug files
    if(MSVC AND NOT "${CMAKE_BUILD_TYPE}" STREQUAL "Debug")
        target_compile_options(${cs_target_name} PRIVATE "-debug:pdbonly")
    endif()
endforeach()

endif()
