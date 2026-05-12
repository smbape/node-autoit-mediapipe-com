#include "binding/tasks/vision/pose_landmarker.h"

namespace mediapipe::tasks::vision::pose_landmarker {
	using Connection = PoseLandmarksConnections::Connection;

	const std::vector<Connection>& PoseLandmarksConnections::POSE_LANDMARKS() {
		static const std::vector<Connection> POSE_LANDMARKS = {
			{ 0, 1 },
			{ 1, 2 },
			{ 2, 3 },
			{ 3, 7 },
			{ 0, 4 },
			{ 4, 5 },
			{ 5, 6 },
			{ 6, 8 },
			{ 9, 10 },
			{ 11, 12 },
			{ 11, 13 },
			{ 13, 15 },
			{ 15, 17 },
			{ 15, 19 },
			{ 15, 21 },
			{ 17, 19 },
			{ 12, 14 },
			{ 14, 16 },
			{ 16, 18 },
			{ 16, 20 },
			{ 16, 22 },
			{ 18, 20 },
			{ 11, 23 },
			{ 12, 24 },
			{ 23, 24 },
			{ 23, 25 },
			{ 24, 26 },
			{ 25, 27 },
			{ 26, 28 },
			{ 27, 29 },
			{ 28, 30 },
			{ 29, 31 },
			{ 30, 32 },
			{ 27, 31 },
			{ 28, 32 },
		};

		return POSE_LANDMARKS;
	}
}

PTR_BRIDGE_IMPL(mediapipe::tasks::vision::pose_landmarker::PoseLandmarkerResultRawCallback);

template<typename _In, typename _Out>
inline const HRESULT autoit_to_callback(VARIANT const* in_val, _Out& result_callback) {
	_In c_callback;
	HRESULT hr = autoit_to(in_val, c_callback);
	if (SUCCEEDED(hr)) {
		result_callback = ::mediapipe::tasks::autoit::core::utils::CppConvertToResultCallback(c_callback);
	}
	return hr;
}

const HRESULT autoit_to(VARIANT const* in_val, mediapipe::tasks::vision::pose_landmarker::PoseLandmarkerResultCallback& result_callback) {
	using _In = mediapipe::tasks::vision::pose_landmarker::PoseLandmarkerResultRawCallback;
	using _Out = mediapipe::tasks::vision::pose_landmarker::PoseLandmarkerResultCallback;
	return autoit_to_callback<_In, _Out>(in_val, result_callback);
}
