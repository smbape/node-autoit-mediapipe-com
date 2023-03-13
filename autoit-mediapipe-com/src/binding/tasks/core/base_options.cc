#include "binding/tasks/core/base_options.h"
#include <filesystem>

namespace fs = std::filesystem;
namespace {
	using mediapipe::tasks::core::proto::ExternalFile;
}

namespace mediapipe {
	namespace tasks {
		namespace autoit {
			namespace core {
				std::shared_ptr<mediapipe::tasks::core::proto::BaseOptions> BaseOptions::to_pb2() {
					const std::string& full_path = model_asset_path.empty() ? model_asset_path : fs::absolute(model_asset_path).string();
					auto options = std::make_shared<mediapipe::tasks::core::proto::BaseOptions>();
					options->mutable_model_asset()->set_file_name(full_path);
					options->mutable_model_asset()->set_file_content(model_asset_buffer);
					return options;
				}

				std::shared_ptr<BaseOptions> BaseOptions::create_from_pb2(const mediapipe::tasks::core::proto::BaseOptions& pb2_obj) {
					return std::make_shared<BaseOptions>(pb2_obj.model_asset().file_name(), pb2_obj.model_asset().file_content());
				}
			}
		}
	}
}
