#include "binding/map_container.h"
#include "Google_Protobuf_Message_Object.h"

namespace google {
	namespace protobuf {
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

		std::string MapRefectionFriend::ToStr(const autoit::MapContainer* self) {
			Message* message = self->message.get();
			const FieldDescriptor* field_descriptor = self->field_descriptor.get();

			std::string output;

			const Reflection* reflection = message->GetReflection();
			for (::google::protobuf::MapIterator it = reflection->MapBegin(message, field_descriptor);
				it != reflection->MapEnd(message, field_descriptor);
				++it
			) {
				_variant_t key = autoit::MapKeyToAutoIt(field_descriptor, it.GetKey());
				_variant_t value = autoit::MapValueRefToAutoIt(field_descriptor, it.GetValueRef());
				// TODO
			}

			return output;
		}

		bool MapRefectionFriend::Contains(const autoit::MapContainer* self, _variant_t key) {
			Message* message = self->message.get();
			const FieldDescriptor* field_descriptor = self->field_descriptor.get();
			const Reflection* reflection = message->GetReflection();
			MapKey map_key;
			autoit::AutoItToMapKey(field_descriptor, key, &map_key);
			return reflection->ContainsMapKey(*message, field_descriptor, map_key);
		}

		size_t MapRefectionFriend::Size(const autoit::MapContainer* self) {
			Message* message = self->message.get();
			const FieldDescriptor* field_descriptor = self->field_descriptor.get();
			const Reflection* reflection = message->GetReflection();
			return reflection->MapSize(*message, field_descriptor);
		}

		_variant_t MapRefectionFriend::GetItem(const autoit::MapContainer* self, _variant_t key) {
			Message* message = self->message.get();
			const FieldDescriptor* field_descriptor = self->field_descriptor.get();
			const Reflection* reflection = message->GetReflection();
			MapKey map_key;
			MapValueRef value;
			autoit::AutoItToMapKey(field_descriptor, key, &map_key);
			reflection->InsertOrLookupMapValue(message, field_descriptor, map_key, &value);
			return autoit::MapValueRefToAutoIt(field_descriptor, value);
		}

		void MapRefectionFriend::SetItem(autoit::MapContainer* self, _variant_t key, _variant_t arg) {
			Message* message = self->message.get();
			const FieldDescriptor* field_descriptor = self->field_descriptor.get();
			const Reflection* reflection = message->GetReflection();
			MapKey map_key;
			MapValueRef value;
			autoit::AutoItToMapKey(field_descriptor, key, &map_key);

			if (PARAMETER_NULL(&arg)) {
				AUTOIT_ASSERT_THROW(reflection->DeleteMapValue(message, field_descriptor, map_key), "Key not present in map");
				return;
			}

			reflection->InsertOrLookupMapValue(message, field_descriptor, map_key, &value);
			autoit::AutoItToMapValueRef(field_descriptor, arg, reflection->SupportsUnknownEnumValues(), &value);
		}

		namespace autoit {
			static _variant_t _none;

			_variant_t noValue() {
				VariantInit(&_none);
				V_VT(&_none) = VT_ERROR;
				V_ERROR(&_none) = DISP_E_PARAMNOTFOUND;
				return _none;
			}

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

			inline static void assign(_variant_t& dst, const _variant_t& src) {
				VARIANT* pdst = &dst;
				_Copy<VARIANT>::destroy(pdst);
				_Copy<VARIANT>::copy(pdst, &src);
			}

