const ns = "mediapipe::tasks::vision::hand_landmarker";
const nsProgId = ns.replaceAll("::", ".");
const containers = "mediapipe::tasks::components::containers";

module.exports = ({language}) => {
    const progid = `mediapipe.tasks.${ language }.vision.hand_landmarker`;

    return [
        // expose hand_landmarker properties like in mediapipe python
        [`${ progid }.`, "", ["/Properties"], [
            [`${ ns }::HandLandmarkerResult`, "HandLandmarkerResult", "", ["/R", "=this", "/S"]],
        ], "", ""],

        [`struct ${ nsProgId }.HandLandmarkerResult`, "", [`/progid=${ progid }.HandLandmarkerResult`, "/Simple", "/DC"], [
            ["std::vector<std::vector<components::containers::Category>>", "handedness", "", ["/RW", `/RExpr=${ containers }::CppConvertToClassificationsResult($0)`, `/WExpr=${ containers }::CppConvertToClassificationsList($value, $0, $hr)`]],
            ["std::vector<std::vector<components::containers::NormalizedLandmark>>", "hand_landmarks", "", ["/RW", `/RExpr=${ containers }::CppConvertToNormalizedLandmarkListList($0)`, `/WExpr=${ containers }::CppConvertToNormalizedLandmarksList($value, $0, $hr)`]],
            ["std::vector<std::vector<components::containers::Landmark>>", "hand_world_landmarks", "", ["/RW", `/RExpr=${ containers }::CppConvertToLandmarkListList($0)`, `/WExpr=${ containers }::CppConvertToLandmarksList($value, $0, $hr)`]],
        ], "", ""],
    ];
};
