#include "mediapipe/framework/port/status_macros.h"
#include "binding/tasks/text/text_embedder.h"
#include "binding/packet_getter.h"
#include "binding/packet_creator.h"

namespace {
	using namespace mediapipe::tasks::text::text_embedder::proto;
	using namespace mediapipe::tasks::autoit::components::containers::embedding_result;
	using namespace mediapipe::tasks::autoit::core::base_options;
	using namespace mediapipe::tasks::autoit::core::task_info;
	using namespace mediapipe::tasks::autoit::components::utils;
	using namespace mediapipe::autoit::packet_getter;

	const std::string _EMBEDDINGS_OUT_STREAM_NAME = "embeddings_out";
	const std::string _EMBEDDINGS_TAG = "EMBEDDINGS";
	const std::string _TEXT_IN_STREAM_NAME = "text_in";
	const std::string _TEXT_TAG = "TEXT";
	const std::string _TASK_GRAPH_NAME = "mediapipe.tasks.text.text_embedder.TextEmbedderGraph";
}

namespace mediapipe::tasks::autoit::text::text_embedder {
	absl::StatusOr<std::shared_ptr<TextEmbedderGraphOptions>> TextEmbedderOptions::to_pb2() const {
		auto pb2_obj = std::make_shared<TextEmbedderGraphOptions>();

		if (base_options) {
			MP_ASSIGN_OR_RETURN(auto base_options_proto, base_options->to_pb2());
			pb2_obj->mutable_base_options()->CopyFrom(*base_options_proto);
		}
		if (l2_normalize) pb2_obj->mutable_embedder_options()->set_l2_normalize(*l2_normalize);
		if (quantize) pb2_obj->mutable_embedder_options()->set_quantize(*quantize);

		return pb2_obj;
	}

	absl::StatusOr<std::shared_ptr<TextEmbedder>> TextEmbedder::create(
		const CalculatorGraphConfig& graph_config
	) {
		using BaseTextTaskApi = core::base_text_task_api::BaseTextTaskApi;
		return BaseTextTaskApi::create(graph_config, static_cast<TextEmbedder*>(nullptr));
	}

	absl::StatusOr<std::shared_ptr<TextEmbedder>> TextEmbedder::create_from_model_path(const std::string& model_path) {
		auto base_options = std::make_shared<BaseOptions>(model_path);
		return create_from_options(std::make_shared<TextEmbedderOptions>(base_options));
	}

	absl::StatusOr<std::shared_ptr<TextEmbedder>> TextEmbedder::create_from_options(std::shared_ptr<TextEmbedderOptions> options) {
		TaskInfo task_info;
		task_info.task_graph = _TASK_GRAPH_NAME;
		*task_info.input_streams = { _TEXT_TAG + ":" + _TEXT_IN_STREAM_NAME };
		*task_info.output_streams = { _EMBEDDINGS_TAG + ":" + _EMBEDDINGS_OUT_STREAM_NAME };
		MP_ASSIGN_OR_RETURN(task_info.task_options, options->to_pb2());

		MP_ASSIGN_OR_RETURN(auto config, task_info.generate_graph_config());

		return create(*config);
	}

	absl::StatusOr<std::shared_ptr<TextEmbedderResult>> TextEmbedder::embed(const std::string& text) {
		MP_ASSIGN_OR_RETURN(auto output_packets, _runner->Process({
			{ _TEXT_IN_STREAM_NAME, std::move(MakePacket<std::string>(text)) }
			}));

		MP_PACKET_ASSIGN_OR_RETURN(const auto& embedding_result_proto, mediapipe::tasks::components::containers::proto::EmbeddingResult, output_packets.at(_EMBEDDINGS_OUT_STREAM_NAME));
		return TextEmbedderResult::create_from_pb2(embedding_result_proto);
	}

	absl::StatusOr<float> TextEmbedder::cosine_similarity(const Embedding& u, const Embedding& v) {
		return cosine_similarity::cosine_similarity(u, v);
	}
}
