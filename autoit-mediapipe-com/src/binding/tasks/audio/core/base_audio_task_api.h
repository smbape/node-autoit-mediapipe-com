#pragma once

#include "mediapipe/framework/calculator.pb.h"
#include "binding/packet.h"
#include "binding/tasks/audio/core/audio_task_running_mode.h"
#include "binding/tasks/core/task_runner.h"
#include "binding/timestamp.h"

namespace mediapipe {
	namespace tasks {
		namespace autoit {
			namespace audio {
				namespace core {
					namespace base_audio_task_api {
						class CV_EXPORTS_W BaseAudioTaskApi {
						public:
							CV_WRAP BaseAudioTaskApi(
								const CalculatorGraphConfig& graph_config,
								audio_task_running_mode::AudioTaskRunningMode running_mode,
								mediapipe::autoit::PacketsCallback packet_callback = nullptr
							);

							CV_WRAP std::map<std::string, Packet> _process_audio_clip(const std::map<std::string, Packet>& inputs);
							CV_WRAP void _set_sample_rate(const std::string& sample_rate_stream_name, float sample_rate);
							CV_WRAP void _send_audio_stream_data(const std::map<std::string, Packet>& inputs);
							CV_WRAP void close();
						protected:
							std::shared_ptr<mediapipe::tasks::core::TaskRunner> _runner;
							audio_task_running_mode::AudioTaskRunningMode _running_mode;
							std::optional<float> _default_sample_rate;
						};
					}
				}
			}
		}
	}
}
