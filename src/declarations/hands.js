module.exports = ({language}) => {
    const ns_hands_connections = `mediapipe::${ language }::solutions::hands_connections`;

    return [
        [`mediapipe.${ language }.solutions.hands.`, "", ["/Properties"], [
            ["std::vector<std::tuple<int, int>>", "HAND_CONNECTIONS", "", [`/RExpr=${ ns_hands_connections }::HAND_CONNECTIONS`]],
        ], "", ""],
    ];
};
