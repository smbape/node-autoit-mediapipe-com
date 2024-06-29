#pragma once

#include "mediapipe/tasks/cc/components/containers/proto/classifications.pb.h"
#include "mediapipe/tasks/cc/components/processors/proto/classifier_options.pb.h"
#include "mediapipe/tasks/cc/text/text_classifier/proto/text_classifier_graph_options.pb.h"
#include "binding/tasks/components/containers/classification_result.h"
#include "binding/tasks/core/base_options.h"
#include "binding/tasks/core/task_info.h"
#include "binding/tasks/text/core/base_text_task_api.h"

namespace mediapipe::tasks::autoit::text::language_detector {
	using _ClassificationResult = components::containers::classification_result::ClassificationResult;

	struct CV_EXPORTS_W_SIMPLE LanguageDetectorResult {
		struct CV_EXPORTS_W_SIMPLE Detection {
			CV_WRAP Detection(const Detection& other) = default;
			Detection& operator=(const Detection& other) = default;

			CV_WRAP Detection(
				const std::string& language_code = "",
				float probability = 0.0
			)
				:
				language_code(language_code),
				probability(probability) {}

			// An i18n language / locale code, e.g. "en" for English, "uz" for Uzbek,
			// "ja"-Latn for Japanese (romaji).
			CV_PROP_RW std::string language_code;
			CV_PROP_RW float probability;
		};

		CV_WRAP LanguageDetectorResult(const LanguageDetectorResult& other) = default;
		LanguageDetectorResult& operator=(const LanguageDetectorResult& other) = default;

		CV_WRAP LanguageDetectorResult(
			const std::shared_ptr<std::vector<std::shared_ptr<LanguageDetectorResult::Detection>>>& detections = std::make_shared<std::vector<std::shared_ptr<LanguageDetectorResult::Detection>>>()
		) : detections(detections) {};

		bool operator== (const LanguageDetectorResult& other) const {
			return ::autoit::__eq__(detections, other.detections);
		}

		CV_PROP_RW std::shared_ptr<std::vector<std::shared_ptr<LanguageDetectorResult::Detection>>> detections;
	};

	struct CV_EXPORTS_W_SIMPLE LanguageDetectorOptions {
		CV_WRAP LanguageDetectorOptions(const LanguageDetectorOptions& other) = default;
		LanguageDetectorOptions& operator=(const LanguageDetectorOptions& other) = default;

		CV_WRAP LanguageDetectorOptions(
			std::shared_ptr<autoit::core::base_options::BaseOptions> base_options = std::shared_ptr<autoit::core::base_options::BaseOptions>(),
			const std::optional<std::string>& display_names_locale = std::optional<std::string>(),
			const std::optional<int>& max_results = std::optional<int>(),
			const std::optional<float>& score_threshold = std::optional<float>(),
			const std::shared_ptr<std::vector<std::string>>& category_allowlist = std::make_shared<std::vector<std::string>>(),
			const std::shared_ptr<std::vector<std::string>>& category_denylist = std::make_shared<std::vector<std::string>>()
		)
			:
			base_options(base_options),
			display_names_locale(display_names_locale),
			max_results(max_results),
			score_threshold(score_threshold),
			category_allowlist(category_allowlist),
			category_denylist(category_denylist)
		{}

		CV_WRAP std::shared_ptr<mediapipe::tasks::text::text_classifier::proto::TextClassifierGraphOptions> to_pb2();

		CV_PROP_RW std::shared_ptr<autoit::core::base_options::BaseOptions> base_options;
		CV_PROP_RW std::optional<std::string> display_names_locale;
		CV_PROP_RW std::optional<int> max_results;
		CV_PROP_RW std::optional<float> score_threshold;
		CV_PROP_RW std::shared_ptr<std::vector<std::string>> category_allowlist;
		CV_PROP_RW std::shared_ptr<std::vector<std::string>> category_denylist;
	};

	class CV_EXPORTS_W LanguageDetector : public ::mediapipe::tasks::autoit::text::core::base_text_task_api::BaseTextTaskApi {
	public:
		using core::base_text_task_api::BaseTextTaskApi::BaseTextTaskApi;

		CV_WRAP static std::shared_ptr<LanguageDetector> create_from_model_path(const std::string& model_path);
		CV_WRAP static std::shared_ptr<LanguageDetector> create_from_options(std::shared_ptr<LanguageDetectorOptions> options);
		CV_WRAP std::shared_ptr<LanguageDetectorResult> detect(const std::string& text);
	};
}
