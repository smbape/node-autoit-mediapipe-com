#pragma once

#include "autoit_bridge.h"

namespace google {
	namespace protobuf {
		namespace autoit {
			struct RepeatedContainer;
			struct RepeatedIterator;

			struct RepeatedIterator {
				RepeatedIterator& operator++() noexcept;
				RepeatedIterator operator++(int) noexcept;
				bool operator==(const RepeatedIterator& other) const noexcept;
				bool operator!=(const RepeatedIterator& other) const noexcept;
				const _variant_t& operator*() noexcept;

				RepeatedContainer* container;
				size_t m_iter = 0;
				_variant_t m_value;
				bool m_dirty = true;
			};

			struct CV_EXPORTS_W_SIMPLE RepeatedContainer {
				CV_WRAP RepeatedContainer() = default;
				CV_WRAP RepeatedContainer(const RepeatedContainer& other) = default;
				RepeatedContainer& operator=(const RepeatedContainer& other) = default;

				CV_WRAP_AS(length) size_t Length() const;
				CV_WRAP size_t size() const;

				CV_WRAP_AS(get Item) _variant_t GetItem(SSIZE_T index) const;
				CV_WRAP_AS(put Item) void SetItem(SSIZE_T index, _variant_t arg);
				CV_WRAP_AS(splice) void Splice(CV_OUT std::vector<_variant_t>& list, SSIZE_T start = 0);
				CV_WRAP_AS(splice) void Splice(CV_OUT std::vector<_variant_t>& list, SSIZE_T start, SSIZE_T deleteCount);
				CV_WRAP_AS(slice) void Slice(CV_OUT std::vector<_variant_t>& list, SSIZE_T start = 0) const;
				CV_WRAP_AS(slice) void Slice(CV_OUT std::vector<_variant_t>& list, SSIZE_T start, SSIZE_T count) const;
				CV_WRAP_AS(deepcopy) _variant_t DeepCopy();
				CV_WRAP_AS(add) Message* Add(std::map<std::string, _variant_t>& attrs = std::map<std::string, _variant_t>());
				CV_WRAP_AS(append) void Append(_variant_t item);
				CV_WRAP_AS(extend) void Extend(std::vector<_variant_t>& items);
				CV_WRAP_AS(insert) void Insert(SSIZE_T index, _variant_t item);
				CV_WRAP_AS(insert) void Insert(std::tuple<SSIZE_T, _variant_t>& args);
				CV_WRAP_AS(pop) _variant_t Pop(SSIZE_T index = -1);
				CV_WRAP_AS(sort) void Sort(void* comparator);
				CV_WRAP_AS(reverse) void Reverse();
				CV_WRAP_AS(clear) void Clear();
				CV_WRAP void MergeFrom(const RepeatedContainer& other);
				CV_WRAP void MergeFrom(const std::vector<_variant_t>& other);

				CV_WRAP_AS(str) std::string ToStr() const;

				using iterator = RepeatedIterator;
				using const_iterator = RepeatedIterator;

				iterator begin();
				iterator end();

				std::shared_ptr<Message> message;
				std::shared_ptr<FieldDescriptor> field_descriptor;
			};

