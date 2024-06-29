#pragma once

#include "mediapipe/framework/formats/classification.pb.h"
#include "mediapipe/framework/formats/landmark.pb.h"
#include "mediapipe/tasks/cc/vision/hand_landmarker/proto/hand_landmarker_graph_options.pb.h"
#include "binding/tasks/components/containers/category.h"
#include "binding/tasks/components/containers/landmark.h"
#include "binding/tasks/core/base_options.h"
#include "binding/tasks/core/task_info.h"
#include "binding/tasks/vision/core/base_vision_task_api.h"
#include "binding/tasks/vision/core/image_processing_options.h"
#include "binding/tasks/vision/core/vision_task_running_mode.h"
#include <functional>

namespace mediapipe::tasks::autoit::vision::hand_landmarker {
	enum class HandLandmark {
		// The 21 hand landmarks.
		WRIST = 0,
		THUMB_CMC = 1,
		THUMB_MCP = 2,
		THUMB_IP = 3,
		THUMB_TIP = 4,
		INDEX_FINGER_MCP = 5,
		INDEX_FINGER_PIP = 6,
		INDEX_FINGER_DIP = 7,
		INDEX_FINGER_TIP = 8,
		MIDDLE_FINGER_MCP = 9,
		MIDDLE_FINGER_PIP = 10,
		MIDDLE_FINGER_DIP = 11,
		MIDDLE_FINGER_TIP = 12,
		RING_FINGER_MCP = 13,
		RING_FINGER_PIP = 14,
		RING_FINGER_DIP = 15,
		RING_FINGER_TIP = 16,
		PINKY_MCP = 17,
		PINKY_PIP = 18,
		PINKY_DIP = 19,
		PINKY_TIP = 20,
	};

	struct CV_EXPORTS_W_SIMPLE HandLandmarksConnections {
		struct CV_EXPORTS_W_SIMPLE Connection {
			CV_WRAP Connection(const Connection& other) = default;
			Connection& operator=(const Connection& other) = default;

			CV_WRAP Connection(int start = 0, int end = 0) : start(start), end(end) {}

			CV_PROP_RW int start;
			CV_PROP_RW int end;
		};

		CV_PROP static const std::vector<Connection> HAND_PALM_CONNECTIONS;
		CV_PROP static const std::vector<Connection> HAND_THUMB_CONNECTIONS;
		CV_PROP static const std::vector<Connection> HAND_INDEX_FINGER_CONNECTIONS;
		CV_PROP static const std::vector<Connection> HAND_MIDDLE_FINGER_CONNECTIONS;
		CV_PROP static const std::vector<Connection> HAND_RING_FINGER_CONNECTIONS;
		CV_PROP static const std::vector<Connection> HAND_PINKY_FINGER_CONNECTIONS;
		CV_PROP static const std::vector<Connection> HAND_CONNECTIONS;
	};

	struct CV_EXPORTS_W_SIMPLE HandLandmarkerResult {
		CV_WRAP HandLandmarkerResult(const HandLandmarkerResult& other) = default;
		HandLandmarkerResult& operator=(const HandLandmarkerResult& other) = default;

		CV_WRAP HandLandmarkerResult(
			const std::shared_ptr<std::vector<std::shared_ptr<std::vector<std::shared_ptr<components::containers::category::Category>>>>>& handedness = std::make_shared<std::vector<std::shared_ptr<std::vector<std::shared_ptr<components::containers::category::Category>>>>>(),
			const std::shared_ptr<std::vector<std::shared_ptr<std::vector<std::shared_ptr<components::containers::landmark::NormalizedLandmark>>>>>& hand_landmarks = std::make_shared<std::vector<std::shared_ptr<std::vector<std::shared_ptr<components::containers::landmark::NormalizedLandmark>>>>>(),
			const std::shared_ptr<std::vector<std::shared_ptr<std::vector<std::shared_ptr<components::containers::landmark::Landmark>>>>>& hand_world_landmarks = std::make_shared<std::vector<std::shared_ptr<std::vector<std::shared_ptr<components::containers::landmark::Landmark>>>>>()
		) :
			handedness(handedness),
			hand_landmarks(hand_landmarks),
			hand_world_landmarks(hand_world_landmarks)
		{}

