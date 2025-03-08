#pragma once

#include "mediapipe/framework/formats/classification.pb.h"
#include "mediapipe/framework/formats/landmark.pb.h"
#include "mediapipe/tasks/cc/vision/pose_landmarker/proto/pose_landmarker_graph_options.pb.h"
#include "binding/tasks/components/containers/category.h"
#include "binding/tasks/components/containers/landmark.h"
#include "binding/tasks/core/base_options.h"
#include "binding/tasks/core/task_info.h"
#include "binding/tasks/vision/core/base_vision_task_api.h"
#include "binding/tasks/vision/core/image_processing_options.h"
#include "binding/tasks/vision/core/vision_task_running_mode.h"
#include <functional>

namespace mediapipe::tasks::autoit::vision::pose_landmarker {
	struct CV_EXPORTS_W_SIMPLE PoseLandmarkerResult {
		CV_WRAP PoseLandmarkerResult(const PoseLandmarkerResult& other) = default;
		PoseLandmarkerResult& operator=(const PoseLandmarkerResult& other) = default;

		CV_WRAP PoseLandmarkerResult(
			const std::shared_ptr<std::vector<std::shared_ptr<std::vector<std::shared_ptr<components::containers::landmark::NormalizedLandmark>>>>>& pose_landmarks = std::make_shared<std::vector<std::shared_ptr<std::vector<std::shared_ptr<components::containers::landmark::NormalizedLandmark>>>>>(),
			const std::shared_ptr<std::vector<std::shared_ptr<std::vector<std::shared_ptr<components::containers::landmark::Landmark>>>>>& pose_world_landmarks = std::make_shared<std::vector<std::shared_ptr<std::vector<std::shared_ptr<components::containers::landmark::Landmark>>>>>(),
			const std::shared_ptr<std::vector<std::shared_ptr<Image>>>& segmentation_masks = std::make_shared<std::vector<std::shared_ptr<Image>>>()
		) :
			pose_landmarks(pose_landmarks),
			pose_world_landmarks(pose_world_landmarks),
			segmentation_masks(segmentation_masks)
		{}

		bool operator== (const PoseLandmarkerResult& other) const {
			return ::autoit::__eq__(pose_landmarks, other.pose_landmarks) &&
				::autoit::__eq__(pose_world_landmarks, other.pose_world_landmarks) &&
				::autoit::__eq__(segmentation_masks, other.segmentation_masks);
		}

		CV_PROP_RW std::shared_ptr<std::vector<std::shared_ptr<std::vector<std::shared_ptr<components::containers::landmark::NormalizedLandmark>>>>> pose_landmarks;
		CV_PROP_RW std::shared_ptr<std::vector<std::shared_ptr<std::vector<std::shared_ptr<components::containers::landmark::Landmark>>>>> pose_world_landmarks;
		CV_PROP_RW std::shared_ptr<std::vector<std::shared_ptr<Image>>> segmentation_masks;
	};

	struct CV_EXPORTS_W_SIMPLE PoseLandmarksConnections {
		struct CV_EXPORTS_W_SIMPLE Connection {
			CV_WRAP Connection(const Connection& other) = default;
			Connection& operator=(const Connection& other) = default;

			CV_WRAP Connection(int start = 0, int end = 0) : start(start), end(end) {}

			CV_PROP_RW int start;
			CV_PROP_RW int end;
		};

		CV_PROP static const std::vector<Connection> POSE_LANDMARKS;
	};

	using PoseLandmarkerResultRawCallback = void(*)(const PoseLandmarkerResult&, const Image&, int64_t);
	using PoseLandmarkerResultCallback = std::function<void(const PoseLandmarkerResult&, const Image&, int64_t)>;

	struct CV_EXPORTS_W_SIMPLE PoseLandmarkerOptions {
		CV_WRAP PoseLandmarkerOptions(const PoseLandmarkerOptions& other) = default;
		PoseLandmarkerOptions& operator=(const PoseLandmarkerOptions& other) = default;

