#pragma once

#include "mediapipe/framework/port/status_macros.h"
#include "MapOfStringAndVariant_Object.h"

namespace google::protobuf::autoit {
	template<typename Element, typename _Tp>
	[[nodiscard]] absl::StatusOr<bool> RepeatedField_PrepareSplice(
		_Tp* repeatedField,
		std::vector<Element>& list,
		ssize_t start,
		ssize_t& deleteCount
	) {
		list.clear();

		if (deleteCount <= 0) {
			return false;
		}

		int field_size = repeatedField->size();

		if (start < 0) {
			start += field_size;
		}

		MP_ASSERT_RETURN_IF_ERROR(start >= 0 && start < field_size, "splice index out of range");

		if (deleteCount > (field_size - start)) {
			deleteCount = field_size - start;
		}

		int end = start + deleteCount;

		for (int i = start; i < end && i + deleteCount < field_size; i++) {
			repeatedField->SwapElements(i, i + deleteCount);
		}

		list.resize(deleteCount);
		return true;
	}

	template<typename Element>
	[[nodiscard]] inline absl::StatusOr<Element*> RepeatedField_AddMessage(RepeatedPtrField<Element>* repeatedField, const Element* message) {
		Element* sub_message = repeatedField->Add();
		sub_message->MergeFrom(*message);
		return sub_message;
	}

	template<typename Element>
	[[nodiscard]] inline absl::StatusOr<Element*> RepeatedField_AddMessage(RepeatedPtrField<Element>* repeatedField, std::map<std::string, _variant_t>& attrs) {
		Element* sub_message = repeatedField->Add();
		MP_RETURN_IF_ERROR(cmessage::InitAttributes(*sub_message, attrs));
		return sub_message;
	}

	template<typename Element, typename _Tp>
	[[nodiscard]] inline absl::Status RepeatedField_SpliceScalar(_Tp* repeatedField, std::vector<Element>& list, ssize_t start, ssize_t deleteCount) {
		MP_ASSIGN_OR_RETURN(auto prepared, RepeatedField_PrepareSplice(repeatedField, list, start, deleteCount));
		if (!prepared) {
			return absl::OkStatus();
		}

		auto field_size = repeatedField->size();
		for (int i = 0; deleteCount > 0; i++, deleteCount--) {
			list[deleteCount - 1 - i] = repeatedField->Get(field_size - 1 - i);
			repeatedField->RemoveLast();
		}

		return absl::OkStatus();
	}

	template<typename Element, typename _Tp>
	[[nodiscard]] inline absl::Status RepeatedField_SpliceScalar(_Tp* repeatedField, std::vector<Element>& list, ssize_t start) {
		auto field_size = repeatedField->size();
		if (start < 0) {
			start += field_size;
		}
		return RepeatedField_SpliceScalar(repeatedField, list, start, field_size - start);
	}

	template<typename Element>
	[[nodiscard]] absl::Status RepeatedField_SpliceMessage(
		RepeatedPtrField<Element>* repeatedField,
		std::vector<std::shared_ptr<Element>>& list,
		ssize_t start,
		ssize_t deleteCount
	) {
		MP_ASSIGN_OR_RETURN(auto prepared, RepeatedField_PrepareSplice(repeatedField, list, start, deleteCount));
		if (!prepared) {
			return absl::OkStatus();
		}

		for (int i = 0; deleteCount > 0; i++, deleteCount--) {
			// It seems that RemoveLast() is less efficient for sub-messages, and
			// the memory is not completely released. Prefer ReleaseLast().
			Element* sub_message = repeatedField->ReleaseLast();
			list[deleteCount - 1 - i] = std::shared_ptr<Element>(sub_message);
		}

		return absl::OkStatus();
	}

	template<typename Element>
	[[nodiscard]] inline absl::Status RepeatedField_SpliceMessage(
		RepeatedPtrField<Element>* repeatedField,
		std::vector<std::shared_ptr<Element>>& list,
		ssize_t start
	) {
		auto field_size = repeatedField->size();
		if (start < 0) {
			start += field_size;
		}
		return RepeatedField_SpliceMessage(repeatedField, list, start, field_size - start);
	}

	template<typename Element, typename _Tp>
	inline void RepeatedField_SliceScalar(
		_Tp* repeatedField,
		std::vector<Element>& list,
		ssize_t start,
		ssize_t count
	) {
		list.clear();
		if (count <= 0) {
			return;
		}
		list.resize(count);
		for (size_t i = 0; i < count; i++) {
			list[i] = repeatedField->Get(start + i);
		}
	}

	template<typename Element, typename _Tp>
	inline void RepeatedField_SliceScalar(
		_Tp* repeatedField,
		std::vector<Element>& list,
		ssize_t start
	) {
		auto field_size = repeatedField->size();
		if (start < 0) {
			start += field_size;
		}
		RepeatedField_SliceScalar(repeatedField, list, start, field_size - start);
	}

	template<typename Element>
	inline void RepeatedField_SliceMessage(
		RepeatedPtrField<Element>* repeatedField,
		std::vector<std::shared_ptr<Element>>& list,
		ssize_t start,
		ssize_t count
	) {
		list.clear();
		if (count <= 0) {
			return;
		}
		list.resize(count);
		for (size_t i = 0; i < count; i++) {
			list[i] = ::autoit::reference_internal(repeatedField->Mutable(start + i));
		}
	}

