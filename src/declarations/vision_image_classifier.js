module.exports = ({language}) => [
    // expose face_detector properties like in mediapipe python
    [`mediapipe.tasks.${ language }.vision.image_classifier.`, "", ["/Properties"], [
        [`mediapipe::tasks::${ language }::components::containers::classification_result::ClassificationResult`, "ImageClassifierResult", "", ["/R", "=this", "/S"]],
    ], "", ""],
];
