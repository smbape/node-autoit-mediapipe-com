#pragma once

#include "binding/tasks/components/containers/embedding_result.h"

namespace mediapipe::tasks::autoit::components::utils::cosine_similarity {
	CV_EXPORTS_W [[nodiscard]] absl::StatusOr<float> cosine_similarity(const containers::embedding_result::Embedding& u, const containers::embedding_result::Embedding& v);
}