			template<typename Element, typename _Tp>
			bool RepeatedField_PrepareSplice(
				_Tp* repeatedField,
				std::vector<Element>& list,
				SSIZE_T start,
				SSIZE_T& deleteCount
			) {
				list.clear();

				if (deleteCount <= 0) {
					return false;
				}

				int field_size = repeatedField->size();

				if (start < 0) {
					start += field_size;
				}

				AUTOIT_ASSERT_THROW(start >= 0 && start < field_size, "splice index out of range");

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
			Element* RepeatedField_AddMessage(RepeatedPtrField<Element>* repeatedField, const Element* message) {
				Element* sub_message = repeatedField->Add();
				sub_message->MergeFrom(*message);
				return sub_message;
			}

			template<typename Element>
			Element* RepeatedField_AddMessage(RepeatedPtrField<Element>* repeatedField, std::map<std::string, _variant_t>& attrs) {
				Element* sub_message = repeatedField->Add();
				cmessage::InitAttributes(*sub_message, attrs);
				return sub_message;
			}

			template<typename Element, typename _Tp>
			void RepeatedField_SpliceScalar(_Tp* repeatedField, std::vector<Element>& list, SSIZE_T start, SSIZE_T deleteCount) {
				if (!RepeatedField_PrepareSplice(repeatedField, list, start, deleteCount)) {
					return;
				}

				auto field_size = repeatedField->size();
				for (int i = 0; deleteCount > 0; i++, deleteCount--) {
					list[deleteCount - 1 - i] = repeatedField->Get(field_size - 1 - i);
					repeatedField->RemoveLast();
				}
			}

			template<typename Element, typename _Tp>
			void RepeatedField_SpliceScalar(_Tp* repeatedField, std::vector<Element>& list, SSIZE_T start = 0) {
				auto field_size = repeatedField->size();
				if (start < 0) {
					start += field_size;
				}
				RepeatedField_SpliceScalar(repeatedField, list, start, field_size - start);
			}

			template<typename Element>
			void RepeatedField_SpliceMessage(
				RepeatedPtrField<Element>* repeatedField,
				std::vector<std::shared_ptr<Element>>& list,
				SSIZE_T start,
				SSIZE_T deleteCount
			) {
				if (!RepeatedField_PrepareSplice(repeatedField, list, start, deleteCount)) {
					return;
				}

				for (int i = 0; deleteCount > 0; i++, deleteCount--) {
					// It seems that RemoveLast() is less efficient for sub-messages, and
					// the memory is not completely released. Prefer ReleaseLast().
					Element* sub_message = repeatedField->ReleaseLast();
					list[deleteCount - 1 - i] = std::shared_ptr<Element>(sub_message);
				}
			}

			template<typename Element>
			void RepeatedField_SpliceMessage(
				RepeatedPtrField<Element>* repeatedField,
				std::vector<std::shared_ptr<Element>>& list,
				SSIZE_T start = 0
			) {
				auto field_size = repeatedField->size();
				if (start < 0) {
					start += field_size;
				}
				RepeatedField_SpliceMessage(repeatedField, list, start, field_size - start);
			}

			template<typename Element, typename _Tp>
			void RepeatedField_SliceScalar(
				_Tp* repeatedField,
				std::vector<Element>& list,
				SSIZE_T start,
				SSIZE_T count
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
			void RepeatedField_SliceScalar(
				_Tp* repeatedField,
				std::vector<Element>& list,
				SSIZE_T start = 0
			) {
				auto field_size = repeatedField->size();
				if (start < 0) {
					start += field_size;
				}
				RepeatedField_SliceScalar(repeatedField, list, start, field_size - start);
			}

			template<typename Element>
			void RepeatedField_SliceMessage(
				RepeatedPtrField<Element>* repeatedField,
				std::vector<std::shared_ptr<Element>>& list,
				SSIZE_T start,
				SSIZE_T count
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
			void RepeatedField_SliceMessage(
				RepeatedPtrField<Element>* repeatedField,
				std::vector<std::shared_ptr<Element>>& list,
				SSIZE_T start = 0
			) {
				auto field_size = repeatedField->size();
				if (start < 0) {
					start += field_size;
				}
				RepeatedField_SliceMessage(repeatedField, list, start, field_size - start);
			}

			template<typename _Tp>
			void RepeatedField_ExtendScalar(
				_Tp* repeatedField,
				const _Tp& items
			) {
				for (const auto& item : items) {
					*repeatedField->Add() = item;
				}
			}

			template<typename Element, typename _Tp>
			void RepeatedField_ExtendScalar(
				_Tp* repeatedField,
				const std::vector<Element>& items
			) {
				for (const auto& item : items) {
					*repeatedField->Add() = item;
				}
			}

			template<typename Element>
			void RepeatedField_ExtendMessage(
				RepeatedPtrField<Element>* repeatedField,
				const std::vector<std::shared_ptr<Element>>& items
			) {
				for (const auto& item : items) {
					RepeatedField_AddMessage(repeatedField, item.get());
				}
			}

			template<typename Element>
			void RepeatedField_ExtendMessage(
				RepeatedPtrField<Element>* repeatedField,
				const RepeatedPtrField<Element>& items
			) {
				for (const auto& item : items) {
					RepeatedField_AddMessage(repeatedField, &item);
				}
			}

			template<typename Element>
			void RepeatedField_ExtendMessage(
				RepeatedPtrField<Element>* repeatedField,
				std::vector<_variant_t>& items
			) {
				for (const auto& item : items) {
					std::map<std::string, _variant_t> attrs;
					HRESULT hr = autoit_to(&item, attrs);
					if (SUCCEEDED(hr)) {
						RepeatedField_AddMessage(repeatedField, attrs);
					}
					else {
						auto value = ::autoit::cast<std::shared_ptr<Element>>(&item);
						RepeatedField_AddMessage(repeatedField, value.get());
					}
				}
			}

			template<typename Element, typename _Tp>
			void RepeatedField_InsertScalar(_Tp* repeatedField, SSIZE_T index, const Element& item) {
				int field_size = repeatedField->size();
				if (index < 0) {
					index += field_size;
				}

				AUTOIT_ASSERT_THROW(index >= 0 && index <= field_size, "list index (" << index << ") out of range");

				*repeatedField->Add() = item;

				for (int i = index; i < field_size; i++) {
					repeatedField->SwapElements(i, field_size);
				}
			}

			template<typename Element>
			void RepeatedField_InsertMessage(RepeatedPtrField<Element>* repeatedField, SSIZE_T index, const Element* item) {
				int field_size = repeatedField->size();
				if (index < 0) {
					index += field_size;
				}

				AUTOIT_ASSERT_THROW(index >= 0 && index <= field_size, "list index (" << index << ") out of range");

				RepeatedField_AddMessage(repeatedField, item);

				for (int i = index; i < field_size; i++) {
					repeatedField->SwapElements(i, field_size);
				}
			}

			template<typename Element, typename _Tp>
			Element RepeatedField_PopScalar(_Tp* repeatedField, SSIZE_T index = -1) {
				std::vector<Element> list;
				RepeatedField_SpliceScalar(repeatedField, list, index, 1);
				return list[0];
			}

			template<typename Element>
			std::shared_ptr<Element> RepeatedField_PopMessage(RepeatedPtrField<Element>* repeatedField, SSIZE_T index = -1) {
				std::vector<std::shared_ptr<Element>> list;
				RepeatedField_SpliceMessage(repeatedField, list, index, 1);
				return list[0];
			}

			template<typename _Tp>
			void RepeatedField_Reverse(_Tp* repeatedField) {
				int field_size = repeatedField->size();
				for (int i = 0; i < field_size / 2; i++) {
					repeatedField->SwapElements(i, field_size - 1 - i);
				}
			}

		}
	}
}
