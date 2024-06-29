#pragma once

#include "mediapipe/tasks/cc/vision/image_segmenter/calculators/tensors_to_segmentation_calculator.pb.h"
#include "mediapipe/tasks/cc/vision/image_segmenter/proto/image_segmenter_graph_options.pb.h"
#include "mediapipe/tasks/cc/vision/image_segmenter/proto/segmenter_options.pb.h"
#include "binding/tasks/components/containers/rect.h"
#include "binding/tasks/core/base_options.h"
#include "binding/tasks/core/task_info.h"
#include "binding/tasks/vision/core/base_vision_task_api.h"
#include "binding/tasks/vision/core/image_processing_options.h"
#include "binding/tasks/vision/core/vision_task_running_mode.h"
#include "binding/packet_getter.h"
#include "binding/packet_creator.h"

namespace mediapipe::tasks::autoit::vision::image_segmenter {
	struct CV_EXPORTS_W_SIMPLE ImageSegmenterResult {
		CV_WRAP ImageSegmenterResult(const ImageSegmenterResult& other) = default;
		ImageSegmenterResult& operator=(const ImageSegmenterResult& other) = default;

		CV_WRAP ImageSegmenterResult(
			const std::shared_ptr<std::vector<std::shared_ptr<Image>>>& confidence_masks = std::make_shared<std::vector<std::shared_ptr<Image>>>(),
			const std::shared_ptr<Image>& category_mask = std::shared_ptr<Image>()
		) :
			confidence_masks(confidence_masks),
			category_mask(category_mask)
		{}

		bool operator== (const ImageSegmenterResult& other) const {
			return ::autoit::__eq__(confidence_masks, other.confidence_masks) &&
				::autoit::__eq__(category_mask, other.category_mask);
		}

		CV_PROP_RW std::shared_ptr<std::vector<std::shared_ptr<Image>>> confidence_masks;
		CV_PROP_RW std::shared_ptr<Image> category_mask;
	};

	using ImageSegmenterResultRawCallback = void(*)(const ImageSegmenterResult&, const Image&, int64_t);
	using ImageSegmenterResultCallback = std::function<void(const ImageSegmenterResult&, const Image&, int64_t)>;

	struct CV_EXPORTS_W_SIMPLE ImageSegmenterOptions {
		CV_WRAP ImageSegmenterOptions(const ImageSegmenterOptions& other) = default;
		ImageSegmenterOptions& operator=(const ImageSegmenterOptions& other) = default;

		CV_WRAP ImageSegmenterOptions(
			std::shared_ptr<autoit::core::base_options::BaseOptions> base_options = std::shared_ptr<autoit::core::base_options::BaseOptions>(),
			core::vision_task_running_mode::VisionTaskRunningMode running_mode = tasks::autoit::vision::core::vision_task_running_mode::VisionTaskRunningMode::IMAGE,
			bool output_confidence_masks = true,
			bool output_category_mask = false,
			ImageSegmenterResultCallback result_callback = nullptr
		)
			:
			base_options(base_options),
			running_mode(running_mode),
			output_confidence_masks(output_confidence_masks),
			output_category_mask(output_category_mask),
			result_callback(result_callback)
		{}

		CV_WRAP std::shared_ptr<mediapipe::tasks::vision::image_segmenter::proto::ImageSegmenterGraphOptions> to_pb2();

		CV_PROP_RW std::shared_ptr<autoit::core::base_options::BaseOptions> base_options;
		CV_PROP_RW core::vision_task_running_mode::VisionTaskRunningMode running_mode;
		CV_PROP_RW bool output_confidence_masks;
		CV_PROP_RW bool output_category_mask;
		CV_PROP_W  ImageSegmenterResultCallback result_callback;
	};

	class CV_EXPORTS_W ImageSegmenter : public ::mediapipe::tasks::autoit::vision::core::base_vision_task_api::BaseVisionTaskApi {
	public:
		CV_WRAP ImageSegmenter(
			const CalculatorGraphConfig& graph_config,
			core::vision_task_running_mode::VisionTaskRunningMode running_mode,
			mediapipe::autoit::PacketsCallback packet_callback = nullptr
		);

		CV_WRAP static std::shared_ptr<ImageSegmenter> create_from_model_path(const std::string& model_path);
		CV_WRAP static std::shared_ptr<ImageSegmenter> create_from_options(std::shared_ptr<ImageSegmenterOptions> options);
		CV_WRAP std::shared_ptr<ImageSegmenterResult> segment(
			const Image& image,
			std::shared_ptr<core::image_processing_options::ImageProcessingOptions> image_processing_options =
			std::shared_ptr<core::image_processing_options::ImageProcessingOptions>()
		);
		CV_WRAP std::shared_ptr<ImageSegmenterResult> segment_for_video(
			const Image& image,
			int64_t timestamp_ms,
			std::shared_ptr<core::image_processing_options::ImageProcessingOptions> image_processing_options =
			std::shared_ptr<core::image_processing_options::ImageProcessingOptions>()
		);
		CV_WRAP void segment_async(
			const Image& image,
			int64_t timestamp_ms,
			std::shared_ptr<core::image_processing_options::ImageProcessingOptions> image_processing_options =
			std::shared_ptr<core::image_processing_options::ImageProcessingOptions>()
		);
		CV_WRAP_AS(get labels) void get_labels(
			CV_OUT std::vector<std::string>& labels
		);
	private:
		void _populate_labels();
		std::vector<std::string> _labels;
	};
}

PTR_BRIDGE_DECL(mediapipe::tasks::autoit::vision::image_segmenter::ImageSegmenterResultRawCallback);
extern const HRESULT autoit_to(VARIANT const* const& in_val, mediapipe::tasks::autoit::vision::image_segmenter::ImageSegmenterResultCallback& out_val);
