#include "mediapipe/framework/port/status_macros.h"
#include "binding/tasks/vision/holistic_landmarker.h"

PTR_BRIDGE_IMPL(mediapipe::tasks::autoit::vision::holistic_landmarker::HolisticLandmarkerResultRawCallback);

template<typename _Ty1, typename _Ty2>
inline const HRESULT autoit_to_callback(VARIANT const* const& in_val, _Ty1& out_val) {
	_Ty2 result_callback;
	HRESULT hr = autoit_to(in_val, result_callback);
	if (SUCCEEDED(hr)) {
		out_val = result_callback;
	}
	return hr;
}

const HRESULT autoit_to(VARIANT const* const& in_val, mediapipe::tasks::autoit::vision::holistic_landmarker::HolisticLandmarkerResultCallback& out_val) {
	return autoit_to_callback<
		mediapipe::tasks::autoit::vision::holistic_landmarker::HolisticLandmarkerResultCallback,
		mediapipe::tasks::autoit::vision::holistic_landmarker::HolisticLandmarkerResultRawCallback
	>(in_val, out_val);
}

namespace {
	using namespace google::protobuf::autoit::cmessage;
	using namespace google::protobuf;
	using namespace mediapipe::autoit::packet_creator;
	using namespace mediapipe::autoit::packet_getter;
	using namespace mediapipe::tasks::autoit::components::containers;
	using namespace mediapipe::tasks::autoit::components::processors;
	using namespace mediapipe::tasks::autoit::core::base_options;
	using namespace mediapipe::tasks::autoit::core::task_info;
	using namespace mediapipe::tasks::autoit::vision::core::vision_task_running_mode;
	using namespace mediapipe::tasks::autoit::vision::holistic_landmarker;
	using namespace mediapipe::tasks::vision::holistic_landmarker::proto;
	using namespace mediapipe;


	using mediapipe::autoit::PacketsCallback;
	using mediapipe::tasks::core::PacketMap;

	const std::string _IMAGE_IN_STREAM_NAME = "image_in";
	const std::string _IMAGE_OUT_STREAM_NAME = "image_out";
	const std::string _IMAGE_TAG = "IMAGE";

	const std::string _POSE_LANDMARKS_STREAM_NAME = "pose_landmarks";
	const std::string _POSE_LANDMARKS_TAG_NAME = "POSE_LANDMARKS";
	const std::string _POSE_WORLD_LANDMARKS_STREAM_NAME = "pose_world_landmarks";
	const std::string _POSE_WORLD_LANDMARKS_TAG = "POSE_WORLD_LANDMARKS";
	const std::string _POSE_SEGMENTATION_MASK_STREAM_NAME = "pose_segmentation_mask";
	const std::string _POSE_SEGMENTATION_MASK_TAG = "POSE_SEGMENTATION_MASK";
	const std::string _FACE_LANDMARKS_STREAM_NAME = "face_landmarks";
	const std::string _FACE_LANDMARKS_TAG = "FACE_LANDMARKS";
	const std::string _FACE_BLENDSHAPES_STREAM_NAME = "extra_blendshapes";
	const std::string _FACE_BLENDSHAPES_TAG = "FACE_BLENDSHAPES";
	const std::string _LEFT_HAND_LANDMARKS_STREAM_NAME = "left_hand_landmarks";
	const std::string _LEFT_HAND_LANDMARKS_TAG = "LEFT_HAND_LANDMARKS";
	const std::string _LEFT_HAND_WORLD_LANDMARKS_STREAM_NAME = "left_hand_world_landmarks";
	const std::string _LEFT_HAND_WORLD_LANDMARKS_TAG = "LEFT_HAND_WORLD_LANDMARKS";
	const std::string _RIGHT_HAND_LANDMARKS_STREAM_NAME = "right_hand_landmarks";
	const std::string _RIGHT_HAND_LANDMARKS_TAG = "RIGHT_HAND_LANDMARKS";
	const std::string _RIGHT_HAND_WORLD_LANDMARKS_STREAM_NAME = "right_hand_world_landmarks";
	const std::string _RIGHT_HAND_WORLD_LANDMARKS_TAG = "RIGHT_HAND_WORLD_LANDMARKS";

	const std::string _TASK_GRAPH_NAME = "mediapipe.tasks.vision.holistic_landmarker.HolisticLandmarkerGraph";
	const int64_t _MICRO_SECONDS_PER_MILLISECOND = 1000;

