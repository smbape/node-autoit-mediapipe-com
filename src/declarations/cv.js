module.exports = [
    ["class cv._InputArray", "", [], [], "", ""],
    ["class cv._OutputArray", "", [], [], "", ""],
    ["class cv._InputOutputArray", "", [], [], "", ""],

    ["enum cv.Formatter.FormatType", "", [], [
        ["const cv.Formatter.FMT_DEFAULT", "0", [], [], "", ""],
        ["const cv.Formatter.FMT_MATLAB", "1", [], [], "", ""],
        ["const cv.Formatter.FMT_CSV", "2", [], [], "", ""],
        ["const cv.Formatter.FMT_PYTHON", "3", [], [], "", ""],
        ["const cv.Formatter.FMT_NUMPY", "4", [], [], "", ""],
        ["const cv.Formatter.FMT_C", "5", [], [], "", ""],
    ], "", ""],

    ["cv.haveImageReader", "bool", [], [
        ["string", "filename", "", ["/C", "/Ref"]],
    ], "", ""],

    ["cv.haveImageWriter", "bool", [], [
        ["string", "filename", "", ["/C", "/Ref"]],
    ], "", ""],

    ["cv.imcount", "size_t", [], [
        ["string", "filename", "", ["/C", "/Ref"]],
        ["int", "flags", "IMREAD_ANYCOLOR", []],
    ], "", ""],

    ["cv.imdecode", "Mat", [], [
        ["Mat", "buf", "", []],
        ["int", "flags", "", []],
    ], "", ""],

    ["cv.imencode", "bool", [], [
        ["string", "ext", "", []],
        ["Mat", "img", "", []],
        ["std::vector<uchar>", "buf", "", ["/O"]],
        ["std::vector<int>", "params", "std::vector<int>()", []],
    ], "", ""],

    ["cv.imread", "Mat", [], [
        ["string", "filename", "", ["/C", "/Ref", "/PATH"]],
        ["int", "flags", "IMREAD_COLOR", []],
    ], "", ""],

    ["cv.imread", "void", [], [
        ["string", "filename", "", ["/C", "/Ref", "/PATH"]],
        ["OutputArray", "dst", "", []],
        ["int", "flags", "IMREAD_COLOR", []],
    ], "", ""],

    ["cv.imreadmulti", "bool", [], [
        ["string", "filename", "", ["/C", "/Ref"]],
        ["std::vector<Mat>", "mats", "", ["/O"]],
        ["int", "flags", "IMREAD_ANYCOLOR", []],
    ], "", ""],

    ["cv.imreadmulti", "bool", [], [
        ["string", "filename", "", ["/C", "/Ref"]],
        ["std::vector<Mat>", "mats", "", ["/O"]],
        ["int", "start", "", []],
        ["int", "count", "", []],
        ["int", "flags", "IMREAD_ANYCOLOR", []],
    ], "", ""],

    ["cv.imwrite", "bool", [], [
        ["string", "filename", "", ["/C", "/Ref"]],
        ["Mat", "img", "", []],
        ["std::vector<int>", "params", "std::vector<int>()", []],
    ], "", ""],

    ["cv.imwritemulti", "bool", [], [
        ["string", "filename", "", ["/C", "/Ref"]],
        ["std::vector<Mat>", "img", "", []],
        ["std::vector<int>", "params", "std::vector<int>()", []],
    ], "", ""],
];
