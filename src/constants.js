exports.SIMPLE_ARGTYPE_DEFAULTS = new Map([
    ["bool", "0"],
    ["size_t", "0"],
    ["SSIZE_T", "0"],
    ["int", "0"],
    ["int64", "0"],
    ["int64_t", "0"],
    ["float", "0.f"],
    ["double", "0"],
    ["c_string", "(char*)\"\""],
]);

exports.IDL_TYPES = new Map([
    ["bool", "VARIANT_BOOL"],
    ["float", "FLOAT"],
    ["int64", "LONGLONG"],
    ["int64_t", "LONGLONG"],
    ["int", "LONG"],
    ["uint", "ULONG"],
    ["uint32", "ULONG"],
    ["long", "LONG"],
    ["ulong", "ULONG"],
    ["SSIZE_T", "LONGLONG"],
    ["size_t", "ULONGLONG"],
    ["uint64", "ULONGLONG"],
    ["String", "BSTR"],
    ["string", "BSTR"],
    ["uchar", "BYTE"],
    ["cv::String", "BSTR"],
    ["std::string", "BSTR"],

    ["InputArray", "VARIANT"],
    ["InputArrayOfArrays", "VARIANT"],
    ["InputOutputArray", "VARIANT"],
    ["InputOutputArrayOfArrays", "VARIANT"],
    ["OutputArray", "VARIANT"],
    ["OutputArrayOfArrays", "VARIANT"],

    ["Point", "VARIANT"],
    ["cv::Point", "VARIANT"],
    ["Point2d", "VARIANT"],
    ["cv::Point2d", "VARIANT"],
    ["Rect", "VARIANT"],
    ["cv::Rect", "VARIANT"],
    ["Scalar", "VARIANT"],
    ["cv::Scalar", "VARIANT"],
    ["Size", "VARIANT"],
    ["cv::Size", "VARIANT"],
]);

exports.CPP_TYPES = new Map([
    ["InputArray", "cv::_InputArray"],
    ["InputArrayOfArrays", "cv::_InputArray"],
    ["InputOutputArray", "cv::_InputOutputArray"],
    ["InputOutputArrayOfArrays", "cv::_InputOutputArray"],
    ["OutputArray", "cv::_OutputArray"],
    ["OutputArrayOfArrays", "cv::_OutputArray"],

    ["Point", "cv::Point"],
    ["Point2d", "cv::Point2d"],
    ["Rect", "cv::Rect"],
    ["Scalar", "cv::Scalar"],
    ["Size", "cv::Size"],

    ["string", "std::string"],

    ["google_protobuf_Message", "google::protobuf::Message"],
    ["ImageFormat_Format", "ImageFormat::Format"],
]);

