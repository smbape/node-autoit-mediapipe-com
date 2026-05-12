const ns = "mediapipe::tasks::vision::interactive_segmenter";
const nsProgId = ns.replaceAll("::", ".");
const fqn = `${ ns }::InteractiveSegmenter`;

module.exports = ({language}) => {
    const progid = `mediapipe.tasks.${ language }.vision.interactive_segmenter`;
    const utils = `mediapipe::tasks::${ language }::core::utils`;

    return [
        // expose interactive_segmenter properties like in mediapipe python
        [`${ progid }.`, "", ["/Properties"], [
            [`${ ns }::InteractiveSegmenterOptions`, "InteractiveSegmenterOptions", "", ["/R", "=this", "/S"]],
            [`${ ns }::InteractiveSegmenter`, "InteractiveSegmenter", "", ["/R", "=this", "/S"]],
            [`${ ns }::RegionOfInterest`, "RegionOfInterest", "", ["/R", "=this", "/S"]],
            ["mediapipe::tasks::vision::image_segmenter::ImageSegmenterResult", "InteractiveSegmenterResult", "", ["/R", "=this", "/S"]],
        ], "", ""],

        [`struct ${ nsProgId }.InteractiveSegmenterOptions`, "", [`/progid=${ progid }.InteractiveSegmenterOptions`, "/Simple", "/DC"], [
            ["tasks::core::BaseOptions", "base_options", "", ["/RW"]],
            ["bool", "output_confidence_masks", "true", ["/RW"]],
            ["bool", "output_category_mask", "false", ["/RW"]],
        ], "", ""],

        [`enum class ${ nsProgId }.RegionOfInterest.Format`, "", [`/progid=${ progid }.RegionOfInterest.Format`], [
            [`const ${ nsProgId }.RegionOfInterest.Format.kUnspecified`, "0", ["=UNSPECIFIED"]],
            [`const ${ nsProgId }.RegionOfInterest.Format.kKeyPoint`, "1", ["=KEYPOINT"]],
            [`const ${ nsProgId }.RegionOfInterest.Format.kScribble`, "2", ["=SCRIBBLE"]],
        ], "", ""],

        [`struct ${ nsProgId }.RegionOfInterest`, "", [`/progid=${ progid }.RegionOfInterest`, "/Simple", "/DC"], [
            ["Format", "format", "RegionOfInterest::Format::kUnspecified", ["/RW"]],
            ["std::optional<components::containers::NormalizedKeypoint>", "keypoint", "", ["/RW"]],
            ["std::optional<std::vector<components::containers::NormalizedKeypoint>>", "scribble", "", ["/RW"]],
        ], "", ""],

        [`class ${ nsProgId }.InteractiveSegmenter`, "", [`/progid=${ progid }.InteractiveSegmenter`], [], "", ""],

        [`${ nsProgId }.InteractiveSegmenter.Create`, `std::shared_ptr<${ fqn }>`, ["=create_from_model_path", "/S", `/WrapAs=${ utils }::ReleaseToSharedPtr`], [
            ["std::string", "model_path", "", ["/Expr=std::unique_ptr<InteractiveSegmenterOptions>(new InteractiveSegmenterOptions{ .base_options{ .model_asset_path{ $0 } } })"]],
        ], "", ""],

        [`${ nsProgId }.InteractiveSegmenter.Create`, `std::shared_ptr<${ fqn }>`, ["=create_from_options", "/S", `/WrapAs=${ utils }::ReleaseToSharedPtr`], [
            ["std::shared_ptr<InteractiveSegmenterOptions>", "options", "", ["/Expr=tasks::autoit::core::utils::ConvertToUniquePtr($0)"]],
        ], "", ""],

        [`${ nsProgId }.InteractiveSegmenter.Segment`, "absl::StatusOr<InteractiveSegmenterResult>", ["=segment"], [
            ["Image", "image", "", []],
            ["RegionOfInterest", "roi", "", ["/C", "/Ref"]],
            ["std::optional<core::ImageProcessingOptions>", "image_processing_options", "std::nullopt", []],
        ], "", ""],

        [`${ nsProgId }.InteractiveSegmenter.Close`, "absl::Status", ["=close"], [], "", ""],
    ];
};
