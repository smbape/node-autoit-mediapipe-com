/* eslint-disable no-magic-numbers */

const fs = require("node:fs");
const fsPromises = require("node:fs/promises");
const sysPath = require("node:path");
const {spawn} = require("node:child_process");

const {mkdirp} = require("mkdirp");
const waterfall = require("async/waterfall");
const {explore} = require("fs-explorer");
const Parser = require("./protobuf/Parser");
const vector_conversion = require("./vector_conversion");

const OpenCV_VERSION = "opencv-4.11.0";
const OpenCV_DLLVERSION = OpenCV_VERSION.slice("opencv-".length).replaceAll(".", "");
const MEDIAPIPE_VERSION = "0.10.24";

const progids = new Map([
    ["google.protobuf.TextFormat", "google.protobuf.text_format"],
]);

/** Function that count occurrences of a substring in a string;
 * @param {String} str               The string
 * @param {String} substr            The sub string to search for
 * @param {Boolean} [allowOverlapping]  Optional. (Default:false)
 *
 * @author Vitim.us https://gist.github.com/victornpb/7736865
 * @see Unit Test https://jsfiddle.net/Victornpb/5axuh96u/
 * @see https://stackoverflow.com/a/7924240/938822
 */
const occurrences = (str, substr, allowOverlapping = false) => {
    if (substr.length === 0) {
        return str.length + 1;
    }

    let n = 0;
    let pos = 0;
    const step = allowOverlapping ? 1 : substr.length;

    while ((pos = str.indexOf(substr, pos)) !== -1) {
        n++;
        pos += step;
    }

    return n;
};

