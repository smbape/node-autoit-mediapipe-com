#include "binding/tasks/core/base_options.h"
#include <filesystem>

namespace fs = std::filesystem;
namespace {
	using mediapipe::tasks::core::proto::ExternalFile;
	using DelegateCase = mediapipe::tasks::core::proto::Acceleration::DelegateCase;
}

namespace mediapipe::tasks::autoit::core::base_options {
	absl::StatusOr<std::shared_ptr<mediapipe::tasks::core::proto::BaseOptions>> BaseOptions::to_pb2() const {
		const std::string& full_path = model_asset_path.empty() ? model_asset_path : fs::absolute(model_asset_path).string();

		auto options = std::make_shared<mediapipe::tasks::core::proto::BaseOptions>();

		options->mutable_model_asset()->set_file_name(full_path);
		options->mutable_model_asset()->set_file_content(model_asset_buffer);

		if (delegate) {
			if (*delegate == BaseOptions_Delegate::GPU) {
#ifdef _MSC_VER
				MP_ASSERT_RETURN_IF_ERROR(false, "GPU BaseOptions_Delegate is not yet supported for Windows");
#else
				options->mutable_acceleration()->mutable_gpu();
#endif
			}
			else if (*delegate == BaseOptions_Delegate::CPU) {
				options->mutable_acceleration()->mutable_tflite();
			}
		}

		return options;
	}

	std::shared_ptr<BaseOptions> BaseOptions::create_from_pb2(const mediapipe::tasks::core::proto::BaseOptions& pb2_obj) {
		std::optional<BaseOptions_Delegate> delegate;
		if (pb2_obj.has_acceleration() && pb2_obj.acceleration().delegate_case() != DelegateCase::DELEGATE_NOT_SET) {
			if (pb2_obj.acceleration().has_gpu()) {
				delegate = BaseOptions_Delegate::GPU;
			}
			else {
				delegate = BaseOptions_Delegate::CPU;
			}
		}

		return std::make_shared<BaseOptions>(
			pb2_obj.model_asset().file_name(),
			pb2_obj.model_asset().file_content(),
			delegate
		);
	}
}
