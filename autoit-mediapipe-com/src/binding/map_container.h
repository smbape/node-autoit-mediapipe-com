#pragma once

#include "autoit_bridge.h"
#include <google/protobuf/stubs/common.h>
#include <google/protobuf/map_field.h>

namespace google {
	namespace protobuf {
		namespace autoit {
			struct MapContainer;
			struct MapIterator;
		}

		// hack to access MapReflection private members
		template<>
		class MutableRepeatedFieldRef<autoit::MapContainer, void> {
		public:
			static autoit::MapIterator begin(autoit::MapContainer* self);
			static autoit::MapIterator end(autoit::MapContainer* self);
			static std::string ToStr(const autoit::MapContainer* self);
			static bool Contains(const autoit::MapContainer* self, _variant_t key);
			static _variant_t GetItem(const autoit::MapContainer* self, _variant_t key);
			static void SetItem(autoit::MapContainer* self, _variant_t key, _variant_t arg);
			static size_t Size(const autoit::MapContainer* self);
		};

		using MapRefectionFriend = MutableRepeatedFieldRef<autoit::MapContainer, void>;

		namespace autoit {
			_variant_t noValue();

			struct MapIterator {
				MapIterator& operator++();
				const MapKey& GetKey();
				const MapValueRef& GetValueRef();

				std::unique_ptr<::google::protobuf::MapIterator> iter;
				MapContainer* container;
			};

			struct CV_EXPORTS_W_SIMPLE MapContainer {
				CV_WRAP MapContainer() = default;
				CV_WRAP MapContainer(const MapContainer& other) = default;
				MapContainer& operator=(const MapContainer& other) = default;

				CV_WRAP_AS(contains) bool Contains(_variant_t key) const;
				CV_WRAP_AS(clear) void Clear();
				CV_WRAP_AS(length) size_t Length() const;
				CV_WRAP size_t size() const;
				CV_WRAP_AS(get) _variant_t Get(_variant_t key, _variant_t default_value = noValue()) const;

				CV_WRAP_AS(get Item) _variant_t GetItem(_variant_t key) const;
				CV_WRAP_AS(put Item) void SetItem(_variant_t key, _variant_t arg);

				CV_WRAP_AS(str) std::string ToStr() const;

				CV_WRAP void MergeFrom(const MapContainer& other);

				friend class MapRefectionFriend;

				using iterator = MapIterator;
				using const_iterator = MapIterator;

				iterator begin();
				iterator end();

				std::shared_ptr<Message> message;
				std::shared_ptr<FieldDescriptor> field_descriptor;
			};

			bool AutoItToMapKey(const FieldDescriptor* parent_field_descriptor, _variant_t arg, MapKey* key);
			bool AutoItToMapValueRef(const FieldDescriptor* parent_field_descriptor, _variant_t arg,
				bool allow_unknown_enum_values,
				MapValueRef* value_ref);
			_variant_t MapKeyToAutoIt(const FieldDescriptor* parent_field_descriptor, const MapKey& key);
			_variant_t MapValueRefToAutoIt(const FieldDescriptor* parent_field_descriptor, const MapValueRef& value);
		}

		bool operator==(const autoit::MapIterator& a, const autoit::MapIterator& b) {
			return *a.iter == *b.iter;
		}

		bool operator!=(const autoit::MapIterator& a, const autoit::MapIterator& b) {
			return *a.iter != *b.iter;
		}
	}
}

namespace autoit {
	template<typename destination_type>
	struct _GenericCopy<destination_type, ::google::protobuf::autoit::MapIterator> {
		inline static HRESULT copy(destination_type* pTo, const ::google::protobuf::autoit::MapIterator* pFrom) {
			std::tuple<_variant_t, _variant_t> pair;
			pair.first = MapKeyToAutoIt(pFrom->container->field_descriptor, pFrom->GetKey());
			pair.second = MapValueRefToAutoIt(pFrom->container->field_descriptor, pFrom->GetValueRef());
			return autoit_from(pair, pTo);
		}
	};
}
