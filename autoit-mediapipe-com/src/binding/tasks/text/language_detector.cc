#include "binding/tasks/text/language_detector.h"
#include "binding/packet_getter.h"

namespace {
	using namespace mediapipe::autoit::packet_getter;
	using namespace mediapipe::tasks::autoit::components::containers::classification_result;
	using namespace mediapipe::tasks::autoit::core::base_options;
	using namespace mediapipe::tasks::autoit::core::task_info;
	using namespace mediapipe::tasks::autoit::text::language_detector;
	using namespace mediapipe::tasks::text::text_classifier::proto;

	const std::string _CLASSIFICATIONS_STREAM_NAME = "classifications_out";
	const std::string _CLASSIFICATIONS_TAG = "CLASSIFICATIONS";
	const std::string _TEXT_IN_STREAM_NAME = "text_in";
	const std::string _TEXT_TAG = "TEXT";
	const std::string _TASK_GRAPH_NAME = "mediapipe.tasks.text.text_classifier.TextClassifierGraph";

	std::shared_ptr<LanguageDetectorResult> _extract_language_detector_result(const _ClassificationResult& classification_result) {
		AUTOIT_ASSERT_THROW(classification_result.classifications->size() == 1,
			"The LanguageDetector TextClassifierGraph should have exactly one "
			"classification head.");

		const auto& languages_and_scores = classification_result.classifications->at(0);

		std::shared_ptr<LanguageDetectorResult> language_detector_result = std::make_shared<LanguageDetectorResult>();

		for (const auto& category : *languages_and_scores->categories) {
			AUTOIT_ASSERT_THROW(!category->category_name.empty(),
				"LanguageDetector ClassificationResult has a missing language code.");
			language_detector_result->detections->push_back(
				std::make_shared<LanguageDetectorResult::Detection>(category->category_name, category->score)
			);
		}

		return language_detector_result;
	}
}

namespace mediapipe::tasks::autoit::text::language_detector {
	std::shared_ptr<TextClassifierGraphOptions> LanguageDetectorOptions::to_pb2() {
		auto pb2_obj = std::make_shared<TextClassifierGraphOptions>();

		if (base_options) {
			pb2_obj->mutable_base_options()->CopyFrom(*base_options->to_pb2());
		}

		if (score_threshold) pb2_obj->mutable_classifier_options()->set_score_threshold(*score_threshold);
		if (category_allowlist) pb2_obj->mutable_classifier_options()->mutable_category_allowlist()->Add(category_allowlist->begin(), category_allowlist->end());
		if (category_denylist) pb2_obj->mutable_classifier_options()->mutable_category_denylist()->Add(category_denylist->begin(), category_denylist->end());
		if (display_names_locale) pb2_obj->mutable_classifier_options()->set_display_names_locale(*display_names_locale);
		if (max_results) pb2_obj->mutable_classifier_options()->set_max_results(*max_results);

		return pb2_obj;
	}

	std::shared_ptr<LanguageDetector> LanguageDetector::create_from_model_path(const std::string& model_path) {
		auto base_options = std::make_shared<BaseOptions>(model_path);
		return create_from_options(std::make_shared<LanguageDetectorOptions>(base_options));
	}

	std::shared_ptr<LanguageDetector> LanguageDetector::create_from_options(std::shared_ptr<LanguageDetectorOptions> options) {
		TaskInfo task_info;
		task_info.task_graph = _TASK_GRAPH_NAME;
		*task_info.input_streams = { _TEXT_TAG + ":" + _TEXT_IN_STREAM_NAME };
		*task_info.output_streams = { _CLASSIFICATIONS_TAG + ":" + _CLASSIFICATIONS_STREAM_NAME };
		task_info.task_options = options->to_pb2();

		return std::make_shared<LanguageDetector>(*task_info.generate_graph_config());
	}

	std::shared_ptr<LanguageDetectorResult> LanguageDetector::detect(const std::string& text) {
		auto output_packets = mediapipe::autoit::AssertAutoItValue(_runner->Process({
			{ _TEXT_IN_STREAM_NAME, std::move(MakePacket<std::string>(text)) }
			}));

		const auto& classification_result_proto = GetContent<mediapipe::tasks::components::containers::proto::ClassificationResult>(output_packets.at(_CLASSIFICATIONS_STREAM_NAME));
		const auto& classification_result = _ClassificationResult::create_from_pb2(classification_result_proto);
		return _extract_language_detector_result(*classification_result);
	}
}