	[[nodiscard]] absl::StatusOr<std::shared_ptr<HolisticLandmarkerResult>> _build_landmarker_result(const PacketMap& output_packets) {
		if (output_packets.at(_FACE_LANDMARKS_STREAM_NAME).IsEmpty()) {
			return std::make_shared<HolisticLandmarkerResult>();
		}

		auto holistic_landmarker_result = std::make_shared<HolisticLandmarkerResult>();

		MP_PACKET_ASSIGN_OR_RETURN(const auto& face_landmarks_proto_list, NormalizedLandmarkList, output_packets.at(_FACE_LANDMARKS_STREAM_NAME));

		MP_PACKET_ASSIGN_OR_RETURN(const auto& pose_landmarks_proto_list, NormalizedLandmarkList, output_packets.at(_POSE_LANDMARKS_STREAM_NAME));

		MP_PACKET_ASSIGN_OR_RETURN(const auto& pose_world_landmarks_proto_list, LandmarkList, output_packets.at(_POSE_WORLD_LANDMARKS_STREAM_NAME));

		MP_PACKET_ASSIGN_OR_RETURN(const auto& left_hand_landmarks_proto_list, NormalizedLandmarkList, output_packets.at(_LEFT_HAND_LANDMARKS_STREAM_NAME));

		MP_PACKET_ASSIGN_OR_RETURN(const auto& left_hand_world_landmarks_proto_list, LandmarkList, output_packets.at(_LEFT_HAND_WORLD_LANDMARKS_STREAM_NAME));

		MP_PACKET_ASSIGN_OR_RETURN(const auto& right_hand_landmarks_proto_list, NormalizedLandmarkList, output_packets.at(_RIGHT_HAND_LANDMARKS_STREAM_NAME));

		MP_PACKET_ASSIGN_OR_RETURN(const auto& right_hand_world_landmarks_proto_list, LandmarkList, output_packets.at(_RIGHT_HAND_WORLD_LANDMARKS_STREAM_NAME));

		for (const auto& face_landmark : face_landmarks_proto_list.landmark()) {
			holistic_landmarker_result->face_landmarks->push_back(std::move(landmark::NormalizedLandmark::create_from_pb2(face_landmark)));
		}

		for (const auto& pose_landmark : pose_landmarks_proto_list.landmark()) {
			holistic_landmarker_result->pose_landmarks->push_back(std::move(landmark::NormalizedLandmark::create_from_pb2(pose_landmark)));
		}

		for (const auto& pose_world_landmark : pose_world_landmarks_proto_list.landmark()) {
			holistic_landmarker_result->pose_world_landmarks->push_back(std::move(landmark::Landmark::create_from_pb2(pose_world_landmark)));
		}

		for (const auto& left_hand_landmark : left_hand_landmarks_proto_list.landmark()) {
			holistic_landmarker_result->left_hand_landmarks->push_back(std::move(landmark::NormalizedLandmark::create_from_pb2(left_hand_landmark)));
		}

		for (const auto& left_hand_world_landmark : left_hand_world_landmarks_proto_list.landmark()) {
			holistic_landmarker_result->left_hand_world_landmarks->push_back(std::move(landmark::Landmark::create_from_pb2(left_hand_world_landmark)));
		}

		for (const auto& right_hand_landmark : right_hand_landmarks_proto_list.landmark()) {
			holistic_landmarker_result->right_hand_landmarks->push_back(std::move(landmark::NormalizedLandmark::create_from_pb2(right_hand_landmark)));
		}

		for (const auto& right_hand_world_landmark : right_hand_world_landmarks_proto_list.landmark()) {
			holistic_landmarker_result->right_hand_world_landmarks->push_back(std::move(landmark::Landmark::create_from_pb2(right_hand_world_landmark)));
		}

		if (output_packets.count(_FACE_BLENDSHAPES_STREAM_NAME)) {
			MP_PACKET_ASSIGN_OR_RETURN(const auto& face_blendshapes_proto_list, ClassificationList, output_packets.at(_FACE_BLENDSHAPES_STREAM_NAME));

			for (const auto& face_blendshapes : face_blendshapes_proto_list.classification()) {
				holistic_landmarker_result->face_blendshapes->push_back(std::move(std::make_shared<category::Category>(
					face_blendshapes.index(),
					face_blendshapes.score(),
					face_blendshapes.display_name(),
					face_blendshapes.label()
				)));
			}
		}

		if (output_packets.count(_POSE_SEGMENTATION_MASK_STREAM_NAME)) {
			MP_PACKET_ASSIGN_OR_RETURN(const auto& image, Image, output_packets.at(_POSE_SEGMENTATION_MASK_STREAM_NAME));
			holistic_landmarker_result->segmentation_mask = std::make_shared<Image>(image);
		}

		return holistic_landmarker_result;
	}
}

namespace mediapipe::tasks::autoit::vision::holistic_landmarker {
	using core::image_processing_options::ImageProcessingOptions;

