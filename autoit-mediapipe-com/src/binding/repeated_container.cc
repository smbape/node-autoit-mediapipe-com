#include "binding/repeated_container.h"
#include "binding/message.h"
#include "Google_Protobuf_Message_Object.h"

namespace google {
	namespace protobuf {
		namespace autoit {
			static void InternalAssignRepeatedField(RepeatedContainer* self, const std::vector<_variant_t>& list) {
				Message* message = self->message.get();
				message->GetReflection()->ClearField(message, self->field_descriptor.get());
				for (const auto& value : list) {
					self->Append(value);
				}
			}

			RepeatedIterator& RepeatedIterator::operator++() noexcept {
				++m_iter;
				m_dirty = true;
				return *this;
			}

			RepeatedIterator RepeatedIterator::operator++(int) noexcept {
				RepeatedIterator _Tmp = *this;
				++*this;
				return _Tmp;
			}

			bool RepeatedIterator::operator==(const autoit::RepeatedIterator& b) const noexcept {
				return m_iter == b.m_iter;
			}

			bool RepeatedIterator::operator!=(const autoit::RepeatedIterator& b) const noexcept {
				return m_iter != b.m_iter;
			}

			const _variant_t& RepeatedIterator::operator*() noexcept {
				if (m_dirty) {
					VARIANT* pv = &m_value;
					_Copy<VARIANT>::destroy(pv);
					_variant_t result = container->GetItem(m_iter);
					_Copy<VARIANT>::copy(pv, &result);
					m_dirty = false;
				}
				return m_value;
			}

			size_t RepeatedContainer::Length() const {
				return size();
			}

			size_t RepeatedContainer::size() const {
				const Message* message = this->message.get();
				const FieldDescriptor* field_descriptor = this->field_descriptor.get();
				return message->GetReflection()->FieldSize(*message, field_descriptor);
			}

			_variant_t RepeatedContainer::GetItem(SSIZE_T index) const {
				const Message* message = this->message.get();
				const FieldDescriptor* field_descriptor = this->field_descriptor.get();
				const Reflection* reflection = message->GetReflection();

				int field_size = reflection->FieldSize(*message, field_descriptor);

				if (index < 0) {
					index += field_size;
				}

				AUTOIT_ASSERT_THROW(index >= 0 && index < field_size, "list index (" << index << ") out of range");

				_variant_t obj;
				VARIANT* out_val = &obj;
				VariantInit(out_val);
				HRESULT hr;

				switch (field_descriptor->cpp_type()) {
				case FieldDescriptor::CPPTYPE_INT32: {
					hr = autoit_from(reflection->GetRepeatedInt32(*message, field_descriptor, index), out_val);
					break;
				}
				case FieldDescriptor::CPPTYPE_INT64: {
					hr = autoit_from(reflection->GetRepeatedInt64(*message, field_descriptor, index), out_val);
					break;
				}
				case FieldDescriptor::CPPTYPE_UINT32: {
					hr = autoit_from(reflection->GetRepeatedUInt32(*message, field_descriptor, index), out_val);
					break;
				}
				case FieldDescriptor::CPPTYPE_UINT64: {
					hr = autoit_from(reflection->GetRepeatedUInt64(*message, field_descriptor, index), out_val);
					break;
				}
				case FieldDescriptor::CPPTYPE_FLOAT: {
					hr = autoit_from(reflection->GetRepeatedFloat(*message, field_descriptor, index), out_val);
					break;
				}
				case FieldDescriptor::CPPTYPE_DOUBLE: {
					hr = autoit_from(reflection->GetRepeatedDouble(*message, field_descriptor, index), out_val);
					break;
				}
				case FieldDescriptor::CPPTYPE_BOOL: {
					hr = autoit_from(reflection->GetRepeatedBool(*message, field_descriptor, index), out_val);
					break;
				}
				case FieldDescriptor::CPPTYPE_ENUM: {
					const EnumValueDescriptor* enum_value = reflection->GetRepeatedEnum(*message, field_descriptor, index);
					hr = autoit_from(enum_value->number(), out_val);
					break;
				}
				case FieldDescriptor::CPPTYPE_STRING: {
					std::string scratch;
					const std::string& value = reflection->GetRepeatedStringReference(
						*message, field_descriptor, index, &scratch);
					hr = autoit_from(value, out_val);
					break;
				}
				case FieldDescriptor::CPPTYPE_MESSAGE: {
					Message* sub_message = reflection->MutableRepeatedMessage(const_cast<Message*>(message), field_descriptor, index);
					hr = autoit_from(::autoit::reference_internal(sub_message), out_val);
					break;
				}
				default:
					hr = E_FAIL;
				}

				if (FAILED(hr)) {
					AUTOIT_THROW("Getting value from a repeated field of unknown type " << field_descriptor->cpp_type());
				}

				return obj;
			}

