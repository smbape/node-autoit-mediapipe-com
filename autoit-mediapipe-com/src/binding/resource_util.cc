#include "binding/resource_util.h"

ABSL_DECLARE_FLAG(std::string, resource_root_dir);

namespace mediapipe {
	namespace autoit {
		namespace _framework_bindings {
			namespace resource_util {
				void set_resource_dir(const std::string& str) {
					absl::SetFlag(&FLAGS_resource_root_dir, str);
				}

				const std::string get_resource_dir() {
					return absl::GetFlag(FLAGS_resource_root_dir);
				}
			}
		}
	}
}
