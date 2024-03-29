#include <cmath>
#include "google/protobuf/descriptor.pb.h"
#include "google/protobuf/message.h"
#include "binding/message.h"
#include "binding/map_container.h"
#include "binding/repeated_container.h"
#include "binding/util.h"
#include "Google_Protobuf_Autoit_MapContainer_Object.h"
#include "Google_Protobuf_Autoit_RepeatedContainer_Object.h"
#include "Google_Protobuf_Message_Object.h"
#include "MapOfStringAndVariant_Object.h"
#include "VectorOfPairOfVariantAndVariant_Object.h"

// https://github.com/protocolbuffers/protobuf/issues/5051
#ifdef GetMessage
#undef GetMessage
#endif

namespace google::protobuf {
	// hack to access MapReflection private members
	template<>
	class MutableRepeatedFieldRef<void, void> {
	public:
		// static void UnsafeShallowSwapFields(
		// 	Message* lhs, Message* rhs,
		// 	const std::vector<const FieldDescriptor*>& fields);
		// static bool IsLazyField(const Reflection* reflection, const Message& message,
		// 	const FieldDescriptor* field);
		static void MapNormalizeNumberFields(Message& message, const Reflection* reflection,
			const FieldDescriptor* field);
	};

	using MessageReflectionFriend = MutableRepeatedFieldRef<void, void>;

	// void MessageReflectionFriend::UnsafeShallowSwapFields(
	// 	Message* lhs, Message* rhs,
	// 	const std::vector<const FieldDescriptor*>& fields) {
	// 	lhs->GetReflection()->UnsafeShallowSwapFields(lhs, rhs, fields);
	// }

	// bool MessageReflectionFriend::IsLazyField(const Reflection* reflection, const Message& message,
	// 	const FieldDescriptor* field) {
	// 	return reflection->IsLazyField(field) ||
	// 		reflection->IsLazyExtension(message, field);
	// }

	void MessageReflectionFriend::MapNormalizeNumberFields(Message& message, const Reflection* reflection,
		const FieldDescriptor* field) {

		const internal::MapFieldBase& base = *reflection->GetMapData(message, field);

		if (base.IsRepeatedFieldValid()) {
			RepeatedPtrField<Message>* map_field =
				reflection->MutableRepeatedPtrFieldInternal<Message>(&message, field);
			for (int i = 0; i < map_field->size(); ++i) {
				Message* sub_message = map_field->Mutable(i);
				autoit::cmessage::NomalizeNumberFields(*sub_message);
			}
		}
		else {
			for (MapIterator iter =
				reflection->MapBegin(&message, field);
				iter != reflection->MapEnd(&message, field);
				++iter) {
				MapValueRef* value = iter.MutableValueRef();
				Message* sub_message = value->MutableMessageValue();
				autoit::cmessage::NomalizeNumberFields(*sub_message);
			}
		}
	}

	namespace autoit::cmessage {
		static _variant_t None = mediapipe::autoit::default_variant();

		const FieldDescriptor* FindFieldWithOneofs(
			const Message& message,
			const std::string& field_name,
			bool* in_oneof
		) {
			const Descriptor* descriptor = message.GetDescriptor();
			return FindFieldWithOneofs(message, field_name, descriptor, in_oneof);
		}

		const FieldDescriptor* FindFieldWithOneofs(
			const Message& message,
			const std::string& field_name,
			const Descriptor* descriptor,
			bool* in_oneof
		) {
			if (in_oneof != nullptr) {
				*in_oneof = false;
			}
			const FieldDescriptor* field_descriptor =
				descriptor->FindFieldByName(field_name);
			if (field_descriptor != NULL) {
				return field_descriptor;
			}
			const OneofDescriptor* oneof_desc =
				descriptor->FindOneofByName(field_name);
			if (oneof_desc != NULL) {
				if (in_oneof != nullptr) {
					*in_oneof = true;
				}
				return message.GetReflection()->GetOneofFieldDescriptor(message, oneof_desc);
			}
			return NULL;
		}

