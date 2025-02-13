#include "mediapipe/framework/port/status_macros.h"
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
	using namespace mediapipe::autoit::packet_creator;
	using namespace mediapipe::autoit::packet_getter;
	using namespace mediapipe::tasks::autoit::components::utils;
	using namespace mediapipe::tasks::autoit::core::base_options;
	using namespace mediapipe::tasks::autoit::core::task_info;
	using namespace mediapipe::tasks::autoit::vision::core::base_vision_task_api;
	using namespace mediapipe::tasks::autoit::vision::core::image_processing_options;
	using namespace mediapipe::tasks::autoit::vision::core::vision_task_running_mode;
	using namespace mediapipe::tasks::autoit::vision::image_segmenter;
	using namespace mediapipe::tasks::vision::image_segmenter::proto;
	using namespace mediapipe;

	using mediapipe::autoit::PacketsCallback;
	using mediapipe::tasks::core::PacketMap;

	const std::string _CONFIDENCE_MASKS_STREAM_NAME = "confidence_masks";
	const std::string _CONFIDENCE_MASKS_TAG = "CONFIDENCE_MASKS";
	const std::string _CATEGORY_MASK_STREAM_NAME = "category_mask";
	const std::string _CATEGORY_MASK_TAG = "CATEGORY_MASK";
	const std::string _IMAGE_IN_STREAM_NAME = "image_in";
	const std::string _IMAGE_OUT_STREAM_NAME = "image_out";
	const std::string _IMAGE_TAG = "IMAGE";
	const std::string _NORM_RECT_STREAM_NAME = "norm_rect_in";
	const std::string _NORM_RECT_TAG = "NORM_RECT";
	const std::string _TENSORS_TO_SEGMENTATION_CALCULATOR_NAME = "mediapipe.tasks.TensorsToSegmentationCalculator";
	const std::string _TASK_GRAPH_NAME = "mediapipe.tasks.vision.image_segmenter.ImageSegmenterGraph";
	const int64_t _MICRO_SECONDS_PER_MILLISECOND = 1000;

	[[nodiscard]] absl::StatusOr<std::shared_ptr<ImageSegmenterResult>> _build_segmenter_result(const PacketMap& output_packets) {
		auto segmentation_result = std::make_shared<ImageSegmenterResult>();

		if (output_packets.count(_CONFIDENCE_MASKS_STREAM_NAME)) {
			MP_PACKET_ASSIGN_OR_RETURN(const auto& confidence_masks, std::vector<Image>, output_packets.at(_CONFIDENCE_MASKS_STREAM_NAME));
			for (const auto& image : confidence_masks) {
				segmentation_result->confidence_masks->push_back(std::move(std::make_shared<Image>(image)));
			}
		}

		if (output_packets.count(_CATEGORY_MASK_STREAM_NAME)) {
			MP_PACKET_ASSIGN_OR_RETURN(const auto& category_mask, Image, output_packets.at(_CATEGORY_MASK_STREAM_NAME));
			segmentation_result->category_mask = std::make_shared<Image>(category_mask);
		}

		return segmentation_result;
	}
}

namespace mediapipe::tasks::autoit::vision::image_segmenter {
	absl::StatusOr<std::shared_ptr<ImageSegmenterGraphOptions>> ImageSegmenterOptions::to_pb2() const {
		auto pb2_obj = std::make_shared<ImageSegmenterGraphOptions>();

		if (base_options) {
			MP_ASSIGN_OR_RETURN(auto base_options_proto, base_options->to_pb2());
			pb2_obj->mutable_base_options()->CopyFrom(*base_options_proto);
		}
		pb2_obj->mutable_base_options()->set_use_stream_mode(running_mode != VisionTaskRunningMode::IMAGE);
		pb2_obj->mutable_segmenter_options();

		return pb2_obj;
	}

	absl::StatusOr<std::shared_ptr<ImageSegmenter>> ImageSegmenter::create(
		const CalculatorGraphConfig& graph_config,
		VisionTaskRunningMode running_mode,
		mediapipe::autoit::PacketsCallback packet_callback
	) {
		using BaseVisionTaskApi = core::base_vision_task_api::BaseVisionTaskApi;
		MP_ASSIGN_OR_RETURN(auto vision_task_api, BaseVisionTaskApi::create(graph_config, running_mode, std::move(packet_callback), static_cast<ImageSegmenter*>(nullptr)));
		MP_RETURN_IF_ERROR(vision_task_api->labels_status);
		return vision_task_api;
	}

	ImageSegmenter::ImageSegmenter(
		const std::shared_ptr<mediapipe::tasks::core::TaskRunner>& runner,
		VisionTaskRunningMode running_mode
	) : BaseVisionTaskApi(runner, running_mode) {
		labels_status = _populate_labels();
	}

	absl::Status ImageSegmenter::_populate_labels() {
		const auto& graph_config = _runner->GetGraphConfig();
		bool found_tensors_to_segmentation = false;

		for (const auto& node : graph_config.node()) {
			if (node.name().find(_TENSORS_TO_SEGMENTATION_CALCULATOR_NAME) == std::string::npos) {
				continue;
			}

			MP_ASSERT_RETURN_IF_ERROR(!found_tensors_to_segmentation, "The graph has more than one " << _TENSORS_TO_SEGMENTATION_CALCULATOR_NAME);
			found_tensors_to_segmentation = true;

			const auto& options = node.options().GetExtension(TensorsToSegmentationCalculatorOptions::ext);
			const auto& label_items = options.label_items();
			const auto label_items_size = options.label_items_size();
			for (int64_t i = 0; i < label_items_size; i++) {
				MP_ASSERT_RETURN_IF_ERROR(label_items.count(i), "The labelmap has no expected key: " << i);
				_labels.push_back(label_items.at(i).name());
			}
		}

		return absl::OkStatus();
	}

