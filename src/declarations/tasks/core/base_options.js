const ns = "mediapipe::tasks::core";
const nsProgId = ns.replaceAll("::", ".");
const hostSystemMap = new Map([
  ["linux", "HOST_SYSTEM_LINUX"],
  ["darwin", "HOST_SYSTEM_MAC"],
  ["win32", "HOST_SYSTEM_WINDOWS"],
  // ["", "HOST_SYSTEM_IOS"],
  // ["", "HOST_SYSTEM_ANDROID"],
]);
const host_system = hostSystemMap.has(process.platform) ? hostSystemMap.get(process.platform) : "HOST_SYSTEM_UNKNOWN";

module.exports = ({language, self_get}) => {
    const progid = `mediapipe.tasks.${ language }.core.base_options`;

    return [
        // expose base_options properties like in mediapipe python
        [`${ progid }.`, "", ["/Properties"], [
            [`${ ns }::BaseOptions`, "BaseOptions", "", ["/R", "=this", "/S"]],
        ], "", ""],

        ["enum mediapipe.tasks.core.HostEnvironment", "", [], [
            ["const mediapipe.tasks.core.HOST_ENVIRONMENT_UNKNOWN", "0", []],
            ["const mediapipe.tasks.core.HOST_ENVIRONMENT_ANDROID", "1", []],
            ["const mediapipe.tasks.core.HOST_ENVIRONMENT_IOS", "2", []],
            ["const mediapipe.tasks.core.HOST_ENVIRONMENT_PYTHON", "3", []],
            ["const mediapipe.tasks.core.HOST_ENVIRONMENT_WEB", "4", []],
        ], "", ""],

        ["enum mediapipe.tasks.core.HostSystem", "", [], [
            ["const mediapipe.tasks.core.HOST_SYSTEM_UNKNOWN", "0", []],
            ["const mediapipe.tasks.core.HOST_SYSTEM_LINUX", "1", []],
            ["const mediapipe.tasks.core.HOST_SYSTEM_MAC", "2", []],
            ["const mediapipe.tasks.core.HOST_SYSTEM_WINDOWS", "3", []],
            ["const mediapipe.tasks.core.HOST_SYSTEM_IOS", "4", []],
            ["const mediapipe.tasks.core.HOST_SYSTEM_ANDROID", "5", []],
        ], "", ""],

        [`enum ${ nsProgId }.BaseOptions.Delegate`, "", [`/progid=${ progid }.BaseOptions.Delegate`], [
            [`const ${ nsProgId }.BaseOptions.CPU`, "0", [], [], "", ""],
            [`const ${ nsProgId }.BaseOptions.GPU`, "1", [], [], "", ""],
            [`const ${ nsProgId }.BaseOptions.EDGETPU_NNAPI`, "2", [], [], "", ""],
        ], "", ""],

        [`struct ${ nsProgId }.BaseOptions`, "", [`/progid=${ progid }.BaseOptions`, "/Simple", "/DC"], [
            ["std::optional<std::string>", "model_asset_buffer", "", ["/RW", "/RExpr=$0 ? std::optional<std::string>(*$0) : std::nullopt", `/WExpr=
                std::optional<std::string> value;
                hr = autoit_to($value, value);
                if (FAILED(hr)) {
                    return hr;
                }

                if (value) {
                    $0 = std::make_unique<std::string>(*value);
                } else {
                    $0.reset();
                }
            `.replace(/^ {12}/mg, "").trim()]],
            ["std::string", "model_asset_path", "", ["/RW"]],
            ["Delegate", "delegate", "BaseOptions::CPU", ["/RW"]],
            ["HostSystem", "host_system", `HostSystem::${ host_system }`, ["/RW"]],
            ["HostEnvironment", "host_environment", "HostEnvironment::HOST_ENVIRONMENT_UNKNOWN", ["/RW"]],
            ["std::string", "host_version", "", ["/RW"]],
            ["std::string", "ca_bundle_path", "", ["/RW"]],
        ], "", ""],
    ];
};
