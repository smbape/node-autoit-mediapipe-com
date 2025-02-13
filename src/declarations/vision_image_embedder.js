module.exports = ({language}) => [
    // expose face_detector properties like in mediapipe python
    [`mediapipe.tasks.${ language }.vision.image_embedder.`, "", ["/Properties"], [
        [`mediapipe::tasks::${ language }::components::containers::embedding_result::EmbeddingResult`, "ImageEmbedderResult", "", ["/R", "=this", "/S"]],
    ], "", ""],
];
