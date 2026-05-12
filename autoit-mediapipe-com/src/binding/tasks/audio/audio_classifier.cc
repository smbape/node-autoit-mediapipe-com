#include "binding/tasks/audio/audio_classifier.h"

PTR_BRIDGE_IMPL(mediapipe::tasks::audio::audio_classifier::AudioClassifierResultRawCallback);

template<typename _In, typename _Out>
inline const HRESULT autoit_to_callback(VARIANT const* in_val, _Out& result_callback) {
	_In c_callback;
	HRESULT hr = autoit_to(in_val, c_callback);
	if (SUCCEEDED(hr)) {
		result_callback = ::mediapipe::tasks::autoit::core::utils::CppConvertToResultCallback(c_callback);
	}
	return hr;
}

const HRESULT autoit_to(VARIANT const* in_val, mediapipe::tasks::audio::audio_classifier::AudioClassifierResultCallback& result_callback) {
	using _In = mediapipe::tasks::audio::audio_classifier::AudioClassifierResultRawCallback;
	using _Out = mediapipe::tasks::audio::audio_classifier::AudioClassifierResultCallback;
	return autoit_to_callback<_In, _Out>(in_val, result_callback);
}
