module.exports = ({language}) => [
    // expose face_detector properties like in mediapipe python
    [`mediapipe.tasks.${ language }.vision.face_detector.`, "", ["/Properties"], [
        [`mediapipe::tasks::${ language }::components::containers::detections::DetectionResult`, "FaceDetectorResult", "", ["/R", "=this", "/S"]],
    ], "", ""],
];
