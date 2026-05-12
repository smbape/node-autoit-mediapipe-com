#pragma once

#include "mediapipe/tasks/cc/components/processors/embedder_options.h"

namespace mediapipe::tasks::components::processors {
	inline bool operator==(const EmbedderOptions& lhs, const EmbedderOptions& rhs) {
		return lhs.l2_normalize == rhs.l2_normalize
			&& lhs.quantize == rhs.quantize;
	}
}

namespace std {
	inline std::string to_string(const mediapipe::tasks::components::processors::EmbedderOptions& embedder_options) {
		auto proto = mediapipe::tasks::components::processors::ConvertEmbedderOptionsToProto(const_cast<mediapipe::tasks::components::processors::EmbedderOptions*>(&embedder_options));
		std::string output;
		if (!google::protobuf::TextFormat::PrintToString(proto, &output)) {
			output = "Failed to print message";
		}
		return output;
	}
}
