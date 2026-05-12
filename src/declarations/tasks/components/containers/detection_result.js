const ns = "mediapipe::tasks::components::containers";
const nsProgId = ns.replaceAll("::", ".");

module.exports = ({language}) => {
    const progid = `mediapipe.tasks.${ language }.components.containers.detections`;

    return [
        // expose detections properties like in mediapipe python
        [`${ progid }.`, "", ["/Properties"], [
            [`${ ns }::Detection`, "Detection", "", ["/R", "=this", "/S"]],
            [`${ ns }::DetectionResult`, "DetectionResult", "", ["/R", "=this", "/S"]],
        ], "", ""],

        [`struct ${ nsProgId }.Detection`, "", [`/progid=${ progid }.Detection`, "/Simple", "/DC"], [
            ["std::vector<Category>", "categories", "", ["/RW"]],
            ["mediapipe::tasks::components::containers::Rect", "bounding_box", "{0, 0, 0, 0}", ["/RW"]],
            ["std::optional<std::vector<NormalizedKeypoint>>", "keypoints", "std::nullopt", ["/RW"]],
        ], "", ""],

        [`struct ${ nsProgId }.DetectionResult`, "", [`/progid=${ progid }.DetectionResult`, "/Simple", "/DC"], [
            ["std::vector<Detection>", "detections", "", ["/RW"]],
        ], "", ""],
    ];
};
