#pragma once

namespace mediapipe {
	namespace tasks {
		namespace autoit {
			namespace audio {
				namespace core {
					namespace audio_task_running_mode {
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
				}
			}
		}
	}
}
