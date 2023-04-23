#pragma once

#include "mediapipe/tasks/cc/components/containers/proto/embeddings.pb.h"
#include "mediapipe/tasks/cc/vision/image_segmenter/proto/image_segmenter_graph_options.pb.h"
#include "mediapipe/tasks/cc/vision/image_segmenter/proto/segmenter_options.pb.h"
#include "binding/tasks/core/base_options.h"
#include "binding/tasks/core/task_info.h"
#include "binding/tasks/vision/core/base_vision_task_api.h"
#include "binding/tasks/vision/core/vision_task_running_mode.h"
#include "binding/packet_getter.h"
#include "binding/packet_creator.h"

namespace mediapipe::tasks::autoit::vision::image_segmenter {
	using ImageSegmenterResultRawCallback = void(*)(const std::vector<Image>&, const Image&, int64_t);
	using ImageSegmenterResultCallback = std::function<void(const std::vector<Image>&, const Image&, int64_t)>;

	struct CV_EXPORTS_W_SIMPLE ImageSegmenterOptions {
		CV_WRAP ImageSegmenterOptions(const ImageSegmenterOptions& other) = default;
		ImageSegmenterOptions& operator=(const ImageSegmenterOptions& other) = default;

		CV_WRAP ImageSegmenterOptions(
			std::shared_ptr<autoit::core::base_options::BaseOptions> base_options = std::shared_ptr<autoit::core::base_options::BaseOptions>(),
			core::vision_task_running_mode::VisionTaskRunningMode running_mode = tasks::autoit::vision::core::vision_task_running_mode::VisionTaskRunningMode::IMAGE,
			mediapipe::tasks::vision::image_segmenter::proto::SegmenterOptions::OutputType output_type = mediapipe::tasks::vision::image_segmenter::proto::SegmenterOptions::CATEGORY_MASK,
			mediapipe::tasks::vision::image_segmenter::proto::SegmenterOptions::Activation activation = mediapipe::tasks::vision::image_segmenter::proto::SegmenterOptions::NONE,
			ImageSegmenterResultCallback result_callback = nullptr
		)
			:
			base_options(base_options),
			running_mode(running_mode),
			output_type(output_type),
			activation(activation),
			result_callback(result_callback)
		{}

		CV_WRAP std::shared_ptr<mediapipe::tasks::vision::image_segmenter::proto::ImageSegmenterGraphOptions> to_pb2();

		CV_PROP_RW std::shared_ptr<autoit::core::base_options::BaseOptions> base_options;
		CV_PROP_RW core::vision_task_running_mode::VisionTaskRunningMode running_mode;
		CV_PROP_RW mediapipe::tasks::vision::image_segmenter::proto::SegmenterOptions::OutputType output_type;
		CV_PROP_RW mediapipe::tasks::vision::image_segmenter::proto::SegmenterOptions::Activation activation;
		CV_PROP_W  ImageSegmenterResultCallback result_callback;
	};

	class CV_EXPORTS_W ImageSegmenter : public ::mediapipe::tasks::autoit::vision::core::base_vision_task_api::BaseVisionTaskApi {
	public:
		using core::base_vision_task_api::BaseVisionTaskApi::BaseVisionTaskApi;

		CV_WRAP static std::shared_ptr<ImageSegmenter> create_from_model_path(const std::string& model_path);
		CV_WRAP static std::shared_ptr<ImageSegmenter> create_from_options(std::shared_ptr<ImageSegmenterOptions> options);
		CV_WRAP void segment(CV_OUT std::vector<Image>& segmentation_result, const Image& image);
		CV_WRAP void segment_for_video(CV_OUT std::vector<Image>& segmentation_result, const Image& image, int64_t timestamp_ms);
		CV_WRAP void segment_async(const Image& image, int64_t timestamp_ms);
	};
}

PTR_BRIDGE_DECL(mediapipe::tasks::autoit::vision::image_segmenter::ImageSegmenterResultRawCallback);
extern const HRESULT autoit_to(VARIANT const* const& in_val, mediapipe::tasks::autoit::vision::image_segmenter::ImageSegmenterResultCallback& out_val);
