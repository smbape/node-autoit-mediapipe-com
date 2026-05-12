const ns = "mediapipe::tasks::components::processors";
const nsProgId = ns.replaceAll("::", ".");

module.exports = ({language}) => {
    const progid = `mediapipe.tasks.${ language }.components.processors.classifier_options`;

    return [
        // expose classifier_options properties like in mediapipe python
        [`${ progid }.`, "", ["/Properties"], [
            [`${ ns }::ClassifierOptions`, "ClassifierOptions", "", ["/R", "=this", "/S"]],
        ], "", ""],

        [`struct ${ nsProgId }.ClassifierOptions`, "", [`/progid=${ progid }.ClassifierOptions`, "/Simple", "/DC"], [
            ["std::string", "display_names_locale", "\"en\"", ["/RW"]],
            ["int", "max_results", "-1", ["/RW"]],
            ["float", "score_threshold", "0.0f", ["/RW"]],
            ["std::vector<std::string>", "category_allowlist", "{}", ["/RW"]],
            ["std::vector<std::string>", "category_denylist", "{}", ["/RW"]],
        ], "", ""],
    ];
};
