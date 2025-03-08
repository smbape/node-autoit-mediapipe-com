#pragma once

#include "mediapipe/tasks/cc/core/proto/base_options.pb.h"
#include "mediapipe/tasks/cc/core/proto/external_file.pb.h"
#include "google/protobuf/any.pb.h"
#include "mediapipe/calculators/core/flow_limiter_calculator.pb.h"
#include "mediapipe/framework/calculator_options.pb.h"
#include "mediapipe/framework/calculator.pb.h"
#include "binding/tasks/core/base_options.h"

namespace mediapipe::tasks::autoit::core::task_info {
	struct CV_EXPORTS_W_SIMPLE TaskInfo {
		CV_WRAP TaskInfo(const TaskInfo& other) = default;
		TaskInfo& operator=(const TaskInfo& other) = default;

		CV_WRAP TaskInfo(
			const std::string& task_graph = "",
			const std::shared_ptr<std::vector<std::string>>& input_streams = std::make_shared<std::vector<std::string>>(),
			const std::shared_ptr<std::vector<std::string>>& output_streams = std::make_shared<std::vector<std::string>>(),
			const std::shared_ptr<google::protobuf::Message>& task_options = std::shared_ptr<google::protobuf::Message>()
		) :
			task_graph(task_graph),
			input_streams(input_streams),
			output_streams(output_streams),
			task_options(task_options)
		{}

		CV_WRAP [[nodiscard]] absl::StatusOr<std::shared_ptr<mediapipe::CalculatorGraphConfig>> generate_graph_config(bool enable_flow_limiting = true);

		CV_PROP_RW std::string task_graph;
		CV_PROP_RW std::shared_ptr<std::vector<std::string>> input_streams;
		CV_PROP_RW std::shared_ptr<std::vector<std::string>> output_streams;
		CV_PROP_RW std::shared_ptr<google::protobuf::Message> task_options;
	};
}