			void RepeatedContainer::SetItem(SSIZE_T index, _variant_t arg) {
				Message* message = this->message.get();
				const FieldDescriptor* field_descriptor = this->field_descriptor.get();
				const Reflection* reflection = message->GetReflection();

				int field_size = reflection->FieldSize(*message, field_descriptor);

				if (index < 0) {
					index += field_size;
				}

				AUTOIT_ASSERT_THROW(index >= 0 && index < field_size, "list index (" << index << ") out of range");

				if (PARAMETER_NULL(&arg)) {
					std::vector<_variant_t> list;
					Splice(list, index, 1);
					return;
				}

				switch (field_descriptor->cpp_type()) {
				case FieldDescriptor::CPPTYPE_INT32: {
					auto value = ::autoit::cast<int>(&arg);
					reflection->SetRepeatedInt32(message, field_descriptor, index, value);
					return;
				}
				case FieldDescriptor::CPPTYPE_INT64: {
					auto value = ::autoit::cast<int64>(&arg);
					reflection->SetRepeatedInt64(message, field_descriptor, index, value);
					return;
				}
				case FieldDescriptor::CPPTYPE_UINT32: {
					auto value = ::autoit::cast<uint>(&arg);
					reflection->SetRepeatedUInt32(message, field_descriptor, index, value);
					return;
				}
				case FieldDescriptor::CPPTYPE_UINT64: {
					auto value = ::autoit::cast<uint64>(&arg);
					reflection->SetRepeatedUInt64(message, field_descriptor, index, value);
					return;
				}
				case FieldDescriptor::CPPTYPE_FLOAT: {
					auto value = ::autoit::cast<float>(&arg);
					reflection->SetRepeatedFloat(message, field_descriptor, index, value);
					return;
				}
				case FieldDescriptor::CPPTYPE_DOUBLE: {
					auto value = ::autoit::cast<double>(&arg);
					reflection->SetRepeatedDouble(message, field_descriptor, index, value);
					return;
				}
				case FieldDescriptor::CPPTYPE_BOOL: {
					auto value = ::autoit::cast<bool>(&arg);
					reflection->SetRepeatedBool(message, field_descriptor, index, value);
					return;
				}
				case FieldDescriptor::CPPTYPE_STRING: {
					auto value = ::autoit::cast<std::string>(&arg);
					reflection->SetRepeatedString(message, field_descriptor, index, std::move(value));
					return;
				}
				case FieldDescriptor::CPPTYPE_ENUM: {
					auto value = ::autoit::cast<int>(&arg);
					if (reflection->SupportsUnknownEnumValues()) {
						reflection->SetRepeatedEnumValue(message, field_descriptor, index, value);
						return;
					}

					const EnumDescriptor* enum_descriptor = field_descriptor->enum_type();
					const EnumValueDescriptor* enum_value = enum_descriptor->FindValueByNumber(value);
					AUTOIT_ASSERT_THROW(enum_value != nullptr, "Unknown enum value: " << value);
					reflection->SetRepeatedEnum(message, field_descriptor, index, enum_value);
					return;
				}
				case FieldDescriptor::CPPTYPE_MESSAGE: {
					AUTOIT_ASSERT_THROW(PARAMETER_NULL(&arg), "does not support assignment");
					Pop(index);
				}
				default:
					AUTOIT_THROW("Adding value to a field of unknown type " << field_descriptor->cpp_type());
				}
			}

			void RepeatedContainer::Splice(std::vector<_variant_t>& list, SSIZE_T start) {
				auto field_size = size();
				if (start < 0) {
					start += field_size;
				}
				Splice(list, start, field_size - start);
			}

