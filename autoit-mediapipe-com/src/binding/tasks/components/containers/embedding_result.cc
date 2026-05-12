#include "binding/tasks/components/containers/embedding_result.h"

namespace mediapipe::tasks::components::containers {
	proto::Embedding ConvertEmbeddingToProto(Embedding* embedding) {
		proto::Embedding embedding_proto;

		if (!embedding->float_embedding.empty()) {
			embedding_proto.mutable_float_embedding()->mutable_values()->Add(embedding->float_embedding.begin(), embedding->float_embedding.end());
		}

		if (!embedding->quantized_embedding.empty()) {
			*embedding_proto.mutable_quantized_embedding()->mutable_values() = embedding->quantized_embedding;
		}

		embedding_proto.set_head_index(embedding->head_index);

		if (embedding->head_name) {
			embedding_proto.set_head_name(*embedding->head_name);
		}

		return embedding_proto;
	}

	proto::EmbeddingResult ConvertEmbeddingResultToProto(EmbeddingResult* embedding_result) {
		proto::EmbeddingResult embedding_result_proto;

		for (const auto& embedding : embedding_result->embeddings) {
			embedding_result_proto.add_embeddings()->CopyFrom(ConvertEmbeddingToProto(const_cast<Embedding*>(&embedding)));
		}

		if (embedding_result->timestamp_ms) {
			embedding_result_proto.set_timestamp_ms(*embedding_result->timestamp_ms);
		}

		return embedding_result_proto;
	}
}
