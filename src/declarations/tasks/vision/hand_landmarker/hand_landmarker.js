const ns = "mediapipe::tasks::vision::hand_landmarker";
const nsProgId = ns.replaceAll("::", ".");
const fqn = `${ ns }::HandLandmarker`;
const RunningMode = "tasks::vision::core::RunningMode";

module.exports = ({language}) => {
    const progid = `mediapipe.tasks.${ language }.vision.hand_landmarker`;
    const utils = `mediapipe::tasks::${ language }::core::utils`;

    return [
        // expose hand_landmarker properties like in mediapipe python
        [`${ progid }.`, "", ["/Properties"], [
            [`${ ns }::HandLandmarkerOptions`, "HandLandmarkerOptions", "", ["/R", "=this", "/S"]],
            [`${ ns }::HandLandmarker`, "HandLandmarker", "", ["/R", "=this", "/S"]],
        ], "", ""],

        [`struct ${ nsProgId }.HandLandmarkerOptions`, "", [`/progid=${ progid }.HandLandmarkerOptions`, "/Simple", "/DC"], [
            ["tasks::core::BaseOptions", "base_options", "", ["/RW"]],
            ["core::RunningMode", "running_mode", `${ RunningMode }::IMAGE`, ["/RW"]],
            ["int", "num_hands", "1", ["/RW"]],
            ["float", "min_hand_detection_confidence", "0.5f", ["/RW"]],
            ["float", "min_hand_presence_confidence", "0.5f", ["/RW"]],
            ["float", "min_tracking_confidence", "0.5f", ["/RW"]],
            ["HandLandmarkerResultCallback", "result_callback", "", [`/WExpr=${ utils }::CppConvertToResultCallback($value, $0, $hr)`]],
        ], "", ""],

        [`class ${ nsProgId }.HandLandmarker`, "", [`/progid=${ progid }.HandLandmarker`], [
            ["mediapipe::tasks::components::containers::Connection", "Connection", "", ["/R", "=this", "/S"]],
        ], "", ""],

        [`${ nsProgId }.HandLandmarker.Create`, `std::shared_ptr<${ fqn }>`, ["=create_from_model_path", "/S", `/WrapAs=${ utils }::ReleaseToSharedPtr`], [
            ["std::string", "model_path", "", [`/Expr=std::unique_ptr<HandLandmarkerOptions>(new HandLandmarkerOptions{ .base_options{ .model_asset_path{ $0 } }, .running_mode{ ${ RunningMode }::IMAGE } })`]],
        ], "", ""],

        [`${ nsProgId }.HandLandmarker.Create`, `std::shared_ptr<${ fqn }>`, ["=create_from_options", "/S", `/WrapAs=${ utils }::ReleaseToSharedPtr`], [
            ["std::shared_ptr<HandLandmarkerOptions>", "options", "", ["/Expr=tasks::autoit::core::utils::ConvertToUniquePtr($0)"]],
        ], "", ""],

        [`${ nsProgId }.HandLandmarker.Detect`, "absl::StatusOr<HandLandmarkerResult>", ["=detect"], [
            ["Image", "image", "", []],
            ["std::optional<core::ImageProcessingOptions>", "image_processing_options", "std::nullopt", []],
        ], "", ""],

        [`${ nsProgId }.HandLandmarker.DetectForVideo`, "absl::StatusOr<HandLandmarkerResult>", ["=detect_for_video"], [
            ["Image", "image", "", []],
            ["uint64_t", "timestamp_ms", "", []],
            ["std::optional<core::ImageProcessingOptions>", "image_processing_options", "std::nullopt", []],
        ], "", ""],

        [`${ nsProgId }.HandLandmarker.DetectAsync`, "absl::Status", ["=detect_async"], [
            ["Image", "image", "", []],
            ["uint64_t", "timestamp_ms", "", []],
            ["std::optional<core::ImageProcessingOptions>", "image_processing_options", "std::nullopt", []],
        ], "", ""],

        [`${ nsProgId }.HandLandmarker.Close`, "absl::Status", ["=close"], [], "", ""],
    ];
};