			void RepeatedContainer::Splice(std::vector<_variant_t>& list, SSIZE_T start, SSIZE_T deleteCount) {
				list.clear();

				if (deleteCount <= 0) {
					return;
				}

				Message* message = this->message.get();
				const FieldDescriptor* field_descriptor = this->field_descriptor.get();
				const Reflection* reflection = message->GetReflection();

				int field_size = reflection->FieldSize(*message, field_descriptor);

				if (start < 0) {
					start += field_size;
				}

				AUTOIT_ASSERT_THROW(start >= 0 && start < field_size, "splice index out of range");

				if (deleteCount > (field_size - start)) {
					deleteCount = field_size - start;
				}

				int end = start + deleteCount;

				for (int i = start; i < end && i + deleteCount < field_size; i++) {
					reflection->SwapElements(message, field_descriptor, i, i + deleteCount);
				}

				Arena* arena = Arena::InternalHelper<Message>::GetArenaForAllocation(message);
				GOOGLE_DCHECK_EQ(arena, nullptr) << "autoit protobuf is expected to be allocated from heap";

				list.resize(deleteCount);
				_variant_t obj;
				VARIANT* out_val = &obj;
				VariantInit(out_val);
				HRESULT hr;

				// Remove items, starting from the end.
				for (int i = 0; deleteCount > 0; i++, deleteCount--) {
					if (field_descriptor->cpp_type() != FieldDescriptor::CPPTYPE_MESSAGE) {
						list[deleteCount - 1 - i] = GetItem(field_size - 1 - i);
						reflection->RemoveLast(message, field_descriptor);
						continue;
					}

					// It seems that RemoveLast() is less efficient for sub-messages, and
					// the memory is not completely released. Prefer ReleaseLast().
					//
					// To work around a debug hardening (PROTOBUF_FORCE_COPY_IN_RELEASE),
					// explicitly use UnsafeArenaReleaseLast. To not break rare use cases where
					// arena is used, we fallback to ReleaseLast (but GOOGLE_DCHECK to find/fix it).
					//
					// Note that arena is likely null and GOOGLE_DCHECK and ReleaesLast might be
					// redundant. The current approach takes extra cautious path not to disrupt
					// production.
					Message* sub_message =
						(arena == nullptr)
						? reflection->UnsafeArenaReleaseLast(message, field_descriptor)
						: reflection->ReleaseLast(message, field_descriptor);

					// transfert ownership of sub message to list
					hr = autoit_from(std::shared_ptr<Message>(sub_message), out_val);
					AUTOIT_ASSERT_THROW(SUCCEEDED(hr), "Failed to delete message at index " << field_size - 1 - i);
					list[deleteCount - 1 - i] = obj;
				}
			}

			void RepeatedContainer::Slice(std::vector<_variant_t>& list, SSIZE_T start) const {
				int field_size = size();
				if (start < 0) {
					start += field_size;
				}
				Slice(list, start, field_size - start);
			}

			void RepeatedContainer::Slice(std::vector<_variant_t>& list, SSIZE_T start, SSIZE_T count) const {
				list.clear();
				if (count <= 0) {
					return;
				}
				list.resize(count);
				for (size_t i = 0; i < count; i++) {
					list[i] = GetItem(start + i);
				}
			}

			_variant_t RepeatedContainer::DeepCopy() {
				return cmessage::DeepCopy(message.get(), field_descriptor.get());
			}

			Message* RepeatedContainer::Add(std::map<std::string, _variant_t>& attrs) {
				Message* message = this->message.get();
				const FieldDescriptor* field_descriptor = this->field_descriptor.get();
				const Reflection* reflection = message->GetReflection();

				if (field_descriptor->cpp_type() != FieldDescriptor::CPPTYPE_MESSAGE) {
					AUTOIT_THROW("field is not a message field");
				}

				Message* sub_message = reflection->AddMessage(message, field_descriptor);
				cmessage::InitAttributes(*sub_message, attrs);
				return sub_message;
			}

			void RepeatedContainer::Append(_variant_t item) {
				Message* message = this->message.get();
				const FieldDescriptor* field_descriptor = this->field_descriptor.get();
				const Reflection* reflection = message->GetReflection();

				switch (field_descriptor->cpp_type()) {
				case FieldDescriptor::CPPTYPE_INT32: {
					auto value = ::autoit::cast<int>(&item);
					reflection->AddInt32(message, field_descriptor, value);
					return;
				}
				case FieldDescriptor::CPPTYPE_INT64: {
					auto value = ::autoit::cast<int64>(&item);
					reflection->AddInt64(message, field_descriptor, value);
					return;
				}
				case FieldDescriptor::CPPTYPE_UINT32: {
					auto value = ::autoit::cast<uint>(&item);
					reflection->AddUInt32(message, field_descriptor, value);
					return;
				}
				case FieldDescriptor::CPPTYPE_UINT64: {
					auto value = ::autoit::cast<uint64>(&item);
					reflection->AddUInt64(message, field_descriptor, value);
					return;
				}
				case FieldDescriptor::CPPTYPE_FLOAT: {
					auto value = ::autoit::cast<float>(&item);
					reflection->AddFloat(message, field_descriptor, value);
					return;
				}
				case FieldDescriptor::CPPTYPE_DOUBLE: {
					auto value = ::autoit::cast<double>(&item);
					reflection->AddDouble(message, field_descriptor, value);
					return;
				}
				case FieldDescriptor::CPPTYPE_BOOL: {
					auto value = ::autoit::cast<bool>(&item);
					reflection->AddBool(message, field_descriptor, value);
					return;
				}
				case FieldDescriptor::CPPTYPE_STRING: {
					auto value = ::autoit::cast<std::string>(&item);
					reflection->AddString(message, field_descriptor, std::move(value));
					return;
				}
				case FieldDescriptor::CPPTYPE_ENUM: {
					auto value = ::autoit::cast<int>(&item);
					if (reflection->SupportsUnknownEnumValues()) {
						reflection->AddEnumValue(message, field_descriptor, value);
						return;
					}

					const EnumDescriptor* enum_descriptor = field_descriptor->enum_type();
					const EnumValueDescriptor* enum_value = enum_descriptor->FindValueByNumber(value);
					AUTOIT_ASSERT_THROW(enum_value != nullptr, "Unknown enum value: " << value);
					reflection->AddEnum(message, field_descriptor, enum_value);
					return;
				}
				case FieldDescriptor::CPPTYPE_MESSAGE: {
					Message* sub_message = Add();
					std::map<std::string, _variant_t> sub_attrs;
					HRESULT hr = autoit_to(&item, sub_attrs);
					if (SUCCEEDED(hr)) {
						cmessage::InitAttributes(*sub_message, sub_attrs);
					} else {
						auto value = ::autoit::cast<std::shared_ptr<Message>>(&item);
						sub_message->MergeFrom(*value);
					}
				}
				default:
					AUTOIT_THROW("Adding value to a field of unknown type " << field_descriptor->cpp_type());
				}
			}

