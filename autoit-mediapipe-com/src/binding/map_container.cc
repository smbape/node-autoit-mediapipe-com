#include "mediapipe/framework/port/status_macros.h"
#include "binding/map_container.h"
#include "Google_Protobuf_Message_Object.h"

namespace {
	inline void assign(_variant_t& dst, const _variant_t& src) {
		VARIANT* pdst = &dst;
		_Copy<VARIANT>::destroy(pdst);
		_Copy<VARIANT>::copy(pdst, &src);
	}
}

namespace google::protobuf {
	autoit::MapIterator MapRefectionFriend::begin(autoit::MapContainer* self) {
		Message* message = self->message.get();
		const FieldDescriptor* field_descriptor = self->field_descriptor.get();
		const Reflection* reflection = message->GetReflection();
		MapIterator begin = reflection->MapBegin(message, field_descriptor);
		return autoit::MapIterator(self, std::move(begin));
	}

	autoit::MapIterator MapRefectionFriend::end(autoit::MapContainer* self) {
		Message* message = self->message.get();
		const FieldDescriptor* field_descriptor = self->field_descriptor.get();
		const Reflection* reflection = message->GetReflection();
		MapIterator end = reflection->MapEnd(message, field_descriptor);
		return autoit::MapIterator(self, std::move(end));
	}

	absl::StatusOr<std::string> MapRefectionFriend::ToStr(const autoit::MapContainer* self) {
		Message* message = self->message.get();
		const FieldDescriptor* field_descriptor = self->field_descriptor.get();

		std::string output;

		const Reflection* reflection = message->GetReflection();
		for (::google::protobuf::MapIterator it = reflection->MapBegin(message, field_descriptor);
			it != reflection->MapEnd(message, field_descriptor);
			++it
		) {
			MP_ASSIGN_OR_RETURN(auto key, autoit::MapKeyToAnyObject(field_descriptor, it.GetKey()));
			MP_ASSIGN_OR_RETURN(auto value, autoit::MapValueRefToAnyObject(field_descriptor, it.GetValueRef()));
			// TODO
		}

		return output;
	}

	absl::StatusOr<bool> MapRefectionFriend::Contains(const autoit::MapContainer* self, _variant_t key) {
		Message* message = self->message.get();
		const FieldDescriptor* field_descriptor = self->field_descriptor.get();
		const Reflection* reflection = message->GetReflection();
		MapKey map_key;
		MP_RETURN_IF_ERROR(autoit::AnyObjectToMapKey(field_descriptor, key, &map_key));
		return reflection->ContainsMapKey(*message, field_descriptor, map_key);
	}

	size_t MapRefectionFriend::Size(const autoit::MapContainer* self) {
		Message* message = self->message.get();
		const FieldDescriptor* field_descriptor = self->field_descriptor.get();
		const Reflection* reflection = message->GetReflection();
		return reflection->MapSize(*message, field_descriptor);
	}

	absl::StatusOr<_variant_t> MapRefectionFriend::GetItem(const autoit::MapContainer* self, _variant_t key) {
		Message* message = self->message.get();
		const FieldDescriptor* field_descriptor = self->field_descriptor.get();
		const Reflection* reflection = message->GetReflection();
		MapKey map_key;
		MapValueRef value;
		MP_RETURN_IF_ERROR(autoit::AnyObjectToMapKey(field_descriptor, key, &map_key));
		reflection->InsertOrLookupMapValue(message, field_descriptor, map_key, &value);
		return autoit::MapValueRefToAnyObject(field_descriptor, value);
	}

	absl::Status MapRefectionFriend::SetItem(autoit::MapContainer* self, _variant_t key, _variant_t arg) {
		Message* message = self->message.get();
		const FieldDescriptor* field_descriptor = self->field_descriptor.get();
		const Reflection* reflection = message->GetReflection();
		MapKey map_key;
		MapValueRef value;
		MP_RETURN_IF_ERROR(autoit::AnyObjectToMapKey(field_descriptor, key, &map_key));

		if (PARAMETER_NULL(&arg)) {
			MP_ASSERT_RETURN_IF_ERROR(reflection->DeleteMapValue(message, field_descriptor, map_key), "Key not present in map");
			return absl::OkStatus();
		}

		reflection->InsertOrLookupMapValue(message, field_descriptor, map_key, &value);
		MP_RETURN_IF_ERROR(autoit::AnyObjectToMapValueRef(field_descriptor, arg, reflection->SupportsUnknownEnumValues(), &value));
		return absl::OkStatus();
	}

