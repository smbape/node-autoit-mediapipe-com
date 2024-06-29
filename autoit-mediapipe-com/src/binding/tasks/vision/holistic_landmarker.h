#pragma once

#include "mediapipe/framework/formats/classification.pb.h"
#include "mediapipe/framework/formats/landmark.pb.h"
#include "mediapipe/tasks/cc/vision/holistic_landmarker/proto/holistic_landmarker_graph_options.pb.h"
#include "mediapipe/tasks/cc/vision/holistic_landmarker/proto/holistic_result.pb.h"
#include "binding/tasks/components/containers/category.h"
#include "binding/tasks/components/containers/landmark.h"
#include "binding/tasks/core/base_options.h"
#include "binding/tasks/core/task_info.h"
#include "binding/tasks/vision/core/base_vision_task_api.h"
#include "binding/tasks/vision/core/image_processing_options.h"
#include "binding/tasks/vision/core/vision_task_running_mode.h"
#include <functional>

namespace mediapipe::tasks::autoit::vision::holistic_landmarker {
	struct CV_EXPORTS_W_SIMPLE HolisticLandmarkerResult {
		CV_WRAP HolisticLandmarkerResult(const HolisticLandmarkerResult& other) = default;
		HolisticLandmarkerResult& operator=(const HolisticLandmarkerResult& other) = default;

		CV_WRAP HolisticLandmarkerResult(
			const std::shared_ptr<std::vector<std::shared_ptr<components::containers::landmark::NormalizedLandmark>>>& face_landmarks = std::make_shared<std::vector<std::shared_ptr<components::containers::landmark::NormalizedLandmark>>>(),
			const std::shared_ptr<std::vector<std::shared_ptr<components::containers::landmark::NormalizedLandmark>>>& pose_landmarks = std::make_shared<std::vector<std::shared_ptr<components::containers::landmark::NormalizedLandmark>>>(),
			const std::shared_ptr<std::vector<std::shared_ptr<components::containers::landmark::Landmark>>>& pose_world_landmarks = std::make_shared<std::vector<std::shared_ptr<components::containers::landmark::Landmark>>>(),
			const std::shared_ptr<std::vector<std::shared_ptr<components::containers::landmark::NormalizedLandmark>>>& left_hand_landmarks = std::make_shared<std::vector<std::shared_ptr<components::containers::landmark::NormalizedLandmark>>>(),
			const std::shared_ptr<std::vector<std::shared_ptr<components::containers::landmark::Landmark>>>& left_hand_world_landmarks = std::make_shared<std::vector<std::shared_ptr<components::containers::landmark::Landmark>>>(),
			const std::shared_ptr<std::vector<std::shared_ptr<components::containers::landmark::NormalizedLandmark>>>& right_hand_landmarks = std::make_shared<std::vector<std::shared_ptr<components::containers::landmark::NormalizedLandmark>>>(),
			const std::shared_ptr<std::vector<std::shared_ptr<components::containers::landmark::Landmark>>>& right_hand_world_landmarks = std::make_shared<std::vector<std::shared_ptr<components::containers::landmark::Landmark>>>(),
			const std::shared_ptr<std::vector<std::shared_ptr<components::containers::category::Category>>>& face_blendshapes = std::make_shared<std::vector<std::shared_ptr<components::containers::category::Category>>>(),
			const std::shared_ptr<Image>& segmentation_mask = std::shared_ptr<Image>()
		) :
			face_landmarks(face_landmarks),
			pose_landmarks(pose_landmarks),
			pose_world_landmarks(pose_world_landmarks),
			left_hand_landmarks(left_hand_landmarks),
			left_hand_world_landmarks(left_hand_world_landmarks),
			right_hand_landmarks(right_hand_landmarks),
			right_hand_world_landmarks(right_hand_world_landmarks),
			face_blendshapes(face_blendshapes),
			segmentation_mask(segmentation_mask)
		{}

		CV_WRAP static std::shared_ptr<HolisticLandmarkerResult> create_from_pb2(const mediapipe::tasks::vision::holistic_landmarker::proto::HolisticResult& pb2_obj);

		bool operator== (const HolisticLandmarkerResult& other) const {
			return ::autoit::__eq__(face_landmarks, other.face_landmarks) &&
				::autoit::__eq__(pose_landmarks, other.pose_landmarks) &&
				::autoit::__eq__(pose_world_landmarks, other.pose_world_landmarks) &&
				::autoit::__eq__(left_hand_landmarks, other.left_hand_landmarks) &&
				::autoit::__eq__(left_hand_world_landmarks, other.left_hand_world_landmarks) &&
				::autoit::__eq__(right_hand_landmarks, other.right_hand_landmarks) &&
				::autoit::__eq__(right_hand_world_landmarks, other.right_hand_world_landmarks) &&
				::autoit::__eq__(face_blendshapes, other.face_blendshapes) &&
				::autoit::__eq__(segmentation_mask, other.segmentation_mask);
		}

