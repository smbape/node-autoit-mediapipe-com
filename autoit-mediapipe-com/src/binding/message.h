#pragma once

#include "absl/status/status.h"
#include "absl/status/statusor.h"
#include <google/protobuf/message.h>
#include <google/protobuf/util/message_differencer.h>
#include <opencv2/core/cvdef.h>

#include "autoit_bridge.h"

namespace google::protobuf::autoit::cmessage {
	const FieldDescriptor* FindFieldWithOneofs(
		const Message& message,
		const std::string& field_name,
		bool* in_oneof = nullptr
	);

	const FieldDescriptor* FindFieldWithOneofs(
		const Message& message,
		const std::string& field_name,
		const Descriptor* descriptor,
		bool* in_oneof = nullptr
	);

	[[nodiscard]] absl::StatusOr<bool> HasField(const Message& message, const std::string& field_name);

	[[nodiscard]] absl::StatusOr<bool> CheckFieldBelongsToMessage(const Message& message,
		const FieldDescriptor* field_descriptor);

	CV_WRAP [[nodiscard]] absl::StatusOr<int> SetFieldValue(Message& message,
		const std::string& field_name,
		const _variant_t& arg);

	[[nodiscard]] absl::StatusOr<int> SetFieldValue(Message& message,
		const FieldDescriptor* field_descriptor,
		const _variant_t& arg);

	[[nodiscard]] absl::Status InitAttributes(Message& message,
		const std::map<std::string, _variant_t>& attrs);

	[[nodiscard]] absl::StatusOr<FieldDescriptor*> GetFieldDescriptor(
		const Message& message,
		const std::string& field_name,
		bool& is_in_oneof
	);

	CV_WRAP [[nodiscard]] absl::StatusOr<_variant_t> GetFieldValue(
		Message& message,
		const std::string& field_name
	);

	[[nodiscard]] absl::StatusOr<_variant_t> GetFieldValue(
		Message& message,
		const FieldDescriptor* field_descriptor
	);

	[[nodiscard]] absl::StatusOr<_variant_t> DeepCopy(
		Message* message,
		const FieldDescriptor* field_descriptor
	);

	[[nodiscard]] absl::Status CopyFrom(Message* message, const Message* other_message);
	[[nodiscard]] absl::Status MergeFromString(Message* message, const std::string& data);

	[[nodiscard]] absl::StatusOr<int> ClearFieldByDescriptor(Message& message, const FieldDescriptor* field_descriptor);
	[[nodiscard]] absl::Status ClearField(Message& message, const std::string& field_name);

	CV_WRAP [[nodiscard]] absl::Status NomalizeNumberFields(Message& message);
}