	namespace autoit {
		MapIterator::MapIterator(
			MapContainer* container,
			const ::google::protobuf::MapIterator&& iter
		) {
			m_container = container;
			m_iter = std::move(std::make_unique<::google::protobuf::MapIterator>(std::move(iter)));
		}

		MapIterator::MapIterator(const MapIterator& other) {
			m_container = other.m_container;
			m_iter = std::move(std::make_unique<::google::protobuf::MapIterator>(*other.m_iter));
		}

		MapIterator& MapIterator::operator=(const MapIterator& other) {
			m_container = other.m_container;
			m_iter = std::move(std::make_unique<::google::protobuf::MapIterator>(*other.m_iter));
			return *this;
		}

		MapIterator& MapIterator::operator++() noexcept {
			++(*m_iter);
			m_dirty = true;
			return *this;
		}

		MapIterator MapIterator::operator++(int) noexcept {
			MapIterator _Tmp = *this;
			++*this;
			return _Tmp;
		}

		bool MapIterator::operator==(const MapIterator& other) const noexcept {
			return *m_iter == *other.m_iter;
		}

		bool MapIterator::operator!=(const MapIterator& other) const noexcept {
			return *m_iter != *other.m_iter;
		}

		const std::pair<_variant_t, _variant_t>& MapIterator::operator*() noexcept {
			if (m_dirty) {
				MP_ASSIGN_OR_THROW(auto key, MapKeyToAnyObject(m_container->field_descriptor.get(), m_iter->GetKey())); // Throwing because I failed to make COM STL Enum handle absl::StatusOr
				MP_ASSIGN_OR_THROW(auto value, MapValueRefToAnyObject(m_container->field_descriptor.get(), m_iter->GetValueRef())); // Throwing because I failed to make COM STL Enum handle absl::StatusOr
				assign(m_value.first, key);
				assign(m_value.second, value);
				m_dirty = false;
			}
			return m_value;
		}

		MapIterator MapContainer::begin() {
			return ::google::protobuf::MapRefectionFriend::begin(this);
		}

		MapIterator MapContainer::end() {
			return ::google::protobuf::MapRefectionFriend::end(this);
		}

		absl::Status AnyObjectToMapKey(const FieldDescriptor* parent_field_descriptor, _variant_t arg, MapKey* key) {
			const FieldDescriptor* field_descriptor =
				parent_field_descriptor->message_type()->map_key();

			switch (field_descriptor->cpp_type()) {
				case FieldDescriptor::CPPTYPE_INT32: {
					auto value = ::autoit::cast<int>(&arg);
					key->SetInt32Value(value);
					break;
				}
				case FieldDescriptor::CPPTYPE_INT64: {
					auto value = ::autoit::cast<int64_t>(&arg);
					key->SetInt64Value(value);
					break;
				}
				case FieldDescriptor::CPPTYPE_UINT32: {
					auto value = ::autoit::cast<uint>(&arg);
					key->SetUInt32Value(value);
					break;
				}
				case FieldDescriptor::CPPTYPE_UINT64: {
					auto value = ::autoit::cast<uint64_t>(&arg);
					key->SetUInt64Value(value);
					break;
				}
				case FieldDescriptor::CPPTYPE_BOOL: {
					auto value = ::autoit::cast<bool>(&arg);
					key->SetBoolValue(value);
					break;
				}
				case FieldDescriptor::CPPTYPE_STRING: {
					auto value = ::autoit::cast<std::string>(&arg);
					key->SetStringValue(value);
					break;
				}
				default:
					MP_ASSERT_RETURN_IF_ERROR(false, "Type " << field_descriptor->cpp_type() << " cannot be a map key");
			}

			return absl::OkStatus();
		}

