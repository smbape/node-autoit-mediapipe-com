module.exports = [
    // expose face_detector properties like in mediapipe python
    ["mediapipe.tasks.autoit.vision.object_detector.", "", ["/Properties"], [
        ["mediapipe::tasks::autoit::components::containers::detections::DetectionResult", "ObjectDetectorResult", "", ["/R", "=this"]],
    ], "", ""],
];
