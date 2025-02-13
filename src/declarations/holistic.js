module.exports = ({language}) => {
    const ns_face_mesh_connections = `mediapipe::${ language }::solutions::face_mesh_connections`;
    const ns_hands_connections = `mediapipe::${ language }::solutions::hands_connections`;
    const ns_pose_connections = `mediapipe::${ language }::solutions::pose_connections`;

    return [
        [`mediapipe.${ language }.solutions.holistic.`, "", ["/Properties"], [
            ["std::vector<std::tuple<int, int>>", "FACEMESH_CONTOURS", "", [`/RExpr=${ ns_face_mesh_connections }::FACEMESH_CONTOURS`]],
            ["std::vector<std::tuple<int, int>>", "FACEMESH_TESSELATION", "", [`/RExpr=${ ns_face_mesh_connections }::FACEMESH_TESSELATION`]],
            [`mediapipe::${ language }::solutions::hands::HandLandmark`, "HandLandmark", "", ["/R", "=this", "/S"]],
            ["std::vector<std::tuple<int, int>>", "HAND_CONNECTIONS", "", [`/RExpr=${ ns_hands_connections }::HAND_CONNECTIONS`]],
            [`mediapipe::${ language }::solutions::pose::PoseLandmark`, "PoseLandmark", "", ["/R", "=this", "/S"]],
            ["std::vector<std::tuple<int, int>>", "POSE_CONNECTIONS", "", [`/RExpr=${ ns_pose_connections }::POSE_CONNECTIONS`]],
        ], "", ""],
    ];
};
