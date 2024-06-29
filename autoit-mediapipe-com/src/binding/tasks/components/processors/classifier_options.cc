#include "binding/tasks/components/processors/classifier_options.h"

using namespace mediapipe::tasks::components::processors;

namespace mediapipe::tasks::autoit::components::processors::classifier_options {
	std::shared_ptr<proto::ClassifierOptions> ClassifierOptions::to_pb2() {
		auto pb2_obj = std::make_shared<proto::ClassifierOptions>();

		if (score_threshold) pb2_obj->set_score_threshold(*score_threshold);
		if (category_allowlist) pb2_obj->mutable_category_allowlist()->Add(category_allowlist->begin(), category_allowlist->end());
		if (category_denylist) pb2_obj->mutable_category_denylist()->Add(category_denylist->begin(), category_denylist->end());
		if (display_names_locale) pb2_obj->set_display_names_locale(*display_names_locale);
		if (max_results) pb2_obj->set_max_results(*max_results);

		return pb2_obj;
	}

	std::shared_ptr<ClassifierOptions> ClassifierOptions::create_from_pb2(const proto::ClassifierOptions& pb2_obj) {
		auto classifier_options = std::make_shared<ClassifierOptions>();
		classifier_options->score_threshold = pb2_obj.score_threshold();
		std::copy(pb2_obj.category_allowlist().begin(), pb2_obj.category_allowlist().end(), classifier_options->category_allowlist->begin());
		std::copy(pb2_obj.category_denylist().begin(), pb2_obj.category_denylist().end(), classifier_options->category_denylist->begin());
		classifier_options->display_names_locale = pb2_obj.display_names_locale();
		return classifier_options;
	}
}
