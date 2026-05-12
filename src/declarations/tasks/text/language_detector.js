const ns = "mediapipe::tasks::text::language_detector";
const nsProgId = ns.replaceAll("::", ".");
const fqn = `${ ns }::LanguageDetector`;

module.exports = ({language, self_get}) => {
    const progid = `mediapipe.tasks.${ language }.text.language_detector`;
    const CppConvertToLanguageDetectorResul = `tasks::${ language }::text::language_detector::CppConvertToLanguageDetectorResult`;
    const utils = `mediapipe::tasks::${ language }::core::utils`;

    return [
        // expose language_detector properties like in mediapipe python
        [`${ progid }.`, "", ["/Properties"], [
            [`${ ns }::LanguageDetectorOptions`, "LanguageDetectorOptions", "", ["/R", "=this", "/S"]],
            [`${ ns }::LanguageDetector`, "LanguageDetector", "", ["/R", "=this", "/S"]],
            [`mediapipe::tasks::${ language }::text::language_detector::LanguageDetectorResult`, "LanguageDetectorResult", "", ["/R", "=this", "/S"]],
            [`${ ns }::LanguageDetectorPrediction`, "LanguageDetectorPrediction", "", ["/R", "=this", "/S"]],
        ], "", ""],

        [`struct mediapipe.tasks.${ language }.text.language_detector.LanguageDetectorResult`, "", ["/Simple", "/DC"], [
            [`${ ns }::LanguageDetectorPrediction`, "Detection", "", ["/R", "=this", "/S"]],
            [`std::vector<${ ns }::LanguageDetectorPrediction>`, "detections", "", ["/RW"]],
        ], "", ""],

        [`struct ${ nsProgId }.LanguageDetectorPrediction`, "", [`/progid=${ progid }.LanguageDetectorPrediction`, "/Simple", "/DC"], [
            ["std::string", "language_code", "", ["/RW"]],
            ["float", "probability", "", ["/RW"]],
        ], "", ""],

        [`struct ${ nsProgId }.LanguageDetectorOptions`, "", [`/progid=${ progid }.LanguageDetectorOptions`, "/Simple"], [
            ["tasks::core::BaseOptions", "base_options", "", ["/RW"]],
            ["components::processors::ClassifierOptions", "classifier_options", "", ["/RW"]],

            ["std::string", "display_names_locale", "", ["/RW", `/RExpr=${ self_get("classifier_options") }.display_names_locale`, `/WExpr=autoit_to($value, ${ self_get("classifier_options") }.display_names_locale)`]],
            ["int", "max_results", "", ["/RW", `/RExpr=${ self_get("classifier_options") }.max_results`, `/WExpr=${ self_get("classifier_options") }.max_results = $value`]],
            ["float", "score_threshold", "", ["/RW", `/RExpr=${ self_get("classifier_options") }.score_threshold`, `/WExpr=${ self_get("classifier_options") }.score_threshold = $value`]],
            ["std::vector<std::string>", "category_allowlist", "", ["/RW", `/RExpr=${ self_get("classifier_options") }.category_allowlist`, `/WExpr=autoit_to($value, ${ self_get("classifier_options") }.category_allowlist)`]],
            ["std::vector<std::string>", "category_denylist", "", ["/RW", `/RExpr=${ self_get("classifier_options") }.category_denylist`, `/WExpr=autoit_to($value, ${ self_get("classifier_options") }.category_denylist)`]],
        ], "", ""],

        [`${ nsProgId }.LanguageDetectorOptions.LanguageDetectorOptions`, "", ["/Expr=", `/DC=
            if (base_options) { ${ self_get("base_options") } = *base_options; }
            if (display_names_locale) { ${ self_get("classifier_options") }.display_names_locale = *display_names_locale; }
            if (max_results) { ${ self_get("classifier_options") }.max_results = *max_results; }
            if (score_threshold) { ${ self_get("classifier_options") }.score_threshold = *score_threshold; }
            if (category_allowlist) { ${ self_get("classifier_options") }.category_allowlist = *category_allowlist; }
            if (category_denylist) { ${ self_get("classifier_options") }.category_denylist = *category_denylist; }
            if (classifier_options) { ${ self_get("classifier_options") } = *classifier_options; }
        `.replace(/^ {8}/mg, "").trim()], [
            ["std::optional<tasks::core::BaseOptions>", "base_options", "std::nullopt", []],
            ["std::optional<std::string>", "display_names_locale", "std::nullopt", []],
            ["std::optional<int>", "max_results", "std::nullopt", []],
            ["std::optional<float>", "score_threshold", "std::nullopt", []],
            ["std::optional<std::vector<std::string>>", "category_allowlist", "std::nullopt", []],
            ["std::optional<std::vector<std::string>>", "category_denylist", "std::nullopt", []],
            ["std::optional<components::processors::ClassifierOptions>", "classifier_options", "std::nullopt", []],
        ], "", ""],

        [`class ${ nsProgId }.LanguageDetector`, "", [`/progid=${ progid }.LanguageDetector`], [], "", ""],

        [`${ nsProgId }.LanguageDetector.Create`, `std::shared_ptr<${ fqn }>`, ["=create_from_model_path", "/S", `/WrapAs=${ utils }::ReleaseToSharedPtr`], [
            ["std::string", "model_path", "", ["/Expr=std::unique_ptr<LanguageDetectorOptions>(new LanguageDetectorOptions{ .base_options{ .model_asset_path{ $0 } } })"]],
        ], "", ""],

        [`${ nsProgId }.LanguageDetector.Create`, `std::shared_ptr<${ fqn }>`, ["=create_from_options", "/S", `/WrapAs=${ utils }::ReleaseToSharedPtr`], [
            ["std::shared_ptr<LanguageDetectorOptions>", "options", "", ["/Expr=tasks::autoit::core::utils::ConvertToUniquePtr($0)"]],
        ], "", ""],

        [`${ nsProgId }.LanguageDetector.Detect`, `absl::StatusOr<mediapipe::tasks::${ language }::text::language_detector::LanguageDetectorResult>`, ["=detect", `/WrapAs=${ CppConvertToLanguageDetectorResul }`], [
            ["std::string", "text", "", []],
        ], "", ""],

        [`${ nsProgId }.LanguageDetector.Close`, "absl::Status", ["=close"], [], "", ""],
    ];
};
