#include <iostream>
#include <filesystem>
#include "mediapipe/framework/port/file_helpers.h"
#include "mediapipe/framework/port/status.h"
#include "binding/resource_util.h"
#include "binding/solutions/download_utils.h"
#include "autoit_bridge_common.h"

namespace fs = std::filesystem;

static const std::string _GCS_URL_PREFIX = "https://storage.googleapis.com/mediapipe-assets/";

namespace mediapipe {
	namespace autoit {
		namespace solutions {
			namespace download_utils {
				void download_oss_model(const std::string& model_path) {
					fs::path mp_root_path(mediapipe::autoit::_framework_bindings::resource_util::get_resource_dir());
					auto model_abspath = fs::absolute(mp_root_path / model_path);

					auto status = file::Exists(model_abspath.string());
					if (status.ok()) {
						return;
					}

					auto pos_end = model_path.find_last_of('/');
					auto model_url = _GCS_URL_PREFIX + model_path.substr(pos_end == std::string::npos ? 0 : pos_end + 1);
					AUTOIT_INFO("Downloading " << model_url << " model to " << model_abspath);

					// create directory tree
					fs::create_directories(model_abspath.parent_path());

					auto sFileNameL = model_abspath.string();
					HRESULT hr = URLDownloadToFile(NULL, model_url.c_str(), sFileNameL.c_str(), 0, NULL);

					if (FAILED(hr)) {
						if (hr == E_OUTOFMEMORY) {
							printf("Buffer length invalid, or insufficient memory\n");
						}
						else if (hr == INET_E_DOWNLOAD_FAILURE) {
							printf("URL is invalid\n");
						}
						else {
							printf("Other error: %d\n", hr);
						}
					}
				}
			}
		}
	}
}
