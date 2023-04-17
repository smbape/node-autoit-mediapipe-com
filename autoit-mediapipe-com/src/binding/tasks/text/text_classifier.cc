#include "binding/tasks/text/text_classifier.h"
#include "binding/packet_getter.h"

namespace {
using namespace mediapipe::tasks::text::text_classifier::proto;
using namespace mediapipe::tasks::autoit::components::containers::classification_result;
using namespace mediapipe::tasks::autoit::core::base_options;
using namespace mediapipe::tasks::autoit::core::task_info;

const std::string _CLASSIFICATIONS_STREAM_NAME = "classifications_out";
const std::string _CLASSIFICATIONS_TAG = "CLASSIFICATIONS";
const std::string _TEXT_IN_STREAM_NAME = "text_in";
const std::string _TEXT_TAG = "TEXT";
const std::string _TASK_GRAPH_NAME = "mediapipe.tasks.text.text_classifier.TextClassifierGraph";
}

namespace mediapipe::tasks::autoit::text::text_classifier {
	std::shared_ptr<TextClassifierGraphOptions> TextClassifierOptions::to_pb2() {
		auto pb2_obj = std::make_shared<TextClassifierGraphOptions>();

		if (base_options) {
			pb2_obj->mutable_base_options()->CopyFrom(*base_options->to_pb2());
		}

		if (score_threshold) pb2_obj->mutable_classifier_options()->set_score_threshold(*score_threshold);
		pb2_obj->mutable_classifier_options()->mutable_category_allowlist()->Add(category_allowlist.begin(), category_allowlist.end());
		pb2_obj->mutable_classifier_options()->mutable_category_denylist()->Add(category_denylist.begin(), category_denylist.end());
		if (display_names_locale) pb2_obj->mutable_classifier_options()->set_display_names_locale(*display_names_locale);
		if (max_results) pb2_obj->mutable_classifier_options()->set_max_results(*max_results);

		return pb2_obj;
	}

	std::shared_ptr<TextClassifier> TextClassifier::create_from_model_path(const std::string& model_path) {
		auto base_options = std::make_shared<BaseOptions>(model_path);
		return create_from_options(std::make_shared<TextClassifierOptions>(base_options));
	}

	std::shared_ptr<TextClassifier> TextClassifier::create_from_options(std::shared_ptr<TextClassifierOptions> options) {
		TaskInfo task_info;
		task_info.task_graph = _TASK_GRAPH_NAME;
		task_info.input_streams = { _TEXT_TAG + ":" + _TEXT_IN_STREAM_NAME };
		task_info.output_streams = { _CLASSIFICATIONS_TAG + ":" + _CLASSIFICATIONS_STREAM_NAME };
		task_info.task_options = options->to_pb2();

		return std::make_shared<TextClassifier>(*task_info.generate_graph_config());
	}

	std::shared_ptr<TextClassifierResult> TextClassifier::classify(const std::string& text) {
		auto output_packets = mediapipe::autoit::AssertAutoItValue(_runner->Process({
			{ _TEXT_IN_STREAM_NAME, std::move(MakePacket<std::string>(text)) }
			}));

		mediapipe::tasks::components::containers::proto::ClassificationResult classification_result_proto;
		classification_result_proto.CopyFrom(
			*mediapipe::autoit::packet_getter::get_proto(output_packets.at(_CLASSIFICATIONS_STREAM_NAME))
		);

		return TextClassifierResult::create_from_pb2(classification_result_proto);
	}
}