		static bool CheckHasPresence(const FieldDescriptor* field_descriptor, bool in_oneof) {
			auto message_name = field_descriptor->containing_type()->name();

			AUTOIT_ASSERT_THROW(!field_descriptor->is_repeated(),
				"Protocol message " << message_name << " has no singular \"" << field_descriptor->name() << "\" field.");

			AUTOIT_ASSERT_THROW(field_descriptor->has_presence(),
				"Can't test non-optional, non-submessage field \"" << message_name << "." << field_descriptor->name() << "\" for "
				"presence in proto3.");

			return true;
		}

		const FieldDescriptor* GetFieldDescriptor(
			const Message& message,
			const std::string& field_name,
			bool& is_in_oneof
		) {
			const FieldDescriptor* field_descriptor = FindFieldWithOneofs(message, field_name, &is_in_oneof);

			if (field_descriptor == NULL) {
				AUTOIT_ASSERT_THROW(is_in_oneof, "Protocol message " << message.GetDescriptor()->name() << " has no field " << field_name << ".");
			}

			return field_descriptor;
		}

		bool HasField(const Message& message, const std::string& field_name) {
			bool is_in_oneof;
			const FieldDescriptor* field_descriptor = GetFieldDescriptor(message, field_name, is_in_oneof);
			if (field_descriptor == NULL) {
				return false;
			}
			CheckHasPresence(field_descriptor, is_in_oneof);
			return message.GetReflection()->HasField(message, field_descriptor);
		}

		bool CheckFieldBelongsToMessage(const Message& message,
			const FieldDescriptor* field_descriptor) {
			AUTOIT_ASSERT_THROW(
				message.GetDescriptor() == field_descriptor->containing_type(),
				"Field '" << field_descriptor->full_name() << "' does not belong to message '" << message.GetDescriptor()->full_name() << "'"
			);
			// if (message.GetDescriptor() != field_descriptor->containing_type()) {
			// 	fprintf(stderr, "Field '%s' does not belong to message '%s'",
			// 		field_descriptor->full_name().c_str(),
			// 		message.GetDescriptor()->full_name().c_str());
			// 	fflush(stdout);
			// 	fflush(stderr);
			// 	return false;
			// }

			return true;
		}

		int InternalSetNonOneofScalar(
			Message* message,
			const FieldDescriptor* field_descriptor,
			const _variant_t& arg
		) {
			if (!CheckFieldBelongsToMessage(*message, field_descriptor)) {
				return -1;
			}

			const Reflection* reflection = message->GetReflection();

			switch (field_descriptor->cpp_type()) {
			case FieldDescriptor::CPPTYPE_INT32: {
				auto value = ::autoit::cast<int>(&arg);
				reflection->SetInt32(message, field_descriptor, value);
				break;
			}
			case FieldDescriptor::CPPTYPE_INT64: {
				auto value = ::autoit::cast<int64_t>(&arg);
				reflection->SetInt64(message, field_descriptor, value);
				break;
			}
			case FieldDescriptor::CPPTYPE_UINT32: {
				auto value = ::autoit::cast<uint>(&arg);
				reflection->SetUInt32(message, field_descriptor, value);
				break;
			}
			case FieldDescriptor::CPPTYPE_UINT64: {
				auto value = ::autoit::cast<uint64_t>(&arg);
				reflection->SetUInt64(message, field_descriptor, value);
				break;
			}
			case FieldDescriptor::CPPTYPE_FLOAT: {
				auto value = ::autoit::cast<float>(&arg);
				reflection->SetFloat(message, field_descriptor, value);
				break;
			}
			case FieldDescriptor::CPPTYPE_DOUBLE: {
				auto value = ::autoit::cast<double>(&arg);
				reflection->SetDouble(message, field_descriptor, value);
				break;
			}
			case FieldDescriptor::CPPTYPE_BOOL: {
				auto value = ::autoit::cast<bool>(&arg);
				reflection->SetBool(message, field_descriptor, value);
				break;
			}
			case FieldDescriptor::CPPTYPE_STRING: {
				auto value = ::autoit::cast<std::string>(&arg);
				reflection->SetString(message, field_descriptor, std::move(value));
				break;
			}
			case FieldDescriptor::CPPTYPE_ENUM: {
				auto value = ::autoit::cast<int>(&arg);
				if (reflection->SupportsUnknownEnumValues()) {
					reflection->SetEnumValue(message, field_descriptor, value);
				}
				else {
					const EnumDescriptor* enum_descriptor = field_descriptor->enum_type();
					const EnumValueDescriptor* enum_value = enum_descriptor->FindValueByNumber(value);
					AUTOIT_ASSERT_THROW(enum_value, "Unknown enum value: " << value);
					reflection->SetEnum(message, field_descriptor, enum_value);
				}
				break;
			}
			default:
				AUTOIT_THROW("Setting value to a field of unknown type " << field_descriptor->cpp_type());
			}

			return 0;
		}

