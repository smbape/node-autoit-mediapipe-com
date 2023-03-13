#pragma once

#include "mediapipe/framework/formats/classification.pb.h"
#include "mediapipe/tasks/cc/components/containers/proto/classifications.pb.h"
#include "binding/tasks/components/containers/category.h"

namespace mediapipe {
	namespace tasks {
		namespace autoit {
			namespace components {
				namespace containers {
					namespace classification_result {
						struct CV_EXPORTS_W_SIMPLE Classifications {
							CV_WRAP Classifications(const Classifications& other) = default;
							Classifications& operator=(const Classifications& other) = default;

							CV_WRAP Classifications(
								const std::vector<std::shared_ptr<category::Category>>& categories = std::vector<std::shared_ptr<category::Category>>(),
								int head_index = -1,
								std::string head_name = std::string()
							)
								:
								categories(categories),
								head_index(head_index),
								head_name(head_name)
							{}

							CV_WRAP std::shared_ptr<mediapipe::tasks::components::containers::proto::Classifications> to_pb2();
							CV_WRAP static std::shared_ptr<Classifications> create_from_pb2(const mediapipe::tasks::components::containers::proto::Classifications& pb2_obj);

							CV_PROP_RW std::vector<std::shared_ptr<category::Category>> categories;
							CV_PROP_RW int head_index;
							CV_PROP_RW std::string head_name;
						};

						struct CV_EXPORTS_W_SIMPLE ClassificationResult {
							CV_WRAP ClassificationResult(const ClassificationResult& other) = default;
							ClassificationResult& operator=(const ClassificationResult& other) = default;

							CV_WRAP ClassificationResult(
								const std::vector<std::shared_ptr<Classifications>>& classifications = std::vector<std::shared_ptr<Classifications>>(),
								int64_t timestamp_ms = 0
							)
								:
								classifications(classifications),
								timestamp_ms(timestamp_ms)
							{}

							CV_WRAP std::shared_ptr<mediapipe::tasks::components::containers::proto::ClassificationResult> to_pb2();
							CV_WRAP static std::shared_ptr<ClassificationResult> create_from_pb2(const mediapipe::tasks::components::containers::proto::ClassificationResult& pb2_obj);

							CV_PROP_RW std::vector<std::shared_ptr<Classifications>> classifications;
							CV_PROP_RW int64_t timestamp_ms;
						};
					}
				}
			}
		}
	}
}
