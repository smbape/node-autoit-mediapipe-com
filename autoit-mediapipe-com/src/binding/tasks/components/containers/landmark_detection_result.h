#pragma once

#include "binding/tasks/components/containers/category.h"
#include "binding/tasks/components/containers/landmark.h"
#include "binding/tasks/components/containers/rect.h"
#include "mediapipe/tasks/cc/components/containers/proto/landmarks_detection_result.pb.h"

namespace mediapipe::tasks::components::containers {
	struct LandmarksDetectionResult {
		std::vector<NormalizedLandmark> landmarks;
		std::vector<Category> categories;
		std::vector<Landmark> world_landmarks;
		NormalizedRect rect;
	};

	inline bool operator==(const LandmarksDetectionResult& lhs, const LandmarksDetectionResult& rhs) {
		return lhs.landmarks == rhs.landmarks
			&& lhs.categories == rhs.categories
			&& lhs.world_landmarks == rhs.world_landmarks
			&& lhs.rect == rhs.rect;
	}

	tasks::containers::proto::LandmarksDetectionResult ConvertLandmarkListToProto(LandmarksDetectionResult* landmarks_detection_result);

	// Utility function to convert from LandmarksDetectionResult proto to LandmarksDetectionResult
	// struct.
	LandmarksDetectionResult ConvertToLandmarksDetectionResult(const tasks::containers::proto::LandmarksDetectionResult& proto);
}

namespace std {
	inline std::string to_string(const mediapipe::tasks::components::containers::LandmarksDetectionResult& landmarks_detection_result) {
		auto proto = mediapipe::tasks::components::containers::ConvertLandmarkListToProto(const_cast<mediapipe::tasks::components::containers::LandmarksDetectionResult*>(&landmarks_detection_result));
		std::string output;
		if (!google::protobuf::TextFormat::PrintToString(proto, &output)) {
			output = "Failed to print message";
		}
		return output;
	}
}
