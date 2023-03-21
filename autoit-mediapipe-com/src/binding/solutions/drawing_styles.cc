#include "binding/solutions/drawing_styles.h"

namespace mediapipe::autoit::solutions::drawing_styles {
	using namespace mediapipe::autoit::solutions::face_mesh_connections;
	using namespace mediapipe::autoit::solutions::hands_connections;
	using namespace mediapipe::autoit::solutions::hands;
	using namespace mediapipe::autoit::solutions::pose_connections;
	using namespace mediapipe::autoit::solutions::pose;

	static DrawingSpec GetDrawingSpectWithScale(const DrawingSpec& drawing_spec, float scale) {
		if (scale == 1.0) {
			return drawing_spec;
		}
		DrawingSpec result(drawing_spec);
		result.thickness *= scale;
		result.circle_radius *= scale;
		return result;
	}

	static const int _RADIUS = 5;
	static const DrawingColor _RED = { 48, 48, 255 };
	static const DrawingColor _GREEN = { 48, 255, 48 };
	static const DrawingColor _BLUE = { 192, 101, 21 };
	static const DrawingColor _YELLOW = { 0, 204, 255 };
	static const DrawingColor _GRAY = { 128, 128, 128 };
	static const DrawingColor _PURPLE = { 128, 64, 128 };
	static const DrawingColor _PEACH = { 180, 229, 255 };
	static const DrawingColor _WHITE = { 224, 224, 224 };

	// Hands
	static const int _THICKNESS_WRIST_MCP = 3;
	static const int _THICKNESS_FINGER = 2;
	static const int _THICKNESS_DOT = -1;

	// Hand landmarks
	static const std::vector<HandLandmark> _PALM_LANDMARKS = { HandLandmark::WRIST, HandLandmark::THUMB_CMC,
					  HandLandmark::INDEX_FINGER_MCP, HandLandmark::MIDDLE_FINGER_MCP,
					  HandLandmark::RING_FINGER_MCP, HandLandmark::PINKY_MCP };
	static const std::vector<HandLandmark> _THUMB_LANDMARKS = { HandLandmark::THUMB_MCP, HandLandmark::THUMB_IP,
						HandLandmark::THUMB_TIP };
	static const std::vector<HandLandmark> _INDEX_FINGER_LANDMARKS = { HandLandmark::INDEX_FINGER_PIP,
							   HandLandmark::INDEX_FINGER_DIP,
							   HandLandmark::INDEX_FINGER_TIP };
	static const std::vector<HandLandmark> _MIDDLE_FINGER_LANDMARKS = { HandLandmark::MIDDLE_FINGER_PIP,
								HandLandmark::MIDDLE_FINGER_DIP,
								HandLandmark::MIDDLE_FINGER_TIP };
	static const std::vector<HandLandmark> _RING_FINGER_LANDMARKS = { HandLandmark::RING_FINGER_PIP,
							  HandLandmark::RING_FINGER_DIP,
							  HandLandmark::RING_FINGER_TIP };
	static const std::vector<HandLandmark> _PINKY_FINGER_LANDMARKS = { HandLandmark::PINKY_PIP, HandLandmark::PINKY_DIP,
							   HandLandmark::PINKY_TIP };

	static const std::vector<std::tuple<std::vector<HandLandmark>, DrawingSpec>> _HAND_LANDMARK_STYLE = {
		{_PALM_LANDMARKS, DrawingSpec(_RED, _THICKNESS_DOT, _RADIUS)},
		{_THUMB_LANDMARKS, DrawingSpec(_PEACH, _THICKNESS_DOT, _RADIUS)},
		{_INDEX_FINGER_LANDMARKS, DrawingSpec(_PURPLE, _THICKNESS_DOT, _RADIUS)},
		{_MIDDLE_FINGER_LANDMARKS, DrawingSpec(_YELLOW, _THICKNESS_DOT, _RADIUS)},
		{_RING_FINGER_LANDMARKS, DrawingSpec(_GREEN, _THICKNESS_DOT, _RADIUS)},
		{_PINKY_FINGER_LANDMARKS, DrawingSpec(_BLUE, _THICKNESS_DOT, _RADIUS)},
	};

