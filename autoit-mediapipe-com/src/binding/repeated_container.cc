#include "mediapipe/framework/port/status_macros.h"
#include "binding/repeated_container.h"
#include "Google_Protobuf_Message_Object.h"

namespace {
	using namespace google::protobuf::autoit;
	using namespace google::protobuf;

	[[nodiscard]] absl::Status InternalAssignRepeatedField(RepeatedContainer* self, const std::vector<_variant_t>& list) {
		Message* message = self->message.get();
		message->GetReflection()->ClearField(message, self->field_descriptor.get());
		for (const auto& value : list) {
			MP_RETURN_IF_ERROR(self->Append(value));
		}
		return absl::OkStatus();
	}
}

namespace google::protobuf::autoit {
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
			VARIANT* pv = &m_value.value();
			_Copy<VARIANT>::destroy(pv);
			MP_ASSIGN_OR_THROW(auto result, container->GetItem(m_iter));
			_Copy<VARIANT>::copy(pv, &result);
			m_dirty = false;
		}
		return m_value.value();
	}

	size_t RepeatedContainer::Length() const {
		return size();
	}

	size_t RepeatedContainer::size() const {
		const Message* message = this->message.get();
		const FieldDescriptor* field_descriptor = this->field_descriptor.get();
		return message->GetReflection()->FieldSize(*message, field_descriptor);
	}

	absl::StatusOr<_variant_t> RepeatedContainer::GetItem(ssize_t index) const {
		const Message* message = this->message.get();
		const FieldDescriptor* field_descriptor = this->field_descriptor.get();
		const Reflection* reflection = message->GetReflection();

		int field_size = reflection->FieldSize(*message, field_descriptor);

		if (index < 0) {
			index += field_size;
		}

		MP_ASSERT_RETURN_IF_ERROR(index >= 0 && index < field_size, "list index (" << index << ") out of range");

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

		MP_ASSERT_RETURN_IF_ERROR(SUCCEEDED(hr), "Getting value from a repeated field of unknown type " << field_descriptor->cpp_type());

		return obj;
	}

	absl::Status RepeatedContainer::SetItem(ssize_t index, _variant_t arg) {
		Message* message = this->message.get();
		const FieldDescriptor* field_descriptor = this->field_descriptor.get();
		const Reflection* reflection = message->GetReflection();

		int field_size = reflection->FieldSize(*message, field_descriptor);

		if (index < 0) {
			index += field_size;
		}

		MP_ASSERT_RETURN_IF_ERROR(index >= 0 && index < field_size, "list index (" << index << ") out of range");

		if (PARAMETER_NULL(&arg)) {
			std::vector<_variant_t> list;
			return Splice(list, index, 1);
		}

		switch (field_descriptor->cpp_type()) {
		case FieldDescriptor::CPPTYPE_INT32: {
			auto value = ::autoit::cast<int>(&arg);
			reflection->SetRepeatedInt32(message, field_descriptor, index, value);
			break;
		}
		case FieldDescriptor::CPPTYPE_INT64: {
			auto value = ::autoit::cast<int64_t>(&arg);
			reflection->SetRepeatedInt64(message, field_descriptor, index, value);
			break;
		}
		case FieldDescriptor::CPPTYPE_UINT32: {
			auto value = ::autoit::cast<uint>(&arg);
			reflection->SetRepeatedUInt32(message, field_descriptor, index, value);
			break;
		}
		case FieldDescriptor::CPPTYPE_UINT64: {
			auto value = ::autoit::cast<uint64_t>(&arg);
			reflection->SetRepeatedUInt64(message, field_descriptor, index, value);
			break;
		}
		case FieldDescriptor::CPPTYPE_FLOAT: {
			auto value = ::autoit::cast<float>(&arg);
			reflection->SetRepeatedFloat(message, field_descriptor, index, value);
			break;
		}
		case FieldDescriptor::CPPTYPE_DOUBLE: {
			auto value = ::autoit::cast<double>(&arg);
			reflection->SetRepeatedDouble(message, field_descriptor, index, value);
			break;
		}
		case FieldDescriptor::CPPTYPE_BOOL: {
			auto value = ::autoit::cast<bool>(&arg);
			reflection->SetRepeatedBool(message, field_descriptor, index, value);
			break;
		}
		case FieldDescriptor::CPPTYPE_STRING: {
			auto value = ::autoit::cast<std::string>(&arg);
			reflection->SetRepeatedString(message, field_descriptor, index, std::move(value));
			break;
		}
		case FieldDescriptor::CPPTYPE_ENUM: {
			auto value = ::autoit::cast<int>(&arg);
			if (reflection->SupportsUnknownEnumValues()) {
				reflection->SetRepeatedEnumValue(message, field_descriptor, index, value);
			} else {
				const EnumDescriptor* enum_descriptor = field_descriptor->enum_type();
				const EnumValueDescriptor* enum_value = enum_descriptor->FindValueByNumber(value);
				MP_ASSERT_RETURN_IF_ERROR(enum_value != nullptr, "Unknown enum value: " << value);
				reflection->SetRepeatedEnum(message, field_descriptor, index, enum_value);
			}
			break;
		}
		case FieldDescriptor::CPPTYPE_MESSAGE: {
			MP_ASSERT_RETURN_IF_ERROR(PARAMETER_NULL(&arg), "does not support assignment");
			MP_RETURN_IF_ERROR(Pop(index).status());
			break;
		}
		default:
			MP_ASSERT_RETURN_IF_ERROR(false, "Adding value to a field of unknown type " << field_descriptor->cpp_type());
		}
		return absl::OkStatus();
	}

	absl::Status RepeatedContainer::Splice(std::vector<_variant_t>& list, ssize_t start) {
		auto field_size = size();
		if (start < 0) {
			start += field_size;
		}
		return Splice(list, start, field_size - start);
	}

	absl::Status RepeatedContainer::Splice(std::vector<_variant_t>& list, ssize_t start, ssize_t deleteCount) {
		list.clear();

		if (deleteCount <= 0) {
			return absl::OkStatus();
		}

		Message* message = this->message.get();
		const FieldDescriptor* field_descriptor = this->field_descriptor.get();
		const Reflection* reflection = message->GetReflection();

		int field_size = reflection->FieldSize(*message, field_descriptor);

		if (start < 0) {
			start += field_size;
		}

		MP_ASSERT_RETURN_IF_ERROR(start >= 0 && start < field_size, "splice index out of range");

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
				MP_ASSIGN_OR_RETURN(auto item, GetItem(field_size - 1 - i));
				list[deleteCount - 1 - i] = item;
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
			MP_ASSERT_RETURN_IF_ERROR(SUCCEEDED(hr), "Failed to delete message at index " << field_size - 1 - i);
			list[deleteCount - 1 - i] = obj;
		}

		return absl::OkStatus();
	}

	absl::Status RepeatedContainer::Slice(std::vector<_variant_t>& list, ssize_t start) const {
		int field_size = size();
		if (start < 0) {
			start += field_size;
		}
		return Slice(list, start, field_size - start);
	}

	absl::Status RepeatedContainer::Slice(std::vector<_variant_t>& list, ssize_t start, ssize_t count) const {
		list.clear();
		if (count <= 0) {
			return absl::OkStatus();
		}
		list.resize(count);
		for (size_t i = 0; i < count; i++) {
			MP_ASSIGN_OR_RETURN(auto item, GetItem(start + i));
			list[i] = item;
		}
		return absl::OkStatus();
	}

	absl::StatusOr<_variant_t> RepeatedContainer::DeepCopy() {
		return cmessage::DeepCopy(message.get(), field_descriptor.get());
	}

	absl::StatusOr<Message*> RepeatedContainer::Add(const std::map<std::string, _variant_t>& attrs) {
		Message* message = this->message.get();
		const FieldDescriptor* field_descriptor = this->field_descriptor.get();
		const Reflection* reflection = message->GetReflection();

		MP_ASSERT_RETURN_IF_ERROR(field_descriptor->cpp_type() == FieldDescriptor::CPPTYPE_MESSAGE, "field is not a message field");

		Message* sub_message = reflection->AddMessage(message, field_descriptor);
		MP_RETURN_IF_ERROR(cmessage::InitAttributes(*sub_message, attrs));
		return sub_message;
	}

	absl::Status RepeatedContainer::Append(_variant_t item) {
		Message* message = this->message.get();
		const FieldDescriptor* field_descriptor = this->field_descriptor.get();
		const Reflection* reflection = message->GetReflection();

		switch (field_descriptor->cpp_type()) {
		case FieldDescriptor::CPPTYPE_INT32: {
			auto value = ::autoit::cast<int>(&item);
			reflection->AddInt32(message, field_descriptor, value);
			break;
		}
		case FieldDescriptor::CPPTYPE_INT64: {
			auto value = ::autoit::cast<int64_t>(&item);
			reflection->AddInt64(message, field_descriptor, value);
			break;
		}
		case FieldDescriptor::CPPTYPE_UINT32: {
			auto value = ::autoit::cast<uint>(&item);
			reflection->AddUInt32(message, field_descriptor, value);
			break;
		}
		case FieldDescriptor::CPPTYPE_UINT64: {
			auto value = ::autoit::cast<uint64_t>(&item);
			reflection->AddUInt64(message, field_descriptor, value);
			break;
		}
		case FieldDescriptor::CPPTYPE_FLOAT: {
			auto value = ::autoit::cast<float>(&item);
			reflection->AddFloat(message, field_descriptor, value);
			break;
		}
		case FieldDescriptor::CPPTYPE_DOUBLE: {
			auto value = ::autoit::cast<double>(&item);
			reflection->AddDouble(message, field_descriptor, value);
			break;
		}
		case FieldDescriptor::CPPTYPE_BOOL: {
			auto value = ::autoit::cast<bool>(&item);
			reflection->AddBool(message, field_descriptor, value);
			break;
		}
		case FieldDescriptor::CPPTYPE_STRING: {
			auto value = ::autoit::cast<std::string>(&item);
			reflection->AddString(message, field_descriptor, std::move(value));
			break;
		}
		case FieldDescriptor::CPPTYPE_ENUM: {
			auto value = ::autoit::cast<int>(&item);
			if (reflection->SupportsUnknownEnumValues()) {
				reflection->AddEnumValue(message, field_descriptor, value);
			} else {
				const EnumDescriptor* enum_descriptor = field_descriptor->enum_type();
				const EnumValueDescriptor* enum_value = enum_descriptor->FindValueByNumber(value);
				MP_ASSERT_RETURN_IF_ERROR(enum_value != nullptr, "Unknown enum value: " << value);
				reflection->AddEnum(message, field_descriptor, enum_value);
			}
			break;
		}
		case FieldDescriptor::CPPTYPE_MESSAGE: {
			MP_ASSIGN_OR_RETURN(auto sub_message, Add());
			std::map<std::string, _variant_t> sub_attrs;
			HRESULT hr = autoit_to(&item, sub_attrs);
			if (SUCCEEDED(hr)) {
				MP_RETURN_IF_ERROR(cmessage::InitAttributes(*sub_message, sub_attrs));
			}
			else {
				auto value = ::autoit::cast<std::shared_ptr<Message>>(&item);
				sub_message->MergeFrom(*value);
			}
			break;
		}
		default:
			MP_ASSERT_RETURN_IF_ERROR(false, "Adding value to a field of unknown type " << field_descriptor->cpp_type());
		}

		return absl::OkStatus();
	}

	absl::Status RepeatedContainer::Extend(const std::vector<_variant_t>& items) {
		for (auto& item : items) {
			MP_RETURN_IF_ERROR(Append(item));
		}
		return absl::OkStatus();
	}

	absl::Status RepeatedContainer::Insert(ssize_t index, _variant_t item) {
		Message* message = this->message.get();
		const FieldDescriptor* field_descriptor = this->field_descriptor.get();
		const Reflection* reflection = message->GetReflection();

		int field_size = reflection->FieldSize(*message, field_descriptor);
		if (index < 0) {
			index += field_size;
		}

		MP_ASSERT_RETURN_IF_ERROR(index >= 0 && index <= field_size, "list index (" << index << ") out of range");

		MP_RETURN_IF_ERROR(Append(item));

		for (int i = index; i < field_size; i++) {
			reflection->SwapElements(message, field_descriptor, i, field_size);
		}
	}

	absl::Status RepeatedContainer::Insert(std::tuple<ssize_t, _variant_t>& args) {
		return Insert(std::get<0>(args), std::get<1>(args));
	}

	absl::StatusOr<_variant_t> RepeatedContainer::Pop(ssize_t index) {
		std::vector<_variant_t> list;
		MP_RETURN_IF_ERROR(Splice(list, index, 1));
		return list[0];
	}

	using RepeatedContainerComparator = bool (*)(VARIANT* a, VARIANT* b);

	typedef struct _RepeatedContainerComparatorProxy {
		RepeatedContainerComparator cmp;
		bool operator() (_variant_t& va, _variant_t& vb) {
			VARIANT* pva = &va;
			VARIANT* pvb = &vb;
			return cmp(pva, pvb);
		}
	} RepeatedContainerComparatorProxy;

	absl::Status RepeatedContainer::Sort(void* comparator) {
		std::vector<_variant_t> list;
		MP_RETURN_IF_ERROR(Slice(list));

		RepeatedContainerComparatorProxy cmp = { reinterpret_cast<RepeatedContainerComparator>(comparator) };
		auto begin = std::begin(list);
		std::sort(begin, begin + list.size(), cmp);

		return InternalAssignRepeatedField(this, list);
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

	absl::Status RepeatedContainer::MergeFrom(const RepeatedContainer& other) {
		auto field_size = other.size();
		for (int i = 0; i < field_size; i++) {
			MP_ASSIGN_OR_RETURN(auto item, other.GetItem(i));
			MP_RETURN_IF_ERROR(Append(item));
		}
		return absl::OkStatus();
	}

	absl::Status RepeatedContainer::MergeFrom(const std::vector<_variant_t>& other) {
		for (const auto& item : other) {
			MP_RETURN_IF_ERROR(Append(item));
		}
		return absl::OkStatus();
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
