module.exports = ({language}) => [
    // expose properties like in mediapipe python
    [`mediapipe.${ language }.solutions.objectron.`, "", ["/Properties"], [
        ["std::vector<std::tuple<BoxLandmark, BoxLandmark>>", "BOX_CONNECTIONS", "", ["/R", "/C"]],
    ], "", ""],
];
