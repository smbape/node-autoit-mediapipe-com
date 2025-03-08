#pragma once

namespace mediapipe::tasks::autoit::audio {
	namespace core::audio_task_running_mode {
		enum class AudioTaskRunningMode {
			AUDIO_CLIPS,
			AUDIO_STREAM
		};

		static const char* AudioTaskRunningModeToChar[] =
		{
			"AUDIO_CLIPS",
			"AUDIO_STREAM"
		};

	}

	inline const char* StringifyAudioTaskRunningMode(core::audio_task_running_mode::AudioTaskRunningMode enum_value) {
		return core::audio_task_running_mode::AudioTaskRunningModeToChar[static_cast<int>(enum_value)];
	}
}
