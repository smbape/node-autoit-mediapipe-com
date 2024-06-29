#include "binding/tasks/core/task_runner.h"

PTR_BRIDGE_IMPL(mediapipe::autoit::PacketsRawCallback);

namespace {
	using ::mediapipe::tasks::core::MediaPipeBuiltinOpResolver;
	using ::mediapipe::tasks::core::PacketMap;
	using ::mediapipe::tasks::core::TaskRunner;
}  // namespace

// A mutex to guard the callback function. Only one callback can
// run at once.
absl::Mutex callback_mutex;

namespace mediapipe::autoit::task_runner {
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

#if !MEDIAPIPE_DISABLE_GPU
		auto gpu_resources_ = mediapipe::GpuResources::Create();
		if (!gpu_resources_.ok()) {
		  ABSL_LOG(INFO) << "GPU suport is not available: "
						 << gpu_resources_.status();
		  gpu_resources_ = nullptr;
		}
		auto task_runner = TaskRunner::Create(
			std::move(graph_config),
			absl::make_unique<MediaPipeBuiltinOpResolver>(),
			std::move(callback),
			/* default_executor= */ nullptr,
			/* input_side_packes= */ std::nullopt, std::move(*gpu_resources_));
#else
		auto task_runner = TaskRunner::Create(
			std::move(graph_config),
			absl::make_unique<MediaPipeBuiltinOpResolver>(),
			std::move(callback));
#endif  // !MEDIAPIPE_DISABLE_GPU

		RaiseAutoItErrorIfNotOk(task_runner.status());

		return std::shared_ptr<TaskRunner>(task_runner.value().release());

	}
}
