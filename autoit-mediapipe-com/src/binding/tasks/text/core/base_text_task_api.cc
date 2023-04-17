#include "binding/tasks/text/core/base_text_task_api.h"

namespace mediapipe::tasks::autoit::text::core::base_text_task_api {
	BaseTextTaskApi::BaseTextTaskApi(const CalculatorGraphConfig& graph_config) {
		_runner = mediapipe::autoit::task_runner::create(graph_config);
	}

	void BaseTextTaskApi::close() {
		_runner->Close();
	}
}
