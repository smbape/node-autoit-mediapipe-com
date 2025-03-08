#pragma once

#include "mediapipe/framework/formats/classification.pb.h"
#include <opencv2/core/cvdef.h>
#include "autoit_bridge_common.h"

namespace mediapipe::tasks::autoit::components::containers::category {
	struct CV_EXPORTS_W_SIMPLE Category {
		CV_WRAP Category(const Category& other) = default;
		Category& operator=(const Category& other) = default;

		CV_WRAP Category(
			int index = -1,
			float score = 0.0f,
			const std::string& display_name = "",
			const std::string& category_name = ""
		)
			:
			index(index),
			score(score),
			display_name(display_name),
			category_name(category_name)
		{}

		CV_WRAP std::shared_ptr<Classification> to_pb2() const;
		CV_WRAP static std::shared_ptr<Category> create_from_pb2(const Classification& pb2_obj);

		bool operator== (const Category& other) const {
			return ::autoit::__eq__(index, other.index) &&
				::autoit::__eq__(score, other.score) &&
				::autoit::__eq__(display_name, other.display_name) &&
				::autoit::__eq__(category_name, other.category_name);
		}

		CV_PROP_RW int index;
		CV_PROP_RW float score;
		CV_PROP_RW std::string display_name;
		CV_PROP_RW std::string category_name;
	};
}
