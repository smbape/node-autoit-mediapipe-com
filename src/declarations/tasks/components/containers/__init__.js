const ns = "mediapipe::tasks::components::containers";

module.exports = ({language}) => [
    // expose a containers property like in mediapipe python
    [`mediapipe.tasks.${ language }.components.containers.`, "", ["/Properties"], [
        [`mediapipe::tasks::${ language }::components::containers::audio_data::AudioDataFormat`, "AudioDataFormat", "", ["/R", "=this", "/S"]],
        [`mediapipe::tasks::${ language }::components::containers::audio_data::AudioData`, "AudioData", "", ["/R", "=this", "/S"]],
        [`${ ns }::Rect`, "BoundingBox", "", ["/R", "=this", "/S"]],
        // [`${ ns }::Category`, "Category", "", ["/R", "=this", "/S"]], // name conflict between class name and namespace
        [`${ ns }::Classifications`, "Classifications", "", ["/R", "=this", "/S"]],
        [`${ ns }::ClassificationResult`, "ClassificationResult", "", ["/R", "=this", "/S"]],
        [`${ ns }::Detection`, "Detection", "", ["/R", "=this", "/S"]],
        [`${ ns }::DetectionResult`, "DetectionResult", "", ["/R", "=this", "/S"]],
        [`${ ns }::Embedding`, "Embedding", "", ["/R", "=this", "/S"]],
        [`${ ns }::EmbeddingResult`, "EmbeddingResult", "", ["/R", "=this", "/S"]],
        // [`${ ns }::Landmark`, "Landmark", "", ["/R", "=this", "/S"]], // name conflict between class name and namespace
        [`${ ns }::NormalizedLandmark`, "NormalizedLandmark", "", ["/R", "=this", "/S"]],
        // [`${ ns }::Rect`, "Rect", "", ["/R", "=this", "/S"]], // name conflict between class name and namespace
        [`${ ns }::NormalizedRect`, "NormalizedRect", "", ["/R", "=this", "/S"]],
    ], "", ""],
];
