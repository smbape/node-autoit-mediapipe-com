const ns = "mediapipe::tasks::vision::holistic_landmarker";
const nsProgId = ns.replaceAll("::", ".");
const containers = "mediapipe::tasks::components::containers";

module.exports = ({language}) => {
    const progid = `mediapipe.tasks.${ language }.vision.holistic_landmarker`;

    return [
        // expose holistic_landmarker properties like in mediapipe python
        [`${ progid }.`, "", ["/Properties"], [
            [`${ ns }::HolisticLandmarkerResult`, "HolisticLandmarkerResult", "", ["/R", "=this", "/S"]],
        ], "", ""],

        [`struct ${ nsProgId }.HolisticLandmarkerResult`, "", [`/progid=${ progid }.HolisticLandmarkerResult`, "/Simple", "/DC"], [
            ["std::vector<components::containers::NormalizedLandmark>", "face_landmarks", "", ["/RW", `/RExpr=${ containers }::CppConvertToNormalizedLandmarkList($0)`, `/WExpr=${ containers }::CppConvertToNormalizedLandmarks($value, $0, $hr)`]],
            ["std::optional<std::vector<components::containers::Category>>", "face_blendshapes", "", ["/RW"]],
            ["std::vector<components::containers::NormalizedLandmark>", "pose_landmarks", "", ["/RW", `/RExpr=${ containers }::CppConvertToNormalizedLandmarkList($0)`, `/WExpr=${ containers }::CppConvertToNormalizedLandmarks($value, $0, $hr)`]],
            ["std::vector<components::containers::Landmark>", "pose_world_landmarks", "", ["/RW", `/RExpr=${ containers }::CppConvertToLandmarkList($0)`, `/WExpr=${ containers }::CppConvertToLandmarks($value, $0, $hr)`]],
            ["std::vector<components::containers::NormalizedLandmark>", "left_hand_landmarks", "", ["/RW", `/RExpr=${ containers }::CppConvertToNormalizedLandmarkList($0)`, `/WExpr=${ containers }::CppConvertToNormalizedLandmarks($value, $0, $hr)`]],
            ["std::vector<components::containers::NormalizedLandmark>", "right_hand_landmarks", "", ["/RW", `/RExpr=${ containers }::CppConvertToNormalizedLandmarkList($0)`, `/WExpr=${ containers }::CppConvertToNormalizedLandmarks($value, $0, $hr)`]],
            ["std::vector<components::containers::Landmark>", "left_hand_world_landmarks", "", ["/RW", `/RExpr=${ containers }::CppConvertToLandmarkList($0)`, `/WExpr=${ containers }::CppConvertToLandmarks($value, $0, $hr)`]],
            ["std::vector<components::containers::Landmark>", "right_hand_world_landmarks", "", ["/RW", `/RExpr=${ containers }::CppConvertToLandmarkList($0)`, `/WExpr=${ containers }::CppConvertToLandmarks($value, $0, $hr)`]],
            ["std::optional<Image>", "segmentation_mask", "", ["/RW", "=pose_segmentation_masks"]],
        ], "", ""],
    ];
};