		CV_WRAP PoseLandmarkerOptions(
			std::shared_ptr<autoit::core::base_options::BaseOptions> base_options = std::shared_ptr<autoit::core::base_options::BaseOptions>(),
			core::vision_task_running_mode::VisionTaskRunningMode running_mode = tasks::autoit::vision::core::vision_task_running_mode::VisionTaskRunningMode::IMAGE,
			int num_poses = 1,
			float min_pose_detection_confidence = 0.5f,
			float min_pose_presence_confidence = 0.5f,
			float min_tracking_confidence = 0.5f,
			bool output_segmentation_masks = false,
			PoseLandmarkerResultCallback result_callback = nullptr
		) :
			base_options(base_options),
			running_mode(running_mode),
			num_poses(num_poses),
			min_pose_detection_confidence(min_pose_detection_confidence),
			min_pose_presence_confidence(min_pose_presence_confidence),
			min_tracking_confidence(min_tracking_confidence),
			output_segmentation_masks(output_segmentation_masks),
			result_callback(result_callback)
		{}

		CV_WRAP [[nodiscard]] absl::StatusOr<std::shared_ptr<mediapipe::tasks::vision::pose_landmarker::proto::PoseLandmarkerGraphOptions>> to_pb2() const;

		CV_PROP_RW std::shared_ptr<autoit::core::base_options::BaseOptions> base_options;
		CV_PROP_RW core::vision_task_running_mode::VisionTaskRunningMode running_mode;
		CV_PROP_RW int num_poses;
		CV_PROP_RW float min_pose_detection_confidence;
		CV_PROP_RW float min_pose_presence_confidence;
		CV_PROP_RW float min_tracking_confidence;
		CV_PROP_RW bool output_segmentation_masks;
		CV_PROP_W  PoseLandmarkerResultCallback result_callback;
	};

	class CV_EXPORTS_W PoseLandmarker : public ::mediapipe::tasks::autoit::vision::core::base_vision_task_api::BaseVisionTaskApi {
	public:
		using core::base_vision_task_api::BaseVisionTaskApi::BaseVisionTaskApi;

		CV_WRAP [[nodiscard]] static absl::StatusOr<std::shared_ptr<PoseLandmarker>> create(
			const CalculatorGraphConfig& graph_config,
			core::vision_task_running_mode::VisionTaskRunningMode running_mode,
			mediapipe::autoit::PacketsCallback packet_callback = nullptr
		);
		CV_WRAP [[nodiscard]] static absl::StatusOr<std::shared_ptr<PoseLandmarker>> create_from_model_path(const std::string& model_path);
		CV_WRAP [[nodiscard]] static absl::StatusOr<std::shared_ptr<PoseLandmarker>> create_from_options(std::shared_ptr<PoseLandmarkerOptions> options);
		CV_WRAP [[nodiscard]] absl::StatusOr<std::shared_ptr<PoseLandmarkerResult>> detect(
			const Image& image,
			std::shared_ptr<core::image_processing_options::ImageProcessingOptions> image_processing_options = std::shared_ptr<core::image_processing_options::ImageProcessingOptions>()
		);
		CV_WRAP [[nodiscard]] absl::StatusOr<std::shared_ptr<PoseLandmarkerResult>> detect_for_video(
			const Image& image,
			int64_t timestamp_ms,
			std::shared_ptr<core::image_processing_options::ImageProcessingOptions> image_processing_options = std::shared_ptr<core::image_processing_options::ImageProcessingOptions>()
		);
		CV_WRAP [[nodiscard]] absl::Status detect_async(
			const Image& image,
			int64_t timestamp_ms,
			std::shared_ptr<core::image_processing_options::ImageProcessingOptions> image_processing_options = std::shared_ptr<core::image_processing_options::ImageProcessingOptions>()
		);
	};
}

PTR_BRIDGE_DECL(mediapipe::tasks::autoit::vision::pose_landmarker::PoseLandmarkerResultRawCallback);
extern const HRESULT autoit_to(VARIANT const* const& in_val, mediapipe::tasks::autoit::vision::pose_landmarker::PoseLandmarkerResultCallback& out_val);
