module.exports = [
    // expose a containers property like in mediapipe python
    ["mediapipe.tasks.autoit.components.containers.", "", ["/Properties"], [
        ["mediapipe::tasks::autoit::components::containers::audio_data::AudioDataFormat", "AudioDataFormat", "", ["/R", "=this"]],
        ["mediapipe::tasks::autoit::components::containers::audio_data::AudioData", "AudioData", "", ["/R", "=this"]],
        ["mediapipe::tasks::autoit::components::containers::bounding_box::BoundingBox", "BoundingBox", "", ["/R", "=this"]],
        // ["mediapipe::tasks::autoit::components::containers::category::Category", "Category", "", ["/R", "=this"]], // name conflict between class name and namespace
        ["mediapipe::tasks::autoit::components::containers::classification_result::Classifications", "Classifications", "", ["/R", "=this"]],
        ["mediapipe::tasks::autoit::components::containers::classification_result::ClassificationResult", "ClassificationResult", "", ["/R", "=this"]],
        ["mediapipe::tasks::autoit::components::containers::detections::Detection", "Detection", "", ["/R", "=this"]],
        ["mediapipe::tasks::autoit::components::containers::detections::DetectionResult", "DetectionResult", "", ["/R", "=this"]],
        ["mediapipe::tasks::autoit::components::containers::embedding_result::Embedding", "Embedding", "", ["/R", "=this"]],
        ["mediapipe::tasks::autoit::components::containers::embedding_result::EmbeddingResult", "EmbeddingResult", "", ["/R", "=this"]],
        // ["mediapipe::tasks::autoit::components::containers::landmark::Landmark", "Landmark", "", ["/R", "=this"]], // name conflict between class name and namespace
        ["mediapipe::tasks::autoit::components::containers::landmark::NormalizedLandmark", "NormalizedLandmark", "", ["/R", "=this"]],
        // ["mediapipe::tasks::autoit::components::containers::rect::Rect", "Rect", "", ["/R", "=this"]], // name conflict between class name and namespace
        ["mediapipe::tasks::autoit::components::containers::rect::NormalizedRect", "NormalizedRect", "", ["/R", "=this"]],
    ], "", ""],
];
