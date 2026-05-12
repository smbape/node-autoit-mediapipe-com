#pragma once

#include "mediapipe/tasks/cc/text/language_detector/language_detector.h"

namespace mediapipe::tasks::text::language_detector {
	inline bool operator==(const LanguageDetectorPrediction& lhs, const LanguageDetectorPrediction& rhs) {
		return lhs.language_code == rhs.language_code
			&& lhs.probability == rhs.probability;
	}
}

namespace mediapipe::tasks::autoit::text::language_detector {
	using LanguageDetectorPrediction = tasks::text::language_detector::LanguageDetectorPrediction;

	struct LanguageDetectorResult {
		std::vector<LanguageDetectorPrediction> detections;
	};

	absl::StatusOr<LanguageDetectorResult> CppConvertToLanguageDetectorResult(const absl::StatusOr<std::vector<LanguageDetectorPrediction>>& detections);
}
