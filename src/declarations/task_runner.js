module.exports = [
    ["class mediapipe.tasks.core.TaskRunner", "", [], [], "", ""],

    ["mediapipe.tasks.core.TaskRunner.create", "std::shared_ptr<mediapipe::tasks::core::TaskRunner>", ["/S", "/Call=mediapipe::autoit::task_runner::create"], [
        ["mediapipe::CalculatorGraphConfig", "graph_config", "", ["/Ref"]],
        ["mediapipe::autoit::PacketsCallback", "packets_callback", "nullptr", [""]],
    ], "", ""],

    ["mediapipe.tasks.core.TaskRunner.Process", "std::map<std::string, Packet>", ["=process", "/WrapAs=mediapipe::autoit::AssertAutoItValue"], [
        ["std::map<std::string, Packet>", "input_packets", "", ["/Ref"]],
    ], "", ""],

    ["mediapipe.tasks.core.TaskRunner.Send", "void", ["=send", "/WrapAs=RaiseAutoItErrorIfNotOk"], [
        ["std::map<std::string, Packet>", "input_packets", "", ["/Ref"]],
    ], "", ""],

    ["mediapipe.tasks.core.TaskRunner.Close", "void", ["=close", "/WrapAs=RaiseAutoItErrorIfNotOk"], [], "", ""],
    ["mediapipe.tasks.core.TaskRunner.Restart", "void", ["=restart", "/WrapAs=RaiseAutoItErrorIfNotOk"], [], "", ""],

    // expose a task_runner property like in mediapipe python
    ["mediapipe.autoit._framework_bindings.task_runner.", "", ["/Properties"], [
        ["mediapipe::tasks::core::TaskRunner", "TaskRunner", "", ["/R", "=this"]],
    ], "", ""],
];
