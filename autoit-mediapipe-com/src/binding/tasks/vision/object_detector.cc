#include "binding/tasks/vision/object_detector.h"

PTR_BRIDGE_IMPL(mediapipe::tasks::vision::object_detector::ObjectDetectorResultRawCallback);

template<typename _In, typename _Out>
inline const HRESULT autoit_to_callback(VARIANT const* in_val, _Out& result_callback) {
	_In c_callback;
	HRESULT hr = autoit_to(in_val, c_callback);
	if (SUCCEEDED(hr)) {
		result_callback = ::mediapipe::tasks::autoit::core::utils::CppConvertToResultCallback(c_callback);
	}
	return hr;
}

const HRESULT autoit_to(VARIANT const* in_val, mediapipe::tasks::vision::object_detector::ObjectDetectorResultCallback& result_callback) {
	using _In = mediapipe::tasks::vision::object_detector::ObjectDetectorResultRawCallback;
	using _Out = mediapipe::tasks::vision::object_detector::ObjectDetectorResultCallback;
	return autoit_to_callback<_In, _Out>(in_val, result_callback);
}
