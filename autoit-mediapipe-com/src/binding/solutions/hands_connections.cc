#include "binding/solutions/hands_connections.h";

namespace mediapipe::autoit::solutions::hands_connections {
	static std::vector<std::tuple<int, int>> getHandConnections() {
		std::vector<std::tuple<int, int>> connections;

		// preallocate memory
		connections.reserve(
			HAND_PALM_CONNECTIONS.size() +
			HAND_THUMB_CONNECTIONS.size() +
			HAND_INDEX_FINGER_CONNECTIONS.size() +
			HAND_MIDDLE_FINGER_CONNECTIONS.size() +
			HAND_RING_FINGER_CONNECTIONS.size() +
			HAND_PINKY_FINGER_CONNECTIONS.size()
		);

		connections.insert(connections.end(), HAND_PALM_CONNECTIONS.begin(), HAND_PALM_CONNECTIONS.end());
		connections.insert(connections.end(), HAND_THUMB_CONNECTIONS.begin(), HAND_THUMB_CONNECTIONS.end());
		connections.insert(connections.end(), HAND_INDEX_FINGER_CONNECTIONS.begin(), HAND_INDEX_FINGER_CONNECTIONS.end());
		connections.insert(connections.end(), HAND_MIDDLE_FINGER_CONNECTIONS.begin(), HAND_MIDDLE_FINGER_CONNECTIONS.end());
		connections.insert(connections.end(), HAND_RING_FINGER_CONNECTIONS.begin(), HAND_RING_FINGER_CONNECTIONS.end());
		connections.insert(connections.end(), HAND_PINKY_FINGER_CONNECTIONS.begin(), HAND_PINKY_FINGER_CONNECTIONS.end());

		return connections;
	}

	std::vector<std::tuple<int, int>> HAND_CONNECTIONS = getHandConnections();
}
