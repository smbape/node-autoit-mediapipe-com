module.exports = [
    // expose properties like in mediapipe python
    ["mediapipe.autoit.solutions.objectron.", "", ["/Properties"], [
        ["std::vector<std::tuple<BoxLandmark, BoxLandmark>>", "BOX_CONNECTIONS", "", ["/R"]],
        ["mediapipe::autoit::solutions::objectron::Objectron", "Objectron", "", ["/R", "=this"]],
    ], "", ""],
];
