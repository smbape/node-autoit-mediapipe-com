#include "binding/tasks/components/containers/classification_result.h"

using namespace mediapipe::tasks::components::containers;

namespace mediapipe {
	namespace tasks {
		namespace autoit {
			namespace components {
				namespace containers {
					namespace classification_result {
						std::shared_ptr<proto::Classifications> Classifications::to_pb2() {
							auto pb2_obj = std::make_shared<proto::Classifications>();

							auto* classification_list = pb2_obj->mutable_classification_list();
							for (const auto& category : categories) {
								classification_list->add_classification()->CopyFrom(*category->to_pb2());
							}

							pb2_obj->set_head_index(head_index);
							pb2_obj->set_head_name(head_name);

							return pb2_obj;
						}

						std::shared_ptr<Classifications> Classifications::create_from_pb2(const proto::Classifications& pb2_obj) {
							std::vector<std::shared_ptr<category::Category>> categories;
							for (const auto& classification : pb2_obj.classification_list().classification()) {
								categories.push_back(category::Category::create_from_pb2(classification));
							}

							return std::make_shared<Classifications>(
								categories,
								pb2_obj.head_index(),
								pb2_obj.head_name()
								);
						}

						std::shared_ptr<proto::ClassificationResult> ClassificationResult::to_pb2() {
							auto pb2_obj = std::make_shared<proto::ClassificationResult>();

							for (const auto& classification : classifications) {
								pb2_obj->add_classifications()->CopyFrom(*classification->to_pb2());
							}

							pb2_obj->set_timestamp_ms(timestamp_ms);

							return pb2_obj;
						}

						std::shared_ptr<ClassificationResult> ClassificationResult::create_from_pb2(const proto::ClassificationResult& pb2_obj) {
							auto classification_result = std::make_shared<ClassificationResult>();
							for (const auto& classification : pb2_obj.classifications()) {
								classification_result->classifications.push_back(Classifications::create_from_pb2(classification));
							}
							classification_result->timestamp_ms = pb2_obj.timestamp_ms();
							return classification_result;
						}
					}
				}
			}
		}
	}
}
