#include "binding/tasks/vision/gesture_recognizer.h"

PTR_BRIDGE_IMPL(mediapipe::tasks::autoit::vision::gesture_recognizer::GestureRecognizerResultRawCallback);

template<typename _Ty1, typename _Ty2>
inline const HRESULT autoit_to_callback(VARIANT const* const& in_val, _Ty1& out_val) {
	_Ty2 result_callback;
	HRESULT hr = autoit_to(in_val, result_callback);
	if (SUCCEEDED(hr)) {
		out_val = result_callback;
	}
	return hr;
}

const HRESULT autoit_to(VARIANT const* const& in_val, mediapipe::tasks::autoit::vision::gesture_recognizer::GestureRecognizerResultCallback& out_val) {
	return autoit_to_callback<
		mediapipe::tasks::autoit::vision::gesture_recognizer::GestureRecognizerResultCallback,
		mediapipe::tasks::autoit::vision::gesture_recognizer::GestureRecognizerResultRawCallback
	>(in_val, out_val);
}

namespace {
	using namespace mediapipe::tasks::vision::gesture_recognizer::proto;
	using namespace mediapipe::tasks::autoit::vision::core::vision_task_running_mode;
	using namespace mediapipe::tasks::autoit::core::base_options;
	using namespace mediapipe::tasks::autoit::core::task_info;
	using namespace mediapipe::tasks::autoit::vision::gesture_recognizer;
	using namespace mediapipe;

	using mediapipe::autoit::PacketsCallback;
	using mediapipe::tasks::core::PacketMap;

	const std::string _IMAGE_IN_STREAM_NAME = "image_in";
	const std::string _IMAGE_OUT_STREAM_NAME = "image_out";
	const std::string _IMAGE_TAG = "IMAGE";
	const std::string _NORM_RECT_STREAM_NAME = "norm_rect_in";
	const std::string _NORM_RECT_TAG = "NORM_RECT";
	const std::string _HAND_GESTURE_STREAM_NAME = "hand_gestures";
	const std::string _HAND_GESTURE_TAG = "HAND_GESTURES";
	const std::string _HANDEDNESS_STREAM_NAME = "handedness";
	const std::string _HANDEDNESS_TAG = "HANDEDNESS";
	const std::string _HAND_LANDMARKS_STREAM_NAME = "landmarks";
	const std::string _HAND_LANDMARKS_TAG = "LANDMARKS";
	const std::string _HAND_WORLD_LANDMARKS_STREAM_NAME = "world_landmarks";
	const std::string _HAND_WORLD_LANDMARKS_TAG = "WORLD_LANDMARKS";
	const std::string _TASK_GRAPH_NAME = "mediapipe.tasks.vision.gesture_recognizer.GestureRecognizerGraph";
	const int64_t _MICRO_SECONDS_PER_MILLISECOND = 1000;
	const int _GESTURE_DEFAULT_INDEX = -1;

