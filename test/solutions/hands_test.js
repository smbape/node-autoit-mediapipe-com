const fs = require("node:fs");
const sysPath = require("node:path");

const test_on_video_fullasl_hand = fs.readFileSync("C:\\Users\\smbape\\AppData\\Local\\Temp\\test_on_video_fullasl_hand.full.json");
const data = JSON.parse(test_on_video_fullasl_hand);

const text = ["#include-once", ""];

for (const name of ["predictions", "predictions_world"]) {
    const varName = `$EXPECTED_${ name.toUpperCase() }_LANDMARKS_PER_FRAME`;
    text.push(`Global ${ varName } = _OpenCV_ObjCreate("VectorOfMat")`, "");

    for (const frame of data[name]) {
        for (const hand of frame) {
            for (const point of hand) {
                text.push(`${varName}.append($Mat.createFromArray(_OpenCV_Tuple(${ point.join(", ") }), $CV_32F))`);
            }
        }
    }

    text.push("", `${ varName } = $cv.vconcat(${ varName })`, "");
}

fs.writeFileSync(sysPath.join(__dirname, "test_on_video_fullasl_hand.full.au3"), text.join("\r\n"));
