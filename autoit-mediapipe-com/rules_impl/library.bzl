load("@bazel_skylib//lib:paths.bzl", "paths")

COMPILE_ATTRS = {
    "srcs": attr.label_list(allow_files = True),
    "hdrs": attr.label_list(allow_files = True),
    "private_hdrs": attr.label_list(allow_files = True, allow_empty = True),
    "deps": attr.label_list(
        allow_empty = True,
        providers = [[CcInfo]],
    ),
    "copts": attr.string_list(),
    "linkopts": attr.string_list(),
    "includes": attr.string_list(),
    "defines": attr.string_list(),
    "local_defines": attr.string_list(),
    "additional_compiler_inputs": attr.label_list(allow_empty = True, allow_files = True),
    "additional_linker_inputs": attr.label_list(allow_empty = True, allow_files = True),
    "alwayslink": attr.bool(default = False),
    "include_prefix": attr.string(),
    "strip_include_prefix": attr.string(),
    "_cc_toolchain": attr.label(
        default = Label("@bazel_tools//tools/cpp:current_cc_toolchain"),
        providers = [cc_common.CcToolchainInfo],
    ),
    "data": attr.label_list(allow_empty = True),
    "win_def_file": attr.string(),
}

# https://groups.google.com/g/bazel-discuss/c/TYU5No_GWew
# https://github.com/bazelbuild/bazel/blob/master/src/main/starlark/builtins_bzl/common/cc/cc_library.bzl#L305-L310
def _cc_compile(srcs, copts, ctx):
    cc_toolchain = ctx.attr._cc_toolchain[cc_common.CcToolchainInfo]
    if type(cc_toolchain) != "CcToolchainInfo":
        fail("_compiler not of type CcToolchainInfo. Found: " + type(cc_toolchain))

    feature_configuration = cc_common.configure_features(
        ctx = ctx,
        cc_toolchain = cc_toolchain,
        requested_features = ctx.features,
        unsupported_features = ctx.disabled_features,
    )

    compilation_contexts = [dep[CcInfo].compilation_context for dep in ctx.attr.deps]

    # To mimic cc_library behavior we need to translate "includes" attribute to "system_includes".
    system_includes = []
    for include_folder in ctx.attr.includes:
        include_folder = paths.normalize(paths.join(ctx.label.workspace_root, ctx.label.package, include_folder))
        system_includes.append(include_folder)
        system_include_from_execroot = paths.join(ctx.bin_dir.path, include_folder)
        system_includes.append(system_include_from_execroot)
    # describe(system_includes, "system_includes for %s" % ctx.label)

    if cc_common.is_enabled(feature_configuration = feature_configuration, feature_name = 'pic'):
        disallow_pic_outputs = False
        disallow_nopic_outputs = True
    else:
        disallow_pic_outputs = True
        disallow_nopic_outputs = False

    # does it respect the toolchains built_in_include_directories?
    return cc_common.compile(
        name = ctx.label.name,
        actions = ctx.actions,
        feature_configuration = feature_configuration,
        cc_toolchain = cc_toolchain,
        srcs = srcs,
        public_hdrs = ctx.files.hdrs,
        private_hdrs = ctx.files.private_hdrs,
        includes = ctx.attr.includes,
        system_includes = system_includes,
        defines = ctx.attr.defines,
        local_defines = ctx.attr.local_defines,
        user_compile_flags = [ctx.expand_location(copt, ctx.attr.data) if "$(location" in copt else copt for copt in copts],
        include_prefix = ctx.attr.include_prefix,
        strip_include_prefix = ctx.attr.strip_include_prefix,
        compilation_contexts = compilation_contexts,
        disallow_pic_outputs = disallow_pic_outputs,
        disallow_nopic_outputs = disallow_nopic_outputs,
        additional_inputs = ctx.files.additional_compiler_inputs,
    )

def _cc_object_impl(ctx):
    (compilation_context, compilation_outputs) = _cc_compile(
        ctx = ctx,
        srcs = ctx.files.srcs,
        copts = ctx.attr.copts,
    )

    cc_info = CcInfo(
        compilation_context = compilation_context,
    )

    output_files = depset(
        compilation_outputs.pic_objects + compilation_outputs.objects,
        transitive = [dep[DefaultInfo].files for dep in ctx.attr.deps],
    )

    file_set_produced = DefaultInfo(files = output_files)
    return file_set_produced, cc_info

cc_object = rule(
    implementation = _cc_object_impl,
    attrs = COMPILE_ATTRS,
    # required to access certain cc_common methods
    fragments = ["cpp"],
    provides = [CcInfo],
)

def _pch_library_impl(ctx):
    name = ctx.label.name
    hdr_file = ctx.actions.declare_file(name + ".hxx")
    src_file = ctx.actions.declare_file(name + ".cxx")

    hdr_content = "/* generated by Bazel */\n\n#pragma system_header\n#ifdef __cplusplus"
    for hdr in ctx.files.hdrs:
        hdr_content = hdr_content + "\n#include \"" + hdr.path + "\""
    hdr_content = hdr_content + "\n#endif // __cplusplus\n"

    ctx.actions.write(
        output = hdr_file,
        content = hdr_content,
    )

    ctx.actions.write(
        output = src_file,
        content = "/* generated by Bazel */\n\n",
    )

    (compilation_context, compilation_outputs) = _cc_compile(
        ctx = ctx,
        srcs = [src_file],
        copts = [copt.replace("$(PCH_HEADER)", hdr_file.path) for copt in ctx.attr.copts],
    )

    return [
        DefaultInfo(
            files = depset(
                ctx.files.srcs + compilation_outputs.pic_objects + compilation_outputs.objects,
                transitive = [depset([hdr_file])] + [dep[DefaultInfo].files for dep in ctx.attr.deps],
            ),
        ),
        OutputGroupInfo(
            header_files = depset([hdr_file]),
            source_files = depset([src_file]),
        ),
        CcInfo(
            compilation_context = cc_common.create_compilation_context(
                includes = depset([hdr_file.dirname]),
                headers = depset([hdr_file]),
            ),
        ),
    ]

