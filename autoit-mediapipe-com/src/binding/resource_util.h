#pragma once

#include "absl/flags/declare.h"
#include "absl/flags/flag.h"
#include <opencv2/core/cvdef.h>

namespace mediapipe {
	namespace resource_util {
		CV_EXPORTS_W void set_resource_dir(const std::string& str);
		CV_EXPORTS_W const std::string get_resource_dir();
	}
}
