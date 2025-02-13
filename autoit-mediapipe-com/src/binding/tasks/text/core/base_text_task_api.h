#pragma once

#include "mediapipe/framework/calculator.pb.h"
#include "mediapipe/framework/port/status_macros.h"
#include "binding/tasks/core/task_runner.h"
#include "absl/status/status.h"
#include "absl/status/statusor.h"
#include <opencv2/core/cvdef.h>

namespace mediapipe::tasks::autoit::text::core::base_text_task_api {
	class CV_EXPORTS_W BaseTextTaskApi {
	public:
		virtual ~BaseTextTaskApi();

		template<typename _Tp>
		[[nodiscard]] inline static absl::StatusOr<std::shared_ptr<_Tp>> create(
			const CalculatorGraphConfig& graph_config,
			_Tp*
		) {
			MP_ASSIGN_OR_RETURN(auto runner, mediapipe::autoit::task_runner::create(graph_config));
			return std::make_shared<_Tp>(runner);
		}

		BaseTextTaskApi(
			const std::shared_ptr<mediapipe::tasks::core::TaskRunner>& runner
		) : _runner(runner) {}

		CV_WRAP [[nodiscard]] static absl::StatusOr<std::shared_ptr<BaseTextTaskApi>> create(
			const CalculatorGraphConfig& graph_config
		);
		CV_WRAP [[nodiscard]] absl::Status close();
	protected:
		std::shared_ptr<mediapipe::tasks::core::TaskRunner> _runner;
	};
}
