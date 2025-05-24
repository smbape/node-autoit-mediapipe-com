licenses(["notice"])  # Apache 2.0

package(default_visibility = ["//visibility:public"])

load("@rules_cc//cc:defs.bzl", "cc_library")
load(":rules_impl/library.bzl", "add_library", "WINDOWS_DLL_LOCAL_DEFINES")
load(":rules_impl/resources_objects_Debug.bzl", resources_objects_Debug = "TARGET_OBJECTS")
load(":rules_impl/resources_objects_Release.bzl", resources_objects_Release = "TARGET_OBJECTS")

config_setting(
    name = "opt_build",
    values = {"compilation_mode": "opt"},
)

config_setting(
    name = "windows-opt-dbg",
    values = {
        "compilation_mode": "opt",
        "strip": "never",
    },
    constraint_values = [
        "@platforms//os:windows",
    ],
)

config_setting(
    name = "dbg_build",
    values = {"compilation_mode": "dbg"},
)

config_setting(
    name = "enable_odml_converter",
    define_values = {"ENABLE_ODML_CONVERTER": "1"},
    visibility = ["//visibility:public"],
)


OPENCV_VERSION = "4110"  # 4.11.0
MEDIAPIPE_VERSION = "0.10.23"
OUTPUT_NAME = "autoit_mediapipe_com-%s-%s" % (MEDIAPIPE_VERSION, OPENCV_VERSION)


cc_library(
    name = OUTPUT_NAME + "_c",
    srcs = glob(["src/**/*.c", "generated/**/*_i.c"]),
    local_defines = select({
        "@bazel_tools//src/conditions:windows": WINDOWS_DLL_LOCAL_DEFINES,
        "//conditions:default": [],
    }),
    copts = select({
        ":windows-opt-dbg": ["/Z7"],
        "//conditions:default": [],
    }),
    linkopts = select({
        ":windows-opt-dbg": [
            "/DEBUG",
            # "/PDB:" + pdb
        ],
        "//conditions:default": [],
    }),
    linkstatic = True,
    alwayslink = True,
)

add_library(OUTPUT_NAME + "_lib",
    pchhdrs = ["generated/autoit_bridge_generated_pch.h"],
    includes = ["src/", "generated/"],
    local_defines = ["CVAPI_EXPORTS"],
    linkopts = select({
        ":opt_build": resources_objects_Release,
        ":dbg_build": resources_objects_Debug,
    }),
    deps = [":" + OUTPUT_NAME + "_c" ],
)

alias(
    name = "lib_pch",
    actual = "_pch_" + OUTPUT_NAME + "_lib",
)


win_def_file = "src/dllmain.def"

cc_binary(
    name = OUTPUT_NAME,
    deps = [ ":" + OUTPUT_NAME + "_lib" ],
    win_def_file = win_def_file,
    linkshared = True,
    target_compatible_with = select({
        ":opt_build": [],
        "//conditions:default": ["@platforms//:incompatible"],
    }),
)

cc_binary(
    name = OUTPUT_NAME + "d",
    deps = [ ":" + OUTPUT_NAME + "_lib" ],
    win_def_file = win_def_file,
    linkshared = True,
    target_compatible_with = select({
        ":dbg_build": [],
        "//conditions:default": ["@platforms//:incompatible"],
    }),
)

alias(
    name = "lib",
    actual = select({
        ":opt_build": OUTPUT_NAME,
        ":dbg_build": OUTPUT_NAME + "d",
    }),
)
