module.exports = [
    ["mediapipe.autoit.solutions.drawing_utils.", "", ["/Properties"], [
        ["std::tuple<int, int, int>", "WHITE_COLOR", "", "/R"],
        ["std::tuple<int, int, int>", "BLACK_COLOR", "", "/R"],
        ["std::tuple<int, int, int>", "RED_COLOR", "", "/R"],
        ["std::tuple<int, int, int>", "GREEN_COLOR", "", "/R"],
        ["std::tuple<int, int, int>", "BLUE_COLOR", "", "/R"],

        // expose a DrawingSpec property like in mediapipe python
        ["mediapipe::autoit::solutions::drawing_utils::DrawingSpec", "DrawingSpec", "", ["/R", "=this"]],
    ], "", ""],
];
