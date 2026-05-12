const ns = "mediapipe::tasks::components::containers";
const nsProgId = ns.replaceAll("::", ".");

module.exports = ({language}) => {
    const progid = `mediapipe.tasks.${ language }.components.containers.keypoint`;

    return [
        // expose keypoint properties like in mediapipe python
        [`${ progid }.`, "", ["/Properties"], [
            [`${ ns }::NormalizedKeypoint`, "NormalizedKeypoint", "", ["/R", "=this", "/S"]],
        ], "", ""],

        [`struct ${ nsProgId }.NormalizedKeypoint`, "", [`/progid=${ progid }.NormalizedKeypoint`, "/Simple", "/DC"], [
            ["float", "x", "", ["/RW"]],
            ["float", "y", "", ["/RW"]],
            ["std::optional<std::string>", "label", "", ["/RW"]],
            ["std::optional<float>", "score", "", ["/RW"]],
        ], "", ""],
    ];
};
