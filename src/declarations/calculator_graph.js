module.exports = [
    ["enum mediapipe.CalculatorGraph.GraphInputStreamAddMode", "", [], [
        ["const mediapipe.CalculatorGraph.GraphInputStreamAddMode.WAIT_TILL_NOT_FULL", "0", []],
        ["const mediapipe.CalculatorGraph.GraphInputStreamAddMode.ADD_IF_NOT_FULL", "0", []],
    ], "", ""],

    ["class mediapipe.CalculatorGraphConfig", ": google::protobuf::Message", ["/Simple"], [], "", ""],

    ["mediapipe.CalculatorGraphConfig.CalculatorGraphConfig", "mediapipe.CalculatorGraphConfig.CalculatorGraphConfig", [], [], "", ""],

    ["class mediapipe.CalculatorGraph", "", [], [
        ["std::string", "text_config", "", ["/R", "=Config().DebugString()"]],
        ["std::string", "binary_config", "", ["/R", "=Config().SerializeAsString()"]],
        ["int", "max_queue_size", "", ["/R", "=GetMaxInputStreamQueueSize()"]],
        ["mediapipe::CalculatorGraph::GraphInputStreamAddMode", "graph_input_stream_add_mode", "", ["/R=GetGraphInputStreamAddMode", "/W=SetGraphInputStreamAddMode"]],
    ], "", ""],

    ["mediapipe.CalculatorGraph.create", "std::shared_ptr<mediapipe::CalculatorGraph>", ["/S", "/External"], [
        ["mediapipe::CalculatorGraphConfig", "graph_config_proto", "", ["/Ref"]],
    ], "", ""],

    ["mediapipe.CalculatorGraph.create", "std::shared_ptr<mediapipe::CalculatorGraph>", ["/S", "/External"], [
        ["std::string", "binary_graph_path", "\"\"", ["/Ref"]],
        ["std::string", "graph_config", "\"\"", ["/Ref"]],
    ], "", ""],

    ["mediapipe.CalculatorGraph.create", "std::shared_ptr<mediapipe::CalculatorGraph>", ["/S", "/External"], [
        ["mediapipe::ValidatedGraphConfig", "validated_graph_config", "", ["/Ref"]],
    ], "", ""],

    ["mediapipe.CalculatorGraph.add_packet_to_input_stream", "void", ["/External"], [
        ["std::string", "stream", "", ["/Ref"]],
        ["mediapipe::Packet", "packet", "", ["/Ref"]],
        ["mediapipe::Timestamp", "timestamp", "Timestamp::Unset()", ["/Ref"]],
    ], "", ""],

    ["mediapipe.CalculatorGraph.CloseInputStream", "void", ["=close_input_stream"], [
        ["std::string", "stream", "", ["/Ref"]],
    ], "", ""],

    ["mediapipe.CalculatorGraph.CloseAllPacketSources", "void", ["=close_all_packet_sources"], [], "", ""],

    ["mediapipe.CalculatorGraph.StartRun", "void", ["=start_run", "/WrapAs=mediapipe::autoit::RaiseAutoItErrorIfNotOk"], [
        ["std::map<std::string, Packet>", "input_side_packets", "", ["/Ref"]],
    ], "", ""],

    ["mediapipe.CalculatorGraph.WaitUntilDone", "void", ["=wait_until_done", "/WrapAs=mediapipe::autoit::RaiseAutoItErrorIfNotOk"], [], "", ""],
    ["mediapipe.CalculatorGraph.WaitUntilIdle", "void", ["=wait_until_idle", "/WrapAs=mediapipe::autoit::RaiseAutoItErrorIfNotOk"], [], "", ""],
    ["mediapipe.CalculatorGraph.WaitForObservedOutput", "void", ["=wait_for_observed_output", "/WrapAs=mediapipe::autoit::RaiseAutoItErrorIfNotOk"], [], "", ""],
    ["mediapipe.CalculatorGraph.HasError", "bool", ["=has_error"], [], "", ""],
    ["mediapipe.CalculatorGraph.get_combined_error_message", "std::string", ["/External"], [], "", ""],

    ["mediapipe.CalculatorGraph.observe_output_stream", "void", ["/External"], [
        ["std::string", "stream_name", "", []],
        ["mediapipe::autoit::StreamPacketCallback", "callback_fn", "", []],
        ["bool", "observe_timestamp_bounds", "false", []],
    ], "", ""],

    ["mediapipe.CalculatorGraph.GetOutputSidePacket", "mediapipe::Packet", ["=get_output_side_packet", "/WrapAs=mediapipe::autoit::AssertAutoItValue"], [
        ["std::string", "packet_name", "", ["/Ref"]],
    ], "", ""],

    // expose a calculator_graph property like in mediapipe python
    ["mediapipe.autoit._framework_bindings.calculator_graph.", "", ["/Properties"], [
        ["mediapipe::CalculatorGraph", "CalculatorGraph", "", ["/R", "=this"]],
    ], "", ""],
];
