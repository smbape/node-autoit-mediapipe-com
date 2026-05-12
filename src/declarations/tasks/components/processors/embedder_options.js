const ns = "mediapipe::tasks::components::processors";
const nsProgId = ns.replaceAll("::", ".");

module.exports = ({language}) => {
    const progid = `mediapipe.tasks.${ language }.components.processors.embedder_options`;

    return [
        // expose embedder_options properties like in mediapipe python
        [`${ progid }.`, "", ["/Properties"], [
            [`${ ns }::EmbedderOptions`, "EmbedderOptions", "", ["/R", "=this", "/S"]],
        ], "", ""],

        [`struct ${ nsProgId }.EmbedderOptions`, "", [`/progid=${ progid }.EmbedderOptions`, "/Simple", "/DC"], [
            ["bool", "l2_normalize", "", ["/RW"]],
            ["bool", "quantize", "", ["/RW"]],
        ], "", ""],
    ];
};