		absl::Status AnyObjectToMapValueRef(const FieldDescriptor* parent_field_descriptor, _variant_t arg,
			bool allow_unknown_enum_values,
			MapValueRef* value_ref) {
			const FieldDescriptor* field_descriptor =
				parent_field_descriptor->message_type()->map_value();
			switch (field_descriptor->cpp_type()) {
				case FieldDescriptor::CPPTYPE_INT32: {
					auto value = ::autoit::cast<int>(&arg);
					value_ref->SetInt32Value(value);
					break;
				}
				case FieldDescriptor::CPPTYPE_INT64: {
					auto value = ::autoit::cast<int64_t>(&arg);
					value_ref->SetInt64Value(value);
					break;
				}
				case FieldDescriptor::CPPTYPE_UINT32: {
					auto value = ::autoit::cast<uint>(&arg);
					value_ref->SetUInt32Value(value);
					break;
				}
				case FieldDescriptor::CPPTYPE_UINT64: {
					auto value = ::autoit::cast<uint64_t>(&arg);
					value_ref->SetUInt64Value(value);
					break;
				}
				case FieldDescriptor::CPPTYPE_FLOAT: {
					auto value = ::autoit::cast<float>(&arg);
					value_ref->SetFloatValue(value);
					break;
				}
				case FieldDescriptor::CPPTYPE_DOUBLE: {
					auto value = ::autoit::cast<double>(&arg);
					value_ref->SetDoubleValue(value);
					break;
				}
				case FieldDescriptor::CPPTYPE_BOOL: {
					auto value = ::autoit::cast<bool>(&arg);
					value_ref->SetBoolValue(value);
					break;
				}
				case FieldDescriptor::CPPTYPE_STRING: {
					auto value = ::autoit::cast<std::string>(&arg);
					value_ref->SetStringValue(value);
					break;
				}
				case FieldDescriptor::CPPTYPE_ENUM: {
					auto value = ::autoit::cast<int>(&arg);
					if (allow_unknown_enum_values) {
						value_ref->SetEnumValue(value);
					} else {
						const EnumDescriptor* enum_descriptor = field_descriptor->enum_type();
						const EnumValueDescriptor* enum_value =
							enum_descriptor->FindValueByNumber(value);

						MP_ASSERT_RETURN_IF_ERROR(enum_value, "Unknown enum value: " << value);
						value_ref->SetEnumValue(value);
					}
					break;
				}
				case FieldDescriptor::CPPTYPE_MESSAGE: {
					MP_ASSERT_RETURN_IF_ERROR(false, "Direct assignment of submessage not allowed");
				}
				default:
					MP_ASSERT_RETURN_IF_ERROR(false, "Setting value to a field of unknown type " << field_descriptor->cpp_type());
			}

			return absl::OkStatus();
		}

		absl::StatusOr<_variant_t> MapKeyToAnyObject(const FieldDescriptor* parent_field_descriptor, const MapKey& key) {
			_variant_t obj;
			VARIANT* out_val = &obj;
			VariantInit(out_val);
			HRESULT hr;

			const FieldDescriptor* field_descriptor =
				parent_field_descriptor->message_type()->map_key();

			switch (field_descriptor->cpp_type()) {
				case FieldDescriptor::CPPTYPE_INT32:
					hr = autoit_from(key.GetInt32Value(), out_val);
				case FieldDescriptor::CPPTYPE_INT64:
					hr = autoit_from(key.GetInt64Value(), out_val);
				case FieldDescriptor::CPPTYPE_UINT32:
					hr = autoit_from(key.GetUInt32Value(), out_val);
				case FieldDescriptor::CPPTYPE_UINT64:
					hr = autoit_from(key.GetUInt64Value(), out_val);
				case FieldDescriptor::CPPTYPE_BOOL:
					hr = autoit_from(key.GetBoolValue(), out_val);
				case FieldDescriptor::CPPTYPE_STRING:
					hr = autoit_from(key.GetStringValue(), out_val);
				default:
					hr = E_FAIL;
			}

			MP_ASSERT_RETURN_IF_ERROR(SUCCEEDED(hr), "Couldn't convert type " << field_descriptor->cpp_type() << " to value");
			return obj;
		}

