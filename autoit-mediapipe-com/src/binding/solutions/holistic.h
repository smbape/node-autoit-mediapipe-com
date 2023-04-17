#pragma once

#include "mediapipe/framework/formats/landmark.pb.h"
#include "binding/solution_base.h"

namespace mediapipe::autoit::solutions::holistic {
	using namespace mediapipe::autoit::solution_base;

	class CV_EXPORTS_W Holistic : public ::mediapipe::autoit::solution_base::SolutionBase {
	public:
		CV_WRAP Holistic(
			bool static_image_mode = false,
			BYTE model_complexity = 1,
			bool smooth_landmarks = true,
			bool enable_segmentation = false,
			bool smooth_segmentation = true,
			bool refine_face_landmarks = false,
			float min_detection_confidence = 0.5f,
			float min_tracking_confidence = 0.5f
		);

		CV_WRAP void process(const cv::Mat& image, CV_OUT std::map<std::string, _variant_t>& solution_outputs);
	};
}
