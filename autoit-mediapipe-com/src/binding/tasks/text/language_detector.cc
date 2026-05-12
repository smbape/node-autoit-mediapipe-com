#include "binding/tasks/text/language_detector.h"

namespace mediapipe::tasks::autoit::text::language_detector {
	absl::StatusOr<LanguageDetectorResult> CppConvertToLanguageDetectorResult(const absl::StatusOr<std::vector<tasks::text::language_detector::LanguageDetectorPrediction>>& detections) {
		if (!detections.ok()) {
			return detections.status();
		}
		return LanguageDetectorResult({ .detections{ detections.value() } });
	}
}
