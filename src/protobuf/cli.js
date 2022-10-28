const fs = require("node:fs");
const sysPath = require("node:path");
const util = require("node:util");
const Parser = require("./Parser");

const outputs = Parser.createOutputs();
const cache = new Map();
const options = {
    proto_path: [
        fs.realpathSync(`${ __dirname }/../../autoit-mediapipe-com/build_x64/mediapipe-prefix/src/mediapipe`),
        fs.realpathSync(`${ __dirname }/../../autoit-mediapipe-com/build_x64/mediapipe-prefix/src/mediapipe/bazel-mediapipe/external/com_google_protobuf/src`),
    ]
};

for (const filename of [
    "mediapipe/framework/formats/detection.proto",
    "mediapipe/framework/calculator.proto",
]) {
    options.filename = filename;
    const parser = new Parser();
    parser.parseFile(fs.realpathSync(`${ __dirname }/../../autoit-mediapipe-com/build_x64/mediapipe-prefix/src/mediapipe/${ filename }`), options, outputs, cache);
}

options.filename = "test/test_proto.proto";
const parser = new Parser();
parser.parseText(`
package foo.bar;

enum Corpus {
    CORPUS_UNSPECIFIED = 0;
    CORPUS_UNIVERSAL = 1;
    CORPUS_WEB = 2;
    CORPUS_IMAGES = 3;
    CORPUS_LOCAL = 4;
    CORPUS_NEWS = 5;
    CORPUS_PRODUCTS = 6;
    CORPUS_VIDEO = 7;
}

/* SearchRequest represents a search query, with pagination options to
 * indicate which results to include in the response. */

message SearchRequest {
        required string query = 1;
        optional int32 page_number = 2;  // Which page number do we want?
        optional int32 result_per_page = 3;  // Number of results to return per page.
        repeated int32 samples = 4 [packed = true];
        repeated ProtoEnum results = 5 [packed = true];
        optional Corpus corpus = 6 [default = CORPUS_UNIVERSAL];
}

message SearchResponse {
    message Result {
        required string url = 1;
        optional string title = 2;
        repeated string snippets = 3;
        optional SearchRequest request = 4;
        repeated SearchRequest requests = 5;
    }

    optional Result result = 1;
    repeated Result results = 2;
}

message SomeOtherMessage {
    optional SearchResponse.Result result = 1;
    map<string, SearchResponse.Result> projects = 3;
}

message Foo {
    reserved 2, 15, 9 to 11;
    reserved "rfoo", "rbar";
    extensions 100 to 199;
}

enum EnumAllowingAlias {
    option allow_alias = true;
    EAA_UNSPECIFIED = 0;
    EAA_STARTED = 1;
    EAA_RUNNING = 1;
    EAA_FINISHED = 2;
}
enum EnumNotAllowingAlias {
    ENAA_UNSPECIFIED = 0;
    ENAA_STARTED = 1;
    // ENAA_RUNNING = 1;  // Uncommenting this line will cause a compile error inside Google and a warning message outside.
    ENAA_FINISHED = 2;
}

message ImageFormat {
    enum Format {
        // The format is unknown.  It is not valid for an ImageFrame to be
        // initialized with this value.
        UNKNOWN = 0;

        // sRGB, interleaved: one byte for R, then one byte for G, then one
        // byte for B for each pixel.
        SRGB = 1;

        // sRGBA, interleaved: one byte for R, one byte for G, one byte for B,
        // one byte for alpha or unused.
        SRGBA = 2;

        // Grayscale, one byte per pixel.
        GRAY8 = 3;

        // Grayscale, one uint16 per pixel.
        GRAY16 = 4;

        // YCbCr420P (1 bpp for Y, 0.25 bpp for U and V).
        // NOTE: NOT a valid ImageFrame format, but intended for
        // ScaleImageCalculatorOptions, VideoHeader, etc. to indicate that
        // YUVImage is used in place of ImageFrame.
        YCBCR420P = 5;

        // Similar to YCbCr420P, but the data is represented as the lower 10bits of
        // a uint16. Like YCbCr420P, this is NOT a valid ImageFrame, and the data is
        // carried within a YUVImage.
        YCBCR420P10 = 6;

        // sRGB, interleaved, each component is a uint16.
        SRGB48 = 7;

        // sRGBA, interleaved, each component is a uint16.
        SRGBA64 = 8;

        // One float per pixel.
        VEC32F1 = 9;

        // Two floats per pixel.
        VEC32F2 = 12;

        // LAB, interleaved: one byte for L, then one byte for a, then one
        // byte for b for each pixel.
        LAB8 = 10;

        // sBGRA, interleaved: one byte for B, one byte for G, one byte for R,
        // one byte for alpha or unused. This is the N32 format for Skia.
        SBGRA = 11;
    }
}

message Outer {       // Level 0
    message MiddleAA {  // Level 1
        message Inner {   // Level 2
            optional int64 ival = 1;
            optional bool  booly = 2;
        }
    }
    message MiddleBB {  // Level 1
        message Inner {   // Level 2
            optional string name = 1;
            optional bool   flag = 2;
        }
    }
}

message SampleMessage {
    oneof test_oneof {
         string name = 4;
         SubMessage sub_message = 9;
    }
}

extend Foo {
    optional int32 bar = 125;
}

message Baz {
    extend Foo {
        optional int32 bar = 126;
        optional Baz foo_ext = 127;
    }
}

// This can even be in a different file.
extend Foo {
    optional Baz foo_baz_ext = 128;
}


import "google/protobuf/descriptor.proto";

extend google.protobuf.MessageOptions {
    optional string my_option = 51234;
}

message MyMessage {
    option (my_option) = "Hello world!";
}


`, options, outputs, cache);

console.log(util.inspect(outputs, {
    colors: true,
    depth: Infinity
}));
