#pragma once

#include "autoit_bridge.h"

namespace google {
	namespace protobuf {
		namespace autoit {
			struct RepeatedContainer;
			struct RepeatedIterator;

			struct RepeatedIterator {
				RepeatedIterator& operator++();
				RepeatedContainer* container;
				size_t curr = 0;
				_variant_t GetItem() const;
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
				CV_WRAP_AS(slice) void Slice(CV_OUT std::vector<_variant_t>& list, SSIZE_T start, size_t count) const;
				CV_WRAP_AS(deepcopy) _variant_t DeepCopy();
				CV_WRAP_AS(append) void Append(_variant_t item);
				CV_WRAP_AS(insert) void Insert(SSIZE_T index, _variant_t item);
				CV_WRAP_AS(insert) void Insert(std::tuple<SSIZE_T, _variant_t>& args);
				CV_WRAP_AS(pop) _variant_t Pop(SSIZE_T index = -1);
				// CV_WRAP_AS(remove) void Remove(_variant_t item);
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
		}

		bool operator==(const autoit::RepeatedIterator& a, const autoit::RepeatedIterator& b) {
			return a.curr == b.curr;
		}

		bool operator!=(const autoit::RepeatedIterator& a, const autoit::RepeatedIterator& b) {
			return a.curr != b.curr;
		}
	}
}

namespace autoit {
	template<typename destination_type>
	struct _GenericCopy<destination_type, ::google::protobuf::autoit::RepeatedIterator> {
		inline static HRESULT copy(destination_type* pTo, const ::google::protobuf::autoit::RepeatedIterator* pFrom) {
			return autoit_from(pFrom->GetItem(), pTo);
		}
	};
}
