module.exports = ({language}) => [
    // expose a language property like in mediapipe python
    [`mediapipe.tasks.${ language }.`, "", ["/Properties"], [
        [`mediapipe::tasks::${ language }::core::base_options::BaseOptions`, "BaseOptions", "", ["/R", "=this", "/S"]],
    ], "", ""],
];
