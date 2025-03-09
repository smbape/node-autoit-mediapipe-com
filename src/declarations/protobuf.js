module.exports = ({self, self_get, language}) => [
    ["class google.protobuf.Message", "", [], [], "", ""],

    ["google.protobuf.Message.ToStr", "absl::Status", ["=__str__", `/Call=google::protobuf::${ language }::Print`, `/Expr=${ self }, $0`], [
        ["std::string*", "output", "", ["/O"]],
    ], "", ""],

    ["google.protobuf.Message.CopyFrom", "absl::Status", [`/Call=google::protobuf::${ language }::cmessage::CopyFrom`, `/Expr=&(${ self }), $0`], [
        ["google::protobuf::Message*", "other_message", "", ["/C"]],
    ], "", ""],

    ["google.protobuf.Message.ClearField", "absl::Status", [`/Call=google::protobuf::${ language }::cmessage::ClearField`, `/Expr=${ self }, $0`], [
        ["std::string", "field_name", "", ["/C", "/Ref"]],
    ], "", ""],

    ["google.protobuf.Message.CheckInitialized", "void", [], [], "", ""],

    ["google.protobuf.Message.FindInitializationErrors", "void", [], [
        ["std::vector<std::string>*", "errors", "", ["/O"]],
    ], "", ""],

    ["google.protobuf.Message.DiscardUnknownFields", "void", [], [], "", ""],
    ["google.protobuf.Message.SpaceUsedLong", "size_t", [], [], "", ""],
    ["google.protobuf.Message.IsInitialized", "bool", [], [], "", ""],
    ["google.protobuf.Message.ByteSizeLong", "size_t", [], [], "", ""],
    ["google.protobuf.Message.Clear", "void", [], [], "", ""],
    ["google.protobuf.Message.SerializeAsString", "std::string", [], [], "", ""],
    ["google.protobuf.Message.SerializeToString", "void", [], [
        ["std::string*", "output", "", ["/O"]],
    ], "", ""],

    ["class google.protobuf.FieldDescriptor", "", [], [
        ["std::string", "full_name", "", ["/R=full_name"]],
    ], "", ""],

    ["google.protobuf.TextFormat.PrintToString", "bool", [], [
        ["std::shared_ptr<google::protobuf::Message>", "message", "", ["/Ref", "/C", "/Expr=*$0.get()"]],
        ["std::string*", "output", "", ["/O"]],
    ], "", ""],

    ["google.protobuf.TextFormat.Print", "absl::Status", [`/Call=google::protobuf::${ language }::Print`], [
        ["std::shared_ptr<google::protobuf::Message>", "message", "", ["/Ref", "/C", "/Expr=*$0.get()"]],
        ["std::string*", "output", "", ["/O"]],
    ], "", ""],

    ["google.protobuf.TextFormat.Parse", "std::shared_ptr<google::protobuf::Message>", [`/Call=google::protobuf::${ language }::Parse`], [
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
