const ns = "mediapipe::tasks::components::containers";
const nsProgId = ns.replaceAll("::", ".");

module.exports = ({language}) => {
    const progid = `mediapipe.tasks.${ language }.components.containers.classification_result`;

    return [
        // expose classification_result properties like in mediapipe python
        [`${ progid }.`, "", ["/Properties"], [
            [`${ ns }::Classifications`, "Classifications", "", ["/R", "=this", "/S"]],
            [`${ ns }::ClassificationResult`, "ClassificationResult", "", ["/R", "=this", "/S"]],
        ], "", ""],

        [`struct ${ nsProgId }.Classifications`, "", [`/progid=${ progid }.Classifications`, "/Simple", "/DC"], [
            ["std::vector<Category>", "categories", "", ["/RW"]],
            ["int", "head_index", "", ["/RW"]],
            ["std::optional<std::string>", "head_name", "std::nullopt", ["/RW"]],
        ], "", ""],

        [`struct ${ nsProgId }.ClassificationResult`, "", [`/progid=${ progid }.ClassificationResult`, "/Simple", "/DC"], [
            ["std::vector<Classifications>", "classifications", "", ["/RW"]],
            ["std::optional<int64_t>", "timestamp_ms", "", ["/RW"]],
        ], "", ""],
    ];
};
