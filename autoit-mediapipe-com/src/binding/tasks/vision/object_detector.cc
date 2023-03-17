#include "binding/tasks/vision/object_detector.h"
#include "binding/packet_getter.h"
#include "binding/packet_creator.h"

PTR_BRIDGE_IMPL(mediapipe::tasks::autoit::vision::object_detector::ObjectDetectorResultRawCallback);

template<typename _Ty1, typename _Ty2>
inline const HRESULT autoit_to_callback(VARIANT const* const& in_val, _Ty1& out_val) {
	_Ty2 result_callback;
	HRESULT hr = autoit_to(in_val, result_callback);
	if (SUCCEEDED(hr)) {
		out_val = result_callback;
	}
	return hr;
}

const HRESULT autoit_to(VARIANT const* const& in_val, mediapipe::tasks::autoit::vision::object_detector::ObjectDetectorResultCallback& out_val) {
	return autoit_to_callback<
		mediapipe::tasks::autoit::vision::object_detector::ObjectDetectorResultCallback,
		mediapipe::tasks::autoit::vision::object_detector::ObjectDetectorResultRawCallback
	>(in_val, out_val);
}

namespace {
	using namespace mediapipe::tasks::vision::object_detector::proto;
	using namespace mediapipe::tasks::autoit::vision::core::vision_task_running_mode;
	using namespace mediapipe::tasks::autoit::core::base_options;
	using namespace mediapipe::tasks::autoit::core::task_info;
	using namespace mediapipe::tasks::autoit::components::utils;

	using mediapipe::autoit::PacketsCallback;
	using mediapipe::tasks::core::PacketMap;

	const std::string _DETECTIONS_OUT_STREAM_NAME = "detections_out";
	const std::string _DETECTIONS_TAG = "DETECTIONS";
	const std::string _IMAGE_IN_STREAM_NAME = "image_in";
	const std::string _IMAGE_OUT_STREAM_NAME = "image_out";
	const std::string _IMAGE_TAG = "IMAGE";
	const std::string _TASK_GRAPH_NAME = "mediapipe.tasks.vision.ObjectDetectorGraph";
}

namespace mediapipe {
	namespace tasks {
		namespace autoit {
			namespace vision {
				namespace object_detector {
					using Detection = components::containers::detections::Detection;

					std::shared_ptr<mediapipe::tasks::vision::object_detector::proto::ObjectDetectorOptions> ObjectDetectorOptions::to_pb2() {
						auto pb2_obj = std::make_shared<mediapipe::tasks::vision::object_detector::proto::ObjectDetectorOptions>();

						pb2_obj->mutable_base_options()->CopyFrom(*base_options->to_pb2());
						pb2_obj->mutable_base_options()->set_use_stream_mode(running_mode != VisionTaskRunningMode::IMAGE);

						if (score_threshold) pb2_obj->set_score_threshold(*score_threshold);
						std::copy(category_allowlist.begin(), category_allowlist.end(), pb2_obj->mutable_category_allowlist()->begin());
						std::copy(category_denylist.begin(), category_denylist.end(), pb2_obj->mutable_category_denylist()->begin());
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
								if (output_packets.at(_IMAGE_OUT_STREAM_NAME).IsEmpty()) {
									return;
								}

								auto detection_proto_list = mediapipe::autoit::packet_getter::get_proto_list(output_packets.at(_DETECTIONS_OUT_STREAM_NAME));
								auto detection_result = ObjectDetectorResult();
								for (const auto& result : detection_proto_list) {
									detection_result.detections.push_back(Detection::create_from_pb2(*static_cast<mediapipe::Detection const*>(result.get())));
								}

								auto image = mediapipe::autoit::packet_getter::GetContent<Image>(output_packets.at(_IMAGE_OUT_STREAM_NAME));
								auto timestamp = output_packets.at(_IMAGE_OUT_STREAM_NAME).Timestamp().Value();

								options->result_callback(detection_result, image, timestamp);
							};
						}

						TaskInfo task_info;
						task_info.task_graph = _TASK_GRAPH_NAME;
						task_info.input_streams = {
							_IMAGE_TAG + ":" + _IMAGE_IN_STREAM_NAME
						};
						task_info.output_streams = {
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

					std::shared_ptr<ObjectDetectorResult> ObjectDetector::detect(const Image& image) {
						auto output_packets = _process_image_data({
							{ _IMAGE_IN_STREAM_NAME, std::move(*std::move(mediapipe::autoit::packet_creator::create_image(image))) }
							});

						auto detection_proto_list = mediapipe::autoit::packet_getter::get_proto_list(output_packets.at(_DETECTIONS_OUT_STREAM_NAME));
						auto detection_result = std::make_shared<ObjectDetectorResult>();
						for (const auto& result : detection_proto_list) {
							detection_result->detections.push_back(Detection::create_from_pb2(*static_cast<mediapipe::Detection const*>(result.get())));
						}

						return detection_result;
					}

					std::shared_ptr<ObjectDetectorResult> ObjectDetector::detect_for_video(const Image& image, int64_t timestamp_ms) {
						auto output_packets = _process_video_data({
							{ _IMAGE_IN_STREAM_NAME, std::move(std::move(mediapipe::autoit::packet_creator::create_image(image))->At(
								Timestamp(timestamp_ms)
							)) },
							});

						auto detection_proto_list = mediapipe::autoit::packet_getter::get_proto_list(output_packets.at(_DETECTIONS_OUT_STREAM_NAME));
						auto detection_result = std::make_shared<ObjectDetectorResult>();
						for (const auto& result : detection_proto_list) {
							detection_result->detections.push_back(Detection::create_from_pb2(*static_cast<mediapipe::Detection const*>(result.get())));
						}

						return detection_result;
					}

					void ObjectDetector::detect_async(const Image& image, int64_t timestamp_ms) {
						_send_live_stream_data({
							{ _IMAGE_IN_STREAM_NAME, std::move(std::move(mediapipe::autoit::packet_creator::create_image(image))->At(
								Timestamp(timestamp_ms)
							)) },
							});
					}
				}
			}
		}
	}
}
