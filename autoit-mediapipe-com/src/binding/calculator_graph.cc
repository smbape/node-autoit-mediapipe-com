#include "Mediapipe_CalculatorGraph_Object.h"

PTR_BRIDGE_IMPL(mediapipe::autoit::PacketCallback)

using namespace mediapipe;
using namespace mediapipe::autoit;

// A mutex to guard the output stream observer autoit callback function.
// Only one autoit callback can run at once.
static absl::Mutex callback_mutex;

namespace mediapipe {
	namespace autoit {
		namespace calculator_graph {
			std::shared_ptr<CalculatorGraph> create(CalculatorGraphConfig& graph_config) {
				auto calculator_graph = std::make_shared<CalculatorGraph>();
				RaiseAutoItErrorIfNotOk(calculator_graph->Initialize(graph_config));
				return calculator_graph;
			}

			std::shared_ptr<CalculatorGraph> create(ValidatedGraphConfig& validated_graph_config) {
				auto graph_config = validated_graph_config.Config();
				return create(graph_config);
			}

			std::shared_ptr<CalculatorGraph> create(const std::string& binary_graph_path, const std::string& graph_config_proto) {
				CalculatorGraphConfig graph_config;
				const auto& use_binary_path = !binary_graph_path.empty();
				const auto& use_graph_config = !graph_config_proto.empty();

				AUTOIT_ASSERT_THROW(use_binary_path && !use_graph_config || !use_binary_path && use_graph_config,
					"Please provide one of the following: "
					"\'binary_graph_path\' to initialize the graph "
					"with a binary graph file, or "
					"\'graph_config\' to initialize the graph with a "
					"graph config proto, or "
					"\'validated_graph_config\' to initialize the "
					"graph with a ValidatedGraphConfig object.");

				if (use_binary_path) {
					graph_config = ReadCalculatorGraphConfigFromFile(binary_graph_path);
				}
				else if (use_graph_config) {
					graph_config = ParseProto<CalculatorGraphConfig>(graph_config_proto);
				}

				return create(graph_config);
			}

			void add_packet_to_input_stream(CalculatorGraph* self, const std::string& stream, Packet& packet, Timestamp& timestamp) {
				auto packet_timestamp = timestamp == Timestamp::Unset() ? packet.Timestamp() : timestamp;
				AUTOIT_ASSERT_THROW(packet_timestamp.IsAllowedInStream(), packet_timestamp.DebugString() << " can't be the timestamp of a Packet in a stream.");
				RaiseAutoItErrorIfNotOk(self->AddPacketToInputStream(stream, packet.At(packet_timestamp)));
			}

			const std::string get_combined_error_message(CalculatorGraph* self) {
				absl::Status error_status;
				if (self->GetCombinedErrors(&error_status) && !error_status.ok()) {
					return error_status.ToString();
				}
				return std::string();
			}

			void observe_output_stream(
				CalculatorGraph* self,
				const std::string& stream_name,
				PacketCallback callback_fn,
				bool observe_timestamp_bounds
			) {
				RaiseAutoItErrorIfNotOk(self->ObserveOutputStream(
					stream_name,
					[callback_fn, stream_name](const Packet& packet) {
						absl::MutexLock lock(&callback_mutex);
						callback_fn(stream_name, packet);
						return absl::OkStatus();
					},
					observe_timestamp_bounds
				));
			}

			void close(CalculatorGraph* self) {
				RaiseAutoItErrorIfNotOk(self->CloseAllPacketSources());
				RaiseAutoItErrorIfNotOk(self->WaitUntilDone());
			}
		}
	}
}
