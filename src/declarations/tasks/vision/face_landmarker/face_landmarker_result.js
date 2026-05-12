const ns = "mediapipe::tasks::vision::face_landmarker";
const nsProgId = ns.replaceAll("::", ".");
const containers = "mediapipe::tasks::components::containers";

module.exports = ({language}) => {
    const progid = `mediapipe.tasks.${ language }.vision.face_landmarker`;
    const utils = `mediapipe::tasks::${ language }::core::utils`;

    return [
        // expose face_landmarker properties like in mediapipe python
        [`${ progid }.`, "", ["/Properties"], [
            [`${ ns }::FaceLandmarkerResult`, "FaceLandmarkerResult", "", ["/R", "=this", "/S"]],
        ], "", ""],

        [`struct ${ nsProgId }.FaceLandmarkerResult`, "", [`/progid=${ progid }.FaceLandmarkerResult`, "/Simple", "/DC"], [
            ["std::vector<std::vector<components::containers::NormalizedLandmark>>", "face_landmarks", "", ["/RW", `/RExpr=${ containers }::CppConvertToNormalizedLandmarkListList($0)`, `/WExpr=${ containers }::CppConvertToNormalizedLandmarksList($value, $0, $hr)`]],
            ["std::optional<std::vector<std::vector<components::containers::Category>>>", "face_blendshapes", "", ["/RW", `/RExpr=${ containers }::CppConvertToClassificationsResult($0)`, `/WExpr=${ containers }::CppConvertToClassificationsList($value, $0, $hr)`]],
            ["std::optional<std::vector<cv::Mat>>", "facial_transformation_matrixes", "", ["/RW", `/RExpr=${ utils }::CppConvertToMatView($0)`, `/WExpr=${ utils }::CppConvertToMatrix($value, $0, $hr)`]],
        ], "", ""],
    ];
};
