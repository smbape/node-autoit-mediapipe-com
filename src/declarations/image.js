module.exports = ({self_get, make_shared, language, cname}) => [
    ["class mediapipe.Image", "", ["/Simple"], [
        ["int", "width", "", ["/R", "=width()"]],
        ["int", "height", "", ["/R", "=height()"]],
        ["int", "channels", "", ["/R", "=channels()"]],
        ["int", "step", "", ["/R", "=step()"]],
        ["ImageFormat::Format", "image_format", "", ["/R", "=image_format()"]],
        ["uchar*", "data", "", ["/R", "=GetImageFrameSharedPtr()->PixelData()", "/C"]],
    ], "", ""],

    ["mediapipe.Image.Image", "mediapipe.Image.Image", [], [], "", ""],

    [`mediapipe.Image.${ cname }`, "std::shared_ptr<Image>", ["/S", `/Call=mediapipe::${ language }::CreateSharedImage`], [
        ["mediapipe::ImageFormat::Format", "image_format", "", []],
        ["cv::Mat", "data", "", ["/C", "/Ref"]],
        ["bool", "copy", "true", []],
    ], "", ""],

    [`mediapipe.Image.${ cname }`, "std::shared_ptr<Image>", ["/S", `/Call=mediapipe::${ language }::CreateSharedImage`], [
        ["cv::Mat", "data", "", ["/C", "/Ref"]],
        ["bool", "copy", "true", []],
    ], "", ""],

    [`mediapipe.Image.${ cname }`, "std::shared_ptr<Image>", ["/S", `/Call=mediapipe::${ language }::CreateSharedImage`], [
        ["std::string", "file_name", "", ["/C", "/Ref"]],
    ], "", ""],

    ["mediapipe.Image.create_from_file", "std::shared_ptr<Image>", ["/S", `/Call=mediapipe::${ language }::CreateSharedImage`], [
        ["std::string", "file_name", "", ["/C", "/Ref"]],
    ], "", ""],

    ["mediapipe.Image.mat_view", "cv::Mat", ["/Call=mediapipe::formats::MatView", `/Expr=${ self_get("GetImageFrameSharedPtr") }().get()`], [], "", ""],
    ["mediapipe.Image.UsesGpu", "bool", ["=uses_gpu"], [], "", ""],
    ["mediapipe.Image.IsContiguous", "bool", ["=is_contiguous", "/Prop=GetImageFrameSharedPtr()"], [], "", ""],
    ["mediapipe.Image.IsEmpty", "bool", ["=is_empty", "/Prop=GetImageFrameSharedPtr()"], [], "", ""],
    ["mediapipe.Image.IsAligned", "bool", ["=is_aligned", "/Prop=GetImageFrameSharedPtr()"], [
        ["uint32_t", "alignment_boundary", "", []],
    ], "", ""],

    // expose an Image property like in mediapipe python
    [`mediapipe.${ language }._framework_bindings.image.`, "", ["/Properties"], [
        ["mediapipe::Image", "Image", "", ["/R", "=this", "/S"]],
    ], "", ""],
];
