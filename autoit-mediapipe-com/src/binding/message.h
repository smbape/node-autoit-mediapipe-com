#pragma once

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

	bool HasField(const Message& message, const std::string& field_name);

	bool CheckFieldBelongsToMessage(const Message& message,
		const FieldDescriptor* field_descriptor);

	CV_WRAP int SetFieldValue(Message& message,
		const std::string& field_name,
		const _variant_t& arg);

	int SetFieldValue(Message& message,
		const FieldDescriptor* field_descriptor,
		const _variant_t& arg);

	void InitAttributes(Message& message,
		const std::map<std::string, _variant_t>& attrs);

	const FieldDescriptor* GetFieldDescriptor(
		const Message& message,
		const std::string& field_name,
		bool& is_in_oneof
	);

	CV_WRAP _variant_t GetFieldValue(
		Message& message,
		const std::string& field_name
	);

	_variant_t GetFieldValue(
		Message& message,
		const FieldDescriptor* field_descriptor
	);

	_variant_t DeepCopy(
		Message* message,
		const FieldDescriptor* field_descriptor
	);

	void CopyFrom(Message* message, const Message* other_message);
	void MergeFromString(Message* message, const std::string& data);

	int ClearFieldByDescriptor(Message& message, const FieldDescriptor* field_descriptor);
	void ClearField(Message& message, const std::string& field_name);

	CV_WRAP void NomalizeNumberFields(Message& message);
}
