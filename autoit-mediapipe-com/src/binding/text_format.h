#pragma once

#include "google/protobuf/text_format.h"

namespace google {
	namespace protobuf {
		namespace autoit {
			inline Message* Parse(const std::string& input, Message* message) {
				AUTOIT_ASSERT_THROW(TextFormat::MergeFromString(input, message), "Failed to parse message " << input);
				return message;
			}

			inline void Print(const Message& message, std::string* output) {
				AUTOIT_ASSERT_THROW(TextFormat::PrintToString(message, output), "Failed to print message");
			}
		}
	}
}
