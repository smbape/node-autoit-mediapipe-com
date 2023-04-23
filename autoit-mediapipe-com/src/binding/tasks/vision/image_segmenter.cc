#include "binding/tasks/vision/image_segmenter.h"

PTR_BRIDGE_IMPL(mediapipe::tasks::autoit::vision::image_segmenter::ImageSegmenterResultRawCallback);

template<typename _Ty1, typename _Ty2>
inline const HRESULT autoit_to_callback(VARIANT const* const& in_val, _Ty1& out_val) {
	_Ty2 result_callback;
	HRESULT hr = autoit_to(in_val, result_callback);
	if (SUCCEEDED(hr)) {
		out_val = result_callback;
	}
	return hr;
}

const HRESULT autoit_to(VARIANT const* const& in_val, mediapipe::tasks::autoit::vision::image_segmenter::ImageSegmenterResultCallback& out_val) {
	return autoit_to_callback<
		mediapipe::tasks::autoit::vision::image_segmenter::ImageSegmenterResultCallback,
		mediapipe::tasks::autoit::vision::image_segmenter::ImageSegmenterResultRawCallback
	>(in_val, out_val);
}

namespace {
	using namespace mediapipe::tasks::vision::image_segmenter::proto;
	using namespace mediapipe::tasks::autoit::vision::core::vision_task_running_mode;
	using namespace mediapipe::tasks::autoit::core::base_options;
	using namespace mediapipe::tasks::autoit::core::task_info;
	using namespace mediapipe::tasks::autoit::components::utils;
	using namespace mediapipe::tasks::autoit::vision::core::image_processing_options;
	using namespace mediapipe::autoit::packet_creator;
	using namespace mediapipe::autoit::packet_getter;

	using mediapipe::autoit::PacketsCallback;
	using mediapipe::tasks::core::PacketMap;

	const std::string _SEGMENTATION_OUT_STREAM_NAME = "segmented_mask_out";
	const std::string _SEGMENTATION_TAG = "GROUPED_SEGMENTATION";
	const std::string _IMAGE_IN_STREAM_NAME = "image_in";
	const std::string _IMAGE_OUT_STREAM_NAME = "image_out";
	const std::string _IMAGE_TAG = "IMAGE";
	const std::string _NORM_RECT_STREAM_NAME = "norm_rect_in";
	const std::string _NORM_RECT_TAG = "NORM_RECT";
	const std::string _TASK_GRAPH_NAME = "mediapipe.tasks.vision.image_segmenter.ImageSegmenterGraph";
	const int64_t _MICRO_SECONDS_PER_MILLISECOND = 1000;
}

namespace mediapipe::tasks::autoit::vision::image_segmenter {
	std::shared_ptr<ImageSegmenterGraphOptions> ImageSegmenterOptions::to_pb2() {
		auto pb2_obj = std::make_shared<ImageSegmenterGraphOptions>();

		if (base_options) {
			pb2_obj->mutable_base_options()->CopyFrom(*base_options->to_pb2());
		}
		pb2_obj->mutable_base_options()->set_use_stream_mode(running_mode != VisionTaskRunningMode::IMAGE);
		pb2_obj->mutable_segmenter_options()->set_output_type(output_type);
		pb2_obj->mutable_segmenter_options()->set_activation(activation);

		return pb2_obj;
	}

	std::shared_ptr<ImageSegmenter> ImageSegmenter::create_from_model_path(const std::string& model_path) {
		auto base_options = std::make_shared<BaseOptions>(model_path);
		return create_from_options(std::make_shared<ImageSegmenterOptions>(base_options, VisionTaskRunningMode::IMAGE));
	}

