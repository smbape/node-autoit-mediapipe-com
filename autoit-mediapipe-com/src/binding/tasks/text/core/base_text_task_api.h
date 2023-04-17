#pragma once

#include "mediapipe/framework/calculator.pb.h"
#include "binding/tasks/core/task_runner.h"

namespace mediapipe::tasks::autoit::text::core::base_text_task_api {
	class CV_EXPORTS_W BaseTextTaskApi {
	public:
		CV_WRAP BaseTextTaskApi(
			const CalculatorGraphConfig& graph_config
		);

		CV_WRAP void close();
	protected:
		std::shared_ptr<mediapipe::tasks::core::TaskRunner> _runner;
	};
}
