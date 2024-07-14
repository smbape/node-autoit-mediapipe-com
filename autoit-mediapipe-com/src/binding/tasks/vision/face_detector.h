#pragma once

#include "mediapipe/tasks/cc/vision/face_detector/proto/face_detector_graph_options.pb.h"
#include "binding/tasks/components/containers/detections.h"
#include "binding/tasks/core/base_options.h"
#include "binding/tasks/core/task_info.h"
#include "binding/tasks/vision/core/base_vision_task_api.h"
#include "binding/tasks/vision/core/image_processing_options.h"
#include "binding/tasks/vision/core/vision_task_running_mode.h"
#include "binding/packet_getter.h"
#include "binding/packet_creator.h"
#include <functional>

namespace mediapipe::tasks::autoit::vision::face_detector {
	using FaceDetectorResult = components::containers::detections::DetectionResult;
	using FaceDetectorResultRawCallback = void(*)(const FaceDetectorResult&, const Image&, int64_t);
	using FaceDetectorResultCallback = std::function<void(const FaceDetectorResult&, const Image&, int64_t)>;

	struct CV_EXPORTS_W_SIMPLE FaceDetectorOptions {
		CV_WRAP FaceDetectorOptions(const FaceDetectorOptions& other) = default;
		FaceDetectorOptions& operator=(const FaceDetectorOptions& other) = default;

		CV_WRAP FaceDetectorOptions(
			std::shared_ptr<autoit::core::base_options::BaseOptions> base_options = std::shared_ptr<autoit::core::base_options::BaseOptions>(),
			core::vision_task_running_mode::VisionTaskRunningMode running_mode = tasks::autoit::vision::core::vision_task_running_mode::VisionTaskRunningMode::IMAGE,
			const std::optional<float>& min_detection_confidence = std::optional<float>(),
			const std::optional<float>& min_suppression_threshold = std::optional<float>(),
			FaceDetectorResultCallback result_callback = nullptr
		)
			:
			base_options(base_options),
			running_mode(running_mode),
			min_detection_confidence(min_detection_confidence),
			min_suppression_threshold(min_suppression_threshold),
			result_callback(result_callback)
		{}

		CV_WRAP [[nodiscard]] absl::StatusOr<std::shared_ptr<mediapipe::tasks::vision::face_detector::proto::FaceDetectorGraphOptions>> to_pb2() const;

		CV_PROP_RW std::shared_ptr<autoit::core::base_options::BaseOptions> base_options;
		CV_PROP_RW core::vision_task_running_mode::VisionTaskRunningMode running_mode;
		CV_PROP_RW std::optional<float> min_detection_confidence;
		CV_PROP_RW std::optional<float> min_suppression_threshold;
		CV_PROP_W  FaceDetectorResultCallback result_callback;
	};

	class CV_EXPORTS_W FaceDetector : public ::mediapipe::tasks::autoit::vision::core::base_vision_task_api::BaseVisionTaskApi {
	public:
		using core::base_vision_task_api::BaseVisionTaskApi::BaseVisionTaskApi;

		CV_WRAP [[nodiscard]] static absl::StatusOr<std::shared_ptr<FaceDetector>> create(
			const CalculatorGraphConfig& graph_config,
			core::vision_task_running_mode::VisionTaskRunningMode running_mode,
			mediapipe::autoit::PacketsCallback packet_callback = nullptr
		);
		CV_WRAP [[nodiscard]] static absl::StatusOr<std::shared_ptr<FaceDetector>> create_from_model_path(const std::string& model_path);
		CV_WRAP [[nodiscard]] static absl::StatusOr<std::shared_ptr<FaceDetector>> create_from_options(std::shared_ptr<FaceDetectorOptions> options);
		CV_WRAP [[nodiscard]] absl::StatusOr<std::shared_ptr<FaceDetectorResult>> detect(
			const Image& image,
			std::shared_ptr<core::image_processing_options::ImageProcessingOptions> image_processing_options =
			std::shared_ptr<core::image_processing_options::ImageProcessingOptions>()
		);
		CV_WRAP [[nodiscard]] absl::StatusOr<std::shared_ptr<FaceDetectorResult>> detect_for_video(
			const Image& image,
			int64_t timestamp_ms,
			std::shared_ptr<core::image_processing_options::ImageProcessingOptions> image_processing_options =
			std::shared_ptr<core::image_processing_options::ImageProcessingOptions>()
		);
		CV_WRAP [[nodiscard]] absl::Status detect_async(
			const Image& image,
			int64_t timestamp_ms,
			std::shared_ptr<core::image_processing_options::ImageProcessingOptions> image_processing_options =
			std::shared_ptr<core::image_processing_options::ImageProcessingOptions>()
		);
	};
}

PTR_BRIDGE_DECL(mediapipe::tasks::autoit::vision::face_detector::FaceDetectorResultRawCallback);
extern const HRESULT autoit_to(VARIANT const* const& in_val, mediapipe::tasks::autoit::vision::face_detector::FaceDetectorResultCallback& out_val);
