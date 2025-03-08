#include "binding/validated_graph_config.h"

namespace mediapipe::autoit::validated_graph_config {
	[[nodiscard]] absl::Status Initialize(ValidatedGraphConfig& self, const std::string& graph_config_proto) {
		CalculatorGraphConfig graph_config;
		MP_RETURN_IF_ERROR(ParseProto<CalculatorGraphConfig>(graph_config_proto, graph_config));
		return self.Initialize(graph_config);
	}
}
