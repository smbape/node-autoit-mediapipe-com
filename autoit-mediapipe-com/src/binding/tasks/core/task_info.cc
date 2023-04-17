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
	std::shared_ptr<CalculatorGraphConfig> TaskInfo::generate_graph_config(bool enable_flow_limiting) {
		AUTOIT_ASSERT_THROW(!task_graph.empty() && task_options, "Please provide both `task_graph` and `task_options`.");
		AUTOIT_ASSERT_THROW(!input_streams.empty() && !output_streams.empty(), "Both `input_streams` and `output_streams` must be non-empty.");

		CalculatorOptions task_subgraph_options;
		const auto* ext = task_options->GetDescriptor()->FindExtensionByName("ext");
		auto* message = task_subgraph_options.GetReflection()->MutableMessage(&task_subgraph_options, ext);
		message->CopyFrom(*task_options);

		auto config = std::make_shared<CalculatorGraphConfig>();

		auto* node = config->add_node();
		node->set_calculator(task_graph);
		node->mutable_output_stream()->Add(output_streams.begin(), output_streams.end());
		node->mutable_options()->CopyFrom(task_subgraph_options);

		config->mutable_input_stream()->Add(input_streams.begin(), input_streams.end());
		config->mutable_output_stream()->Add(output_streams.begin(), output_streams.end());

		if (!enable_flow_limiting) {
			node->mutable_input_stream()->Add(input_streams.begin(), input_streams.end());
			return config;
		}

		auto* flow_limiter = config->add_node();

		flow_limiter->set_calculator("FlowLimiterCalculator");

		auto* input_stream_info = flow_limiter->add_input_stream_info();
		input_stream_info->set_tag_index("FINISHED");
		input_stream_info->set_back_edge(true);

		auto finished_stream = "FINISHED:" + strip_tag_index(output_streams[0]);
		for (const auto& stream : input_streams) {
			flow_limiter->add_input_stream(strip_tag_index(stream));
		}
		flow_limiter->add_input_stream(finished_stream);

		for (auto stream : input_streams) {
			stream = add_stream_name_prefix(stream);

			node->add_input_stream(stream);
			flow_limiter->add_output_stream(strip_tag_index(stream));
		}

		flow_limiter->mutable_options()->MutableExtension(FlowLimiterCalculatorOptions::ext)->set_max_in_flight(1);
		flow_limiter->mutable_options()->MutableExtension(FlowLimiterCalculatorOptions::ext)->set_max_in_queue(1);

		return config;
	}
}
