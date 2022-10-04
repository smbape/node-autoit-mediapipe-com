#pragma once

#include "absl/memory/memory.h"
#include "mediapipe/framework/calculator.pb.h"
#include "mediapipe/framework/calculator_graph.h"
#include "mediapipe/framework/packet.h"
#include "mediapipe/framework/port/map_util.h"
#include "mediapipe/framework/port/parse_text_proto.h"
#include "mediapipe/framework/port/status.h"
#include "mediapipe/framework/tool/calculator_graph_template.pb.h"
#include "mediapipe/framework/formats/detection.pb.h"
#include "binding/util.h"

namespace mediapipe {
	namespace autoit {
		typedef void (*StreamPacketCallback)(const std::string& stream_name, const Packet& packet);
	}
}

PTR_BRIDGE_DECL(mediapipe::autoit::StreamPacketCallback)