	std::shared_ptr<GestureRecognizerResult> _build_recognition_result(const PacketMap& output_packets) {
		if (output_packets.at(_HAND_GESTURE_STREAM_NAME).IsEmpty()) {
			return std::make_shared<GestureRecognizerResult>();
		}

		auto gestures_proto_list = mediapipe::autoit::packet_getter::get_proto_list(
			output_packets.at(_HAND_GESTURE_STREAM_NAME));
		auto handedness_proto_list = mediapipe::autoit::packet_getter::get_proto_list(
			output_packets.at(_HANDEDNESS_STREAM_NAME));
		auto hand_landmarks_proto_list = mediapipe::autoit::packet_getter::get_proto_list(
			output_packets.at(_HAND_LANDMARKS_STREAM_NAME));
		auto hand_world_landmarks_proto_list = mediapipe::autoit::packet_getter::get_proto_list(
			output_packets.at(_HAND_WORLD_LANDMARKS_STREAM_NAME));

		std::vector<std::vector<std::shared_ptr<category::Category>>> gesture_results;
		for (const auto& proto : gestures_proto_list) {
			std::vector<std::shared_ptr<category::Category>> gesture_categories;

			// ClassificationList gesture_classifications;
			// gesture_classifications.MergeFrom(*proto); // Is it necessary? Shouldn't reinterpret_cast(&proto) be enough?
			const auto& gesture_classifications = *static_cast<ClassificationList const*>(proto.get());
			for (const auto& gesture : gesture_classifications.classification()) {
				gesture_categories.push_back(std::make_shared<category::Category>(
					_GESTURE_DEFAULT_INDEX,
					gesture.score(),
					gesture.display_name(),
					gesture.label()
					));
			}

			gesture_results.push_back(std::move(gesture_categories));
		}

		std::vector<std::vector<std::shared_ptr<category::Category>>> handedness_results;
		for (const auto& proto : handedness_proto_list) {
			std::vector<std::shared_ptr<category::Category>> handedness_categories;

			// ClassificationList handedness_classifications;
			// handedness_classifications.MergeFrom(*proto); // Is it necessary? Shouldn't reinterpret_cast(&proto) be enough?
			const auto& handedness_classifications = *static_cast<ClassificationList const*>(proto.get());
			for (const auto& handedness : handedness_classifications.classification()) {
				handedness_categories.push_back(std::make_shared<category::Category>(
					handedness.index(),
					handedness.score(),
					handedness.display_name(),
					handedness.label()
					));
			}

			handedness_results.push_back(std::move(handedness_categories));
		}

		std::vector<std::vector<std::shared_ptr<landmark::NormalizedLandmark>>> hand_landmarks_results;
		for (const auto& proto : hand_landmarks_proto_list) {
			std::vector<std::shared_ptr<landmark::NormalizedLandmark>> hand_landmarks_list;

			// NormalizedLandmarkList hand_landmarks;
			// hand_landmarks.MergeFrom(*proto); // Is it necessary? Shouldn't reinterpret_cast(&proto) be enough?
			const auto& hand_landmarks = *static_cast<NormalizedLandmarkList const*>(proto.get());
			for (const auto& hand_landmark : hand_landmarks.landmark()) {
				hand_landmarks_list.push_back(landmark::NormalizedLandmark::create_from_pb2(hand_landmark));
			}

			hand_landmarks_results.push_back(std::move(hand_landmarks_list));
		}

		std::vector<std::vector<std::shared_ptr<landmark::Landmark>>> hand_world_landmarks_results;
		for (const auto& proto : hand_world_landmarks_proto_list) {
			std::vector<std::shared_ptr<landmark::Landmark>> hand_world_landmarks_list;

			// LandmarkList hand_world_landmarks;
			// hand_world_landmarks.MergeFrom(*proto); // Is it necessary? Shouldn't reinterpret_cast(&proto) be enough?
			const auto& hand_world_landmarks = *static_cast<LandmarkList const*>(proto.get());
			for (const auto& hand_world_landmark : hand_world_landmarks.landmark()) {
				hand_world_landmarks_list.push_back(landmark::Landmark::create_from_pb2(hand_world_landmark));
			}

			hand_world_landmarks_results.push_back(std::move(hand_world_landmarks_list));
		}

		return std::make_shared<GestureRecognizerResult>(
			std::move(gesture_results),
			std::move(handedness_results),
			std::move(hand_landmarks_results),
			std::move(hand_world_landmarks_results)
			);
	}
}

namespace mediapipe {
	namespace tasks {
		namespace autoit {
			namespace vision {
				namespace gesture_recognizer {
					using mediapipe::tasks::vision::gesture_recognizer::proto::GestureRecognizerGraphOptions;
					using core::image_processing_options::ImageProcessingOptions;

					std::shared_ptr<GestureRecognizerGraphOptions> GestureRecognizerOptions::to_pb2() {
						auto gesture_recognizer_options_proto = std::make_shared<GestureRecognizerGraphOptions>();

						// Initialize gesture recognizer options from base options.
						gesture_recognizer_options_proto->mutable_base_options()->CopyFrom(*base_options->to_pb2());
						gesture_recognizer_options_proto->mutable_base_options()->set_use_stream_mode(running_mode != VisionTaskRunningMode::IMAGE);

						// Configure hand detector and hand landmarker options.
						auto hand_landmarker_options_proto = gesture_recognizer_options_proto->mutable_hand_landmarker_graph_options();
						hand_landmarker_options_proto->set_min_tracking_confidence(min_tracking_confidence);
						hand_landmarker_options_proto->mutable_hand_detector_graph_options()->set_num_hands(num_hands);
						hand_landmarker_options_proto->mutable_hand_detector_graph_options()->set_min_detection_confidence(min_hand_detection_confidence);
						hand_landmarker_options_proto->mutable_hand_landmarks_detector_graph_options()->set_min_detection_confidence(min_hand_presence_confidence);

						// Configure hand gesture recognizer options.
						auto hand_gesture_recognizer_options_proto = gesture_recognizer_options_proto->mutable_hand_gesture_recognizer_graph_options();
						hand_gesture_recognizer_options_proto->mutable_canned_gesture_classifier_graph_options()->mutable_classifier_options()->CopyFrom(
							*canned_gesture_classifier_options->to_pb2());
						hand_gesture_recognizer_options_proto->mutable_custom_gesture_classifier_graph_options()->mutable_classifier_options()->CopyFrom(
							*custom_gesture_classifier_options->to_pb2());

						return gesture_recognizer_options_proto;
					}

