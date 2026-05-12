#include "binding/tasks/components/containers/rect.h"

namespace mediapipe::tasks::components::containers {
	mediapipe::NormalizedRect ConvertNormalizedRectToProto(NormalizedRect* normalized_rect) {
		mediapipe::NormalizedRect normalized_rect_proto;
		normalized_rect_proto.set_x_center(normalized_rect->x_center);
		normalized_rect_proto.set_y_center(normalized_rect->y_center);
		normalized_rect_proto.set_width(normalized_rect->width);
		normalized_rect_proto.set_height(normalized_rect->height);
		if (normalized_rect->rotation) {
			normalized_rect_proto.set_rotation(*normalized_rect->rotation);
		}
		if (normalized_rect->rect_id) {
			normalized_rect_proto.set_rect_id(*normalized_rect->rect_id);
		}
		return normalized_rect_proto;
	}

	NormalizedRect ConvertToNormalizedRect(const mediapipe::NormalizedRect& proto) {
		return {
			.x_center = proto.x_center(),
			.y_center = proto.y_center(),
			.width    = proto.width(),
			.height   = proto.height(),
			.rotation = proto.has_rotation() ? std::optional<float>(proto.rotation()) : std::optional<float>(0.0f),
			.rect_id =  proto.has_rect_id() ? std::optional<int64_t>(proto.rect_id()) : std::nullopt
		};
	}
}
