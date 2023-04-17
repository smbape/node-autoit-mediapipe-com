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
		std::map<std::string, _variant_t>& attrs);

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

	template<typename _Tr, typename _Ti>
	HRESULT SetRepeatedField(Message& message, const std::string& field_name, VARIANT* newVal, _Tr* repeated_field, _Ti& repeated_iterator) {
		const Descriptor* descriptor = message.GetDescriptor();
		const auto field_descriptor = FindFieldWithOneofs(message, field_name, descriptor);
		RepeatedContainer autoit_container;
		autoit_container.message = ::autoit::reference_internal(&message);
		autoit_container.field_descriptor = ::autoit::reference_internal(field_descriptor);

		HRESULT hr;

		std::shared_ptr<_Tr> other;
		hr = autoit_to(newVal, other);
		if (SUCCEEDED(hr)) {
			autoit_container.Clear();
			repeated_field->Reserve(other->size());
			std::copy(other->begin(), other->end(), repeated_iterator);
			return hr;
		}

		std::vector<_variant_t> value_items;
		hr = autoit_to(newVal, value_items);
		if (SUCCEEDED(hr)) {
			autoit_container.Clear();
			autoit_container.MergeFrom(value_items);
			return hr;
		}

		return E_INVALIDARG;
	}
}