		absl::StatusOr<_variant_t> MapValueRefToAnyObject(const FieldDescriptor* parent_field_descriptor, const MapValueRef& value) {
			_variant_t obj;
			VARIANT* out_val = &obj;
			VariantInit(out_val);
			HRESULT hr;

			const FieldDescriptor* field_descriptor =
				parent_field_descriptor->message_type()->map_value();
			switch (field_descriptor->cpp_type()) {
			case FieldDescriptor::CPPTYPE_INT32:
				hr = autoit_from(value.GetInt32Value(), out_val);
			case FieldDescriptor::CPPTYPE_INT64:
				hr = autoit_from(value.GetInt64Value(), out_val);
			case FieldDescriptor::CPPTYPE_UINT32:
				hr = autoit_from(value.GetUInt32Value(), out_val);
			case FieldDescriptor::CPPTYPE_UINT64:
				hr = autoit_from(value.GetUInt64Value(), out_val);
			case FieldDescriptor::CPPTYPE_FLOAT:
				hr = autoit_from(value.GetFloatValue(), out_val);
			case FieldDescriptor::CPPTYPE_DOUBLE:
				hr = autoit_from(value.GetDoubleValue(), out_val);
			case FieldDescriptor::CPPTYPE_BOOL:
				hr = autoit_from(value.GetBoolValue(), out_val);
			case FieldDescriptor::CPPTYPE_STRING:
				hr = autoit_from(value.GetStringValue(), out_val);
			case FieldDescriptor::CPPTYPE_ENUM:
				hr = autoit_from(value.GetEnumValue(), out_val);
			case FieldDescriptor::CPPTYPE_MESSAGE: {
				hr = autoit_from(::autoit::reference_internal(&value.GetMessageValue()), out_val);
			}
			default:
				hr = E_FAIL;
			}

			MP_ASSERT_RETURN_IF_ERROR(SUCCEEDED(hr), "Couldn't convert type " << field_descriptor->cpp_type() << " to value");
			return obj;
		}

		absl::StatusOr<bool> MapContainer::Contains(_variant_t key) const {
			return ::google::protobuf::MapRefectionFriend::Contains(this, key);
		}

		void MapContainer::Clear() {
			const Reflection* reflection = message->GetReflection();
			reflection->ClearField(message.get(), field_descriptor.get());
		}

		size_t MapContainer::Length() const {
			return ::google::protobuf::MapRefectionFriend::Size(this);
		}

		size_t MapContainer::size() const {
			return ::google::protobuf::MapRefectionFriend::Size(this);
		}

		absl::StatusOr<_variant_t> MapContainer::Get(_variant_t key, _variant_t default_value) const {
			MP_ASSIGN_OR_RETURN(auto contains, ::google::protobuf::MapRefectionFriend::Contains(this, key));
			if (contains) {
				return GetItem(key);
			}
			return default_value;
		}

		absl::StatusOr<_variant_t> MapContainer::GetItem(_variant_t key) const {
			return ::google::protobuf::MapRefectionFriend::GetItem(this, key);
		}

		absl::Status MapContainer::SetItem(_variant_t key, _variant_t arg) {
			return ::google::protobuf::MapRefectionFriend::SetItem(this, key, arg);
		}

		absl::Status MapContainer::SetFields(std::vector<std::pair<_variant_t, _variant_t>>& fields) {
			for (auto& [key, arg] : fields) {
				MP_RETURN_IF_ERROR(::google::protobuf::MapRefectionFriend::SetItem(this, key, arg));
			}
			return absl::OkStatus();
		}

		absl::StatusOr<std::string> MapContainer::ToStr() const {
			return ::google::protobuf::MapRefectionFriend::ToStr(this);
		}

		absl::Status MapContainer::MergeFrom(const MapContainer& other) {
			MP_ASSERT_RETURN_IF_ERROR(message->GetDescriptor() == other.message->GetDescriptor(),
				"Parameter to MergeFrom() must be instance of same class: "
				"expected " << message->GetDescriptor()->full_name() << " got " << other.message->GetDescriptor()->full_name() << ".");
			message->MergeFrom(*other.message.get());
			return absl::OkStatus();
		}
	}
}
