const ns = "mediapipe::tasks::vision::pose_landmarker";
const nsProgId = ns.replaceAll("::", ".");
const fqn = `${ ns }::PoseLandmarker`;
const RunningMode = "tasks::vision::core::RunningMode";

module.exports = ({language}) => {
    const progid = `mediapipe.tasks.${ language }.vision.pose_landmarker`;
    const utils = `mediapipe::tasks::${ language }::core::utils`;

    return [
        // expose pose_landmarker properties like in mediapipe python
        [`${ progid }.`, "", ["/Properties"], [
            [`${ ns }::PoseLandmarkerOptions`, "PoseLandmarkerOptions", "", ["/R", "=this", "/S"]],
            [`${ ns }::PoseLandmarker`, "PoseLandmarker", "", ["/R", "=this", "/S"]],
        ], "", ""],

        [`struct ${ nsProgId }.PoseLandmarkerOptions`, "", [`/progid=${ progid }.PoseLandmarkerOptions`, "/Simple", "/DC"], [
            ["tasks::core::BaseOptions", "base_options", "", ["/RW"]],
            ["core::RunningMode", "running_mode", `${ RunningMode }::IMAGE`, ["/RW"]],
            ["int", "num_poses", "1", ["/RW"]],
            ["float", "min_pose_detection_confidence", "0.5f", ["/RW"]],
            ["float", "min_pose_presence_confidence", "0.5f", ["/RW"]],
            ["float", "min_tracking_confidence", "0.5f", ["/RW"]],
            ["bool", "output_segmentation_masks", "false", ["/RW"]],
            ["PoseLandmarkerResultCallback", "result_callback", "", [`/WExpr=${ utils }::CppConvertToResultCallback($value, $0, $hr)`]],
        ], "", ""],

        [`class ${ nsProgId }.PoseLandmarker`, "", [`/progid=${ progid }.PoseLandmarker`], [
            ["mediapipe::tasks::components::containers::Connection", "Connection", "", ["/R", "=this", "/S"]],
        ], "", ""],

        [`${ nsProgId }.PoseLandmarker.Create`, `std::shared_ptr<${ fqn }>`, ["=create_from_model_path", "/S", `/WrapAs=${ utils }::ReleaseToSharedPtr`], [
            ["std::string", "model_path", "", [`/Expr=std::unique_ptr<PoseLandmarkerOptions>(new PoseLandmarkerOptions{ .base_options{ .model_asset_path{ $0 } }, .running_mode{ ${ RunningMode }::IMAGE } })`]],
        ], "", ""],

        [`${ nsProgId }.PoseLandmarker.Create`, `std::shared_ptr<${ fqn }>`, ["=create_from_options", "/S", `/WrapAs=${ utils }::ReleaseToSharedPtr`], [
            ["std::shared_ptr<PoseLandmarkerOptions>", "options", "", ["/Expr=tasks::autoit::core::utils::ConvertToUniquePtr($0)"]],
        ], "", ""],

        [`${ nsProgId }.PoseLandmarker.Detect`, "absl::StatusOr<PoseLandmarkerResult>", ["=detect"], [
            ["Image", "image", "", []],
            ["std::optional<core::ImageProcessingOptions>", "image_processing_options", "std::nullopt", []],
        ], "", ""],

        [`${ nsProgId }.PoseLandmarker.DetectForVideo`, "absl::StatusOr<PoseLandmarkerResult>", ["=detect_for_video"], [
            ["Image", "image", "", []],
            ["uint64_t", "timestamp_ms", "", []],
            ["std::optional<core::ImageProcessingOptions>", "image_processing_options", "std::nullopt", []],
        ], "", ""],

        [`${ nsProgId }.PoseLandmarker.DetectAsync`, "absl::Status", ["=detect_async"], [
            ["Image", "image", "", []],
            ["uint64_t", "timestamp_ms", "", []],
            ["std::optional<core::ImageProcessingOptions>", "image_processing_options", "std::nullopt", []],
        ], "", ""],

        [`${ nsProgId }.PoseLandmarker.Close`, "absl::Status", ["=close"], [], "", ""],
    ];
};
