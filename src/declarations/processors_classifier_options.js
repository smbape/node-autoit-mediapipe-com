module.exports = ({language}) => [
    // expose a containers property like in mediapipe python
    [`mediapipe.tasks.${ language }.components.processors.classifier_options.`, "", ["/Properties"], [
        [`mediapipe::tasks::${ language }::components::processors::classifier_options::ClassifierOptions`, "ClassifierOptions", "", ["/R", "=this", "/S"]],
    ], "", ""],
];
