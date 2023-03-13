module.exports = [
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
