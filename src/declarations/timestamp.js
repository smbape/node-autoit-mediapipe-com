module.exports = ({self, language}) => [
    ["class mediapipe.Timestamp", "", [], [
        ["int64_t", "value", "", ["/R", "=Value()"]],
        ["Timestamp", "UNSET", "", ["/R", "=Unset()", "/S"]],
        ["Timestamp", "UNSTARTED", "", ["/R", "=Unstarted()", "/S"]],
        ["Timestamp", "PRESTREAM", "", ["/R", "=PreStream()", "/S"]],
        ["Timestamp", "MIN", "", ["/R", "=Min()", "/S"]],
        ["Timestamp", "MAX", "", ["/R", "=Max()", "/S"]],
        ["Timestamp", "POSTSTREAM", "", ["/R", "=PostStream()", "/S"]],
        ["Timestamp", "DONE", "", ["/R", "=Done()", "/S"]],
    ], "", ""],

    ["mediapipe.Timestamp.Timestamp", "mediapipe.Timestamp.Timestamp", [], [
        ["Timestamp", "timestamp", "", ["/Ref", "/C"]],
    ], "", ""],

    ["mediapipe.Timestamp.Timestamp", "mediapipe.Timestamp.Timestamp", [], [
        ["int64_t", "timestamp", "", []],
    ], "", ""],

    ["mediapipe.Timestamp.eq", "bool", ["/Call=", "/Expr=a == b", "/S"], [
        ["Timestamp", "a", "", ["/Ref", "/C"]],
        ["Timestamp", "b", "", ["/Ref", "/C"]],
    ], "", ""],

    ["mediapipe.Timestamp.operator==", "bool", ["=eq"], [
        ["Timestamp", "other", "", ["/Ref", "/C"]],
    ], "", ""],

    ["mediapipe.Timestamp.ne", "bool", ["/Call=", "/Expr=a != b", "/S"], [
        ["Timestamp", "a", "", ["/Ref", "/C"]],
        ["Timestamp", "b", "", ["/Ref", "/C"]],
    ], "", ""],

    ["mediapipe.Timestamp.operator!=", "bool", ["=ne"], [
        ["Timestamp", "other", "", ["/Ref", "/C"]],
    ], "", ""],

    ["mediapipe.Timestamp.lt", "bool", ["/Call=", "/Expr=a < b", "/S"], [
        ["Timestamp", "a", "", ["/Ref", "/C"]],
        ["Timestamp", "b", "", ["/Ref", "/C"]],
    ], "", ""],

    ["mediapipe.Timestamp.operator<", "bool", ["=lt"], [
        ["Timestamp", "other", "", ["/Ref", "/C"]],
    ], "", ""],

    ["mediapipe.Timestamp.gt", "bool", ["/Call=", "/Expr=a > b", "/S"], [
        ["Timestamp", "a", "", ["/Ref", "/C"]],
        ["Timestamp", "b", "", ["/Ref", "/C"]],
    ], "", ""],

    ["mediapipe.Timestamp.operator>", "bool", ["=gt"], [
        ["Timestamp", "other", "", ["/Ref", "/C"]],
    ], "", ""],

    ["mediapipe.Timestamp.le", "bool", ["/Call=", "/Expr=a <= b", "/S"], [
        ["Timestamp", "a", "", ["/Ref", "/C"]],
        ["Timestamp", "b", "", ["/Ref", "/C"]],
    ], "", ""],

    ["mediapipe.Timestamp.operator<=", "bool", ["=le"], [
        ["Timestamp", "other", "", ["/Ref", "/C"]],
    ], "", ""],

    ["mediapipe.Timestamp.ge", "bool", ["/Call=", "/Expr=a >= b", "/S"], [
        ["Timestamp", "a", "", ["/Ref", "/C"]],
        ["Timestamp", "b", "", ["/Ref", "/C"]],
    ], "", ""],

    ["mediapipe.Timestamp.operator>=", "bool", ["=ge"], [
        ["Timestamp", "other", "", ["/Ref", "/C"]],
    ], "", ""],

    ["mediapipe.Timestamp.Seconds", "double", ["=seconds"], [], "", ""],
    ["mediapipe.Timestamp.Microseconds", "int64_t", ["=microseconds"], [], "", ""],
    ["mediapipe.Timestamp.IsSpecialValue", "bool", ["=is_special_value"], [], "", ""],
    ["mediapipe.Timestamp.IsRangeValue", "bool", ["=is_range_value"], [], "", ""],
    ["mediapipe.Timestamp.IsAllowedInStream", "bool", ["=is_allowed_in_stream"], [], "", ""],

    ["mediapipe.Timestamp.FromSeconds", "Timestamp", ["=from_seconds", "/S"], [
        ["double", "seconds", "", []],
    ], "", ""],

    ["mediapipe.Timestamp.str", "std::string", [`/Output=\"<mediapipe.Timestamp with value: \" + mediapipe::${ language }::TimestampValueString(${ self }) + \">\"`], [], "", ""],

    // expose a Timestamp property like in mediapipe python
    [`mediapipe.${ language }._framework_bindings.timestamp.`, "", ["/Properties"], [
        ["mediapipe::Timestamp", "Timestamp", "", ["/R", "=this", "/S"]],
    ], "", ""],
];
