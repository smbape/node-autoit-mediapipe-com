const declarations = [
    ["create_string", "std::string", "std::string", ["/Ref"], []],
    ["create_bool", "bool", "bool", [], []],
    ["create_int64", "int64_t", "int64_t", [], []],
    ["create_uint64", "uint64_t", "uint64_t", [], []],
    ["create_float", "float", "float", [], []],
    ["create_double", "double", "double", [], []],
    ["create_int_vector", "std::vector<int>", "std::vector<int>", ["/C", "/Ref"], []],
    ["create_bool_vector", "std::vector<bool>", "std::vector<bool>", ["/C", "/Ref"], []],
    ["create_float_vector", "std::vector<float>", "std::vector<float>", ["/C", "/Ref"], []],
    ["create_string_vector", "std::vector<std::string>", "std::vector<std::string>", ["/C", "/Ref"], []],
    ["create_image_vector", "std::vector<Image>", "std::vector<Image>", ["/C", "/Ref"], []],
    ["create_packet_vector", "std::vector<Packet>", "std::vector<Packet>", ["/C", "/Ref"], []],
    ["create_string_to_packet_map", "std::map<std::string, Packet>", "std::map<std::string, Packet>", ["/C", "/Ref"], []],
].map(([fname, data_type, packet_type, arg_modifiers, func_modifiers]) => {
    func_modifiers.push(...[
        `/Call=MakePacket<${ packet_type }>`,
        "/Output=std::make_shared<Packet>(std::move($0))"
    ]);
    return [`mediapipe.autoit.packet_creator.${ fname }`, "std::shared_ptr<mediapipe::Packet>", func_modifiers, [
        [data_type, "data", "", arg_modifiers]
    ], "", ""];
});

declarations.push(...[
    // expose a packet_creator property like in mediapipe python
    ["mediapipe.autoit.", "", ["/Properties"], [
        ["mediapipe::autoit::packet_creator", "packet_creator", "", ["/R", "=this"]],
    ], "", ""]
]);

module.exports = declarations;
