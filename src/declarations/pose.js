module.exports = ({language}) => {
    const ns_pose_connections = `mediapipe::${ language }::solutions::pose_connections`;

    return [
        [`mediapipe.${ language }.solutions.pose.`, "", ["/Properties"], [
            ["std::vector<std::tuple<int, int>>", "POSE_CONNECTIONS", "", [`/RExpr=${ ns_pose_connections }::POSE_CONNECTIONS`, "/C"]],
            [`mediapipe::${ language }::solution_base::ExtraSettings`, "ExtraSettings", "", ["/R", "=this", "/S"]],
        ], "", ""],
    ];
};
