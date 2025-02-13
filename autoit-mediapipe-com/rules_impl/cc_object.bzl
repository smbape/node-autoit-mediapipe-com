# https://stackoverflow.com/questions/65359354/separate-compile-and-linking-actions-with-bazel
# https://groups.google.com/g/bazel-discuss/c/TYU5No_GWew
# https://github.com/bazelbuild/bazel/blob/6.4.0/src/main/starlark/builtins_bzl/common/cc/cc_library.bzl

load("@bazel_skylib//lib:paths.bzl", "paths")
load("@bazel_skylib//rules:copy_file.bzl", "copy_file")
load("@bazel_skylib//rules:write_file.bzl", "write_file")

CC_SOURCE = [".cc", ".cpp", ".cxx", ".c++", ".C", ".cu", ".cl"]
C_SOURCE = [".c"]
OBJC_SOURCE = [".m"]
OBJCPP_SOURCE = [".mm"]
CLIF_INPUT_PROTO = [".ipb"]
CLIF_OUTPUT_PROTO = [".opb"]
CC_HEADER = [".h", ".hh", ".hpp", ".ipp", ".hxx", ".h++", ".inc", ".inl", ".tlh", ".tli", ".H", ".tcc"]
ASSESMBLER_WITH_C_PREPROCESSOR = [".S"]
ASSEMBLER = [".s", ".asm"]
ARCHIVE = [".a", ".lib"]
PIC_ARCHIVE = [".pic.a"]
ALWAYSLINK_LIBRARY = [".lo"]
ALWAYSLINK_PIC_LIBRARY = [".pic.lo"]
SHARED_LIBRARY = [".so", ".dylib", ".dll", ".wasm"]
INTERFACE_SHARED_LIBRARY = [".ifso", ".tbd", ".lib", ".dll.a"]
OBJECT_FILE = [".o", ".obj"]
PIC_OBJECT_FILE = [".pic.o"]

CC_AND_OBJC = []
CC_AND_OBJC.extend(CC_SOURCE)
CC_AND_OBJC.extend(C_SOURCE)
CC_AND_OBJC.extend(OBJC_SOURCE)
CC_AND_OBJC.extend(OBJCPP_SOURCE)
CC_AND_OBJC.extend(CC_HEADER)
CC_AND_OBJC.extend(ASSEMBLER)
CC_AND_OBJC.extend(ASSESMBLER_WITH_C_PREPROCESSOR)

DISALLOWED_HDRS_FILES = []
DISALLOWED_HDRS_FILES.extend(ARCHIVE)
DISALLOWED_HDRS_FILES.extend(PIC_ARCHIVE)
DISALLOWED_HDRS_FILES.extend(ALWAYSLINK_LIBRARY)
DISALLOWED_HDRS_FILES.extend(ALWAYSLINK_PIC_LIBRARY)
DISALLOWED_HDRS_FILES.extend(SHARED_LIBRARY)
DISALLOWED_HDRS_FILES.extend(INTERFACE_SHARED_LIBRARY)
DISALLOWED_HDRS_FILES.extend(OBJECT_FILE)
DISALLOWED_HDRS_FILES.extend(PIC_OBJECT_FILE)

def _matches_extension(extension, patterns):
    for pattern in patterns:
        if extension.endswith(pattern):
            return True
    return False

def _is_versioned_shared_library_extension_valid(shared_library_name):
    # validate agains the regex "^.+\\.((so)|(dylib))(\\.\\d\\w*)+$",
    # must match VERSIONED_SHARED_LIBRARY.
    for ext in (".so.", ".dylib."):
        name, _, version = shared_library_name.rpartition(ext)
        if name and version:
            version_parts = version.split(".")
            for part in version_parts:
                if not part[0].isdigit():
                    return False
                for c in part[1:].elems():
                    if not (c.isalnum() or c == "_"):
                        return False
            return True
    return False

def _check_src_extension(file, allowed_src_files, allow_versioned_shared_libraries = False):
    extension = "." + file.extension
    if _matches_extension(extension, allowed_src_files) or (allow_versioned_shared_libraries and _is_versioned_shared_library_extension_valid(file.path)):
        return True
    return False

# This should be enough to assume if two labels are equal.
def _are_labels_equal(a, b):
    return a.name == b.name and a.package == b.package