exports.ALIASES = new Map([
    ["mediapipe::solutions::face_detection::SolutionBase", "mediapipe::autoit::solution_base::SolutionBase"],
    ["DrawingColor", "tuple_int_and_int_and_int"],

    ["autoit_PacketsCallback", "mediapipe::autoit::PacketsRawCallback"],
    ["mediapipe::autoit::PacketsCallback", "mediapipe::autoit::PacketsRawCallback"],

    ["autoit_core_base_options_BaseOptions", "mediapipe::tasks::autoit::core::base_options::BaseOptions"],
    ["base_options_BaseOptions", "mediapipe::tasks::autoit::core::base_options::BaseOptions"],
    ["tasks_core_proto_BaseOptions", "mediapipe::tasks::core::proto::BaseOptions"],

    ["tasks_components_processors_proto_ClassifierOptions", "mediapipe::tasks::components::processors::proto::ClassifierOptions"],
    ["mediapipe::autoit::PacketCallback", "mediapipe::autoit::PacketRawCallback"],

    ["components_containers_audio_data_AudioData", "mediapipe::tasks::autoit::components::containers::AudioData"],
    ["bounding_box_BoundingBox", "mediapipe::tasks::autoit::components::containers::bounding_box::BoundingBox"],
    ["category_Category", "mediapipe::tasks::autoit::components::containers::category::Category"],
    ["detections_Detection", "mediapipe::tasks::autoit::components::containers::detections::Detection"],
    ["detections_DetectionResult", "mediapipe::tasks::autoit::components::containers::detections::DetectionResult"],
    ["containers_embedding_result_Embedding", "mediapipe::tasks::autoit::components::containers::embedding_result::Embedding"],
    ["landmark_Landmark", "mediapipe::tasks::autoit::components::containers::landmark::Landmark"],
    ["landmark_NormalizedLandmark", "mediapipe::tasks::autoit::components::containers::landmark::NormalizedLandmark"],
    ["rect_NormalizedRect", "mediapipe::tasks::autoit::components::containers::rect::NormalizedRect"],
    ["components_containers_rect_Rect", "mediapipe::tasks::autoit::components::containers::rect::Rect"],
    ["rect_Rect", "mediapipe::tasks::autoit::components::containers::rect::Rect"],

    ["components_containers_embedding_result_Embedding", "mediapipe::tasks::components::containers::embedding_result::Embedding"],
    ["tasks_components_containers_proto_ClassificationResult", "mediapipe::tasks::components::containers::proto::ClassificationResult"],
    ["tasks_components_containers_proto_Classifications", "mediapipe::tasks::components::containers::proto::Classifications"],
    ["tasks_components_containers_proto_Embedding", "mediapipe::tasks::components::containers::proto::Embedding"],
    ["tasks_components_containers_proto_EmbeddingResult", "mediapipe::tasks::components::containers::proto::EmbeddingResult"],

    ["AudioEmbedderResult", "mediapipe::tasks::components::containers::embedding_result::EmbeddingResult"],
    ["TextEmbedderResult", "mediapipe::tasks::components::containers::embedding_result::EmbeddingResult"],

    ["tasks_containers_proto_LandmarksDetectionResult", "mediapipe::tasks::containers::proto::LandmarksDetectionResult"],

    ["AudioClassifierResultCallback", "mediapipe::tasks::autoit::audio::audio_classifier::AudioClassifierResultRawCallback"],
    ["AudioEmbedderResultCallback", "mediapipe::tasks::autoit::audio::audio_embedder::AudioEmbedderResultRawCallback"],
    ["audio_task_running_mode_AudioTaskRunningMode", "mediapipe::tasks::autoit::audio::core::audio_task_running_mode::AudioTaskRunningMode"],
    ["core_audio_task_running_mode_AudioTaskRunningMode", "mediapipe::tasks::autoit::audio::core::audio_task_running_mode::AudioTaskRunningMode"],
    ["core_base_audio_task_api_BaseAudioTaskApi", "mediapipe::tasks::autoit::audio::core::base_audio_task_api::BaseAudioTaskApi"],

    ["tasks_audio_audio_classifier_proto_AudioClassifierGraphOptions", "mediapipe::tasks::audio::audio_classifier::proto::AudioClassifierGraphOptions"],
    ["tasks_audio_audio_embedder_proto_AudioEmbedderGraphOptions", "mediapipe::tasks::audio::audio_embedder::proto::AudioEmbedderGraphOptions"],

    ["core_base_text_task_api_BaseTextTaskApi", "mediapipe::tasks::autoit::text::core::base_text_task_api::BaseTextTaskApi"],
    ["tasks_text_text_classifier_proto_TextClassifierGraphOptions", "mediapipe::tasks::text::text_classifier::proto::TextClassifierGraphOptions"],
    ["tasks_text_text_embedder_proto_TextEmbedderGraphOptions", "mediapipe::tasks::text::text_embedder::proto::TextEmbedderGraphOptions"],

    ["core_base_vision_task_api_BaseVisionTaskApi", "mediapipe::tasks::autoit::vision::core::base_vision_task_api::BaseVisionTaskApi"],
    ["core_vision_task_running_mode_VisionTaskRunningMode", "mediapipe::tasks::autoit::vision::core::vision_task_running_mode::VisionTaskRunningMode"],
    ["vision_task_running_mode_VisionTaskRunningMode", "mediapipe::tasks::autoit::vision::core::vision_task_running_mode::VisionTaskRunningMode"],
    ["ImageClassifierResultCallback", "mediapipe::tasks::autoit::vision::image_classifier::ImageClassifierResultRawCallback"],
    ["ImageEmbedderResultCallback", "mediapipe::tasks::autoit::vision::image_embedder::ImageEmbedderResultRawCallback"],

    ["AudioClassifierResult", "mediapipe::tasks::components::containers::classification_result::ClassificationResult"],
    ["TextClassifierResult", "mediapipe::tasks::components::containers::classification_result::ClassificationResult"],
    ["ImageClassifierResult", "mediapipe::tasks::components::containers::classification_result::ClassificationResult"],

    ["tasks_vision_image_classifier_proto_ImageClassifierGraphOptions", "mediapipe::tasks::vision::image_classifier::proto::ImageClassifierGraphOptions"],
    ["tasks_vision_image_embedder_proto_ImageEmbedderGraphOptions", "mediapipe::tasks::vision::image_embedder::proto::ImageEmbedderGraphOptions"],

    ["components_containers_rect_NormalizedRect", "mediapipe::tasks::autoit::components::containers::rect::NormalizedRect"],
    ["image_processing_options_ImageProcessingOptions", "mediapipe::tasks::autoit::vision::core::image_processing_options::ImageProcessingOptions"],
    ["core_image_processing_options_ImageProcessingOptions", "mediapipe::tasks::autoit::vision::core::image_processing_options::ImageProcessingOptions"],

    ["tasks_vision_image_segmenter_proto_SegmenterOptions_OutputType", "mediapipe::tasks::vision::image_segmenter::proto::SegmenterOptions::OutputType"],
    ["tasks_vision_image_segmenter_proto_SegmenterOptions_Activation", "mediapipe::tasks::vision::image_segmenter::proto::SegmenterOptions::Activation"],
    ["ImageSegmenterResultCallback", "mediapipe::tasks::autoit::vision::image_segmenter::ImageSegmenterResultRawCallback"],

    ["ObjectDetectorResult", "mediapipe::tasks::autoit::components::containers::detections::DetectionResult"],
    ["ObjectDetectorResultCallback", "mediapipe::tasks::autoit::vision::object_detector::ObjectDetectorResultRawCallback"],
]);

