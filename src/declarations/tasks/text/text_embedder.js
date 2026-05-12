const ns = "mediapipe::tasks::text::text_embedder";
const nsProgId = ns.replaceAll("::", ".");
const fqn = `${ ns }::TextEmbedder`;

module.exports = ({language, self_get}) => {
    const progid = `mediapipe.tasks.${ language }.text.text_embedder`;
    const utils = `mediapipe::tasks::${ language }::core::utils`;

    return [
        // expose text_embedder properties like in mediapipe python
        [`${ progid }.`, "", ["/Properties"], [
            [`${ ns }::TextEmbedderOptions`, "TextEmbedderOptions", "", ["/R", "=this", "/S"]],
            [`${ ns }::TextEmbedder`, "TextEmbedder", "", ["/R", "=this", "/S"]],
            ["mediapipe::tasks::components::containers::EmbeddingResult", "TextEmbedderResult", "", ["/R", "=this", "/S"]],
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

        [`${ nsProgId }.TextEmbedder.Close`, "absl::Status", ["=close"], [], "", ""],

        [`${ nsProgId }.TextEmbedder.CosineSimilarity`, "absl::StatusOr<double>", ["=cosine_similarity", "/S"], [
            ["components::containers::Embedding", "u", "", ["/C", "/Ref"]],
            ["components::containers::Embedding", "v", "", ["/C", "/Ref"]],
        ], "", ""],
    ];
};
