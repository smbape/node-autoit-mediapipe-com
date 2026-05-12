const ns = "mediapipe::tasks::vision";
const nsProgId = ns.replaceAll("::", ".");
const fqn = `${ ns }::ObjectDetector`;
const RunningMode = "tasks::vision::core::RunningMode";

module.exports = ({language}) => {
    const progid = `mediapipe.tasks.${ language }.vision.object_detector`;
    const utils = `mediapipe::tasks::${ language }::core::utils`;

    return [
        // expose object_detector properties like in mediapipe python
        [`${ progid }.`, "", ["/Properties"], [
            [`${ ns }::ObjectDetectorOptions`, "ObjectDetectorOptions", "", ["/R", "=this", "/S"]],
            [`${ ns }::ObjectDetector`, "ObjectDetector", "", ["/R", "=this", "/S"]],
            ["mediapipe::tasks::components::containers::DetectionResult", "ObjectDetectorResult", "", ["/R", "=this", "/S"]],
        ], "", ""],

        [`struct ${ nsProgId }.NonMaxSuppressionOptions`, "", [`/progid=${ progid }.NonMaxSuppressionOptions`, "/Simple", "/DC"], [
            ["bool", "multiclass_nms", "false", ["/RW"]],
            ["float", "min_suppression_threshold", "0.3f", ["/RW"]],
        ], "", ""],

        [`struct ${ nsProgId }.ObjectDetectorOptions`, "", [`/progid=${ progid }.ObjectDetectorOptions`, "/Simple", "/DC"], [
            ["tasks::core::BaseOptions", "base_options", "", ["/RW"]],
            ["core::RunningMode", "running_mode", `${ RunningMode }::IMAGE`, ["/RW"]],
            ["std::string", "display_names_locale", "\"en\"", ["/RW"]],
            ["int", "max_results", "-1", ["/RW"]],
            ["float", "score_threshold", "0.0f", ["/RW"]],
            ["std::vector<std::string>", "category_allowlist", "{}", ["/RW"]],
            ["std::vector<std::string>", "category_denylist", "{}", ["/RW"]],
            ["NonMaxSuppressionOptions", "non_max_suppression_options", "", ["/RW"]],
            ["ObjectDetectorResultCallback", "result_callback", "", [`/WExpr=${ utils }::CppConvertToResultCallback($value, $0, $hr)`]],
        ], "", ""],

        [`class ${ nsProgId }.ObjectDetector`, "", [`/progid=${ progid }.ObjectDetector`], [], "", ""],

        [`${ nsProgId }.ObjectDetector.Create`, `std::shared_ptr<${ fqn }>`, ["=create_from_model_path", "/S", `/WrapAs=${ utils }::ReleaseToSharedPtr`], [
            ["std::string", "model_path", "", [`/Expr=std::unique_ptr<ObjectDetectorOptions>(new ObjectDetectorOptions{ .base_options{ .model_asset_path{ $0 } }, .running_mode{ ${ RunningMode }::IMAGE } })`]],
        ], "", ""],

        [`${ nsProgId }.ObjectDetector.Create`, `std::shared_ptr<${ fqn }>`, ["=create_from_options", "/S", `/WrapAs=${ utils }::ReleaseToSharedPtr`], [
            ["std::shared_ptr<ObjectDetectorOptions>", "options", "", ["/Expr=tasks::autoit::core::utils::ConvertToUniquePtr($0)"]],
        ], "", ""],

        [`${ nsProgId }.ObjectDetector.Detect`, "absl::StatusOr<ObjectDetectorResult>", ["=detect"], [
            ["Image", "image", "", []],
            ["std::optional<core::ImageProcessingOptions>", "image_processing_options", "std::nullopt", []],
        ], "", ""],

        [`${ nsProgId }.ObjectDetector.DetectForVideo`, "absl::StatusOr<ObjectDetectorResult>", ["=detect_for_video"], [
            ["Image", "image", "", []],
            ["uint64_t", "timestamp_ms", "", []],
            ["std::optional<core::ImageProcessingOptions>", "image_processing_options", "std::nullopt", []],
        ], "", ""],

        [`${ nsProgId }.ObjectDetector.DetectAsync`, "absl::Status", ["=detect_async"], [
            ["Image", "image", "", []],
            ["uint64_t", "timestamp_ms", "", []],
            ["std::optional<core::ImageProcessingOptions>", "image_processing_options", "std::nullopt", []],
        ], "", ""],

        [`${ nsProgId }.ObjectDetector.Close`, "absl::Status", ["=close"], [], "", ""],
    ];
};
