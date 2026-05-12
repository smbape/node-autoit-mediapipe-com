module.exports = ({language}) => [
    // import mediapipe.tasks.python as tasks
    // from mediapipe.tasks.python.vision.core.image import Image
    // from mediapipe.tasks.python.vision.core.image import ImageFormat
    ["mediapipe.", "", ["/Properties"], [
        [`mediapipe::tasks::${ language }`, "tasks", "", ["/R", "=this", "/S"]],
        ["mediapipe::Image", "Image", "", ["/R", "=this", "/S"]],
        ["mediapipe::ImageFormat::Format", "ImageFormat", "", ["/R", "=this", "/S"]],
    ], "", ""],
];
