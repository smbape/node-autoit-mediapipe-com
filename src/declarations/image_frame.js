// from mediapipe\examples\desktop\autoit-mediapipe-com\build_x64\mediapipe-prefix\src\mediapipe\mediapipe\framework\formats\image_format.proto

module.exports = [
    ["enum mediapipe.ImageFormat.Format", "", [], [
        // The format is unknown.  It is not valid for an ImageFrame to be
        // initialized with this value.
        ["const mediapipe.ImageFormat.UNKNOWN", "0", []],

        // sRGB, interleaved: one byte for R, then one byte for G, then one
        // byte for B for each pixel.
        ["const mediapipe.ImageFormat.SRGB", "1", []],

        // sRGBA, interleaved: one byte for R, one byte for G, one byte for B,
        // one byte for alpha or unused.
        ["const mediapipe.ImageFormat.SRGBA", "2", []],

        // Grayscale, one byte per pixel.
        ["const mediapipe.ImageFormat.GRAY8", "3", []],

        // Grayscale, one uint16 per pixel.
        ["const mediapipe.ImageFormat.GRAY16", "4", []],

        // YCbCr420P (1 bpp for Y, 0.25 bpp for U and V).
        // NOTE: NOT a valid ImageFrame format, but intended for
        // ScaleImageCalculatorOptions, VideoHeader, etc. to indicate that
        // YUVImage is used in place of ImageFrame.
        ["const mediapipe.ImageFormat.YCBCR420P", "5", []],

        // Similar to YCbCr420P, but the data is represented as the lower 10bits of
        // a uint16. Like YCbCr420P, this is NOT a valid ImageFrame, and the data is
        // carried within a YUVImage.
        ["const mediapipe.ImageFormat.YCBCR420P10", "6", []],

        // sRGB, interleaved, each component is a uint16.
        ["const mediapipe.ImageFormat.SRGB48", "7", []],

        // sRGBA, interleaved, each component is a uint16.
        ["const mediapipe.ImageFormat.SRGBA64", "8", []],

        // One float per pixel.
        ["const mediapipe.ImageFormat.VEC32F1", "9", []],

        // Two floats per pixel.
        ["const mediapipe.ImageFormat.VEC32F2", "12", []],

        // LAB, interleaved: one byte for L, then one byte for a, then one
        // byte for b for each pixel.
        ["const mediapipe.ImageFormat.LAB8", "10", []],

        // sBGRA, interleaved: one byte for B, one byte for G, one byte for R,
        // one byte for alpha or unused. This is the N32 format for Skia.
        ["const mediapipe.ImageFormat.SBGRA", "11", []],
    ], "", ""],

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

    ["mediapipe.ImageFrame.mat_view", "cv::Mat", ["/Call=mediapipe::formats::MatView", "/Expr=this->__self->get()"], [], "", ""],
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
