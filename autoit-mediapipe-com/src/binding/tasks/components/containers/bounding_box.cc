#include "binding/tasks/components/containers/bounding_box.h"

namespace mediapipe {
	namespace tasks {
		namespace autoit {
			namespace components {
				namespace containers {
					namespace bounding_box {
						std::shared_ptr<LocationData::BoundingBox> BoundingBox::to_pb2() {
							auto pb2_obj = std::make_shared<LocationData::BoundingBox>();
							pb2_obj->set_xmin(origin_x);
							pb2_obj->set_ymin(origin_y);
							pb2_obj->set_width(width);
							pb2_obj->set_height(height);
							return pb2_obj;
						}

						std::shared_ptr<BoundingBox> BoundingBox::create_from_pb2(const LocationData::BoundingBox& pb2_obj) {
							return std::make_shared<BoundingBox>(
								pb2_obj.xmin(),
								pb2_obj.ymin(),
								pb2_obj.width(),
								pb2_obj.height()
								);
						}
					}
				}
			}
		}
	}
}
