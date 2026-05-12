#pragma once

#include "mediapipe/tasks/cc/core/utils.h"
#include "binding/tasks/core/utils.h"

namespace mediapipe::tasks::autoit::core::utils {
	// Status codes for MediaPipe C API functions.
	// These codes are aligned with absl::StatusCode.
	enum class MpStatus {
		MP_OK = 0,
		MP_CANCELLED = 1,
		MP_UNKNOWN = 2,
		MP_INVALID_ARGUMENT = 3,
		MP_DEADLINE_EXCEEDED = 4,
		MP_NOT_FOUND = 5,
		MP_ALREADY_EXISTS = 6,
		MP_PERMISSION_DENIED = 7,
		MP_RESOURCE_EXHAUSTED = 8,
		MP_FAILED_PRECONDITION = 9,
		MP_ABORTED = 10,
		MP_OUT_OF_RANGE = 11,
		MP_UNIMPLEMENTED = 12,
		MP_INTERNAL = 13,
		MP_UNAVAILABLE = 14,
		MP_DATA_LOSS = 15,
		MP_UNAUTHENTICATED = 16,
	};

	inline MpStatus ToMpStatus(absl::Status status) {
		switch (status.code()) {
			case absl::StatusCode::kOk:
				return MpStatus::MP_OK;
			case absl::StatusCode::kCancelled:
				return MpStatus::MP_CANCELLED;
			case absl::StatusCode::kUnknown:
				return MpStatus::MP_UNKNOWN;
			case absl::StatusCode::kInvalidArgument:
				return MpStatus::MP_INVALID_ARGUMENT;
			case absl::StatusCode::kDeadlineExceeded:
				return MpStatus::MP_DEADLINE_EXCEEDED;
			case absl::StatusCode::kNotFound:
				return MpStatus::MP_NOT_FOUND;
			case absl::StatusCode::kAlreadyExists:
				return MpStatus::MP_ALREADY_EXISTS;
			case absl::StatusCode::kPermissionDenied:
				return MpStatus::MP_PERMISSION_DENIED;
			case absl::StatusCode::kResourceExhausted:
				return MpStatus::MP_RESOURCE_EXHAUSTED;
			case absl::StatusCode::kFailedPrecondition:
				return MpStatus::MP_FAILED_PRECONDITION;
			case absl::StatusCode::kAborted:
				return MpStatus::MP_ABORTED;
			case absl::StatusCode::kOutOfRange:
				return MpStatus::MP_OUT_OF_RANGE;
			case absl::StatusCode::kUnimplemented:
				return MpStatus::MP_UNIMPLEMENTED;
			case absl::StatusCode::kInternal:
				return MpStatus::MP_INTERNAL;
			case absl::StatusCode::kUnavailable:
				return MpStatus::MP_UNAVAILABLE;
			case absl::StatusCode::kDataLoss:
				return MpStatus::MP_DATA_LOSS;
			case absl::StatusCode::kUnauthenticated:
				return MpStatus::MP_UNAUTHENTICATED;
			default:
				return MpStatus::MP_UNKNOWN;
		}
	}

	template<typename R, typename T, typename... Args>
	std::function<R(absl::StatusOr<T>, Args...)> CppConvertToResultCallback(R(*c_callback)(T*, int, const char*, Args...)) {
		if (!c_callback) {
			return nullptr;
		}

		return [c_callback](absl::StatusOr<T> status_or, Args... args) {
			if constexpr (std::is_same_v<R, void>) {
				const auto& status = status_or.status();
				const char* error_msg = status.ok() ? nullptr : status.message().data();
				c_callback(&status_or.value(), static_cast<int>(ToMpStatus(status)), error_msg, std::forward<Args>(args)...);
			} else {
				const auto& status = status_or.status();
				const char* error_msg = status.ok() ? nullptr : status.message().data();
				return c_callback(&status_or.value(), static_cast<int>(ToMpStatus(status)), error_msg, std::forward<Args>(args)...);
			}
		};
	}

	template<typename R, typename T, typename... Args>
	void CppConvertToResultCallback(R(*c_callback)(T*, int, const char*, Args...), std::function<R(absl::StatusOr<T>, Args...)>& fn, HRESULT& hr) {
		fn = CppConvertToResultCallback(c_callback);
		hr = S_OK;
	}

	template<typename R, typename T, typename... Args>
	void CppConvertToResultCallback(VARIANT* in_val, std::function<R(absl::StatusOr<T>, Args...)>& fn, HRESULT& hr) {
		using Callback = R(*)(T*, int, const char*, Args...);

		Callback c_callback = nullptr;
		hr = autoit_to(in_val, c_callback);
		if (SUCCEEDED(hr)) {
			fn = CppConvertToResultCallback(c_callback);
		}
	}

	template<typename T>
	std::unique_ptr<T> ConvertToUniquePtr(std::shared_ptr<T> sp) {
		std::unique_ptr<T> up = std::make_unique<T>();
		*up = *sp;
		return up;
	}

	template<typename T>
	absl::StatusOr<std::shared_ptr<T>> ReleaseToSharedPtr(absl::StatusOr<std::unique_ptr<T>> up) {
		if (!up.ok()) {
			return up.status();
		}
		return std::shared_ptr<T>(up.value().release());
	}

	mediapipe::Matrix CppConvertToMatrix(const cv::Mat& data, bool transpose = true);

	void CppConvertToMatrix(const std::optional<std::vector<cv::Mat>>& cv_matrixes, std::optional<std::vector<Matrix>>& mp_matrixes, HRESULT& hr, bool transpose = true);

	void CppConvertToMatrix(VARIANT* in_val, std::optional<std::vector<Matrix>>& mp_matrixes, HRESULT& hr, bool transpose = true);

	cv::Mat CppConvertToMatView(mediapipe::Matrix& matrix);

	std::optional<std::vector<cv::Mat>> CppConvertToMatView(std::optional<std::vector<Matrix>>& mp_matrixes);
}
