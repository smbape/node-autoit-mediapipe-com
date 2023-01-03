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

cc_library(
    name = "builtin_calculators",
    deps = [
        "//mediapipe/calculators/core:gate_calculator",
        "//mediapipe/calculators/core:pass_through_calculator",
        "//mediapipe/calculators/core:side_packet_to_stream_calculator",
        "//mediapipe/calculators/core:split_proto_list_calculator",
        "//mediapipe/calculators/core:string_to_int_calculator",
        "//mediapipe/calculators/image:image_transformation_calculator",
        "//mediapipe/calculators/util:detection_unique_id_calculator",
        "//mediapipe/modules/face_detection:face_detection_full_range_cpu",
        "//mediapipe/modules/face_detection:face_detection_short_range_cpu",
        "//mediapipe/modules/face_landmark:face_landmark_front_cpu",
        "//mediapipe/modules/hand_landmark:hand_landmark_tracking_cpu",
        "//mediapipe/modules/holistic_landmark:holistic_landmark_cpu",
        "//mediapipe/modules/objectron:objectron_cpu",
        "//mediapipe/modules/palm_detection:palm_detection_cpu",
        "//mediapipe/modules/pose_detection:pose_detection_cpu",
        "//mediapipe/modules/pose_landmark:pose_landmark_by_roi_cpu",
        "//mediapipe/modules/pose_landmark:pose_landmark_cpu",
        "//mediapipe/modules/selfie_segmentation:selfie_segmentation_cpu",
    ],
)

cc_library(
    name = "builtin_task_graphs",
    deps = [
        "//mediapipe/tasks/cc/vision/object_detector:object_detector_graph",
    ],
)

OPENCV_VERSION = "470"  # 4.7.0
MEDIAPIPE_VERSION = "0.8.11"
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
