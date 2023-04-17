#include "binding/tasks/components/containers/rect.h"

namespace mediapipe::tasks::autoit::components::containers::rect {
	std::shared_ptr<mediapipe::NormalizedRect> NormalizedRect::to_pb2() {
		auto pb2_obj = std::make_shared<mediapipe::NormalizedRect>();
		pb2_obj->set_x_center(x_center);
		pb2_obj->set_y_center(y_center);
		pb2_obj->set_width(width);
		pb2_obj->set_height(height);
		pb2_obj->set_rotation(rotation);
		pb2_obj->set_rect_id(rect_id);
		return pb2_obj;
	}

	std::shared_ptr<NormalizedRect> NormalizedRect::create_from_pb2(const mediapipe::NormalizedRect& pb2_obj) {
		return std::make_shared<NormalizedRect>(
			pb2_obj.x_center(),
			pb2_obj.y_center(),
			pb2_obj.width(),
			pb2_obj.height(),
			pb2_obj.rotation(),
			pb2_obj.rect_id()
			);
	}
}
