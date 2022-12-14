module.exports = [
    ["class mediapipe.Packet", "", ["/Simple"], [], "", ""],

    ["mediapipe.Packet.Packet", "mediapipe.Packet.Packet", [], [], "", ""],

    ["mediapipe.Packet.Packet", "mediapipe.Packet.Packet", [], [
        ["mediapipe::Packet", "Packet", "", ["/Ref", "/C"]],
    ], "", ""],

    ["mediapipe.Packet.Timestamp", "mediapipe::Timestamp", ["/attr=propget", "=get_timestamp", "/idlname=timestamp"], [], "", ""],
    ["mediapipe.Packet.Timestamp", "void", ["/attr=propput", "=put_timestamp", "/idlname=timestamp", "/Output=*__self->get() = __self->get()->At(Timestamp(ts_value))"], [
        ["int64", "ts_value", "", []],
    ], "", ""],

    ["mediapipe.Packet.IsEmpty", "bool", ["=is_empty"], [], "", ""],

    ["mediapipe.Packet.At", "mediapipe::Packet", ["=at"], [
        ["int64", "ts_value", "", ["/Cast=Timestamp"]],
    ], "", ""],

    ["mediapipe.Packet.At", "mediapipe::Packet", ["=at"], [
        ["Timestamp", "ts", "", []],
    ], "", ""],

    ["mediapipe.Packet.str", "std::string", ["/External"], [], "", ""],

    // expose a packet property like in mediapipe python
    ["mediapipe.autoit._framework_bindings.packet.", "", ["/Properties"], [
        ["mediapipe::Packet", "Packet", "", ["/R", "=this"]],
    ], "", ""],
];