		_variant_t InternalGetScalar(
			const Message& message,
			const FieldDescriptor* field_descriptor
		) {
			const Reflection* reflection = message.GetReflection();
			if (!CheckFieldBelongsToMessage(message, field_descriptor)) {
				return None;
			}

			_variant_t obj;
			VARIANT* out_val = &obj;
			VariantInit(out_val);
			HRESULT hr = S_OK;

			switch (field_descriptor->cpp_type()) {
			case FieldDescriptor::CPPTYPE_INT32: {
				hr = autoit_from(reflection->GetInt32(message, field_descriptor), out_val);
				break;
			}
			case FieldDescriptor::CPPTYPE_INT64: {
				hr = autoit_from(reflection->GetInt64(message, field_descriptor), out_val);
				break;
			}
			case FieldDescriptor::CPPTYPE_UINT32: {
				hr = autoit_from(reflection->GetUInt32(message, field_descriptor), out_val);
				break;
			}
			case FieldDescriptor::CPPTYPE_UINT64: {
				hr = autoit_from(reflection->GetUInt64(message, field_descriptor), out_val);
				break;
			}
			case FieldDescriptor::CPPTYPE_FLOAT: {
				hr = autoit_from(reflection->GetFloat(message, field_descriptor), out_val);
				break;
			}
			case FieldDescriptor::CPPTYPE_DOUBLE: {
				hr = autoit_from(reflection->GetDouble(message, field_descriptor), out_val);
				break;
			}
			case FieldDescriptor::CPPTYPE_BOOL: {
				hr = autoit_from(reflection->GetBool(message, field_descriptor), out_val);
				break;
			}
			case FieldDescriptor::CPPTYPE_STRING: {
				std::string scratch;
				hr = autoit_from(reflection->GetStringReference(message, field_descriptor, &scratch), out_val);
				break;
			}
			case FieldDescriptor::CPPTYPE_ENUM: {
				const EnumValueDescriptor* enum_value = reflection->GetEnum(message, field_descriptor);
				hr = autoit_from(enum_value->number(), out_val);
				break;
			}
			default:
				AUTOIT_THROW("Getting a value from a field of unknown type " << field_descriptor->cpp_type());
			}

			if (FAILED(hr)) {
				AUTOIT_THROW("Getting a value from a field of type " << field_descriptor->cpp_type());
			}

			return obj;
		}

		int InternalSetScalar(
			Message& message,
			const FieldDescriptor* field_descriptor,
			const _variant_t& arg) {
			if (!CheckFieldBelongsToMessage(message, field_descriptor)) {
				return -1;
			}

			return InternalSetNonOneofScalar(&message, field_descriptor, arg);
		}

