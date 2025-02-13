#include "binding/text_format.h"
#include "binding/packet_getter.h"

namespace google::protobuf::autoit {
	absl::StatusOr<std::shared_ptr<Message>> Parse(const std::string& input, std::shared_ptr<Message>& message) {
		MP_ASSERT_RETURN_IF_ERROR(TextFormat::MergeFromString(input, message.get()), "Failed to parse message " << input);
		return message;
	}

	absl::Status Print(const Message& message, std::string* output) {
		MP_ASSERT_RETURN_IF_ERROR(TextFormat::PrintToString(message, output), "Failed to print message");
		return absl::OkStatus();
	}
}
