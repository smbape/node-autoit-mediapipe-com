#include "mediapipe/framework/port/status_macros.h"
#include "binding/tasks/vision/hand_landmarker.h"

namespace mediapipe::tasks::autoit::vision::hand_landmarker {
	using Connection = HandLandmarksConnections::Connection;

	const std::vector<Connection> HandLandmarksConnections::HAND_PALM_CONNECTIONS = {
		{ 0, 1 },
		{ 1, 5 },
		{ 9, 13 },
		{ 13, 17 },
		{ 5, 9 },
		{ 0, 17 },


		{ 1, 2 },
		{ 2, 3 },
		{ 3, 4 },


		{ 5, 6 },
		{ 6, 7 },
		{ 7, 8 },


		{ 9, 10 },
		{ 10, 11 },
		{ 11, 12 },


		{ 13, 14 },
		{ 14, 15 },
		{ 15, 16 },


		{ 17, 18 },
		{ 18, 19 },
		{ 19, 20 },
	};

	const std::vector<Connection> HandLandmarksConnections::HAND_THUMB_CONNECTIONS = {
		{ 0, 1 },
		{ 1, 5 },
		{ 9, 13 },
		{ 13, 17 },
		{ 5, 9 },
		{ 0, 17 },


		{ 1, 2 },
		{ 2, 3 },
		{ 3, 4 },


		{ 5, 6 },
		{ 6, 7 },
		{ 7, 8 },


		{ 9, 10 },
		{ 10, 11 },
		{ 11, 12 },


		{ 13, 14 },
		{ 14, 15 },
		{ 15, 16 },


		{ 17, 18 },
		{ 18, 19 },
		{ 19, 20 },
	};

	const std::vector<Connection> HandLandmarksConnections::HAND_INDEX_FINGER_CONNECTIONS = {
		{ 0, 1 },
		{ 1, 5 },
		{ 9, 13 },
		{ 13, 17 },
		{ 5, 9 },
		{ 0, 17 },


		{ 1, 2 },
		{ 2, 3 },
		{ 3, 4 },


		{ 5, 6 },
		{ 6, 7 },
		{ 7, 8 },


		{ 9, 10 },
		{ 10, 11 },
		{ 11, 12 },


		{ 13, 14 },
		{ 14, 15 },
		{ 15, 16 },


		{ 17, 18 },
		{ 18, 19 },
		{ 19, 20 },
	};

	const std::vector<Connection> HandLandmarksConnections::HAND_MIDDLE_FINGER_CONNECTIONS = {
		{ 0, 1 },
		{ 1, 5 },
		{ 9, 13 },
		{ 13, 17 },
		{ 5, 9 },
		{ 0, 17 },


		{ 1, 2 },
		{ 2, 3 },
		{ 3, 4 },


		{ 5, 6 },
		{ 6, 7 },
		{ 7, 8 },


		{ 9, 10 },
		{ 10, 11 },
		{ 11, 12 },


		{ 13, 14 },
		{ 14, 15 },
		{ 15, 16 },


		{ 17, 18 },
		{ 18, 19 },
		{ 19, 20 },
	};

	const std::vector<Connection> HandLandmarksConnections::HAND_RING_FINGER_CONNECTIONS = {
		{ 0, 1 },
		{ 1, 5 },
		{ 9, 13 },
		{ 13, 17 },
		{ 5, 9 },
		{ 0, 17 },


		{ 1, 2 },
		{ 2, 3 },
		{ 3, 4 },


		{ 5, 6 },
		{ 6, 7 },
		{ 7, 8 },


		{ 9, 10 },
		{ 10, 11 },
		{ 11, 12 },


		{ 13, 14 },
		{ 14, 15 },
		{ 15, 16 },


		{ 17, 18 },
		{ 18, 19 },
		{ 19, 20 },
	};

	const std::vector<Connection> HandLandmarksConnections::HAND_PINKY_FINGER_CONNECTIONS = {
		{ 0, 1 },
		{ 1, 5 },
		{ 9, 13 },
		{ 13, 17 },
		{ 5, 9 },
		{ 0, 17 },


		{ 1, 2 },
		{ 2, 3 },
		{ 3, 4 },


		{ 5, 6 },
		{ 6, 7 },
		{ 7, 8 },


		{ 9, 10 },
		{ 10, 11 },
		{ 11, 12 },


		{ 13, 14 },
		{ 14, 15 },
		{ 15, 16 },


		{ 17, 18 },
		{ 18, 19 },
		{ 19, 20 },
	};

