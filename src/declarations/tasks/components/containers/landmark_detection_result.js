const ns = "mediapipe::tasks::components::containers";
const nsProgId = ns.replaceAll("::", ".");

module.exports = ({language}) => {
    const progid = `mediapipe.tasks.${ language }.components.containers.landmark_detection_result`;

    return [
        // expose landmark_detection_result properties like in mediapipe python
        [`${ progid }.`, "", ["/Properties"], [
            [`${ ns }::LandmarksDetectionResult`, "LandmarksDetectionResult", "", ["/R", "=this", "/S"]],
        ], "", ""],

        [`struct ${ nsProgId }.LandmarksDetectionResult`, "", [`/progid=${ progid }.LandmarksDetectionResult`, "/Simple", "/DC"], [
            ["std::vector<NormalizedLandmark>", "landmarks", "", ["/RW"]],
            ["std::vector<Category>", "categories", "", ["/RW"]],
            ["std::vector<Landmark>", "world_landmarks", "", ["/RW"]],
            ["NormalizedRect", "rect", "", ["/RW"]],
        ], "", ""],
    ];
};
