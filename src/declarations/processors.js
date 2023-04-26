module.exports = [
    // expose a processors property like in mediapipe python
    ["mediapipe.tasks.autoit.components.processors.", "", ["/Properties"], [
        ["mediapipe::tasks::autoit::components::processors::classifier_options::ClassifierOptions", "ClassifierOptions", "", ["/R", "=this"]],
        ["mediapipe::tasks::components::processors::proto::EmbedderOptions", "EmbedderOptions", "", ["/R", "=this"]],
    ], "", ""],
];
