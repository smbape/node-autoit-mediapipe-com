#include "binding/tasks/vision/gesture_recognizer.h"

namespace mediapipe::tasks::autoit::core::utils {
	tasks::vision::gesture_recognizer::GestureRecognizerResultCallback CppConvertToGestureRecognizerResultCallback(
		tasks::vision::gesture_recognizer::GestureRecognizerResultRawCallback c_callback
	) {
		return [c_callback](absl::StatusOr<tasks::vision::gesture_recognizer::GestureRecognizerResult> _status_or, const Image& image, int64_t timestamp) {
			auto status_or = tasks::autoit::vision::gesture_recognizer::ConvertToGestureRecognizerResult(_status_or);

			const auto& status = status_or.status();
			const char* error_msg = status.ok() ? nullptr : status.message().data();
			c_callback(&status_or.value(), static_cast<int>(core::utils::ToMpStatus(status)), error_msg, image, timestamp);
		};
	}

	void CppConvertToGestureRecognizerResultCallback(tasks::vision::gesture_recognizer::GestureRecognizerResultRawCallback c_callback, tasks::vision::gesture_recognizer::GestureRecognizerResultCallback& fn, HRESULT& hr) {
		fn = CppConvertToGestureRecognizerResultCallback(c_callback);
		hr = S_OK;
	}

	void CppConvertToGestureRecognizerResultCallback(VARIANT* in_val, tasks::vision::gesture_recognizer::GestureRecognizerResultCallback& fn, HRESULT& hr) {
		using Callback = tasks::vision::gesture_recognizer::GestureRecognizerResultRawCallback;

		Callback c_callback = nullptr;
		hr = autoit_to(in_val, c_callback);
		if (SUCCEEDED(hr)) {
			fn = CppConvertToGestureRecognizerResultCallback(c_callback);
		}
	}
}

PTR_BRIDGE_IMPL(mediapipe::tasks::vision::gesture_recognizer::GestureRecognizerResultRawCallback);

template<typename _In, typename _Out>
inline const HRESULT autoit_to_callback(VARIANT const* in_val, _Out& result_callback) {
	_In c_callback;
	HRESULT hr = autoit_to(in_val, c_callback);
	if (SUCCEEDED(hr)) {
		result_callback = ::mediapipe::tasks::autoit::core::utils::CppConvertToGestureRecognizerResultCallback(c_callback);
	}
	return hr;
}

const HRESULT autoit_to(VARIANT const* in_val, mediapipe::tasks::vision::gesture_recognizer::GestureRecognizerResultCallback& result_callback) {
	using _In = mediapipe::tasks::vision::gesture_recognizer::GestureRecognizerResultRawCallback;
	using _Out = mediapipe::tasks::vision::gesture_recognizer::GestureRecognizerResultCallback;
	return autoit_to_callback<_In, _Out>(in_val, result_callback);
}
