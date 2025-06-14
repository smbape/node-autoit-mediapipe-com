const fs = require("node:fs");
const sysPath = require("node:path");

const test_on_video_fullpose_squats = fs.readFileSync(process.env.APPDATA + "..\\Local\\Temp\\test_on_video_fullpose_squats.full.json");
const data = JSON.parse(test_on_video_fullpose_squats);

const text = ["#include-once", ""];

for (const name of ["predictions", "predictions_world"]) {
    const varName = `$EXPECTED_${ name.toUpperCase() }_POSE_LANDMARKS_PER_FRAME`;
    text.push(`Global ${ varName } = _OpenCV_ObjCreate("VectorOfMat")`, "");

    for (const frame of data[name]) {
        for (const point of frame) {
            text.push(`${varName}.append($Mat.createFromArray(_OpenCV_Tuple(${ point.join(", ") }), $CV_32F))`);
        }
    }

    text.push("", `${ varName } = $cv.vconcat(${ varName })`, "");
}

fs.writeFileSync(sysPath.join(__dirname, "test_on_video_fullpose_squats.full.au3"), text.join("\r\n"));
