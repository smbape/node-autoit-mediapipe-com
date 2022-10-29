/* eslint-disable no-magic-numbers */

const fs = require("fs");
const fsPromises = require("fs/promises");
const sysPath = require("path");
const {spawn} = require("child_process");

const mkdirp = require("mkdirp");
const waterfall = require("async/waterfall");
const {explore} = require("fs-explorer");
const Parser = require("./protobuf/Parser");
const vector_conversion = require("./vector_conversion");

const progids = new Map([
    ["google.protobuf.TextFormat", "google.protobuf.text_format"],
]);

const parseArguments = PROJECT_DIR => {
    const options = {
        APP_NAME: "Mediapipe",
        LIB_UID: "29090432-104c-c6cd-cd2b-9f2a43abd5b6",
        LIBRARY: "mediapipeCOM",
        namespace: "mediapipe",
        shared_ptr: "std::shared_ptr",
        make_shared: "std::make_shared",
        assert: "AUTOIT_ASSERT",
        progid: progid => {
            if (progids.has(progid)) {
                return progids.get(progid);
            }

            return progid;
        },
        namespaces: new Set([
            "cv",
            "mediapipe",
            "std",
        ]),
        other_namespaces: new Set([
        ]),
        build: new Set(),
        notest: new Set(),
        skip: new Set(),
        make: sysPath.join(PROJECT_DIR, "build.bat"),
        includes: [sysPath.join(PROJECT_DIR, "src")],
        output: sysPath.join(PROJECT_DIR, "generated"),
        toc: true,
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
            }
        },
        convert: (coclass, header, impl, opts) => {
            const {fqn} = coclass;

            if (fqn.startsWith("google::protobuf::Repeated_")) {
                vector_conversion.convert_sort(coclass, header, impl, opts);
            }
        }
    };

    for (const opt of ["iface", "hdr", "impl", "idl", "rgs", "res", "save"]) {
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

const {replaceAliases} = require("./alias");

const custom_declarations = require("./custom_declarations");
const AutoItGenerator = require("./AutoItGenerator");

const PROJECT_DIR = sysPath.resolve(__dirname, "../autoit-mediapipe-com");
const SRC_DIR = sysPath.join(PROJECT_DIR, "src");

const candidates = fs.readdirSync(sysPath.join(__dirname, "..")).filter(path => {
    if (!path.startsWith("opencv-4.")) {
        return false;
    }

    try {
        fs.accessSync(sysPath.join(__dirname, "..", path, "opencv"), fs.constants.R_OK);
        return true;
    } catch (err) {
        return false;
    }
});

const src2 = sysPath.resolve(__dirname, "..", candidates[0], "opencv/sources/modules/python/src2");

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

        explore(SRC_DIR, async (path, stats, next) => {
            const extname = sysPath.extname(path);
            const isheader = extname.startsWith(".h");
            let include = isheader && path.slice(SRC_DIR.length + 1).replace("\\", "/").startsWith("binding/");

            if (!include && isheader) {
                const content = await fsPromises.readFile(path);
                include = content.includes("CV_EXPORTS");
            }

            if (include) {
                srcfiles.push(path);
            }

            next();
        }, {followSymlink: true}, err => {
            const generated_include = srcfiles.map(path => `#include "${ path.slice(SRC_DIR.length + 1).replace("\\", "/") }"`);
            next(err, srcfiles, generated_include);
        });
    },

    (srcfiles, generated_include, next) => {
        const outputs = Parser.createOutputs();
        const cache = new Map();
        const opts = {
            proto_path: [
                fs.realpathSync(`${ __dirname }/../autoit-mediapipe-com/build_x64/mediapipe-prefix/src/mediapipe`),
                fs.realpathSync(`${ __dirname }/../autoit-mediapipe-com/build_x64/mediapipe-prefix/src/mediapipe/bazel-mediapipe/external/com_google_protobuf/src`),
            ]
        };

        for (const filename of [
            "mediapipe/framework/calculator.proto",
            "mediapipe/framework/formats/detection.proto",
            "mediapipe/framework/formats/image_format.proto",

            // solution base calculators
            "mediapipe/calculators/core/constant_side_packet_calculator.proto",
            "mediapipe/calculators/image/image_transformation_calculator.proto",
            "mediapipe/calculators/tensor/tensors_to_detections_calculator.proto",
            "mediapipe/calculators/util/landmarks_smoothing_calculator.proto",
            "mediapipe/calculators/util/logic_calculator.proto",
            "mediapipe/calculators/util/thresholding_calculator.proto",
            "mediapipe/modules/objectron/calculators/lift_2d_frame_annotation_to_3d_calculator.proto",
        ]) {
            opts.filename = filename;
            const parser = new Parser();
            parser.parseFile(fs.realpathSync(`${ __dirname }/../autoit-mediapipe-com/build_x64/mediapipe-prefix/src/mediapipe/${ filename }`), opts, outputs, cache);
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

            const json = JSON.parse(replaceAliases(buffer.toString(), options));
            json.decls.push(...custom_declarations);

            const configuration = JSON.parse(replaceAliases(JSON.stringify(json), options));
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
