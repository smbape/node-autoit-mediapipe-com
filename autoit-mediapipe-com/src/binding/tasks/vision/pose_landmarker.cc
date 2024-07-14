#include "binding/tasks/vision/pose_landmarker.h"

namespace mediapipe::tasks::autoit::vision::pose_landmarker {
	using Connection = PoseLandmarksConnections::Connection;

	const std::vector<Connection> PoseLandmarksConnections::POSE_LANDMARKS = {
		{ 0, 1 },
		{ 1, 2 },
		{ 2, 3 },
		{ 3, 7 },
		{ 0, 4 },
		{ 4, 5 },
		{ 5, 6 },
		{ 6, 8 },
		{ 9, 10 },
		{ 11, 12 },
		{ 11, 13 },
		{ 13, 15 },
		{ 15, 17 },
		{ 15, 19 },
		{ 15, 21 },
		{ 17, 19 },
		{ 12, 14 },
		{ 14, 16 },
		{ 16, 18 },
		{ 16, 20 },
		{ 16, 22 },
		{ 18, 20 },
		{ 11, 23 },
		{ 12, 24 },
		{ 23, 24 },
		{ 23, 25 },
		{ 24, 26 },
		{ 25, 27 },
		{ 26, 28 },
		{ 27, 29 },
		{ 28, 30 },
		{ 29, 31 },
		{ 30, 32 },
		{ 27, 31 },
		{ 28, 32 },
	};
}

PTR_BRIDGE_IMPL(mediapipe::tasks::autoit::vision::pose_landmarker::PoseLandmarkerResultRawCallback);

template<typename _Ty1, typename _Ty2>
inline const HRESULT autoit_to_callback(VARIANT const* const& in_val, _Ty1& out_val) {
	_Ty2 result_callback;
	HRESULT hr = autoit_to(in_val, result_callback);
	if (SUCCEEDED(hr)) {
		out_val = result_callback;
	}
	return hr;
}

const HRESULT autoit_to(VARIANT const* const& in_val, mediapipe::tasks::autoit::vision::pose_landmarker::PoseLandmarkerResultCallback& out_val) {
	return autoit_to_callback<
		mediapipe::tasks::autoit::vision::pose_landmarker::PoseLandmarkerResultCallback,
		mediapipe::tasks::autoit::vision::pose_landmarker::PoseLandmarkerResultRawCallback
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
	using namespace mediapipe::tasks::autoit::vision::pose_landmarker;
	using namespace mediapipe::tasks::vision::pose_landmarker::proto;
	using namespace mediapipe;

	using mediapipe::autoit::PacketsCallback;
	using mediapipe::tasks::core::PacketMap;

	const std::string _IMAGE_IN_STREAM_NAME = "image_in";
	const std::string _IMAGE_OUT_STREAM_NAME = "image_out";
	const std::string _IMAGE_TAG = "IMAGE";
	const std::string _NORM_RECT_STREAM_NAME = "norm_rect_in";
	const std::string _NORM_RECT_TAG = "NORM_RECT";
	const std::string _SEGMENTATION_MASK_STREAM_NAME = "segmentation_mask";
	const std::string _SEGMENTATION_MASK_TAG = "SEGMENTATION_MASK";
	const std::string _NORM_LANDMARKS_STREAM_NAME = "norm_landmarks";
	const std::string _NORM_LANDMARKS_TAG = "NORM_LANDMARKS";
	const std::string _POSE_WORLD_LANDMARKS_STREAM_NAME = "world_landmarks";
	const std::string _POSE_WORLD_LANDMARKS_TAG = "WORLD_LANDMARKS";
	const std::string _TASK_GRAPH_NAME = "mediapipe.tasks.vision.pose_landmarker.PoseLandmarkerGraph";
	const int64_t _MICRO_SECONDS_PER_MILLISECOND = 1000;

	[[nodiscard]] absl::StatusOr<std::shared_ptr<PoseLandmarkerResult>> _build_landmarker_result(const PacketMap& output_packets) {
		if (output_packets.at(_NORM_LANDMARKS_STREAM_NAME).IsEmpty()) {
			return std::make_shared<PoseLandmarkerResult>();
		}

		auto pose_landmarker_result = std::make_shared<PoseLandmarkerResult>();

		if (output_packets.count(_SEGMENTATION_MASK_STREAM_NAME)) {
			MP_PACKET_ASSIGN_OR_RETURN(const auto& segmentation_masks, std::vector<Image>, output_packets.at(_SEGMENTATION_MASK_STREAM_NAME));
			for (const auto& image : segmentation_masks) {
				pose_landmarker_result->segmentation_masks->push_back(std::make_shared<Image>(image));
			}
		}

		MP_PACKET_ASSIGN_OR_RETURN(const auto& pose_landmarks_proto_list, std::vector<NormalizedLandmarkList>, output_packets.at(_NORM_LANDMARKS_STREAM_NAME));
		for (const auto& pose_landmarks : pose_landmarks_proto_list) {
			std::shared_ptr<std::vector<std::shared_ptr<landmark::NormalizedLandmark>>> pose_landmarks_list = std::make_shared<std::vector<std::shared_ptr<landmark::NormalizedLandmark>>>();

			for (const auto& pose_landmark : pose_landmarks.landmark()) {
				pose_landmarks_list->push_back(landmark::NormalizedLandmark::create_from_pb2(pose_landmark));
			}

			pose_landmarker_result->pose_landmarks->push_back(std::move(pose_landmarks_list));
		}

		MP_PACKET_ASSIGN_OR_RETURN(const auto& pose_world_landmarks_proto_list, std::vector<LandmarkList>, output_packets.at(_POSE_WORLD_LANDMARKS_STREAM_NAME));
		for (const auto& pose_world_landmarks : pose_world_landmarks_proto_list) {
			std::shared_ptr<std::vector<std::shared_ptr<landmark::Landmark>>> pose_world_landmarks_list = std::make_shared<std::vector<std::shared_ptr<landmark::Landmark>>>();

			for (const auto& pose_world_landmark : pose_world_landmarks.landmark()) {
				pose_world_landmarks_list->push_back(landmark::Landmark::create_from_pb2(pose_world_landmark));
			}

			pose_landmarker_result->pose_world_landmarks->push_back(std::move(pose_world_landmarks_list));
		}

		return pose_landmarker_result;
	}
}