	static std::vector<Connection> get_HAND_CONNECTIONS() {
		std::vector<Connection> connections;

		// preallocate memory
		connections.reserve(
			HandLandmarksConnections::HAND_PALM_CONNECTIONS.size() +
			HandLandmarksConnections::HAND_THUMB_CONNECTIONS.size() +
			HandLandmarksConnections::HAND_INDEX_FINGER_CONNECTIONS.size() +
			HandLandmarksConnections::HAND_MIDDLE_FINGER_CONNECTIONS.size() +
			HandLandmarksConnections::HAND_RING_FINGER_CONNECTIONS.size() +
			HandLandmarksConnections::HAND_PINKY_FINGER_CONNECTIONS.size()
		);

		connections.insert(connections.end(), HandLandmarksConnections::HAND_PALM_CONNECTIONS.begin(), HandLandmarksConnections::HAND_PALM_CONNECTIONS.end());
		connections.insert(connections.end(), HandLandmarksConnections::HAND_THUMB_CONNECTIONS.begin(), HandLandmarksConnections::HAND_THUMB_CONNECTIONS.end());
		connections.insert(connections.end(), HandLandmarksConnections::HAND_INDEX_FINGER_CONNECTIONS.begin(), HandLandmarksConnections::HAND_INDEX_FINGER_CONNECTIONS.end());
		connections.insert(connections.end(), HandLandmarksConnections::HAND_MIDDLE_FINGER_CONNECTIONS.begin(), HandLandmarksConnections::HAND_MIDDLE_FINGER_CONNECTIONS.end());
		connections.insert(connections.end(), HandLandmarksConnections::HAND_RING_FINGER_CONNECTIONS.begin(), HandLandmarksConnections::HAND_RING_FINGER_CONNECTIONS.end());
		connections.insert(connections.end(), HandLandmarksConnections::HAND_PINKY_FINGER_CONNECTIONS.begin(), HandLandmarksConnections::HAND_PINKY_FINGER_CONNECTIONS.end());

		return connections;
	}

	const std::vector<Connection> HandLandmarksConnections::HAND_CONNECTIONS = get_HAND_CONNECTIONS();
}

PTR_BRIDGE_IMPL(mediapipe::tasks::autoit::vision::hand_landmarker::HandLandmarkerResultRawCallback);

template<typename _Ty1, typename _Ty2>
inline const HRESULT autoit_to_callback(VARIANT const* const& in_val, _Ty1& out_val) {
	_Ty2 result_callback;
	HRESULT hr = autoit_to(in_val, result_callback);
	if (SUCCEEDED(hr)) {
		out_val = result_callback;
	}
	return hr;
}

const HRESULT autoit_to(VARIANT const* const& in_val, mediapipe::tasks::autoit::vision::hand_landmarker::HandLandmarkerResultCallback& out_val) {
	return autoit_to_callback<
		mediapipe::tasks::autoit::vision::hand_landmarker::HandLandmarkerResultCallback,
		mediapipe::tasks::autoit::vision::hand_landmarker::HandLandmarkerResultRawCallback
	>(in_val, out_val);
}

namespace {
	using namespace google::protobuf;
	using namespace mediapipe::autoit::packet_creator;
	using namespace mediapipe::autoit::packet_getter;
	using namespace mediapipe::tasks::autoit::components::containers;
	using namespace mediapipe::tasks::autoit::components::processors;
	using namespace mediapipe::tasks::autoit::core::base_options;
	using namespace mediapipe::tasks::autoit::core::task_info;
	using namespace mediapipe::tasks::autoit::vision::core::vision_task_running_mode;
	using namespace mediapipe::tasks::autoit::vision::hand_landmarker;
	using namespace mediapipe::tasks::vision::hand_landmarker::proto;
	using namespace mediapipe;

	using mediapipe::autoit::PacketsCallback;
	using mediapipe::tasks::core::PacketMap;

