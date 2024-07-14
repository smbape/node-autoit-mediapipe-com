const process = require("node:process");
const { spawn } = require("node:child_process");
const sysPath = require("node:path");
const fs = require("node:fs");
const eachOfLimit = require("async/eachOfLimit");
const waterfall = require("async/waterfall");
const { explore } = require("fs-explorer");

const examples = [];
const output = process.argv[2];
const LF = "\n";

explore(sysPath.resolve(__dirname, "../examples/googlesamples/examples"), (path, stats, next) => {
    const basename = sysPath.basename(path);
    const extname = sysPath.extname(path);

    if (!path.endsWith(".au3") || path.endsWith("-gui.au3")) {
        next();
        return;
    }

    const content = fs.readFileSync(path).toString().replace(/\r?\n|\r/g, LF)
        .replaceAll("#include \"..\\..\\..\\..\\..\\", "#include \"")
        .replaceAll("_Mediapipe_FindDLL(\"opencv_world4100*\")", "\"opencv-4.10.0-windows\\opencv\\build\\x64\\vc16\\bin\\opencv_world4100.dll\"")
        .replaceAll("_Mediapipe_FindDLL(\"autoit_mediapipe_com-*-4100*\")", "\"autoit-mediapipe-com\\autoit_mediapipe_com-0.10.14-4100.dll\"")
        .replaceAll("_OpenCV_FindDLL(\"opencv_world4100*\")", "\"opencv-4.10.0-windows\\opencv\\build\\x64\\vc16\\bin\\opencv_world4100.dll\"")
        .replaceAll("_OpenCV_FindDLL(\"autoit_opencv_com4100*\")", "\"autoit-opencv-com\\autoit_opencv_com4100.dll\"")
        .replace("_Mediapipe_FindFile(\"examples\\data\")", "@ScriptDir & \"\\examples\\data\"");

    examples.push(content);

    if (output) {
        fs.writeFileSync(sysPath.join(output, `${ String(examples.length).padStart(2, "0") }-${ basename }`), content);
    }

    next();
}, (path, stats, files, state, next) => {
    const basename = sysPath.basename(path);
    const skip = state === "begin" && (basename[0] === "." || basename === "BackUp");
    next(null, skip);
}, err => {
    if (err) {
        throw err;
    }

    const readmeFile = sysPath.resolve(__dirname, "../README.md");
    const readme = fs.readFileSync(readmeFile).toString().replace(/\r?\n|\r/g, LF);
    const exampleStart = readme.indexOf("### AutoIt") + "### AutoIt".length + LF.length;
    const exampleEnd = readme.indexOf("### PowerShell", exampleStart + 1);
    const texts = [""];

    for (const content of examples) {
        const titleStart = content.indexOf(";~ Title: ") + ";~ Title: ".length;
        const titleEnd = content.indexOf(LF, titleStart + 1);
        const title = titleStart === -1 || titleEnd === -1 ? basename : content.slice(titleStart, titleEnd).trim();

        texts.push(...[
            `#### ${ title }`,
            "",
            "```autoit",
            content,
            "```",
            "",
        ]);
    }

    texts.push("");

    fs.writeFileSync(readmeFile, readme.slice(0, exampleStart) + texts.join(LF) + readme.slice(exampleEnd));
});
