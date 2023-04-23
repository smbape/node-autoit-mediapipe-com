#pragma once

#include "mediapipe/tasks/cc/vision/image_segmenter/proto/image_segmenter_graph_options.pb.h"
#include "mediapipe/tasks/cc/vision/image_segmenter/proto/segmenter_options.pb.h"
#include "mediapipe/util/render_data.pb.h"
#include "binding/tasks/components/containers/keypoint.h"
#include "binding/tasks/core/base_options.h"
#include "binding/tasks/core/task_info.h"
#include "binding/tasks/vision/core/base_vision_task_api.h"
#include "binding/tasks/vision/core/image_processing_options.h"
#include "binding/tasks/vision/core/vision_task_running_mode.h"
#include "binding/packet_getter.h"
#include "binding/packet_creator.h"

namespace mediapipe::tasks::autoit::vision::interactive_segmenter {
	struct CV_EXPORTS_W_SIMPLE InteractiveSegmenterOptions {
		CV_WRAP InteractiveSegmenterOptions(const InteractiveSegmenterOptions& other) = default;
		InteractiveSegmenterOptions& operator=(const InteractiveSegmenterOptions& other) = default;

		CV_WRAP InteractiveSegmenterOptions(
			std::shared_ptr<autoit::core::base_options::BaseOptions> base_options = std::shared_ptr<autoit::core::base_options::BaseOptions>(),
			mediapipe::tasks::vision::image_segmenter::proto::SegmenterOptions::OutputType output_type = mediapipe::tasks::vision::image_segmenter::proto::SegmenterOptions::CATEGORY_MASK
		)
			:
			base_options(base_options),
			output_type(output_type)
		{}

		CV_WRAP std::shared_ptr<mediapipe::tasks::vision::image_segmenter::proto::ImageSegmenterGraphOptions> to_pb2();

		CV_PROP_RW std::shared_ptr<autoit::core::base_options::BaseOptions> base_options;
		CV_PROP_RW mediapipe::tasks::vision::image_segmenter::proto::SegmenterOptions::OutputType output_type;
	};

	enum class RegionOfInterest_Format {
		UNSPECIFIED = 0,
		KEYPOINT = 1,
	};

	struct CV_EXPORTS_W_SIMPLE RegionOfInterest {
		CV_WRAP RegionOfInterest(const RegionOfInterest& other) = default;
		RegionOfInterest& operator=(const RegionOfInterest& other) = default;

		CV_WRAP RegionOfInterest(
			RegionOfInterest_Format format = RegionOfInterest_Format::UNSPECIFIED,
			std::shared_ptr<components::containers::keypoint::NormalizedKeypoint> keypoint = std::shared_ptr<components::containers::keypoint::NormalizedKeypoint>()
		)
			:
			format(format),
			keypoint(keypoint)
		{}

		CV_PROP_RW RegionOfInterest_Format format;
		CV_PROP_RW std::shared_ptr<components::containers::keypoint::NormalizedKeypoint> keypoint;
	};

	class CV_EXPORTS_W InteractiveSegmenter : public ::mediapipe::tasks::autoit::vision::core::base_vision_task_api::BaseVisionTaskApi {
	public:
		using core::base_vision_task_api::BaseVisionTaskApi::BaseVisionTaskApi;

		CV_WRAP static std::shared_ptr<InteractiveSegmenter> create_from_model_path(const std::string& model_path);
		CV_WRAP static std::shared_ptr<InteractiveSegmenter> create_from_options(std::shared_ptr<InteractiveSegmenterOptions> options);
		CV_WRAP void segment(
			CV_OUT std::vector<Image>& segmentation_result,
			const Image& image,
			const RegionOfInterest& roi,
			std::shared_ptr<core::image_processing_options::ImageProcessingOptions> image_processing_options =
			std::shared_ptr<core::image_processing_options::ImageProcessingOptions>()
		);
	};
}