		CV_PROP_RW std::shared_ptr<std::vector<std::shared_ptr<components::containers::landmark::NormalizedLandmark>>> face_landmarks;
		CV_PROP_RW std::shared_ptr<std::vector<std::shared_ptr<components::containers::landmark::NormalizedLandmark>>> pose_landmarks;
		CV_PROP_RW std::shared_ptr<std::vector<std::shared_ptr<components::containers::landmark::Landmark>>> pose_world_landmarks;
		CV_PROP_RW std::shared_ptr<std::vector<std::shared_ptr<components::containers::landmark::NormalizedLandmark>>> left_hand_landmarks;
		CV_PROP_RW std::shared_ptr<std::vector<std::shared_ptr<components::containers::landmark::Landmark>>> left_hand_world_landmarks;
		CV_PROP_RW std::shared_ptr<std::vector<std::shared_ptr<components::containers::landmark::NormalizedLandmark>>> right_hand_landmarks;
		CV_PROP_RW std::shared_ptr<std::vector<std::shared_ptr<components::containers::landmark::Landmark>>> right_hand_world_landmarks;
		CV_PROP_RW std::shared_ptr<std::vector<std::shared_ptr<components::containers::category::Category>>> face_blendshapes;
		CV_PROP_RW std::shared_ptr<Image> segmentation_mask;
	};

	using HolisticLandmarkerResultRawCallback = void(*)(const HolisticLandmarkerResult&, const Image&, int64_t);
	using HolisticLandmarkerResultCallback = std::function<void(const HolisticLandmarkerResult&, const Image&, int64_t)>;

	struct CV_EXPORTS_W_SIMPLE HolisticLandmarkerOptions {
		CV_WRAP HolisticLandmarkerOptions(const HolisticLandmarkerOptions& other) = default;
		HolisticLandmarkerOptions& operator=(const HolisticLandmarkerOptions& other) = default;

		CV_WRAP HolisticLandmarkerOptions(
			std::shared_ptr<autoit::core::base_options::BaseOptions> base_options = std::shared_ptr<autoit::core::base_options::BaseOptions>(),
			core::vision_task_running_mode::VisionTaskRunningMode running_mode = tasks::autoit::vision::core::vision_task_running_mode::VisionTaskRunningMode::IMAGE,
			float min_face_detection_confidence = 0.5f,
			float min_face_suppression_threshold = 0.5f,
			float min_face_landmarks_confidence = 0.5f,
			float min_pose_detection_confidence = 0.5f,
			float min_pose_suppression_threshold = 0.5f,
			float min_pose_landmarks_confidence = 0.5f,
			float min_hand_landmarks_confidence = 0.5f,
			bool output_face_blendshapes = false,
			bool output_segmentation_mask = false,
			HolisticLandmarkerResultCallback result_callback = nullptr
		) :
			base_options(base_options),
			running_mode(running_mode),
			min_face_detection_confidence(min_face_detection_confidence),
			min_face_suppression_threshold(min_face_suppression_threshold),
			min_face_landmarks_confidence(min_face_landmarks_confidence),
			min_pose_detection_confidence(min_pose_detection_confidence),
			min_pose_suppression_threshold(min_pose_suppression_threshold),
			min_pose_landmarks_confidence(min_pose_landmarks_confidence),
			min_hand_landmarks_confidence(min_hand_landmarks_confidence),
			output_face_blendshapes(output_face_blendshapes),
			output_segmentation_mask(output_segmentation_mask),
			result_callback(result_callback)
		{}

		CV_WRAP std::shared_ptr<mediapipe::tasks::vision::holistic_landmarker::proto::HolisticLandmarkerGraphOptions> to_pb2();

		CV_PROP_RW std::shared_ptr<autoit::core::base_options::BaseOptions> base_options;
		CV_PROP_RW core::vision_task_running_mode::VisionTaskRunningMode running_mode;
		CV_PROP_RW float min_face_detection_confidence;
		CV_PROP_RW float min_face_suppression_threshold;
		CV_PROP_RW float min_face_landmarks_confidence;
		CV_PROP_RW float min_pose_detection_confidence;
		CV_PROP_RW float min_pose_suppression_threshold;
		CV_PROP_RW float min_pose_landmarks_confidence;
		CV_PROP_RW float min_hand_landmarks_confidence;
		CV_PROP_RW bool output_face_blendshapes;
		CV_PROP_RW bool output_segmentation_mask;
		CV_PROP_W  HolisticLandmarkerResultCallback result_callback;
	};

	class CV_EXPORTS_W HolisticLandmarker : public ::mediapipe::tasks::autoit::vision::core::base_vision_task_api::BaseVisionTaskApi {
	public:
		using core::base_vision_task_api::BaseVisionTaskApi::BaseVisionTaskApi;

		CV_WRAP static std::shared_ptr<HolisticLandmarker> create_from_model_path(const std::string& model_path);
		CV_WRAP static std::shared_ptr<HolisticLandmarker> create_from_options(std::shared_ptr<HolisticLandmarkerOptions> options);
		CV_WRAP std::shared_ptr<HolisticLandmarkerResult> detect(
			const Image& image,
			std::shared_ptr<core::image_processing_options::ImageProcessingOptions> image_processing_options = std::shared_ptr<core::image_processing_options::ImageProcessingOptions>()
		);
		CV_WRAP std::shared_ptr<HolisticLandmarkerResult> detect_for_video(
			const Image& image,
			int64_t timestamp_ms,
			std::shared_ptr<core::image_processing_options::ImageProcessingOptions> image_processing_options = std::shared_ptr<core::image_processing_options::ImageProcessingOptions>()
		);
		CV_WRAP void detect_async(
			const Image& image,
			int64_t timestamp_ms,
			std::shared_ptr<core::image_processing_options::ImageProcessingOptions> image_processing_options = std::shared_ptr<core::image_processing_options::ImageProcessingOptions>()
		);
	};
}

PTR_BRIDGE_DECL(mediapipe::tasks::autoit::vision::holistic_landmarker::HolisticLandmarkerResultRawCallback);
extern const HRESULT autoit_to(VARIANT const* const& in_val, mediapipe::tasks::autoit::vision::holistic_landmarker::HolisticLandmarkerResultCallback& out_val);
