#include "Mediapipe_CalculatorGraph_Object.h"

PTR_BRIDGE_IMPL(mediapipe::autoit::StreamPacketCallback)

using namespace mediapipe;
using namespace mediapipe::autoit;

// A mutex to guard the output stream observer python callback function.
// Only one python callback can run at once.
absl::Mutex callback_mutex;

const std::shared_ptr<CalculatorGraph> CMediapipe_CalculatorGraph_Object::create(CalculatorGraphConfig& graph_config, HRESULT& hr) {
	auto calculator_graph = std::make_shared<CalculatorGraph>();
	RaiseAutoItErrorIfNotOk(calculator_graph->Initialize(graph_config));
	hr = S_OK;
	return calculator_graph;
}

const std::shared_ptr<CalculatorGraph> CMediapipe_CalculatorGraph_Object::create(ValidatedGraphConfig& validated_graph_config, HRESULT& hr) {
	auto graph_config = validated_graph_config.Config();
	return create(graph_config, hr);
}

const std::shared_ptr<CalculatorGraph> CMediapipe_CalculatorGraph_Object::create(std::string& binary_graph_path, std::string& graph_config_proto, HRESULT& hr) {
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
	} else if (use_graph_config) {
		graph_config = ParseProto<CalculatorGraphConfig>(graph_config_proto);
	}

	return create(graph_config, hr);
}

void CMediapipe_CalculatorGraph_Object::add_packet_to_input_stream(std::string& stream, Packet& packet, Timestamp& timestamp, HRESULT& hr) {
	auto packet_timestamp = timestamp == Timestamp::Unset() ? packet.Timestamp() : timestamp;
	AUTOIT_ASSERT_THROW(packet_timestamp.IsAllowedInStream(), packet_timestamp.DebugString() << " can't be the timestamp of a Packet in a stream.");

	const auto& self = this->__self->get();
	RaiseAutoItErrorIfNotOk(self->AddPacketToInputStream(stream, packet.At(packet_timestamp)));
	hr = S_OK;
}

const std::string CMediapipe_CalculatorGraph_Object::get_combined_error_message(HRESULT& hr) {
	const auto& self = this->__self->get();

	absl::Status error_status;
	if (self->GetCombinedErrors(&error_status) && !error_status.ok()) {
		return error_status.ToString();
	}

	hr = S_OK;
	return std::string();
}

void CMediapipe_CalculatorGraph_Object::observe_output_stream(std::string& stream_name, StreamPacketCallback callback_fn, bool observe_timestamp_bounds, HRESULT& hr) {
	const auto& self = this->__self->get();

	RaiseAutoItErrorIfNotOk(self->ObserveOutputStream(
		stream_name,
		[callback_fn, stream_name](const Packet& packet) {
			absl::MutexLock lock(&callback_mutex);
			callback_fn(stream_name, packet);
			return absl::OkStatus();
		},
		observe_timestamp_bounds
	));

	hr = S_OK;
}
