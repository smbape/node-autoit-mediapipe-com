const ns = "mediapipe::tasks::components::containers";
const nsProgId = ns.replaceAll("::", ".");

module.exports = ({language, self_get}) => {
    const progid = `mediapipe.tasks.${ language }.components.containers.embedding_result`;

    const isFloatEmbedding = `!${ self_get("float_embedding") }.empty()`;
    const isQuantizedEmbedding = `!${ self_get("quantized_embedding") }.empty()`;

    const converFloatEmbeddingToMat = `std::make_shared<cv::Mat>(${ self_get("float_embedding") }.size(), 1, CV_32F, static_cast<void *>(${ self_get("float_embedding") }.data()))`;
    const converQuantizedEmbeddingToMat = `std::make_shared<cv::Mat>(${ self_get("quantized_embedding") }.size(), 1, CV_8U, static_cast<void *>(${ self_get("quantized_embedding") }.data()))`;
    const getterEmbedding = `${ isFloatEmbedding } ? ${ converFloatEmbeddingToMat } : ${ isQuantizedEmbedding } ? ${ converQuantizedEmbeddingToMat } : std::make_shared<cv::Mat>()`;

    const setterEmbedding = `
        std::shared_ptr<cv::Mat> value;
        hr = autoit_to($value, value);
        if (FAILED(hr)) {
            return hr;
        }

        if (value->depth() == CV_32F) {
            ${ self_get("float_embedding") }.assign(value->ptr<float>(), value->ptr<float>() + value->total() * value->channels());
            ${ self_get("quantized_embedding") }.clear();
        } else if (value->depth() == CV_8U) {
            ${ self_get("float_embedding") }.clear();
            ${ self_get("quantized_embedding") }.assign(value->ptr<char>(), value->ptr<char>() + value->total() * value->channels());
        } else {
            hr = E_FAIL;
        }
    `.replace(/^ {8}/mg, "").trim();

    return [
        // expose embedding_result properties like in mediapipe python
        [`${ progid }.`, "", ["/Properties"], [
            [`${ ns }::Embedding`, "Embedding", "", ["/R", "=this", "/S"]],
            [`${ ns }::EmbeddingResult`, "EmbeddingResult", "", ["/R", "=this", "/S"]],
        ], "", ""],

        [`struct ${ nsProgId }.Embedding`, "", [`/progid=${ progid }.Embedding`, "/Simple"], [
            ["std::vector<float>", "float_embedding", "", ["/RW"]],
            ["std::string", "quantized_embedding", "", ["/RW", "/WType=std::variant<std::string, std::vector<unsigned char>>", "/WIDL=VARIANT*", `/WExpr=
                std::variant<std::string, std::vector<unsigned char>> value;
                hr = autoit_to($value, value);
                if (FAILED(hr)) {
                    return hr;
                }

                if (std::holds_alternative<std::string>(value)) {
                    auto& values = std::get<std::string>(value);
                    $0.assign(reinterpret_cast<char*>(values.data()), reinterpret_cast<char*>(values.data()) + values.size());
                } else {
                    auto& values = std::get<std::vector<unsigned char>>(value);
                    $0.assign(reinterpret_cast<char*>(values.data()), reinterpret_cast<char*>(values.data()) + values.size());
                }
            `.replace(/^ {16}/mg, "").trim()]],
            ["int", "head_index", "", ["/RW"]],
            ["std::optional<std::string>", "head_name", "std::nullopt", ["/RW"]],

            ["std::shared_ptr<cv::Mat>", "embedding", "", ["/RW", `/RExpr=${ getterEmbedding }`, `/WExpr=${ setterEmbedding }`]],
        ], "", ""],

        [`${ nsProgId }.Embedding.Embedding`, "", ["/Expr=", `/DC=
            if (!embedding.isContinuous()) { embedding = embedding.clone(); }
            if (embedding.depth() == CV_32F) { ${ self_get("float_embedding") }.assign(embedding.ptr<float>(), embedding.ptr<float>() + embedding.total() * embedding.channels()); }
            else if (embedding.depth() == CV_8U) { ${ self_get("quantized_embedding") }.assign(embedding.ptr<char>(), embedding.ptr<char>() + embedding.total() * embedding.channels()); }
            else { hr = E_FAIL; }
            if (head_index) { ${ self_get("head_index") } = *head_index; }
            if (head_name) { ${ self_get("head_name") } = *head_name; }
        `.replace(/^ {12}/mg, "").trim()], [
            ["cv::Mat", "embedding", "", []],
            ["std::optional<int>", "head_index", "std::nullopt", []],
            ["std::optional<std::string>", "head_name", "std::nullopt", []],
        ], "", ""],

        [`${ nsProgId }.Embedding.Embedding`, "", ["/Expr=", `/DC=
            if (float_embedding) { ${ self_get("float_embedding") } = *float_embedding; }
            if (quantized_embedding) {
                auto& value = *quantized_embedding;
                if (std::holds_alternative<std::string>(value)) {
                    auto& values = std::get<std::string>(value);
                    ${ self_get("quantized_embedding") }.assign(reinterpret_cast<char*>(values.data()), reinterpret_cast<char*>(values.data()) + values.size());
                } else {
                    auto& values = std::get<std::vector<unsigned char>>(value);
                    ${ self_get("quantized_embedding") }.assign(reinterpret_cast<char*>(values.data()), reinterpret_cast<char*>(values.data()) + values.size());
                }
            }
            if (head_index) { ${ self_get("head_index") } = *head_index; }
            if (head_name) { ${ self_get("head_name") } = *head_name; }
        `.replace(/^ {12}/mg, "").trim()], [
            ["std::optional<std::vector<float>>", "float_embedding", "std::nullopt", []],
            ["std::optional<std::variant<std::string, std::vector<unsigned char>>>", "quantized_embedding", "std::nullopt", []],
            ["std::optional<int>", "head_index", "std::nullopt", []],
            ["std::optional<std::string>", "head_name", "std::nullopt", []],
        ], "", ""],

        [`struct ${ nsProgId }.EmbeddingResult`, "", [`/progid=${ progid }.EmbeddingResult`, "/Simple", "/DC"], [
            ["std::vector<Embedding>", "embeddings", "", ["/RW"]],
            ["std::optional<int64_t>", "timestamp_ms", "std::nullopt", ["/RW"]],
        ], "", ""],
    ];
};
