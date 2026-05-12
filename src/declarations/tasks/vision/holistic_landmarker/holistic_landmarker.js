const ns = "mediapipe::tasks::vision::holistic_landmarker";
const nsProgId = ns.replaceAll("::", ".");
const fqn = `${ ns }::HolisticLandmarker`;
const RunningMode = "tasks::vision::core::RunningMode";

module.exports = ({language}) => {
    const progid = `mediapipe.tasks.${ language }.vision.holistic_landmarker`;
    const utils = `mediapipe::tasks::${ language }::core::utils`;

    return [
        // expose holistic_landmarker properties like in mediapipe python
        [`${ progid }.`, "", ["/Properties"], [
            [`${ ns }::HolisticLandmarkerOptions`, "HolisticLandmarkerOptions", "", ["/R", "=this", "/S"]],
            [`${ ns }::HolisticLandmarker`, "HolisticLandmarker", "", ["/R", "=this", "/S"]],
        ], "", ""],

        [`struct ${ nsProgId }.HolisticLandmarkerOptions`, "", [`/progid=${ progid }.HolisticLandmarkerOptions`, "/Simple", "/DC"], [
            ["tasks::core::BaseOptions", "base_options", "", ["/RW"]],
            ["core::RunningMode", "running_mode", `${ RunningMode }::IMAGE`, ["/RW"]],
            ["float", "min_face_detection_confidence", "0.5f", ["/RW"]],
            ["float", "min_face_suppression_threshold", "0.3f", ["/RW"]],
            ["float", "min_face_presence_confidence", "0.5f", ["/RW"]],
            ["float", "min_hand_landmarks_confidence", "0.5f", ["/RW"]],
            ["float", "min_pose_detection_confidence", "0.5f", ["/RW"]],
            ["float", "min_pose_suppression_threshold", "0.3f", ["/RW"]],
            ["float", "min_pose_presence_confidence", "0.5f", ["/RW"]],
            ["bool", "output_face_blendshapes", "false", ["/RW"]],
            ["bool", "output_segmentation_mask", "false", ["/RW", "=output_pose_segmentation_masks"]],
            ["HolisticLandmarkerResultCallback", "result_callback", "", [`/WExpr=${ utils }::CppConvertToResultCallback($value, $0, $hr)`]],
        ], "", ""],

        [`class ${ nsProgId }.HolisticLandmarker`, "", [`/progid=${ progid }.HolisticLandmarker`], [], "", ""],

        [`${ nsProgId }.HolisticLandmarker.Create`, `std::shared_ptr<${ fqn }>`, ["=create_from_model_path", "/S", `/WrapAs=${ utils }::ReleaseToSharedPtr`], [
            ["std::string", "model_path", "", [`/Expr=std::unique_ptr<HolisticLandmarkerOptions>(new HolisticLandmarkerOptions{ .base_options{ .model_asset_path{ $0 } }, .running_mode{ ${ RunningMode }::IMAGE } })`]],
        ], "", ""],

        [`${ nsProgId }.HolisticLandmarker.Create`, `std::shared_ptr<${ fqn }>`, ["=create_from_options", "/S", `/WrapAs=${ utils }::ReleaseToSharedPtr`], [
            ["std::shared_ptr<HolisticLandmarkerOptions>", "options", "", ["/Expr=tasks::autoit::core::utils::ConvertToUniquePtr($0)"]],
        ], "", ""],

        [`${ nsProgId }.HolisticLandmarker.Detect`, "absl::StatusOr<HolisticLandmarkerResult>", ["=detect"], [
            ["Image", "image", "", []],
            ["std::optional<core::ImageProcessingOptions>", "image_processing_options", "std::nullopt", []],
        ], "", ""],

        [`${ nsProgId }.HolisticLandmarker.DetectForVideo`, "absl::StatusOr<HolisticLandmarkerResult>", ["=detect_for_video"], [
            ["Image", "image", "", []],
            ["uint64_t", "timestamp_ms", "", []],
            ["std::optional<core::ImageProcessingOptions>", "image_processing_options", "std::nullopt", []],
        ], "", ""],

        [`${ nsProgId }.HolisticLandmarker.DetectAsync`, "absl::Status", ["=detect_async"], [
            ["Image", "image", "", []],
            ["uint64_t", "timestamp_ms", "", []],
            ["std::optional<core::ImageProcessingOptions>", "image_processing_options", "std::nullopt", []],
        ], "", ""],

        [`${ nsProgId }.HolisticLandmarker.Close`, "absl::Status", ["=close"], [], "", ""],
    ];
};