exports.CLASS_PTR = new Set([
]);

exports.PTR = new Set([
    "void*",
    "uchar*",
    "HWND",
    "mediapipe::autoit::PacketRawCallback",
    "mediapipe::autoit::PacketsRawCallback",

    "mediapipe::tasks::autoit::audio::audio_classifier::AudioClassifierResultRawCallback",
    "mediapipe::tasks::autoit::audio::audio_embedder::AudioEmbedderResultRawCallback",

    "mediapipe::tasks::autoit::vision::image_classifier::ImageClassifierResultRawCallback",
    "mediapipe::tasks::autoit::vision::image_embedder::ImageEmbedderResultRawCallback",

    "mediapipe::tasks::autoit::vision::image_segmenter::ImageSegmenterResultRawCallback",
    "mediapipe::tasks::autoit::vision::object_detector::ObjectDetectorResultRawCallback",
]);

exports.CUSTOM_CLASSES = [
];

exports.ARRAY_CLASSES = new Set([
    // Array types
    // Unique
    "cv::GpuMat",
    "cv::Mat",
    "cv::UMat",
    "cv::Scalar", // Array of 4 numbers
]);

exports.ARRAYS_CLASSES = new Set([
    // Unique types
    "VectorOfMat",
    "VectorOfRotatedRect",
    "VectorOfUMat",

    // Ambiguous because Array of numbers
    "VectorOfChar", // Array of n numbers
    "VectorOfDouble", // Array of n numbers
    "VectorOfFloat", // Array of n numbers
    "VectorOfInt", // Array of n numbers
    "VectorOfUchar", // Array of n numbers

    // Ambiguous because Array of Array numbers
    "VectorOfCv_Point", // Array of Array of 2 numbers
    "VectorOfPoint2f", // Array of Array of 2 numbers
    "VectorOfRect", // Array of Array of 4 numbers
    "VectorOfSize", // Array of Array of 2 numbers
    "VectorOfVec6f", // Array of Array of 6 numbers
    "VectorOfVectorOfChar", // Array of Array of n numbers
    "VectorOfVectorOfInt", // Array of Array of n numbers

    // Ambiguous because Array of Array of Array of 2 numbers
    "VectorOfVectorOfCv_Point", // Array of Array of Array of 2 numbers
    "VectorOfVectorOfPoint2f", // Array of Array of Array of 2 numbers
]);

for (const _Tp of ["b", "s", "w"]) {
    for (const cn of [2, 3, 4]) { // eslint-disable-line no-magic-numbers
        const type = `Vec${ cn }${ _Tp }`;
        exports.IDL_TYPES.set(type, "VARIANT");
        exports.IDL_TYPES.set(`cv::${ type }`, "VARIANT");
        exports.CPP_TYPES.set(type, `cv::${ type }`);
    }
}

for (const cn of [2, 3, 4, 6, 8]) { // eslint-disable-line no-magic-numbers
    const type = `Vec${ cn }i`;
    exports.IDL_TYPES.set(type, "VARIANT");
    exports.IDL_TYPES.set(`cv::${ type }`, "VARIANT");
    exports.CPP_TYPES.set(type, `cv::${ type }`);
}

for (const _Tp of ["f", "d"]) {
    for (const cn of [2, 3, 4, 6]) { // eslint-disable-line no-magic-numbers
        const type = `Vec${ cn }${ _Tp }`;
        exports.IDL_TYPES.set(type, "VARIANT");
        exports.IDL_TYPES.set(`cv::${ type }`, "VARIANT");
        exports.CPP_TYPES.set(type, `cv::${ type }`);
    }
}

exports.IGNORED_CLASSES = new Set([]);
