#include "binding/tasks/components/containers/bounding_box.h"

namespace mediapipe::tasks::components::containers {
	LocationData::BoundingBox ConvertRectToProto(Rect* rect) {
		LocationData::BoundingBox bounding_box_proto;
		bounding_box_proto.set_xmin(rect->left);
		bounding_box_proto.set_ymin(rect->top);
		bounding_box_proto.set_width(rect->right - rect->left);
		bounding_box_proto.set_height(rect->bottom - rect->top);
		return bounding_box_proto;
	}
}
