#pragma once

#include "mediapipe/tasks/cc/components/containers/category.h"
#include "mediapipe/framework/formats/classification.pb.h"
#include "google/protobuf/text_format.h"
#include "binding/tasks/components/containers/utils.h"

namespace mediapipe::tasks::components::containers {
	inline constexpr float kScoreTolerance = 1e-6;

	inline bool operator==(const Category& lhs, const Category& rhs) {
		return lhs.index == rhs.index
			&& abs(lhs.score - rhs.score) < kScoreTolerance
			&& is_optional_equal(lhs.category_name, rhs.category_name)
			&& is_optional_equal(lhs.display_name, rhs.display_name);
	}

	Classification ConvertCategoryToProto(Category* category);

}  // namespace mediapipe::tasks::components::containers

namespace std {
	inline std::string to_string(const mediapipe::tasks::components::containers::Category& category) {
		auto proto = mediapipe::tasks::components::containers::ConvertCategoryToProto(const_cast<mediapipe::tasks::components::containers::Category*>(&category));
		std::string output;
		if (!google::protobuf::TextFormat::PrintToString(proto, &output)) {
			output = "Failed to print message";
		}
		return output;
	}
}
