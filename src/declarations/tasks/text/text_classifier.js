const ns = "mediapipe::tasks::text::text_classifier";
const nsProgId = ns.replaceAll("::", ".");
const fqn = `${ ns }::TextClassifier`;

module.exports = ({language, self_get}) => {
    const progid = `mediapipe.tasks.${ language }.text.text_classifier`;
    const utils = `mediapipe::tasks::${ language }::core::utils`;

    return [
        // expose text_classifier properties like in mediapipe python
        [`${ progid }.`, "", ["/Properties"], [
            [`${ ns }::TextClassifierOptions`, "TextClassifierOptions", "", ["/R", "=this", "/S"]],
            [`${ ns }::TextClassifier`, "TextClassifier", "", ["/R", "=this", "/S"]],
            ["mediapipe::tasks::components::containers::ClassificationResult", "TextClassifierResult", "", ["/R", "=this", "/S"]],
        ], "", ""],

        [`struct ${ nsProgId }.TextClassifierOptions`, "", [`/progid=${ progid }.TextClassifierOptions`, "/Simple"], [
            ["tasks::core::BaseOptions", "base_options", "", ["/RW"]],
            ["components::processors::ClassifierOptions", "classifier_options", "", ["/RW"]],

            ["std::string", "display_names_locale", "", ["/RW", `/RExpr=${ self_get("classifier_options") }.display_names_locale`, `/WExpr=autoit_to($value, ${ self_get("classifier_options") }.display_names_locale)`]],
            ["int", "max_results", "", ["/RW", `/RExpr=${ self_get("classifier_options") }.max_results`, `/WExpr=${ self_get("classifier_options") }.max_results = $value`]],
            ["float", "score_threshold", "", ["/RW", `/RExpr=${ self_get("classifier_options") }.score_threshold`, `/WExpr=${ self_get("classifier_options") }.score_threshold = $value`]],
            ["std::vector<std::string>", "category_allowlist", "", ["/RW", `/RExpr=${ self_get("classifier_options") }.category_allowlist`, `/WExpr=autoit_to($value, ${ self_get("classifier_options") }.category_allowlist)`]],
            ["std::vector<std::string>", "category_denylist", "", ["/RW", `/RExpr=${ self_get("classifier_options") }.category_denylist`, `/WExpr=autoit_to($value, ${ self_get("classifier_options") }.category_denylist)`]],
        ], "", ""],

        [`${ nsProgId }.TextClassifierOptions.TextClassifierOptions`, "", ["/Expr=", `/DC=
            if (base_options) { ${ self_get("base_options") } = std::move(*base_options); }
            if (display_names_locale) { ${ self_get("classifier_options") }.display_names_locale = std::move(*display_names_locale); }
            if (max_results) { ${ self_get("classifier_options") }.max_results = std::move(*max_results); }
            if (score_threshold) { ${ self_get("classifier_options") }.score_threshold = std::move(*score_threshold); }
            if (category_allowlist) { ${ self_get("classifier_options") }.category_allowlist = std::move(*category_allowlist); }
            if (category_denylist) { ${ self_get("classifier_options") }.category_denylist = std::move(*category_denylist); }
            if (classifier_options) { ${ self_get("classifier_options") } = std::move(*classifier_options); }
        `.replace(/^ {8}/mg, "").trim()], [
            ["std::optional<tasks::core::BaseOptions>", "base_options", "std::nullopt", []],
            ["std::optional<std::string>", "display_names_locale", "std::nullopt", []],
            ["std::optional<int>", "max_results", "std::nullopt", []],
            ["std::optional<float>", "score_threshold", "std::nullopt", []],
            ["std::optional<std::vector<std::string>>", "category_allowlist", "std::nullopt", []],
            ["std::optional<std::vector<std::string>>", "category_denylist", "std::nullopt", []],
            ["std::optional<components::processors::ClassifierOptions>", "classifier_options", "std::nullopt", []],
        ], "", ""],

        [`class ${ nsProgId }.TextClassifier`, "", [`/progid=${ progid }.TextClassifier`], [], "", ""],

        [`${ nsProgId }.TextClassifier.Create`, `std::shared_ptr<${ fqn }>`, ["=create_from_model_path", "/S", `/WrapAs=${ utils }::ReleaseToSharedPtr`], [
            ["std::string", "model_path", "", ["/Expr=std::unique_ptr<TextClassifierOptions>(new TextClassifierOptions{ .base_options{ .model_asset_path{ $0 } } })"]],
        ], "", ""],

        [`${ nsProgId }.TextClassifier.Create`, `std::shared_ptr<${ fqn }>`, ["=create_from_options", "/S", `/WrapAs=${ utils }::ReleaseToSharedPtr`], [
            ["std::shared_ptr<TextClassifierOptions>", "options", "", ["/Expr=tasks::autoit::core::utils::ConvertToUniquePtr($0)"]],
        ], "", ""],

        [`${ nsProgId }.TextClassifier.Classify`, "absl::StatusOr<TextClassifierResult>", ["=classify"], [
            ["std::string", "text", "", []],
        ], "", ""],

        [`${ nsProgId }.TextClassifier.Close`, "absl::Status", ["=close"], [], "", ""],
    ];
};
