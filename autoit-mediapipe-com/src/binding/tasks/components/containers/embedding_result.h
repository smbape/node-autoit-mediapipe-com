#pragma once

#include "mediapipe/tasks/cc/components/containers/embedding_result.h"
#include "binding/tasks/components/containers/utils.h"

namespace mediapipe::tasks::components::containers {
	inline bool operator==(const Embedding& lhs, const Embedding& rhs) {
		return lhs.float_embedding == rhs.float_embedding
			&& lhs.quantized_embedding == rhs.quantized_embedding
			&& lhs.head_index == rhs.head_index
			&& is_optional_equal(lhs.head_name, rhs.head_name);
	}

	inline bool operator==(const EmbeddingResult& lhs, const EmbeddingResult& rhs) {
		return lhs.embeddings == rhs.embeddings
			&& is_optional_equal(lhs.timestamp_ms, rhs.timestamp_ms);
	}

	proto::Embedding ConvertEmbeddingToProto(Embedding* embedding);

	proto::EmbeddingResult ConvertEmbeddingResultToProto(EmbeddingResult* embedding_result);
}

namespace std {
	inline std::string to_string(const mediapipe::tasks::components::containers::Embedding& embedding) {
		auto proto = mediapipe::tasks::components::containers::ConvertEmbeddingToProto(const_cast<mediapipe::tasks::components::containers::Embedding*>(&embedding));
		std::string output;
		if (!google::protobuf::TextFormat::PrintToString(proto, &output)) {
			output = "Failed to print message";
		}
		return output;
	}

	inline std::string to_string(const mediapipe::tasks::components::containers::EmbeddingResult& embedding_result) {
		auto proto = mediapipe::tasks::components::containers::ConvertEmbeddingResultToProto(const_cast<mediapipe::tasks::components::containers::EmbeddingResult*>(&embedding_result));
		std::string output;
		if (!google::protobuf::TextFormat::PrintToString(proto, &output)) {
			output = "Failed to print message";
		}
		return output;
	}
}