			void RepeatedContainer::Extend(std::vector<_variant_t>& items) {
				for (auto& item : items) {
					Append(item);
				}
			}

			void RepeatedContainer::Insert(SSIZE_T index, _variant_t item) {
				Message* message = this->message.get();
				const FieldDescriptor* field_descriptor = this->field_descriptor.get();
				const Reflection* reflection = message->GetReflection();

				int field_size = reflection->FieldSize(*message, field_descriptor);
				if (index < 0) {
					index += field_size;
				}

				AUTOIT_ASSERT_THROW(index >= 0 && index <= field_size, "list index (" << index << ") out of range");

				Append(item);

				for (int i = index; i < field_size; i++) {
					reflection->SwapElements(message, field_descriptor, i, field_size);
				}
			}

			void RepeatedContainer::Insert(std::tuple<SSIZE_T, _variant_t>& args) {
				Insert(std::get<0>(args), std::get<1>(args));
			}

			_variant_t RepeatedContainer::Pop(SSIZE_T index) {
				std::vector<_variant_t> list;
				Splice(list, index, 1);
				return list[0];
			}

			typedef bool (*RepeatedContainerComparator)(VARIANT* a, VARIANT* b);

			typedef struct _RepeatedContainerComparatorProxy {
				RepeatedContainerComparator cmp;
				bool operator() (_variant_t& va, _variant_t& vb) {
					VARIANT* pva = &va;
					VARIANT* pvb = &vb;
					return cmp(pva, pvb);
				}
			} RepeatedContainerComparatorProxy;

			void RepeatedContainer::Sort(void* comparator) {
				std::vector<_variant_t> list;
				Slice(list);

				RepeatedContainerComparatorProxy cmp = { reinterpret_cast<RepeatedContainerComparator>(comparator) };
				auto begin = std::begin(list);
				std::sort(begin, begin + list.size(), cmp);

				InternalAssignRepeatedField(this, list);
			}

			void RepeatedContainer::Reverse() {
				Message* message = this->message.get();
				const FieldDescriptor* field_descriptor = this->field_descriptor.get();
				const Reflection* reflection = message->GetReflection();

				int field_size = reflection->FieldSize(*message, field_descriptor);
				for (int i = 0; i < field_size / 2; i++) {
					reflection->SwapElements(message, field_descriptor, i, field_size - 1 - i);
				}
			}

			void RepeatedContainer::Clear() {
				Message* message = this->message.get();
				const FieldDescriptor* field_descriptor = this->field_descriptor.get();
				const Reflection* reflection = message->GetReflection();
				reflection->ClearField(message, field_descriptor);
			}

			void RepeatedContainer::MergeFrom(const RepeatedContainer& other) {
				auto field_size = other.size();
				for (int i = 0; i < field_size; i++) {
					Append(other.GetItem(i));
				}
			}

			void RepeatedContainer::MergeFrom(const std::vector<_variant_t>& other) {
				for (const auto& item : other) {
					Append(item);
				}
			}

			std::string RepeatedContainer::ToStr() const {
				std::string output;
				// TODO
				return output;
			}

			RepeatedIterator RepeatedContainer::begin() {
				return { this, 0 };
			}

			RepeatedIterator RepeatedContainer::end() {
				return { this, size() };
			}

		}
	}
}
