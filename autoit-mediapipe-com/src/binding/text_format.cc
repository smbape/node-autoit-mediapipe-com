#include "binding/text_format.h"
#include "binding/packet_getter.h"

namespace google {
	namespace protobuf {
		namespace autoit {
			std::shared_ptr<Message> Parse(const std::string& input, std::shared_ptr<Message> message) {
				AUTOIT_ASSERT_THROW(TextFormat::MergeFromString(input, message.get()), "Failed to parse message " << input);
				return message;
			}

			void Print(const Message& message, std::string* output) {
				AUTOIT_ASSERT_THROW(TextFormat::PrintToString(message, output), "Failed to print message");
			}
		}
	}
}