	template<typename Element>
	inline void RepeatedField_SliceMessage(
		RepeatedPtrField<Element>* repeatedField,
		std::vector<std::shared_ptr<Element>>& list,
		ssize_t start
	) {
		auto field_size = repeatedField->size();
		if (start < 0) {
			start += field_size;
		}
		RepeatedField_SliceMessage(repeatedField, list, start, field_size - start);
	}

	template<typename _Tp>
	inline void RepeatedField_ExtendScalar(
		_Tp* repeatedField,
		const _Tp& items
	) {
		for (const auto& item : items) {
			*repeatedField->Add() = item;
		}
	}

	template<typename Element, typename _Tp>
	inline void RepeatedField_ExtendScalar(
		_Tp* repeatedField,
		const std::vector<Element>& items
	) {
		for (const auto& item : items) {
			*repeatedField->Add() = item;
		}
	}

	template<typename Element>
	[[nodiscard]] inline absl::Status RepeatedField_ExtendMessage(
		RepeatedPtrField<Element>* repeatedField,
		const std::vector<std::shared_ptr<Element>>& items
	) {
		for (const auto& item : items) {
			MP_RETURN_IF_ERROR(RepeatedField_AddMessage(repeatedField, item.get()).status());
		}
	}

	template<typename Element>
	[[nodiscard]] inline absl::Status RepeatedField_ExtendMessage(
		RepeatedPtrField<Element>* repeatedField,
		const RepeatedPtrField<Element>& items
	) {
		for (const auto& item : items) {
			MP_RETURN_IF_ERROR(RepeatedField_AddMessage(repeatedField, &item).status());
		}
	}

	template<typename Element>
	[[nodiscard]] inline absl::Status RepeatedField_ExtendMessage(
		RepeatedPtrField<Element>* repeatedField,
		const std::vector<_variant_t>& items
	) {
		for (const auto& item : items) {
			std::map<std::string, _variant_t> attrs;
			HRESULT hr = autoit_to(&item, attrs);
			if (SUCCEEDED(hr)) {
				MP_RETURN_IF_ERROR(RepeatedField_AddMessage(repeatedField, attrs).status());
			}
			else {
				auto value = ::autoit::cast<std::shared_ptr<Element>>(&item);
				MP_RETURN_IF_ERROR(RepeatedField_AddMessage(repeatedField, value.get()).status());
			}
		}
	}

	template<typename Element, typename _Tp>
	[[nodiscard]] inline absl::Status RepeatedField_InsertScalar(_Tp* repeatedField, ssize_t index, const Element& item) {
		int field_size = repeatedField->size();
		if (index < 0) {
			index += field_size;
		}

		MP_ASSERT_RETURN_IF_ERROR(index >= 0 && index <= field_size, "list index (" << index << ") out of range");

		*repeatedField->Add() = item;

		for (int i = index; i < field_size; i++) {
			repeatedField->SwapElements(i, field_size);
		}

		return absl::OkStatus();
	}

	template<typename Element>
	[[nodiscard]] inline absl::Status RepeatedField_InsertMessage(RepeatedPtrField<Element>* repeatedField, ssize_t index, const Element* item) {
		int field_size = repeatedField->size();
		if (index < 0) {
			index += field_size;
		}

		MP_ASSERT_RETURN_IF_ERROR(index >= 0 && index <= field_size, "list index (" << index << ") out of range");

		MP_RETURN_IF_ERROR(RepeatedField_AddMessage(repeatedField, item).status());

		for (int i = index; i < field_size; i++) {
			repeatedField->SwapElements(i, field_size);
		}

		return absl::OkStatus();
	}

	template<typename Element, typename _Tp>
	[[nodiscard]] inline absl::StatusOr<Element> RepeatedField_PopScalar(_Tp* repeatedField, ssize_t index) {
		std::vector<Element> list;
		MP_RETURN_IF_ERROR(RepeatedField_SpliceScalar(repeatedField, list, index, 1));
		return list[0];
	}

	template<typename Element>
	[[nodiscard]] inline absl::StatusOr<std::shared_ptr<Element>> RepeatedField_PopMessage(RepeatedPtrField<Element>* repeatedField, ssize_t index) {
		std::vector<std::shared_ptr<Element>> list;
		MP_RETURN_IF_ERROR(RepeatedField_SpliceMessage(repeatedField, list, index, 1));
		return list[0];
	}

	template<typename _Tp>
	inline void RepeatedField_Reverse(_Tp* repeatedField) {
		int field_size = repeatedField->size();
		for (int i = 0; i < field_size / 2; i++) {
			repeatedField->SwapElements(i, field_size - 1 - i);
		}
	}

	template<typename _Tr, typename _Ti>
	HRESULT RepeatedField_Set(Message& message, const std::string& field_name, VARIANT* newVal, _Tr* repeated_field, _Ti& repeated_iterator) {
		const Descriptor* descriptor = message.GetDescriptor();
		const auto field_descriptor = cmessage::FindFieldWithOneofs(message, field_name, descriptor);
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
			if (!autoit_container.MergeFrom(value_items).ok()) {
				hr = E_FAIL;
			}
			return hr;
		}

		return E_INVALIDARG;
	}
}
