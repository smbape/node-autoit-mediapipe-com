#pragma once

#include <google/protobuf/text_format.h>
#include "absl/status/statusor.h"

namespace google::protobuf::autoit {
	[[nodiscard]] absl::StatusOr<std::shared_ptr<Message>> Parse(const std::string& input, std::shared_ptr<Message>& message);
	[[nodiscard]] absl::Status Print(const Message& message, std::string* output);
}
