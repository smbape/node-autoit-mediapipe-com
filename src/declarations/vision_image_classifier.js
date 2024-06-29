module.exports = [
    // expose face_detector properties like in mediapipe python
    ["mediapipe.tasks.autoit.vision.image_classifier.", "", ["/Properties"], [
        ["mediapipe::tasks::autoit::components::containers::classification_result::ClassificationResult", "ImageClassifierResult", "", ["/R", "=this"]],
    ], "", ""],
];
