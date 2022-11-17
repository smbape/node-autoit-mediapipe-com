module.exports = [
    ["class google.protobuf.Message", "", [], [], "", ""],

    ["google.protobuf.Message.ToStr", "void", ["=__str__", "/Call=google::protobuf::autoit::Print", "/Expr=*__self->get(), $0"], [
        ["std::string*", "output", "", ["/O"]],
    ], "", ""],

    ["google.protobuf.Message.CopyFrom", "void", ["/Call=google::protobuf::autoit::cmessage::CopyFrom", "/Expr=__self->get(), $0"], [
        ["google::protobuf::Message*", "other_message", "", ["/C"]],
    ], "", ""],

    ["google.protobuf.Message.ClearField", "void", ["/Call=google::protobuf::autoit::cmessage::ClearField", "/Expr=*__self->get(), $0"], [
        ["std::string", "field_name", "", ["/C", "/Ref"]],
    ], "", ""],

    ["google.protobuf.Message.Clear", "void", [], [], "", ""],

    ["class google.protobuf.FieldDescriptor", "", [], [
        ["std::string", "full_name", "", ["/R=full_name"]],
    ], "", ""],

    ["google.protobuf.TextFormat.PrintToString", "bool", [], [
        ["std::shared_ptr<google::protobuf::Message>", "message", "", ["/Ref", "/C", "/Expr=*$0.get()"]],
        ["std::string*", "output", "", ["/O"]],
    ], "", ""],

    ["google.protobuf.TextFormat.Print", "void", ["/Call=google::protobuf::autoit::Print"], [
        ["std::shared_ptr<google::protobuf::Message>", "message", "", ["/Ref", "/C", "/Expr=*$0.get()"]],
        ["std::string*", "output", "", ["/O"]],
    ], "", ""],

    ["google.protobuf.TextFormat.Parse", "std::shared_ptr<google::protobuf::Message>", ["/Call=google::protobuf::autoit::Parse"], [
        ["std::string", "input", "", ["/C", "/Ref"]],
        ["std::shared_ptr<google::protobuf::Message>", "message", "", []],
    ], "", ""],

    ["google.protobuf.TextFormat.ParseFromString", "bool", [], [
        ["std::string", "input", "", ["/C", "/Ref"]],
        ["google::protobuf::Message*", "message", "", []],
    ], "", ""],

    ["google.protobuf.TextFormat.MergeFromString", "bool", [], [
        ["std::string", "input", "", ["/C", "/Ref"]],
        ["google::protobuf::Message*", "message", "", []],
    ], "", ""],

    ["google.protobuf.Any.UnpackTo", "void", ["=Unpack"], [
        ["google::protobuf::Message*", "message", "", []],
    ], "", ""],

    ["google.protobuf.Any.PackFrom", "void", ["=Pack"], [
        ["google::protobuf::Message", "message", "", ["/C", "/Ref"]],
    ], "", ""],
];
