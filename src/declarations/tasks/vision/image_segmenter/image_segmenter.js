const ns = "mediapipe::tasks::vision::image_segmenter";
const nsProgId = ns.replaceAll("::", ".");
const fqn = `${ ns }::ImageSegmenter`;
const RunningMode = "tasks::vision::core::RunningMode";

module.exports = ({language}) => {
    const progid = `mediapipe.tasks.${ language }.vision.image_segmenter`;
    const utils = `mediapipe::tasks::${ language }::core::utils`;

    return [
        // expose image_segmenter properties like in mediapipe python
        [`${ progid }.`, "", ["/Properties"], [
            [`${ ns }::ImageSegmenterOptions`, "ImageSegmenterOptions", "", ["/R", "=this", "/S"]],
            [`${ ns }::ImageSegmenter`, "ImageSegmenter", "", ["/R", "=this", "/S"]],
        ], "", ""],

        [`struct ${ nsProgId }.ImageSegmenterOptions`, "", [`/progid=${ progid }.ImageSegmenterOptions`, "/Simple", "/DC"], [
            ["tasks::core::BaseOptions", "base_options", "", ["/RW"]],
            ["core::RunningMode", "running_mode", `${ RunningMode }::IMAGE`, ["/RW"]],
            ["std::string", "display_names_locale", "\"en\"", ["/RW"]],
            ["bool", "output_confidence_masks", "true", ["/RW"]],
            ["bool", "output_category_mask", "false", ["/RW"]],
            ["ImageSegmenterResultCallback", "result_callback", "", [`/WExpr=${ utils }::CppConvertToResultCallback($value, $0, $hr)`]],
        ], "", ""],

        [`class ${ nsProgId }.ImageSegmenter`, "", [`/progid=${ progid }.ImageSegmenter`], [
            ["std::vector<std::string>", "labels", "", ["/R=GetLabels"]],
        ], "", ""],

        [`${ nsProgId }.ImageSegmenter.Create`, `std::shared_ptr<${ fqn }>`, ["=create_from_model_path", "/S", `/WrapAs=${ utils }::ReleaseToSharedPtr`], [
            ["std::string", "model_path", "", [`/Expr=std::unique_ptr<ImageSegmenterOptions>(new ImageSegmenterOptions{ .base_options{ .model_asset_path{ $0 } }, .running_mode{ ${ RunningMode }::IMAGE } })`]],
        ], "", ""],

        [`${ nsProgId }.ImageSegmenter.Create`, `std::shared_ptr<${ fqn }>`, ["=create_from_options", "/S", `/WrapAs=${ utils }::ReleaseToSharedPtr`], [
            ["std::shared_ptr<ImageSegmenterOptions>", "options", "", ["/Expr=tasks::autoit::core::utils::ConvertToUniquePtr($0)"]],
        ], "", ""],

        [`${ nsProgId }.ImageSegmenter.Segment`, "absl::StatusOr<ImageSegmenterResult>", ["=segment"], [
            ["Image", "image", "", []],
            ["std::optional<core::ImageProcessingOptions>", "image_processing_options", "std::nullopt", []],
        ], "", ""],

        [`${ nsProgId }.ImageSegmenter.SegmentForVideo`, "absl::StatusOr<ImageSegmenterResult>", ["=segment_for_video"], [
            ["Image", "image", "", []],
            ["uint64_t", "timestamp_ms", "", []],
            ["std::optional<core::ImageProcessingOptions>", "image_processing_options", "std::nullopt", []],
        ], "", ""],

        [`${ nsProgId }.ImageSegmenter.SegmentAsync`, "absl::Status", ["=segment_async"], [
            ["Image", "image", "", []],
            ["uint64_t", "timestamp_ms", "", []],
            ["std::optional<core::ImageProcessingOptions>", "image_processing_options", "std::nullopt", []],
        ], "", ""],

        [`${ nsProgId }.ImageSegmenter.Close`, "absl::Status", ["=close"], [], "", ""],
    ];
};