const getOptions = PROJECT_DIR => {
    const language = "autoit";

    const options = {
        APP_NAME: "Mediapipe",
        language,
        cname: "create",
        LIB_UID: "29090432-104c-c6cd-cd2b-9f2a43abd5b6",
        LIBRARY: "mediapipeCOM",
        OUTPUT_NAME: `autoit_mediapipe_com-${ MEDIAPIPE_VERSION }-${ OpenCV_DLLVERSION }`,
        OUTPUT_DIRECTORY_DEBUG: `${ PROJECT_DIR }/build_x64/mediapipe-src/bazel-out/x64_windows-dbg/bin/mediapipe/autoit`,
        OUTPUT_DIRECTORY_RELEASE: `${ PROJECT_DIR }/build_x64/mediapipe-src/bazel-out/x64_windows-opt/bin/mediapipe/autoit`,
        namespace: "mediapipe",
        shared_ptr: "std::shared_ptr",
        make_shared: "std::make_shared",
        assert: "AUTOIT_ASSERT",
        Any: "VARIANT*",
        AnyObject: "_variant_t",
        maxFilenameLength: 120,
        meta_methods: new Map([
            ["__str__", "::autoit::__str__"],
            ["__eq__", "::autoit::__eq__"],
            ["__type__", null /* use default __type__ method */],
        ]),

        self: "*__self->get()",
        self_get: (name = null) => {
            return name ? `__self->get()->${ name }` : "__self->get()";
        },

        progid: progid => {
            if (progids.has(progid)) {
                return progids.get(progid);
            }

            return progid;
        },
        namespaces: new Set([]),
        other_namespaces: new Set([]),
        remove_namespaces: new Set([
            "cv",
            "google::protobuf",
            "mediapipe",
            `mediapipe::${ language }`,
            `mediapipe::${ language }::solution_base`,
            `mediapipe::${ language }::solutions`,
            "std",
        ]),
        build: new Set(),
        notest: new Set(),
        skip: new Set(),
        includes: [sysPath.join(PROJECT_DIR, "src")],
        output: sysPath.join(PROJECT_DIR, "generated"),
        toc: true,
        globals: [
            // cv::AccessFlag
            "$CV_ACCESS_READ",
            "$CV_ACCESS_WRITE",
            "$CV_ACCESS_RW",
            "$CV_ACCESS_MASK",
            "$CV_ACCESS_FAST",
            "$CV_USAGE_DEFAULT",
            "$CV_USAGE_ALLOCATE_HOST_MEMORY",
            "$CV_USAGE_ALLOCATE_DEVICE_MEMORY",
            "$CV_USAGE_ALLOCATE_SHARED_MEMORY",
            "$CV___UMAT_USAGE_FLAGS_32BIT",

            // cv::Formatter::FormatType
            "$CV_FORMATTER_FMT_DEFAULT",
            "$CV_FORMATTER_FMT_MATLAB",
            "$CV_FORMATTER_FMT_CSV",
            "$CV_FORMATTER_FMT_PYTHON",
            "$CV_FORMATTER_FMT_NUMPY",
            "$CV_FORMATTER_FMT_C",
        ],
        constReplacer: new Map([
            ["std::numeric_limits<int32_t>::min()", "-0x80000000"],
            ["std::numeric_limits<int32_t>::max()", "0x7FFFFFFF"],
        ]),
        onCoClass: (processor, coclass, opts) => {
            const {fqn} = coclass;

            if (fqn.endsWith("MapContainer")) {
                // make MapContainer to be recognized as a collection
                processor.as_stl_enum(coclass, "std::pair<_variant_t, _variant_t>", opts);
            } else if (fqn.endsWith("RepeatedContainer")) {
                // make RepeatedContainer to be recognized as a collection
                processor.as_stl_enum(coclass, "_variant_t", opts);
                coclass.addProperty(["size_t", "Count", "", ["/R", "=size()"]]);
            } else if (fqn.startsWith("google::protobuf::Repeated_")) {
                // make RepeatedField to be recognized as a collection
                const vtype = fqn.slice("google::protobuf::Repeated_".length).replaceAll("_", "::");
                processor.as_stl_enum(coclass, vtype, opts);
                coclass.cpptype = vtype;
                coclass.idltype = processor.getIDLType(vtype, coclass, opts);
            } else if (fqn === `mediapipe::${ language }::solutions::objectron::ObjectronOutputs`) {
                processor.add_vector(`std::vector<${ fqn }>`, coclass, opts);
            }

            // from mediapipe.python import *
            if (fqn.startsWith(`mediapipe::${ language }::`) || fqn.startsWith(`mediapipe::tasks::${ language }::`) || fqn.startsWith("mediapipe::") && occurrences(fqn, "::") === 1) {
                const parts = fqn.split("::");

                for (let i = 1; i < parts.length; i++) {
                    processor.add_func([`${ parts.slice(0, i).join(".") }.`, "", ["/Properties"], [
                        [parts.slice(0, i + 1).join("::"), parts[i], "", ["/R", "=this", "/S"]],
                    ], "", ""]);
                }
            }

            // import mediapipe.python.solutions as solutions
            if (fqn.startsWith(`mediapipe::${ language }::`)) {
                const parts = fqn.split("::");

                for (let i = 2; i < parts.length; i++) {
                    processor.add_func([`${ [parts[0]].concat(parts.slice(2, i)).join(".") }.`, "", ["/Properties"], [
                        [parts.slice(0, i + 1).join("::"), parts[i], "", ["/R", "=this", "/S"]],
                    ], "", ""]);
                }
            }
        },
        convert: (processor, coclass, header, impl, opts) => {
            const {fqn} = coclass;

            if (fqn === "google::protobuf::Message") {
                const {children} = coclass;

                let i = impl.length - 1;

                for (; i >= 0; i--) {
                    if (impl[i].includes("const HRESULT autoit_from(const std::shared_ptr<google::protobuf::Message>& in_val, VARIANT*& out_val) {")) {
                        break;
                    }
                }

                impl.splice(i, 0, `
                    auto init_type_indexes() {
                        std::unordered_map<std::type_index, int> type_indexes;
                        ${ [...children].map((child, index) => {
                            return `type_indexes[std::type_index(typeid(${ child.fqn }))] = ${ index + 1 };`;
                        }).join(`\n${ " ".repeat(24) }`) }
                        return type_indexes;
                    }

                    static auto type_indexes = init_type_indexes();
                `.replace(/^ {20}/mg, "").trim(), "");
            }

            if (fqn.startsWith("google::protobuf::Repeated_")) {
                vector_conversion.convert_sort(coclass, header, impl, opts);
            }
        },
        dynamicPointerCast: (processor, coclass, opts) => {
            const {fqn, children} = coclass;

            if (fqn !== "google::protobuf::Message") {
                return "";
            }

            return `switch(type_indexes[std::type_index(typeid(*in_val))]) {
                ${ [...children].map((child, index) => {
                    return `case ${ index + 1 }: {
                        auto derived = std::dynamic_pointer_cast<${ child.fqn }>(in_val);

                        if (!derived.get()) {
                            AUTOIT_ERROR("object cannot be cast to a ${ child.fqn }");
                            return E_FAIL;
                        }

                        return autoit_from(derived, out_val);
                    }`.replace(/^ {4}/mg, "");
                }).join(`\n${ " ".repeat(16) }`) }
            }`.replace(/^ {12}/mg, "");
        },

        getIDLType: (processor, type, coclass, opts) => {
            if (type === "absl::Status") {
                return "void";
            }

            if (type.startsWith("absl::StatusOr<")) {
                return processor.getIDLType(type.slice("absl::StatusOr<".length, -">".length), coclass, opts);
            }

            return null;
        },

        getReturnCppType: (processor, type, coclass, opts) => {
            if (type === "absl::Status") {
                return "void";
            }

            if (type.startsWith("absl::StatusOr<")) {
                return processor.getReturnCppType(type.slice("absl::StatusOr<".length, -">".length), coclass, opts);
            }

            return processor.getCppType(type, coclass, opts);
        },
    };

    const argv = process.argv.slice(2);
    const flags_true = ["iface", "hdr", "impl", "idl", "manifest", "rgs", "res", "save"];
    const flags_false = ["test"];

    for (const opt of flags_true) {
        options[opt] = !argv.includes(`--no-${ opt }`);
    }

    for (const opt of flags_false) {
        options[opt] = argv.includes(`--${ opt }`);
    }

    for (let i = 0; i < argv.length; i++) {
        const opt = argv[i];

        if (opt.startsWith("--no-") && flags_true.includes(opt.slice("--no-".length))) {
            continue;
        }

        if (opt.startsWith("--") && flags_false.includes(opt.slice("--".length))) {
            continue;
        }

        if (opt.startsWith("--no-test=")) {
            for (const fqn of opt.slice("--no-test=".length).split(/[ ,]/)) {
                options.notest.add(fqn);
            }
            continue;
        }

        if (opt.startsWith("--build=")) {
            for (const fqn of opt.slice("--build=".length).split(/[ ,]/)) {
                options.build.add(fqn);
            }
            continue;
        }

        if (opt.startsWith("--skip=")) {
            for (const fqn of opt.slice("--skip=".length).split(/[ ,]/)) {
                options.skip.add(fqn);
            }
            continue;
        }

        if (opt.startsWith("-D")) {
            const [key, value] = opt.slice("-D".length).split("=");
            options[key] = typeof value === "undefined" ? true : value;
            continue;
        }

        throw new Error(`Unknown option ${ opt }`);
    }

    return options;
};

