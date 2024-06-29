module.exports = [
    // expose audio_classifier properties like in mediapipe python
    ["mediapipe.tasks.autoit.audio.audio_classifier.", "", ["/Properties"], [
        ["mediapipe::tasks::autoit::components::containers::classification_result::ClassificationResult", "AudioClassifierResult", "", ["/R", "=this"]],
    ], "", ""],
];
