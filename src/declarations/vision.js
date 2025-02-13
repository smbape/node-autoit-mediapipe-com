module.exports = ({language}) => [
    // expose a vision property like in mediapipe python
    [`mediapipe.tasks.${ language }.vision.`, "", ["/Properties"], [
        [`mediapipe::tasks::${ language }::vision::face_aligner::FaceAligner`, "FaceAligner", "", ["/R", "=this", "/S"]],
        [`mediapipe::tasks::${ language }::vision::face_aligner::FaceAlignerOptions`, "FaceAlignerOptions", "", ["/R", "=this", "/S"]],
        [`mediapipe::tasks::${ language }::vision::face_detector::FaceDetector`, "FaceDetector", "", ["/R", "=this", "/S"]],
        [`mediapipe::tasks::${ language }::vision::face_detector::FaceDetectorOptions`, "FaceDetectorOptions", "", ["/R", "=this", "/S"]],
        [`mediapipe::tasks::${ language }::components::containers::detections::DetectionResult`, "FaceDetectorResult", "", ["/R", "=this", "/S"]],
        [`mediapipe::tasks::${ language }::vision::face_landmarker::FaceLandmarker`, "FaceLandmarker", "", ["/R", "=this", "/S"]],
        [`mediapipe::tasks::${ language }::vision::face_landmarker::FaceLandmarkerOptions`, "FaceLandmarkerOptions", "", ["/R", "=this", "/S"]],
        [`mediapipe::tasks::${ language }::vision::face_landmarker::FaceLandmarkerResult`, "FaceLandmarkerResult", "", ["/R", "=this", "/S"]],
        [`mediapipe::tasks::${ language }::vision::face_landmarker::FaceLandmarksConnections`, "FaceLandmarksConnections", "", ["/R", "=this", "/S"]],
        [`mediapipe::tasks::${ language }::vision::face_stylizer::FaceStylizer`, "FaceStylizer", "", ["/R", "=this", "/S"]],
        [`mediapipe::tasks::${ language }::vision::face_stylizer::FaceStylizerOptions`, "FaceStylizerOptions", "", ["/R", "=this", "/S"]],
        [`mediapipe::tasks::${ language }::vision::gesture_recognizer::GestureRecognizer`, "GestureRecognizer", "", ["/R", "=this", "/S"]],
        [`mediapipe::tasks::${ language }::vision::gesture_recognizer::GestureRecognizerOptions`, "GestureRecognizerOptions", "", ["/R", "=this", "/S"]],
        [`mediapipe::tasks::${ language }::vision::gesture_recognizer::GestureRecognizerResult`, "GestureRecognizerResult", "", ["/R", "=this", "/S"]],
        [`mediapipe::tasks::${ language }::vision::hand_landmarker::HandLandmarker`, "HandLandmarker", "", ["/R", "=this", "/S"]],
        [`mediapipe::tasks::${ language }::vision::hand_landmarker::HandLandmarkerOptions`, "HandLandmarkerOptions", "", ["/R", "=this", "/S"]],
        [`mediapipe::tasks::${ language }::vision::hand_landmarker::HandLandmarkerResult`, "HandLandmarkerResult", "", ["/R", "=this", "/S"]],
        [`mediapipe::tasks::${ language }::vision::hand_landmarker::HandLandmarksConnections`, "HandLandmarksConnections", "", ["/R", "=this", "/S"]],
        [`mediapipe::tasks::${ language }::vision::image_classifier::ImageClassifier`, "ImageClassifier", "", ["/R", "=this", "/S"]],
        [`mediapipe::tasks::${ language }::vision::image_classifier::ImageClassifierOptions`, "ImageClassifierOptions", "", ["/R", "=this", "/S"]],
        [`mediapipe::tasks::${ language }::components::containers::classification_result::ClassificationResult`, "ImageClassifierResult", "", ["/R", "=this", "/S"]],
        [`mediapipe::tasks::${ language }::vision::image_embedder::ImageEmbedder`, "ImageEmbedder", "", ["/R", "=this", "/S"]],
        [`mediapipe::tasks::${ language }::vision::image_embedder::ImageEmbedderOptions`, "ImageEmbedderOptions", "", ["/R", "=this", "/S"]],
        [`mediapipe::tasks::${ language }::components::containers::embedding_result::EmbeddingResult`, "ImageEmbedderResult", "", ["/R", "=this", "/S"]],
        [`mediapipe::tasks::${ language }::vision::image_segmenter::ImageSegmenter`, "ImageSegmenter", "", ["/R", "=this", "/S"]],
        [`mediapipe::tasks::${ language }::vision::image_segmenter::ImageSegmenterOptions`, "ImageSegmenterOptions", "", ["/R", "=this", "/S"]],
        [`mediapipe::tasks::${ language }::vision::core::image_processing_options::ImageProcessingOptions`, "ImageProcessingOptions", "", ["/R", "=this", "/S"]],
        ["mediapipe::tasks::vision::image_segmenter::proto::SegmenterOptions::OutputType", "ImageSegmenterOptions_OutputType", "", ["/R", "=this", "/S"]],
        ["mediapipe::tasks::vision::image_segmenter::proto::SegmenterOptions::Activation", "ImageSegmenterOptions_Activation", "", ["/R", "=this", "/S"]],
        [`mediapipe::tasks::${ language }::vision::interactive_segmenter::InteractiveSegmenter`, "InteractiveSegmenter", "", ["/R", "=this", "/S"]],
        [`mediapipe::tasks::${ language }::vision::interactive_segmenter::InteractiveSegmenterOptions`, "InteractiveSegmenterOptions", "", ["/R", "=this", "/S"]],
        ["mediapipe::tasks::vision::image_segmenter::proto::SegmenterOptions::OutputType", "InteractiveSegmenterOptions_OutputType", "", ["/R", "=this", "/S"]],
        [`mediapipe::tasks::${ language }::vision::interactive_segmenter::RegionOfInterest`, "InteractiveSegmenterRegionOfInterest", "", ["/R", "=this", "/S"]],
        [`mediapipe::tasks::${ language }::vision::interactive_segmenter::RegionOfInterest_Format`, "InteractiveSegmenterRegionOfInterest_Format", "", ["/R", "=this", "/S"]],
        [`mediapipe::tasks::${ language }::vision::object_detector::ObjectDetector`, "ObjectDetector", "", ["/R", "=this", "/S"]],
        [`mediapipe::tasks::${ language }::vision::object_detector::ObjectDetectorOptions`, "ObjectDetectorOptions", "", ["/R", "=this", "/S"]],
        [`mediapipe::tasks::${ language }::components::containers::detections::DetectionResult`, "ObjectDetectorResult", "", ["/R", "=this", "/S"]],
        [`mediapipe::tasks::${ language }::vision::pose_landmarker::PoseLandmarker`, "PoseLandmarker", "", ["/R", "=this", "/S"]],
        [`mediapipe::tasks::${ language }::vision::pose_landmarker::PoseLandmarkerOptions`, "PoseLandmarkerOptions", "", ["/R", "=this", "/S"]],
        [`mediapipe::tasks::${ language }::vision::pose_landmarker::PoseLandmarkerResult`, "PoseLandmarkerResult", "", ["/R", "=this", "/S"]],
        [`mediapipe::tasks::${ language }::vision::pose_landmarker::PoseLandmarksConnections`, "PoseLandmarksConnections", "", ["/R", "=this", "/S"]],
        [`mediapipe::tasks::${ language }::vision::holistic_landmarker::HolisticLandmarker`, "HolisticLandmarker", "", ["/R", "=this", "/S"]],
        [`mediapipe::tasks::${ language }::vision::holistic_landmarker::HolisticLandmarkerOptions`, "HolisticLandmarkerOptions", "", ["/R", "=this", "/S"]],
        [`mediapipe::tasks::${ language }::vision::holistic_landmarker::HolisticLandmarkerResult`, "HolisticLandmarkerResult", "", ["/R", "=this", "/S"]],
    ], "", ""],

    // expose a image_classifier property like in mediapipe python
    [`mediapipe.tasks.${ language }.vision.image_classifier.`, "", ["/Properties"], [
        [`mediapipe::tasks::${ language }::components::containers::classification_result::ClassificationResult`, "ImageClassifierResult", "", ["/R", "=this", "/S"]],
    ], "", ""],

    // expose a image_embedder property like in mediapipe python
    [`mediapipe.tasks.${ language }.vision.image_embedder.`, "", ["/Properties"], [
        [`mediapipe::tasks::${ language }::components::containers::embedding_result::EmbeddingResult`, "ImageEmbedderResult", "", ["/R", "=this", "/S"]],
    ], "", ""],

    // expose a object_detector property like in mediapipe python
    [`mediapipe.tasks.${ language }.vision.object_detector.`, "", ["/Properties"], [
        [`mediapipe::tasks::${ language }::components::containers::detections::DetectionResult`, "ObjectDetectorResult", "", ["/R", "=this", "/S"]],
    ], "", ""],

    // expose a image_segmenter property like in mediapipe python
    [`mediapipe.tasks.${ language }.vision.image_segmenter.`, "", ["/Properties"], [
        ["mediapipe::tasks::vision::image_segmenter::proto::SegmenterOptions::OutputType", "ImageSegmenterOptions_OutputType", "", ["/R", "=this", "/S"]],
        ["mediapipe::tasks::vision::image_segmenter::proto::SegmenterOptions::Activation", "ImageSegmenterOptions_Activation", "", ["/R", "=this", "/S"]],
    ], "", ""],

    // expose a interactive_segmenter property like in mediapipe python
    [`mediapipe.tasks.${ language }.vision.interactive_segmenter.`, "", ["/Properties"], [
        ["mediapipe::tasks::vision::image_segmenter::proto::SegmenterOptions::OutputType", "InteractiveSegmenterOptions_OutputType", "", ["/R", "=this", "/S"]],
        ["mediapipe::tasks::vision::image_segmenter::proto::SegmenterOptions::Activation", "InteractiveSegmenterOptions_Activation", "", ["/R", "=this", "/S"]],
    ], "", ""],
];