	std::shared_ptr<HolisticLandmarkerResult> HolisticLandmarkerResult::create_from_pb2(const HolisticResult& pb2_obj) {
		auto holistic_landmarker_result = std::make_shared<HolisticLandmarkerResult>();

		for (const auto& landmark : pb2_obj.face_landmarks().landmark()) {
			holistic_landmarker_result->face_landmarks->push_back(std::move(landmark::NormalizedLandmark::create_from_pb2(landmark)));
		}

		for (const auto& landmark : pb2_obj.pose_landmarks().landmark()) {
			holistic_landmarker_result->pose_landmarks->push_back(std::move(landmark::NormalizedLandmark::create_from_pb2(landmark)));
		}

		for (const auto& landmark : pb2_obj.pose_world_landmarks().landmark()) {
			holistic_landmarker_result->pose_world_landmarks->push_back(std::move(landmark::Landmark::create_from_pb2(landmark)));
		}

		for (const auto& landmark : pb2_obj.left_hand_landmarks().landmark()) {
			holistic_landmarker_result->left_hand_landmarks->push_back(std::move(landmark::NormalizedLandmark::create_from_pb2(landmark)));
		}

		for (const auto& landmark : pb2_obj.right_hand_landmarks().landmark()) {
			holistic_landmarker_result->right_hand_landmarks->push_back(std::move(landmark::NormalizedLandmark::create_from_pb2(landmark)));
		}

		for (const auto& classification : pb2_obj.face_blendshapes().classification()) {
			holistic_landmarker_result->face_blendshapes->push_back(std::move(std::make_shared<category::Category>(
				classification.index(),
				classification.score(),
				classification.display_name(),
				classification.label()
			)));
		}

		return holistic_landmarker_result;
	}

	absl::StatusOr<std::shared_ptr<HolisticLandmarkerGraphOptions>> HolisticLandmarkerOptions::to_pb2() const {
		auto holistic_landmarker_options_proto = std::make_shared<HolisticLandmarkerGraphOptions>();

		// Initialize the holistic landmarker options from base options.
		if (base_options) {
			MP_ASSIGN_OR_RETURN(auto base_options_proto, base_options->to_pb2());
			holistic_landmarker_options_proto->mutable_base_options()->CopyFrom(*base_options_proto);
		}
		holistic_landmarker_options_proto->mutable_base_options()->set_use_stream_mode(running_mode != VisionTaskRunningMode::IMAGE);

		// Configure face detector and face landmarks detector options.
		holistic_landmarker_options_proto->mutable_face_detector_graph_options()->set_min_detection_confidence(min_face_detection_confidence);
		holistic_landmarker_options_proto->mutable_face_detector_graph_options()->set_min_suppression_threshold(min_face_suppression_threshold);
		holistic_landmarker_options_proto->mutable_face_landmarks_detector_graph_options()->set_min_detection_confidence(min_face_landmarks_confidence);

		// Configure pose detector and pose landmarks detector options.
		holistic_landmarker_options_proto->mutable_pose_detector_graph_options()->set_min_detection_confidence(min_pose_detection_confidence);
		holistic_landmarker_options_proto->mutable_pose_detector_graph_options()->set_min_suppression_threshold(min_pose_suppression_threshold);
		holistic_landmarker_options_proto->mutable_pose_landmarks_detector_graph_options()->set_min_detection_confidence(min_pose_landmarks_confidence);

		// Configure hand landmarks detector options.
		holistic_landmarker_options_proto->mutable_hand_landmarks_detector_graph_options()->set_min_detection_confidence(min_hand_landmarks_confidence);

		return holistic_landmarker_options_proto;
	}

	absl::StatusOr<std::shared_ptr<HolisticLandmarker>> HolisticLandmarker::create(
		const CalculatorGraphConfig& graph_config,
		VisionTaskRunningMode running_mode,
		mediapipe::autoit::PacketsCallback packet_callback
	) {
		using BaseVisionTaskApi = core::base_vision_task_api::BaseVisionTaskApi;
		return BaseVisionTaskApi::create(graph_config, running_mode, std::move(packet_callback), static_cast<HolisticLandmarker*>(nullptr));
	}

	absl::StatusOr<std::shared_ptr<HolisticLandmarker>> HolisticLandmarker::create_from_model_path(const std::string& model_path) {
		auto base_options = std::make_shared<BaseOptions>(model_path);
		return create_from_options(std::make_shared<HolisticLandmarkerOptions>(base_options, VisionTaskRunningMode::IMAGE));
	}

