#pragma once

#include <opencv2/core/cvdef.h>

#include "mediapipe/framework/calculator.pb.h"
#include "mediapipe/framework/port/status_macros.h"
#include "binding/packet.h"
#include "binding/tasks/audio/core/audio_task_running_mode.h"
#include "binding/tasks/core/task_runner.h"
#include "binding/timestamp.h"

namespace mediapipe::tasks::autoit::audio::core::base_audio_task_api {
	class CV_EXPORTS_W BaseAudioTaskApi {
	public:
		virtual ~BaseAudioTaskApi();

		template<typename _Tp>
		[[nodiscard]] inline static absl::StatusOr<std::shared_ptr<_Tp>> create(
			const CalculatorGraphConfig& graph_config,
			audio_task_running_mode::AudioTaskRunningMode running_mode,
			mediapipe::autoit::PacketsCallback packet_callback,
			_Tp*
		) {
			if (running_mode == audio_task_running_mode::AudioTaskRunningMode::AUDIO_STREAM) {
				MP_ASSERT_RETURN_IF_ERROR(packet_callback, "The audio task is in audio stream mode, a user-defined result "
					"callback must be provided.");
			}
			else {
				MP_ASSERT_RETURN_IF_ERROR(!packet_callback, "The audio task is in audio clips mode, a user-defined result "
					"callback should not be provided.");
			}

			MP_ASSIGN_OR_RETURN(auto runner, mediapipe::autoit::task_runner::create(graph_config, std::move(packet_callback)));
			return std::make_shared<_Tp>(runner, running_mode);
		}

		BaseAudioTaskApi(
			const std::shared_ptr<mediapipe::tasks::core::TaskRunner>& runner,
			audio_task_running_mode::AudioTaskRunningMode running_mode
		) : _runner(runner), _running_mode(running_mode) {}

		CV_WRAP [[nodiscard]] static absl::StatusOr<std::shared_ptr<BaseAudioTaskApi>> create(
			const CalculatorGraphConfig& graph_config,
			audio_task_running_mode::AudioTaskRunningMode running_mode,
			mediapipe::autoit::PacketsCallback packet_callback = nullptr
		);
		CV_WRAP [[nodiscard]] absl::StatusOr<std::map<std::string, Packet>> _process_audio_clip(const std::map<std::string, Packet>& inputs);
		CV_WRAP [[nodiscard]] absl::Status _set_sample_rate(const std::string& sample_rate_stream_name, float sample_rate);
		CV_WRAP [[nodiscard]] absl::Status _send_audio_stream_data(const std::map<std::string, Packet>& inputs);
		CV_WRAP [[nodiscard]] absl::Status close();
	protected:
		std::shared_ptr<mediapipe::tasks::core::TaskRunner> _runner;
		audio_task_running_mode::AudioTaskRunningMode _running_mode;
		std::optional<float> _default_sample_rate;
	};
}
