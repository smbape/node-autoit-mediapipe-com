#include "binding/resource_util.h"

ABSL_DECLARE_FLAG(std::string, resource_root_dir);

void mediapipe::resource_util::set_resource_dir(const std::string& str) {
	absl::SetFlag(&FLAGS_resource_root_dir, str);
}
