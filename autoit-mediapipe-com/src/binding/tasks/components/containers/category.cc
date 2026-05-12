#include "binding/tasks/components/containers/category.h"

namespace mediapipe::tasks::components::containers {
	Classification ConvertCategoryToProto(Category* category) {
		Classification classification_proto;
		classification_proto.set_index(category->index);
		classification_proto.set_score(category->score);
		if (category->display_name) {
			classification_proto.set_display_name(*category->display_name);
		}
		if (category->category_name) {
			classification_proto.set_label(*category->category_name);
		}
		return classification_proto;
	}
}