namespace mediapipe::tasks::autoit::vision::pose_landmarker {
	using core::image_processing_options::ImageProcessingOptions;

	absl::StatusOr<std::shared_ptr<PoseLandmarkerGraphOptions>> PoseLandmarkerOptions::to_pb2() const {
		auto pose_landmarker_options_proto = std::make_shared<PoseLandmarkerGraphOptions>();

		// Initialize the pose landmarker options from base options.
		if (base_options) {
			MP_ASSIGN_OR_RETURN(auto base_options_proto, base_options->to_pb2());
			pose_landmarker_options_proto->mutable_base_options()->CopyFrom(*base_options_proto);
		}
		pose_landmarker_options_proto->mutable_base_options()->set_use_stream_mode(running_mode != VisionTaskRunningMode::IMAGE);

		// Configure pose detector and pose landmarker options.
		pose_landmarker_options_proto->set_min_tracking_confidence(min_tracking_confidence);
		pose_landmarker_options_proto->mutable_pose_detector_graph_options()->set_num_poses(num_poses);
		pose_landmarker_options_proto->mutable_pose_detector_graph_options()->set_min_detection_confidence(min_pose_detection_confidence);
		pose_landmarker_options_proto->mutable_pose_landmarks_detector_graph_options()->set_min_detection_confidence(min_pose_presence_confidence);

		return pose_landmarker_options_proto;
	}

	absl::StatusOr<std::shared_ptr<PoseLandmarker>> PoseLandmarker::create(
		const CalculatorGraphConfig& graph_config,
		VisionTaskRunningMode running_mode,
		mediapipe::autoit::PacketsCallback packet_callback
	) {
		using BaseVisionTaskApi = core::base_vision_task_api::BaseVisionTaskApi;
		return BaseVisionTaskApi::create(graph_config, running_mode, packet_callback, static_cast<PoseLandmarker*>(nullptr));
	}

	absl::StatusOr<std::shared_ptr<PoseLandmarker>> PoseLandmarker::create_from_model_path(const std::string& model_path) {
		auto base_options = std::make_shared<BaseOptions>(model_path);
		return create_from_options(std::make_shared<PoseLandmarkerOptions>(base_options, VisionTaskRunningMode::IMAGE));
	}

	absl::StatusOr<std::shared_ptr<PoseLandmarker>> PoseLandmarker::create_from_options(std::shared_ptr<PoseLandmarkerOptions> options) {
		PacketsCallback packet_callback = nullptr;

		if (options->result_callback) {
			packet_callback = [options](const PacketMap& output_packets) {
				const auto& image_out_packet = output_packets.at(_IMAGE_OUT_STREAM_NAME);
				if (image_out_packet.IsEmpty()) {
					return;
				}

				MP_ASSIGN_OR_THROW(auto pose_landmarker_result, _build_landmarker_result(output_packets)); // There is no other choice than throw in a callback to stop the execution
				MP_PACKET_ASSIGN_OR_THROW(const auto& image, Image, image_out_packet); // There is no other choice than throw in a callback to stop the execution
				auto timestamp_ms = output_packets.at(_NORM_LANDMARKS_STREAM_NAME).Timestamp().Value() / _MICRO_SECONDS_PER_MILLISECOND;

				options->result_callback(*pose_landmarker_result, image, timestamp_ms);
			};
		}

		TaskInfo task_info;
		task_info.task_graph = _TASK_GRAPH_NAME;
		*task_info.input_streams = {
			_IMAGE_TAG + ":" + _IMAGE_IN_STREAM_NAME,
			_NORM_RECT_TAG + ":" + _NORM_RECT_STREAM_NAME
		};
		*task_info.output_streams = {
			_NORM_LANDMARKS_TAG + ":" + _NORM_LANDMARKS_STREAM_NAME,
			_POSE_WORLD_LANDMARKS_TAG + ":" + _POSE_WORLD_LANDMARKS_STREAM_NAME,
			_IMAGE_TAG + ":" + _IMAGE_OUT_STREAM_NAME
		};
		MP_ASSIGN_OR_RETURN(task_info.task_options, options->to_pb2());

		if (options->output_segmentation_masks) {
			task_info.output_streams->push_back(_SEGMENTATION_MASK_TAG + ":" + _SEGMENTATION_MASK_STREAM_NAME);
		}

		MP_ASSIGN_OR_RETURN(auto config, task_info.generate_graph_config(options->running_mode == VisionTaskRunningMode::LIVE_STREAM));

		return create(
			*config,
			options->running_mode,
			std::move(packet_callback)
		);
	}

	absl::StatusOr<std::shared_ptr<PoseLandmarkerResult>> PoseLandmarker::detect(
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

	absl::StatusOr<std::shared_ptr<PoseLandmarkerResult>> PoseLandmarker::detect_for_video(
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

	absl::Status PoseLandmarker::detect_async(
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
