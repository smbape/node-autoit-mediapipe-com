const ns_face_mesh_connections = "mediapipe::autoit::solutions::face_mesh_connections";
const ns_hands_connections = "mediapipe::autoit::solutions::hands_connections";
const ns_pose_connections = "mediapipe::autoit::solutions::pose_connections";

module.exports = [
    ["mediapipe.autoit.solutions.holistic.", "", ["/Properties"], [
        ["std::vector<std::tuple<int, int>>", "FACEMESH_CONTOURS", "", [`/RExpr=${ ns_face_mesh_connections }::FACEMESH_CONTOURS`]],
        ["std::vector<std::tuple<int, int>>", "FACEMESH_TESSELATION", "", [`/RExpr=${ ns_face_mesh_connections }::FACEMESH_TESSELATION`]],
        ["mediapipe::autoit::solutions::hands::HandLandmark", "HandLandmark", "", ["/R", "=this"]],
        ["std::vector<std::tuple<int, int>>", "HAND_CONNECTIONS", "", [`/RExpr=${ ns_hands_connections }::HAND_CONNECTIONS`]],
        ["mediapipe::autoit::solutions::pose::PoseLandmark", "PoseLandmark", "", ["/R", "=this"]],
        ["std::vector<std::tuple<int, int>>", "POSE_CONNECTIONS", "", [`/RExpr=${ ns_pose_connections }::POSE_CONNECTIONS`]],
    ], "", ""],
];
