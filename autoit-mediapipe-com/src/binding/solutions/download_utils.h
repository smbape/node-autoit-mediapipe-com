#pragma once
#pragma comment(lib, "urlmon.lib")

#include <Windows.h>
#include <urlmon.h>

namespace mediapipe {
	namespace autoit {
		namespace solutions {
			namespace download_utils {
				/**
				 * Downloads the oss model from Google Cloud Storage if it doesn't exist in the package.
				 * @param model_path [description]
				 */
				CV_WRAP void download_oss_model(const std::string& model_path);
			}
		}
	}
}