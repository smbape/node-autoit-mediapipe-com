#pragma once

#include "mediapipe/tasks/cc/core/base_options.h"

namespace mediapipe::tasks::core {
	inline bool operator==(const BaseOptions& lhs, const BaseOptions& rhs) {
		return lhs.model_asset_buffer == rhs.model_asset_buffer
			&& lhs.model_asset_path == rhs.model_asset_path
			&& lhs.delegate == rhs.delegate;
	}
}

namespace std {
	inline std::string to_string(const mediapipe::tasks::core::BaseOptions& base_options) {
		auto proto = mediapipe::tasks::core::ConvertBaseOptionsToProto(const_cast<mediapipe::tasks::core::BaseOptions*>(&base_options));
		std::string output;
		if (!google::protobuf::TextFormat::PrintToString(proto, &output)) {
			output = "Failed to print message";
		}
		return output;
	}
}
