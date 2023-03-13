#pragma once

#include "binding/tasks/components/containers/embedding_result.h"

namespace mediapipe {
	namespace tasks {
		namespace autoit {
			namespace components {
				namespace utils {
					namespace cosine_similarity {
						CV_EXPORTS_W float cosine_similarity(const containers::embedding_result::Embedding& u, const containers::embedding_result::Embedding& v);
					}
				}
			}
		}
	}
}
