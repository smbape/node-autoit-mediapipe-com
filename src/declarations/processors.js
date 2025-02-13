module.exports = ({language}) => [
    // expose a processors property like in mediapipe python
    [`mediapipe.tasks.${ language }.components.processors.`, "", ["/Properties"], [
        [`mediapipe::tasks::${ language }::components::processors::classifier_options::ClassifierOptions`, "ClassifierOptions", "", ["/R", "=this", "/S"]],
        ["mediapipe::tasks::components::processors::proto::EmbedderOptions", "EmbedderOptions", "", ["/R", "=this", "/S"]],
    ], "", ""],
];
