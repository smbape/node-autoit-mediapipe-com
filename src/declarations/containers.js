module.exports = ({language}) => [
    // expose a containers property like in mediapipe python
    [`mediapipe.tasks.${ language }.components.containers.`, "", ["/Properties"], [
        [`mediapipe::tasks::${ language }::components::containers::audio_data::AudioDataFormat`, "AudioDataFormat", "", ["/R", "=this", "/S"]],
        [`mediapipe::tasks::${ language }::components::containers::audio_data::AudioData`, "AudioData", "", ["/R", "=this", "/S"]],
        [`mediapipe::tasks::${ language }::components::containers::bounding_box::BoundingBox`, "BoundingBox", "", ["/R", "=this", "/S"]],
        // [`mediapipe::tasks::${ language }::components::containers::category::Category`, `Category`, ``, [`/R`, `=this`]], // name conflict between class name and namespace
        [`mediapipe::tasks::${ language }::components::containers::classification_result::Classifications`, "Classifications", "", ["/R", "=this", "/S"]],
        [`mediapipe::tasks::${ language }::components::containers::classification_result::ClassificationResult`, "ClassificationResult", "", ["/R", "=this", "/S"]],
        [`mediapipe::tasks::${ language }::components::containers::detections::Detection`, "Detection", "", ["/R", "=this", "/S"]],
        [`mediapipe::tasks::${ language }::components::containers::detections::DetectionResult`, "DetectionResult", "", ["/R", "=this", "/S"]],
        [`mediapipe::tasks::${ language }::components::containers::embedding_result::Embedding`, "Embedding", "", ["/R", "=this", "/S"]],
        [`mediapipe::tasks::${ language }::components::containers::embedding_result::EmbeddingResult`, "EmbeddingResult", "", ["/R", "=this", "/S"]],
        // [`mediapipe::tasks::${ language }::components::containers::landmark::Landmark`, `Landmark`, ``, [`/R`, `=this`]], // name conflict between class name and namespace
        [`mediapipe::tasks::${ language }::components::containers::landmark::NormalizedLandmark`, "NormalizedLandmark", "", ["/R", "=this", "/S"]],
        // [`mediapipe::tasks::${ language }::components::containers::rect::Rect`, `Rect`, ``, [`/R`, `=this`]], // name conflict between class name and namespace
        [`mediapipe::tasks::${ language }::components::containers::rect::NormalizedRect`, "NormalizedRect", "", ["/R", "=this", "/S"]],
    ], "", ""],
];