const {
    CUSTOM_CLASSES,
} = require("./constants");

const {findFile} = require("./FileUtils");
const custom_declarations = require("./custom_declarations");
const DeclProcessor = require("./DeclProcessor");
const COMGenerator = require("./COMGenerator");

const PROJECT_DIR = sysPath.resolve(__dirname, "../autoit-mediapipe-com");
const SRC_DIR = sysPath.join(PROJECT_DIR, "src");
const opencv_SOURCE_DIR = findFile(`${ OpenCV_VERSION }-*/opencv/sources`, sysPath.resolve(__dirname, ".."));

const src2 = sysPath.resolve(opencv_SOURCE_DIR, "modules/python/src2");

const hdr_parser = fs.readFileSync(sysPath.join(src2, "hdr_parser.py")).toString();
const hdr_parser_start = hdr_parser.indexOf("class CppHeaderParser");
const hdr_parser_end = hdr_parser.indexOf("if __name__ == '__main__':");

const options = getOptions(PROJECT_DIR);
options.proto = COMGenerator.proto;

waterfall([
    next => {
        mkdirp(options.output).then(performed => {
            next();
        }, next);
    },

    next => {
        const srcfiles = [];
        const protofiles = new Set();
        const matcher = /#include "([^"]+)\.pb\.h"/g;

        explore(SRC_DIR, async (path, stats, next) => {
            const relpath = path.slice(SRC_DIR.length + 1);
            const parts = relpath.split(".");
            const extname = parts.length === 0 ? "" : `.${ parts[parts.length - 1] }`;
            const extnames = parts.length === 0 ? "" : `.${ parts.slice(-2).join(".") }`;
            const isheader = [".h", ".hpp", ".hxx"].includes(extname);

            const content = await fsPromises.readFile(path);

            let match;
            matcher.lastIndex = 0;
            while ((match = matcher.exec(content))) {
                protofiles.add(`${ match[1] }.proto`);
            }

            if (isheader && ![".impl.h", ".impl.hpp", ".impl.hxx"].includes(extnames) && (content.includes("CV_EXPORTS") || relpath.replace("\\", "/").startsWith("binding/"))) {
                srcfiles.push(path);
            }

            next();
        }, {followSymlink: true}, err => {
            const generated_include = srcfiles.map(path => `#include "${ path.slice(SRC_DIR.length + 1).replace("\\", "/") }"`);
            next(err, srcfiles, protofiles, generated_include);
        });
    },

    (srcfiles, protofiles, generated_include, next) => {
        const mediapipe_SOURCE_DIR = fs.realpathSync(`${ __dirname }/../autoit-mediapipe-com/build_x64/mediapipe-src`);
        const protobuf_SOURCE_DIR = fs.realpathSync(`${ mediapipe_SOURCE_DIR }/bazel-mediapipe-src/external/com_google_protobuf/src`);

        const outputs = Parser.createOutputs();
        const cache = new Map();
        const opts = {
            proto_path: [
                mediapipe_SOURCE_DIR,
                protobuf_SOURCE_DIR,
            ],
            language: options.language,
            self: options.self,
            self_get: options.self_get,
            Any: options.Any,
            AnyObject: options.AnyObject,
        };

        for (const filename of protofiles) {
            opts.filename = filename;
            const abspath = opts.proto_path
                .map(dirname => sysPath.join(dirname, filename))
                .filter(candidate => fs.existsSync(candidate))[0];
            const parser = new Parser();
            parser.parseFile(fs.realpathSync(abspath), opts, outputs, cache);
        }

        custom_declarations.push(...outputs.decls);
        generated_include.push(...outputs.generated_include);
        options.typedefs = outputs.typedefs;

        next(null, srcfiles, generated_include);
    },

    (srcfiles, generated_include, next) => {
        const buffers = [];
        let nlen = 0;
        const child = spawn("python", []);

        child.stderr.on("data", chunk => {
            process.stderr.write(chunk);
        });

        child.on("close", code => {
            if (code !== 0) {
                console.log(`python process exited with code ${ code }`);
                process.exit(code);
            }

            const buffer = Buffer.concat(buffers, nlen);

            const configuration = JSON.parse(buffer.toString());
            configuration.decls.push(...custom_declarations.load(options));
            configuration.generated_include = generated_include;

            for (const [name, modifiers] of CUSTOM_CLASSES) {
                configuration.decls.push([`class ${ name }`, "", modifiers, [], "", ""]);
            }

            configuration.namespaces.push(...options.namespaces);
            configuration.namespaces.push(...options.other_namespaces);

            // fs.writeFileSync(sysPath.join(__dirname, "../gen.json"), JSON.stringify(configuration, null, 4));

            const processor = new DeclProcessor(options);
            processor.process(configuration, options);

            next(null, processor, configuration);
        });

        child.stderr.on("data", chunk => {
            process.stderr.write(chunk);
        });

        child.stdout.on("data", chunk => {
            buffers.push(chunk);
            nlen += chunk.length;
        });

        const code = `
            import io, json, os, re, string, sys

            ${ hdr_parser
                .slice(hdr_parser_start, hdr_parser_end)
                .split("\n")
                .join(`\n${ " ".repeat(12) }`) }

            srcfiles = []

            ${ srcfiles.map(file => `srcfiles.append(${ JSON.stringify(file) })`).join(`\n${ " ".repeat(12) }`) }

            parser = CppHeaderParser(generate_umat_decls=True, generate_gpumat_decls=True)
            all_decls = []
            for hdr in srcfiles:
                decls = parser.parse(hdr)
                if len(decls) == 0 or hdr.find('/python/') != -1:
                    continue

                all_decls += decls

            # parser.print_decls(all_decls)
            print(json.dumps({"decls": all_decls, "namespaces": sorted(parser.namespaces)}, indent=4))
        `.trim().replace(/^ {12}/mg, "");

        // fs.writeFileSync(sysPath.join(__dirname, "../gen.py"), code);

        child.stdin.write(code);
        child.stdin.end();
    },

    (processor, configuration, next) => {
        const comGenerator = new COMGenerator();
        comGenerator.generate(processor, configuration, options, next);
    },
], err => {
    if (err) {
        throw err;
    }
    console.log(`Build files have been written to: ${ options.output }`);
});
