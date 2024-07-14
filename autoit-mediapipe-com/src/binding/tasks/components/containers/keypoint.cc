#include "binding/tasks/components/containers/keypoint.h"

namespace mediapipe::tasks::autoit::components::containers::keypoint {
	std::shared_ptr<LocationData::RelativeKeypoint> NormalizedKeypoint::to_pb2() const {
		auto pb2_obj = std::make_shared<LocationData::RelativeKeypoint>();
		if (x) {
			pb2_obj->set_x(x.value());
		}
		if (y) {
			pb2_obj->set_y(y.value());
		}
		if (label) {
			pb2_obj->set_keypoint_label(label.value());
		}
		if (score) {
			pb2_obj->set_score(score.value());
		}
		return pb2_obj;
	}

	std::shared_ptr<NormalizedKeypoint> NormalizedKeypoint::create_from_pb2(const LocationData::RelativeKeypoint& pb2_obj) {
		return std::make_shared<NormalizedKeypoint>(
			pb2_obj.x(),
			pb2_obj.y(),
			pb2_obj.keypoint_label(),
			pb2_obj.score()
		);
	}
}