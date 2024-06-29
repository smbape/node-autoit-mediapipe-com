#pragma once

#include "binding/solutions/face_mesh_connections.h"

#include "binding/solutions/drawing_utils.h"
#include "binding/solutions/hands_connections.h"
#include "binding/solutions/hands.h"
#include "binding/solutions/pose.h"

namespace mediapipe::autoit::solutions::drawing_styles {
	using namespace mediapipe::autoit::solutions::drawing_utils;

	CV_WRAP std::map<int, DrawingSpec> get_default_hand_landmarks_style(float scale = 1.0);
	CV_WRAP std::map<int, std::map<int, DrawingSpec>> get_default_hand_connections_style(float scale = 1.0);
	CV_WRAP std::map<int, std::map<int, DrawingSpec>> get_default_face_mesh_contours_style(int i = 0, float scale = 1.0);
	CV_WRAP DrawingSpec get_default_face_mesh_tesselation_style(float scale = 1.0);
	CV_WRAP std::map<int, std::map<int, DrawingSpec>> get_default_face_mesh_iris_connections_style(float scale = 1.0);
	CV_WRAP std::map<int, DrawingSpec> get_default_pose_landmarks_style(float scale = 1.0);
}
