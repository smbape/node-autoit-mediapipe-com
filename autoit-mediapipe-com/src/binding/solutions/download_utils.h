#pragma once
#pragma comment(lib, "urlmon.lib")

#include <Windows.h>
#include <urlmon.h>

namespace mediapipe::autoit::solutions::download_utils {
	/**
	 * Downloads the oss model from Google Cloud Storage if it doesn't exist in the package.
	 * @param model_path [description]
	 */
	CV_WRAP [[nodiscard]] absl::Status download_oss_model(const std::string& model_path, const std::string& hash = std::string(), const bool force = false, const bool verbose = false);

	CV_WRAP [[nodiscard]] absl::Status download(const std::string& url, const std::string& file, const std::string& hash = std::string(), const bool force = false, const bool verbose = false);
}
