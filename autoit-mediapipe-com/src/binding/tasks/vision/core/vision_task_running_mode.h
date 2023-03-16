#pragma once

namespace mediapipe {
	namespace tasks {
		namespace autoit {
			namespace vision {
				namespace core {
					namespace vision_task_running_mode {
						enum class VisionTaskRunningMode {
							IMAGE,
							VIDEO,
							LIVE_STREAM,
						};

						static const char* VisionTaskRunningModeToChar[] =
						{
							"IMAGE",
							"VIDEO",
							"LIVE_STREAM",
						};
					}
				}

				inline const char* StringifyVisionTaskRunningMode(core::vision_task_running_mode::VisionTaskRunningMode enum_value) {
					return core::vision_task_running_mode::VisionTaskRunningModeToChar[static_cast<int>(enum_value)];
				}
			}
		}
	}
}
