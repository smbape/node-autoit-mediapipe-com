#pragma once

#include "binding/solution_base.h"

namespace mediapipe {
	namespace autoit {
		namespace solutions {
			namespace face_mesh {
				using namespace mediapipe::autoit::solution_base;

				static const int FACEMESH_NUM_LANDMARKS = 468;
				static const int FACEMESH_NUM_LANDMARKS_WITH_IRISES = 478;

				class CV_EXPORTS_W FaceMesh : public SolutionBase {
				public:
					CV_WRAP FaceMesh(
						bool static_image_mode = false,
						int max_num_faces = 1,
						bool refine_landmarks = false,
						float min_detection_confidence = 0.5f,
						float min_tracking_confidence = 0.5f
					);

					CV_WRAP void process(const cv::Mat& image, CV_OUT std::map<std::string, _variant_t>& solution_outputs);
				};
			}
		}
	}
}