	// Hands connections
	static const std::vector<std::tuple<std::vector<std::tuple<int, int>>, DrawingSpec>> _HAND_CONNECTION_STYLE = {
		{HAND_PALM_CONNECTIONS, DrawingSpec(_GRAY, _THICKNESS_WRIST_MCP)},
		{HAND_THUMB_CONNECTIONS, DrawingSpec(_PEACH, _THICKNESS_FINGER)},
		{HAND_INDEX_FINGER_CONNECTIONS, DrawingSpec(_PURPLE, _THICKNESS_FINGER)},
		{HAND_MIDDLE_FINGER_CONNECTIONS, DrawingSpec(_YELLOW, _THICKNESS_FINGER)},
		{HAND_RING_FINGER_CONNECTIONS, DrawingSpec(_GREEN, _THICKNESS_FINGER)},
		{HAND_PINKY_FINGER_CONNECTIONS, DrawingSpec(_BLUE, _THICKNESS_FINGER)},
	};

	// FaceMesh connections
	static const int _THICKNESS_TESSELATION = 1;
	static const int _THICKNESS_CONTOURS = 2;
	static const std::vector<std::tuple<std::vector<std::tuple<int, int>>, DrawingSpec>> _FACEMESH_CONTOURS_CONNECTION_STYLE = {
		{FACEMESH_LIPS, DrawingSpec(_WHITE, _THICKNESS_CONTOURS)},
		{FACEMESH_LEFT_EYE, DrawingSpec(_GREEN, _THICKNESS_CONTOURS)},
		{FACEMESH_LEFT_EYEBROW, DrawingSpec(_GREEN, _THICKNESS_CONTOURS)},
		{FACEMESH_RIGHT_EYE, DrawingSpec(_RED, _THICKNESS_CONTOURS)},
		{FACEMESH_RIGHT_EYEBROW, DrawingSpec(_RED, _THICKNESS_CONTOURS)},
		{FACEMESH_FACE_OVAL, DrawingSpec(_WHITE, _THICKNESS_CONTOURS)},
	};

	// Pose
	static const int _THICKNESS_POSE_LANDMARKS = 2;
	static const std::vector<PoseLandmark> _POSE_LANDMARKS_LEFT = {
		PoseLandmark::LEFT_EYE_INNER, PoseLandmark::LEFT_EYE,
		PoseLandmark::LEFT_EYE_OUTER, PoseLandmark::LEFT_EAR, PoseLandmark::MOUTH_LEFT,
		PoseLandmark::LEFT_SHOULDER, PoseLandmark::LEFT_ELBOW,
		PoseLandmark::LEFT_WRIST, PoseLandmark::LEFT_PINKY, PoseLandmark::LEFT_INDEX,
		PoseLandmark::LEFT_THUMB, PoseLandmark::LEFT_HIP, PoseLandmark::LEFT_KNEE,
		PoseLandmark::LEFT_ANKLE, PoseLandmark::LEFT_HEEL,
		PoseLandmark::LEFT_FOOT_INDEX
	};

	static const std::vector<PoseLandmark> _POSE_LANDMARKS_RIGHT = {
		PoseLandmark::RIGHT_EYE_INNER, PoseLandmark::RIGHT_EYE,
		PoseLandmark::RIGHT_EYE_OUTER, PoseLandmark::RIGHT_EAR,
		PoseLandmark::MOUTH_RIGHT, PoseLandmark::RIGHT_SHOULDER,
		PoseLandmark::RIGHT_ELBOW, PoseLandmark::RIGHT_WRIST,
		PoseLandmark::RIGHT_PINKY, PoseLandmark::RIGHT_INDEX,
		PoseLandmark::RIGHT_THUMB, PoseLandmark::RIGHT_HIP, PoseLandmark::RIGHT_KNEE,
		PoseLandmark::RIGHT_ANKLE, PoseLandmark::RIGHT_HEEL,
		PoseLandmark::RIGHT_FOOT_INDEX
	};


