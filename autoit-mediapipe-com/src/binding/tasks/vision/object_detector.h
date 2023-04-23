#pragma once

#include "mediapipe/tasks/cc/vision/object_detector/proto/object_detector_options.pb.h"
#include "binding/tasks/components/containers/detections.h"
#include "binding/tasks/core/base_options.h"
#include "binding/tasks/core/task_info.h"
#include "binding/tasks/vision/core/base_vision_task_api.h"
#include "binding/tasks/vision/core/vision_task_running_mode.h"
#include "binding/packet_getter.h"
#include "binding/packet_creator.h"
#include <functional>

namespace mediapipe::tasks::autoit::vision::object_detector {
	using ObjectDetectorResult = components::containers::detections::DetectionResult;
	using ObjectDetectorResultRawCallback = void(*)(const ObjectDetectorResult&, const Image&, int64_t);
	using ObjectDetectorResultCallback = std::function<void(const ObjectDetectorResult&, const Image&, int64_t)>;

	struct CV_EXPORTS_W_SIMPLE ObjectDetectorOptions {
		CV_WRAP ObjectDetectorOptions(const ObjectDetectorOptions& other) = default;
		ObjectDetectorOptions& operator=(const ObjectDetectorOptions& other) = default;

		CV_WRAP ObjectDetectorOptions(
			std::shared_ptr<autoit::core::base_options::BaseOptions> base_options = std::shared_ptr<autoit::core::base_options::BaseOptions>(),
			core::vision_task_running_mode::VisionTaskRunningMode running_mode = tasks::autoit::vision::core::vision_task_running_mode::VisionTaskRunningMode::IMAGE,
			const std::optional<std::string>& display_names_locale = std::optional<std::string>(),
			const std::optional<int>& max_results = std::optional<int>(),
			const std::optional<float>& score_threshold = std::optional<float>(),
			const std::vector<std::string>& category_allowlist = std::vector<std::string>(),
			const std::vector<std::string>& category_denylist = std::vector<std::string>(),
			ObjectDetectorResultCallback result_callback = nullptr
		)
			:
			base_options(base_options),
			running_mode(running_mode),
			display_names_locale(display_names_locale),
			max_results(max_results),
			score_threshold(score_threshold),
			category_allowlist(category_allowlist),
			category_denylist(category_denylist),
			result_callback(result_callback)
		{}

		CV_WRAP std::shared_ptr<mediapipe::tasks::vision::object_detector::proto::ObjectDetectorOptions> to_pb2();

		CV_PROP_RW std::shared_ptr<autoit::core::base_options::BaseOptions> base_options;
		CV_PROP_RW core::vision_task_running_mode::VisionTaskRunningMode running_mode;
		CV_PROP_RW std::optional<std::string> display_names_locale;
		CV_PROP_RW std::optional<int> max_results;
		CV_PROP_RW std::optional<float> score_threshold;
		CV_PROP_RW std::vector<std::string> category_allowlist;
		CV_PROP_RW std::vector<std::string> category_denylist;
		CV_PROP_W  ObjectDetectorResultCallback result_callback;
	};

	class CV_EXPORTS_W ObjectDetector : public ::mediapipe::tasks::autoit::vision::core::base_vision_task_api::BaseVisionTaskApi {
	public:
		using core::base_vision_task_api::BaseVisionTaskApi::BaseVisionTaskApi;

		CV_WRAP static std::shared_ptr<ObjectDetector> create_from_model_path(const std::string& model_path);
		CV_WRAP static std::shared_ptr<ObjectDetector> create_from_options(std::shared_ptr<ObjectDetectorOptions> options);
		CV_WRAP std::shared_ptr<ObjectDetectorResult> detect(const Image& image);
		CV_WRAP std::shared_ptr<ObjectDetectorResult> detect_for_video(const Image& image, int64_t timestamp_ms);
		CV_WRAP void detect_async(const Image& image, int64_t timestamp_ms);
	};
}

// PTR_BRIDGE_DECL(mediapipe::tasks::autoit::vision::object_detector::ObjectDetectorResultRawCallback);
// extern const HRESULT autoit_to(VARIANT const* const& in_val, mediapipe::tasks::autoit::vision::object_detector::ObjectDetectorResultCallback& out_val);
