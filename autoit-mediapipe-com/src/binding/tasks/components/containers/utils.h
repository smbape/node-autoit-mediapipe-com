#pragma once

#include <optional>

namespace mediapipe::tasks::components::containers {
	template <typename T>
	concept IsNumber = std::integral<T> || std::floating_point<T>;

	template<IsNumber T>
	inline bool is_optional_equal(const std::optional<T>& a, const std::optional<T>& b) {
		if (!a.has_value()) {
			return !b.has_value() || b.value() == 0;
		}

		if (!b.has_value()) {
			return a.value() == 0;
		}

		return a.value() == b.value();
	}

	template <typename T>
	concept HasEmptyMethod = requires(T t) {

		// Must have an empty() method returning a bool
		{ t.empty() } -> std::same_as<bool>;
	};

	template<HasEmptyMethod T>
	inline bool is_optional_equal(const std::optional<T>& a, const std::optional<T>& b) {
		if (!a.has_value()) {
			return !b.has_value() || b->empty();
		}

		if (!b.has_value()) {
			return a->empty();
		}

		return a.value() == b.value();
	}
}
