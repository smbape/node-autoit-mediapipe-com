#pragma once

#include "mediapipe/framework/formats/landmark.pb.h"
#include "binding/solution_base.h"
#include <opencv2/core/mat.hpp>

namespace mediapipe::autoit::solutions::holistic {
	using namespace mediapipe::autoit::solution_base;

	class CV_EXPORTS_W Holistic : public ::mediapipe::autoit::solution_base::SolutionBase {
	public:
		using SolutionBase::SolutionBase;

		CV_WRAP [[nodiscard]] static absl::StatusOr<std::shared_ptr<Holistic>> create(
			bool static_image_mode = false,
			uint8_t model_complexity = 1,
			bool smooth_landmarks = true,
			bool enable_segmentation = false,
			bool smooth_segmentation = true,
			bool refine_face_landmarks = false,
			float min_detection_confidence = 0.5f,
			float min_tracking_confidence = 0.5f
		);

		CV_WRAP [[nodiscard]] absl::Status process(const cv::Mat& image, CV_OUT std::map<std::string, _variant_t>& solution_outputs);
	};
}
