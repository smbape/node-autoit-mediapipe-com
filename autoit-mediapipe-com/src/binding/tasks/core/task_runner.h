#pragma once

#include "absl/log/absl_log.h"
#include "mediapipe/framework/calculator.pb.h"
#include "mediapipe/tasks/cc/core/mediapipe_builtin_op_resolver.h"
#include "mediapipe/tasks/cc/core/task_runner.h"
#include "tensorflow/lite/core/api/op_resolver.h"
#if !MEDIAPIPE_DISABLE_GPU
#include "mediapipe/gpu/gpu_shared_data_internal.h"
#endif  // MEDIAPIPE_DISABLE_GPU
#include <functional>

namespace mediapipe::autoit {
	using PacketsRawCallback = void(*)(const ::mediapipe::tasks::core::PacketMap&);
	using PacketsCallback = std::function<void(const ::mediapipe::tasks::core::PacketMap&)>;
	namespace task_runner {
		[[nodiscard]] absl::StatusOr<std::shared_ptr<mediapipe::tasks::core::TaskRunner>> create(const CalculatorGraphConfig& graph_config);
		[[nodiscard]] absl::StatusOr<std::shared_ptr<mediapipe::tasks::core::TaskRunner>> create(const CalculatorGraphConfig& graph_config, PacketsCallback&& packets_callback);
	}
}

PTR_BRIDGE_DECL(mediapipe::autoit::PacketsRawCallback)
