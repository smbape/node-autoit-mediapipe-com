const declarations = [
    ["class google.protobuf.Message", "", [], [], "", ""],

    ["google.protobuf.Message.ToStr", "std::string", ["=str", "/Call=google::protobuf::autoit::cmessage::ToStr", "/Expr=*__self->get()"], [], "", ""],

    ["class google.protobuf.FieldDescriptor", "", [], [
        ["std::string", "full_name", "", ["/R=full_name"]],
    ], "", ""],

    ["google.protobuf.TextFormat.ParseFromString", "bool", ["=Parse"], [
        ["string", "input", "", ["/C", "/Ref"]],
        ["std::shared_ptr<google::protobuf::Message>", "output", "", ["/Expr=$0.get()"]],
    ], "", ""],

    // TODO : add Any.Unpack and Any.Pack
];

const protobufs = {
    "mediapipe.framework.calculator_pb2": [
        "mediapipe.CalculatorGraphConfig",
    ],
    "mediapipe.framework.formats.detection_pb2": [
        "mediapipe.Detection",
    ],
};

for (const pkg of Object.keys(protobufs)) {
    for (const proto of protobufs[pkg]) {
        const type_name = proto.slice(proto.lastIndexOf(".") + 1);

        declarations.push(...[
            [`class ${ proto }`, ": google::protobuf::Message", ["/Simple"], [], "", ""],
            [`${ proto }.${ type_name }`, "", [], [], "", ""],
        ]);
    }

    // expose a package property like in mediapipe python
    declarations.push([`${ pkg }.`, "", ["/Properties"], protobufs[pkg].map(proto => {
        const paths = proto.split(".");
        return [paths.join("::"), paths[paths.length - 1], "", ["/R", "=this"]];
    }), "", ""]);
}

module.exports = declarations;
