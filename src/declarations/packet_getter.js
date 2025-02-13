module.exports = ({language}) => {
    const declarations = [
        ["get_str", "std::string", "", []],
        ["get_bool", "bool", "", []],
        ["get_bool_list", "std::vector<bool>", "", []],
        ["get_str_list", "std::vector<std::string>", "", []],
        ["get_image_list", "std::vector<mediapipe::Image>", "", []],
        ["get_packet_list", "std::vector<mediapipe::Packet>", "", []],
        ["get_str_to_packet_dict", "std::map<std::string, mediapipe::Packet>", "", []],
        ["get_image_frame", "mediapipe::ImageFrame", "std::shared_ptr<mediapipe::ImageFrame>", []],
        ["get_image", "mediapipe::Image", "", []],
    ].map(([fname, type_name, return_value_type, func_modifiers]) => {
        func_modifiers.push(...[
            `/Call=${ return_value_type.startsWith("std::shared_ptr<") ? "Share" : "Get" }Content<${ type_name }>`,
        ]);
        return [`mediapipe.${ language }.packet_getter.${ fname }`, return_value_type || type_name, func_modifiers, [
            ["mediapipe::Packet", "packet", "", ["/Ref", "/C"]],
        ], "", ""];
    });

    declarations.push(...[
        // expose a packet_getter property like in mediapipe python
        [`mediapipe.${ language }.`, "", ["/Properties"], [
            [`mediapipe::${ language }::packet_getter`, "packet_getter", "", ["/R", "=this", "/S"]],
        ], "", ""]
    ]);

    return declarations;
};
