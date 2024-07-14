#pragma once

#include "binding/solution_base.h"

namespace mediapipe::autoit::solutions::selfie_segmentation {
	using namespace mediapipe::autoit::solution_base;

	class CV_EXPORTS_W SelfieSegmentation : public ::mediapipe::autoit::solution_base::SolutionBase {
	public:
		using SolutionBase::SolutionBase;
		CV_WRAP [[nodiscard]] static absl::StatusOr<std::shared_ptr<SelfieSegmentation>> create(uchar model_selection = 0);
		CV_WRAP [[nodiscard]] absl::Status process(const cv::Mat& image, CV_OUT std::map<std::string, _variant_t>& solution_outputs);
	};
}
