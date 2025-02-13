module.exports = ({language, cname}) => [
    ["class mediapipe.tasks.core.TaskRunner", "", [], [], "", ""],

    [`mediapipe.tasks.core.TaskRunner.${ cname }`, "std::shared_ptr<mediapipe::tasks::core::TaskRunner>", ["/S", `/Call=mediapipe::${ language }::task_runner::create`], [
        ["mediapipe::CalculatorGraphConfig", "graph_config", "", ["/Ref"]],
        [`mediapipe::${ language }::PacketsCallback`, "packets_callback", "nullptr", [""]],
    ], "", ""],

    ["mediapipe.tasks.core.TaskRunner.Process", "std::map<std::string, Packet>", ["=process"], [
        ["std::map<std::string, Packet>", "input_packets", "", ["/Ref"]],
    ], "", ""],

    ["mediapipe.tasks.core.TaskRunner.Send", "absl::Status", ["=send"], [
        ["std::map<std::string, Packet>", "input_packets", "", ["/Ref"]],
    ], "", ""],

    ["mediapipe.tasks.core.TaskRunner.Close", "absl::Status", ["=close"], [], "", ""],
    ["mediapipe.tasks.core.TaskRunner.Restart", "absl::Status", ["=restart"], [], "", ""],
    ["mediapipe.tasks.core.TaskRunner.GetGraphConfig", "std::shared_ptr<mediapipe::CalculatorGraphConfig>", ["=get_graph_config", `/WrapAs=::${ language }::reference_internal`], [], "", ""],

    // expose a task_runner property like in mediapipe python
    [`mediapipe.${ language }._framework_bindings.task_runner.`, "", ["/Properties"], [
        ["mediapipe::tasks::core::TaskRunner", "TaskRunner", "", ["/R", "=this", "/S"]],
    ], "", ""],
];
