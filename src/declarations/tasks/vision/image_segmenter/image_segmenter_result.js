const ns = "mediapipe::tasks::vision::image_segmenter";
const nsProgId = ns.replaceAll("::", ".");

module.exports = ({language}) => {
    const progid = `mediapipe.tasks.${ language }.vision.image_segmenter`;

    return [
        // expose image_segmenter properties like in mediapipe python
        [`${ progid }.`, "", ["/Properties"], [
            [`${ ns }::ImageSegmenterResult`, "ImageSegmenterResult", "", ["/R", "=this", "/S"]],
        ], "", ""],

        [`struct ${ nsProgId }.ImageSegmenterResult`, "", [`/progid=${ progid }.ImageSegmenterResult`, "/Simple", "/DC"], [
            ["std::optional<std::vector<Image>>", "confidence_masks", "", ["/RW"]],
            ["std::optional<Image>", "category_mask", "", ["/RW"]],
            ["std::vector<float>", "quality_scores", "", ["/RW"]],
        ], "", ""],
    ];
};
