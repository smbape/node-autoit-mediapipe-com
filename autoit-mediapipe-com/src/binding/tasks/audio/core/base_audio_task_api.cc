#include "binding/tasks/audio/core/base_audio_task_api.h"

namespace mediapipe {
	namespace tasks {
		namespace autoit {
			namespace audio {
				namespace core {
					namespace base_audio_task_api {
						using audio_task_running_mode::AudioTaskRunningMode;
						using audio_task_running_mode::AudioTaskRunningModeToChar;
						using mediapipe::autoit::PacketsCallback;

						BaseAudioTaskApi::BaseAudioTaskApi(
							const CalculatorGraphConfig& graph_config,
							AudioTaskRunningMode running_mode,
							PacketsCallback packet_callback
						) {
							if (running_mode == AudioTaskRunningMode::AUDIO_STREAM) {
								AUTOIT_ASSERT_THROW(packet_callback, "The audio task is in audio stream mode, a user-defined result "
									"callback must be provided.");
							}
							else {
								AUTOIT_ASSERT_THROW(!packet_callback, "The audio task is in audio clips mode, a user-defined result "
									"callback should not be provided.");
							}

							_runner = mediapipe::autoit::task_runner::create(graph_config, std::move(packet_callback));
							_running_mode = running_mode;
						}

						std::map<std::string, Packet> BaseAudioTaskApi::_process_audio_clip(const std::map<std::string, Packet>& inputs) {
							AUTOIT_ASSERT_THROW(_running_mode == AudioTaskRunningMode::AUDIO_CLIPS,
								"Task is not initialized with the audio clips mode. Current running mode: "
								<< StringifyAudioTaskRunningMode(_running_mode));
							return mediapipe::autoit::AssertAutoItValue(_runner->Process(inputs));
						}

						void BaseAudioTaskApi::_set_sample_rate(const std::string& sample_rate_stream_name, float sample_rate) {
							AUTOIT_ASSERT_THROW(_running_mode == AudioTaskRunningMode::AUDIO_STREAM,
								"Task is not initialized with the audio stream mode. Current running mode: "
								<< StringifyAudioTaskRunningMode(_running_mode));
							_runner->Send({
								{sample_rate_stream_name, std::move(std::move(MakePacket<double>(sample_rate)).At(Timestamp::PreStream()))}
								});
						}

						void BaseAudioTaskApi::_send_audio_stream_data(const std::map<std::string, Packet>& inputs) {
							AUTOIT_ASSERT_THROW(_running_mode == AudioTaskRunningMode::AUDIO_STREAM,
								"Task is not initialized with the audio stream mode. Current running mode: "
								<< StringifyAudioTaskRunningMode(_running_mode));
							_runner->Send(inputs);
						}

						void BaseAudioTaskApi::close() {
							_runner->Close();
						}
					}
				}
			}
		}
	}
}
