#include "binding/tasks/vision/face_detector.h"

PTR_BRIDGE_IMPL(mediapipe::tasks::autoit::vision::face_detector::FaceDetectorResultRawCallback);

template<typename _Ty1, typename _Ty2>
inline const HRESULT autoit_to_callback(VARIANT const* const& in_val, _Ty1& out_val) {
	_Ty2 result_callback;
	HRESULT hr = autoit_to(in_val, result_callback);
	if (SUCCEEDED(hr)) {
		out_val = result_callback;
	}
	return hr;
}

const HRESULT autoit_to(VARIANT const* const& in_val, mediapipe::tasks::autoit::vision::face_detector::FaceDetectorResultCallback& out_val) {
	return autoit_to_callback<
		mediapipe::tasks::autoit::vision::face_detector::FaceDetectorResultCallback,
		mediapipe::tasks::autoit::vision::face_detector::FaceDetectorResultRawCallback
	>(in_val, out_val);
}

namespace {
	using namespace mediapipe::tasks::vision::face_detector::proto;
	using namespace mediapipe::tasks::autoit::vision::core::vision_task_running_mode;
	using namespace mediapipe::tasks::autoit::core::base_options;
	using namespace mediapipe::tasks::autoit::core::task_info;
	using namespace mediapipe::tasks::autoit::components::utils;;
	using namespace mediapipe::tasks::autoit::vision::core::image_processing_options;
	using namespace mediapipe::autoit::packet_creator;
	using namespace mediapipe::autoit::packet_getter;
	using namespace google::protobuf;

	using mediapipe::autoit::PacketsCallback;
	using mediapipe::tasks::core::PacketMap;

	const std::string _DETECTIONS_OUT_STREAM_NAME = "detections";
	const std::string _DETECTIONS_TAG = "DETECTIONS";
	const std::string _NORM_RECT_STREAM_NAME = "norm_rect_in";
	const std::string _NORM_RECT_TAG = "NORM_RECT";
	const std::string _IMAGE_IN_STREAM_NAME = "image_in";
	const std::string _IMAGE_OUT_STREAM_NAME = "image_out";
	const std::string _IMAGE_TAG = "IMAGE";
	const std::string _TASK_GRAPH_NAME = "mediapipe.tasks.vision.face_detector.FaceDetectorGraph";
	const int64_t _MICRO_SECONDS_PER_MILLISECOND = 1000;
}

namespace mediapipe::tasks::autoit::vision::face_detector {
	using Detection = components::containers::detections::Detection;

	std::shared_ptr<mediapipe::tasks::vision::face_detector::proto::FaceDetectorGraphOptions> FaceDetectorOptions::to_pb2() {
		auto pb2_obj = std::make_shared<mediapipe::tasks::vision::face_detector::proto::FaceDetectorGraphOptions>();

		if (base_options) {
			pb2_obj->mutable_base_options()->CopyFrom(*base_options->to_pb2());
		}
		pb2_obj->mutable_base_options()->set_use_stream_mode(running_mode != VisionTaskRunningMode::IMAGE);

		if (min_detection_confidence) pb2_obj->set_min_detection_confidence(*min_detection_confidence);
		if (min_suppression_threshold) pb2_obj->set_min_suppression_threshold(*min_suppression_threshold);

		return pb2_obj;
	}

	std::shared_ptr<FaceDetector> FaceDetector::create_from_model_path(const std::string& model_path) {
		auto base_options = std::make_shared<BaseOptions>(model_path);
		return create_from_options(std::make_shared<FaceDetectorOptions>(base_options, VisionTaskRunningMode::IMAGE));
	}

	std::shared_ptr<FaceDetector> FaceDetector::create_from_options(std::shared_ptr<FaceDetectorOptions> options) {
		PacketsCallback packets_callback = nullptr;

		if (options->result_callback) {
			packets_callback = [options](const PacketMap& output_packets) {
				const auto image_out_packet = output_packets.at(_IMAGE_OUT_STREAM_NAME);
				if (image_out_packet.IsEmpty()) {
					return;
				}

				const auto& detections_out_packet = output_packets.at(_DETECTIONS_OUT_STREAM_NAME);

				FaceDetectorResult detection_result;

				std::vector<std::shared_ptr<Message>> detection_proto_list;
				get_proto_list(detections_out_packet, detection_proto_list);
				for (const auto& result : detection_proto_list) {
					detection_result.detections.push_back(Detection::create_from_pb2(*static_cast<mediapipe::Detection const*>(result.get())));
				}

				auto image = GetContent<Image>(image_out_packet);
				auto timestamp = detections_out_packet.IsEmpty() ? detections_out_packet.Timestamp().Value() : image_out_packet.Timestamp().Value();
				auto timestamp_ms = timestamp / _MICRO_SECONDS_PER_MILLISECOND;

				options->result_callback(detection_result, image, timestamp_ms);
			};
		}

		TaskInfo task_info;
		task_info.task_graph = _TASK_GRAPH_NAME;
		task_info.input_streams = {
			_IMAGE_TAG + ":" + _IMAGE_IN_STREAM_NAME,
			_NORM_RECT_TAG + ":" + _NORM_RECT_STREAM_NAME
		};
		task_info.output_streams = {
			_DETECTIONS_TAG + ":" + _DETECTIONS_OUT_STREAM_NAME,
			_IMAGE_TAG + ":" + _IMAGE_OUT_STREAM_NAME
		};
		task_info.task_options = options->to_pb2();

		return std::make_shared<FaceDetector>(
			*task_info.generate_graph_config(options->running_mode == VisionTaskRunningMode::LIVE_STREAM),
			options->running_mode,
			std::move(packets_callback)
			);
	}

	std::shared_ptr<FaceDetectorResult> FaceDetector::detect(
		const Image& image,
		std::shared_ptr<ImageProcessingOptions> image_processing_options
	) {
		auto normalized_rect = convert_to_normalized_rect(image_processing_options, image, false);

		auto output_packets = _process_image_data({
			{ _IMAGE_IN_STREAM_NAME, std::move(*std::move(create_image(image))) },
			{ _NORM_RECT_STREAM_NAME, std::move(*std::move(create_proto(*normalized_rect.to_pb2()))) },
			});

		std::vector<std::shared_ptr<Message>> detection_proto_list;
		get_proto_list(output_packets.at(_DETECTIONS_OUT_STREAM_NAME), detection_proto_list);
		auto detection_result = std::make_shared<FaceDetectorResult>();
		for (const auto& result : detection_proto_list) {
			detection_result->detections.push_back(Detection::create_from_pb2(*static_cast<mediapipe::Detection const*>(result.get())));
		}

		return detection_result;
	}

	std::shared_ptr<FaceDetectorResult> FaceDetector::detect_for_video(
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

		std::vector<std::shared_ptr<Message>> detection_proto_list;
		get_proto_list(output_packets.at(_DETECTIONS_OUT_STREAM_NAME), detection_proto_list);
		auto detection_result = std::make_shared<FaceDetectorResult>();
		for (const auto& result : detection_proto_list) {
			detection_result->detections.push_back(Detection::create_from_pb2(*static_cast<mediapipe::Detection const*>(result.get())));
		}

		return detection_result;
	}

	void FaceDetector::detect_async(
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
