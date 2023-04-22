#pragma once

#include "binding/calculator_graph.h"
#include "binding/validated_graph_config.h"

namespace mediapipe::autoit::solution_base {
	#pragma push_macro("BOOL")
	#pragma push_macro("INT")
	#pragma push_macro("FLOAT")
	#ifdef BOOL
	#undef BOOL
	#endif
	#ifdef INT
	#undef INT
	#endif
	#ifdef FLOAT
	#undef FLOAT
	#endif

	enum class PacketDataType {
		STRING,
		BOOL,
		BOOL_LIST,
		INT,
		INT_LIST,
		FLOAT,
		FLOAT_LIST,
		AUDIO,
		IMAGE,
		IMAGE_LIST,
		IMAGE_FRAME,
		PROTO,
		PROTO_LIST
	};

	static const char* PacketDataTypeToChar[] =
	{
		"STRING",
		"BOOL",
		"BOOL_LIST",
		"INT",
		"INT_LIST",
		"FLOAT",
		"FLOAT_LIST",
		"AUDIO",
		"IMAGE",
		"IMAGE_LIST",
		"IMAGE_FRAME",
		"PROTO",
		"PROTO_LIST"
	};

	#pragma pop_macro("FLOAT")
	#pragma pop_macro("INT")
	#pragma pop_macro("BOOL")

	const std::map<std::string, _variant_t>& noMap();
	const std::map<std::string, PacketDataType>& noTypeMap();
	const std::vector<std::string>& noVector();

	class CV_EXPORTS_W SolutionBase {
	public:
		SolutionBase() = default;

		CV_WRAP SolutionBase(
			const CalculatorGraphConfig& graph_config,
			const std::map<std::string, _variant_t>& calculator_params = noMap(),
			const std::shared_ptr<google::protobuf::Message>& graph_options = std::shared_ptr<google::protobuf::Message>(),
			const std::map<std::string, _variant_t>& side_inputs = noMap(),
			const std::vector<std::string>& outputs = noVector(),
			const std::map<std::string, PacketDataType>& stream_type_hints = noTypeMap()
		);

		void __init__(
			const CalculatorGraphConfig& graph_config,
			const std::map<std::string, _variant_t>& calculator_params = noMap(),
			const std::shared_ptr<google::protobuf::Message>& graph_options = std::shared_ptr<google::protobuf::Message>(),
			const std::map<std::string, _variant_t>& side_inputs = noMap(),
			const std::vector<std::string>& outputs = noVector(),
			const std::map<std::string, PacketDataType>& stream_type_hints = noTypeMap()
		);

		CV_WRAP SolutionBase(
			const std::string& binary_graph_path,
			const std::map<std::string, _variant_t>& calculator_params = noMap(),
			const std::shared_ptr<google::protobuf::Message>& graph_options = std::shared_ptr<google::protobuf::Message>(),
			const std::map<std::string, _variant_t>& side_inputs = noMap(),
			const std::vector<std::string>& outputs = noVector(),
			const std::map<std::string, PacketDataType>& stream_type_hints = noTypeMap()
		);

		void __init__(
			const std::string& binary_graph_path,
			const std::map<std::string, _variant_t>& calculator_params = noMap(),
			const std::shared_ptr<google::protobuf::Message>& graph_options = std::shared_ptr<google::protobuf::Message>(),
			const std::map<std::string, _variant_t>& side_inputs = noMap(),
			const std::vector<std::string>& outputs = noVector(),
			const std::map<std::string, PacketDataType>& stream_type_hints = noTypeMap()
		);

		CV_WRAP void process(const cv::Mat& input_data, CV_OUT std::map<std::string, _variant_t>& solution_outputs);
		CV_WRAP void process(const std::map<std::string, _variant_t>& input_data, CV_OUT std::map<std::string, _variant_t>& solution_outputs);

		/**
		 * Closes all the input sources and the graph.
		 */
		CV_WRAP void close();

		/**
		 * Resets the graph for another run.
		 */
		CV_WRAP void reset();

		/**
		 * Sets protobuf field values.
		 *
		 *  Args:
		 *    options_message: the options protobuf message.
		 *    values: field value pairs, where each field may be a "." separated path.
		 *
		 *  Returns:
		 *    the options protobuf message.
		 */
		CV_WRAP static std::shared_ptr<google::protobuf::Message> create_graph_options(
			std::shared_ptr<google::protobuf::Message> options_message,
			const std::map<std::string, _variant_t>& values
		);

		virtual ~SolutionBase() = default;

	private:
		// since I don't know the copy behaviour
		// disable it
		SolutionBase(const SolutionBase&) = delete;
		SolutionBase& operator=(const SolutionBase&) = delete;

		/**
		 * Gets graph interface type information and returns the canonical graph config proto.
		 * @param  graph_config      [description]
		 * @param  side_inputs       [description]
		 * @param  outputs           [description]
		 * @param  stream_type_hints [description]
		 * @return                   [description]
		 */
		CalculatorGraphConfig InitializeGraphInterface(
			const CalculatorGraphConfig& graph_config,
			const std::map<std::string, _variant_t>& side_inputs,
			const std::vector<std::string>& outputs,
			const std::map<std::string, PacketDataType>& stream_type_hints
		);

		std::map<std::string, PacketDataType> m_input_stream_type_info;
		std::map<std::string, PacketDataType> m_output_stream_type_info;
		std::map<std::string, PacketDataType> m_side_input_type_info;

		std::unique_ptr<CalculatorGraph> m_graph;
		int64_t m_simulated_timestamp = 0;
		std::map<std::string, Packet> m_graph_outputs;
		std::map<std::string, Packet> m_input_side_packets;
	};
}
