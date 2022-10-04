const declarations = [
    ["create_string", "std::string", "std::string", ["/Ref"], []],
    ["create_bool", "bool", "bool", [], []],
    ["create_int", "int64", "int", [], ["/External"]],
    ["create_int8", "int64", "int8", [], ["/External"]],
    ["create_int16", "int64", "int16", [], ["/External"]],
    ["create_int32", "int64", "int32", [], ["/External"]],
    ["create_int64", "int64", "int64", [], []],
    ["create_uint8", "int64", "uint8", [], ["/External"]],
    ["create_uint16", "int64", "uint16", [], ["/External"]],
    ["create_uint32", "int64", "uint32", [], ["/External"]],
    ["create_uint64", "uint64", "uint64", [], []],
    ["create_float", "float", "float", [], []],
    ["create_double", "double", "double", [], []],
    ["create_int_array", "std::vector<int>", "std::vector<int>", ["/C", "/Ref"], ["/External"]],
    ["create_float_array", "std::vector<float>", "std::vector<float>", ["/C", "/Ref"], ["/External"]],
    ["create_int_vector", "std::vector<int>", "std::vector<int>", ["/C", "/Ref"], []],
    ["create_bool_vector", "std::vector<bool>", "std::vector<bool>", ["/C", "/Ref"], []],
    ["create_float_vector", "std::vector<float>", "std::vector<float>", ["/C", "/Ref"], []],
    ["create_string_vector", "std::vector<std::string>", "std::vector<std::string>", ["/C", "/Ref"], []],
    ["create_image_vector", "std::vector<Image>", "std::vector<Image>", ["/C", "/Ref"], []],
    ["create_packet_vector", "std::vector<Packet>", "std::vector<Packet>", ["/C", "/Ref"], []],
    ["create_string_to_packet_map", "std::map<std::string, Packet>", "std::map<std::string, Packet>", ["/C", "/Ref"], []],
].map(([fname, data_type, packet_type, arg_modifiers, func_modifiers]) => {
    if (!func_modifiers.includes("/External")) {
        func_modifiers.push(...[
            `/Call=MakePacket<${ packet_type }>`,
            "/Output=std::make_shared<Packet>(std::move($0))"
        ]);
    }
    return [`mediapipe.autoit.packet_creator.${ fname }`, "std::shared_ptr<mediapipe::Packet>", func_modifiers, [
        [data_type, "data", "", arg_modifiers]
    ], "", ""];
});

declarations.push(...[
    ["mediapipe.autoit.packet_creator.create_image_frame", "std::shared_ptr<mediapipe::Packet>", ["/External"], [
        ["ImageFrame", "data", "", ["/Ref"]],
        ["bool", "copy", "true", []],
    ], "", ""],

    ["mediapipe.autoit.packet_creator.create_image_frame", "std::shared_ptr<mediapipe::Packet>", ["/External"], [
        ["ImageFrame", "data", "", ["/Ref"]],
        ["ImageFormat::Format", "image_format", "", []],
        ["bool", "copy", "true", []],
    ], "", ""],

    ["mediapipe.autoit.packet_creator.create_image_frame", "std::shared_ptr<mediapipe::Packet>", ["/External"], [
        ["cv::Mat", "data", "", ["/Ref"]],
        ["bool", "copy", "true", []],
    ], "", ""],

    ["mediapipe.autoit.packet_creator.create_image_frame", "std::shared_ptr<mediapipe::Packet>", ["/External"], [
        ["cv::Mat", "data", "", ["/Ref"]],
        ["ImageFormat::Format", "image_format", "", []],
        ["bool", "copy", "true", []],
    ], "", ""],

    ["mediapipe.autoit.packet_creator.create_image", "std::shared_ptr<mediapipe::Packet>", ["/External"], [
        ["Image", "data", "", ["/Ref"]],
        ["bool", "copy", "true", []],
    ], "", ""],

    ["mediapipe.autoit.packet_creator.create_image", "std::shared_ptr<mediapipe::Packet>", ["/External"], [
        ["Image", "data", "", ["/Ref"]],
        ["ImageFormat::Format", "image_format", "", []],
        ["bool", "copy", "true", []],
    ], "", ""],

    ["mediapipe.autoit.packet_creator.create_image", "std::shared_ptr<mediapipe::Packet>", ["/External"], [
        ["cv::Mat", "data", "", ["/Ref"]],
        ["bool", "copy", "true", []],
    ], "", ""],

    ["mediapipe.autoit.packet_creator.create_image", "std::shared_ptr<mediapipe::Packet>", ["/External"], [
        ["cv::Mat", "data", "", ["/Ref"]],
        ["ImageFormat::Format", "image_format", "", []],
        ["bool", "copy", "true", []],
    ], "", ""],

    ["mediapipe.autoit.packet_creator.create_proto", "std::shared_ptr<mediapipe::Packet>", ["/External"], [
        ["google::protobuf::Message", "proto_message", "", ["/Ref"]],
    ], "", ""],

    // expose a packet_creator property like in mediapipe python
    ["mediapipe.autoit.", "", ["/Properties"], [
        ["mediapipe::autoit::packet_creator", "packet_creator", "", ["/R", "=this"]],
    ], "", ""]
]);

module.exports = declarations;
