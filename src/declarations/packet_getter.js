const declarations = [
    ["get_str", "std::string", []],
    ["get_bool", "bool", []],
    ["get_bool_list", "std::vector<bool>", []],
    ["get_str_list", "std::vector<std::string>", []],
    ["get_image_list", "std::vector<mediapipe::Image>", []],
    ["get_packet_list", "std::vector<mediapipe::Packet>", []],
    ["get_str_to_packet_dict", "std::map<std::string, mediapipe::Packet>", []],
    ["get_image_frame", "mediapipe::ImageFrame", ["/WrapAs=::autoit::reference_internal"]],
    ["get_image", "mediapipe::Image", []],
].map(([fname, type_name, func_modifiers]) => {
    func_modifiers.push(...[
        `/Call=GetContent<${ type_name }>`,
    ]);
    return [`mediapipe.autoit.packet_getter.${ fname }`, type_name, func_modifiers, [
        ["mediapipe::Packet", "packet", "", ["/Ref"]],
    ], "", ""];
});

declarations.push(...[
    // expose a packet_getter property like in mediapipe python
    ["mediapipe.autoit.", "", ["/Properties"], [
        ["mediapipe::autoit::packet_getter", "packet_getter", "", ["/R", "=this"]],
    ], "", ""]
]);

module.exports = declarations;
