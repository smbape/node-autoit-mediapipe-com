#pragma once

#include "mediapipe/framework/formats/detection.pb.h"
#include "mediapipe/framework/formats/location_data.pb.h"
#include "mediapipe/framework/formats/landmark.pb.h"

namespace mediapipe {
	namespace autoit {
		namespace solutions {
			namespace drawing_utils {
				typedef std::tuple<int, int, int> DrawingColor;

				static const DrawingColor WHITE_COLOR = { 224, 224, 224 };
				static const DrawingColor BLACK_COLOR = { 0, 0, 0 };
				static const DrawingColor RED_COLOR = { 0, 0, 255 };
				static const DrawingColor GREEN_COLOR = { 0, 128, 0 };
				static const DrawingColor BLUE_COLOR = { 255, 0, 0 };

				struct CV_EXPORTS_W_SIMPLE DrawingSpec {
					CV_WRAP DrawingSpec(
						DrawingColor color = WHITE_COLOR,
						int thickness = 2,
						int circle_radius = 2
					) : color(color), thickness(thickness), circle_radius(circle_radius) {}

					CV_WRAP DrawingSpec(const DrawingSpec& other) = default;

					// Color for drawing the annotation. Default to the white color.
					CV_PROP_RW DrawingColor color;
					// Thickness for drawing the annotation. Default to 2 pixels.
					CV_PROP_RW int thickness;
					// Circle radius. Default to 2 pixels.
					CV_PROP_RW int circle_radius;
				};

				CV_WRAP void draw_detection(
					cv::Mat& image,
					const Detection& detection,
					const DrawingSpec& keypoint_drawing_spec = DrawingSpec(RED_COLOR),
					const DrawingSpec& bbox_drawing_spec = DrawingSpec()
				);

				CV_WRAP void draw_landmarks(
					cv::Mat& image,
					const NormalizedLandmarkList& landmark_list,
					const std::vector<std::tuple<int, int>>& connections = std::vector<std::tuple<int, int>>(),
					const DrawingSpec& landmark_drawing_spec = DrawingSpec(RED_COLOR),
					const DrawingSpec& connection_drawing_spec = DrawingSpec()
				);

				CV_WRAP void draw_landmarks(
					cv::Mat& image,
					const NormalizedLandmarkList& landmark_list,
					const std::vector<std::tuple<int, int>>& connections = std::vector<std::tuple<int, int>>(),
					const std::map<int, DrawingSpec>& landmark_drawing_spec = std::map<int, DrawingSpec>(),
					const DrawingSpec& connection_drawing_spec = DrawingSpec()
				);

				CV_WRAP void draw_landmarks(
					cv::Mat& image,
					const NormalizedLandmarkList& landmark_list,
					const std::vector<std::tuple<int, int>>& connections = std::vector<std::tuple<int, int>>(),
					const DrawingSpec& landmark_drawing_spec = DrawingSpec(RED_COLOR),
					const std::map<int, std::map<int, DrawingSpec>>& connection_drawing_spec = std::map<int, std::map<int, DrawingSpec>>()
				);

				CV_WRAP void draw_landmarks(
					cv::Mat& image,
					const NormalizedLandmarkList& landmark_list,
					const std::vector<std::tuple<int, int>>& connections = std::vector<std::tuple<int, int>>(),
					const std::map<int, DrawingSpec>& landmark_drawing_spec = std::map<int, DrawingSpec>(),
					const std::map<int, std::map<int, DrawingSpec>>& connection_drawing_spec = std::map<int, std::map<int, DrawingSpec>>()
				);

				CV_WRAP void draw_axis(
					cv::Mat& image,
					cv::Mat& rotation,
					cv::Mat& translation,
					const std::tuple<float, float>& focal_length = std::tuple<float, float>(1.0f, 1.0f),
					const std::tuple<float, float>& principal_point = std::tuple<float, float>(0.0f, 0.0f),
					float axis_length = 0.1,
					const DrawingSpec& axis_drawing_spec = DrawingSpec()
				);
			}
		}
	}
}
