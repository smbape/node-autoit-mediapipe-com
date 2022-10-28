module.exports = [
    ["class google.protobuf.Message", "", [], [], "", ""],

    ["google.protobuf.Message.ToStr", "std::string", ["=str", "/Call=google::protobuf::autoit::cmessage::ToStr", "/Expr=*__self->get()"], [], "", ""],

    ["class google.protobuf.FieldDescriptor", "", [], [
        ["std::string", "full_name", "", ["/R=full_name"]],
    ], "", ""],

    ["google.protobuf.TextFormat.PrintToString", "bool", [], [
        ["std::shared_ptr<google::protobuf::Message>", "message", "", ["/Expr=*$0.get()"]],
        ["std::string*", "output", "", ["/O"]],
    ], "", ""],

    ["google.protobuf.TextFormat.ParseFromString", "bool", [], [
        ["std::string", "input", "", ["/C", "/Ref"]],
        ["std::shared_ptr<google::protobuf::Message>", "output", "", ["/Expr=$0.get()"]],
    ], "", ""],

    ["google.protobuf.TextFormat.MergeFromString", "bool", [], [
        ["std::string", "input", "", ["/C", "/Ref"]],
        ["std::shared_ptr<google::protobuf::Message>", "output", "", ["/Expr=$0.get()"]],
    ], "", ""],

    ["google.protobuf.Any.UnpackTo", "void", ["=Unpack"], [
        ["google::protobuf::Message*", "message", "", []],
    ], "", ""],

    ["google.protobuf.Any.PackFrom", "void", ["=Pack"], [
        ["google::protobuf::Message", "input", "", ["/C", "/Ref"]],
    ], "", ""],
];
