module.exports = ({self, language}) => [
    ["class mediapipe.ValidatedGraphConfig", "", [], [
        ["std::string", "text_config", "", ["/R", "=Config().DebugString()"]],
        ["std::string", "binary_config", "", ["/R", "=Config().SerializeAsString()"]],
    ], "", ""],

    ["mediapipe.ValidatedGraphConfig.ValidatedGraphConfig", "mediapipe.ValidatedGraphConfig.ValidatedGraphConfig", [], [], "", ""],

    ["mediapipe.ValidatedGraphConfig.Initialize", "absl::Status", ["=initialize"], [
        ["std::string", "binary_graph_path", "", [`/Cast=mediapipe::${ language }::ReadCalculatorGraphConfigFromFile`, "/C", "/Ref"]],
    ], "", ""],

    ["mediapipe.ValidatedGraphConfig.Initialize", "absl::Status", ["=initialize"], [
        ["mediapipe::CalculatorGraphConfig", "graph_config", "", ["/Ref"]],
    ], "", ""],

    ["mediapipe.ValidatedGraphConfig.Initialize", "absl::Status", ["=initialize", `/Call=mediapipe::${ language }::validated_graph_config::Initialize`, `/Expr=${ self }, $0`], [
        ["std::string", "graph_config", "", ["/Ref", "/C"]],
    ], "", ""],

    ["mediapipe.ValidatedGraphConfig.RegisteredStreamTypeName", "std::string", ["=registered_stream_type_name"], [
        ["std::string", "stream_name", "", []],
    ], "", ""],

    ["mediapipe.ValidatedGraphConfig.RegisteredSidePacketTypeName", "std::string", ["=registered_side_packet_type_name"], [
        ["std::string", "side_packet_name", "", []],
    ], "", ""],

    ["mediapipe.ValidatedGraphConfig.Initialized", "bool", ["=initialized"], [], "", ""],

    // expose a validated_graph_config property like in mediapipe python
    [`mediapipe.${ language }._framework_bindings.validated_graph_config.`, "", ["/Properties"], [
        ["mediapipe::ValidatedGraphConfig", "ValidatedGraphConfig", "", ["/R", "=this", "/S"]],
    ], "", ""],
];
