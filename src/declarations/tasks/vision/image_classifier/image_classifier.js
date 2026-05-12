const ns = "mediapipe::tasks::vision::image_classifier";
const nsProgId = ns.replaceAll("::", ".");
const fqn = `${ ns }::ImageClassifier`;
const RunningMode = "tasks::vision::core::RunningMode";

module.exports = ({language, self_get}) => {
    const progid = `mediapipe.tasks.${ language }.vision.image_classifier`;
    const utils = `mediapipe::tasks::${ language }::core::utils`;

    return [
        // expose image_classifier properties like in mediapipe python
        [`${ progid }.`, "", ["/Properties"], [
            [`${ ns }::ImageClassifierOptions`, "ImageClassifierOptions", "", ["/R", "=this", "/S"]],
            [`${ ns }::ImageClassifier`, "ImageClassifier", "", ["/R", "=this", "/S"]],
            ["mediapipe::tasks::components::containers::ClassificationResult", "ImageClassifierResult", "", ["/R", "=this", "/S"]],
        ], "", ""],

        [`struct ${ nsProgId }.ImageClassifierOptions`, "", [`/progid=${ progid }.ImageClassifierOptions`, "/Simple", "/DC"], [
            ["tasks::core::BaseOptions", "base_options", "", ["/RW"]],
            ["core::RunningMode", "running_mode", `${ RunningMode }::IMAGE`, ["/RW"]],
            ["components::processors::ClassifierOptions", "classifier_options", "", ["/RW"]],
            ["ImageClassifierResultCallback", "result_callback", "", [`/WExpr=${ utils }::CppConvertToResultCallback($value, $0, $hr)`]],
        ], "", ""],

        [`${ nsProgId }.ImageClassifierOptions.ImageClassifierOptions`, "", ["/Expr=", `/DC=
            if (base_options) { ${ self_get("base_options") } = std::move(*base_options); }
            ${ self_get("running_mode") } = running_mode;
            if (display_names_locale) { ${ self_get("classifier_options") }.display_names_locale = std::move(*display_names_locale); }
            if (max_results) { ${ self_get("classifier_options") }.max_results = std::move(*max_results); }
            if (score_threshold) { ${ self_get("classifier_options") }.score_threshold = std::move(*score_threshold); }
            if (category_allowlist) { ${ self_get("classifier_options") }.category_allowlist = std::move(*category_allowlist); }
            if (category_denylist) { ${ self_get("classifier_options") }.category_denylist = std::move(*category_denylist); }
            if (result_callback) { ${ self_get("result_callback") } = ${ utils }::CppConvertToResultCallback(*result_callback); }
            if (classifier_options) { ${ self_get("classifier_options") } = std::move(*classifier_options); }
        `.replace(/^ {8}/mg, "").trim()], [
            ["std::optional<tasks::core::BaseOptions>", "base_options", "std::nullopt", []],
            ["core::RunningMode", "running_mode", `${ RunningMode }::IMAGE`, []],
            ["std::optional<std::string>", "display_names_locale", "std::nullopt", []],
            ["std::optional<int>", "max_results", "std::nullopt", []],
            ["std::optional<float>", "score_threshold", "std::nullopt", []],
            ["std::optional<std::vector<std::string>>", "category_allowlist", "std::nullopt", []],
            ["std::optional<std::vector<std::string>>", "category_denylist", "std::nullopt", []],
            ["std::optional<ImageClassifierResultCallback>", "result_callback", "std::nullopt", []],
            ["std::optional<components::processors::ClassifierOptions>", "classifier_options", "std::nullopt", []],
        ], "", ""],

        [`class ${ nsProgId }.ImageClassifier`, "", [`/progid=${ progid }.ImageClassifier`], [], "", ""],

        [`${ nsProgId }.ImageClassifier.Create`, `std::shared_ptr<${ fqn }>`, ["=create_from_model_path", "/S", `/WrapAs=${ utils }::ReleaseToSharedPtr`], [
            ["std::string", "model_path", "", [`/Expr=std::unique_ptr<ImageClassifierOptions>(new ImageClassifierOptions{ .base_options{ .model_asset_path{ $0 } }, .running_mode{ ${ RunningMode }::IMAGE } })`]],
        ], "", ""],

        [`${ nsProgId }.ImageClassifier.Create`, `std::shared_ptr<${ fqn }>`, ["=create_from_options", "/S", `/WrapAs=${ utils }::ReleaseToSharedPtr`], [
            ["std::shared_ptr<ImageClassifierOptions>", "options", "", ["/Expr=tasks::autoit::core::utils::ConvertToUniquePtr($0)"]],
        ], "", ""],

        [`${ nsProgId }.ImageClassifier.Classify`, "absl::StatusOr<ImageClassifierResult>", ["=classify"], [
            ["Image", "image", "", []],
            ["std::optional<core::ImageProcessingOptions>", "image_processing_options", "std::nullopt", []],
        ], "", ""],

        [`${ nsProgId }.ImageClassifier.ClassifyForVideo`, "absl::StatusOr<ImageClassifierResult>", ["=classify_for_video"], [
            ["Image", "image", "", []],
            ["uint64_t", "timestamp_ms", "", []],
            ["std::optional<core::ImageProcessingOptions>", "image_processing_options", "std::nullopt", []],
        ], "", ""],

        [`${ nsProgId }.ImageClassifier.ClassifyAsync`, "absl::Status", ["=classify_async"], [
            ["Image", "image", "", []],
            ["uint64_t", "timestamp_ms", "", []],
            ["std::optional<core::ImageProcessingOptions>", "image_processing_options", "std::nullopt", []],
        ], "", ""],

        [`${ nsProgId }.ImageClassifier.Close`, "absl::Status", ["=close"], [], "", ""],
    ];
};
