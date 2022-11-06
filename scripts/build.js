const { spawn } = require("child_process");
const sysPath = require("path");
const eachOfLimit = require("async/eachOfLimit");

const version = process.env.npm_package_version || require("../package.json").version;
const sources = sysPath.resolve(__dirname, "..");
const archive = sysPath.join(sources, `autoit-mediapipe-0.8.11-opencv-4.6.0-com-v${ version }.7z`);
const project = sysPath.join(sources, "autoit-mediapipe-com");

const files = [
    [project, "install.bat"],
    [project, "udf/*.au3"],
    [project, "udf/*.md"],
    [sysPath.join(project, "generated"), "mediapipeCOM.tlb"],
];

files.push([
    sysPath.join(project, "build_x64/mediapipe-prefix/src/mediapipe/bazel-bin"),
    "*.binarypb",
    "-r"
]);

for (const mode of ["dbg", "opt"]) {
    for (const extname of ["dll", "lib", "exp", "pdb"]) {
        files.push([
            sysPath.join(project, `build_x64/mediapipe-prefix/src/mediapipe/bazel-out/x64_windows-${ mode }/bin/mediapipe/autoit`),
            `autoit*.${ extname }`
        ]);
    }
}

eachOfLimit(files, 1, ([cwd, ...args], i, next) => {
    const child = spawn("7z", ["a", archive, ...args], {
        cwd,
        stdio: "inherit"
    });

    child.on("close", next);
    child.on("error", next);
});
