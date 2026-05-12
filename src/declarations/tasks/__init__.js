module.exports = ({language}) => [
    // expose a language property like in mediapipe python
    [`mediapipe.tasks.${ language }.`, "", ["/Properties"], [
        ["mediapipe::tasks::core::BaseOptions", "BaseOptions", "", ["/R", "=this", "/S"]],
    ], "", ""],
];
