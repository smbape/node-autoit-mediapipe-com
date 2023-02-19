module.exports = [
    ["class mediapipe.ImageFrame", "", [], [
        ["int", "width", "", ["/R", "=Width()"]],
        ["int", "height", "", ["/R", "=Height()"]],
        ["int", "channels", "", ["/R", "=NumberOfChannels()"]],
        ["int", "byte_depth", "", ["/R", "=ByteDepth()"]],
        ["ImageFormat::Format", "image_format", "", ["/R", "=Format()"]],
        ["uchar*", "data", "", ["/R", "=PixelData()"]],
    ], "", ""],

    ["mediapipe.ImageFrame.create", "std::shared_ptr<ImageFrame>", ["/S", "/Call=mediapipe::autoit::CreateImageFrame", "/Output=std::shared_ptr<ImageFrame>($0.release())"], [
        ["mediapipe::ImageFormat::Format", "image_format", "", []],
        ["cv::Mat", "image", "", ["/C", "/Ref"]],
        ["bool", "copy", "true", []],
    ], "", ""],

    ["mediapipe.ImageFrame.create", "std::shared_ptr<ImageFrame>", ["/S", "/Call=mediapipe::autoit::CreateImageFrame", "/Output=std::shared_ptr<ImageFrame>($0.release())"], [
        ["cv::Mat", "image", "", ["/C", "/Ref"]],
        ["bool", "copy", "true", []],
    ], "", ""],

    ["mediapipe.ImageFrame.create", "std::shared_ptr<ImageFrame>", ["/S", "/Call=mediapipe::autoit::CreateImageFrame", "/Output=std::shared_ptr<ImageFrame>($0.release())"], [
        ["std::string", "file_name", "", ["/C", "/Ref"]],
    ], "", ""],

    ["mediapipe.ImageFrame.create_from_file", "std::shared_ptr<ImageFrame>", ["/S", "/Call=mediapipe::autoit::CreateImageFrame", "/Output=std::shared_ptr<ImageFrame>($0.release())"], [
        ["std::string", "file_name", "", ["/C", "/Ref"]],
    ], "", ""],

    ["mediapipe.ImageFrame.mat_view", "cv::Mat", ["/Call=mediapipe::formats::MatView", "/Expr=__self->get()"], [], "", ""],
    ["mediapipe.ImageFrame.IsContiguous", "bool", ["=is_contiguous"], [], "", ""],
    ["mediapipe.ImageFrame.IsEmpty", "bool", ["=is_empty"], [], "", ""],
    ["mediapipe.ImageFrame.IsAligned", "bool", ["=is_aligned"], [
        ["uint32", "alignment_boundary", "", []],
    ], "", ""],

    // expose an ImageFrame property like in mediapipe python
    ["mediapipe.autoit._framework_bindings.image_frame.", "", ["/Properties"], [
        ["mediapipe::ImageFrame", "ImageFrame", "", ["/R", "=this"]],
    ], "", ""],
];
