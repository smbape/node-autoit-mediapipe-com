const ns = "mediapipe::tasks::vision::image_embedder";
const nsProgId = ns.replaceAll("::", ".");
const fqn = `${ ns }::ImageEmbedder`;
const RunningMode = "tasks::vision::core::RunningMode";

module.exports = ({language, self_get}) => {
    const progid = `mediapipe.tasks.${ language }.vision.image_embedder`;
    const utils = `mediapipe::tasks::${ language }::core::utils`;

    return [
        // expose image_embedder properties like in mediapipe python
        [`${ progid }.`, "", ["/Properties"], [
            [`${ ns }::ImageEmbedderOptions`, "ImageEmbedderOptions", "", ["/R", "=this", "/S"]],
            [`${ ns }::ImageEmbedder`, "ImageEmbedder", "", ["/R", "=this", "/S"]],
            ["mediapipe::tasks::components::containers::EmbeddingResult", "ImageEmbedderResult", "", ["/R", "=this", "/S"]],
        ], "", ""],

        [`struct ${ nsProgId }.ImageEmbedderOptions`, "", [`/progid=${ progid }.ImageEmbedderOptions`, "/Simple"], [
            ["tasks::core::BaseOptions", "base_options", "", ["/RW"]],
            ["core::RunningMode", "running_mode", `${ RunningMode }::IMAGE`, ["/RW"]],
            ["components::processors::EmbedderOptions", "embedder_options", "", ["/RW"]],
            ["ImageEmbedderResultCallback", "result_callback", "", [`/WExpr=${ utils }::CppConvertToResultCallback($value, $0, $hr)`]],

            ["bool", "l2_normalize", "", ["/RW", `/RExpr=${ self_get("embedder_options") }.l2_normalize`, `/WExpr=${ self_get("embedder_options") }.l2_normalize = $value`]],
            ["bool", "quantize", "", ["/RW", `/RExpr=${ self_get("embedder_options") }.quantize`, `/WExpr=${ self_get("embedder_options") }.quantize = $value`]],
        ], "", ""],

        [`${ nsProgId }.ImageEmbedderOptions.ImageEmbedderOptions`, "", ["/Expr=", `/DC=
            if (base_options) { ${ self_get("base_options") } = *base_options; }
            ${ self_get("running_mode") } = running_mode;
            if (l2_normalize) { ${ self_get("embedder_options") }.l2_normalize = *l2_normalize; }
            if (quantize) { ${ self_get("embedder_options") }.quantize = *quantize; }
            if (result_callback) { ${ self_get("result_callback") } = ${ utils }::CppConvertToResultCallback(*result_callback); }
            if (embedder_options) { ${ self_get("embedder_options") } = *embedder_options; }
        `.replace(/^ {8}/mg, "").trim()], [
            ["std::optional<tasks::core::BaseOptions>", "base_options", "std::nullopt", []],
            ["core::RunningMode", "running_mode", `${ RunningMode }::IMAGE`, []],
            ["std::optional<bool>", "l2_normalize", "std::nullopt", []],
            ["std::optional<bool>", "quantize", "std::nullopt", []],
            ["std::optional<ImageEmbedderResultCallback>", "result_callback", "std::nullopt", []],
            ["std::optional<components::processors::EmbedderOptions>", "embedder_options", "std::nullopt", []],
        ], "", ""],

        [`class ${ nsProgId }.ImageEmbedder`, "", [`/progid=${ progid }.ImageEmbedder`], [], "", ""],

        [`${ nsProgId }.ImageEmbedder.Create`, `std::shared_ptr<${ fqn }>`, ["=create_from_model_path", "/S", `/WrapAs=${ utils }::ReleaseToSharedPtr`], [
            ["std::string", "model_path", "", [`/Expr=std::unique_ptr<ImageEmbedderOptions>(new ImageEmbedderOptions{ .base_options{ .model_asset_path{ $0 } }, .running_mode{ ${ RunningMode }::IMAGE } })`]],
        ], "", ""],

        [`${ nsProgId }.ImageEmbedder.Create`, `std::shared_ptr<${ fqn }>`, ["=create_from_options", "/S", `/WrapAs=${ utils }::ReleaseToSharedPtr`], [
            ["std::shared_ptr<ImageEmbedderOptions>", "options", "", ["/Expr=tasks::autoit::core::utils::ConvertToUniquePtr($0)"]],
        ], "", ""],

        [`${ nsProgId }.ImageEmbedder.Embed`, "absl::StatusOr<ImageEmbedderResult>", ["=embed"], [
            ["Image", "image", "", []],
            ["std::optional<core::ImageProcessingOptions>", "image_processing_options", "std::nullopt", []],
        ], "", ""],

        [`${ nsProgId }.ImageEmbedder.EmbedForVideo`, "absl::StatusOr<ImageEmbedderResult>", ["=embed_for_video"], [
            ["Image", "image", "", []],
            ["uint64_t", "timestamp_ms", "", []],
            ["std::optional<core::ImageProcessingOptions>", "image_processing_options", "std::nullopt", []],
        ], "", ""],

        [`${ nsProgId }.ImageEmbedder.EmbedAsync`, "absl::Status", ["=embed_async"], [
            ["Image", "image", "", []],
            ["uint64_t", "timestamp_ms", "", []],
            ["std::optional<core::ImageProcessingOptions>", "image_processing_options", "std::nullopt", []],
        ], "", ""],

        [`${ nsProgId }.ImageEmbedder.Close`, "absl::Status", ["=close"], [], "", ""],

        [`${ nsProgId }.ImageEmbedder.cosine_similarity`, "absl::StatusOr<double>", ["/Call=mediapipe::tasks::components::utils::CosineSimilarity", "/S"], [
            ["containers::Embedding", "u", "", ["/C", "/Ref"]],
            ["containers::Embedding", "v", "", ["/C", "/Ref"]],
        ], "", ""],
    ];
};
