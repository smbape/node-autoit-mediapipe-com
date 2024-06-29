# https://stackoverflow.com/questions/60012975/bazel-c-precompiled-headers-implementation

load("@rules_cc//cc:defs.bzl", "cc_library")
load("//mediapipe/autoit/rules_impl:library.bzl", "add_com_library")

licenses(["notice"])  # Apache 2.0

package(default_visibility = ["//visibility:public"])

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

OPENCV_VERSION = "4100"  # 4.10.0
MEDIAPIPE_VERSION = "0.10.14"
OUTPUT_NAME = "autoit_mediapipe_com-%s-%s" % (MEDIAPIPE_VERSION, OPENCV_VERSION)

add_com_library(OUTPUT_NAME, "Release", "opt")
add_com_library(OUTPUT_NAME + "d", "Debug", "dbg")

alias(
    name = "lib_pch",
    actual = select({
        ":opt_build": "_pch_" + OUTPUT_NAME,
        ":dbg_build": "_pch_" + OUTPUT_NAME + "d",
    }),
)

alias(
    name = "lib",
    actual = select({
        ":opt_build": OUTPUT_NAME,
        ":dbg_build": OUTPUT_NAME + "d",
    }),
)
