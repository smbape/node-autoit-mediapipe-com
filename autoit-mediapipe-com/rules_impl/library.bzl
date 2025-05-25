load(":rules_impl/pch_library.bzl", "pch_library")

def _add_library(name, pchhdrs, **kwargs):
    srcs = kwargs.get("srcs", [])
    kwargs.pop("srcs", None)

    srcs += pchhdrs

    cc_hdrs = native.glob([
        "src/**/*.h",
        "src/**/*.hh",
        "src/**/*.hpp",
        "src/**/*.hxx",
        "generated/**/*.h",
        "generated/**/*.hh",
        "generated/**/*.hpp",
        "generated/**/*.hxx",
    ], exclude = pchhdrs)
    srcs += cc_hdrs

    cc_srcs = native.glob([
        "src/**/*.cc",
        "src/**/*.cpp",
        "src/**/*.cxx",
        "src/**/*.c++",
        "generated/**/*.cc",
        "generated/**/*.cpp",
        "generated/**/*.cxx",
        "generated/**/*.c++",
    ])
    srcs += cc_srcs

    # ========================
    # use a precompiled header
    # ========================
    pch_attrs = pch_library(
        name = name,
        hdrs = pchhdrs,
        additional_compiler_inputs = cc_hdrs,
        **kwargs
    )

    for (key, value) in pch_attrs.items():
        if key == "srcs":
            srcs += value
        else:
            kwargs[key] = kwargs.get(key, []) + value
    # ========================

    native.cc_library(
        name = name,
        srcs = srcs,
        linkstatic = True,
        alwayslink = True,
        **kwargs
    )

WINDOWS_DLL_LOCAL_DEFINES = [
    "WIN32",
    "_WINDOWS",
    "_MBCS",
    "_WINDLL",
    "ISOLATION_AWARE_ENABLED",
    "_WIN32_FUSION=0x010",
]

