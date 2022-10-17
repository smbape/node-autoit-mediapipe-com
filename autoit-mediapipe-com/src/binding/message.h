#pragma once

#include "autoit_bridge.h"

namespace google {
	namespace protobuf {
		namespace autoit {
			namespace cmessage {
				const std::string ToStr(const Message& message);

				const FieldDescriptor* FindFieldWithOneofs(
					const Message& message,
					const std::string& field_name,
					bool* in_oneof
				);

				bool HasField(const Message& message, const std::string& field_name);

				bool CheckFieldBelongsToMessage(const Message& message,
					const FieldDescriptor* field_descriptor);

				int SetFieldValue(Message& message,
					const FieldDescriptor* field_descriptor,
					const _variant_t& arg);

				_variant_t GetFieldValue(
					Message& message,
					const FieldDescriptor* field_descriptor
				);

				_variant_t DeepCopy(
					Message* message,
					const FieldDescriptor* field_descriptor
				);

				void MergeFromString(Message* message, const std::string& data);
			}
		}
	}
}
