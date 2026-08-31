const ns = "mediapipe::tasks::components::containers";
const nsProgId = ns.replaceAll("::", ".");

module.exports = ({cname, language, self_get}) => {
    const progid = `mediapipe.tasks.${ language }.components.containers.rect`;

    return [
        // expose rect properties like in mediapipe python
        [`${ progid }.`, "", ["/Properties"], [
            [`${ ns }::Rect`, "Rect", "", ["/R", "=this", "/S"]],
            [`${ ns }::RectF`, "RectF", "", ["/R", "=this", "/S"]],
            [`${ ns }::NormalizedRect`, "NormalizedRect", "", ["/R", "=this", "/S"]],
        ], "", ""],

        [`struct ${ nsProgId }.Rect`, "", [`/progid=${ progid }.Rect`, "/Simple", "/DC"], [
            ["int", "left", "", ["/RW"]],
            ["int", "top", "", ["/RW"]],
            ["int", "right", "", ["/RW"]],
            ["int", "bottom", "", ["/RW"]],

            ["int", "origin_x", "", ["/RW", "/NoDC", "=left", `/WExpr=const auto _width = ${ self_get("right") } - ${ self_get("left") }; ${ self_get("left") } = $value; ${ self_get("right") } = $value + _width`]],
            ["int", "origin_y", "", ["/RW", "/NoDC", "=top", `/WExpr=const auto _height = ${ self_get("bottom") } - ${ self_get("top") }; ${ self_get("top") } = $value; ${ self_get("bottom") } = $value + _height`]],
            ["int", "width", "", ["/RW", "/NoDC", `/RExpr=${ self_get("right") } - ${ self_get("left") }`, `/WExpr=${ self_get("right") } = ${ self_get("left") } + $value`]],
            ["int", "height", "", ["/RW", "/NoDC", `/RExpr=${ self_get("bottom") } - ${ self_get("top") }`, `/WExpr=${ self_get("bottom") } = ${ self_get("top") } + $value`]],
        ], "", ""],

        [`${ nsProgId }.Rect.Rect`, "", ["/Expr=", `/DC=
            if (origin_x) { const auto _width = ${ self_get("right") } - ${ self_get("left") }; ${ self_get("left") } = *origin_x; ${ self_get("right") } = *origin_x + _width; }
            if (origin_y) { const auto _height = ${ self_get("bottom") } - ${ self_get("top") }; ${ self_get("top") } = *origin_y; ${ self_get("bottom") } = *origin_y + _height; }
            if (width) { ${ self_get("right") } = ${ self_get("left") } + *width; }
            if (height) { ${ self_get("bottom") } = ${ self_get("top") } + *height; }
        `.replace(/^ {8}/mg, "").trim()], [
            ["std::optional<int>", "origin_x", "std::nullopt", []],
            ["std::optional<int>", "origin_y", "std::nullopt", []],
            ["std::optional<int>", "width", "std::nullopt", []],
            ["std::optional<int>", "height", "std::nullopt", []],
        ], "", ""],

        [`struct ${ nsProgId }.RectF`, "", [`/progid=${ progid }.RectF`, "/Simple", "/DC"], [
            ["float", "left", "", ["/RW"]],
            ["float", "top", "", ["/RW"]],
            ["float", "right", "", ["/RW"]],
            ["float", "bottom", "", ["/RW"]],
        ], "", ""],

        [`struct ${ nsProgId }.NormalizedRect`, "", [`/progid=${ progid }.NormalizedRect`, "/Simple", "/DC"], [
            ["float", "x_center", "", ["/RW"]],
            ["float", "y_center", "", ["/RW"]],
            ["float", "width", "", ["/RW"]],
            ["float", "height", "", ["/RW"]],
            ["std::optional<float>", "rotation", "std::optional<float>(0.0f)", ["/RW"]],
            ["std::optional<int64_t>", "rect_id", "std::nullopt", ["/RW"]],
        ], "", ""],
    ];
};
