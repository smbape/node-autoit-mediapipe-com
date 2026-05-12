#include "binding/tasks/components/containers/keypoint.h"

namespace mediapipe::tasks::components::containers {
	LocationData::RelativeKeypoint ConvertNormalizedKeypointToProto(NormalizedKeypoint* normalized_keypoint) {
		LocationData::RelativeKeypoint normalized_keypoint_proto;
		normalized_keypoint_proto.set_x(normalized_keypoint->x);
		normalized_keypoint_proto.set_y(normalized_keypoint->y);
		if (normalized_keypoint->label) {
			normalized_keypoint_proto.set_keypoint_label(*normalized_keypoint->label);
		}
		if (normalized_keypoint->score) {
			normalized_keypoint_proto.set_score(*normalized_keypoint->score);
		}
		return normalized_keypoint_proto;
	}
}