	const std::string _IMAGE_IN_STREAM_NAME = "image_in";
	const std::string _IMAGE_OUT_STREAM_NAME = "image_out";
	const std::string _IMAGE_TAG = "IMAGE";
	const std::string _NORM_RECT_STREAM_NAME = "norm_rect_in";
	const std::string _NORM_RECT_TAG = "NORM_RECT";
	const std::string _HANDEDNESS_STREAM_NAME = "handedness";
	const std::string _HANDEDNESS_TAG = "HANDEDNESS";
	const std::string _HAND_LANDMARKS_STREAM_NAME = "landmarks";
	const std::string _HAND_LANDMARKS_TAG = "LANDMARKS";
	const std::string _HAND_WORLD_LANDMARKS_STREAM_NAME = "world_landmarks";
	const std::string _HAND_WORLD_LANDMARKS_TAG = "WORLD_LANDMARKS";
	const std::string _TASK_GRAPH_NAME = "mediapipe.tasks.vision.hand_landmarker.HandLandmarkerGraph";
	const int64_t _MICRO_SECONDS_PER_MILLISECOND = 1000;

	[[nodiscard]] absl::StatusOr<std::shared_ptr<HandLandmarkerResult>> _build_landmarker_result(const PacketMap& output_packets) {
		if (output_packets.at(_HAND_LANDMARKS_STREAM_NAME).IsEmpty()) {
			return std::make_shared<HandLandmarkerResult>();
		}

		auto hand_landmarker_result = std::make_shared<HandLandmarkerResult>();

		MP_PACKET_ASSIGN_OR_RETURN(const auto& handedness_proto_list, std::vector<ClassificationList>, output_packets.at(_HANDEDNESS_STREAM_NAME));
		for (const auto& handedness_classifications : handedness_proto_list) {
			std::shared_ptr<std::vector<std::shared_ptr<category::Category>>> handedness_categories = std::make_shared<std::vector<std::shared_ptr<category::Category>>>();

			for (const auto& handedness : handedness_classifications.classification()) {
				handedness_categories->push_back(std::move(std::make_shared<category::Category>(
					handedness.index(),
					handedness.score(),
					handedness.display_name(),
					handedness.label()
				)));
			}

			hand_landmarker_result->handedness->push_back(std::move(handedness_categories));
		}

		MP_PACKET_ASSIGN_OR_RETURN(const auto& hand_landmarks_proto_list, std::vector<NormalizedLandmarkList>, output_packets.at(_HAND_LANDMARKS_STREAM_NAME));
		for (const auto& hand_landmarks : hand_landmarks_proto_list) {
			std::shared_ptr<std::vector<std::shared_ptr<landmark::NormalizedLandmark>>> hand_landmarks_list = std::make_shared<std::vector<std::shared_ptr<landmark::NormalizedLandmark>>>();

			for (const auto& hand_landmark : hand_landmarks.landmark()) {
				hand_landmarks_list->push_back(std::move(landmark::NormalizedLandmark::create_from_pb2(hand_landmark)));
			}

			hand_landmarker_result->hand_landmarks->push_back(std::move(hand_landmarks_list));
		}

		MP_PACKET_ASSIGN_OR_RETURN(const auto& hand_world_landmarks_proto_list, std::vector<LandmarkList>, output_packets.at(_HAND_WORLD_LANDMARKS_STREAM_NAME));
		for (const auto& hand_world_landmarks : hand_world_landmarks_proto_list) {
			std::shared_ptr<std::vector<std::shared_ptr<landmark::Landmark>>> hand_world_landmarks_list = std::make_shared<std::vector<std::shared_ptr<landmark::Landmark>>>();

			for (const auto& hand_world_landmark : hand_world_landmarks.landmark()) {
				hand_world_landmarks_list->push_back(std::move(landmark::Landmark::create_from_pb2(hand_world_landmark)));
			}

			hand_landmarker_result->hand_world_landmarks->push_back(std::move(hand_world_landmarks_list));
		}

		return hand_landmarker_result;
	}
}

namespace mediapipe::tasks::autoit::vision::hand_landmarker {
	using core::image_processing_options::ImageProcessingOptions;

