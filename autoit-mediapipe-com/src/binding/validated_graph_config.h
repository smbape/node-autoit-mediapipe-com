#pragma once

#include "mediapipe/framework/port/parse_text_proto.h"
#include "mediapipe/framework/validated_graph_config.h"
#include "binding/util.h"

namespace mediapipe::autoit::validated_graph_config {
    [[nodiscard]] absl::Status Initialize(ValidatedGraphConfig& self, const std::string& graph_config);
}
