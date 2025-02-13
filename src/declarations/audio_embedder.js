module.exports = ({language}) => [
    // expose audio_embedder properties like in mediapipe python
    [`mediapipe.tasks.${ language }.audio.audio_embedder.`, "", ["/Properties"], [
        [`mediapipe::tasks::${ language }::components::containers::embedding_result::EmbeddingResult`, "AudioEmbedderResult", "", ["/R", "=this", "/S"]],
    ], "", ""],
];
