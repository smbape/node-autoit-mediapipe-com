#include "binding/tasks/components/containers/landmark.h"

using namespace mediapipe::tasks::components::containers;

namespace mediapipe {
	namespace tasks {
		namespace autoit {
			namespace components {
				namespace containers {
					namespace landmark {

						std::shared_ptr<mediapipe::Landmark> Landmark::to_pb2() {
							auto pb2_obj = std::make_shared<mediapipe::Landmark>();
							pb2_obj->set_x(x);
							pb2_obj->set_y(y);
							pb2_obj->set_z(z);
							pb2_obj->set_visibility(visibility);
							pb2_obj->set_presence(presence);
							return pb2_obj;
						}

						std::shared_ptr<Landmark> Landmark::create_from_pb2(const mediapipe::Landmark& pb2_obj) {
							return std::make_shared<Landmark>(
								pb2_obj.x(),
								pb2_obj.y(),
								pb2_obj.z(),
								pb2_obj.visibility(),
								pb2_obj.presence()
								);
						}

						std::shared_ptr<mediapipe::NormalizedLandmark> NormalizedLandmark::to_pb2() {
							auto pb2_obj = std::make_shared<mediapipe::NormalizedLandmark>();
							pb2_obj->set_x(x);
							pb2_obj->set_y(y);
							pb2_obj->set_z(z);
							pb2_obj->set_visibility(visibility);
							pb2_obj->set_presence(presence);
							return pb2_obj;
						}

						std::shared_ptr<NormalizedLandmark> NormalizedLandmark::create_from_pb2(const mediapipe::NormalizedLandmark& pb2_obj) {
							return std::make_shared<NormalizedLandmark>(
								pb2_obj.x(),
								pb2_obj.y(),
								pb2_obj.z(),
								pb2_obj.visibility(),
								pb2_obj.presence()
								);
						}
					}
				}
			}
		}
	}
}
