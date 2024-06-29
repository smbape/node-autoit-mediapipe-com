module.exports = [
    // expose audio properties like in mediapipe python
    ["mediapipe.tasks.autoit.audio.", "", ["/Properties"], [
        ["mediapipe::tasks::autoit::audio::audio_classifier::AudioClassifier", "AudioClassifier", "", ["/R", "=this"]],
        ["mediapipe::tasks::autoit::audio::audio_classifier::AudioClassifierOptions", "AudioClassifierOptions", "", ["/R", "=this"]],
        ["mediapipe::tasks::autoit::components::containers::classification_result::ClassificationResult", "AudioClassifierResult", "", ["/R", "=this"]],
        ["mediapipe::tasks::autoit::audio::audio_embedder::AudioEmbedder", "AudioEmbedder", "", ["/R", "=this"]],
        ["mediapipe::tasks::autoit::audio::audio_embedder::AudioEmbedderOptions", "AudioEmbedderOptions", "", ["/R", "=this"]],
        ["mediapipe::tasks::autoit::components::containers::embedding_result::EmbeddingResult", "AudioEmbedderResult", "", ["/R", "=this"]],
        ["mediapipe::tasks::autoit::audio::core::audio_task_running_mode::AudioTaskRunningMode", "RunningMode", "", ["/R", "=this"]],
    ], "", ""],
];
