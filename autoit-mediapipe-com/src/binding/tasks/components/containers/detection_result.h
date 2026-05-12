#pragma once

#include "mediapipe/tasks/cc/components/containers/detection_result.h"
#include "mediapipe/framework/formats/detection.pb.h"
#include "binding/tasks/components/containers/category.h"
#include "binding/tasks/components/containers/utils.h"

namespace mediapipe::tasks::components::containers {

	inline bool operator==(const Detection& lhs, const Detection& rhs) {
		return lhs.categories == rhs.categories
			&& lhs.bounding_box == rhs.bounding_box
			&& is_optional_equal(lhs.keypoints, rhs.keypoints);
	}

	inline bool operator==(const DetectionResult& lhs, const DetectionResult& rhs) {
		return lhs.detections == rhs.detections;
	}

	mediapipe::Detection ConvertDetectionToProto(Detection* detection);

	mediapipe::DetectionList ConvertDetectionResultToProto(DetectionResult* detection_result);

	// Utility function to convert from Detection proto to Detection struct.
	Detection ConvertToDetection(const mediapipe::Detection& detection_proto, int image_width, int image_height);

}  // namespace mediapipe::tasks::components::containers

namespace std {
	inline std::string to_string(const mediapipe::tasks::components::containers::Detection& detection) {
		auto proto = mediapipe::tasks::components::containers::ConvertDetectionToProto(const_cast<mediapipe::tasks::components::containers::Detection*>(&detection));
		std::string output;
		if (!google::protobuf::TextFormat::PrintToString(proto, &output)) {
			output = "Failed to print message";
		}
		return output;
	}

	inline std::string to_string(const mediapipe::tasks::components::containers::DetectionResult& detection_result) {
		auto proto = mediapipe::tasks::components::containers::ConvertDetectionResultToProto(const_cast<mediapipe::tasks::components::containers::DetectionResult*>(&detection_result));
		std::string output;
		if (!google::protobuf::TextFormat::PrintToString(proto, &output)) {
			output = "Failed to print message";
		}
		return output;
	}
}