			const std::pair<_variant_t, _variant_t>& MapIterator::operator*() noexcept {
				if (m_dirty) {
					assign(m_value.first, MapKeyToAutoIt(m_container->field_descriptor.get(), m_iter->GetKey()));
					assign(m_value.second, MapValueRefToAutoIt(m_container->field_descriptor.get(), m_iter->GetValueRef()));
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

			bool AutoItToMapKey(const FieldDescriptor* parent_field_descriptor, _variant_t arg, MapKey* key) {
				const FieldDescriptor* field_descriptor =
					parent_field_descriptor->message_type()->map_key();

				switch (field_descriptor->cpp_type()) {
					case FieldDescriptor::CPPTYPE_INT32: {
						auto value = ::autoit::cast<int>(&arg);
						key->SetInt32Value(value);
						break;
					}
					case FieldDescriptor::CPPTYPE_INT64: {
						auto value = ::autoit::cast<int64>(&arg);
						key->SetInt64Value(value);
						break;
					}
					case FieldDescriptor::CPPTYPE_UINT32: {
						auto value = ::autoit::cast<uint>(&arg);
						key->SetUInt32Value(value);
						break;
					}
					case FieldDescriptor::CPPTYPE_UINT64: {
						auto value = ::autoit::cast<uint64>(&arg);
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
						AUTOIT_THROW("Type " << field_descriptor->cpp_type() << " cannot be a map key");
				}

				return true;
			}

			bool AutoItToMapValueRef(const FieldDescriptor* parent_field_descriptor, _variant_t arg,
				bool allow_unknown_enum_values,
				MapValueRef* value_ref) {
				const FieldDescriptor* field_descriptor =
					parent_field_descriptor->message_type()->map_value();
				switch (field_descriptor->cpp_type()) {
					case FieldDescriptor::CPPTYPE_INT32: {
						auto value = ::autoit::cast<int>(&arg);
						value_ref->SetInt32Value(value);
						return true;
					}
					case FieldDescriptor::CPPTYPE_INT64: {
						auto value = ::autoit::cast<int64>(&arg);
						value_ref->SetInt64Value(value);
						return true;
					}
					case FieldDescriptor::CPPTYPE_UINT32: {
						auto value = ::autoit::cast<uint>(&arg);
						value_ref->SetUInt32Value(value);
						return true;
					}
					case FieldDescriptor::CPPTYPE_UINT64: {
						auto value = ::autoit::cast<uint64>(&arg);
						value_ref->SetUInt64Value(value);
						return true;
					}
					case FieldDescriptor::CPPTYPE_FLOAT: {
						auto value = ::autoit::cast<float>(&arg);
						value_ref->SetFloatValue(value);
						return true;
					}
					case FieldDescriptor::CPPTYPE_DOUBLE: {
						auto value = ::autoit::cast<double>(&arg);
						value_ref->SetDoubleValue(value);
						return true;
					}
					case FieldDescriptor::CPPTYPE_BOOL: {
						auto value = ::autoit::cast<bool>(&arg);
						value_ref->SetBoolValue(value);
						return true;;
					}
					case FieldDescriptor::CPPTYPE_STRING: {
						auto value = ::autoit::cast<std::string>(&arg);
						value_ref->SetStringValue(value);
						return true;
					}
					case FieldDescriptor::CPPTYPE_ENUM: {
						auto value = ::autoit::cast<int>(&arg);
						if (allow_unknown_enum_values) {
							value_ref->SetEnumValue(value);
							return true;
						}

						const EnumDescriptor* enum_descriptor = field_descriptor->enum_type();
						const EnumValueDescriptor* enum_value =
							enum_descriptor->FindValueByNumber(value);

						AUTOIT_ASSERT_THROW(enum_value, "Unknown enum value: " << value);
						value_ref->SetEnumValue(value);
						return true;
					}
					case FieldDescriptor::CPPTYPE_MESSAGE: {
						AUTOIT_THROW("Direct assignment of submessage not allowed");
					}
					default:
						AUTOIT_THROW("Setting value to a field of unknown type " << field_descriptor->cpp_type());
						return false;
				}
			}

			_variant_t MapKeyToAutoIt(const FieldDescriptor* parent_field_descriptor, const MapKey& key) {
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

				if (FAILED(hr)) {
					AUTOIT_THROW("Couldn't convert type " << field_descriptor->cpp_type() << " to value");
				}

				return obj;
			}

			_variant_t MapValueRefToAutoIt(const FieldDescriptor* parent_field_descriptor, const MapValueRef& value) {
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

				if (FAILED(hr)) {
					AUTOIT_THROW("Couldn't convert type " << field_descriptor->cpp_type() << " to value");
				}

				return obj;
			}

			bool MapContainer::Contains(_variant_t key) const {
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

			_variant_t MapContainer::Get(_variant_t key, _variant_t default_value) const {
				if (::google::protobuf::MapRefectionFriend::Contains(this, key)) {
					return GetItem(key);
				}
				return default_value;
			}

			_variant_t MapContainer::GetItem(_variant_t key) const {
				return ::google::protobuf::MapRefectionFriend::GetItem(this, key);
			}

			void MapContainer::SetItem(_variant_t key, _variant_t arg) {
				::google::protobuf::MapRefectionFriend::SetItem(this, key, arg);
			}

			std::string MapContainer::ToStr() const {
				return ::google::protobuf::MapRefectionFriend::ToStr(this);
			}

			void MapContainer::MergeFrom(const MapContainer& other) {
				AUTOIT_ASSERT_THROW(message->GetDescriptor() == other.message->GetDescriptor(),
					"Parameter to MergeFrom() must be instance of same class: "
					"expected " << message->GetDescriptor()->full_name() << " got " << other.message->GetDescriptor()->full_name() << ".");
				message->MergeFrom(*other.message.get());
			}
		}
	}
}
