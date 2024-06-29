module.exports = [
    // expose a containers property like in mediapipe python
    ["mediapipe.tasks.autoit.text.", "", ["/Properties"], [
        ["mediapipe::tasks::autoit::text::language_detector::LanguageDetector", "LanguageDetector", "", ["/R", "=this"]],
        ["mediapipe::tasks::autoit::text::language_detector::LanguageDetectorOptions", "LanguageDetectorOptions", "", ["/R", "=this"]],
        ["mediapipe::tasks::autoit::text::language_detector::LanguageDetectorResult", "LanguageDetectorResult", "", ["/R", "=this"]],
        ["mediapipe::tasks::autoit::text::text_classifier::TextClassifier", "TextClassifier", "", ["/R", "=this"]],
        ["mediapipe::tasks::autoit::text::text_classifier::TextClassifierOptions", "TextClassifierOptions", "", ["/R", "=this"]],
        ["mediapipe::tasks::autoit::components::containers::classification_result::ClassificationResult", "TextClassifierResult", "", ["/R", "=this"]],
        ["mediapipe::tasks::autoit::text::text_embedder::TextEmbedder", "TextEmbedder", "", ["/R", "=this"]],
        ["mediapipe::tasks::autoit::text::text_embedder::TextEmbedderOptions", "TextEmbedderOptions", "", ["/R", "=this"]],
        ["mediapipe::tasks::autoit::components::containers::embedding_result::EmbeddingResult", "TextEmbedderResult", "", ["/R", "=this"]],
    ], "", ""],
];
