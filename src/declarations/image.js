module.exports = [
    ["class mediapipe.Image", "", ["/Simple"], [
        ["int", "width", "", ["/R", "=width()"]],
        ["int", "height", "", ["/R", "=height()"]],
        ["int", "channels", "", ["/R", "=channels()"]],
        ["int", "step", "", ["/R", "=step()"]],
        ["ImageFormat::Format", "image_format", "", ["/R", "=image_format()"]],
        ["uchar*", "data", "", ["/R", "=GetImageFrameSharedPtr()->PixelData()"]],
    ], "", ""],

    ["mediapipe.Image.Image", "mediapipe.Image.Image", [], [], "", ""],

    ["mediapipe.Image.create", "std::shared_ptr<Image>", ["/S", "/Call=mediapipe::autoit::CreateImageFrame", "/Output=std::make_shared<Image>(std::shared_ptr<ImageFrame>($0.release()))"], [
        ["mediapipe::ImageFormat::Format", "image_format", "", []],
        ["cv::Mat", "image", "", ["/C", "/Ref"]],
        ["bool", "copy", "true", []],
    ], "", ""],

    ["mediapipe.Image.create", "std::shared_ptr<Image>", ["/S", "/Call=mediapipe::autoit::CreateImageFrame", "/Output=std::make_shared<Image>(std::shared_ptr<ImageFrame>($0.release()))"], [
        ["cv::Mat", "image", "", ["/C", "/Ref"]],
        ["bool", "copy", "true", []],
    ], "", ""],

    ["mediapipe.Image.mat_view", "cv::Mat", ["/Call=mediapipe::formats::MatView", "/Expr=__self->get()->GetImageFrameSharedPtr().get()"], [], "", ""],
    ["mediapipe.Image.UsesGpu", "bool", ["=uses_gpu"], [], "", ""],
    ["mediapipe.Image.IsContiguous", "bool", ["=is_contiguous", "/Prop=GetImageFrameSharedPtr()"], [], "", ""],
    ["mediapipe.Image.IsEmpty", "bool", ["=is_empty", "/Prop=GetImageFrameSharedPtr()"], [], "", ""],
    ["mediapipe.Image.IsAligned", "bool", ["=is_aligned", "/Prop=GetImageFrameSharedPtr()"], [
        ["uint32", "alignment_boundary", "", []],
    ], "", ""],

    // expose an Image property like in mediapipe python
    ["mediapipe.autoit._framework_bindings.image.", "", ["/Properties"], [
        ["mediapipe::Image", "Image", "", ["/R", "=this"]],
    ], "", ""],
];
