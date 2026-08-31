const ns = "mediapipe::tasks::text::text_embedder";
const nsProgId = ns.replaceAll("::", ".");
const fqn = `${ ns }::TextEmbedder`;

module.exports = ({language, self_get}) => {
    const progid = `mediapipe.tasks.${ language }.text.text_embedder`;
    const utils = `mediapipe::tasks::${ language }::core::utils`;

    return [
        // expose text_embedder properties like in mediapipe python
        [`${ progid }.`, "", ["/Properties"], [
            [`${ ns }::EmbeddingType`, "EmbeddingType", "", ["/R", "=this", "/S"]],
            [`${ ns }::TextRole`, "TextRole", "", ["/R", "=this", "/S"]],
            [`${ ns }::TextFormatContext`, "TextFormatContext", "", ["/R", "=this", "/S"]],
            [`${ ns }::TextEmbedderOptions`, "TextEmbedderOptions", "", ["/R", "=this", "/S"]],
            [`${ ns }::TextEmbedder`, "TextEmbedder", "", ["/R", "=this", "/S"]],
            ["mediapipe::tasks::components::containers::EmbeddingResult", "TextEmbedderResult", "", ["/R", "=this", "/S"]],
        ], "", ""],

        [`enum class ${ nsProgId }.EmbeddingType`, "", [`/progid=${ progid }.EmbeddingType`], [
            [`const ${ nsProgId }.EmbeddingType.RETRIEVAL_QUERY`, "1", [], [], "", ""],
            [`const ${ nsProgId }.EmbeddingType.RETRIEVAL_DOCUMENT`, "2", [], [], "", ""],
            [`const ${ nsProgId }.EmbeddingType.SEMANTIC_SIMILARITY`, "3", [], [], "", ""],
            [`const ${ nsProgId }.EmbeddingType.CLASSIFICATION`, "4", [], [], "", ""],
            [`const ${ nsProgId }.EmbeddingType.CLUSTERING`, "5", [], [], "", ""],
            [`const ${ nsProgId }.EmbeddingType.QUESTION_ANSWERING`, "6", [], [], "", ""],
            [`const ${ nsProgId }.EmbeddingType.FACT_CHECKING`, "7", [], [], "", ""],
            [`const ${ nsProgId }.EmbeddingType.CODE_RETRIEVAL`, "8", [], [], "", ""],
        ], "", ""],

        [`enum class ${ nsProgId }.TextRole`, "", [`/progid=${ progid }.TextRole`], [
            [`const ${ nsProgId }.TextRole.kQuery`, "1", ["=QUERY"], [], "", ""],
            [`const ${ nsProgId }.TextRole.kDocument`, "2", ["=DOCUMENT"], [], "", ""],
        ], "", ""],

        [`struct ${ nsProgId }.TextFormatContext`, "", [`/progid=${ progid }.TextFormatContext`, "/Simple", "/DC"], [
            ["EmbeddingType", "task_type", "", ["/RW"]],
            ["std::optional<std::string>", "title", "std::nullopt", ["/RW"]],
            ["TextRole", "role", "TextRole::kQuery", ["/RW"]],
        ], "", ""],

        [`struct ${ nsProgId }.TextEmbedderOptions`, "", [`/progid=${ progid }.TextEmbedderOptions`, "/Simple"], [
            ["tasks::core::BaseOptions", "base_options", "", ["/RW"]],
            ["components::processors::EmbedderOptions", "embedder_options", "", ["/RW"]],

            ["bool", "l2_normalize", "", ["/RW", `/RExpr=${ self_get("embedder_options") }.l2_normalize`, `/WExpr=${ self_get("embedder_options") }.l2_normalize = $value`]],
            ["bool", "quantize", "", ["/RW", `/RExpr=${ self_get("embedder_options") }.quantize`, `/WExpr=${ self_get("embedder_options") }.quantize = $value`]],
        ], "", ""],

        [`${ nsProgId }.TextEmbedderOptions.TextEmbedderOptions`, "", ["/Expr=", `/DC=
            if (base_options) { ${ self_get("base_options") } = *base_options; }
            if (l2_normalize) { ${ self_get("embedder_options") }.l2_normalize = *l2_normalize; }
            if (quantize) { ${ self_get("embedder_options") }.quantize = *quantize; }
            if (embedder_options) { ${ self_get("embedder_options") } = *embedder_options; }
        `.replace(/^ {8}/mg, "").trim()], [
            ["std::optional<tasks::core::BaseOptions>", "base_options", "std::nullopt", []],
            ["std::optional<bool>", "l2_normalize", "std::nullopt", []],
            ["std::optional<bool>", "quantize", "std::nullopt", []],
            ["std::optional<components::processors::EmbedderOptions>", "embedder_options", "std::nullopt", []],
        ], "", ""],

        [`class ${ nsProgId }.TextEmbedder`, "", [`/progid=${ progid }.TextEmbedder`], [], "", ""],

        [`${ nsProgId }.TextEmbedder.Create`, `std::shared_ptr<${ fqn }>`, ["=create_from_model_path", "/S", `/WrapAs=${ utils }::ReleaseToSharedPtr`], [
            ["std::string", "model_path", "", ["/Expr=std::unique_ptr<TextEmbedderOptions>(new TextEmbedderOptions{ .base_options{ .model_asset_path{ $0 } } })"]],
        ], "", ""],

        [`${ nsProgId }.TextEmbedder.Create`, `std::shared_ptr<${ fqn }>`, ["=create_from_options", "/S", `/WrapAs=${ utils }::ReleaseToSharedPtr`], [
            ["std::shared_ptr<TextEmbedderOptions>", "options", "", ["/Expr=tasks::autoit::core::utils::ConvertToUniquePtr($0)"]],
        ], "", ""],

        [`${ nsProgId }.TextEmbedder.Embed`, "absl::StatusOr<TextEmbedderResult>", ["=embed"], [
            ["std::string", "text", "", []],
        ], "", ""],

        [`${ nsProgId }.TextEmbedder.Embed`, "absl::StatusOr<TextEmbedderResult>", ["=embed"], [
            ["std::string", "text", "", []],
            ["TextFormatContext", "format_context", "", ["/C", "/Ref"]],
        ], "", ""],

        [`${ nsProgId }.TextEmbedder.Close`, "absl::Status", ["=close", "/GU"], [], "", ""],

        [`${ nsProgId }.TextEmbedder.CosineSimilarity`, "absl::StatusOr<double>", ["=cosine_similarity", "/S"], [
            ["components::containers::Embedding", "u", "", ["/C", "/Ref"]],
            ["components::containers::Embedding", "v", "", ["/C", "/Ref"]],
        ], "", ""],
    ];
};
