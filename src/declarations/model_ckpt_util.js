module.exports = ({ ENABLE_ODML_CONVERTER }) => {
    // TODO : odml is not a public repository. How to test?
    if (!ENABLE_ODML_CONVERTER) {
        return [];
    }

    return [
        ["mediapipe.autoit._framework_bindings.model_ckpt_util.GenerateCpuTfLite", "bool", ["/S", "/Call=odml::infra::xnn_utils::GenerateTfLite", "/Output=$0.ok()"], [
            ["std::string", "model_type", "", ["/Ref", "/C"]],
            ["std::string", "weight_path", "", ["/Ref", "/C"]],
            ["std::string", "vocab_model_file", "", ["/Ref", "/C"]],
            ["bool", "arg3", "", []],
            ["std::string", "output_tflite_file", "", ["/Ref", "/C"]],
        ], "", ""],
        ["mediapipe.autoit._framework_bindings.model_ckpt_util.GenerateGpuTfLite", "bool", ["/S", "/Call=odml::infra::gpu::GenerateTfLite", "/Output=$0.ok()"], [
            ["std::string", "model_type", "", ["/Ref", "/C"]],
            ["std::string", "weight_path", "", ["/Ref", "/C"]],
            ["std::string", "vocab_model_file", "", ["/Ref", "/C"]],
            ["bool", "arg3", "", []],
            ["std::string", "output_tflite_file", "", ["/Ref", "/C"]],
        ], "", ""],
        ["mediapipe.autoit._framework_bindings.model_ckpt_util.ConvertHfTokenizer", "bool", ["/S", "/Call=mediapipe::tasks::text::ConvertHfTokenizer", "/Output=$0.ok()"], [
            ["std::string", "hf_tokenizer", "", ["/Ref", "/C"]],
            ["std::string", "output_vocab_path", "", ["/Ref", "/C"]],
        ], "", ""],
    ];
};
