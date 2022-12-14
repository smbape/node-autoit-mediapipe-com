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
    [project, "dotnet/*.cs"],
    [sysPath.join(sources, "examples"), "dotnet/*.psm1"],
    [sysPath.join(project, "generated"), "*.tlb"],
    [sysPath.join(project, "build_x64", "Debug"), "autoit*", "dotnet/*"],
    [sysPath.join(project, "build_x64", "RelWithDebInfo"), "autoit*", "dotnet/*"],
];

files.push([
    sysPath.join(project, "build_x64/_deps/mediapipe-src/bazel-out/x64_windows-opt/bin"),
    "-r",
    "*.binarypb",
]);

files.push([
    sysPath.join(project, "build_x64/_deps/mediapipe-src"),
    "mediapipe/modules/objectron/object_detection_oidv4_labelmap.txt",
    "mediapipe/modules/hand_landmark/handedness.txt",
]);

for (const mode of ["dbg", "opt"]) {
    for (const extname of ["dll", "lib", "exp", "pdb"]) {
        files.push([
            sysPath.join(project, `build_x64/_deps/mediapipe-src/bazel-out/x64_windows-${ mode }/bin/mediapipe/autoit`),
            `autoit*.${ extname }`
        ]);
    }
}

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