	std::map<int, DrawingSpec> get_default_hand_landmarks_style(float scale) {
		std::map<int, DrawingSpec> hand_landmark_style;
		for (const auto& [k, v] : _HAND_LANDMARK_STYLE) {
			DrawingSpec drawing_spec = GetDrawingSpectWithScale(v, scale);
			for (const auto& landmark : k) {
				hand_landmark_style.insert_or_assign(static_cast<int>(landmark), drawing_spec);
			}
		}
		return hand_landmark_style;
	}

	std::map<int, std::map<int, DrawingSpec>> get_default_hand_connections_style(float scale) {
		std::map<int, std::map<int, DrawingSpec>> hand_connection_style;
		for (const auto& [k, v] : _HAND_CONNECTION_STYLE) {
			DrawingSpec drawing_spec = GetDrawingSpectWithScale(v, scale);
			for (const auto& [start, end] : k) {
				if (!hand_connection_style.count(start)) {
					hand_connection_style.insert_or_assign(start, std::map<int, DrawingSpec>());
				}
				hand_connection_style.at(start).insert_or_assign(end, drawing_spec);
			}
		}
		return hand_connection_style;
	}

	std::map<int, std::map<int, DrawingSpec>> get_default_face_mesh_contours_style(float scale) {
		std::map<int, std::map<int, DrawingSpec>> face_mesh_contours_connection_style;
		for (const auto& [k, v] : _FACEMESH_CONTOURS_CONNECTION_STYLE) {
			DrawingSpec drawing_spec = GetDrawingSpectWithScale(v, scale);
			for (const auto& [start, end] : k) {
				if (!face_mesh_contours_connection_style.count(start)) {
					face_mesh_contours_connection_style.insert_or_assign(start, std::map<int, DrawingSpec>());
				}
				face_mesh_contours_connection_style.at(start).insert_or_assign(end, drawing_spec);
			}
		}
		return face_mesh_contours_connection_style;
	}

	DrawingSpec get_default_face_mesh_tesselation_style(float scale) {
		return DrawingSpec(_GRAY, _THICKNESS_TESSELATION * scale);
	}

	std::map<int, std::map<int, DrawingSpec>> get_default_face_mesh_iris_connections_style(float scale) {
		std::map<int, std::map<int, DrawingSpec>> face_mesh_iris_connections_style;

		DrawingSpec left_spec(_GREEN, _THICKNESS_CONTOURS * scale);
		for (const auto& [start, end] : FACEMESH_LEFT_IRIS) {
			if (!face_mesh_iris_connections_style.count(start)) {
				face_mesh_iris_connections_style.insert_or_assign(start, std::map<int, DrawingSpec>());
			}
			face_mesh_iris_connections_style.at(start).insert_or_assign(end, left_spec);
		}

		DrawingSpec right_spec(_RED, _THICKNESS_CONTOURS * scale);
		for (const auto& [start, end] : FACEMESH_RIGHT_IRIS) {
			if (!face_mesh_iris_connections_style.count(start)) {
				face_mesh_iris_connections_style.insert_or_assign(start, std::map<int, DrawingSpec>());
			}
			face_mesh_iris_connections_style.at(start).insert_or_assign(end, right_spec);
		}

		return face_mesh_iris_connections_style;
	}

	std::map<int, DrawingSpec> get_default_pose_landmarks_style(float scale) {
		std::map<int, DrawingSpec> pose_landmark_style;

		DrawingSpec left_spec({ 0, 138, 255 }, _THICKNESS_POSE_LANDMARKS * scale);
		for (const auto& landmark : _POSE_LANDMARKS_LEFT) {
			pose_landmark_style.insert_or_assign(static_cast<int>(landmark), left_spec);
		}

		DrawingSpec right_spec({ 231, 217, 0 }, _THICKNESS_POSE_LANDMARKS * scale);
		for (const auto& landmark : _POSE_LANDMARKS_RIGHT) {
			pose_landmark_style.insert_or_assign(static_cast<int>(landmark), right_spec);
		}

		pose_landmark_style.insert_or_assign(static_cast<int>(PoseLandmark::NOSE), DrawingSpec(_WHITE, _THICKNESS_POSE_LANDMARKS * scale));

		return pose_landmark_style;
	}

}
