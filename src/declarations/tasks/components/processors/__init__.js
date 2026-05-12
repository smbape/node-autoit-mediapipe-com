module.exports = ({language}) => [
    // expose a processors property like in mediapipe python
    [`mediapipe.tasks.${ language }.components.processors.`, "", ["/Properties"], [
        ["mediapipe::tasks::components::processors::ClassifierOptions", "ClassifierOptions", "", ["/R", "=this", "/S"]],
        ["mediapipe::tasks::components::processors::EmbedderOptions", "EmbedderOptions", "", ["/R", "=this", "/S"]],
    ], "", ""],
];
