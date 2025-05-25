#pragma once

#include "mediapipe/tasks/cc/text/text_embedder/proto/text_embedder_graph_options.pb.h"
#include "mediapipe/tasks/cc/components/containers/proto/embeddings.pb.h"
#include "mediapipe/tasks/cc/components/processors/proto/embedder_options.pb.h"
#include "binding/tasks/text/core/base_text_task_api.h"
#include "binding/tasks/components/containers/embedding_result.h"
#include "binding/tasks/components/utils/cosine_similarity.h"
#include "binding/tasks/core/base_options.h"
#include "binding/tasks/core/task_info.h"

namespace mediapipe::tasks::autoit::text::text_embedder {
	using TextEmbedderResult = components::containers::embedding_result::EmbeddingResult;

	struct CV_EXPORTS_W_SIMPLE TextEmbedderOptions {
		CV_WRAP TextEmbedderOptions(const TextEmbedderOptions& other) = default;
		TextEmbedderOptions& operator=(const TextEmbedderOptions& other) = default;

		CV_WRAP TextEmbedderOptions(
			std::shared_ptr<autoit::core::base_options::BaseOptions> base_options = std::shared_ptr<autoit::core::base_options::BaseOptions>(),
			const std::optional<bool>& l2_normalize = std::nullopt,
			const std::optional<bool>& quantize = std::nullopt
		)
			:
			base_options(base_options),
			l2_normalize(l2_normalize),
			quantize(quantize)
		{}

		CV_WRAP [[nodiscard]] absl::StatusOr<std::shared_ptr<mediapipe::tasks::text::text_embedder::proto::TextEmbedderGraphOptions>> to_pb2() const;

		CV_PROP_RW std::shared_ptr<autoit::core::base_options::BaseOptions> base_options;
		CV_PROP_RW std::optional<bool> l2_normalize;
		CV_PROP_RW std::optional<bool> quantize;
	};

	class CV_EXPORTS_W TextEmbedder : public ::mediapipe::tasks::autoit::text::core::base_text_task_api::BaseTextTaskApi {
	public:
		using core::base_text_task_api::BaseTextTaskApi::BaseTextTaskApi;

		CV_WRAP [[nodiscard]] static absl::StatusOr<std::shared_ptr<TextEmbedder>> create(
			const CalculatorGraphConfig& graph_config
		);
		CV_WRAP [[nodiscard]] static absl::StatusOr<std::shared_ptr<TextEmbedder>> create_from_model_path(const std::string& model_path);
		CV_WRAP [[nodiscard]] static absl::StatusOr<std::shared_ptr<TextEmbedder>> create_from_options(std::shared_ptr<TextEmbedderOptions> options);
		CV_WRAP [[nodiscard]] absl::StatusOr<std::shared_ptr<TextEmbedderResult>> embed(const std::string& text);
		CV_WRAP [[nodiscard]] static absl::StatusOr<float> cosine_similarity(const components::containers::embedding_result::Embedding& u, const components::containers::embedding_result::Embedding& v);
	};
}
