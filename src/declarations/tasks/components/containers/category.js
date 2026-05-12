const ns = "mediapipe::tasks::components::containers";
const nsProgId = ns.replaceAll("::", ".");

module.exports = ({language}) => {
    const progid = `mediapipe.tasks.${ language }.components.containers.category`;

    return [
        // expose category properties like in mediapipe python
        [`${ progid }.`, "", ["/Properties"], [
            [`${ ns }::Category`, "Category", "", ["/R", "=this", "/S"]],
        ], "", ""],

        [`struct ${ nsProgId }.Category`, "", [`/progid=${ progid }.Category`, "/Simple", "/DC"], [
            ["int", "index", "-1", ["/RW"]],
            ["float", "score", "", ["/RW"]],
            ["std::optional<std::string>", "category_name", "std::nullopt", ["/RW"]],
            ["std::optional<std::string>", "display_name", "std::nullopt", ["/RW"]],
        ], "", ""],
    ];
};
