#pragma once

#include "mediapipe/tasks/cc/components/containers/keypoint.h"
#include "binding/tasks/components/containers/utils.h"

namespace mediapipe::tasks::components::containers {

	inline bool operator==(const NormalizedKeypoint& lhs, const NormalizedKeypoint& rhs) {
		return lhs.x == rhs.x
			&& lhs.y == rhs.y
			&& is_optional_equal(lhs.label, rhs.label)
			&& is_optional_equal(lhs.score, rhs.score);
	}

	LocationData::RelativeKeypoint ConvertNormalizedKeypointToProto(NormalizedKeypoint* normalized_keypoint);

}  // namespace mediapipe::tasks::components::containers

namespace std {
	inline std::string to_string(const mediapipe::tasks::components::containers::NormalizedKeypoint& normalized_keypoint) {
		auto proto = mediapipe::tasks::components::containers::ConvertNormalizedKeypointToProto(const_cast<mediapipe::tasks::components::containers::NormalizedKeypoint*>(&normalized_keypoint));
		std::string output;
		if (!google::protobuf::TextFormat::PrintToString(proto, &output)) {
			output = "Failed to print message";
		}
		return output;
	}
}