pch_library_rule = rule(
    implementation = _pch_library_impl,
    attrs = COMPILE_ATTRS,
    # required to access certain cc_common methods
    fragments = ["cpp"],
    output_to_genfiles = True,
    provides = [CcInfo],
)

def pch_library(name, **kwargs):
    kwargs["copts"] = kwargs.get("copts", []) + select({
        "@bazel_tools//src/conditions:windows": [
            "/FI$(PCH_HEADER)",
            "/Yc$(PCH_HEADER)",
            # "/Fp$(locations :_pch_" + name + "_pch)",
        ],
        "//conditions:default": [],
    })

    pch = "_pch_" + name
    pch_header = pch + "_header"

    pch_library_rule(
        name = pch,
        **kwargs
    )

    native.filegroup(
        name = pch_header,
        srcs = [ ":" + pch ],
        output_group = 'header_files'
    )

    return pch, pch_header

# https://stackoverflow.com/questions/65359354/separate-compile-and-linking-actions-with-bazel

# def _cc_compile_impl(ctx):
#     outs = []
#     for src in ctx.attr.srcs:
#         if hasattr(src, "actions"):
#             for action in src.actions:
#                 if action.mnemonic == "CppCompile":
#                     outs.append(action.outputs)
#     return DefaultInfo(files = depset(transitive = outs))

# cc_compile = rule(
#     _cc_compile_impl,
#     attrs = {
#         "srcs": attr.label_list(mandatory = True),
#     },
# )

def _add_com_library(name, intdir, compilation_mode, pchhdrs, **kwargs):
    native.filegroup(
        name = name + "_h",
        srcs = native.glob([
            "src/**/*.h*",
            "generated/**/*.h*",
        ])
    )

    native.filegroup(
        name = name + "_cc",
        srcs = native.glob([
            "src/**/*.h*",
            "generated/**/*.h*",
            "src/**/*.cc",
            "src/**/*.cpp",
            "src/**/*.cxx",
            "generated/**/*.cc",
            "generated/**/*.cpp",
            "generated/**/*.cxx",
        ])
    )

    # create precompiled header
    pch, pch_header = pch_library(
        name = name,
        hdrs = pchhdrs,
        additional_compiler_inputs = [":" + name + "_h"],
        **kwargs
    )

    # c files do not use precompiled headers
    cc_object(
        name = name + "_c",
        srcs = native.glob(["src/**/*.c", "generated/**/*_i.c"]),
        **kwargs
    )

    # use precompiled headers
    kwargs["data"] = kwargs.get("data", []) + [":" + pch_header]
    kwargs["copts"] = kwargs.get("copts", []) + select({
        "@bazel_tools//src/conditions:windows": [
            "/FI$(location :" + pch_header + ")",
            "/Yu$(location :" + pch_header + ")",
            # "/Fp$(locations :_pch_" + name + "_pch)",
        ],
        "//conditions:default": [],
    })
    kwargs["linkopts"] = kwargs.get("linkopts", []) + [
        "mediapipe/autoit/build_x64/autoit_mediapipe_com.dir/" + intdir + "/mediapipeCOM.res",
    ]

    native.cc_binary(
        name = name,
        srcs = [
            ":" + name + "_h",
            ":" + name + "_c",
            ":" + name + "_cc",
            ":" + pch,
        ],
        win_def_file = "src/dllmain.def",
        linkshared = True,
        **kwargs
    )

def add_com_library(name, intdir, compilation_mode):
    # pdb = "bazel-out/x64_windows-" + compilation_mode + "/bin/mediapipe/examples/desktop/autoit-mediapipe-com/" + name + ".pdb"

    _add_com_library(
        name = name,
        intdir = intdir,
        compilation_mode = compilation_mode,
        pchhdrs = ["src/autoit_bridge.h"],
        includes = ["src/", "generated/"],
        local_defines = select({
            "@bazel_tools//src/conditions:windows": [
                "WIN32",
                "_WINDOWS",
                "_MBCS",
                "_WINDLL",
                "CVAPI_EXPORTS",
            ],
            "//conditions:default": [],
        }),
        copts = ["/Zc:__cplusplus"] + select({
            ":windows-opt-dbg": [
                "/Z7",
                # "/Zi",
                # "/Fd" + pdb,
                # "/FS",
            ],
            "//conditions:default": [],
        }),
        linkopts = select({
            ":windows-opt-dbg": [
                "/DEBUG",
                # "/PDB:" + pdb
            ],
            "//conditions:default": [],
        }),
        deps = [
            "@windows_opencv//:opencv",

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
            ":builtin_calculators",
            ":builtin_task_graphs",

            # Type registration.
            "//mediapipe/framework:basic_types_registration",
            "//mediapipe/framework/formats:classification_registration",
            "//mediapipe/framework/formats:detection_registration",
            "//mediapipe/framework/formats:landmark_registration",
            "//mediapipe/framework/formats:rect_registration",
            "//mediapipe/modules/objectron/calculators:annotation_registration",

            # solution_base
            "//mediapipe/calculators/util:logic_calculator_cc_proto",
        ],
    )