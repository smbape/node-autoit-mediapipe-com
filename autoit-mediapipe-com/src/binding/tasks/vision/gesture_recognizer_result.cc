#include "mediapipe/tasks/cc/components/containers/classification_result.h"
#include "mediapipe/tasks/cc/components/containers/landmark.h"
#include "binding/tasks/vision/gesture_recognizer_result.h"

namespace mediapipe::tasks::autoit::vision::gesture_recognizer {
	absl::StatusOr<GestureRecognizerResult> ConvertToGestureRecognizerResult(const absl::StatusOr<tasks::vision::gesture_recognizer::GestureRecognizerResult>& status_or_proto) {
		if (!status_or_proto.ok()) {
			return status_or_proto.status();
		}

		const auto& proto = status_or_proto.value();
		GestureRecognizerResult gesture_recognizer_result;

		gesture_recognizer_result.gestures.reserve(proto.gestures.size());
		for (const auto& gestures : proto.gestures) {
			gesture_recognizer_result.gestures.push_back(tasks::components::containers::ConvertToClassifications(gestures).categories);
		}

		gesture_recognizer_result.handedness.reserve(proto.handedness.size());
		for (const auto& handedness : proto.handedness) {
			gesture_recognizer_result.handedness.push_back(tasks::components::containers::ConvertToClassifications(handedness).categories);
		}

		gesture_recognizer_result.hand_landmarks.reserve(proto.hand_landmarks.size());
		for (const auto& hand_landmarks : proto.hand_landmarks) {
			gesture_recognizer_result.hand_landmarks.push_back(tasks::components::containers::ConvertToNormalizedLandmarks(hand_landmarks).landmarks);
		}

		gesture_recognizer_result.hand_world_landmarks.reserve(proto.hand_world_landmarks.size());
		for (const auto& hand_world_landmarks : proto.hand_world_landmarks) {
			gesture_recognizer_result.hand_world_landmarks.push_back(tasks::components::containers::ConvertToLandmarks(hand_world_landmarks).landmarks);
		}

		return gesture_recognizer_result;
	}
}
