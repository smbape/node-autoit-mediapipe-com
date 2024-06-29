module.exports = [
    // expose audio_embedder properties like in mediapipe python
    ["mediapipe.tasks.autoit.audio.audio_embedder.", "", ["/Properties"], [
        ["mediapipe::tasks::autoit::components::containers::embedding_result::EmbeddingResult", "AudioEmbedderResult", "", ["/R", "=this"]],
    ], "", ""],
];