		bool operator== (const HandLandmarkerResult& other) const {
			return ::autoit::__eq__(handedness, other.handedness) &&
				::autoit::__eq__(hand_landmarks, other.hand_landmarks) &&
				::autoit::__eq__(hand_world_landmarks, other.hand_world_landmarks);
		}

		CV_PROP_RW std::shared_ptr<std::vector<std::shared_ptr<std::vector<std::shared_ptr<components::containers::category::Category>>>>> handedness;
		CV_PROP_RW std::shared_ptr<std::vector<std::shared_ptr<std::vector<std::shared_ptr<components::containers::landmark::NormalizedLandmark>>>>> hand_landmarks;
		CV_PROP_RW std::shared_ptr<std::vector<std::shared_ptr<std::vector<std::shared_ptr<components::containers::landmark::Landmark>>>>> hand_world_landmarks;
	};

	using HandLandmarkerResultRawCallback = void(*)(const HandLandmarkerResult&, const Image&, int64_t);
	using HandLandmarkerResultCallback = std::function<void(const HandLandmarkerResult&, const Image&, int64_t)>;

	struct CV_EXPORTS_W_SIMPLE HandLandmarkerOptions {
		CV_WRAP HandLandmarkerOptions(const HandLandmarkerOptions& other) = default;
		HandLandmarkerOptions& operator=(const HandLandmarkerOptions& other) = default;

		CV_WRAP HandLandmarkerOptions(
			std::shared_ptr<autoit::core::base_options::BaseOptions> base_options = std::shared_ptr<autoit::core::base_options::BaseOptions>(),
			core::vision_task_running_mode::VisionTaskRunningMode running_mode = tasks::autoit::vision::core::vision_task_running_mode::VisionTaskRunningMode::IMAGE,
			int num_hands = 1,
			float min_hand_detection_confidence = 0.5f,
			float min_hand_presence_confidence = 0.5f,
			float min_tracking_confidence = 0.5f,
			HandLandmarkerResultCallback result_callback = nullptr
		) :
			base_options(base_options),
			running_mode(running_mode),
			num_hands(num_hands),
			min_hand_detection_confidence(min_hand_detection_confidence),
			min_hand_presence_confidence(min_hand_presence_confidence),
			min_tracking_confidence(min_tracking_confidence),
			result_callback(result_callback)
		{}

		CV_WRAP std::shared_ptr<mediapipe::tasks::vision::hand_landmarker::proto::HandLandmarkerGraphOptions> to_pb2();

		CV_PROP_RW std::shared_ptr<autoit::core::base_options::BaseOptions> base_options;
		CV_PROP_RW core::vision_task_running_mode::VisionTaskRunningMode running_mode;
		CV_PROP_RW int num_hands;
		CV_PROP_RW float min_hand_detection_confidence;
		CV_PROP_RW float min_hand_presence_confidence;
		CV_PROP_RW float min_tracking_confidence;
		CV_PROP_W  HandLandmarkerResultCallback result_callback;
	};

	class CV_EXPORTS_W HandLandmarker : public ::mediapipe::tasks::autoit::vision::core::base_vision_task_api::BaseVisionTaskApi {
	public:
		using core::base_vision_task_api::BaseVisionTaskApi::BaseVisionTaskApi;

		CV_WRAP static std::shared_ptr<HandLandmarker> create_from_model_path(const std::string& model_path);
		CV_WRAP static std::shared_ptr<HandLandmarker> create_from_options(std::shared_ptr<HandLandmarkerOptions> options);
		CV_WRAP std::shared_ptr<HandLandmarkerResult> detect(
			const Image& image,
			std::shared_ptr<core::image_processing_options::ImageProcessingOptions> image_processing_options = std::shared_ptr<core::image_processing_options::ImageProcessingOptions>()
		);
		CV_WRAP std::shared_ptr<HandLandmarkerResult> detect_for_video(
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

PTR_BRIDGE_DECL(mediapipe::tasks::autoit::vision::hand_landmarker::HandLandmarkerResultRawCallback);
extern const HRESULT autoit_to(VARIANT const* const& in_val, mediapipe::tasks::autoit::vision::hand_landmarker::HandLandmarkerResultCallback& out_val);
