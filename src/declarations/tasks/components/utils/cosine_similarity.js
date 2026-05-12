const ns = "mediapipe::tasks::components::utils";

module.exports = ({language}) => [
    // expose cosine_similarity properties like in mediapipe python
    [`mediapipe.tasks.${ language }.components.utils.cosine_similarity.cosine_similarity`, "absl::StatusOr<double>", [`/Call=${ ns }::CosineSimilarity`], [
        ["containers::Embedding", "u", "", ["/C", "/Ref"]],
        ["containers::Embedding", "v", "", ["/C", "/Ref"]],
    ], "", ""],
];
