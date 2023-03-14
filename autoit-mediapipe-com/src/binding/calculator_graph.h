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
#include <functional>

namespace mediapipe {
	namespace autoit {
		using PacketRawCallback = void(*)(const std::string&, const Packet&);
		using PacketCallback = std::function<void(const std::string&, const Packet&)>;

		namespace calculator_graph {
			std::shared_ptr<CalculatorGraph> create(CalculatorGraphConfig& graph_config);
			std::shared_ptr<CalculatorGraph> create(ValidatedGraphConfig& validated_graph_config);
			std::shared_ptr<CalculatorGraph> create(const std::string& binary_graph_path, const std::string& graph_config_proto);
			void add_packet_to_input_stream(CalculatorGraph* self, const std::string& stream, Packet& packet, Timestamp& timestamp);
			const std::string get_combined_error_message(CalculatorGraph* self);
			void observe_output_stream(
				CalculatorGraph* self,
				const std::string& stream_name,
				PacketCallback callback_fn,
				bool observe_timestamp_bounds
			);
			void close(CalculatorGraph* self);
		}
	}
}

PTR_BRIDGE_DECL(mediapipe::autoit::PacketRawCallback);