	std::shared_ptr<ImageSegmenter> ImageSegmenter::create_from_options(std::shared_ptr<ImageSegmenterOptions> options) {
		PacketsCallback packets_callback = nullptr;

		if (options->result_callback) {
			packets_callback = [options](const PacketMap& output_packets) {
				const auto& image_out_packet = output_packets.at(_IMAGE_OUT_STREAM_NAME);
				if (image_out_packet.IsEmpty()) {
					return;
				}

				auto segmentation_result = GetContent<std::vector<Image>>(output_packets.at(_SEGMENTATION_OUT_STREAM_NAME));
				auto image = GetContent<Image>(image_out_packet);
				auto timestamp_ms = output_packets.at(_SEGMENTATION_OUT_STREAM_NAME).Timestamp().Value() / _MICRO_SECONDS_PER_MILLISECOND;

				options->result_callback(segmentation_result, image, timestamp_ms);
			};
		}

		TaskInfo task_info;
		task_info.task_graph = _TASK_GRAPH_NAME;
		task_info.input_streams = {
			_IMAGE_TAG + ":" + _IMAGE_IN_STREAM_NAME,
			_NORM_RECT_TAG + ":" + _NORM_RECT_STREAM_NAME,
		};
		task_info.output_streams = {
			_SEGMENTATION_TAG + ":" + _SEGMENTATION_OUT_STREAM_NAME,
			_IMAGE_TAG + ":" + _IMAGE_OUT_STREAM_NAME
		};
		task_info.task_options = options->to_pb2();

		return std::make_shared<ImageSegmenter>(
			*task_info.generate_graph_config(options->running_mode == VisionTaskRunningMode::LIVE_STREAM),
			options->running_mode,
			std::move(packets_callback)
			);
	}

	void ImageSegmenter::segment(
		std::vector<Image>& segmentation_result,
		const Image& image,
		std::shared_ptr<ImageProcessingOptions> image_processing_options
	) {
		auto normalized_rect = convert_to_normalized_rect(image_processing_options, image, false);

		auto output_packets = _process_image_data({
			{ _IMAGE_IN_STREAM_NAME, std::move(*std::move(create_image(image))) },
			{ _NORM_RECT_STREAM_NAME, std::move(*std::move(create_proto(*normalized_rect.to_pb2()))) },
			});

		segmentation_result = GetContent<std::vector<Image>>(output_packets.at(_SEGMENTATION_OUT_STREAM_NAME));
	}

	void ImageSegmenter::segment_for_video(
		std::vector<Image>& segmentation_result,
		const Image& image,
		int64_t timestamp_ms,
		std::shared_ptr<ImageProcessingOptions> image_processing_options
	) {
		auto normalized_rect = convert_to_normalized_rect(image_processing_options, image, false);

		auto output_packets = _process_video_data({
			{ _IMAGE_IN_STREAM_NAME, std::move(std::move(create_image(image))->At(
				Timestamp(timestamp_ms * _MICRO_SECONDS_PER_MILLISECOND)
			)) },
			{ _NORM_RECT_STREAM_NAME, std::move(std::move(create_proto(*normalized_rect.to_pb2()))->At(
				Timestamp(timestamp_ms * _MICRO_SECONDS_PER_MILLISECOND)
			)) },
			});

		segmentation_result = GetContent<std::vector<Image>>(output_packets.at(_SEGMENTATION_OUT_STREAM_NAME));
	}

	void ImageSegmenter::segment_async(
		const Image& image,
		int64_t timestamp_ms,
		std::shared_ptr<ImageProcessingOptions> image_processing_options
	) {
		auto normalized_rect = convert_to_normalized_rect(image_processing_options, image, false);

		_send_live_stream_data({
			{ _IMAGE_IN_STREAM_NAME, std::move(std::move(create_image(image))->At(
				Timestamp(timestamp_ms * _MICRO_SECONDS_PER_MILLISECOND)
			)) },
			{ _NORM_RECT_STREAM_NAME, std::move(std::move(create_proto(*normalized_rect.to_pb2()))->At(
				Timestamp(timestamp_ms * _MICRO_SECONDS_PER_MILLISECOND)
			)) },
			});
	}
}
