const ns_face_mesh_connections = "mediapipe::autoit::solutions::face_mesh_connections";

module.exports = [
    ["mediapipe.autoit.solutions.face_mesh.", "", ["/Properties"], [
        ["int", "FACEMESH_NUM_LANDMARKS", "", ["/R"]],
        ["int", "FACEMESH_NUM_LANDMARKS_WITH_IRISES", "", ["/R"]],
        ["std::vector<std::tuple<int, int>>", "FACEMESH_CONTOURS", "", [`/RExpr=${ ns_face_mesh_connections }::FACEMESH_CONTOURS`]],
        ["std::vector<std::tuple<int, int>>", "FACEMESH_FACE_OVAL", "", [`/RExpr=${ ns_face_mesh_connections }::FACEMESH_FACE_OVAL`]],
        ["std::vector<std::tuple<int, int>>", "FACEMESH_IRISES", "", [`/RExpr=${ ns_face_mesh_connections }::FACEMESH_IRISES`]],
        ["std::vector<std::tuple<int, int>>", "FACEMESH_LEFT_EYE", "", [`/RExpr=${ ns_face_mesh_connections }::FACEMESH_LEFT_EYE`]],
        ["std::vector<std::tuple<int, int>>", "FACEMESH_LEFT_EYEBROW", "", [`/RExpr=${ ns_face_mesh_connections }::FACEMESH_LEFT_EYEBROW`]],
        ["std::vector<std::tuple<int, int>>", "FACEMESH_LEFT_IRIS", "", [`/RExpr=${ ns_face_mesh_connections }::FACEMESH_LEFT_IRIS`]],
        ["std::vector<std::tuple<int, int>>", "FACEMESH_LIPS", "", [`/RExpr=${ ns_face_mesh_connections }::FACEMESH_LIPS`]],
        ["std::vector<std::tuple<int, int>>", "FACEMESH_RIGHT_EYE", "", [`/RExpr=${ ns_face_mesh_connections }::FACEMESH_RIGHT_EYE`]],
        ["std::vector<std::tuple<int, int>>", "FACEMESH_RIGHT_EYEBROW", "", [`/RExpr=${ ns_face_mesh_connections }::FACEMESH_RIGHT_EYEBROW`]],
        ["std::vector<std::tuple<int, int>>", "FACEMESH_RIGHT_IRIS", "", [`/RExpr=${ ns_face_mesh_connections }::FACEMESH_RIGHT_IRIS`]],
        ["std::vector<std::tuple<int, int>>", "FACEMESH_TESSELATION", "", [`/RExpr=${ ns_face_mesh_connections }::FACEMESH_TESSELATION`]],
    ], "", ""],
];
