module.exports = [
    ["class mediapipe.ImageFrame", "", [], [
        ["int", "width", "", ["/R", "=Width()"]],
        ["int", "height", "", ["/R", "=Height()"]],
        ["int", "channels", "", ["/R", "=NumberOfChannels()"]],
        ["int", "byte_depth", "", ["/R", "=ByteDepth()"]],
        ["ImageFormat::Format", "image_format", "", ["/R", "=Format()"]],
        ["uchar*", "data", "", ["/R", "=PixelData()"]],
    ], "", ""],

    ["mediapipe.ImageFrame.create", "std::shared_ptr<ImageFrame>", ["/S", "/Call=mediapipe::autoit::CreateSharedImageFrame"], [
        ["mediapipe::ImageFormat::Format", "image_format", "", []],
        ["cv::Mat", "image", "", ["/C", "/Ref"]],
        ["bool", "copy", "true", []],
    ], "", ""],

    ["mediapipe.ImageFrame.create", "std::shared_ptr<ImageFrame>", ["/S", "/Call=mediapipe::autoit::CreateSharedImageFrame"], [
        ["cv::Mat", "image", "", ["/C", "/Ref"]],
        ["bool", "copy", "true", []],
    ], "", ""],

    ["mediapipe.ImageFrame.create", "std::shared_ptr<ImageFrame>", ["/S", "/Call=mediapipe::autoit::CreateSharedImageFrame"], [
        ["std::string", "file_name", "", ["/C", "/Ref"]],
    ], "", ""],

    ["mediapipe.ImageFrame.create_from_file", "std::shared_ptr<ImageFrame>", ["/S", "/Call=mediapipe::autoit::CreateSharedImageFrame"], [
        ["std::string", "file_name", "", ["/C", "/Ref"]],
    ], "", ""],

    ["mediapipe.ImageFrame.mat_view", "cv::Mat", ["/Call=mediapipe::formats::MatView", "/Expr=__self->get()"], [], "", ""],
    ["mediapipe.ImageFrame.IsContiguous", "bool", ["=is_contiguous"], [], "", ""],
    ["mediapipe.ImageFrame.IsEmpty", "bool", ["=is_empty"], [], "", ""],
    ["mediapipe.ImageFrame.IsAligned", "bool", ["=is_aligned"], [
        ["uint32_t", "alignment_boundary", "", []],
    ], "", ""],

    // expose an image_frame property like in mediapipe python
    ["mediapipe.autoit._framework_bindings.image_frame.", "", ["/Properties"], [
        ["mediapipe::ImageFrame", "ImageFrame", "", ["/R", "=this"]],
        ["mediapipe::ImageFormat::Format", "ImageFormat", "", ["/R", "=this"]],
    ], "", ""],
];
