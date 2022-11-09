#pragma once

#include "autoit_bridge.h"
#include "binding/util.h"
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
			class MapIterator {
			public:
				MapIterator() = default;
				MapIterator(
					MapContainer* container,
					const ::google::protobuf::MapIterator&& iter
				);
				MapIterator(const MapIterator& other);
				MapIterator& operator=(const MapIterator& other);

				MapIterator& operator++() noexcept;
				MapIterator operator++(int) noexcept;
				bool operator==(const MapIterator& other) const noexcept;
				bool operator!=(const MapIterator& other) const noexcept;
				const std::pair<_variant_t, _variant_t>& operator*() noexcept;

			private:
				MapContainer* m_container;
				std::unique_ptr<::google::protobuf::MapIterator> m_iter;
				std::pair<_variant_t, _variant_t> m_value;
				bool m_dirty = true;
			};

			struct CV_EXPORTS_W_SIMPLE MapContainer {
				CV_WRAP MapContainer() = default;
				CV_WRAP MapContainer(const MapContainer& other) = default;
				MapContainer& operator=(const MapContainer& other) = default;

				CV_WRAP_AS(contains) bool Contains(_variant_t key) const;
				CV_WRAP_AS(clear) void Clear();
				CV_WRAP_AS(length) size_t Length() const;
				CV_WRAP size_t size() const;
				CV_WRAP_AS(get) _variant_t Get(_variant_t key, _variant_t default_value = mediapipe::autoit::default_variant()) const;

				CV_WRAP_AS(get Item) _variant_t GetItem(_variant_t key) const;
				CV_WRAP_AS(put Item) void SetItem(_variant_t key, _variant_t arg);

				CV_WRAP_AS(setFields) void SetFields(std::vector<std::pair<_variant_t, _variant_t>>& fields);

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
	}
}
