exports.SIMPLE_ARGTYPE_DEFAULTS = new Map([
    ["bool", "0"],
    ["size_t", "0"],
    ["SSIZE_T", "0"],
    ["ssize_t", "0"],
    ["int", "0"],
    ["float", "0.f"],
    ["double", "0"],
    ["c_string", "(char*)\"\""],

    ["int8", "0"],
    ["int8_t", "0"],
    ["int16", "0"],
    ["int16_t", "0"],
    ["int32", "0"],
    ["int32_t", "0"],
    ["int64", "0"],
    ["int64_t", "0"],

    ["uint8", "0"],
    ["uint8_t", "0"],
    ["uint16", "0"],
    ["uint16_t", "0"],
    ["uint32", "0"],
    ["uint32_t", "0"],
    ["uint64", "0"],
    ["uint64_t", "0"],
]);

exports.IDL_TYPES = new Map([
    ["bool", "VARIANT_BOOL"],
    ["float", "FLOAT"],
    ["int", "LONG"],
    ["uint", "ULONG"],
    ["unsigned", "ULONG"],
    ["long", "LONG"],
    ["long long", "LONGLONG"],
    ["ulong", "ULONG"],
    ["SSIZE_T", "LONGLONG"],
    ["size_t", "ULONGLONG"],
    ["String", "BSTR"],
    ["string", "BSTR"],
    ["uchar", "BYTE"],
    ["cv::String", "BSTR"],
    ["std::string", "BSTR"],

    ["int8", "CHAR"],
    ["int8_t", "CHAR"],
    ["int16", "SHORT"],
    ["int16_t", "SHORT"],
    ["int32", "LONG"],
    ["int32_t", "LONG"],
    ["int64", "LONGLONG"],
    ["int64_t", "LONGLONG"],

    ["uint8", "BYTE"],
    ["uint8_t", "BYTE"],
    ["uint16", "USHORT"],
    ["uint16_t", "USHORT"],
    ["uint32", "ULONG"],
    ["uint32_t", "ULONG"],
    ["uint64", "ULONGLONG"],
    ["uint64_t", "ULONGLONG"],

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
]);

exports.ALIASES = new Map([
    ["cv::InputArray", "InputArray"],
    ["cv::InputArrayOfArrays", "InputArrayOfArrays"],
    ["cv::InputOutputArray", "InputOutputArray"],
    ["cv::InputOutputArrayOfArrays", "InputOutputArrayOfArrays"],
    ["cv::OutputArray", "OutputArray"],
    ["cv::OutputArrayOfArrays", "OutputArrayOfArrays"],

    ["DrawingColor", "std::tuple<int, int, int>"],

    ["autoit::PacketsCallback", "mediapipe::autoit::PacketsRawCallback"],
    ["mediapipe::autoit::PacketsCallback", "mediapipe::autoit::PacketsRawCallback"],

    ["mediapipe::autoit::PacketCallback", "mediapipe::autoit::PacketRawCallback"],

    ["TextEmbedderResult", "mediapipe::tasks::components::containers::EmbeddingResult"],
    ["ImageEmbedderResult", "mediapipe::tasks::components::containers::EmbeddingResult"],

    ["AudioClassifierResultCallback", "mediapipe::tasks::audio::audio_classifier::AudioClassifierResultRawCallback"],

    ["ImageClassifierResultCallback", "mediapipe::tasks::vision::image_classifier::ImageClassifierResultRawCallback"],
    ["ImageEmbedderResultCallback", "mediapipe::tasks::vision::image_embedder::ImageEmbedderResultRawCallback"],

    ["AudioClassifierResult", "mediapipe::tasks::components::containers::ClassificationResult"],
    ["TextClassifierResult", "mediapipe::tasks::components::containers::ClassificationResult"],
    ["ImageClassifierResult", "mediapipe::tasks::components::containers::ClassificationResult"],

    ["ImageSegmenterResultCallback", "mediapipe::tasks::vision::image_segmenter::ImageSegmenterResultRawCallback"],

    ["InteractiveSegmenterResult", "mediapipe::tasks::vision::image_segmenter::ImageSegmenterResult"],

    ["ObjectDetectorResult", "mediapipe::tasks::components::containers::DetectionResult"],
    ["ObjectDetectorResultCallback", "mediapipe::tasks::vision::object_detector::ObjectDetectorResultRawCallback"],

    ["FaceDetectorResult", "mediapipe::tasks::components::containers::DetectionResult"],
    ["FaceDetectorResultCallback", "mediapipe::tasks::vision::face_detector::FaceDetectorResultRawCallback"],

    ["FaceLandmarkerResultCallback", "mediapipe::tasks::vision::face_landmarker::FaceLandmarkerResultRawCallback"],
    ["GestureRecognizerResultCallback", "mediapipe::tasks::vision::gesture_recognizer::GestureRecognizerResultRawCallback"],
    ["HandLandmarkerResultCallback", "mediapipe::tasks::vision::hand_landmarker::HandLandmarkerResultRawCallback"],
    ["HolisticLandmarkerResultCallback", "mediapipe::tasks::vision::holistic_landmarker::HolisticLandmarkerResultRawCallback"],
    ["PoseLandmarkerResultCallback", "mediapipe::tasks::vision::pose_landmarker::PoseLandmarkerResultRawCallback"],
]);