					std::shared_ptr<GestureRecognizer> GestureRecognizer::create_from_model_path(const std::string& model_path) {
						auto base_options = std::make_shared<BaseOptions>(model_path);
						return create_from_options(std::make_shared<GestureRecognizerOptions>(base_options, VisionTaskRunningMode::IMAGE));
					}

					std::shared_ptr<GestureRecognizer> GestureRecognizer::create_from_options(std::shared_ptr<GestureRecognizerOptions> options) {
						PacketsCallback packets_callback = nullptr;

						if (options->result_callback) {
							packets_callback = [options](const PacketMap& output_packets) {
								if (output_packets.at(_IMAGE_OUT_STREAM_NAME).IsEmpty()) {
									return;
								}

								auto timestamp_ms = output_packets.at(_HAND_GESTURE_STREAM_NAME).Timestamp().Value() / _MICRO_SECONDS_PER_MILLISECOND;
								auto image = mediapipe::autoit::packet_getter::GetContent<Image>(output_packets.at(_IMAGE_OUT_STREAM_NAME));
								auto gesture_recognizer_result = _build_recognition_result(output_packets);
								options->result_callback(*gesture_recognizer_result, image, timestamp_ms);
							};
						}

						TaskInfo task_info;
						task_info.task_graph = _TASK_GRAPH_NAME;
						task_info.input_streams = {
							_IMAGE_TAG + ":" + _IMAGE_IN_STREAM_NAME,
							_NORM_RECT_TAG + ":" + _NORM_RECT_STREAM_NAME
						};
						task_info.output_streams = {
							_HAND_GESTURE_TAG + ":" + _HAND_GESTURE_STREAM_NAME,
							_HANDEDNESS_TAG + ":" + _HANDEDNESS_STREAM_NAME,
							_HAND_LANDMARKS_TAG + ":" + _HAND_LANDMARKS_STREAM_NAME,
							_HAND_WORLD_LANDMARKS_TAG + ":" + _HAND_WORLD_LANDMARKS_STREAM_NAME,
							_IMAGE_TAG + ":" + _IMAGE_OUT_STREAM_NAME
						};
						task_info.task_options = options->to_pb2();

						return std::make_shared<GestureRecognizer>(
							*task_info.generate_graph_config(options->running_mode == VisionTaskRunningMode::LIVE_STREAM),
							options->running_mode,
							std::move(packets_callback)
							);
					}

					std::shared_ptr<GestureRecognizerResult> GestureRecognizer::recognize(
						const Image& image,
						std::shared_ptr<ImageProcessingOptions> image_processing_options
					) {
						auto normalized_rect = convert_to_normalized_rect(image_processing_options, false);
						auto output_packets = _process_image_data({
							{ _IMAGE_IN_STREAM_NAME, std::move(*std::move(mediapipe::autoit::packet_creator::create_image(image))) },
							{ _NORM_RECT_STREAM_NAME, std::move(*std::move(mediapipe::autoit::packet_creator::create_proto(*normalized_rect.to_pb2()))) },
							});
						return _build_recognition_result(output_packets);
					}

					std::shared_ptr<GestureRecognizerResult> GestureRecognizer::recognize_for_video(
						const Image& image,
						int64_t timestamp_ms,
						std::shared_ptr<ImageProcessingOptions> image_processing_options
					) {
						auto normalized_rect = convert_to_normalized_rect(image_processing_options, false);
						auto output_packets = _process_video_data({
							{ _IMAGE_IN_STREAM_NAME, std::move(std::move(mediapipe::autoit::packet_creator::create_image(image))->At(
								Timestamp(timestamp_ms * _MICRO_SECONDS_PER_MILLISECOND)
							)) },
							{ _NORM_RECT_STREAM_NAME, std::move(std::move(mediapipe::autoit::packet_creator::create_proto(*normalized_rect.to_pb2()))->At(
								Timestamp(timestamp_ms * _MICRO_SECONDS_PER_MILLISECOND)
							)) },
							});
						return _build_recognition_result(output_packets);
					}

					void GestureRecognizer::recognize_async(
						const Image& image,
						int64_t timestamp_ms,
						std::shared_ptr<ImageProcessingOptions> image_processing_options
					) {
						auto normalized_rect = convert_to_normalized_rect(image_processing_options, false);
						_send_live_stream_data({
							{ _IMAGE_IN_STREAM_NAME, std::move(std::move(mediapipe::autoit::packet_creator::create_image(image))->At(
								Timestamp(timestamp_ms * _MICRO_SECONDS_PER_MILLISECOND)
							)) },
							{ _NORM_RECT_STREAM_NAME, std::move(std::move(mediapipe::autoit::packet_creator::create_proto(*normalized_rect.to_pb2()))->At(
								Timestamp(timestamp_ms * _MICRO_SECONDS_PER_MILLISECOND)
							)) },
							});
					}
				}
			}
		}
	}
}
