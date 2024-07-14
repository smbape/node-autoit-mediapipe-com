#include "binding/tasks/core/task_info.h"

namespace {
	inline std::string strip_tag_index(const std::string& tag_index_name) {
		auto pos = tag_index_name.find_last_of(':');
		return tag_index_name.substr(pos + 1);
	}

	inline std::string add_stream_name_prefix(const std::string& tag_index_name) {
		auto pos = tag_index_name.find_last_of(':');
		return tag_index_name.substr(0, pos + 1) + "throttled_" + tag_index_name.substr(pos + 1);
	}
}

namespace mediapipe::tasks::autoit::core::task_info {
	absl::StatusOr<std::shared_ptr<CalculatorGraphConfig>> TaskInfo::generate_graph_config(bool enable_flow_limiting) {
		MP_ASSERT_RETURN_IF_ERROR(!task_graph.empty() && task_options, "Please provide both `task_graph` and `task_options`.");
		MP_ASSERT_RETURN_IF_ERROR(
			static_cast<bool>(input_streams) && !input_streams->empty() &&
			static_cast<bool>(output_streams) && !output_streams->empty(),
			"Both `input_streams` and `output_streams` must be non-empty.");

		auto graph_config = std::make_shared<CalculatorGraphConfig>();

		auto* node_config = graph_config->add_node();
		node_config->set_calculator(task_graph);
		node_config->mutable_input_stream()->Add(input_streams->begin(), input_streams->end());
		node_config->mutable_output_stream()->Add(output_streams->begin(), output_streams->end());

		const auto* ext = task_options->GetDescriptor()->FindExtensionByName("ext");
		if (ext) {
			// Use the extension mechanism for task_subgraph_options (proto2)
			CalculatorOptions task_subgraph_options;
			auto* message = task_subgraph_options.GetReflection()->MutableMessage(&task_subgraph_options, ext);
			message->CopyFrom(*task_options);
			node_config->mutable_options()->CopyFrom(task_subgraph_options);
		}
		else {
			// Use the Any type for task_subgraph_options (proto3)
			google::protobuf::Any task_subgraph_options;
			node_config->add_node_options()->PackFrom(*task_options);
		}

		graph_config->mutable_input_stream()->Add(input_streams->begin(), input_streams->end());
		graph_config->mutable_output_stream()->Add(output_streams->begin(), output_streams->end());

		if (!enable_flow_limiting) {
			return graph_config;
		}

		// When a FlowLimiterCalculator is inserted to lower the overall graph
		// latency, the task doesn't guarantee that each input must have the
		// corresponding output.
		auto* flow_limiter = graph_config->add_node();

		for (const auto& stream : *input_streams) {
			flow_limiter->add_input_stream(strip_tag_index(stream));
			flow_limiter->add_output_stream(strip_tag_index(add_stream_name_prefix(stream)));
		}

		flow_limiter->set_calculator("FlowLimiterCalculator");

		auto* input_stream_info = flow_limiter->add_input_stream_info();
		input_stream_info->set_tag_index("FINISHED");
		input_stream_info->set_back_edge(true);

		auto finished_stream = "FINISHED:" + strip_tag_index(output_streams->at(0));
		flow_limiter->add_input_stream(finished_stream);

		flow_limiter->mutable_options()->MutableExtension(FlowLimiterCalculatorOptions::ext)->set_max_in_flight(1);
		flow_limiter->mutable_options()->MutableExtension(FlowLimiterCalculatorOptions::ext)->set_max_in_queue(1);

		return graph_config;
	}
}