exports.CLASS_PTR = new Set([]);

exports.PTR = new Set([
    "void*",
    "uchar*",
    "HWND",
    "mediapipe::autoit::PacketRawCallback",
    "mediapipe::autoit::PacketsRawCallback",

    "mediapipe::tasks::audio::audio_classifier::AudioClassifierResultRawCallback",
    "mediapipe::tasks::vision::face_detector::FaceDetectorResultRawCallback",
    "mediapipe::tasks::vision::face_landmarker::FaceLandmarkerResultRawCallback",
    "mediapipe::tasks::vision::gesture_recognizer::GestureRecognizerResultRawCallback",
    "mediapipe::tasks::vision::hand_landmarker::HandLandmarkerResultRawCallback",
    "mediapipe::tasks::vision::holistic_landmarker::HolisticLandmarkerResultRawCallback",
    "mediapipe::tasks::vision::image_classifier::ImageClassifierResultRawCallback",
    "mediapipe::tasks::vision::image_embedder::ImageEmbedderResultRawCallback",
    "mediapipe::tasks::vision::image_segmenter::ImageSegmenterResultRawCallback",
    "mediapipe::tasks::vision::object_detector::ObjectDetectorResultRawCallback",
    "mediapipe::tasks::vision::pose_landmarker::PoseLandmarkerResultRawCallback",
]);

exports.CUSTOM_CLASSES = [];

exports.TEMPLATED_TYPES = new Set([
    "cv::GArray",
    "cv::GOpaque",
]);

exports.ARRAY_CLASSES = new Set([
    // Array types
    // Unique
    "cv::cuda::GpuMat",
    "cv::Mat",
    "cv::UMat",
    "cv::Scalar", // Array of 4 numbers
]);

const { getTypeDef } = require("./alias");

const types = [
    // Unique types
    "cv::Mat",
    "cv::UMat",
    // "bool",
    "cv::RotatedRect",
    "cv::Range",
    "cv::Moments",

    // Ambiguous because number
    "uchar",
    "schar",
    "char",
    "ushort",
    "short",
    "int",
    "float",
    "double",
    // "float16_t",

    // Ambiguous because array of numbers
    "cv::Point3i",
    "cv::Point3f",
    "cv::Point3d",

    // "cv::Point2l", // DataType<int64>::depth is not defined
    "cv::Point2f",
    "cv::Point2d",
    "cv::Point",

    "cv::Rect2f",
    "cv::Rect2d",
    "cv::Rect",

    // "cv::Size2l", // DataType<int64>::depth is not defined
    "cv::Size2f",
    "cv::Size2d",
    "cv::Size",
];

// Ambiguous because array of numbers
for (const _Tp of ["b", "s", "w"]) {
    for (const cn of [2, 3, 4]) { // eslint-disable-line no-magic-numbers
        types.push(`cv::Vec${ cn }${ _Tp }`);
    }
}

for (const cn of [2, 3, 4, 6, 8]) { // eslint-disable-line no-magic-numbers
    types.push(`cv::Vec${ cn }i`);
}

for (const _Tp of ["f", "d"]) {
    for (const cn of [2, 3, 4, 6]) { // eslint-disable-line no-magic-numbers
        types.push(`cv::Vec${ cn }${ _Tp }`);
    }
}

const length = types.length;

// Mat and UMat does not have vector<vector>
for (let i = 2; i < length; i++) {
    types.push(`std::vector<${ types[i] }>`);
}

for (let i = 0; i < types.length; i++) {
    types[i] = `std::vector<${ types[i] }>`;
}

exports.ARRAYS_CLASSES = new Set(types.map(type => getTypeDef(type, {
    remove_namespaces: new Set([
        "cv",
        "std",
    ])
})));

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
