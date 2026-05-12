#pragma once

#include "mediapipe/tasks/cc/components/containers/rect.h"
#include "mediapipe/framework/formats/rect.pb.h"

namespace mediapipe::tasks::components::containers {

	struct NormalizedRect {
		float x_center;
		float y_center;
		float width;
		float height;
		std::optional<float> rotation = std::nullopt;
		std::optional<int64_t> rect_id = std::nullopt;
	};

	inline bool operator==(const NormalizedRect& lhs, const NormalizedRect& rhs) {
		return lhs.x_center == rhs.x_center
			&& lhs.y_center == rhs.y_center
			&& lhs.width == rhs.width
			&& lhs.height == rhs.height
			&& lhs.rotation == rhs.rotation;
	}

	mediapipe::NormalizedRect ConvertNormalizedRectToProto(NormalizedRect* normalized_rect);

	// Utility function to convert from NormalizedRect proto to NormalizedRect
	// struct.
	NormalizedRect ConvertToNormalizedRect(const mediapipe::NormalizedRect& proto);
}

namespace std {
	inline std::string to_string(const mediapipe::tasks::components::containers::NormalizedRect& normalized_result) {
		auto proto = mediapipe::tasks::components::containers::ConvertNormalizedRectToProto(const_cast<mediapipe::tasks::components::containers::NormalizedRect*>(&normalized_result));
		std::string output;
		if (!google::protobuf::TextFormat::PrintToString(proto, &output)) {
			output = "Failed to print message";
		}
		return output;
	}
}
