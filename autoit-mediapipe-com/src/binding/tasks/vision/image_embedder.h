#pragma once

#include "mediapipe/tasks/cc/components/containers/proto/embeddings.pb.h"
#include "mediapipe/tasks/cc/components/processors/proto/embedder_options.pb.h"
#include "mediapipe/tasks/cc/vision/image_embedder/proto/image_embedder_graph_options.pb.h"
#include "binding/tasks/components/containers/embedding_result.h"
#include "binding/tasks/components/utils/cosine_similarity.h"
#include "binding/tasks/core/base_options.h"
#include "binding/tasks/core/task_info.h"
#include "binding/tasks/vision/core/base_vision_task_api.h"
#include "binding/tasks/vision/core/image_processing_options.h"
#include "binding/tasks/vision/core/vision_task_running_mode.h"
#include "binding/packet_getter.h"
#include "binding/packet_creator.h"
#include <functional>

namespace mediapipe::tasks::autoit::vision::image_embedder {
	using ImageEmbedderResult = components::containers::embedding_result::EmbeddingResult;
	using ImageEmbedderResultRawCallback = void(*)(const ImageEmbedderResult&, const Image&, int64_t);
	using ImageEmbedderResultCallback = std::function<void(const ImageEmbedderResult&, const Image&, int64_t)>;

	struct CV_EXPORTS_W_SIMPLE ImageEmbedderOptions {
		CV_WRAP ImageEmbedderOptions(const ImageEmbedderOptions& other) = default;
		ImageEmbedderOptions& operator=(const ImageEmbedderOptions& other) = default;

		CV_WRAP ImageEmbedderOptions(
			std::shared_ptr<autoit::core::base_options::BaseOptions> base_options = std::shared_ptr<autoit::core::base_options::BaseOptions>(),
			core::vision_task_running_mode::VisionTaskRunningMode running_mode = tasks::autoit::vision::core::vision_task_running_mode::VisionTaskRunningMode::IMAGE,
			const std::optional<bool>& l2_normalize = std::nullopt,
			const std::optional<bool>& quantize = std::nullopt,
			ImageEmbedderResultCallback result_callback = nullptr
		)
			:
			base_options(base_options),
			running_mode(running_mode),
			l2_normalize(l2_normalize),
			quantize(quantize),
			result_callback(result_callback)
		{}

		CV_WRAP [[nodiscard]] absl::StatusOr<std::shared_ptr<mediapipe::tasks::vision::image_embedder::proto::ImageEmbedderGraphOptions>> to_pb2() const;

		CV_PROP_RW std::shared_ptr<autoit::core::base_options::BaseOptions> base_options;
		CV_PROP_RW core::vision_task_running_mode::VisionTaskRunningMode running_mode;
		CV_PROP_RW std::optional<bool> l2_normalize;
		CV_PROP_RW std::optional<bool> quantize;
		CV_PROP_W  ImageEmbedderResultCallback result_callback;
	};

	class CV_EXPORTS_W ImageEmbedder : public ::mediapipe::tasks::autoit::vision::core::base_vision_task_api::BaseVisionTaskApi {
	public:
		using core::base_vision_task_api::BaseVisionTaskApi::BaseVisionTaskApi;

		CV_WRAP [[nodiscard]] static absl::StatusOr<std::shared_ptr<ImageEmbedder>> create(
			const CalculatorGraphConfig& graph_config,
			core::vision_task_running_mode::VisionTaskRunningMode running_mode,
			mediapipe::autoit::PacketsCallback packet_callback = nullptr
		);
		CV_WRAP [[nodiscard]] static absl::StatusOr<std::shared_ptr<ImageEmbedder>> create_from_model_path(const std::string& model_path);
		CV_WRAP [[nodiscard]] static absl::StatusOr<std::shared_ptr<ImageEmbedder>> create_from_options(std::shared_ptr<ImageEmbedderOptions> options);
		CV_WRAP [[nodiscard]] absl::StatusOr<std::shared_ptr<ImageEmbedderResult>> embed(
			const Image& image,
			std::shared_ptr<core::image_processing_options::ImageProcessingOptions> image_processing_options = std::shared_ptr<core::image_processing_options::ImageProcessingOptions>()
		);
		CV_WRAP [[nodiscard]] absl::StatusOr<std::shared_ptr<ImageEmbedderResult>> embed_for_video(
			const Image& image,
			int64_t timestamp_ms,
			std::shared_ptr<core::image_processing_options::ImageProcessingOptions> image_processing_options = std::shared_ptr<core::image_processing_options::ImageProcessingOptions>()
		);
		CV_WRAP [[nodiscard]] absl::Status embed_async(
			const Image& image,
			int64_t timestamp_ms,
			std::shared_ptr<core::image_processing_options::ImageProcessingOptions> image_processing_options = std::shared_ptr<core::image_processing_options::ImageProcessingOptions>()
		);
		CV_WRAP [[nodiscard]] static absl::StatusOr<float> cosine_similarity(const components::containers::embedding_result::Embedding& u, const components::containers::embedding_result::Embedding& v);
	};
}

PTR_BRIDGE_DECL(mediapipe::tasks::autoit::vision::image_embedder::ImageEmbedderResultRawCallback);
extern const HRESULT autoit_to(VARIANT const* const& in_val, mediapipe::tasks::autoit::vision::image_embedder::ImageEmbedderResultCallback& out_val);
