#pragma once

#include "mediapipe/tasks/cc/components/processors/proto/classifier_options.pb.h"

namespace mediapipe {
	namespace tasks {
		namespace autoit {
			namespace components {
				namespace processors {
					namespace classifier_options {
						struct CV_EXPORTS_W_SIMPLE ClassifierOptions {
							CV_WRAP ClassifierOptions(const ClassifierOptions& other) = default;
							ClassifierOptions& operator=(const ClassifierOptions& other) = default;

							CV_WRAP ClassifierOptions(
								const std::optional<std::string>& display_names_locale = std::optional<std::string>(),
								std::optional<int> max_results = std::optional<int>(),
								std::optional<float> score_threshold = std::optional<float>(),
								const std::vector<std::string>& category_allowlist = std::vector<std::string>(),
								const std::vector<std::string>& category_denylist = std::vector<std::string>()
							)
								:
								display_names_locale(display_names_locale),
								max_results(max_results),
								score_threshold(score_threshold),
								category_allowlist(category_allowlist),
								category_denylist(category_denylist)
							{}

							CV_WRAP std::shared_ptr<mediapipe::tasks::components::processors::proto::ClassifierOptions> to_pb2();
							CV_WRAP static std::shared_ptr<ClassifierOptions> create_from_pb2(const mediapipe::tasks::components::processors::proto::ClassifierOptions& pb2_obj);

							CV_PROP_RW std::optional<std::string> display_names_locale;
							CV_PROP_RW std::optional<int> max_results;
							CV_PROP_RW std::optional<float> score_threshold;
							CV_PROP_RW std::vector<std::string> category_allowlist;
							CV_PROP_RW std::vector<std::string> category_denylist;
						};
					}
				}
			}
		}
	}
}