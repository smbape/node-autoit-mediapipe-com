#include "binding/tasks/components/containers/proto_utils.h"

namespace mediapipe::tasks::components::containers {
	Rect ConvertToRect(const mediapipe::LocationData::BoundingBox& proto) {
		return {
			.left   = proto.xmin(),
			.top    = proto.ymin(),
			.right  = proto.xmin() + proto.width(),
			.bottom = proto.ymin() + proto.height(),
		};
	}

	NormalizedKeypoint ConvertToNormalizedKeypoint(const mediapipe::LocationData::RelativeKeypoint& proto) {
		return {
			.x = proto.x(),
			.y = proto.y(),
			.label = proto.has_keypoint_label() ? std::optional<std::string>(proto.keypoint_label()) : std::nullopt,
			.score = proto.has_score() ? std::optional<float>(proto.score()) : std::nullopt,
		};
	}
}
