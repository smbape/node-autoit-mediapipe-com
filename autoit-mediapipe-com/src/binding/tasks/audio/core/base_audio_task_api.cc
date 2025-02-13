#include "binding/tasks/audio/core/base_audio_task_api.h"

namespace mediapipe::tasks::autoit::audio::core::base_audio_task_api {
	using audio_task_running_mode::AudioTaskRunningMode;
	using audio_task_running_mode::AudioTaskRunningModeToChar;
	using mediapipe::autoit::PacketsCallback;

	BaseAudioTaskApi::~BaseAudioTaskApi() {
		auto status = close();
		if (!status.ok()) {
			AUTOIT_WARN(::mediapipe::autoit::StatusCodeToError(status.code()) << ": " << status.message().data());
		}
	}

	absl::StatusOr<std::shared_ptr<BaseAudioTaskApi>> BaseAudioTaskApi::create(
		const CalculatorGraphConfig& graph_config,
		audio_task_running_mode::AudioTaskRunningMode running_mode,
		mediapipe::autoit::PacketsCallback packet_callback
	) {
		return BaseAudioTaskApi::create(graph_config, running_mode, packet_callback, static_cast<BaseAudioTaskApi*>(nullptr));
	}

	absl::StatusOr<std::map<std::string, Packet>> BaseAudioTaskApi::_process_audio_clip(const std::map<std::string, Packet>& inputs) {
		MP_ASSERT_RETURN_IF_ERROR(_running_mode == AudioTaskRunningMode::AUDIO_CLIPS,
			"Task is not initialized with the audio clips mode. Current running mode: "
			<< StringifyAudioTaskRunningMode(_running_mode));
		return _runner->Process(inputs);
	}

	absl::Status BaseAudioTaskApi::_set_sample_rate(const std::string& sample_rate_stream_name, float sample_rate) {
		MP_ASSERT_RETURN_IF_ERROR(_running_mode == AudioTaskRunningMode::AUDIO_STREAM,
			"Task is not initialized with the audio stream mode. Current running mode: "
			<< StringifyAudioTaskRunningMode(_running_mode));
		return _runner->Send({
			{sample_rate_stream_name, std::move(std::move(MakePacket<double>(sample_rate)).At(Timestamp::PreStream()))}
			});
	}

	absl::Status BaseAudioTaskApi::_send_audio_stream_data(const std::map<std::string, Packet>& inputs) {
		MP_ASSERT_RETURN_IF_ERROR(_running_mode == AudioTaskRunningMode::AUDIO_STREAM,
			"Task is not initialized with the audio stream mode. Current running mode: "
			<< StringifyAudioTaskRunningMode(_running_mode));
		return _runner->Send(inputs);
	}

	absl::Status BaseAudioTaskApi::close() {
		return _runner->Close();
	}
}
