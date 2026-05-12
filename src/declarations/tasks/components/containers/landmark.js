const ns = "mediapipe::tasks::components::containers";
const nsProgId = ns.replaceAll("::", ".");

module.exports = ({language}) => {
    const progid = `mediapipe.tasks.${ language }.components.containers.landmark`;

    return [
        // expose landmark properties like in mediapipe python
        [`${ progid }.`, "", ["/Properties"], [
            [`${ ns }::Landmark`, "Landmark", "", ["/R", "=this", "/S"]],
            [`${ ns }::NormalizedLandmark`, "NormalizedLandmark", "", ["/R", "=this", "/S"]],
            [`${ ns }::Landmarks`, "Landmarks", "", ["/R", "=this", "/S"]],
            [`${ ns }::NormalizedLandmarks`, "NormalizedLandmarks", "", ["/R", "=this", "/S"]],
            [`${ ns }::Connection`, "Connection", "", ["/R", "=this", "/S"]],
        ], "", ""],

        [`struct ${ nsProgId }.Landmark`, "", [`/progid=${ progid }.Landmark`, "/Simple", "/DC"], [
            ["float", "x", "", ["/RW"]],
            ["float", "y", "", ["/RW"]],
            ["float", "z", "", ["/RW"]],
            ["std::optional<float>", "visibility", "std::nullopt", ["/RW"]],
            ["std::optional<float>", "presence", "std::nullopt", ["/RW"]],
            ["std::optional<std::string>", "name", "std::nullopt", ["/RW"]],
        ], "", ""],

        [`struct ${ nsProgId }.NormalizedLandmark`, "", [`/progid=${ progid }.NormalizedLandmark`, "/Simple", "/DC"], [
            ["float", "x", "", ["/RW"]],
            ["float", "y", "", ["/RW"]],
            ["float", "z", "", ["/RW"]],
            ["std::optional<float>", "visibility", "std::nullopt", ["/RW"]],
            ["std::optional<float>", "presence", "std::nullopt", ["/RW"]],
            ["std::optional<std::string>", "name", "std::nullopt", ["/RW"]],
        ], "", ""],

        [`struct ${ nsProgId }.Landmarks`, "", [`/progid=${ progid }.Landmarks`, "/Simple", "/DC"], [
            ["std::vector<Landmark>", "landmarks", "", ["/RW"]],
        ], "", ""],

        [`struct ${ nsProgId }.NormalizedLandmarks`, "", [`/progid=${ progid }.NormalizedLandmarks`, "/Simple", "/DC"], [
            ["std::vector<NormalizedLandmark>", "landmarks", "", ["/RW"]],
        ], "", ""],

        [`struct ${ nsProgId }.Connection`, "", [`/progid=${ progid }.Connection`, "/Simple", "/DC"], [
            ["int", "start", "", ["/RW"]],
            ["int", "end", "", ["/RW"]],
        ], "", ""],
    ];
};
