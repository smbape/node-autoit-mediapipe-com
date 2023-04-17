#pragma once

#include "mediapipe/framework/calculator.pb.h"
#include "binding/tasks/vision/core/image_processing_options.h"
#include "binding/tasks/vision/core/vision_task_running_mode.h"
#include "binding/tasks/core/task_runner.h"
#include "binding/tasks/components/containers/rect.h"

namespace mediapipe::tasks::autoit::vision::core::base_vision_task_api {
	class CV_EXPORTS_W BaseVisionTaskApi {
	public:
		CV_WRAP BaseVisionTaskApi(
			const CalculatorGraphConfig& graph_config,
			vision_task_running_mode::VisionTaskRunningMode running_mode,
			mediapipe::autoit::PacketsCallback packet_callback = nullptr
		);

		CV_WRAP std::map<std::string, Packet> _process_image_data(const std::map<std::string, Packet>& inputs);
		CV_WRAP std::map<std::string, Packet> _process_video_data(const std::map<std::string, Packet>& inputs);
		CV_WRAP void _send_live_stream_data(const std::map<std::string, Packet>& inputs);
		CV_WRAP components::containers::rect::NormalizedRect convert_to_normalized_rect(std::shared_ptr<image_processing_options::ImageProcessingOptions> options, bool roi_allowed = true);
		CV_WRAP void close();
	protected:
		std::shared_ptr<mediapipe::tasks::core::TaskRunner> _runner;
		vision_task_running_mode::VisionTaskRunningMode _running_mode;
	};
}
