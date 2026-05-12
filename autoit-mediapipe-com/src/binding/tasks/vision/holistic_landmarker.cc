#include "binding/tasks/vision/holistic_landmarker.h"

PTR_BRIDGE_IMPL(mediapipe::tasks::vision::holistic_landmarker::HolisticLandmarkerResultRawCallback);

template<typename _In, typename _Out>
inline const HRESULT autoit_to_callback(VARIANT const* in_val, _Out& result_callback) {
	_In c_callback;
	HRESULT hr = autoit_to(in_val, c_callback);
	if (SUCCEEDED(hr)) {
		result_callback = ::mediapipe::tasks::autoit::core::utils::CppConvertToResultCallback(c_callback);
	}
	return hr;
}

const HRESULT autoit_to(VARIANT const* in_val, mediapipe::tasks::vision::holistic_landmarker::HolisticLandmarkerResultCallback& result_callback) {
	using _In = mediapipe::tasks::vision::holistic_landmarker::HolisticLandmarkerResultRawCallback;
	using _Out = mediapipe::tasks::vision::holistic_landmarker::HolisticLandmarkerResultCallback;
	return autoit_to_callback<_In, _Out>(in_val, result_callback);
}
