#pragma once

#include "mediapipe/tasks/cc/components/processors/classifier_options.h"

namespace mediapipe::tasks::components::processors {
	inline bool operator==(const ClassifierOptions& lhs, const ClassifierOptions& rhs) {
		return lhs.display_names_locale == rhs.display_names_locale
			&& lhs.max_results == rhs.max_results
			&& lhs.score_threshold == rhs.score_threshold
			&& lhs.category_allowlist == rhs.category_allowlist
			&& lhs.category_denylist == rhs.category_denylist;
	}
}

namespace std {
	inline std::string to_string(const mediapipe::tasks::components::processors::ClassifierOptions& classifier_options) {
		auto proto = mediapipe::tasks::components::processors::ConvertClassifierOptionsToProto(const_cast<mediapipe::tasks::components::processors::ClassifierOptions*>(&classifier_options));
		std::string output;
		if (!google::protobuf::TextFormat::PrintToString(proto, &output)) {
			output = "Failed to print message";
		}
		return output;
	}
}
