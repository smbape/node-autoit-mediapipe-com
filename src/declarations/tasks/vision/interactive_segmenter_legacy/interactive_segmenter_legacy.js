const ns = "mediapipe::tasks::vision::interactive_segmenter_legacy";
const nsProgId = ns.replaceAll("::", ".");
const fqn = `${ ns }::InteractiveSegmenterLegacy`;

module.exports = ({language}) => {
    const progid = `mediapipe.tasks.${ language }.vision.interactive_segmenter_legacy`;
    const utils = `mediapipe::tasks::${ language }::core::utils`;

    return [
        // expose interactive_segmenter_legacy properties like in mediapipe python
        [`${ progid }.`, "", ["/Properties"], [
            [`${ ns }::InteractiveSegmenterLegacyOptions`, "InteractiveSegmenterLegacyOptions", "", ["/R", "=this", "/S"]],
            [`${ ns }::InteractiveSegmenterLegacy`, "InteractiveSegmenterLegacy", "", ["/R", "=this", "/S"]],
            [`${ ns }::RegionOfInterest`, "RegionOfInterest", "", ["/R", "=this", "/S"]],
            ["mediapipe::tasks::vision::image_segmenter::ImageSegmenterResult", "InteractiveSegmenterLegacyResult", "", ["/R", "=this", "/S"]],
        ], "", ""],

        [`struct ${ nsProgId }.InteractiveSegmenterLegacyOptions`, "", [`/progid=${ progid }.InteractiveSegmenterLegacyOptions`, "/Simple", "/DC"], [
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

        [`class ${ nsProgId }.InteractiveSegmenterLegacy`, "", [`/progid=${ progid }.InteractiveSegmenterLegacy`], [], "", ""],

        [`${ nsProgId }.InteractiveSegmenterLegacy.Create`, `std::shared_ptr<${ fqn }>`, ["=create_from_model_path", "/S", `/WrapAs=${ utils }::ReleaseToSharedPtr`], [
            ["std::string", "model_path", "", ["/Expr=std::unique_ptr<InteractiveSegmenterLegacyOptions>(new InteractiveSegmenterLegacyOptions{ .base_options{ .model_asset_path{ $0 } } })"]],
        ], "", ""],

        [`${ nsProgId }.InteractiveSegmenterLegacy.Create`, `std::shared_ptr<${ fqn }>`, ["=create_from_options", "/S", `/WrapAs=${ utils }::ReleaseToSharedPtr`], [
            ["std::shared_ptr<InteractiveSegmenterLegacyOptions>", "options", "", ["/Expr=tasks::autoit::core::utils::ConvertToUniquePtr($0)"]],
        ], "", ""],

        [`${ nsProgId }.InteractiveSegmenterLegacy.Segment`, "absl::StatusOr<InteractiveSegmenterLegacyResult>", ["=segment"], [
            ["Image", "image", "", []],
            ["RegionOfInterest", "roi", "", ["/C", "/Ref"]],
            ["std::optional<core::ImageProcessingOptions>", "image_processing_options", "std::nullopt", []],
        ], "", ""],

        [`${ nsProgId }.InteractiveSegmenterLegacy.Close`, "absl::Status", ["=close", "/GU"], [], "", ""],
    ];
};
