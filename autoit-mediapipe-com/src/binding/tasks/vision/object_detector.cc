#include "binding/tasks/vision/object_detector.h"

// PTR_BRIDGE_IMPL(mediapipe::tasks::autoit::vision::object_detector::ObjectDetectorResultRawCallback);

// template<typename _Ty1, typename _Ty2>
// inline const HRESULT autoit_to_callback(VARIANT const* const& in_val, _Ty1& out_val) {
// 	_Ty2 result_callback;
// 	HRESULT hr = autoit_to(in_val, result_callback);
// 	if (SUCCEEDED(hr)) {
// 		out_val = result_callback;
// 	}
// 	return hr;
// }

// const HRESULT autoit_to(VARIANT const* const& in_val, mediapipe::tasks::autoit::vision::object_detector::ObjectDetectorResultCallback& out_val) {
// 	return autoit_to_callback<
// 		mediapipe::tasks::autoit::vision::object_detector::ObjectDetectorResultCallback,
// 		mediapipe::tasks::autoit::vision::object_detector::ObjectDetectorResultRawCallback
// 	>(in_val, out_val);
// }

namespace {
	using namespace google::protobuf;
	using namespace mediapipe::autoit::packet_creator;
	using namespace mediapipe::autoit::packet_getter;
	using namespace mediapipe::tasks::autoit::components::utils;
	using namespace mediapipe::tasks::autoit::core::base_options;
	using namespace mediapipe::tasks::autoit::core::task_info;
	using namespace mediapipe::tasks::autoit::vision::core::image_processing_options;
	using namespace mediapipe::tasks::autoit::vision::core::vision_task_running_mode;
	using namespace mediapipe::tasks::autoit::vision::object_detector;
	using namespace mediapipe::tasks::vision::object_detector::proto;

	using mediapipe::autoit::PacketsCallback;
	using mediapipe::tasks::core::PacketMap;

	using Detection = mediapipe::tasks::autoit::components::containers::detections::Detection;

	const std::string _DETECTIONS_OUT_STREAM_NAME = "detections_out";
	const std::string _DETECTIONS_TAG = "DETECTIONS";
	const std::string _IMAGE_IN_STREAM_NAME = "image_in";
	const std::string _IMAGE_OUT_STREAM_NAME = "image_out";
	const std::string _IMAGE_TAG = "IMAGE";
	const std::string _NORM_RECT_STREAM_NAME = "norm_rect_in";
	const std::string _NORM_RECT_TAG = "NORM_RECT";
	const std::string _TASK_GRAPH_NAME = "mediapipe.tasks.vision.ObjectDetectorGraph";
	const int64_t _MICRO_SECONDS_PER_MILLISECOND = 1000;

	std::shared_ptr<ObjectDetectorResult> _build_detection_result(const PacketMap& output_packets) {
		const auto& detector_out_packet = output_packets.at(_DETECTIONS_OUT_STREAM_NAME);
		if (detector_out_packet.IsEmpty()) {
			return std::make_shared<ObjectDetectorResult>();
		}

		auto detection_result = std::make_shared<ObjectDetectorResult>();

		const auto& detection_proto_list = GetContent<std::vector<mediapipe::Detection>>(output_packets.at(_DETECTIONS_OUT_STREAM_NAME));
		for (const auto& detection : detection_proto_list) {
			detection_result->detections->push_back(Detection::create_from_pb2(detection));
		}

		return detection_result;
	}
}

namespace mediapipe::tasks::autoit::vision::object_detector {
	std::shared_ptr<mediapipe::tasks::vision::object_detector::proto::ObjectDetectorOptions> ObjectDetectorOptions::to_pb2() {
		auto pb2_obj = std::make_shared<mediapipe::tasks::vision::object_detector::proto::ObjectDetectorOptions>();

		if (base_options) {
			pb2_obj->mutable_base_options()->CopyFrom(*base_options->to_pb2());
		}
		pb2_obj->mutable_base_options()->set_use_stream_mode(running_mode != VisionTaskRunningMode::IMAGE);

		if (score_threshold) pb2_obj->set_score_threshold(*score_threshold);
		if (category_allowlist) pb2_obj->mutable_category_allowlist()->Add(category_allowlist->begin(), category_allowlist->end());
		if (category_denylist) pb2_obj->mutable_category_denylist()->Add(category_denylist->begin(), category_denylist->end());
		if (display_names_locale) pb2_obj->set_display_names_locale(*display_names_locale);
		if (max_results) pb2_obj->set_max_results(*max_results);

		return pb2_obj;
	}

	std::shared_ptr<ObjectDetector> ObjectDetector::create_from_model_path(const std::string& model_path) {
		auto base_options = std::make_shared<BaseOptions>(model_path);
		return create_from_options(std::make_shared<ObjectDetectorOptions>(base_options, VisionTaskRunningMode::IMAGE));
	}

	std::shared_ptr<ObjectDetector> ObjectDetector::create_from_options(std::shared_ptr<ObjectDetectorOptions> options) {
		PacketsCallback packets_callback = nullptr;

		if (options->result_callback) {
			packets_callback = [options](const PacketMap& output_packets) {
				const auto& image_out_packet = output_packets.at(_IMAGE_OUT_STREAM_NAME);
				if (image_out_packet.IsEmpty()) {
					return;
				}

				auto detection_result = _build_detection_result(output_packets);
				const auto& image = GetContent<Image>(image_out_packet);
				auto timestamp_ms = output_packets.at(_DETECTIONS_OUT_STREAM_NAME).Timestamp().Value() / _MICRO_SECONDS_PER_MILLISECOND;

				options->result_callback(*detection_result, image, timestamp_ms);
			};
		}

		TaskInfo task_info;
		task_info.task_graph = _TASK_GRAPH_NAME;
		*task_info.input_streams = {
			_IMAGE_TAG + ":" + _IMAGE_IN_STREAM_NAME,
			_NORM_RECT_TAG + ":" + _NORM_RECT_STREAM_NAME,
		};
		*task_info.output_streams = {
			_DETECTIONS_TAG + ":" + _DETECTIONS_OUT_STREAM_NAME,
			_IMAGE_TAG + ":" + _IMAGE_OUT_STREAM_NAME
		};
		task_info.task_options = options->to_pb2();

		return std::make_shared<ObjectDetector>(
			*task_info.generate_graph_config(options->running_mode == VisionTaskRunningMode::LIVE_STREAM),
			options->running_mode,
			std::move(packets_callback)
		);
	}

	std::shared_ptr<ObjectDetectorResult> ObjectDetector::detect(
		const Image& image,
		std::shared_ptr<ImageProcessingOptions> image_processing_options
	) {
		auto normalized_rect = convert_to_normalized_rect(image_processing_options, image, false);

		auto output_packets = _process_image_data({
			{ _IMAGE_IN_STREAM_NAME, std::move(*std::move(create_image(image))) },
			{ _NORM_RECT_STREAM_NAME, std::move(*std::move(create_proto(*normalized_rect.to_pb2()))) },
			});

		return _build_detection_result(output_packets);
	}

	std::shared_ptr<ObjectDetectorResult> ObjectDetector::detect_for_video(
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

		return _build_detection_result(output_packets);
	}

	void ObjectDetector::detect_async(
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
