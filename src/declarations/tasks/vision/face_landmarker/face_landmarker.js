const ns = "mediapipe::tasks::vision::face_landmarker";
const nsProgId = ns.replaceAll("::", ".");
const fqn = `${ ns }::FaceLandmarker`;
const RunningMode = "tasks::vision::core::RunningMode";

module.exports = ({language}) => {
    const progid = `mediapipe.tasks.${ language }.vision.face_landmarker`;
    const utils = `mediapipe::tasks::${ language }::core::utils`;

    return [
        // expose face_landmarker properties like in mediapipe python
        [`${ progid }.`, "", ["/Properties"], [
            [`${ ns }::FaceLandmarkerOptions`, "FaceLandmarkerOptions", "", ["/R", "=this", "/S"]],
            [`${ ns }::FaceLandmarker`, "FaceLandmarker", "", ["/R", "=this", "/S"]],
        ], "", ""],

        [`struct ${ nsProgId }.FaceLandmarkerOptions`, "", [`/progid=${ progid }.FaceLandmarkerOptions`, "/Simple", "/DC"], [
            ["tasks::core::BaseOptions", "base_options", "", ["/RW"]],
            ["core::RunningMode", "running_mode", `${ RunningMode }::IMAGE`, ["/RW"]],
            ["int", "num_faces", "1", ["/RW"]],
            ["float", "min_face_detection_confidence", "0.5f", ["/RW"]],
            ["float", "min_face_presence_confidence", "0.5f", ["/RW"]],
            ["float", "min_tracking_confidence", "0.5f", ["/RW"]],
            ["bool", "output_face_blendshapes", "false", ["/RW"]],
            ["bool", "output_facial_transformation_matrixes", "false", ["/RW"]],
            ["FaceLandmarkerResultCallback", "result_callback", "", [`/WExpr=${ utils }::CppConvertToResultCallback($value, $0, $hr)`]],
        ], "", ""],

        [`class ${ nsProgId }.FaceLandmarker`, "", [`/progid=${ progid }.FaceLandmarker`], [
            ["mediapipe::tasks::components::containers::Connection", "Connection", "", ["/R", "=this", "/S"]],
        ], "", ""],

        [`${ nsProgId }.FaceLandmarker.Create`, `std::shared_ptr<${ fqn }>`, ["=create_from_model_path", "/S", `/WrapAs=${ utils }::ReleaseToSharedPtr`], [
            ["std::string", "model_path", "", [`/Expr=std::unique_ptr<FaceLandmarkerOptions>(new FaceLandmarkerOptions{ .base_options{ .model_asset_path{ $0 } }, .running_mode{ ${ RunningMode }::IMAGE } })`]],
        ], "", ""],

        [`${ nsProgId }.FaceLandmarker.Create`, `std::shared_ptr<${ fqn }>`, ["=create_from_options", "/S", `/WrapAs=${ utils }::ReleaseToSharedPtr`], [
            ["std::shared_ptr<FaceLandmarkerOptions>", "options", "", ["/Expr=tasks::autoit::core::utils::ConvertToUniquePtr($0)"]],
        ], "", ""],

        [`${ nsProgId }.FaceLandmarker.Detect`, "absl::StatusOr<FaceLandmarkerResult>", ["=detect"], [
            ["Image", "image", "", []],
            ["std::optional<core::ImageProcessingOptions>", "image_processing_options", "std::nullopt", []],
        ], "", ""],

        [`${ nsProgId }.FaceLandmarker.DetectForVideo`, "absl::StatusOr<FaceLandmarkerResult>", ["=detect_for_video"], [
            ["Image", "image", "", []],
            ["uint64_t", "timestamp_ms", "", []],
            ["std::optional<core::ImageProcessingOptions>", "image_processing_options", "std::nullopt", []],
        ], "", ""],

        [`${ nsProgId }.FaceLandmarker.DetectAsync`, "absl::Status", ["=detect_async"], [
            ["Image", "image", "", []],
            ["uint64_t", "timestamp_ms", "", []],
            ["std::optional<core::ImageProcessingOptions>", "image_processing_options", "std::nullopt", []],
        ], "", ""],

        [`${ nsProgId }.FaceLandmarker.Close`, "absl::Status", ["=close"], [], "", ""],
    ];
};
