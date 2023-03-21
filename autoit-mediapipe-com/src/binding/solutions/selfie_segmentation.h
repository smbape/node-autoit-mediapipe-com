#pragma once

#include "binding/solution_base.h"

namespace mediapipe::autoit::solutions::selfie_segmentation {
	using namespace mediapipe::autoit::solution_base;

	class CV_EXPORTS_W SelfieSegmentation : public SolutionBase {
	public:
		CV_WRAP SelfieSegmentation(BYTE model_selection = 0);
		CV_WRAP void process(const cv::Mat& image, CV_OUT std::map<std::string, _variant_t>& solution_outputs);
	};
}
