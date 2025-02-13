#include "binding/tasks/text/core/base_text_task_api.h"

namespace mediapipe::tasks::autoit::text::core::base_text_task_api {
	BaseTextTaskApi::~BaseTextTaskApi() {
		auto status = close();
		if (!status.ok()) {
			AUTOIT_WARN(::mediapipe::autoit::StatusCodeToError(status.code()) << ": " << status.message().data());
		}
	}

	absl::StatusOr<std::shared_ptr<BaseTextTaskApi>> BaseTextTaskApi::create(
		const CalculatorGraphConfig& graph_config
	) {
		return create(graph_config, static_cast<BaseTextTaskApi*>(nullptr));
	}

	absl::Status BaseTextTaskApi::close() {
		return _runner->Close();
	}
}
