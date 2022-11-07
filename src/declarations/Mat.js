const declarations = [
    // cv::Mat Class Reference

    ["class cv.Mat", "", ["/Simple"], [
        ["int", "flags", "", ["/RW"]],
        ["int", "dims", "", ["/RW"]],
        ["int", "rows", "", ["/RW"]],
        ["int", "cols", "", ["/RW"]],
        ["uchar*", "data", "", ["/RW"]],
        ["size_t", "step", "", ["/RW"]],
        ["int", "width", "", ["/RW", "=cols"]],
        ["int", "height", "", ["/RW", "=rows"]]
    ], "", ""],

    ["cv.Mat.Mat", "", [], [], "", ""],

    ["cv.Mat.Mat", "", [], [
        ["int", "rows", "", []],
        ["int", "cols", "", []],
        ["int", "type", "", []]
    ], "", ""],

    ["cv.Mat.Mat", "", [], [
        ["tuple_int_and_int", "size", "", ["/Expr=std::get<0>(size), std::get<1>(size)", "/Cast=Size"]],
        ["int", "type", "", []]
    ], "", ""],

    ["cv.Mat.Mat", "", [], [
        ["int", "rows", "", []],
        ["int", "cols", "", []],
        ["int", "type", "", []],
        ["tuple_double_and_double_and_double_and_double", "s", "", ["/Expr=std::get<0>(s), std::get<1>(s), std::get<2>(s), std::get<3>(s)", "/Cast=Scalar"]],
    ], "", ""],

    ["cv.Mat.Mat", "", [], [
        ["tuple_int_and_int", "size", "", ["/Expr=std::get<0>(size), std::get<1>(size)", "/Cast=Size"]],
        ["int", "type", "", []],
        ["tuple_double_and_double_and_double_and_double", "s", "", ["/Expr=std::get<0>(s), std::get<1>(s), std::get<2>(s), std::get<3>(s)", "/Cast=Scalar"]],
    ], "", ""],

    ["cv.Mat.Mat", "", [], [
        ["int", "rows", "", []],
        ["int", "cols", "", []],
        ["int", "type", "", []],
        ["void*", "data", "", []],
        ["size_t", "step", "cv::Mat::AUTO_STEP", []]
    ], "", ""],

    ["cv.Mat.Mat", "", [], [
        ["Mat", "m", "", []]
    ], "", ""],

    ["cv.Mat.Mat", "", [], [
        ["Mat", "src", "", []],
        ["tuple_int_and_int_and_int_and_int", "roi", "", ["/Expr=std::get<0>(roi), std::get<1>(roi), std::get<2>(roi), std::get<3>(roi)", "/Cast=Rect"]]
    ], "", ""],

    ["cv.Mat.row", "cv::Mat", [], [
        ["int", "y", "", []],
    ], "", ""],
    ["cv.Mat.col", "cv::Mat", [], [
        ["int", "x", "", []],
    ], "", ""],
    ["cv.Mat.rowRange", "cv::Mat", [], [
        ["int", "startrow", "", []],
        ["int", "endrow", "", []],
    ], "", ""],
    ["cv.Mat.rowRange", "cv::Mat", [], [
        ["Range", "r", "", []],
    ], "", ""],
    ["cv.Mat.colRange", "cv::Mat", [], [
        ["int", "startcol", "", []],
        ["int", "endcol", "", []],
    ], "", ""],
    ["cv.Mat.colRange", "cv::Mat", [], [
        ["Range", "r", "", []],
    ], "", ""],

    ["cv.Mat.isContinuous", "bool", [], [], "", ""],
    ["cv.Mat.isSubmatrix", "bool", [], [], "", ""],
    ["cv.Mat.elemSize", "size_t", [], [], "", ""],
    ["cv.Mat.elemSize1", "size_t", [], [], "", ""],

    ["cv.Mat.type", "int", [], [], "", ""],
    ["cv.Mat.depth", "int", [], [], "", ""],
    ["cv.Mat.channels", "int", [], [], "", ""],

    ["cv.Mat.step1", "size_t", [], [
        ["int", "i", "0", []]
    ], "", ""],

    ["cv.Mat.empty", "bool", [], [], "", ""],
    ["cv.Mat.total", "size_t", [], [], "", ""],
    ["cv.Mat.total", "size_t", [], [
        ["int", "startDim", "", []],
        ["int", "endDim", "INT_MAX", []],
    ], "", ""],

    ["cv.Mat.checkVector", "int", [], [
        ["int", "elemChannels", "", []],
        ["int", "depth", "-1", []],
        ["int", "requireContinuous", "true", []],
    ], "", ""],

    ["cv.Mat.ptr", "uchar*", [], [
        ["int", "y", "0", []]
    ], "", ""],
    ["cv.Mat.ptr", "uchar*", [], [
        ["int", "i0", "", []],
        ["int", "i1", "", []],
    ], "", ""],
    ["cv.Mat.ptr", "uchar*", [], [
        ["int", "i0", "", []],
        ["int", "i1", "", []],
        ["int", "i2", "", []],
    ], "", ""],

    ["cv.Mat.size", "tuple_int_and_int", ["/Output=std::tuple<int, int>(__self->get()->cols, __self->get()->rows)"], [], "", ""],
    ["cv.Mat.pop_back", "void", [], [
        ["size_t", "value", "", []]
    ], "", ""],
    ["cv.Mat.push_back", "void", [], [
        ["Mat", "value", "", []]
    ], "", ""],
    ["cv.Mat.clone", "Mat", [], [], "", ""],
    ["cv.Mat.clone", "Mat", ["=copy"], [], "", ""],
    ["cv.Mat.reshape", "cv::Mat", [], [
        ["int", "cn", "", []],
        ["int", "rows", "0", []],
    ], "", ""],
    ["cv.Mat.diag", "cv::Mat", [], [
        ["int", "d", "0", []],
    ], "", ""],
    ["cv.Mat.t", "cv::Mat", [], [], "", ""],

    ["cv.Mat.convertToBitmap", "void*", ["/External"], [
        ["bool", "copy", "true", []],
    ], "", ""],
    ["cv.Mat.convertToShow", "cv::Mat", ["/External"], [
        ["Mat", "dst", "Mat::zeros(__self->get()->rows, __self->get()->cols, CV_8UC3)", ["/IO"]],
        ["bool", "toRGB", "false", []],
    ], "", ""],
    ["cv.Mat.GdiplusResize", "cv::Mat", ["/External"], [
        ["float", "newWidth", "", []],
        ["float", "newHeight", "", []],
        ["int", "interpolation", "7", []],
    ], "", ""],

    ["cv.Mat.eye", "cv::Mat", ["/S"], [
        ["int", "rows", "", []],
        ["int", "cols", "", []],
        ["int", "type", "", []],
    ], "", ""],

    ["cv.Mat.eye", "cv::Mat", ["/S", "/Expr=rows, rows, type"], [
        ["int", "rows", "", []],
        ["int", "type", "", []],
    ], "", ""],

    ["cv.Mat.eye", "cv::Mat", ["/S", "/Expr=cols, cols, type"], [
        ["int", "cols", "", []],
        ["int", "type", "", []],
    ], "", ""],

    ["cv.Mat.zeros", "cv::Mat", ["/S"], [
        ["int", "rows", "", []],
        ["int", "cols", "", []],
        ["int", "type", "", []],
    ], "", ""],

    ["cv.Mat.zeros", "cv::Mat", ["/S", "/Expr=1, cols, type"], [
        ["int", "cols", "", []],
        ["int", "type", "", []],
    ], "", ""],

    ["cv.Mat.zeros", "cv::Mat", ["/S", "/Expr=rows, 1, type"], [
        ["int", "rows", "", []],
        ["int", "type", "", []],
    ], "", ""],

    ["cv.Mat.zeros", "cv::Mat", ["/S"], [
        ["tuple_int_and_int", "size", "", ["/Expr=std::get<0>(size), std::get<1>(size)", "/Cast=Size"]],
        ["int", "type", "", []],
    ], "", ""],

    ["cv.Mat.ones", "cv::Mat", ["/S"], [
        ["int", "rows", "", []],
        ["int", "cols", "", []],
        ["int", "type", "", []],
    ], "", ""],

    ["cv.Mat.ones", "cv::Mat", ["/S", "/Expr=1, cols, type"], [
        ["int", "cols", "", []],
        ["int", "type", "", []],
    ], "", ""],

    ["cv.Mat.ones", "cv::Mat", ["/S", "/Expr=rows, 1, type"], [
        ["int", "rows", "", []],
        ["int", "type", "", []],
    ], "", ""],

    ["cv.Mat.ones", "cv::Mat", ["/S"], [
        ["tuple_int_and_int", "size", "", ["/Expr=std::get<0>(size), std::get<1>(size)", "/Cast=Size"]],
        ["int", "type", "", []],
    ], "", ""],

    // Image file reading and writing

    ["cv.haveImageReader", "bool", [], [
        ["string", "filename", "", []],
    ], "", ""],

    ["cv.haveImageWriter", "bool", [], [
        ["string", "filename", "", []],
    ], "", ""],

    ["cv.imcount", "size_t", [], [
        ["string", "filename", "", []],
        ["int", "flags", "IMREAD_ANYCOLOR", []],
    ], "", ""],

    ["cv.imdecode", "Mat", [], [
        ["Mat", "buf", "", []],
        ["int", "flags", "", []],
    ], "", ""],

    ["cv.imencode", "bool", [], [
        ["string", "ext", "", []],
        ["Mat", "img", "", []],
        ["vector_uchar", "buf", "", ["/O"]],
        ["vector_int", "params", "std::vector<int>()", []],
    ], "", ""],

    ["cv.imread", "Mat", [], [
        ["string", "filename", "", []],
        ["int", "flags", "IMREAD_COLOR", []],
    ], "", ""],

    ["cv.imreadmulti", "bool", [], [
        ["string", "filename", "", []],
        ["vector_Mat", "mats", "", ["/O"]],
        ["int", "flags", "IMREAD_ANYCOLOR", []],
    ], "", ""],

    ["cv.imreadmulti", "bool", [], [
        ["string", "filename", "", []],
        ["vector_Mat", "mats", "", ["/O"]],
        ["int", "start", "", []],
        ["int", "count", "", []],
        ["int", "flags", "IMREAD_ANYCOLOR", []],
    ], "", ""],

    ["cv.imwrite", "bool", [], [
        ["string", "filename", "", []],
        ["Mat", "img", "", []],
        ["vector_int", "params", "std::vector<int>()", []],
    ], "", ""],

    ["cv.imwritemulti", "bool", [], [
        ["string", "filename", "", []],
        ["vector_Mat", "img", "", []],
        ["vector_int", "params", "std::vector<int>()", []],
    ], "", ""],
];

for (const args of [
    [
        ["int", "i0", "", []],
    ],
    [
        ["int", "row", "", []],
        ["int", "col", "", []],
    ],
    [
        ["int", "i0", "", []],
        ["int", "i1", "", []],
        ["int", "i2", "", []],
    ],
    [
        ["tuple_int_and_int", "pt", "", []],
    ],
]) {
    declarations.push(...[
        ["cv.Mat.at", "double", ["/External"], args, "", ""],
        ["cv.Mat.set_at", "void", ["/External"], args.concat([["double", "value", "", []]]), "", ""],
        ["cv.Mat.at", "double", ["/ExternalNoDecl", "/attr=propget", "=get_Item", "/idlname=Item", "/id=DISPID_VALUE"], args, "", ""],
        ["cv.Mat.set_at", "void", ["/ExternalNoDecl", "/attr=propput", "=put_Item", "/idlname=Item", "/id=DISPID_VALUE"], args.concat([["double", "value", "", []]]), "", ""],
    ]);
}

module.exports = declarations;
