const ns = "mediapipe::tasks::vision::face_detector";
const nsProgId = ns.replaceAll("::", ".");
const fqn = `${ ns }::FaceDetector`;
const RunningMode = "tasks::vision::core::RunningMode";

module.exports = ({language}) => {
    const progid = `mediapipe.tasks.${ language }.vision.face_detector`;
    const utils = `mediapipe::tasks::${ language }::core::utils`;

    return [
        // expose face_detector properties like in mediapipe python
        [`${ progid }.`, "", ["/Properties"], [
            [`${ ns }::FaceDetectorOptions`, "FaceDetectorOptions", "", ["/R", "=this", "/S"]],
            [`${ ns }::FaceDetector`, "FaceDetector", "", ["/R", "=this", "/S"]],
            ["mediapipe::tasks::components::containers::DetectionResult", "FaceDetectorResult", "", ["/R", "=this", "/S"]],
        ], "", ""],

        [`struct ${ nsProgId }.FaceDetectorOptions`, "", [`/progid=${ progid }.FaceDetectorOptions`, "/Simple", "/DC"], [
            ["tasks::core::BaseOptions", "base_options", "", ["/RW"]],
            ["core::RunningMode", "running_mode", `${ RunningMode }::IMAGE`, ["/RW"]],
            ["float", "min_detection_confidence", "0.5f", ["/RW"]],
            ["float", "min_suppression_threshold", "0.3f", ["/RW"]],
            ["FaceDetectorResultCallback", "result_callback", "", [`/WExpr=${ utils }::CppConvertToResultCallback($value, $0, $hr)`]],
        ], "", ""],

        [`class ${ nsProgId }.FaceDetector`, "", [`/progid=${ progid }.FaceDetector`], [], "", ""],

        [`${ nsProgId }.FaceDetector.Create`, `std::shared_ptr<${ fqn }>`, ["=create_from_model_path", "/S", `/WrapAs=${ utils }::ReleaseToSharedPtr`], [
            ["std::string", "model_path", "", [`/Expr=std::unique_ptr<FaceDetectorOptions>(new FaceDetectorOptions{ .base_options{ .model_asset_path{ $0 } }, .running_mode{ ${ RunningMode }::IMAGE } })`]],
        ], "", ""],

        [`${ nsProgId }.FaceDetector.Create`, `std::shared_ptr<${ fqn }>`, ["=create_from_options", "/S", `/WrapAs=${ utils }::ReleaseToSharedPtr`], [
            ["std::shared_ptr<FaceDetectorOptions>", "options", "", ["/Expr=tasks::autoit::core::utils::ConvertToUniquePtr($0)"]],
        ], "", ""],

        [`${ nsProgId }.FaceDetector.Detect`, "absl::StatusOr<FaceDetectorResult>", ["=detect"], [
            ["Image", "image", "", []],
            ["std::optional<core::ImageProcessingOptions>", "image_processing_options", "std::nullopt", []],
        ], "", ""],

        [`${ nsProgId }.FaceDetector.DetectForVideo`, "absl::StatusOr<FaceDetectorResult>", ["=detect_for_video"], [
            ["Image", "image", "", []],
            ["uint64_t", "timestamp_ms", "", []],
            ["std::optional<core::ImageProcessingOptions>", "image_processing_options", "std::nullopt", []],
        ], "", ""],

        [`${ nsProgId }.FaceDetector.DetectAsync`, "absl::Status", ["=detect_async"], [
            ["Image", "image", "", []],
            ["uint64_t", "timestamp_ms", "", []],
            ["std::optional<core::ImageProcessingOptions>", "image_processing_options", "std::nullopt", []],
        ], "", ""],

        [`${ nsProgId }.FaceDetector.Close`, "absl::Status", ["=close"], [], "", ""],
    ];
};
