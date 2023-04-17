#include "binding/tasks/components/utils/cosine_similarity.h"
#include <opencv2/core.hpp>

namespace mediapipe::tasks::autoit::components::utils::cosine_similarity {
	float cosine_similarity(const containers::embedding_result::Embedding& u, const containers::embedding_result::Embedding& v) {
		AUTOIT_ASSERT_THROW(!u.embedding.empty(), "Cannot compute cosing similarity on empty embeddings.");

		AUTOIT_ASSERT_THROW(u.embedding.total() == v.embedding.total(),
			"Cannot compute cosine similarity between embeddings "
			"of different sizes "
			"(" << u.embedding.total() << " vs. " << v.embedding.total() << ").");

		AUTOIT_ASSERT_THROW(u.embedding.type() == v.embedding.type(),
			"Cannot compute cosine similarity between quantized and "
				"float embeddings.");

		auto norm_u = cv::norm(u.embedding);
		auto norm_v = cv::norm(v.embedding);
		AUTOIT_ASSERT_THROW(norm_u > 0 && norm_v > 0, "Cannot compute cosine similarity on embedding with 0 norm.");

		cv::Mat transposed;
		cv::transpose(v.embedding, transposed);
		return u.embedding.dot(transposed) / (norm_u * norm_v);
	}
}
