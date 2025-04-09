const { spawn } = require("node:child_process");
const sysPath = require("node:path");
const eachOfLimit = require("async/eachOfLimit");

const version = process.env.npm_package_version || require("../package.json").version;
const sources = sysPath.resolve(__dirname, "..");
const archive = sysPath.join(sources, `autoit-mediapipe-0.10.22-opencv-4.11.0-com-v${ version }.7z`);
const project = sysPath.join(sources, "autoit-mediapipe-com");

const files = [
    [project, "install.bat"],
    [project, "udf/*.au3", "udf/*.md"],
    [project, "dotnet/*.cs"],
    [sysPath.join(project, "udf"), "*.config", "*.manifest"],
    [sysPath.join(sources, "examples"), "dotnet/*.psm1"],
    [sysPath.join(project, "generated"), "*.tlb", "dotnet/*.dll"],
    [sysPath.join(project, "build_x64", "bin", "Debug"), "autoit*", "dotnet/*"],
    [sysPath.join(project, "build_x64", "bin", "Release"), "autoit*", "dotnet/*"],
];

files.push([
    sysPath.join(project, "build_x64/mediapipe-src/bazel-out/x64_windows-opt/bin"),
    "-r",
    "*.binarypb",
]);

files.push([
    sysPath.join(project, "build_x64/mediapipe-src"),
    "mediapipe/modules/objectron/object_detection_oidv4_labelmap.txt",
    "mediapipe/modules/hand_landmark/handedness.txt",
]);

eachOfLimit(files, 1, ([cwd, ...args], i, next) => {
    const child = spawn("7z", ["a", archive, ...args], {
        cwd,
        stdio: "inherit"
    });

    child.on("close", () => {
        if (next !== null) {
            next();
        }
    });
    child.on("error", err => {
        if (next !== null) {
            next(err);
            next = null;
        } else {
            console.error(err);
        }
    });
});
