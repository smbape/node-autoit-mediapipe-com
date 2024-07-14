module.exports = ({ self_get }) => [
    ["enum mediapipe.CalculatorGraph.GraphInputStreamAddMode", "", [], [
        ["const mediapipe.CalculatorGraph.GraphInputStreamAddMode.WAIT_TILL_NOT_FULL", "0", []],
        ["const mediapipe.CalculatorGraph.GraphInputStreamAddMode.ADD_IF_NOT_FULL", "0", []],
    ], "", ""],

    ["class mediapipe.CalculatorGraph", "", [], [
        ["std::string", "text_config", "", ["/R", "=Config().DebugString()"]],
        ["std::string", "binary_config", "", ["/R", "=Config().SerializeAsString()"]],
        ["int", "max_queue_size", "", ["/R", "=GetMaxInputStreamQueueSize()"]],
        ["mediapipe::CalculatorGraph::GraphInputStreamAddMode", "graph_input_stream_add_mode", "", ["/R=GetGraphInputStreamAddMode", "/W=SetGraphInputStreamAddMode"]],
    ], "", ""],

    ["mediapipe.CalculatorGraph.create", "std::shared_ptr<mediapipe::CalculatorGraph>", ["/S", "/Call=mediapipe::autoit::calculator_graph::create"], [
        ["mediapipe::CalculatorGraphConfig", "graph_config_proto", "", ["/Ref"]],
    ], "", ""],

    ["mediapipe.CalculatorGraph.create", "std::shared_ptr<mediapipe::CalculatorGraph>", ["/S", "/Call=mediapipe::autoit::calculator_graph::create"], [
        ["std::string", "binary_graph_path", "", ["/Ref"]],
        ["std::string", "graph_config", "\"\"", ["/Ref"]],
    ], "", ""],

    ["mediapipe.CalculatorGraph.create", "std::shared_ptr<mediapipe::CalculatorGraph>", ["/S", "/Call=mediapipe::autoit::calculator_graph::create", "/Expr=\"\", $0"], [
        ["std::string", "graph_config", "", ["/Ref"]],
    ], "", ""],

    ["mediapipe.CalculatorGraph.create", "std::shared_ptr<mediapipe::CalculatorGraph>", ["/S", "/Call=mediapipe::autoit::calculator_graph::create"], [
        ["mediapipe::ValidatedGraphConfig", "validated_graph_config", "", ["/Ref"]],
    ], "", ""],

    ["mediapipe.CalculatorGraph.add_packet_to_input_stream", "absl::Status", ["/Call=mediapipe::autoit::calculator_graph::add_packet_to_input_stream", `/Expr=${ self_get() }, $0`], [
        ["std::string", "stream", "", ["/Ref"]],
        ["mediapipe::Packet", "packet", "", ["/Ref"]],
        ["mediapipe::Timestamp", "timestamp", "Timestamp::Unset()", ["/Ref"]],
    ], "", ""],

    ["mediapipe.CalculatorGraph.CloseInputStream", "absl::Status", ["=close_input_stream"], [
        ["std::string", "stream", "", ["/Ref"]],
    ], "", ""],

    ["mediapipe.CalculatorGraph.CloseAllPacketSources", "absl::Status", ["=close_all_packet_sources"], [], "", ""],

    ["mediapipe.CalculatorGraph.StartRun", "absl::Status", ["=start_run"], [
        ["std::map<std::string, Packet>", "input_side_packets", "", ["/Ref"]],
    ], "", ""],

    ["mediapipe.CalculatorGraph.WaitUntilDone", "absl::Status", ["=wait_until_done"], [], "", ""],
    ["mediapipe.CalculatorGraph.WaitUntilIdle", "absl::Status", ["=wait_until_idle"], [], "", ""],
    ["mediapipe.CalculatorGraph.WaitForObservedOutput", "absl::Status", ["=wait_for_observed_output"], [], "", ""],
    ["mediapipe.CalculatorGraph.HasError", "bool", ["=has_error"], [], "", ""],
    ["mediapipe.CalculatorGraph.get_combined_error_message", "std::string", ["/Call=mediapipe::autoit::calculator_graph::get_combined_error_message", `/Expr=${ self_get() }`], [], "", ""],
    ["mediapipe.CalculatorGraph.close", "absl::Status", ["/Call=mediapipe::autoit::calculator_graph::close", `/Expr=${ self_get() }`], [], "", ""],

    ["mediapipe.CalculatorGraph.observe_output_stream", "absl::Status", ["/Call=mediapipe::autoit::calculator_graph::observe_output_stream", `/Expr=${ self_get() }, $0`], [
        ["std::string", "stream_name", "", []],
        ["mediapipe::autoit::PacketCallback", "callback_fn", "", []],
        ["bool", "observe_timestamp_bounds", "false", []],
    ], "", ""],

    ["mediapipe.CalculatorGraph.GetOutputSidePacket", "mediapipe::Packet", ["=get_output_side_packet"], [
        ["std::string", "packet_name", "", ["/Ref"]],
    ], "", ""],

    // expose a calculator_graph property like in mediapipe python
    ["mediapipe.autoit._framework_bindings.calculator_graph.", "", ["/Properties"], [
        ["mediapipe::CalculatorGraph", "CalculatorGraph", "", ["/R", "=this"]],
    ], "", ""],
];