def _map_to_list(m):
    return list(m.keys())

# Returns a list of (Artifact, Label) tuples. Each tuple represents an input source
# file and the label of the rule that generates it (or the label of the source file itself if it
# is an input file).
def _get_srcs(ctx):
    if not hasattr(ctx.attr, "srcs"):
        return []

    # "srcs" attribute is a LABEL_LIST in cc_rules, which might also contain files.
    artifact_label_map = {}
    for src in ctx.attr.srcs:
        if DefaultInfo in src:
            for artifact in src[DefaultInfo].files.to_list():
                if "." + artifact.extension not in CC_HEADER:
                    old_label = artifact_label_map.get(artifact, None)
                    artifact_label_map[artifact] = src.label
                    if old_label != None and not _are_labels_equal(old_label, src.label) and "." + artifact.extension in CC_AND_OBJC:
                        fail(
                            "Artifact '{}' is duplicated (through '{}' and '{}')".format(artifact, old_label, src),
                            attr = "srcs",
                        )
    return _map_to_list(artifact_label_map)

# Returns a list of (Artifact, Label) tuples. Each tuple represents an input source
# file and the label of the rule that generates it (or the label of the source file itself if it
# is an input file).
def _get_private_hdrs(ctx):
    if not hasattr(ctx.attr, "srcs"):
        return []
    artifact_label_map = {}
    for src in ctx.attr.srcs:
        if DefaultInfo in src:
            for artifact in src[DefaultInfo].files.to_list():
                if "." + artifact.extension in CC_HEADER:
                    artifact_label_map[artifact] = src.label
    return _map_to_list(artifact_label_map)

# Returns the files from headers and does some checks.
def _get_public_hdrs(ctx):
    if not hasattr(ctx.attr, "hdrs"):
        return []
    artifact_label_map = {}
    for hdr in ctx.attr.hdrs:
        if DefaultInfo in hdr:
            for artifact in hdr[DefaultInfo].files.to_list():
                if _check_src_extension(artifact, DISALLOWED_HDRS_FILES, True):
                    continue
                artifact_label_map[artifact] = hdr.label
    return _map_to_list(artifact_label_map)

# Returns the files from headers and does some checks.
def _get_objects(ctx):
    if not hasattr(ctx.attr, "srcs"):
        return []
    object_artifact_label_map = {}
    pic_object_artifact_label_map = {}
    for src in ctx.attr.srcs:
        if DefaultInfo in src:
            for artifact in src[DefaultInfo].files.to_list():
                if _matches_extension(artifact.basename, PIC_OBJECT_FILE):
                    pic_object_artifact_label_map[artifact] = src.label
                elif _matches_extension(artifact.basename, OBJECT_FILE):
                    object_artifact_label_map[artifact] = src.label
    return _map_to_list(object_artifact_label_map), _map_to_list(pic_object_artifact_label_map)

def _is_compilation_outputs_empty(compilation_outputs):
    return (len(compilation_outputs.pic_objects) == 0 and
            len(compilation_outputs.objects) == 0)

# https://github.com/bazelbuild/bazel/blob/6.4.0/src/main/starlark/builtins_bzl/common/cc/cc_library.bzl#L24-L76
def _cc_compile(ctx):
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

    targets = []
    targets.extend(getattr(ctx.attr, "srcs", []))
    targets.extend(getattr(ctx.attr, "hdrs", []))
    targets.extend(getattr(ctx.attr, "data", []))
    targets.extend(getattr(ctx.attr, "additional_compiler_inputs", []))

    additional_inputs = ctx.files.additional_compiler_inputs

    # does it respect the toolchains built_in_include_directories?
    (compilation_context, compilation_outputs) = cc_common.compile(
        actions = ctx.actions,
        name = ctx.label.name,
        cc_toolchain = cc_toolchain,
        feature_configuration = feature_configuration,
        user_compile_flags = [ctx.expand_location(copt, targets = targets) if "$(location " in copt else copt for copt in ctx.attr.copts],
        defines = ctx.attr.defines,
        local_defines = [ctx.expand_make_variables(local_define, local_define, ctx.var) for local_define in ctx.attr.local_defines],
        system_includes = system_includes,
        srcs = _get_srcs(ctx),
        private_hdrs = _get_private_hdrs(ctx),
        public_hdrs = _get_public_hdrs(ctx),
        compilation_contexts = compilation_contexts,
        include_prefix = ctx.attr.include_prefix,
        strip_include_prefix = ctx.attr.strip_include_prefix,
        additional_inputs = additional_inputs,

        includes = ctx.attr.includes,
        disallow_pic_outputs = disallow_pic_outputs,
        disallow_nopic_outputs = disallow_nopic_outputs,
    )

    linking_context = None
    linking_outputs = None

    if ctx.attr.linkname:
        objects, pic_objects = _get_objects(ctx)
        compilation_outputs = cc_common.create_compilation_outputs(
            objects = depset(compilation_outputs.objects + objects),
            pic_objects = depset(compilation_outputs.pic_objects + pic_objects),
        )

    return (compilation_context, compilation_outputs)