		int SetFieldValue(
			Message& message,
			const std::string& field_name,
			const _variant_t& arg
		) {
			bool is_in_oneof;
			const FieldDescriptor* field_descriptor = GetFieldDescriptor(message, field_name, is_in_oneof);
			return ::google::protobuf::autoit::cmessage::SetFieldValue(message, field_descriptor, arg);
		}

		int SetFieldValue(Message& message,
			const FieldDescriptor* field_descriptor,
			const _variant_t& arg) {
			if (!CheckFieldBelongsToMessage(message, field_descriptor)) {
				return -1;
			}

			AUTOIT_ASSERT_THROW(!field_descriptor->is_repeated(),
				"Assignment not allowed to repeated "
				"field \"" << field_descriptor->name() << "\" in protocol message object.");

			AUTOIT_ASSERT_THROW(field_descriptor->cpp_type() != FieldDescriptor::CPPTYPE_MESSAGE,
				"Assignment not allowed to "
				"field \"" << field_descriptor->name() << "\" in protocol message object.");

			return InternalSetScalar(message, field_descriptor, arg);
		}

		void InitAttributes(Message& message,
			std::map<std::string, _variant_t>& attrs) {
			const Descriptor* descriptor = message.GetDescriptor();

			for (auto& [field_name, value] : attrs) {
				const auto field_descriptor = FindFieldWithOneofs(message, field_name, descriptor);
				AUTOIT_ASSERT_THROW(field_descriptor, "Field '" << field_name << "' does not belong to message '" << descriptor->full_name() << "'");
				VARIANT* in_val = &value;

				if (field_descriptor->is_map()) {
					MapContainer autoit_container;
					autoit_container.message = ::autoit::reference_internal(&message);
					autoit_container.field_descriptor = ::autoit::reference_internal(field_descriptor);
					std::vector<std::pair<_variant_t, _variant_t>> value_fields;
					HRESULT hr = autoit_to(in_val, value_fields);
					AUTOIT_ASSERT_THROW(SUCCEEDED(hr), "value of field " << field_name << " is not a map");
					autoit_container.SetFields(value_fields);
				}
				else if (field_descriptor->is_repeated()) {
					RepeatedContainer autoit_container;
					autoit_container.message = ::autoit::reference_internal(&message);
					autoit_container.field_descriptor = ::autoit::reference_internal(field_descriptor);
					std::vector<_variant_t> value_items;
					HRESULT hr = autoit_to(in_val, value_items);
					AUTOIT_ASSERT_THROW(SUCCEEDED(hr), "value of field " << field_name << " is not a list");
					autoit_container.Extend(value_items);
				}
				else if (field_descriptor->cpp_type() == FieldDescriptor::CPPTYPE_MESSAGE) {
					std::map<std::string, _variant_t> sub_attrs;
					HRESULT hr = autoit_to(in_val, sub_attrs);
					if (SUCCEEDED(hr)) {
						Message* sub_message = message.GetReflection()->MutableMessage(&message, field_descriptor);
						InitAttributes(*sub_message, sub_attrs);
					}
					else {
						SetFieldValue(message, field_descriptor, value);
					}
				}
				else {
					SetFieldValue(message, field_descriptor, value);
				}
			}
		}

		_variant_t GetFieldValue(Message& message, const std::string& field_name) {
			bool is_in_oneof;
			const FieldDescriptor* field_descriptor = GetFieldDescriptor(message, field_name, is_in_oneof);
			return GetFieldValue(message, field_descriptor);
		}

