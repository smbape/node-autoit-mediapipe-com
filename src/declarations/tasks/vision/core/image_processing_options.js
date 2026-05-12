const ns = "mediapipe::tasks::vision::core";
const nsProgId = ns.replaceAll("::", ".");

module.exports = ({language}) => {
    const progid = `mediapipe.tasks.${ language }.vision.core.image_processing_options`;

    return [
        // expose image_processing_options properties like in mediapipe python
        [`${ progid }.`, "", ["/Properties"], [
            [`${ ns }::ImageProcessingOptions`, "ImageProcessingOptions", "", ["/R", "=this", "/S"]],
        ], "", ""],

        [`struct ${ nsProgId }.ImageProcessingOptions`, "", [`/progid=${ progid }.ImageProcessingOptions`, "/Simple", "/DC"], [
            ["std::optional<components::containers::RectF>", "region_of_interest", "std::nullopt", ["/RW"]],
            ["int", "rotation_degrees", "0", ["/RW"]],
        ], "", ""],
    ];
};
