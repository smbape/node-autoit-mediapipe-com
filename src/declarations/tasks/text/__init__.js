module.exports = ({language}) => [
    // expose a containers property like in mediapipe python
    [`mediapipe.tasks.${ language }.text.`, "", ["/Properties"], [
        ["mediapipe::tasks::text::language_detector::LanguageDetector", "LanguageDetector", "", ["/R", "=this", "/S"]],
        ["mediapipe::tasks::text::language_detector::LanguageDetectorOptions", "LanguageDetectorOptions", "", ["/R", "=this", "/S"]],
        [`mediapipe::tasks::${ language }::text::language_detector::LanguageDetectorResult`, "LanguageDetectorResult", "", ["/R", "=this", "/S"]],
        ["mediapipe::tasks::text::text_classifier::TextClassifier", "TextClassifier", "", ["/R", "=this", "/S"]],
        ["mediapipe::tasks::text::text_classifier::TextClassifierOptions", "TextClassifierOptions", "", ["/R", "=this", "/S"]],
        ["mediapipe::tasks::components::containers::ClassificationResult", "TextClassifierResult", "", ["/R", "=this", "/S"]],
        ["mediapipe::tasks::text::text_embedder::TextEmbedder", "TextEmbedder", "", ["/R", "=this", "/S"]],
        ["mediapipe::tasks::text::text_embedder::TextEmbedderOptions", "TextEmbedderOptions", "", ["/R", "=this", "/S"]],
        ["mediapipe::tasks::components::containers::EmbeddingResult", "TextEmbedderResult", "", ["/R", "=this", "/S"]],
    ], "", ""],
];
