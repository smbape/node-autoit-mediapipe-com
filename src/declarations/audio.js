module.exports = ({language}) => [
    // expose audio properties like in mediapipe python
    [`mediapipe.tasks.${ language }.audio.`, "", ["/Properties"], [
        [`mediapipe::tasks::${ language }::audio::audio_classifier::AudioClassifier`, "AudioClassifier", "", ["/R", "=this", "/S"]],
        [`mediapipe::tasks::${ language }::audio::audio_classifier::AudioClassifierOptions`, "AudioClassifierOptions", "", ["/R", "=this", "/S"]],
        [`mediapipe::tasks::${ language }::components::containers::classification_result::ClassificationResult`, "AudioClassifierResult", "", ["/R", "=this", "/S"]],
        [`mediapipe::tasks::${ language }::audio::audio_embedder::AudioEmbedder`, "AudioEmbedder", "", ["/R", "=this", "/S"]],
        [`mediapipe::tasks::${ language }::audio::audio_embedder::AudioEmbedderOptions`, "AudioEmbedderOptions", "", ["/R", "=this", "/S"]],
        [`mediapipe::tasks::${ language }::components::containers::embedding_result::EmbeddingResult`, "AudioEmbedderResult", "", ["/R", "=this", "/S"]],
        [`mediapipe::tasks::${ language }::audio::core::audio_task_running_mode::AudioTaskRunningMode`, "RunningMode", "", ["/R", "=this", "/S"]],
    ], "", ""],
];
