#pragma once
#pragma comment(lib, "urlmon.lib")

#include <Windows.h>
#include <urlmon.h>

namespace mediapipe::tasks::autoit::core::download_utils {
	CV_WRAP [[nodiscard]] absl::Status download(const std::string& url, const std::string& file, const std::string& hash = std::string(), const bool force = false, const bool verbose = false);
}
