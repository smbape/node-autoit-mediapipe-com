#pragma once

#include "mediapipe/framework/calculator.pb.h"
#include "mediapipe/framework/formats/image.h"
#include "mediapipe/framework/port/status_macros.h"
#include "binding/tasks/vision/core/image_processing_options.h"
#include "binding/tasks/vision/core/vision_task_running_mode.h"
#include "binding/tasks/core/task_runner.h"
#include "binding/tasks/components/containers/rect.h"
#include <cmath>

namespace mediapipe::tasks::autoit::vision::core::base_vision_task_api {
	class CV_EXPORTS_W BaseVisionTaskApi {
	public:
		virtual ~BaseVisionTaskApi();

		template<typename _Tp>
		[[nodiscard]] inline static absl::StatusOr<std::shared_ptr<_Tp>> create(
			const CalculatorGraphConfig& graph_config,
			vision_task_running_mode::VisionTaskRunningMode running_mode,
			mediapipe::autoit::PacketsCallback&& packet_callback,
			_Tp*
		) {
			if (running_mode == vision_task_running_mode::VisionTaskRunningMode::LIVE_STREAM) {
				MP_ASSERT_RETURN_IF_ERROR(packet_callback, "The vision task is in live stream mode, a user-defined result "
					"callback must be provided.");
			}
			else {
				MP_ASSERT_RETURN_IF_ERROR(!packet_callback, "The vision task is in image or video mode, a user-defined result "
					"callback should not be provided.");
			}

			MP_ASSIGN_OR_RETURN(auto runner, mediapipe::autoit::task_runner::create(graph_config, std::move(packet_callback)));
			return std::make_shared<_Tp>(runner, running_mode);
		}

		BaseVisionTaskApi(
			const std::shared_ptr<mediapipe::tasks::core::TaskRunner>& runner,
			vision_task_running_mode::VisionTaskRunningMode running_mode
		) : _runner(runner), _running_mode(running_mode) {}

		CV_WRAP [[nodiscard]] static absl::StatusOr<std::shared_ptr<BaseVisionTaskApi>> create(
			const CalculatorGraphConfig& graph_config,
			vision_task_running_mode::VisionTaskRunningMode running_mode,
			mediapipe::autoit::PacketsCallback packet_callback = nullptr
		);
		CV_WRAP [[nodiscard]] absl::StatusOr<std::map<std::string, Packet>> _process_image_data(const std::map<std::string, Packet>& inputs);
		CV_WRAP [[nodiscard]] absl::StatusOr<std::map<std::string, Packet>> _process_video_data(const std::map<std::string, Packet>& inputs);
		CV_WRAP [[nodiscard]] absl::Status _send_live_stream_data(const std::map<std::string, Packet>& inputs);
		CV_WRAP [[nodiscard]] absl::StatusOr<components::containers::rect::NormalizedRect> convert_to_normalized_rect(
			std::shared_ptr<image_processing_options::ImageProcessingOptions> options,
			const mediapipe::Image& image,
			bool roi_allowed = true
		);
		CV_WRAP [[nodiscard]] absl::Status close();
		CV_WRAP std::shared_ptr<mediapipe::CalculatorGraphConfig> get_graph_config();
	protected:
		std::shared_ptr<mediapipe::tasks::core::TaskRunner> _runner;
		vision_task_running_mode::VisionTaskRunningMode _running_mode;
	};
}
