module.exports = [
    ["class google.protobuf.Message", "", [], [], "", ""],

    // ["google.protobuf.Message.GetDescriptor", "std::shared_ptr<google::protobuf::FieldDescriptor>", [
    //     "/attr=propget", "=get_DESCRIPTOR", "/idlname=DESCRIPTOR", "/Output=::autoit::reference_internal($0)"
    // ], [], "", ""],

    // ["class google.protobuf.FieldDescriptor", "", [], [
    //     ["std::string", "full_name", "", ["/R=full_name"]],
    // ], "", ""],

    ["class mediapipe.Detection", ": google::protobuf::Message", ["/Simple"], [], "", ""],

    ["mediapipe.Detection.Detection", "", [], [], "", ""],

    ["google.protobuf.TextFormat.ParseFromString", "bool", ["=Parse"], [
        ["string", "input", "", ["/C", "/Ref"]],
        ["std::shared_ptr<google::protobuf::Message>", "output", "", ["/Expr=$0.get()"]],
    ], "", ""],

    // expose a detection_pb2 property like in mediapipe python
    ["mediapipe.framework.formats.detection_pb2.", "", ["/Properties"], [
        ["mediapipe::Detection", "Detection", "", ["/R", "=this"]],
    ], "", ""],
];
