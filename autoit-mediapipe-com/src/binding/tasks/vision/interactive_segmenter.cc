#include "binding/tasks/vision/image_segmenter.h"

namespace {
	using namespace mediapipe::tasks::vision::image_segmenter::proto;
	using namespace mediapipe::tasks::autoit::vision::core::vision_task_running_mode;
	using namespace mediapipe::tasks::autoit::core::base_options;
	using namespace mediapipe::tasks::autoit::core::task_info;
	using namespace mediapipe::tasks::autoit::components::utils;
	using namespace mediapipe::tasks::autoit::vision::core::image_processing_options;
	using namespace mediapipe::autoit::packet_creator;
	using namespace mediapipe::autoit::packet_getter;
	using namespace mediapipe::tasks::autoit::vision::interactive_segmenter;
	using namespace mediapipe;

	using mediapipe::autoit::PacketsCallback;
	using mediapipe::tasks::core::PacketMap;

	const std::string _SEGMENTATION_OUT_STREAM_NAME = "segmented_mask_out";
	const std::string _SEGMENTATION_TAG = "GROUPED_SEGMENTATION";
	const std::string _IMAGE_IN_STREAM_NAME = "image_in";
	const std::string _IMAGE_OUT_STREAM_NAME = "image_out";
	const std::string _ROI_STREAM_NAME = "roi_in";
	const std::string _ROI_TAG = "ROI";
	const std::string _NORM_RECT_STREAM_NAME = "norm_rect_in";
	const std::string _NORM_RECT_TAG = "NORM_RECT";
	const std::string _IMAGE_TAG = "IMAGE";
	const std::string _TASK_GRAPH_NAME = "mediapipe.tasks.vision.interactive_segmenter.InteractiveSegmenterGraph";
	const int64_t _MICRO_SECONDS_PER_MILLISECOND = 1000;

	std::shared_ptr<RenderData> _convert_roi_to_render_data(const RegionOfInterest& roi) {
		std::shared_ptr<RenderData> result = std::make_shared<RenderData>();

		AUTOIT_ASSERT_THROW(roi.format != RegionOfInterest_Format::UNSPECIFIED, "RegionOfInterest format not specified.");
		AUTOIT_ASSERT_THROW(roi.format == RegionOfInterest_Format::KEYPOINT, "Unrecognized format.");
		AUTOIT_ASSERT_THROW(roi.keypoint, "RegionOfInterest has no keypoint.");

		auto* annotation = result->add_render_annotations();
		annotation->mutable_color()->set_r(255);
		auto* point = annotation->mutable_point();
		point->set_normalized(true);
		if (roi.keypoint->x) point->set_x(*roi.keypoint->x);
		if (roi.keypoint->y) point->set_y(*roi.keypoint->y);

		return result;
	}
}

namespace mediapipe::tasks::autoit::vision::interactive_segmenter {
	std::shared_ptr<ImageSegmenterGraphOptions> InteractiveSegmenterOptions::to_pb2() {
		auto pb2_obj = std::make_shared<ImageSegmenterGraphOptions>();

		if (base_options) {
			pb2_obj->mutable_base_options()->CopyFrom(*base_options->to_pb2());
		}
		pb2_obj->mutable_base_options()->set_use_stream_mode(false);
		pb2_obj->mutable_segmenter_options()->set_output_type(output_type);

		return pb2_obj;
	}

	std::shared_ptr<InteractiveSegmenter> InteractiveSegmenter::create_from_model_path(const std::string& model_path) {
		auto base_options = std::make_shared<BaseOptions>(model_path);
		return create_from_options(std::make_shared<InteractiveSegmenterOptions>(base_options));
	}

	std::shared_ptr<InteractiveSegmenter> InteractiveSegmenter::create_from_options(std::shared_ptr<InteractiveSegmenterOptions> options) {
		TaskInfo task_info;
		task_info.task_graph = _TASK_GRAPH_NAME;
		task_info.input_streams = {
			_IMAGE_TAG + ":" + _IMAGE_IN_STREAM_NAME,
			_ROI_TAG + ":" + _ROI_STREAM_NAME,
			_NORM_RECT_TAG + ":" + _NORM_RECT_STREAM_NAME,
		};
		task_info.output_streams = {
			_SEGMENTATION_TAG + ":" + _SEGMENTATION_OUT_STREAM_NAME,
			_IMAGE_TAG + ":" + _IMAGE_OUT_STREAM_NAME
		};
		task_info.task_options = options->to_pb2();

		return std::make_shared<InteractiveSegmenter>(
			*task_info.generate_graph_config(false),
			VisionTaskRunningMode::IMAGE
			);
	}

	void InteractiveSegmenter::segment(
		std::vector<Image>& segmentation_result,
		const Image& image,
		const RegionOfInterest& roi,
		std::shared_ptr<core::image_processing_options::ImageProcessingOptions> image_processing_options
	) {
		auto normalized_rect = convert_to_normalized_rect(image_processing_options, image, false);
		auto render_data_proto = _convert_roi_to_render_data(roi);

		auto output_packets = _process_image_data({
			{ _IMAGE_IN_STREAM_NAME, std::move(*std::move(create_image(image))) },
			{ _ROI_STREAM_NAME, std::move(*std::move(create_proto(*render_data_proto))) },
			{ _NORM_RECT_STREAM_NAME, std::move(*std::move(create_proto(*normalized_rect.to_pb2()))) },
			});

		segmentation_result = GetContent<std::vector<Image>>(output_packets.at(_SEGMENTATION_OUT_STREAM_NAME));
	}
}
