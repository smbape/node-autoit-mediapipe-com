#pragma once

#include "binding/tasks/vision/drawing_utils.h"
#include "binding/tasks/vision/face_landmarker.h"
#include "binding/tasks/vision/hand_landmarker.h"
#include "binding/tasks/vision/pose_landmarker.h"

namespace mediapipe::tasks::autoit::vision::drawing_styles {
	CV_WRAP std::map<int, drawing_utils::DrawingSpec> get_default_hand_landmarks_style(float scale = 1.0);
	CV_WRAP std::map<int, std::map<int, drawing_utils::DrawingSpec>> get_default_hand_connections_style(float scale = 1.0);
	CV_WRAP std::map<int, std::map<int, drawing_utils::DrawingSpec>> get_default_face_mesh_contours_style(int style = 0, float scale = 1.0);
	CV_WRAP drawing_utils::DrawingSpec get_default_face_mesh_tesselation_style(float scale = 1.0);
	CV_WRAP std::map<int, std::map<int, drawing_utils::DrawingSpec>> get_default_face_mesh_iris_connections_style(float scale = 1.0);
	CV_WRAP std::map<int, drawing_utils::DrawingSpec> get_default_pose_landmarks_style(float scale = 1.0);
}
