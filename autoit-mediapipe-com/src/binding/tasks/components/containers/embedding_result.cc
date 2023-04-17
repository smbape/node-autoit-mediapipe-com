#include "binding/tasks/components/containers/embedding_result.h"
#include "Mediapipe_Tasks_Autoit_Components_Containers_Embedding_result_Embedding_Object.h"
#include "Mediapipe_Tasks_Autoit_Components_Containers_Embedding_result_EmbeddingResult_Object.h"

using namespace mediapipe::tasks::components::containers;

namespace mediapipe::tasks::autoit::components::containers::embedding_result {
	std::shared_ptr<Embedding> Embedding::create_from_pb2(const proto::Embedding& pb2_obj) {
		auto embedding = std::make_shared<Embedding>();

		if (pb2_obj.has_float_embedding()) {
			std::vector<float> values(pb2_obj.float_embedding().values().begin(), pb2_obj.float_embedding().values().end());
			embedding->embedding = cv::Mat(values, true);
		}
		else {
			std::vector<byte> values(pb2_obj.quantized_embedding().values().begin(), pb2_obj.quantized_embedding().values().end());
			embedding->embedding = cv::Mat(values, true);
		}

		embedding->head_index = pb2_obj.head_index();
		embedding->head_name = pb2_obj.head_name();
		return embedding;
	}

	std::shared_ptr<EmbeddingResult> EmbeddingResult::create_from_pb2(const proto::EmbeddingResult& pb2_obj) {
		auto embedding_result = std::make_shared<EmbeddingResult>();
		for (const auto& embedding : pb2_obj.embeddings()) {
			embedding_result->embeddings.push_back(Embedding::create_from_pb2(embedding));
		}
		return embedding_result;
	}
}
