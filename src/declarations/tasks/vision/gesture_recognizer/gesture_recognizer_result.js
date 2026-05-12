module.exports = ({language}) => {
    const progid = `mediapipe.tasks.${ language }.vision.gesture_recognizer_result`;

    return [
        // expose gesture_recognizer_result properties like in mediapipe python
        [`${ progid }.`, "", ["/Properties"], [
            [`mediapipe::tasks::${ language }::vision::gesture_recognizer::GestureRecognizerResult`, "GestureRecognizerResult", "", ["/R", "=this", "/S"]],
        ], "", ""],

        [`struct mediapipe.tasks.${ language }.vision.gesture_recognizer.GestureRecognizerResult`, "", [`/progid=${ progid }.GestureRecognizerResult`, "/Simple", "/DC"], [
            ["std::vector<std::vector<components::containers::Category>>", "gestures", "", ["/RW"]],
            ["std::vector<std::vector<components::containers::Category>>", "handedness", "", ["/RW"]],
            ["std::vector<std::vector<components::containers::NormalizedLandmark>>", "hand_landmarks", "", ["/RW"]],
            ["std::vector<std::vector<components::containers::Landmark>>", "hand_world_landmarks", "", ["/RW"]],
        ], "", ""],
    ];
};
