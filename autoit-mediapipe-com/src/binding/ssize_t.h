#pragma once

// https://www.scivision.dev/ssize_t-platform-independent/
#include <cstddef>
namespace google::protobuf::autoit {
	using ssize_t = std::ptrdiff_t;
}
