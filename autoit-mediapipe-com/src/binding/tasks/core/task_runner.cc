#include "binding/tasks/core/task_runner.h"

namespace {
	using ::mediapipe::tasks::core::MediaPipeBuiltinOpResolver;
	using ::mediapipe::tasks::core::PacketMap;
	using ::mediapipe::tasks::core::TaskRunner;
}  // namespace

// A mutex to guard the callback function. Only one callback can
// run at once.
absl::Mutex callback_mutex;

namespace mediapipe {
	namespace autoit {
		namespace task_runner {
			std::shared_ptr<TaskRunner> create(const CalculatorGraphConfig& graph_config, PacketsCallback packets_callback) {
				mediapipe::tasks::core::PacketsCallback callback = nullptr;

				if (packets_callback) {
					callback = [packets_callback](absl::StatusOr<PacketMap> output_packets) {
						absl::MutexLock lock(&callback_mutex);
						RaiseAutoItErrorIfNotOk(output_packets.status());
						packets_callback(output_packets.value());
						return absl::OkStatus();
					};
				}

				auto task_runner = TaskRunner::Create(
					std::move(graph_config),
					absl::make_unique<MediaPipeBuiltinOpResolver>(),
					std::move(callback));
				RaiseAutoItErrorIfNotOk(task_runner.status());

				return std::shared_ptr<TaskRunner>(task_runner.value().release());

			}
		}
	}
}

PTR_BRIDGE_IMPL(mediapipe::autoit::PacketsCallback)
