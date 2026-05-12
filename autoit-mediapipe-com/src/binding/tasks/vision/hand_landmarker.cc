#include "binding/tasks/vision/hand_landmarker.h"

namespace mediapipe::tasks::vision::hand_landmarker {
	using Connection = HandLandmarksConnections::Connection;

	const std::vector<Connection>& HandLandmarksConnections::HAND_PALM_CONNECTIONS() {
		static const std::vector<Connection> HAND_PALM_CONNECTIONS = {
			{ 0, 1 },
			{ 1, 5 },
			{ 9, 13 },
			{ 13, 17 },
			{ 5, 9 },
			{ 0, 17 },


			{ 1, 2 },
			{ 2, 3 },
			{ 3, 4 },


			{ 5, 6 },
			{ 6, 7 },
			{ 7, 8 },


			{ 9, 10 },
			{ 10, 11 },
			{ 11, 12 },


			{ 13, 14 },
			{ 14, 15 },
			{ 15, 16 },


			{ 17, 18 },
			{ 18, 19 },
			{ 19, 20 },
		};

		return HAND_PALM_CONNECTIONS;
	}

	const std::vector<Connection>& HandLandmarksConnections::HAND_THUMB_CONNECTIONS() {
		static const std::vector<Connection> HAND_THUMB_CONNECTIONS = {
			{ 0, 1 },
			{ 1, 5 },
			{ 9, 13 },
			{ 13, 17 },
			{ 5, 9 },
			{ 0, 17 },


			{ 1, 2 },
			{ 2, 3 },
			{ 3, 4 },


			{ 5, 6 },
			{ 6, 7 },
			{ 7, 8 },


			{ 9, 10 },
			{ 10, 11 },
			{ 11, 12 },


			{ 13, 14 },
			{ 14, 15 },
			{ 15, 16 },


			{ 17, 18 },
			{ 18, 19 },
			{ 19, 20 },
		};

		return HAND_THUMB_CONNECTIONS;
	}

	const std::vector<Connection>& HandLandmarksConnections::HAND_INDEX_FINGER_CONNECTIONS() {
		static const std::vector<Connection> HAND_INDEX_FINGER_CONNECTIONS = {
			{ 0, 1 },
			{ 1, 5 },
			{ 9, 13 },
			{ 13, 17 },
			{ 5, 9 },
			{ 0, 17 },


			{ 1, 2 },
			{ 2, 3 },
			{ 3, 4 },


			{ 5, 6 },
			{ 6, 7 },
			{ 7, 8 },


			{ 9, 10 },
			{ 10, 11 },
			{ 11, 12 },


			{ 13, 14 },
			{ 14, 15 },
			{ 15, 16 },


			{ 17, 18 },
			{ 18, 19 },
			{ 19, 20 },
		};

		return HAND_INDEX_FINGER_CONNECTIONS;
	}

	const std::vector<Connection>& HandLandmarksConnections::HAND_MIDDLE_FINGER_CONNECTIONS() {
		static const std::vector<Connection> HAND_MIDDLE_FINGER_CONNECTIONS = {
			{ 0, 1 },
			{ 1, 5 },
			{ 9, 13 },
			{ 13, 17 },
			{ 5, 9 },
			{ 0, 17 },


			{ 1, 2 },
			{ 2, 3 },
			{ 3, 4 },


			{ 5, 6 },
			{ 6, 7 },
			{ 7, 8 },


			{ 9, 10 },
			{ 10, 11 },
			{ 11, 12 },


			{ 13, 14 },
			{ 14, 15 },
			{ 15, 16 },


			{ 17, 18 },
			{ 18, 19 },
			{ 19, 20 },
		};

		return HAND_MIDDLE_FINGER_CONNECTIONS;
	}

	const std::vector<Connection>& HandLandmarksConnections::HAND_RING_FINGER_CONNECTIONS() {
		static const std::vector<Connection> HAND_RING_FINGER_CONNECTIONS = {
			{ 0, 1 },
			{ 1, 5 },
			{ 9, 13 },
			{ 13, 17 },
			{ 5, 9 },
			{ 0, 17 },


			{ 1, 2 },
			{ 2, 3 },
			{ 3, 4 },


			{ 5, 6 },
			{ 6, 7 },
			{ 7, 8 },


			{ 9, 10 },
			{ 10, 11 },
			{ 11, 12 },


			{ 13, 14 },
			{ 14, 15 },
			{ 15, 16 },


			{ 17, 18 },
			{ 18, 19 },
			{ 19, 20 },
		};

		return HAND_RING_FINGER_CONNECTIONS;
	}

