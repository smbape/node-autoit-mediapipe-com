module.exports = ({language}) => [
    // expose face_detector properties like in mediapipe python
    [`mediapipe.tasks.${ language }.vision.object_detector.`, "", ["/Properties"], [
        [`mediapipe::tasks::${ language }::components::containers::detections::DetectionResult`, "ObjectDetectorResult", "", ["/R", "=this", "/S"]],
    ], "", ""],
];