		_variant_t GetFieldValue(
			Message& message,
			const FieldDescriptor* field_descriptor
		) {
			if (!CheckFieldBelongsToMessage(message, field_descriptor)) {
				return None;
			}

			if (!field_descriptor->is_repeated() &&
				field_descriptor->cpp_type() != FieldDescriptor::CPPTYPE_MESSAGE) {
				return InternalGetScalar(message, field_descriptor);
			}

			_variant_t obj;
			VARIANT* out_val = &obj;
			VariantInit(out_val);
			HRESULT hr = S_OK;

			if (field_descriptor->is_map()) {
				MapContainer autoit_container;
				autoit_container.message = ::autoit::reference_internal(&message);
				autoit_container.field_descriptor = ::autoit::reference_internal(field_descriptor);
				hr = autoit_from(autoit_container, out_val);
			}
			else if (field_descriptor->is_repeated()) {
				RepeatedContainer autoit_container;
				autoit_container.message = ::autoit::reference_internal(&message);
				autoit_container.field_descriptor = ::autoit::reference_internal(field_descriptor);
				hr = autoit_from(autoit_container, out_val);
			}
			else if (field_descriptor->cpp_type() ==
				FieldDescriptor::CPPTYPE_MESSAGE) {
				hr = autoit_from(message.GetReflection()->MutableMessage(&message, field_descriptor), out_val);
			}
			else {
				AUTOIT_THROW("Should never happen");
			}

			AUTOIT_ASSERT_THROW(SUCCEEDED(hr), "Failed to get field ");

			return obj;
		}

		_variant_t DeepCopy(
			Message* message,
			const FieldDescriptor* field_descriptor
		) {
			std::unique_ptr<Message> copy(message->New(nullptr));
			const Reflection* reflection = message->GetReflection();

			// Copy the map field into the new message.
			reflection->SwapFields(
				message,
				copy.get(),
				{ field_descriptor }
			);

			message->MergeFrom(*copy);

			reflection->SwapFields(
				message,
				copy.get(),
				{ field_descriptor }
			);

			return GetFieldValue(*copy, field_descriptor);
		}

		void CopyFrom(Message* message, const Message* other_message) {
			if (message == other_message) {
				return;
			}

			AUTOIT_ASSERT_THROW(other_message->GetDescriptor() == message->GetDescriptor(),
				"Parameter to CopyFrom() must be instance of same class: "
				"expected " << message->GetDescriptor()->full_name() << " got "
				<< other_message->GetDescriptor()->full_name() << ".");

			// CopyFrom on the message will not clean up self->composite_fields,
			// which can leave us in an inconsistent state, so clear it out here.
			message->Clear();
			message->CopyFrom(*other_message);
		}

		void MergeFromString(Message* message, const std::string& data) {
			int depth = io::CodedInputStream::GetDefaultRecursionLimit();
			const char* ptr;
			internal::ParseContext ctx(depth, false, &ptr, StringPiece(data));

			ptr = message->_InternalParse(ptr, &ctx);
			AUTOIT_ASSERT_THROW(ptr != nullptr && ctx.BytesUntilLimit(ptr) >= 0,
				"Error parsing message with type '" << message->GetDescriptor()->full_name() << "'");

			AUTOIT_ASSERT_THROW(ctx.EndedAtLimit(), "Unexpected end-group tag: Not all data was converted");
		}

		int ClearFieldByDescriptor(Message& message, const FieldDescriptor* field_descriptor) {
			if (!CheckFieldBelongsToMessage(message, field_descriptor)) {
				return -1;
			}

			message.GetReflection()->ClearField(&message, field_descriptor);
			return 0;
		}

		void ClearField(Message& message, const std::string& field_name) {
			bool is_in_oneof;

			const FieldDescriptor* field_descriptor = FindFieldWithOneofs(message, field_name, &is_in_oneof);
			if (field_descriptor == NULL) {
				if (!is_in_oneof) {
					fprintf(stderr, "Protocol message has no \"%s\" field.", field_name);
					fflush(stdout);
					fflush(stderr);
				}
				return;
			}

			ClearFieldByDescriptor(message, field_descriptor);
		}

