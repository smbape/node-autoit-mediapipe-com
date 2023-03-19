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

    ["mediapipe::autoit::PacketCallback", "mediapipe::autoit::PacketRawCallback"],
]);

exports.CLASS_PTR = new Set([
]);

exports.PTR = new Set([
    "void*",
    "uchar*",
    "HWND",
    "mediapipe::autoit::PacketRawCallback",
    "mediapipe::autoit::PacketsRawCallback",
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
