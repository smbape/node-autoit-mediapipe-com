module.exports = [
    // expose a vision property like in mediapipe python
    ["mediapipe.tasks.autoit.vision.", "", ["/Properties"], [
        ["mediapipe::tasks::autoit::vision::face_detector::FaceDetector", "FaceDetector", "", ["/R", "=this"]],
        ["mediapipe::tasks::autoit::vision::face_detector::FaceDetectorOptions", "FaceDetectorOptions", "", ["/R", "=this"]],
        ["mediapipe::tasks::autoit::components::containers::detections::DetectionResult", "FaceDetectorResult", "", ["/R", "=this"]],
        ["mediapipe::tasks::autoit::vision::face_landmarker::FaceLandmarker", "FaceLandmarker", "", ["/R", "=this"]],
        ["mediapipe::tasks::autoit::vision::face_landmarker::FaceLandmarkerOptions", "FaceLandmarkerOptions", "", ["/R", "=this"]],
        ["mediapipe::tasks::autoit::vision::face_landmarker::FaceLandmarkerResult", "FaceLandmarkerResult", "", ["/R", "=this"]],
        ["mediapipe::tasks::autoit::vision::face_landmarker::FaceLandmarksConnections", "FaceLandmarksConnections", "", ["/R", "=this"]],
        ["mediapipe::tasks::autoit::vision::face_stylizer::FaceStylizer", "FaceStylizer", "", ["/R", "=this"]],
        ["mediapipe::tasks::autoit::vision::face_stylizer::FaceStylizerOptions", "FaceStylizerOptions", "", ["/R", "=this"]],
        ["mediapipe::tasks::autoit::vision::gesture_recognizer::GestureRecognizer", "GestureRecognizer", "", ["/R", "=this"]],
        ["mediapipe::tasks::autoit::vision::gesture_recognizer::GestureRecognizerOptions", "GestureRecognizerOptions", "", ["/R", "=this"]],
        ["mediapipe::tasks::autoit::vision::gesture_recognizer::GestureRecognizerResult", "GestureRecognizerResult", "", ["/R", "=this"]],
        ["mediapipe::tasks::autoit::vision::hand_landmarker::HandLandmarker", "HandLandmarker", "", ["/R", "=this"]],
        ["mediapipe::tasks::autoit::vision::hand_landmarker::HandLandmarkerOptions", "HandLandmarkerOptions", "", ["/R", "=this"]],
        ["mediapipe::tasks::autoit::vision::hand_landmarker::HandLandmarkerResult", "HandLandmarkerResult", "", ["/R", "=this"]],
        ["mediapipe::tasks::autoit::vision::image_classifier::ImageClassifier", "ImageClassifier", "", ["/R", "=this"]],
        ["mediapipe::tasks::autoit::vision::image_classifier::ImageClassifierOptions", "ImageClassifierOptions", "", ["/R", "=this"]],
        ["mediapipe::tasks::autoit::components::containers::classification_result::ClassificationResult", "ImageClassifierResult", "", ["/R", "=this"]],
        ["mediapipe::tasks::autoit::vision::image_embedder::ImageEmbedder", "ImageEmbedder", "", ["/R", "=this"]],
        ["mediapipe::tasks::autoit::vision::image_embedder::ImageEmbedderOptions", "ImageEmbedderOptions", "", ["/R", "=this"]],
        ["mediapipe::tasks::autoit::components::containers::embedding_result::EmbeddingResult", "ImageEmbedderResult", "", ["/R", "=this"]],
        ["mediapipe::tasks::autoit::vision::image_segmenter::ImageSegmenter", "ImageSegmenter", "", ["/R", "=this"]],
        ["mediapipe::tasks::autoit::vision::image_segmenter::ImageSegmenterOptions", "ImageSegmenterOptions", "", ["/R", "=this"]],
        ["mediapipe::tasks::vision::image_segmenter::proto::SegmenterOptions::OutputType", "ImageSegmenterOptions_OutputType", "", ["/R", "=this", "/S"]],
        ["mediapipe::tasks::vision::image_segmenter::proto::SegmenterOptions::Activation", "ImageSegmenterOptions_Activation", "", ["/R", "=this", "/S"]],
        ["mediapipe::tasks::autoit::vision::interactive_segmenter::InteractiveSegmenter", "InteractiveSegmenter", "", ["/R", "=this"]],
        ["mediapipe::tasks::autoit::vision::interactive_segmenter::InteractiveSegmenterOptions", "InteractiveSegmenterOptions", "", ["/R", "=this"]],
        ["mediapipe::tasks::vision::image_segmenter::proto::SegmenterOptions::OutputType", "InteractiveSegmenterOptions_OutputType", "", ["/R", "=this"]],
        ["mediapipe::tasks::autoit::vision::interactive_segmenter::RegionOfInterest", "InteractiveSegmenterRegionOfInterest", "", ["/R", "=this"]],
        ["mediapipe::tasks::autoit::vision::interactive_segmenter::RegionOfInterest_Format", "InteractiveSegmenterRegionOfInterest_Format", "", ["/R", "=this"]],
        ["mediapipe::tasks::autoit::vision::object_detector::ObjectDetector", "ObjectDetector", "", ["/R", "=this"]],
        ["mediapipe::tasks::autoit::vision::object_detector::ObjectDetectorOptions", "ObjectDetectorOptions", "", ["/R", "=this"]],
        ["mediapipe::tasks::autoit::vision::core::vision_task_running_mode::VisionTaskRunningMode", "RunningMode", "", ["/R", "=this"]],
    ], "", ""],

    // expose a image_classifier property like in mediapipe python
    ["mediapipe.tasks.autoit.vision.image_classifier.", "", ["/Properties"], [
        ["mediapipe::tasks::autoit::components::containers::classification_result::ClassificationResult", "ImageClassifierResult", "", ["/R", "=this"]],
    ], "", ""],

    // expose a image_embedder property like in mediapipe python
    ["mediapipe.tasks.autoit.vision.image_embedder.", "", ["/Properties"], [
        ["mediapipe::tasks::autoit::components::containers::embedding_result::EmbeddingResult", "ImageEmbedderResult", "", ["/R", "=this"]],
    ], "", ""],

    // expose a object_detector property like in mediapipe python
    ["mediapipe.tasks.autoit.vision.object_detector.", "", ["/Properties"], [
        ["mediapipe::tasks::autoit::components::containers::detections::DetectionResult", "ObjectDetectorResult", "", ["/R", "=this"]],
    ], "", ""],

    // expose a image_segmenter property like in mediapipe python
    ["mediapipe.tasks.autoit.vision.image_segmenter.", "", ["/Properties"], [
        ["mediapipe::tasks::vision::image_segmenter::proto::SegmenterOptions::OutputType", "ImageSegmenterOptions_OutputType", "", ["/R", "=this", "/S"]],
        ["mediapipe::tasks::vision::image_segmenter::proto::SegmenterOptions::Activation", "ImageSegmenterOptions_Activation", "", ["/R", "=this", "/S"]],
    ], "", ""],

    // expose a interactive_segmenter property like in mediapipe python
    ["mediapipe.tasks.autoit.vision.interactive_segmenter.", "", ["/Properties"], [
        ["mediapipe::tasks::vision::image_segmenter::proto::SegmenterOptions::OutputType", "InteractiveSegmenterOptions_OutputType", "", ["/R", "=this", "/S"]],
        ["mediapipe::tasks::vision::image_segmenter::proto::SegmenterOptions::Activation", "InteractiveSegmenterOptions_Activation", "", ["/R", "=this", "/S"]],
    ], "", ""],
];