	absl::StatusOr<std::shared_ptr<HandLandmarkerGraphOptions>> HandLandmarkerOptions::to_pb2() const {
		auto hand_landmarker_options_proto = std::make_shared<HandLandmarkerGraphOptions>();

		// Initialize the hand landmarker options from base options.
		if (base_options) {
			MP_ASSIGN_OR_RETURN(auto base_options_proto, base_options->to_pb2());
			hand_landmarker_options_proto->mutable_base_options()->CopyFrom(*base_options_proto);
		}
		hand_landmarker_options_proto->mutable_base_options()->set_use_stream_mode(running_mode != VisionTaskRunningMode::IMAGE);

		// Configure hand detector and hand landmarker options.
		hand_landmarker_options_proto->set_min_tracking_confidence(min_tracking_confidence);
		hand_landmarker_options_proto->mutable_hand_detector_graph_options()->set_num_hands(num_hands);
		hand_landmarker_options_proto->mutable_hand_detector_graph_options()->set_min_detection_confidence(min_hand_detection_confidence);
		hand_landmarker_options_proto->mutable_hand_landmarks_detector_graph_options()->set_min_detection_confidence(min_hand_presence_confidence);

		return hand_landmarker_options_proto;
	}

	absl::StatusOr<std::shared_ptr<HandLandmarker>> HandLandmarker::create(
		const CalculatorGraphConfig& graph_config,
		VisionTaskRunningMode running_mode,
		mediapipe::autoit::PacketsCallback packet_callback
	) {
		using BaseVisionTaskApi = core::base_vision_task_api::BaseVisionTaskApi;
		return BaseVisionTaskApi::create(graph_config, running_mode, std::move(packet_callback), static_cast<HandLandmarker*>(nullptr));
	}

	absl::StatusOr<std::shared_ptr<HandLandmarker>> HandLandmarker::create_from_model_path(const std::string& model_path) {
		auto base_options = std::make_shared<BaseOptions>(model_path);
		return create_from_options(std::make_shared<HandLandmarkerOptions>(base_options, VisionTaskRunningMode::IMAGE));
	}

	absl::StatusOr<std::shared_ptr<HandLandmarker>> HandLandmarker::create_from_options(std::shared_ptr<HandLandmarkerOptions> options) {
		PacketsCallback packet_callback = nullptr;

		if (options->result_callback) {
			packet_callback = [options](const PacketMap& output_packets) {
				const auto& image_out_packet = output_packets.at(_IMAGE_OUT_STREAM_NAME);
				if (image_out_packet.IsEmpty()) {
					return;
				}

				MP_ASSIGN_OR_THROW(auto hand_landmarker_result, _build_landmarker_result(output_packets)); // There is no other choice than throw in a callback to stop the execution
				MP_PACKET_ASSIGN_OR_THROW(const auto& image, Image, image_out_packet); // There is no other choice than throw in a callback to stop the execution
				auto timestamp_ms = output_packets.at(_HAND_LANDMARKS_STREAM_NAME).Timestamp().Value() / _MICRO_SECONDS_PER_MILLISECOND;

				options->result_callback(*hand_landmarker_result, image, timestamp_ms);
			};
		}

		TaskInfo task_info;
		task_info.task_graph = _TASK_GRAPH_NAME;
		*task_info.input_streams = {
			_IMAGE_TAG + ":" + _IMAGE_IN_STREAM_NAME,
			_NORM_RECT_TAG + ":" + _NORM_RECT_STREAM_NAME
		};
		*task_info.output_streams = {
			_HANDEDNESS_TAG + ":" + _HANDEDNESS_STREAM_NAME,
			_HAND_LANDMARKS_TAG + ":" + _HAND_LANDMARKS_STREAM_NAME,
			_HAND_WORLD_LANDMARKS_TAG + ":" + _HAND_WORLD_LANDMARKS_STREAM_NAME,
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

	absl::StatusOr<std::shared_ptr<HandLandmarkerResult>> HandLandmarker::detect(
		const Image& image,
		std::shared_ptr<ImageProcessingOptions> image_processing_options
	) {
		MP_ASSIGN_OR_RETURN(auto normalized_rect, convert_to_normalized_rect(image_processing_options, image, false));

		MP_ASSIGN_OR_RETURN(auto output_packets, _process_image_data({
			{ _IMAGE_IN_STREAM_NAME, std::move(*std::move(create_image(image))) },
			{ _NORM_RECT_STREAM_NAME, std::move(*std::move(create_proto(*normalized_rect.to_pb2()))) },
			}));

		return _build_landmarker_result(output_packets);
	}

	absl::StatusOr<std::shared_ptr<HandLandmarkerResult>> HandLandmarker::detect_for_video(
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

		return _build_landmarker_result(output_packets);
	}

	absl::Status HandLandmarker::detect_async(
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