def _cc_object_impl(ctx):
    (compilation_context, compilation_outputs) = _cc_compile(ctx)

    objects = compilation_outputs.pic_objects + compilation_outputs.objects

    files = depset(direct = objects)
    runfiles = ctx.runfiles(files = objects)

    return [
        DefaultInfo(files = files, data_runfiles = runfiles),
        CcInfo(compilation_context = compilation_context),
    ]

LINKER_SCRIPT = [".ld", ".lds", ".ldscript"]
PREPROCESSED_C = [".i"]
DEPS_ALLOWED_RULES = [
    "genrule",
    "cc_library",
    "cc_inc_library",
    "cc_embed_data",
    "go_library",
    "objc_library",
    "cc_import",
    "cc_proto_library",
    "gentpl",
    "gentplvars",
    "genantlr",
    "sh_library",
    "cc_binary",
    "cc_test",
]

COMPILE_ATTRS = {
    "srcs": attr.label_list(
        allow_files = True,
        flags = ["DIRECT_COMPILE_TIME_INPUT"],
    ),
    "alwayslink": attr.bool(default = False),
    "linkstatic": attr.bool(default = False),
    "hdrs": attr.label_list(
        allow_files = True,
        flags = ["ORDER_INDEPENDENT", "DIRECT_COMPILE_TIME_INPUT"],
    ),
    "strip_include_prefix": attr.string(),
    "include_prefix": attr.string(),
    "linkopts": attr.string_list(),
    "additional_linker_inputs": attr.label_list(
        allow_files = True,
        flags = ["ORDER_INDEPENDENT", "DIRECT_COMPILE_TIME_INPUT"],
    ),
    "includes": attr.string_list(),
    "defines": attr.string_list(),
    "copts": attr.string_list(),
    "local_defines": attr.string_list(),
    "deps": attr.label_list(
        providers = [CcInfo],
        flags = ["SKIP_ANALYSIS_TIME_FILETYPE_CHECK"],
        allow_files = LINKER_SCRIPT + PREPROCESSED_C,
        allow_rules = DEPS_ALLOWED_RULES,
    ),
    "data": attr.label_list(
        allow_files = True,
        flags = ["SKIP_CONSTRAINTS_OVERRIDE"],
    ),
    "win_def_file": attr.label(allow_single_file = [".def"]),
    "additional_compiler_inputs": attr.label_list(
        allow_files = True,
        flags = ["ORDER_INDEPENDENT", "DIRECT_COMPILE_TIME_INPUT"],
    ),
    "_cc_toolchain": attr.label(default = "@bazel_tools//tools/cpp:current_cc_toolchain"),
    "linkname": attr.string(),
}

cc_object_rule = rule(
    implementation = _cc_object_impl,
    attrs = COMPILE_ATTRS,
    # required to access certain cc_common methods
    fragments = ["cpp"],
    provides = [CcInfo],
)

def cc_object(**kwargs):
    cc_object_rule(**kwargs)

    linkname = kwargs.get("linkname", None)
    if linkname:
        native.cc_library(
            name = linkname,
            visibility = kwargs.get("visibility", None),
            hdrs = kwargs.get("hdrs", []),
            linkopts = kwargs.get("linkopts", []),
            additional_linker_inputs = kwargs.get("additional_linker_inputs", []),
            includes = kwargs.get("includes", []),
            defines = kwargs.get("defines", []) + kwargs.get("local_defines", []),
            deps = kwargs.get("deps", []),
            data = kwargs.get("data", []),
        )
