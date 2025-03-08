#include <iostream>
#include <filesystem>
#include "binding/resource_util.h"
#include "binding/solutions/download_utils.h"
#include "autoit_bridge_common.h"

namespace fs = std::filesystem;

static const std::string _GCS_URL_PREFIX = "https://storage.googleapis.com/mediapipe-assets/";

namespace mediapipe::autoit::solutions::download_utils {
	absl::Status download_oss_model(const std::string& model_path, const std::string& hash, const bool force, const bool verbose) {
		fs::path mp_root_path(mediapipe::autoit::_framework_bindings::resource_util::get_resource_dir());
		auto model_abspath = fs::absolute(mp_root_path / model_path);

		auto pos_end = model_path.find_last_of('/');
		auto model_url = _GCS_URL_PREFIX + model_path.substr(pos_end == std::string::npos ? 0 : pos_end + 1);

		return download(model_url, model_abspath.string(), hash, force, verbose);
	}

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
