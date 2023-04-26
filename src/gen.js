/* eslint-disable no-magic-numbers */

const fs = require("node:fs");
const fsPromises = require("node:fs/promises");
const sysPath = require("node:path");
const {spawn} = require("node:child_process");

const mkdirp = require("mkdirp");
const waterfall = require("async/waterfall");
const {explore} = require("fs-explorer");
const Parser = require("./protobuf/Parser");
const vector_conversion = require("./vector_conversion");

const OpenCV_VERSION = "opencv-4.7.0";
const OpenCV_DLLVERSION = OpenCV_VERSION.slice("opencv-".length).replaceAll(".", "");
const MEDIAPIPE_VERSION = "0.9.3.0";

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

const parseArguments = PROJECT_DIR => {
    const options = {
        APP_NAME: "Mediapipe",
        LIB_UID: "29090432-104c-c6cd-cd2b-9f2a43abd5b6",
        LIBRARY: "mediapipeCOM",
        OUTPUT_NAME: `autoit_mediapipe_com-${ MEDIAPIPE_VERSION }-${ OpenCV_DLLVERSION }`,
        OUTPUT_DIRECTORY_DEBUG: `${ PROJECT_DIR }/build_x64/_deps/mediapipe-src/bazel-out/x64_windows-dbg/bin/mediapipe/autoit`,
        OUTPUT_DIRECTORY_RELEASE: `${ PROJECT_DIR }/build_x64/_deps/mediapipe-src/bazel-out/x64_windows-opt/bin/mediapipe/autoit`,
        namespace: "mediapipe",
        shared_ptr: "std::shared_ptr",
        make_shared: "std::make_shared",
        assert: "AUTOIT_ASSERT",
        maxFilenameLength: 120,
        progid: progid => {
            if (progids.has(progid)) {
                return progids.get(progid);
            }

            return progid;
        },
        namespaces: new Set([
            "cv",
            "google::protobuf",
            "mediapipe",
            "mediapipe::autoit",
            "mediapipe::autoit::solution_base",
            "mediapipe::autoit::solutions",
            "std",
        ]),
        other_namespaces: new Set([]),
        remove_namespaces: new Set([
            "cv",
            "google::protobuf",
            "mediapipe",
            "mediapipe::autoit",
            "mediapipe::autoit::solution_base",
            "mediapipe::autoit::solutions",
            "std",
        ]),
        build: new Set(),
        notest: new Set(),
        skip: new Set(),
        includes: [sysPath.join(PROJECT_DIR, "src")],
        output: sysPath.join(PROJECT_DIR, "generated"),
        toc: true,
        globals: [
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
        ],
        constReplacer: new Map([
            ["std::numeric_limits<int32_t>::min()", "-0x80000000"],
            ["std::numeric_limits<int32_t>::max()", "0x7FFFFFFF"],
        ]),
        onCoClass: (generator, coclass, opts) => {
            const {fqn} = coclass;

            if (fqn.endsWith("MapContainer")) {
                // make MapContainer to be recognized as a collection
                generator.as_stl_enum(coclass, "std::pair<_variant_t, _variant_t>");
            } else if (fqn.endsWith("RepeatedContainer")) {
                // make RepeatedContainer to be recognized as a collection
                generator.as_stl_enum(coclass, "_variant_t");
                coclass.addProperty(["size_t", "Count", "", ["/R", "=size()"]]);
            } else if (fqn.startsWith("google::protobuf::Repeated_")) {
                // make RepeatedField to be recognized as a collection
                const vtype = fqn.slice("google::protobuf::Repeated_".length).replaceAll("_", "::");
                generator.as_stl_enum(coclass, vtype);
                coclass.cpptype = vtype;
                coclass.idltype = generator.getIDLType(vtype, coclass, opts);
            } else if (fqn === "mediapipe::autoit::solutions::objectron::ObjectronOutputs") {
                generator.add_vector(`vector<${ fqn }>`, coclass, opts);
            }

            // from mediapipe.python import *
            if (fqn.startsWith("mediapipe::autoit::") || fqn.startsWith("mediapipe::tasks::autoit::") || fqn.startsWith("mediapipe::") && occurrences(fqn, "::") === 1) {
                const parts = fqn.split("::");

                for (let i = 1; i < parts.length; i++) {
                    generator.add_func([`${ parts.slice(0, i).join(".") }.`, "", ["/Properties"], [
                        [parts.slice(0, i + 1).join("::"), parts[i], "", ["/R", "=this", "/S"]],
                    ], "", ""]);
                }
            }

            // import mediapipe.python.solutions as solutions
            if (fqn.startsWith("mediapipe::autoit::")) {
                const parts = fqn.split("::");

                for (let i = 2; i < parts.length; i++) {
                    generator.add_func([`${ [parts[0]].concat(parts.slice(2, i)).join(".") }.`, "", ["/Properties"], [
                        [parts.slice(0, i + 1).join("::"), parts[i], "", ["/R", "=this", "/S"]],
                    ], "", ""]);
                }
            }
        },
        convert: (generator, coclass, header, impl, opts) => {
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
        dynamicPointerCast: (generator, coclass, opts) => {
            const {fqn, children} = coclass;

            if (fqn !== "google::protobuf::Message") {
                return "";
            }

            return `switch(type_indexes[std::type_index(typeid(*in_val))]) {
                ${ [...children].map((child, index) => {
                    return `case ${ index + 1 }: {
                        auto derived = std::dynamic_pointer_cast<${ child.fqn }>(in_val);
                        AUTOIT_ASSERT_THROW(derived.get(), "object cannot be cast to a ${ child.fqn }");
                        return autoit_from(derived, out_val);
                    }`.replace(/^ {4}/mg, "");
                }).join(`\n${ " ".repeat(16) }`) }
            }`.replace(/^ {12}/mg, "");
        },
    };

    for (const opt of ["iface", "hdr", "impl", "idl", "manifest", "rgs", "res", "save"]) {
        options[opt] = !process.argv.includes(`--no-${ opt }`);
    }

    for (const opt of ["test"]) {
        options[opt] = process.argv.includes(`--${ opt }`);
    }

    for (const opt of process.argv) {
        if (opt.startsWith("--no-test=")) {
            for (const fqn of opt.slice("--no-test=".length).split(/[ ,]/)) {
                options.notest.add(fqn);
            }
        }

        if (opt.startsWith("--build=")) {
            for (const fqn of opt.slice("--build=".length).split(/[ ,]/)) {
                options.build.add(fqn);
            }
        }

        if (opt.startsWith("--skip=")) {
            for (const fqn of opt.slice("--skip=".length).split(/[ ,]/)) {
                options.skip.add(fqn);
            }
        }
    }

    return options;
};

const {
    CUSTOM_CLASSES,
} = require("./constants");

const {findFile} = require("./FileUtils");
const custom_declarations = require("./custom_declarations");
const AutoItGenerator = require("./AutoItGenerator");

const PROJECT_DIR = sysPath.resolve(__dirname, "../autoit-mediapipe-com");
const SRC_DIR = sysPath.join(PROJECT_DIR, "src");
const opencv_SOURCE_DIR = findFile(`${ OpenCV_VERSION }-*/opencv/sources`, sysPath.resolve(__dirname, ".."));

const src2 = sysPath.resolve(opencv_SOURCE_DIR, "modules/python/src2");

const hdr_parser = fs.readFileSync(sysPath.join(src2, "hdr_parser.py")).toString();
const hdr_parser_start = hdr_parser.indexOf("class CppHeaderParser");
const hdr_parser_end = hdr_parser.indexOf("if __name__ == '__main__':");

const options = parseArguments(PROJECT_DIR);

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
            const extname = sysPath.extname(path);
            const isheader = extname.startsWith(".h");
            let include = isheader && path.slice(SRC_DIR.length + 1).replace("\\", "/").startsWith("binding/");

            const content = await fsPromises.readFile(path);

            if (!include && isheader) {
                include = content.includes("CV_EXPORTS");
            }

            let match;
            matcher.lastIndex = 0;
            while ((match = matcher.exec(content))) {
                protofiles.add(`${ match[1] }.proto`);
            }

            if (include) {
                srcfiles.push(path);
            }

            next();
        }, {followSymlink: true}, err => {
            const generated_include = srcfiles.map(path => `#include "${ path.slice(SRC_DIR.length + 1).replace("\\", "/") }"`);
            next(err, srcfiles, protofiles, generated_include);
        });
    },

    (srcfiles, protofiles, generated_include, next) => {
        const mediapipe_SOURCE_DIR = fs.realpathSync(`${ __dirname }/../autoit-mediapipe-com/build_x64/_deps/mediapipe-src`);
        const protobuf_SOURCE_DIR = fs.realpathSync(`${ mediapipe_SOURCE_DIR }/bazel-mediapipe-src/external/com_google_protobuf/src`);

        const outputs = Parser.createOutputs();
        const cache = new Map();
        const opts = {
            proto_path: [
                mediapipe_SOURCE_DIR,
                protobuf_SOURCE_DIR,
            ]
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

            const generator = new AutoItGenerator();
            generator.generate(configuration, options, next);
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
                .replace(`${ " ".repeat(20) }if self.wrap_mode:`, `${ " ".repeat(20) }if False:`)
                .replace(/\("std::", ""\), \("cv::", ""\)/g, Array.from(options.namespaces).map(namespace => `("${ namespace }::", "")`).join(", "))
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
    }
], err => {
    if (err) {
        throw err;
    }
    console.log(`Build files have been written to: ${ options.output }`);
});
