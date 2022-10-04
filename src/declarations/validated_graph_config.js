module.exports = [
    ["class mediapipe.ValidatedGraphConfig", "", [], [
        ["std::string", "text_config", "", ["/R", "=Config().DebugString()"]],
        ["std::string", "binary_config", "", ["/R", "=Config().SerializeAsString()"]],
    ], "", ""],

    ["mediapipe.ValidatedGraphConfig.ValidatedGraphConfig", "mediapipe.ValidatedGraphConfig.ValidatedGraphConfig", [], [], "", ""],

    ["mediapipe.ValidatedGraphConfig.Initialize", "void", ["=initialize", "/WrapAs=mediapipe::autoit::RaiseAutoItErrorIfNotOk"], [
        ["std::string", "binary_graph_path", "", ["/Cast=mediapipe::autoit::ReadCalculatorGraphConfigFromFile"]],
    ], "", ""],

    ["mediapipe.ValidatedGraphConfig.Initialize", "void", ["=initialize", "/WrapAs=mediapipe::autoit::RaiseAutoItErrorIfNotOk"], [
        ["mediapipe::CalculatorGraphConfig", "graph_config", "", ["/Ref"]],
    ], "", ""],

    ["mediapipe.ValidatedGraphConfig.RegisteredStreamTypeName", "std::string", ["=registered_stream_type_name", "/WrapAs=mediapipe::autoit::AssertAutoItValue"], [
        ["std::string", "stream_name", "", []],
    ], "", ""],

    ["mediapipe.ValidatedGraphConfig.RegisteredSidePacketTypeName", "std::string", ["=registered_side_packet_type_name", "/WrapAs=mediapipe::autoit::AssertAutoItValue"], [
        ["std::string", "side_packet_name", "", []],
    ], "", ""],

    ["mediapipe.ValidatedGraphConfig.Initialized", "bool", ["=initialized"], [], "", ""],

    // expose a validated_graph_config property like in mediapipe python
    ["mediapipe.autoit._framework_bindings.validated_graph_config.", "", ["/Properties"], [
        ["mediapipe::ValidatedGraphConfig", "ValidatedGraphConfig", "", ["/R", "=this"]],
    ], "", ""],
];
