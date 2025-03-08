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
	struct CV_EXPORTS_W_SIMPLE InteractiveSegmenterResult {
		CV_WRAP InteractiveSegmenterResult(const InteractiveSegmenterResult& other) = default;
		InteractiveSegmenterResult& operator=(const InteractiveSegmenterResult& other) = default;

		CV_WRAP InteractiveSegmenterResult(
			const std::shared_ptr<std::vector<std::shared_ptr<Image>>>& confidence_masks = std::make_shared<std::vector<std::shared_ptr<Image>>>(),
			const std::shared_ptr<Image>& category_mask = std::shared_ptr<Image>()
		) :
			confidence_masks(confidence_masks),
			category_mask(category_mask)
		{}

		bool operator== (const InteractiveSegmenterResult& other) const {
			return ::autoit::__eq__(confidence_masks, other.confidence_masks) &&
				::autoit::__eq__(category_mask, other.category_mask);
		}

		CV_PROP_RW std::shared_ptr<std::vector<std::shared_ptr<Image>>> confidence_masks;
		CV_PROP_RW std::shared_ptr<Image> category_mask;
	};

	struct CV_EXPORTS_W_SIMPLE InteractiveSegmenterOptions {
		CV_WRAP InteractiveSegmenterOptions(const InteractiveSegmenterOptions& other) = default;
		InteractiveSegmenterOptions& operator=(const InteractiveSegmenterOptions& other) = default;

		CV_WRAP InteractiveSegmenterOptions(
			std::shared_ptr<autoit::core::base_options::BaseOptions> base_options = std::shared_ptr<autoit::core::base_options::BaseOptions>(),
			bool output_confidence_masks = true,
			bool output_category_mask = false
		)
			:
			base_options(base_options),
			output_confidence_masks(output_confidence_masks),
			output_category_mask(output_category_mask)
		{}

		CV_WRAP [[nodiscard]] absl::StatusOr<std::shared_ptr<mediapipe::tasks::vision::image_segmenter::proto::ImageSegmenterGraphOptions>> to_pb2() const;

		CV_PROP_RW std::shared_ptr<autoit::core::base_options::BaseOptions> base_options;
		CV_PROP_RW bool output_confidence_masks;
		CV_PROP_RW bool output_category_mask;
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

		CV_WRAP [[nodiscard]] static absl::StatusOr<std::shared_ptr<InteractiveSegmenter>> create(
			const CalculatorGraphConfig& graph_config,
			core::vision_task_running_mode::VisionTaskRunningMode running_mode,
			mediapipe::autoit::PacketsCallback packet_callback = nullptr
		);
		CV_WRAP [[nodiscard]] static absl::StatusOr<std::shared_ptr<InteractiveSegmenter>> create_from_model_path(const std::string& model_path);
		CV_WRAP [[nodiscard]] static absl::StatusOr<std::shared_ptr<InteractiveSegmenter>> create_from_options(std::shared_ptr<InteractiveSegmenterOptions> options);
		CV_WRAP [[nodiscard]] absl::StatusOr<std::shared_ptr<InteractiveSegmenterResult>> segment(
			const Image& image,
			const RegionOfInterest& roi,
			std::shared_ptr<core::image_processing_options::ImageProcessingOptions> image_processing_options =
			std::shared_ptr<core::image_processing_options::ImageProcessingOptions>()
		);
	};
}
