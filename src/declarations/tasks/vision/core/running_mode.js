module.exports = ({language}) => {
    const progid = `mediapipe.tasks.${ language }.vision.core.vision_task_running_mode`;

    return [
        // expose vision properties like in mediapipe python
        [`${ progid }.`, "", ["/Properties"], [
            ["mediapipe::tasks::vision::core::RunningMode", "VisionTaskRunningMode", "", ["/R", "=this", "/S"]],
        ], "", ""],

        ["enum mediapipe.tasks.vision.core.RunningMode", "", [`/progid=${ progid }.VisionTaskRunningMode`], [
            ["const mediapipe.tasks.vision.core.IMAGE", "1", []],
            ["const mediapipe.tasks.vision.core.VIDEO", "2", []],
            ["const mediapipe.tasks.vision.core.LIVE_STREAM", "3", []],
        ], "", ""],
    ];
};
