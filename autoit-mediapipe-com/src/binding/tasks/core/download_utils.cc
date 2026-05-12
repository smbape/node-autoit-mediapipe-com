#include <iostream>
#include <filesystem>
#include "binding/tasks/core/download_utils.h"
#include "autoit_bridge_common.h"

namespace fs = std::filesystem;

namespace mediapipe::tasks::autoit::core::download_utils {
	absl::Status download(const std::string& url, const std::string& file, const std::string& hash, const bool force, const bool verbose) {
		auto file_abspath = fs::absolute(fs::path(file));

		if (!force && fs::exists(file_abspath)) {
			return absl::OkStatus();
		}

		AUTOIT_INFO("Downloading " << url << " to " << file_abspath);

		// create directory tree
		fs::create_directories(file_abspath.parent_path());

		auto sFileNameL = file_abspath.string();
		HRESULT hr = URLDownloadToFile(NULL, url.c_str(), sFileNameL.c_str(), 0, NULL);

		if (SUCCEEDED(hr)) {
			return absl::OkStatus();
		}

		if (hr == E_OUTOFMEMORY) {
			MP_ASSERT_RETURN_IF_ERROR(false, "Buffer length invalid, or insufficient memory");
		}
		else if (hr == INET_E_DOWNLOAD_FAILURE) {
			MP_ASSERT_RETURN_IF_ERROR(false, "URL is invalid");
		}
		else {
			MP_ASSERT_RETURN_IF_ERROR(false, "Other error: " << hr);
		}
	}
}
