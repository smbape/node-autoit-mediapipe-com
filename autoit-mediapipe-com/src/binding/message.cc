#include "binding/message.h"
#include "binding/map_container.h"
#include "binding/repeated_container.h"
#include "Google_Protobuf_Autoit_MapContainer_Object.h"
#include "Google_Protobuf_Autoit_RepeatedContainer_Object.h"
#include "Google_Protobuf_Message_Object.h"

// https://github.com/protocolbuffers/protobuf/issues/5051
#ifdef GetMessage
#undef GetMessage
#endif

using namespace google::protobuf;

namespace google {
	namespace protobuf {
		// hack to access MapReflection private members
		template<>
		class MutableRepeatedFieldRef<Message, void> {
		public:
			static void UnsafeShallowSwapFields(
				Message* lhs, Message* rhs,
				const std::vector<const FieldDescriptor*>& fields) {
				lhs->GetReflection()->UnsafeShallowSwapFields(lhs, rhs, fields);
			}
			static bool IsLazyField(const Reflection* reflection, const Message& message,
				const FieldDescriptor* field) {
				return reflection->IsLazyField(field) ||
					reflection->IsLazyExtension(message, field);
			}
		};

		using MessageReflectionFriend = MutableRepeatedFieldRef<Message, void>;

		namespace autoit {
			namespace cmessage {
				inline static _variant_t default_variant() {
					_variant_t vtDefault;
					V_VT(&vtDefault) = VT_ERROR;
					V_ERROR(&vtDefault) = DISP_E_PARAMNOTFOUND;
					return vtDefault;
				}

				static _variant_t None = default_variant();

				const std::string ToStr(const Message& message) {
					TextFormat::Printer printer;
					printer.SetHideUnknownFields(true);
					std::string output;
					AUTOIT_ASSERT_THROW(printer.PrintToString(message, &output), "Unable to convert message to str");
					return output;
				}

				const FieldDescriptor* FindFieldWithOneofs(
					const Message& message,
					const std::string& field_name,
					bool* in_oneof
				) {
					*in_oneof = false;
					const Descriptor* descriptor = message.GetDescriptor();
					const FieldDescriptor* field_descriptor =
						descriptor->FindFieldByName(field_name);
					if (field_descriptor != NULL) {
						return field_descriptor;
					}
					const OneofDescriptor* oneof_desc =
						descriptor->FindOneofByName(field_name);
					if (oneof_desc != NULL) {
						*in_oneof = true;
						return message.GetReflection()->GetOneofFieldDescriptor(message, oneof_desc);
					}
					return NULL;
				}

				bool CheckHasPresence(const FieldDescriptor* field_descriptor, bool in_oneof) {
					auto message_name = field_descriptor->containing_type()->name();

					AUTOIT_ASSERT_THROW(!field_descriptor->is_repeated(),
						"Protocol message " << message_name << " has no singular \"" << field_descriptor->name() << "\" field.");

					AUTOIT_ASSERT_THROW(field_descriptor->has_presence(),
						"Can't test non-optional, non-submessage field \"" << message_name << "." << field_descriptor->name() << "\" for "
						"presence in proto3.");

					return true;
				}

				static const FieldDescriptor* GetFieldDescriptor(
					const Message& message,
					const std::string& field_name,
					bool& is_in_oneof
				) {
					const FieldDescriptor* field_descriptor =
						FindFieldWithOneofs(message, field_name, &is_in_oneof);

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
						auto value = ::autoit::cast<int64>(&arg);
						reflection->SetInt64(message, field_descriptor, value);
						break;
					}
					case FieldDescriptor::CPPTYPE_UINT32: {
						auto value = ::autoit::cast<uint>(&arg);
						reflection->SetUInt32(message, field_descriptor, value);
						break;
					}
					case FieldDescriptor::CPPTYPE_UINT64: {
						auto value = ::autoit::cast<uint64>(&arg);
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
					_variant_t obj;
					VARIANT* out_val = &obj;
					VariantInit(out_val);

					const Reflection* reflection = message.GetReflection();
					if (!CheckFieldBelongsToMessage(message, field_descriptor)) {
						V_VT(&obj) = VT_NULL;
						return obj;
					}

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

				_variant_t InternalGetSubMessage(
					const Message& message,
					const FieldDescriptor* field_descriptor
				) {
					_variant_t obj;
					VARIANT* out_val = &obj;
					VariantInit(out_val);

					const Reflection* reflection = message.GetReflection();
					HRESULT hr = S_OK;

					if (reflection->HasField(message, field_descriptor) &&
						MessageReflectionFriend::IsLazyField(reflection, message, field_descriptor)) {
						Message* sub_message = reflection->MutableMessage(const_cast<Message*>(&message), field_descriptor);
						hr = autoit_from(::autoit::reference_internal(sub_message), out_val);
					}
					else {
						const Message& sub_message = reflection->GetMessage(message, field_descriptor);
						hr = autoit_from(::autoit::reference_internal(&sub_message), out_val);
					}

					if (FAILED(hr)) {
						AUTOIT_THROW("Getting sub message failed");
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

					if (field_descriptor->is_map()) {
						MapContainer autoit_container;
						autoit_container.message = ::autoit::reference_internal(&message);
						autoit_container.field_descriptor = ::autoit::reference_internal(field_descriptor);
						autoit_from(autoit_container, out_val);
					}
					else if (field_descriptor->is_repeated()) {
						RepeatedContainer autoit_container;
						autoit_container.message = ::autoit::reference_internal(&message);
						autoit_container.field_descriptor = ::autoit::reference_internal(field_descriptor);
						autoit_from(autoit_container, out_val);
					}
					else if (field_descriptor->cpp_type() ==
						FieldDescriptor::CPPTYPE_MESSAGE) {
						return InternalGetSubMessage(message, field_descriptor);
					}
					else {
						AUTOIT_THROW("Should never happen");
					}

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

				void MergeFromString(Message* message, const std::string& data) {
					int depth = io::CodedInputStream::GetDefaultRecursionLimit();
					const char* ptr;
					internal::ParseContext ctx(depth, false, &ptr, StringPiece(data));

					ptr = message->_InternalParse(ptr, &ctx);
					AUTOIT_ASSERT_THROW(ptr != nullptr && ctx.BytesUntilLimit(ptr) > 0,
						"Error parsing message with type '" << message->GetDescriptor()->full_name() << "'");

					AUTOIT_ASSERT_THROW(ctx.EndedAtLimit(), "Unexpected end-group tag: Not all data was converted");
				}
			}
		}
	}
}
