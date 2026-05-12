#pragma once

#include "mediapipe/tasks/cc/vision/hand_landmarker/hand_landmarker.h"

namespace mediapipe::tasks::vision::hand_landmarker {
	using HandLandmarkerResultRawCallback = void(*)(HandLandmarkerResult*, int, const char*, const Image&, int64_t);
	using HandLandmarkerResultCallback = std::function<void(absl::StatusOr<HandLandmarkerResult>, const Image&, int64_t)>;

	inline bool operator==(const HandLandmarkerResult& lhs, const HandLandmarkerResult& rhs) {
		return lhs.handedness == rhs.handedness
			&& lhs.hand_landmarks == rhs.hand_landmarks
			&& lhs.hand_world_landmarks == rhs.hand_world_landmarks;
	}

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
		using Connection = mediapipe::tasks::components::containers::Connection;

		CV_WRAP_AS(get HAND_PALM_CONNECTIONS) static const std::vector<Connection>& HAND_PALM_CONNECTIONS();
		CV_WRAP_AS(get HAND_THUMB_CONNECTIONS) static const std::vector<Connection>& HAND_THUMB_CONNECTIONS();
		CV_WRAP_AS(get HAND_INDEX_FINGER_CONNECTIONS) static const std::vector<Connection>& HAND_INDEX_FINGER_CONNECTIONS();
		CV_WRAP_AS(get HAND_MIDDLE_FINGER_CONNECTIONS) static const std::vector<Connection>& HAND_MIDDLE_FINGER_CONNECTIONS();
		CV_WRAP_AS(get HAND_RING_FINGER_CONNECTIONS) static const std::vector<Connection>& HAND_RING_FINGER_CONNECTIONS();
		CV_WRAP_AS(get HAND_PINKY_FINGER_CONNECTIONS) static const std::vector<Connection>& HAND_PINKY_FINGER_CONNECTIONS();
		CV_WRAP_AS(get HAND_CONNECTIONS) static const std::vector<Connection>& HAND_CONNECTIONS();
	};
}

PTR_BRIDGE_DECL(mediapipe::tasks::vision::hand_landmarker::HandLandmarkerResultRawCallback);
extern const HRESULT autoit_to(VARIANT const* in_val, mediapipe::tasks::vision::hand_landmarker::HandLandmarkerResultCallback& out_val);
