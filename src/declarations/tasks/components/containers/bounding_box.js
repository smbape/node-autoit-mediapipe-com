module.exports = ({language, self_get}) => [
    // expose bounding_box properties like in mediapipe python
    [`mediapipe.tasks.${ language }.components.containers.bounding_box.`, "", ["/Properties"], [
        ["mediapipe::tasks::components::containers::Rect", "BoundingBox", "", ["/R", "=this", "/S"]],
    ], "", ""],
];
