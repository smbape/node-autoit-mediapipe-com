const ns = "mediapipe::tasks::vision::pose_landmarker";
const nsProgId = ns.replaceAll("::", ".");
const containers = "mediapipe::tasks::components::containers";

module.exports = ({language}) => {
    const progid = `mediapipe.tasks.${ language }.vision.pose_landmarker`;

    return [
        // expose pose_landmarker properties like in mediapipe python
        [`${ progid }.`, "", ["/Properties"], [
            [`${ ns }::PoseLandmarkerResult`, "PoseLandmarkerResult", "", ["/R", "=this", "/S"]],
        ], "", ""],

        [`struct ${ nsProgId }.PoseLandmarkerResult`, "", [`/progid=${ progid }.PoseLandmarkerResult`, "/Simple", "/DC"], [
            ["std::optional<std::vector<Image>>", "segmentation_masks", "", ["/RW"]],
            ["std::vector<std::vector<components::containers::NormalizedLandmark>>", "pose_landmarks", "", ["/RW", `/RExpr=${ containers }::CppConvertToNormalizedLandmarkListList($0)`, `/WExpr=${ containers }::CppConvertToNormalizedLandmarksList($value, $0, $hr)`]],
            ["std::vector<std::vector<components::containers::Landmark>>", "pose_world_landmarks", "", ["/RW", `/RExpr=${ containers }::CppConvertToLandmarkListList($0)`, `/WExpr=${ containers }::CppConvertToLandmarksList($value, $0, $hr)`]],
        ], "", ""],
    ];
};
