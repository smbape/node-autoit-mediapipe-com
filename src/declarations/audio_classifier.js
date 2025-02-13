module.exports = ({language}) => [
    // expose audio_classifier properties like in mediapipe python
    [`mediapipe.tasks.${ language }.audio.audio_classifier.`, "", ["/Properties"], [
        [`mediapipe::tasks::${ language }::components::containers::classification_result::ClassificationResult`, "AudioClassifierResult", "", ["/R", "=this", "/S"]],
    ], "", ""],
];
