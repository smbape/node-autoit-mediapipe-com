#pragma once

#include "binding/solution_base.h"
#include <opencv2/core/mat.hpp>

namespace mediapipe::autoit::solutions::face_mesh {
	using namespace mediapipe::autoit::solution_base;

	static const int FACEMESH_NUM_LANDMARKS = 468;
	static const int FACEMESH_NUM_LANDMARKS_WITH_IRISES = 478;

	class CV_EXPORTS_W FaceMesh : public ::mediapipe::autoit::solution_base::SolutionBase {
	public:
		using SolutionBase::SolutionBase;

		CV_WRAP [[nodiscard]] static absl::StatusOr<std::shared_ptr<FaceMesh>> create(
			bool static_image_mode = false,
			int max_num_faces = 1,
			bool refine_landmarks = false,
			float min_detection_confidence = 0.5f,
			float min_tracking_confidence = 0.5f
		);

		CV_WRAP [[nodiscard]] absl::Status process(const cv::Mat& image, CV_OUT std::map<std::string, _variant_t>& solution_outputs);
	};
}
