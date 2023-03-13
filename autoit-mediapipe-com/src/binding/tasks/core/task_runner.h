#pragma once

#include "mediapipe/framework/calculator.pb.h"
#include "mediapipe/tasks/cc/core/mediapipe_builtin_op_resolver.h"
#include "mediapipe/tasks/cc/core/task_runner.h"
#include "tensorflow/lite/core/api/op_resolver.h"

namespace mediapipe {
	namespace autoit {
		using PacketsCallback = void (*)(const ::mediapipe::tasks::core::PacketMap&);
		namespace task_runner {
			std::shared_ptr<mediapipe::tasks::core::TaskRunner> create(const CalculatorGraphConfig& graph_config, PacketsCallback packets_callback = nullptr);
		}
	}
}

PTR_BRIDGE_DECL(mediapipe::autoit::PacketsCallback)