	absl::StatusOr<std::shared_ptr<ImageSegmenter>> ImageSegmenter::create_from_model_path(const std::string& model_path) {
		auto base_options = std::make_shared<BaseOptions>(model_path);
		return create_from_options(std::make_shared<ImageSegmenterOptions>(base_options, VisionTaskRunningMode::IMAGE));
	}

	absl::StatusOr<std::shared_ptr<ImageSegmenter>> ImageSegmenter::create_from_options(std::shared_ptr<ImageSegmenterOptions> options) {
		PacketsCallback packet_callback = nullptr;

		if (options->result_callback) {
			packet_callback = [options](const PacketMap& output_packets) {
				const auto& image_out_packet = output_packets.at(_IMAGE_OUT_STREAM_NAME);
				if (image_out_packet.IsEmpty()) {
					return;
				}

				MP_ASSIGN_OR_THROW(auto segmentation_result, _build_segmenter_result(output_packets)); // There is no other choice than throw in a callback to stop the execution
				MP_PACKET_ASSIGN_OR_THROW(const auto& image, Image, image_out_packet); // There is no other choice than throw in a callback to stop the execution
				auto timestamp_ms = image_out_packet.Timestamp().Value() / _MICRO_SECONDS_PER_MILLISECOND;

				options->result_callback(*segmentation_result, image, timestamp_ms);
				};
		}

		TaskInfo task_info;
		task_info.task_graph = _TASK_GRAPH_NAME;
		*task_info.input_streams = {
			_IMAGE_TAG + ":" + _IMAGE_IN_STREAM_NAME,
			_NORM_RECT_TAG + ":" + _NORM_RECT_STREAM_NAME,
		};
		*task_info.output_streams = {
			_IMAGE_TAG + ":" + _IMAGE_OUT_STREAM_NAME,
		};
		MP_ASSIGN_OR_RETURN(task_info.task_options, options->to_pb2());

		if (options->output_confidence_masks) {
			task_info.output_streams->push_back(_CONFIDENCE_MASKS_TAG + ":" + _CONFIDENCE_MASKS_STREAM_NAME);
		}

		if (options->output_category_mask) {
			task_info.output_streams->push_back(_CATEGORY_MASK_TAG + ":" + _CATEGORY_MASK_STREAM_NAME);
		}

		MP_ASSIGN_OR_RETURN(auto config, task_info.generate_graph_config(options->running_mode == VisionTaskRunningMode::LIVE_STREAM));

		return create(
			*config,
			options->running_mode,
			std::move(packet_callback)
		);
	}

	absl::StatusOr<std::shared_ptr<ImageSegmenterResult>> ImageSegmenter::segment(
		const Image& image,
		std::shared_ptr<ImageProcessingOptions> image_processing_options
	) {
		MP_ASSIGN_OR_RETURN(auto normalized_rect, convert_to_normalized_rect(image_processing_options, image, false));

		MP_ASSIGN_OR_RETURN(auto output_packets, _process_image_data({
			{ _IMAGE_IN_STREAM_NAME, std::move(*std::move(create_image(image))) },
			{ _NORM_RECT_STREAM_NAME, std::move(*std::move(create_proto(*normalized_rect.to_pb2()))) },
			}));

		return _build_segmenter_result(output_packets);
	}

	absl::StatusOr<std::shared_ptr<ImageSegmenterResult>> ImageSegmenter::segment_for_video(
		const Image& image,
		int64_t timestamp_ms,
		std::shared_ptr<ImageProcessingOptions> image_processing_options
	) {
		MP_ASSIGN_OR_RETURN(auto normalized_rect, convert_to_normalized_rect(image_processing_options, image, false));

		MP_ASSIGN_OR_RETURN(auto output_packets, _process_video_data({
			{ _IMAGE_IN_STREAM_NAME, std::move(std::move(create_image(image))->At(
				Timestamp(timestamp_ms * _MICRO_SECONDS_PER_MILLISECOND)
			)) },
			{ _NORM_RECT_STREAM_NAME, std::move(std::move(create_proto(*normalized_rect.to_pb2()))->At(
				Timestamp(timestamp_ms * _MICRO_SECONDS_PER_MILLISECOND)
			)) },
			}));

		return _build_segmenter_result(output_packets);
	}

	absl::Status ImageSegmenter::segment_async(
		const Image& image,
		int64_t timestamp_ms,
		std::shared_ptr<ImageProcessingOptions> image_processing_options
	) {
		MP_ASSIGN_OR_RETURN(auto normalized_rect, convert_to_normalized_rect(image_processing_options, image, false));

		return _send_live_stream_data({
			{ _IMAGE_IN_STREAM_NAME, std::move(std::move(create_image(image))->At(
				Timestamp(timestamp_ms * _MICRO_SECONDS_PER_MILLISECOND)
			)) },
			{ _NORM_RECT_STREAM_NAME, std::move(std::move(create_proto(*normalized_rect.to_pb2()))->At(
				Timestamp(timestamp_ms * _MICRO_SECONDS_PER_MILLISECOND)
			)) },
			});
	}

	void ImageSegmenter::get_labels(std::vector<std::string>& labels) {
		labels = _labels;
	}
}
