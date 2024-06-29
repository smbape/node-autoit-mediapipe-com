#pragma once

#include "binding/message.h"

namespace google::protobuf::autoit {
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

		CV_WRAP_AS(get_default Item) _variant_t GetItem(SSIZE_T index) const;
		CV_WRAP_AS(put_default Item) void SetItem(SSIZE_T index, _variant_t arg);
		CV_WRAP_AS(splice) void Splice(CV_OUT std::vector<_variant_t>& list, SSIZE_T start = 0);
		CV_WRAP_AS(splice) void Splice(CV_OUT std::vector<_variant_t>& list, SSIZE_T start, SSIZE_T deleteCount);
		CV_WRAP_AS(slice) void Slice(CV_OUT std::vector<_variant_t>& list, SSIZE_T start = 0) const;
		CV_WRAP_AS(slice) void Slice(CV_OUT std::vector<_variant_t>& list, SSIZE_T start, SSIZE_T count) const;
		CV_WRAP_AS(deepcopy) _variant_t DeepCopy();
		CV_WRAP_AS(add) Message* Add(const std::map<std::string, _variant_t>& attrs = std::map<std::string, _variant_t>());
		CV_WRAP_AS(append) void Append(_variant_t item);
		CV_WRAP_AS(extend) void Extend(const std::vector<_variant_t>& items);
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
	);

	template<typename Element>
	Element* RepeatedField_AddMessage(RepeatedPtrField<Element>* repeatedField, const Element* message);

	template<typename Element>
	Element* RepeatedField_AddMessage(RepeatedPtrField<Element>* repeatedField, std::map<std::string, _variant_t>& attrs);

	template<typename Element, typename _Tp>
	void RepeatedField_SpliceScalar(_Tp* repeatedField, std::vector<Element>& list, SSIZE_T start, SSIZE_T deleteCount);

	template<typename Element, typename _Tp>
	void RepeatedField_SpliceScalar(_Tp* repeatedField, std::vector<Element>& list, SSIZE_T start = 0);

	template<typename Element>
	void RepeatedField_SpliceMessage(
		RepeatedPtrField<Element>* repeatedField,
		std::vector<std::shared_ptr<Element>>& list,
		SSIZE_T start,
		SSIZE_T deleteCount
	);

	template<typename Element>
	void RepeatedField_SpliceMessage(
		RepeatedPtrField<Element>* repeatedField,
		std::vector<std::shared_ptr<Element>>& list,
		SSIZE_T start = 0
	);

	template<typename Element, typename _Tp>
	void RepeatedField_SliceScalar(
		_Tp* repeatedField,
		std::vector<Element>& list,
		SSIZE_T start,
		SSIZE_T count
	);

	template<typename Element, typename _Tp>
	void RepeatedField_SliceScalar(
		_Tp* repeatedField,
		std::vector<Element>& list,
		SSIZE_T start = 0
	);

	template<typename Element>
	void RepeatedField_SliceMessage(
		RepeatedPtrField<Element>* repeatedField,
		std::vector<std::shared_ptr<Element>>& list,
		SSIZE_T start,
		SSIZE_T count
	);

	template<typename Element>
	void RepeatedField_SliceMessage(
		RepeatedPtrField<Element>* repeatedField,
		std::vector<std::shared_ptr<Element>>& list,
		SSIZE_T start = 0
	);

	template<typename _Tp>
	void RepeatedField_ExtendScalar(
		_Tp* repeatedField,
		const _Tp& items
	);

	template<typename Element, typename _Tp>
	void RepeatedField_ExtendScalar(
		_Tp* repeatedField,
		const std::vector<Element>& items
	);

	template<typename Element>
	void RepeatedField_ExtendMessage(
		RepeatedPtrField<Element>* repeatedField,
		const std::vector<std::shared_ptr<Element>>& items
	);

	template<typename Element>
	void RepeatedField_ExtendMessage(
		RepeatedPtrField<Element>* repeatedField,
		const RepeatedPtrField<Element>& items
	);

	template<typename Element>
	void RepeatedField_ExtendMessage(
		RepeatedPtrField<Element>* repeatedField,
		const std::vector<_variant_t>& items
	);

	template<typename Element, typename _Tp>
	void RepeatedField_InsertScalar(_Tp* repeatedField, SSIZE_T index, const Element& item);

	template<typename Element>
	void RepeatedField_InsertMessage(RepeatedPtrField<Element>* repeatedField, SSIZE_T index, const Element* item);

	template<typename Element, typename _Tp>
	Element RepeatedField_PopScalar(_Tp* repeatedField, SSIZE_T index = -1);

	template<typename Element>
	std::shared_ptr<Element> RepeatedField_PopMessage(RepeatedPtrField<Element>* repeatedField, SSIZE_T index = -1);

	template<typename _Tp>
	void RepeatedField_Reverse(_Tp* repeatedField);

	template<typename _Tr, typename _Ti>
	HRESULT RepeatedField_Set(Message& message, const std::string& field_name, VARIANT* newVal, _Tr* repeated_field, _Ti& repeated_iterator);
}
