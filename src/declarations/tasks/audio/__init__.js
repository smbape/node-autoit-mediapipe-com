module.exports = ({language}) => [
    // expose audio properties like in mediapipe python
    [`mediapipe.tasks.${ language }.audio.`, "", ["/Properties"], [
        ["mediapipe::tasks::audio::audio_classifier::AudioClassifier", "AudioClassifier", "", ["/R", "=this", "/S"]],
        ["mediapipe::tasks::audio::audio_classifier::AudioClassifierOptions", "AudioClassifierOptions", "", ["/R", "=this", "/S"]],
        ["mediapipe::tasks::components::containers::ClassificationResult", "AudioClassifierResult", "", ["/R", "=this", "/S"]],
        ["mediapipe::tasks::audio::core::RunningMode", "RunningMode", "", ["/R", "=this", "/S"]],
    ], "", ""],
];
