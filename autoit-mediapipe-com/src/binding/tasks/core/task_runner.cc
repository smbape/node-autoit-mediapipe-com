#include "mediapipe/framework/port/status_macros.h"
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
	absl::StatusOr<std::shared_ptr<TaskRunner>> create(const CalculatorGraphConfig& graph_config) {
		PacketsCallback packets_callback = nullptr;
		return create(graph_config, std::move(packets_callback));
	}

	absl::StatusOr<std::shared_ptr<TaskRunner>> create(const CalculatorGraphConfig& graph_config, PacketsCallback&& packets_callback) {
		mediapipe::tasks::core::PacketsCallback callback = nullptr;

		if (packets_callback) {
			callback = [packets_callback = std::move(packets_callback)](absl::StatusOr<PacketMap> output_packets) {
				absl::MutexLock lock(&callback_mutex);
				MP_THROW_IF_ERROR(output_packets.status()); // There is no other choice than throw in a callback to stop the execution
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
		MP_ASSIGN_OR_RETURN(auto task_runner, TaskRunner::Create(
			std::move(graph_config),
			absl::make_unique<MediaPipeBuiltinOpResolver>(),
			std::move(callback),
			/* default_executor= */ nullptr,
			/* input_side_packes= */ std::nullopt, std::move(*gpu_resources_)));
#else
		MP_ASSIGN_OR_RETURN(auto task_runner, TaskRunner::Create(
			std::move(graph_config),
			absl::make_unique<MediaPipeBuiltinOpResolver>(),
			std::move(callback)));
#endif  // !MEDIAPIPE_DISABLE_GPU

		return std::shared_ptr<TaskRunner>(task_runner.release());

	}
}
