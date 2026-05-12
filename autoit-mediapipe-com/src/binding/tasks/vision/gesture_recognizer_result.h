#pragma once

#include "mediapipe/tasks/cc/vision/gesture_recognizer/gesture_recognizer_result.h"

namespace mediapipe::tasks::autoit::vision::gesture_recognizer {
	struct GestureRecognizerResult {
		std::vector<std::vector<tasks::components::containers::Category>> gestures;
		std::vector<std::vector<tasks::components::containers::Category>> handedness;
		std::vector<std::vector<tasks::components::containers::NormalizedLandmark>> hand_landmarks;
		std::vector<std::vector<tasks::components::containers::Landmark>> hand_world_landmarks;
	};

	inline bool operator==(const GestureRecognizerResult& lhs, const GestureRecognizerResult& rhs) {
		return lhs.gestures == rhs.gestures
			&& lhs.handedness == rhs.handedness
			&& lhs.hand_landmarks == rhs.hand_landmarks
			&& lhs.hand_world_landmarks == rhs.hand_world_landmarks;
	}

	// Utility function to convert from GestureRecognizerResult proto to GestureRecognizerResult
	// struct.
	absl::StatusOr<GestureRecognizerResult> ConvertToGestureRecognizerResult(const absl::StatusOr<tasks::vision::gesture_recognizer::GestureRecognizerResult>& status_or_proto);
}
