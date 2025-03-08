#include "binding/tasks/components/containers/category.h"

namespace mediapipe::tasks::autoit::components::containers::category {
	std::shared_ptr<Classification> Category::to_pb2() const {
		auto pb2_obj = std::make_shared<Classification>();
		pb2_obj->set_index(index);
		pb2_obj->set_score(score);
		pb2_obj->set_display_name(display_name);
		pb2_obj->set_label(category_name);
		return pb2_obj;
	}

	std::shared_ptr<Category> Category::create_from_pb2(const Classification& pb2_obj) {
		return std::make_shared<Category>(
			pb2_obj.index(),
			pb2_obj.score(),
			pb2_obj.display_name(),
			pb2_obj.label()
		);
	}
}