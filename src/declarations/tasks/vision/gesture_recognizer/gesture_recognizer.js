const ns = "mediapipe::tasks::vision::gesture_recognizer";
const nsProgId = ns.replaceAll("::", ".");
const fqn = `${ ns }::GestureRecognizer`;
const RunningMode = "tasks::vision::core::RunningMode";

module.exports = ({language}) => {
    const progid = `mediapipe.tasks.${ language }.vision.gesture_recognizer`;
    const nsLanguage = `tasks::${ language }::vision::gesture_recognizer`;
    const utils = `mediapipe::tasks::${ language }::core::utils`;

    return [
        // expose gesture_recognizer properties like in mediapipe python
        [`${ progid }.`, "", ["/Properties"], [
            [`${ ns }::GestureRecognizerOptions`, "GestureRecognizerOptions", "", ["/R", "=this", "/S"]],
            [`${ ns }::GestureRecognizer`, "GestureRecognizer", "", ["/R", "=this", "/S"]],
        ], "", ""],

        [`struct ${ nsProgId }.GestureRecognizerOptions`, "", [`/progid=${ progid }.GestureRecognizerOptions`, "/Simple", "/DC"], [
            ["tasks::core::BaseOptions", "base_options", "", ["/RW"]],
            ["core::RunningMode", "running_mode", `${ RunningMode }::IMAGE`, ["/RW"]],
            ["int", "num_hands", "1", ["/RW"]],
            ["float", "min_hand_detection_confidence", "0.5f", ["/RW"]],
            ["float", "min_hand_presence_confidence", "0.5f", ["/RW"]],
            ["float", "min_tracking_confidence", "0.5f", ["/RW"]],
            ["components::processors::ClassifierOptions", "canned_gestures_classifier_options", "", ["/RW"]],
            ["components::processors::ClassifierOptions", "custom_gestures_classifier_options", "", ["/RW"]],
            ["GestureRecognizerResultCallback", "result_callback", "", [`/WExpr=${ utils }::CppConvertToGestureRecognizerResultCallback($value, $0, $hr)`]],
        ], "", ""],

        [`class ${ nsProgId }.GestureRecognizer`, "", [`/progid=${ progid }.GestureRecognizer`], [], "", ""],

        [`${ nsProgId }.GestureRecognizer.Create`, `std::shared_ptr<${ fqn }>`, ["=create_from_model_path", "/S", `/WrapAs=${ utils }::ReleaseToSharedPtr`], [
            ["std::string", "model_path", "", [`/Expr=std::unique_ptr<GestureRecognizerOptions>(new GestureRecognizerOptions{ .base_options{ .model_asset_path{ $0 } }, .running_mode{ ${ RunningMode }::IMAGE } })`]],
        ], "", ""],

        [`${ nsProgId }.GestureRecognizer.Create`, `std::shared_ptr<${ fqn }>`, ["=create_from_options", "/S", `/WrapAs=${ utils }::ReleaseToSharedPtr`], [
            ["std::shared_ptr<GestureRecognizerOptions>", "options", "", ["/Expr=tasks::autoit::core::utils::ConvertToUniquePtr($0)"]],
        ], "", ""],

        [`${ nsProgId }.GestureRecognizer.Recognize`, `absl::StatusOr<${ nsLanguage }::GestureRecognizerResult>`, ["=recognize", `/WrapAs=${ nsLanguage }::ConvertToGestureRecognizerResult`], [
            ["Image", "image", "", []],
            ["std::optional<core::ImageProcessingOptions>", "image_processing_options", "std::nullopt", []],
        ], "", ""],

        [`${ nsProgId }.GestureRecognizer.RecognizeForVideo`, `absl::StatusOr<${ nsLanguage }::GestureRecognizerResult>`, ["=recognize_for_video", `/WrapAs=${ nsLanguage }::ConvertToGestureRecognizerResult`], [
            ["Image", "image", "", []],
            ["uint64_t", "timestamp_ms", "", []],
            ["std::optional<core::ImageProcessingOptions>", "image_processing_options", "std::nullopt", []],
        ], "", ""],

        [`${ nsProgId }.GestureRecognizer.RecognizeAsync`, "absl::Status", ["=recognize_async"], [
            ["Image", "image", "", []],
            ["uint64_t", "timestamp_ms", "", []],
            ["std::optional<core::ImageProcessingOptions>", "image_processing_options", "std::nullopt", []],
        ], "", ""],

        [`${ nsProgId }.GestureRecognizer.Close`, "absl::Status", ["=close"], [], "", ""],
    ];
};