	const std::vector<Connection>& HandLandmarksConnections::HAND_PINKY_FINGER_CONNECTIONS() {
		static const std::vector<Connection> HAND_PINKY_FINGER_CONNECTIONS = {
			{ 0, 1 },
			{ 1, 5 },
			{ 9, 13 },
			{ 13, 17 },
			{ 5, 9 },
			{ 0, 17 },


			{ 1, 2 },
			{ 2, 3 },
			{ 3, 4 },


			{ 5, 6 },
			{ 6, 7 },
			{ 7, 8 },


			{ 9, 10 },
			{ 10, 11 },
			{ 11, 12 },


			{ 13, 14 },
			{ 14, 15 },
			{ 15, 16 },


			{ 17, 18 },
			{ 18, 19 },
			{ 19, 20 },
		};

		return HAND_PINKY_FINGER_CONNECTIONS;
	}

	const std::vector<Connection>& HandLandmarksConnections::HAND_CONNECTIONS() {
		static const std::vector<Connection> HAND_CONNECTIONS = []() {
			std::vector<Connection> connections;

			// preallocate memory
			connections.reserve(
				HandLandmarksConnections::HAND_PALM_CONNECTIONS().size() +
				HandLandmarksConnections::HAND_THUMB_CONNECTIONS().size() +
				HandLandmarksConnections::HAND_INDEX_FINGER_CONNECTIONS().size() +
				HandLandmarksConnections::HAND_MIDDLE_FINGER_CONNECTIONS().size() +
				HandLandmarksConnections::HAND_RING_FINGER_CONNECTIONS().size() +
				HandLandmarksConnections::HAND_PINKY_FINGER_CONNECTIONS().size()
			);

			connections.insert(connections.end(), HandLandmarksConnections::HAND_PALM_CONNECTIONS().begin(), HandLandmarksConnections::HAND_PALM_CONNECTIONS().end());
			connections.insert(connections.end(), HandLandmarksConnections::HAND_THUMB_CONNECTIONS().begin(), HandLandmarksConnections::HAND_THUMB_CONNECTIONS().end());
			connections.insert(connections.end(), HandLandmarksConnections::HAND_INDEX_FINGER_CONNECTIONS().begin(), HandLandmarksConnections::HAND_INDEX_FINGER_CONNECTIONS().end());
			connections.insert(connections.end(), HandLandmarksConnections::HAND_MIDDLE_FINGER_CONNECTIONS().begin(), HandLandmarksConnections::HAND_MIDDLE_FINGER_CONNECTIONS().end());
			connections.insert(connections.end(), HandLandmarksConnections::HAND_RING_FINGER_CONNECTIONS().begin(), HandLandmarksConnections::HAND_RING_FINGER_CONNECTIONS().end());
			connections.insert(connections.end(), HandLandmarksConnections::HAND_PINKY_FINGER_CONNECTIONS().begin(), HandLandmarksConnections::HAND_PINKY_FINGER_CONNECTIONS().end());

			return connections;
		}();

		return HAND_CONNECTIONS;
	}
}

PTR_BRIDGE_IMPL(mediapipe::tasks::vision::hand_landmarker::HandLandmarkerResultRawCallback);

template<typename _In, typename _Out>
inline const HRESULT autoit_to_callback(VARIANT const* in_val, _Out& result_callback) {
	_In c_callback;
	HRESULT hr = autoit_to(in_val, c_callback);
	if (SUCCEEDED(hr)) {
		result_callback = ::mediapipe::tasks::autoit::core::utils::CppConvertToResultCallback(c_callback);
	}
	return hr;
}

const HRESULT autoit_to(VARIANT const* in_val, mediapipe::tasks::vision::hand_landmarker::HandLandmarkerResultCallback& result_callback) {
	using _In = mediapipe::tasks::vision::hand_landmarker::HandLandmarkerResultRawCallback;
	using _Out = mediapipe::tasks::vision::hand_landmarker::HandLandmarkerResultCallback;
	return autoit_to_callback<_In, _Out>(in_val, result_callback);
}
