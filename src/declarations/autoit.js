module.exports = [
    // expose a autoit property like in mediapipe python
    ["mediapipe.tasks.autoit.", "", ["/Properties"], [
        ["mediapipe::tasks::autoit::core::base_options::BaseOptions", "BaseOptions", "", ["/R", "=this"]],
    ], "", ""],
];
