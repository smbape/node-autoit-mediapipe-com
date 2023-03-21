#pragma once

#include "google/protobuf/text_format.h"

namespace google::protobuf::autoit {
	std::shared_ptr<Message> Parse(const std::string& input, std::shared_ptr<Message> message);
	void Print(const Message& message, std::string* output);
}
