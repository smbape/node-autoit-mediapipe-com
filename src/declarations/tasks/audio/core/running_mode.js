const ns = "mediapipe::tasks::audio::core";
const nsProgId = ns.replaceAll("::", ".");

module.exports = ({language}) => {
    const progid = `mediapipe.tasks.${ language }.audio.core.audio_task_running_mode`;

    return [
        // expose audio properties like in mediapipe python
        [`${ progid }.`, "", ["/Properties"], [
            [`${ ns }::RunningMode`, "AudioTaskRunningMode", "", ["/R", "=this", "/S"]],
        ], "", ""],

        [`enum ${ nsProgId }.RunningMode`, "", [`/progid=${ progid }.AudioTaskRunningMode`], [
            ["const mediapipe.tasks.audio.core.AUDIO_CLIPS", "1", []],
            ["const mediapipe.tasks.audio.core.AUDIO_STREAM", "2", []],
        ], "", ""],
    ];
};