	absl::StatusOr<std::shared_ptr<HolisticLandmarker>> HolisticLandmarker::create_from_options(std::shared_ptr<HolisticLandmarkerOptions> options) {
		PacketsCallback packet_callback = nullptr;

		if (options->result_callback) {
			packet_callback = [options](const PacketMap& output_packets) {
				const auto& image_out_packet = output_packets.at(_IMAGE_OUT_STREAM_NAME);
				if (image_out_packet.IsEmpty()) {
					return;
				}

				MP_ASSIGN_OR_THROW(auto holistic_landmarks_detection_result, _build_landmarker_result(output_packets)); // There is no other choice than throw in a callback to stop the execution
				MP_PACKET_ASSIGN_OR_THROW(const auto& image, Image, image_out_packet); // There is no other choice than throw in a callback to stop the execution
				auto timestamp_ms = output_packets.at(_FACE_LANDMARKS_STREAM_NAME).Timestamp().Value() / _MICRO_SECONDS_PER_MILLISECOND;

				options->result_callback(*holistic_landmarks_detection_result, image, timestamp_ms);
				};
		}

		TaskInfo task_info;
		task_info.task_graph = _TASK_GRAPH_NAME;
		*task_info.input_streams = {
			_IMAGE_TAG + ":" + _IMAGE_IN_STREAM_NAME
		};
		*task_info.output_streams = {
			_FACE_LANDMARKS_TAG + ":" + _FACE_LANDMARKS_STREAM_NAME,
			_POSE_LANDMARKS_TAG_NAME + ":" + _POSE_LANDMARKS_STREAM_NAME,
			_POSE_WORLD_LANDMARKS_TAG + ":" + _POSE_WORLD_LANDMARKS_STREAM_NAME,
			_LEFT_HAND_LANDMARKS_TAG + ":" + _LEFT_HAND_LANDMARKS_STREAM_NAME,
			_LEFT_HAND_WORLD_LANDMARKS_TAG + ":" + _LEFT_HAND_WORLD_LANDMARKS_STREAM_NAME,
			_RIGHT_HAND_LANDMARKS_TAG + ":" + _RIGHT_HAND_LANDMARKS_STREAM_NAME,
			_RIGHT_HAND_WORLD_LANDMARKS_TAG + ":" + _RIGHT_HAND_WORLD_LANDMARKS_STREAM_NAME,
			_IMAGE_TAG + ":" + _IMAGE_OUT_STREAM_NAME
		};
		MP_ASSIGN_OR_RETURN(task_info.task_options, options->to_pb2());

		if (options->output_segmentation_mask) {
			task_info.output_streams->push_back(_POSE_SEGMENTATION_MASK_TAG + ":" + _POSE_SEGMENTATION_MASK_STREAM_NAME);
		}

		if (options->output_face_blendshapes) {
			task_info.output_streams->push_back(_FACE_BLENDSHAPES_TAG + ":" + _FACE_BLENDSHAPES_STREAM_NAME);
		}

		MP_ASSIGN_OR_RETURN(auto config, task_info.generate_graph_config(options->running_mode == VisionTaskRunningMode::LIVE_STREAM));

		return create(
			*config,
			options->running_mode,
			std::move(packet_callback)
		);
	}

	absl::StatusOr<std::shared_ptr<HolisticLandmarkerResult>> HolisticLandmarker::detect(
		const Image& image,
		std::shared_ptr<ImageProcessingOptions> image_processing_options
	) {
		MP_ASSIGN_OR_RETURN(auto output_packets, _process_image_data({
			{ _IMAGE_IN_STREAM_NAME, std::move(*std::move(create_image(image))) },
			}));

		return _build_landmarker_result(output_packets);
	}

	absl::StatusOr<std::shared_ptr<HolisticLandmarkerResult>> HolisticLandmarker::detect_for_video(
		const Image& image,
		int64_t timestamp_ms,
		std::shared_ptr<ImageProcessingOptions> image_processing_options
	) {
		MP_ASSIGN_OR_RETURN(auto output_packets, _process_video_data({
			{ _IMAGE_IN_STREAM_NAME, std::move(std::move(create_image(image))->At(
				Timestamp(timestamp_ms * _MICRO_SECONDS_PER_MILLISECOND)
			)) },
			}));

		return _build_landmarker_result(output_packets);
	}

	absl::Status HolisticLandmarker::detect_async(
		const Image& image,
		int64_t timestamp_ms,
		std::shared_ptr<ImageProcessingOptions> image_processing_options
	) {
		return _send_live_stream_data({
			{ _IMAGE_IN_STREAM_NAME, std::move(std::move(create_image(image))->At(
				Timestamp(timestamp_ms * _MICRO_SECONDS_PER_MILLISECOND)
			)) },
			});
	}
}
