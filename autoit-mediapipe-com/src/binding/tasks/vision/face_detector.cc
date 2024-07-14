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
	using namespace google::protobuf;
	using namespace mediapipe::autoit::packet_creator;
	using namespace mediapipe::autoit::packet_getter;
	using namespace mediapipe::tasks::autoit::components::utils;;
	using namespace mediapipe::tasks::autoit::core::base_options;
	using namespace mediapipe::tasks::autoit::core::task_info;
	using namespace mediapipe::tasks::autoit::vision::core::image_processing_options;
	using namespace mediapipe::tasks::autoit::vision::core::vision_task_running_mode;
	using namespace mediapipe::tasks::vision::face_detector::proto;
	using namespace mediapipe::tasks::autoit::vision::face_detector;

	using mediapipe::autoit::PacketsCallback;
	using mediapipe::tasks::core::PacketMap;

	using Detection = mediapipe::tasks::autoit::components::containers::detections::Detection;

	const std::string _DETECTIONS_OUT_STREAM_NAME = "detections";
	const std::string _DETECTIONS_TAG = "DETECTIONS";
	const std::string _NORM_RECT_STREAM_NAME = "norm_rect_in";
	const std::string _NORM_RECT_TAG = "NORM_RECT";
	const std::string _IMAGE_IN_STREAM_NAME = "image_in";
	const std::string _IMAGE_OUT_STREAM_NAME = "image_out";
	const std::string _IMAGE_TAG = "IMAGE";
	const std::string _TASK_GRAPH_NAME = "mediapipe.tasks.vision.face_detector.FaceDetectorGraph";
	const int64_t _MICRO_SECONDS_PER_MILLISECOND = 1000;

	[[nodiscard]] absl::StatusOr<std::shared_ptr<FaceDetectorResult>> _build_detection_result(const PacketMap& output_packets) {
		const auto& detector_out_packet = output_packets.at(_DETECTIONS_OUT_STREAM_NAME);
		if (detector_out_packet.IsEmpty()) {
			return std::make_shared<FaceDetectorResult>();
		}

		auto detection_result = std::make_shared<FaceDetectorResult>();

		MP_PACKET_ASSIGN_OR_RETURN(const auto& detection_proto_list, std::vector<mediapipe::Detection>, output_packets.at(_DETECTIONS_OUT_STREAM_NAME));
		for (const auto& detection : detection_proto_list) {
			detection_result->detections->push_back(Detection::create_from_pb2(detection));
		}

		return detection_result;
	}
}

namespace mediapipe::tasks::autoit::vision::face_detector {
	absl::StatusOr<std::shared_ptr<FaceDetectorGraphOptions>> FaceDetectorOptions::to_pb2() const {
		auto pb2_obj = std::make_shared<FaceDetectorGraphOptions>();

		if (base_options) {
			MP_ASSIGN_OR_RETURN(auto base_options_proto, base_options->to_pb2());
			pb2_obj->mutable_base_options()->CopyFrom(*base_options_proto);
		}
		pb2_obj->mutable_base_options()->set_use_stream_mode(running_mode != VisionTaskRunningMode::IMAGE);

		if (min_detection_confidence) pb2_obj->set_min_detection_confidence(*min_detection_confidence);
		if (min_suppression_threshold) pb2_obj->set_min_suppression_threshold(*min_suppression_threshold);

		return pb2_obj;
	}

	absl::StatusOr<std::shared_ptr<FaceDetector>> FaceDetector::create(
		const CalculatorGraphConfig& graph_config,
		VisionTaskRunningMode running_mode,
		mediapipe::autoit::PacketsCallback packet_callback
	) {
		using BaseVisionTaskApi = core::base_vision_task_api::BaseVisionTaskApi;
		return BaseVisionTaskApi::create(graph_config, running_mode, packet_callback, static_cast<FaceDetector*>(nullptr));
	}

	absl::StatusOr<std::shared_ptr<FaceDetector>> FaceDetector::create_from_model_path(const std::string& model_path) {
		auto base_options = std::make_shared<BaseOptions>(model_path);
		return create_from_options(std::make_shared<FaceDetectorOptions>(base_options, VisionTaskRunningMode::IMAGE));
	}

	absl::StatusOr<std::shared_ptr<FaceDetector>> FaceDetector::create_from_options(std::shared_ptr<FaceDetectorOptions> options) {
		PacketsCallback packet_callback = nullptr;

		if (options->result_callback) {
			packet_callback = [options](const PacketMap& output_packets) {
				const auto image_out_packet = output_packets.at(_IMAGE_OUT_STREAM_NAME);
				if (image_out_packet.IsEmpty()) {
					return;
				}

				MP_ASSIGN_OR_THROW(auto detection_result, _build_detection_result(output_packets)); // There is no other choice than throw in a callback to stop the execution
				MP_PACKET_ASSIGN_OR_THROW(const auto& image, Image, image_out_packet); // There is no other choice than throw in a callback to stop the execution
				auto timestamp_ms = output_packets.at(_DETECTIONS_OUT_STREAM_NAME).Timestamp().Value() / _MICRO_SECONDS_PER_MILLISECOND;

				options->result_callback(*detection_result, image, timestamp_ms);
			};
		}

		TaskInfo task_info;
		task_info.task_graph = _TASK_GRAPH_NAME;
		*task_info.input_streams = {
			_IMAGE_TAG + ":" + _IMAGE_IN_STREAM_NAME,
			_NORM_RECT_TAG + ":" + _NORM_RECT_STREAM_NAME
		};
		*task_info.output_streams = {
			_DETECTIONS_TAG + ":" + _DETECTIONS_OUT_STREAM_NAME,
			_IMAGE_TAG + ":" + _IMAGE_OUT_STREAM_NAME
		};
		MP_ASSIGN_OR_RETURN(task_info.task_options, options->to_pb2());

		MP_ASSIGN_OR_RETURN(auto config, task_info.generate_graph_config(options->running_mode == VisionTaskRunningMode::LIVE_STREAM));

		return create(
			*config,
			options->running_mode,
			std::move(packet_callback)
		);
	}

	absl::StatusOr<std::shared_ptr<FaceDetectorResult>> FaceDetector::detect(
		const Image& image,
		std::shared_ptr<ImageProcessingOptions> image_processing_options
	) {
		MP_ASSIGN_OR_RETURN(auto normalized_rect, convert_to_normalized_rect(image_processing_options, image, false));

		MP_ASSIGN_OR_RETURN(auto output_packets, _process_image_data({
			{ _IMAGE_IN_STREAM_NAME, std::move(*std::move(create_image(image))) },
			{ _NORM_RECT_STREAM_NAME, std::move(*std::move(create_proto(*normalized_rect.to_pb2()))) },
			}));

		return _build_detection_result(output_packets);
	}

	absl::StatusOr<std::shared_ptr<FaceDetectorResult>> FaceDetector::detect_for_video(
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

		return _build_detection_result(output_packets);
	}

	absl::Status FaceDetector::detect_async(
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
}