def add_library(name, **kwargs):
    kwargs["copts"] = kwargs.get("copts", []) + select({
        "@platforms//os:windows": ["/we4834", "/Zc:__cplusplus"],
        "//conditions:default": [],
    }) + select({
        ":windows-opt-dbg": ["/Z7"],
        "//conditions:default": [],
    }) + select({
        ":enable_odml_converter": ["-DENABLE_ODML_CONVERTER"],
        "//conditions:default": [],
    })

    kwargs["local_defines"] = kwargs.get("local_defines", []) + select({
        "@platforms//os:windows": WINDOWS_DLL_LOCAL_DEFINES,
        "//conditions:default": [],
    })

    kwargs["linkopts"] = kwargs.get("linkopts", []) + select({
        ":windows-opt-dbg": [
            "/DEBUG",
            # "/PDB:" + pdb
        ],
        "//conditions:default": [],
    }) + select({
        "@platforms//os:linux": ["-Wl,--no-undefined"],
        "@platforms//os:macos": ["-Wl,-undefined,error"],
        "@platforms//os:windows": [],
        "//conditions:default": [],
    })

    kwargs["deps"] = kwargs.get("deps", []) + [
        # opencv
        "//third_party:opencv",

        # util
        "//mediapipe/framework:calculator_cc_proto",
        "//mediapipe/framework:timestamp",
        "//mediapipe/framework/port:file_helpers",
        "//mediapipe/framework/port:status",

        # resource_util
        "//mediapipe/util:resource_util",
        "@com_google_absl//absl/flags:flag",
        "@com_google_absl//absl/strings",

        # timestamp
        # "//mediapipe/framework:timestamp",
        # "@com_google_absl//absl/strings",

        # image_frame_util
        "//mediapipe/framework/formats:image_format_cc_proto",
        "//mediapipe/framework/formats:image_frame_opencv",
        "//mediapipe/framework/formats:image_frame",
        "//mediapipe/framework/port:logging",
        "@com_google_absl//absl/memory",
        # "@com_google_absl//absl/strings",

        # image
        "//mediapipe/framework:type_map",
        "//mediapipe/framework/formats:image",
        "@stblib//:stb_image",

        # packet
        "//mediapipe/framework:packet",
        # "//mediapipe/framework:timestamp",

        # packet_creator
        # "//mediapipe/framework:packet",
        # "//mediapipe/framework:timestamp",
        # "//mediapipe/framework/formats:image",
        "//mediapipe/framework/formats:matrix",
        "//mediapipe/framework/port:integral_types",
        # "@com_google_absl//absl/memory",
        # "@com_google_absl//absl/strings",

        # packet_getter
        # "//mediapipe/framework:packet",
        # "//mediapipe/framework:timestamp",
        # "//mediapipe/framework/formats:image",
        # "//mediapipe/framework/formats:matrix",
        # "//mediapipe/framework/port:integral_types",
        "@com_google_absl//absl/status:statusor",

        # validated_graph_config"
        "//mediapipe/framework:validated_graph_config",
        "//mediapipe/framework/port:parse_text_proto",

        # calculator_graph"
        # "//mediapipe/framework:calculator_cc_proto",
        "//mediapipe/framework:calculator_graph",
        # "//mediapipe/framework:packet",
        "//mediapipe/framework/port:map_util",
        # "//mediapipe/framework/port:parse_text_proto",
        # "//mediapipe/framework/port:status",
        "//mediapipe/framework/tool:calculator_graph_template_cc_proto",
        # "@com_google_absl//absl/memory",
        # "@com_google_absl//absl/strings",

        # detection
        "//mediapipe/framework/formats:detection_cc_proto",

        # _framework_bindings
        "//mediapipe/python:builtin_calculators",
        "//mediapipe/python:builtin_task_graphs",

        # Type registration.
        "//mediapipe/framework:basic_types_registration",
        "//mediapipe/framework/formats:classification_registration",
        "//mediapipe/framework/formats:detection_registration",
        "//mediapipe/framework/formats:landmark_registration",
        "//mediapipe/framework/formats:rect_registration",
        "//mediapipe/modules/objectron/calculators:annotation_registration",

        # solution_base
        "//mediapipe/calculators/util:logic_calculator_cc_proto",

        # tasks/components/containers
        "//mediapipe/tasks/cc/components/containers/proto:landmarks_detection_result_cc_proto",

        # tasks/audio:audio_classifier
        "//mediapipe/tasks/cc/audio/audio_classifier:audio_classifier",

        # tasks/audio:audio_embedder
        "//mediapipe/tasks/cc/audio/audio_embedder:audio_embedder",

        # tasks/text
        "//mediapipe/tasks/cc/text/text_classifier:text_classifier",
        "//mediapipe/tasks/cc/text/text_embedder:text_embedder",

        # tasks/vision
        "//mediapipe/tasks/cc/vision/face_detector:face_detector_graph",
        "//mediapipe/tasks/cc/vision/gesture_recognizer:gesture_recognizer",
        "//mediapipe/tasks/cc/vision/hand_detector:hand_detector_graph",
        "//mediapipe/tasks/cc/vision/hand_landmarker:hand_landmarker",
        "//mediapipe/tasks/cc/vision/image_classifier:image_classifier",
        "//mediapipe/tasks/cc/vision/image_embedder:image_embedder",
        "//mediapipe/tasks/cc/vision/image_segmenter:image_segmenter",
        "//mediapipe/tasks/cc/vision/object_detector:object_detector",

        # tasks/vision:holistic_landmarker
        "//mediapipe/tasks/cc/vision/holistic_landmarker/proto:holistic_result_cc_proto",
    ] + select({
        # model_ckpt_util
        "//conditions:default": [],
        ":enable_odml_converter": [
            "//mediapipe/tasks/cc/text/utils:vocab_convert_utils",
            "@odml//odml/infra/genai/inference/ml_drift/llm/tensor_loaders:model_ckpt_util",
            "@odml//odml/infra/genai/inference/utils/xnn_utils:model_ckpt_util",
        ],
    })

    kwargs["data"] = kwargs.get("data", []) + [
        # audio
        "//mediapipe/tasks/testdata/audio:test_audio_clips",
        "//mediapipe/tasks/testdata/audio:test_models",

        # text
        "//mediapipe/tasks/testdata/text:bert_text_classifier_models",
        "//mediapipe/tasks/testdata/text:text_classifier_models",
        "//mediapipe/tasks/testdata/text:mobilebert_embedding_model",
        "//mediapipe/tasks/testdata/text:regex_embedding_with_metadata",
        "//mediapipe/tasks/testdata/text:universal_sentence_encoder_qa",

        # vision
        "//mediapipe/tasks/testdata/vision:test_images",
        "//mediapipe/tasks/testdata/vision:test_models",
        "//mediapipe/tasks/testdata/vision:test_protos",
    ]

    _add_library(
        name = name,
        **kwargs
    )
