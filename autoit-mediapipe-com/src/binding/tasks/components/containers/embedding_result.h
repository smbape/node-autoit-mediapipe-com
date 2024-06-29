#pragma once

#include "mediapipe/tasks/cc/components/containers/proto/embeddings.pb.h"
#include <opencv2/core/mat.hpp>
#include "autoit_bridge_common.h"

namespace mediapipe::tasks::autoit::components::containers::embedding_result {
	struct CV_EXPORTS_W_SIMPLE Embedding {
		CV_WRAP Embedding(const Embedding& other) = default;
		Embedding& operator=(const Embedding& other) = default;

		CV_WRAP Embedding(
			cv::Mat embedding = cv::Mat(),
			int head_index = -1,
			const std::string& head_name = std::string()
		)
			:
			embedding(embedding),
			head_index(head_index),
			head_name(head_name)
		{}

		CV_WRAP static std::shared_ptr<Embedding> create_from_pb2(const mediapipe::tasks::components::containers::proto::Embedding& pb2_obj);

		bool operator== (const Embedding& other) const {
			return ::autoit::__eq__(embedding, other.embedding) &&
				::autoit::__eq__(head_index, other.head_index) &&
				::autoit::__eq__(head_name, other.head_name);
		}

		CV_PROP_RW cv::Mat embedding;
		CV_PROP_RW int head_index;
		CV_PROP_RW std::string head_name;
	};

	struct CV_EXPORTS_W_SIMPLE EmbeddingResult {
		CV_WRAP EmbeddingResult(const EmbeddingResult& other) = default;
		EmbeddingResult& operator=(const EmbeddingResult& other) = default;

		CV_WRAP EmbeddingResult(
			const std::shared_ptr<std::vector<std::shared_ptr<Embedding>>>& embeddings = std::make_shared<std::vector<std::shared_ptr<Embedding>>>(),
			int64_t timestamp_ms = 0
		)
			:
			embeddings(embeddings),
			timestamp_ms(timestamp_ms)
		{}

		CV_WRAP static std::shared_ptr<EmbeddingResult> create_from_pb2(const mediapipe::tasks::components::containers::proto::EmbeddingResult& pb2_obj);

		bool operator== (const EmbeddingResult& other) const {
			return ::autoit::__eq__(embeddings, other.embeddings) &&
				::autoit::__eq__(timestamp_ms, other.timestamp_ms);
		}

		CV_PROP_RW std::shared_ptr<std::vector<std::shared_ptr<Embedding>>> embeddings;
		CV_PROP_RW int64_t timestamp_ms;
	};
}