		/**
		 * @see https://stackoverflow.com/a/13094362
		 * @param  value  [description]
		 * @param  digits [description]
		 * @return        [description]
		 */
		inline double round_to_digits(double value, int digits) {
			// ln(0) = Infinity
			if (value == 0.0) {
				return value;
			}

			double factor = std::pow(10.0, digits - std::ceil(std::log10(std::fabs(value))));
			return std::round(value * factor) / factor;
		}

		inline double round(double value, int digits) {
			double factor = std::pow(10.0, digits);
			return std::round(value * factor) / factor;
		}

		/**
		 * @see https://github.com/protocolbuffers/protobuf/blob/v22.3/src/google/protobuf/text_format.cc#L2569
		 * @param message    [description]
		 * @param reflection [description]
		 * @param field      [description]
		 * @param index      [description]
		 */
		void NormalizeNumberFieldValue(Message& message,
			const Reflection* reflection,
			const FieldDescriptor* field,
			int index) {

			AUTOIT_ASSERT_THROW(field->is_repeated() || index == -1,
				"Index must be -1 for non-repeated fields");

			switch (field->cpp_type()) {
			case FieldDescriptor::CPPTYPE_DOUBLE:
				if (field->is_repeated()) {
					reflection->SetRepeatedDouble(&message, field, index, round(reflection->GetRepeatedDouble(message, field, index), 6));
				}
				else {
					reflection->SetDouble(&message, field, round(reflection->GetDouble(message, field), 6));
				}
				break;

			case FieldDescriptor::CPPTYPE_FLOAT:
				if (field->is_repeated()) {
					reflection->SetRepeatedFloat(&message, field, index, round(reflection->GetRepeatedFloat(message, field, index), 4));
				}
				else {
					reflection->SetFloat(&message, field, round(reflection->GetFloat(message, field), 4));
				}
				break;

			case FieldDescriptor::CPPTYPE_MESSAGE:
				NomalizeNumberFields(field->is_repeated()
					? *reflection->MutableRepeatedMessage(&message, field, index)
					: *reflection->MutableMessage(&message, field));
				break;
			}
		}

		/**
		 * @see https://github.com/protocolbuffers/protobuf/blob/v22.3/src/google/protobuf/text_format.cc#L2464
		 * @param message    [description]
		 * @param reflection [description]
		 * @param field      [description]
		 */
		void NomalizeNumberField(Message& message, const Reflection* reflection, const FieldDescriptor* field) {
			if (field->is_map()) {
				MessageReflectionFriend::MapNormalizeNumberFields(message, reflection, field);
				return;
			}

			int count = 0;

			if (field->is_repeated()) {
				count = reflection->FieldSize(message, field);
			}
			else if (reflection->HasField(message, field) ||
				field->containing_type()->options().map_entry()) {
				count = 1;
			}

			for (int j = 0; j < count; ++j) {
				if (field->cpp_type() == FieldDescriptor::CPPTYPE_MESSAGE) {
					Message* sub_message = field->is_repeated() ?
						reflection->MutableRepeatedMessage(&message, field, j)
						: reflection->MutableMessage(&message, field);
					NomalizeNumberFields(*sub_message);
				}
				else {
					const int field_index = field->is_repeated() ? j : -1;
					NormalizeNumberFieldValue(message, reflection, field, field_index);
				}
			}
		}

		/**
		 *
		 * @see https://github.com/protocolbuffers/protobuf/blob/v22.3/src/google/protobuf/text_format.cc#L2245
		 * @param message [description]
		 */
		void NomalizeNumberFields(Message& message) {
			const Descriptor* descriptor = message.GetDescriptor();
			const Reflection* reflection = message.GetReflection();
			std::vector<const FieldDescriptor*> fields;
			if (descriptor->options().map_entry()) {
				fields.push_back(descriptor->field(0));
				fields.push_back(descriptor->field(1));
			}
			else {
				reflection->ListFields(message, &fields);
			}

			for (const FieldDescriptor* field : fields) {
				NomalizeNumberField(message, reflection, field);
			}
		}
	}
}
