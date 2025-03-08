#pragma once

#include "mediapipe/tasks/cc/vision/face_stylizer/proto/face_stylizer_graph_options.pb.h"
#include "binding/tasks/core/base_options.h"
#include "binding/tasks/core/task_info.h"
#include "binding/tasks/vision/core/base_vision_task_api.h"
#include "binding/tasks/vision/core/image_processing_options.h"
#include "binding/packet_getter.h"
#include "binding/packet_creator.h"
#include <functional>

namespace mediapipe::tasks::autoit::vision::face_stylizer {
	struct CV_EXPORTS_W_SIMPLE FaceStylizerOptions {
		CV_WRAP FaceStylizerOptions(const FaceStylizerOptions& other) = default;
		FaceStylizerOptions& operator=(const FaceStylizerOptions& other) = default;

		CV_WRAP FaceStylizerOptions(
			std::shared_ptr<autoit::core::base_options::BaseOptions> base_options = std::shared_ptr<autoit::core::base_options::BaseOptions>()
		)
			:
			base_options(base_options)
		{}

		CV_WRAP [[nodiscard]] absl::StatusOr<std::shared_ptr<mediapipe::tasks::vision::face_stylizer::proto::FaceStylizerGraphOptions>> to_pb2() const;

		CV_PROP_RW std::shared_ptr<autoit::core::base_options::BaseOptions> base_options;
	};

	class CV_EXPORTS_W FaceStylizer : public ::mediapipe::tasks::autoit::vision::core::base_vision_task_api::BaseVisionTaskApi {
	public:
		using core::base_vision_task_api::BaseVisionTaskApi::BaseVisionTaskApi;

		CV_WRAP [[nodiscard]] static absl::StatusOr<std::shared_ptr<FaceStylizer>> create(
			const CalculatorGraphConfig& graph_config,
			core::vision_task_running_mode::VisionTaskRunningMode running_mode,
			mediapipe::autoit::PacketsCallback packet_callback = nullptr
		);
		CV_WRAP [[nodiscard]] static absl::StatusOr<std::shared_ptr<FaceStylizer>> create_from_model_path(const std::string& model_path);
		CV_WRAP [[nodiscard]] static absl::StatusOr<std::shared_ptr<FaceStylizer>> create_from_options(std::shared_ptr<FaceStylizerOptions> options);
		CV_WRAP [[nodiscard]] absl::StatusOr<std::shared_ptr<Image>> stylize(
			const Image& image,
			std::shared_ptr<core::image_processing_options::ImageProcessingOptions> image_processing_options =
			std::shared_ptr<core::image_processing_options::ImageProcessingOptions>()
		);
	};
}
