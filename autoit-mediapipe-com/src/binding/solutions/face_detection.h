#pragma once

#include "binding/solution_base.h"
#include "mediapipe/modules/face_detection/face_detection.pb.h"

namespace mediapipe {
	namespace autoit {
		namespace solutions {
			namespace face_detection {
				using namespace mediapipe::autoit::solution_base;

				enum class FaceKeyPoint {
					RIGHT_EYE = 0,
					LEFT_EYE = 1,
					NOSE_TIP = 2,
					MOUTH_CENTER = 3,
					RIGHT_EAR_TRAGION = 4,
					LEFT_EAR_TRAGION = 5,
				};

				CV_WRAP std::shared_ptr<LocationData::RelativeKeypoint> get_key_point(
					const Detection& detection,
					FaceKeyPoint key_point_enum
				);

				class CV_EXPORTS_W FaceDetection : public SolutionBase {
				public:
					CV_WRAP FaceDetection(
						float min_detection_confidence = 0,
						short model_selection = 0
					);

					CV_WRAP void process(const cv::Mat& image, CV_OUT std::map<std::string, _variant_t>& solution_outputs);
				private:
					static const std::string& GetModelPath(short model_selection);
				};
			}
		}
	}
}
