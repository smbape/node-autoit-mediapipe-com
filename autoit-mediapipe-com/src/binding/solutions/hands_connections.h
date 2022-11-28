#pragma once

#include <tuple>
#include <vector>

namespace mediapipe {
	namespace autoit {
		namespace solutions {
			namespace hands_connections {

				static const std::vector<std::tuple<int, int>> HAND_PALM_CONNECTIONS = { {0, 1}, {0, 5}, {9, 13}, {13, 17}, {5, 9}, {0, 17} };

				static const std::vector<std::tuple<int, int>> HAND_THUMB_CONNECTIONS = { {1, 2}, {2, 3}, {3, 4} };

				static const std::vector<std::tuple<int, int>> HAND_INDEX_FINGER_CONNECTIONS = { {5, 6}, {6, 7}, {7, 8} };

				static const std::vector<std::tuple<int, int>> HAND_MIDDLE_FINGER_CONNECTIONS = { {9, 10}, {10, 11}, {11, 12} };

				static const std::vector<std::tuple<int, int>> HAND_RING_FINGER_CONNECTIONS = { {13, 14}, {14, 15}, {15, 16} };

				static const std::vector<std::tuple<int, int>> HAND_PINKY_FINGER_CONNECTIONS = { {17, 18}, {18, 19}, {19, 20} };

				extern std::vector<std::tuple<int, int>> HAND_CONNECTIONS;
			}
		}
	}
}
