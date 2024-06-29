module.exports = [
    // expose face_detector properties like in mediapipe python
    ["mediapipe.tasks.autoit.vision.image_embedder.", "", ["/Properties"], [
        ["mediapipe::tasks::autoit::components::containers::embedding_result::EmbeddingResult", "ImageEmbedderResult", "", ["/R", "=this"]],
    ], "", ""],
];
