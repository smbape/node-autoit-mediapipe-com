#pragma once

#include "mediapipe/tasks/cc/vision/face_stylizer/proto/face_stylizer_graph_options.pb.h"
#include "binding/tasks/core/base_options.h"
#include "binding/tasks/core/task_info.h"
#include "binding/tasks/vision/core/base_vision_task_api.h"
#include "binding/tasks/vision/core/image_processing_options.h"
#include "binding/tasks/vision/core/vision_task_running_mode.h"
#include "binding/packet_getter.h"
#include "binding/packet_creator.h"
#include <functional>

namespace mediapipe::tasks::autoit::vision::face_stylizer {
	using ImageRawCallback = void(*)(const Image* const, const Image&, int64_t);
	using ImageCallback = std::function<void(const Image* const, const Image&, int64_t)>;

	struct CV_EXPORTS_W_SIMPLE FaceStylizerOptions {
		CV_WRAP FaceStylizerOptions(const FaceStylizerOptions& other) = default;
		FaceStylizerOptions& operator=(const FaceStylizerOptions& other) = default;

		CV_WRAP FaceStylizerOptions(
			std::shared_ptr<autoit::core::base_options::BaseOptions> base_options = std::shared_ptr<autoit::core::base_options::BaseOptions>(),
			core::vision_task_running_mode::VisionTaskRunningMode running_mode = tasks::autoit::vision::core::vision_task_running_mode::VisionTaskRunningMode::IMAGE,
			ImageCallback result_callback = nullptr
		)
			:
			base_options(base_options),
			running_mode(running_mode),
			result_callback(result_callback)
		{}

		CV_WRAP std::shared_ptr<mediapipe::tasks::vision::face_stylizer::proto::FaceStylizerGraphOptions> to_pb2();

		CV_PROP_RW std::shared_ptr<autoit::core::base_options::BaseOptions> base_options;
		CV_PROP_RW core::vision_task_running_mode::VisionTaskRunningMode running_mode;
		CV_PROP_W  ImageCallback result_callback;
	};

	class CV_EXPORTS_W FaceStylizer : public ::mediapipe::tasks::autoit::vision::core::base_vision_task_api::BaseVisionTaskApi {
	public:
		using core::base_vision_task_api::BaseVisionTaskApi::BaseVisionTaskApi;

		CV_WRAP static std::shared_ptr<FaceStylizer> create_from_model_path(const std::string& model_path);
		CV_WRAP static std::shared_ptr<FaceStylizer> create_from_options(std::shared_ptr<FaceStylizerOptions> options);
		CV_WRAP std::shared_ptr<Image> stylize(
			const Image& image,
			std::shared_ptr<core::image_processing_options::ImageProcessingOptions> image_processing_options =
			std::shared_ptr<core::image_processing_options::ImageProcessingOptions>()
		);
		CV_WRAP std::shared_ptr<Image> stylize_for_video(
			const Image& image,
			int64_t timestamp_ms,
			std::shared_ptr<core::image_processing_options::ImageProcessingOptions> image_processing_options =
			std::shared_ptr<core::image_processing_options::ImageProcessingOptions>()
		);
		CV_WRAP void stylize_async(
			const Image& image,
			int64_t timestamp_ms,
			std::shared_ptr<core::image_processing_options::ImageProcessingOptions> image_processing_options =
			std::shared_ptr<core::image_processing_options::ImageProcessingOptions>()
		);
	};
}

PTR_BRIDGE_DECL(mediapipe::tasks::autoit::vision::face_stylizer::ImageRawCallback);
extern const HRESULT autoit_to(VARIANT const* const& in_val, mediapipe::tasks::autoit::vision::face_stylizer::ImageCallback& out_val);
