#pragma once

#include "mediapipe/tasks/cc/vision/pose_landmarker/pose_landmarker.h"

namespace mediapipe::tasks::vision::pose_landmarker {
	using PoseLandmarkerResultRawCallback = void(*)(PoseLandmarkerResult*, int, const char*, const Image&, int64_t);
	using PoseLandmarkerResultCallback = std::function<void(absl::StatusOr<PoseLandmarkerResult>, const Image&, int64_t)>;

	inline bool operator==(const PoseLandmarkerResult& lhs, const PoseLandmarkerResult& rhs) {
		return lhs.segmentation_masks == rhs.segmentation_masks
			&& lhs.pose_landmarks == rhs.pose_landmarks
			&& lhs.pose_world_landmarks == rhs.pose_world_landmarks;
	}

	enum class PoseLandmark {
		// The 33 pose landmarks.

		NOSE = 0,
		LEFT_EYE_INNER = 1,
		LEFT_EYE = 2,
		LEFT_EYE_OUTER = 3,
		RIGHT_EYE_INNER = 4,
		RIGHT_EYE = 5,
		RIGHT_EYE_OUTER = 6,
		LEFT_EAR = 7,
		RIGHT_EAR = 8,
		MOUTH_LEFT = 9,
		MOUTH_RIGHT = 10,
		LEFT_SHOULDER = 11,
		RIGHT_SHOULDER = 12,
		LEFT_ELBOW = 13,
		RIGHT_ELBOW = 14,
		LEFT_WRIST = 15,
		RIGHT_WRIST = 16,
		LEFT_PINKY = 17,
		RIGHT_PINKY = 18,
		LEFT_INDEX = 19,
		RIGHT_INDEX = 20,
		LEFT_THUMB = 21,
		RIGHT_THUMB = 22,
		LEFT_HIP = 23,
		RIGHT_HIP = 24,
		LEFT_KNEE = 25,
		RIGHT_KNEE = 26,
		LEFT_ANKLE = 27,
		RIGHT_ANKLE = 28,
		LEFT_HEEL = 29,
		RIGHT_HEEL = 30,
		LEFT_FOOT_INDEX = 31,
		RIGHT_FOOT_INDEX = 32,
	};

	struct CV_EXPORTS_W_SIMPLE PoseLandmarksConnections {
		using Connection = mediapipe::tasks::components::containers::Connection;

		CV_WRAP_AS(get POSE_LANDMARKS) static const std::vector<Connection>& POSE_LANDMARKS();
	};
}

PTR_BRIDGE_DECL(mediapipe::tasks::vision::pose_landmarker::PoseLandmarkerResultRawCallback);
extern const HRESULT autoit_to(VARIANT const* in_val, mediapipe::tasks::vision::pose_landmarker::PoseLandmarkerResultCallback& out_val);
