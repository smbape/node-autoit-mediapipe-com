#include "binding/solutions/face_detection.h"
#include "Cv_Mat_Object.h"

static const std::string _SHORT_RANGE_GRAPH_FILE_PATH = "mediapipe/modules/face_detection/face_detection_short_range_cpu.binarypb";
static const std::string _FULL_RANGE_GRAPH_FILE_PATH = "mediapipe/modules/face_detection/face_detection_full_range_cpu.binarypb";

namespace mediapipe {
	namespace autoit {
		namespace solutions {
			namespace face_detection {
				std::shared_ptr<LocationData::RelativeKeypoint> get_key_point(
					const Detection& detection,
					FaceKeyPoint key_point_enum
				) {
					if (!detection.has_location_data()) {
						return std::shared_ptr<LocationData::RelativeKeypoint>();
					}

					const auto& index = static_cast<int>(key_point_enum);
					return std::make_shared<LocationData::RelativeKeypoint>(detection.location_data().relative_keypoints(index));
				}

				FaceDetection::FaceDetection(
					float min_detection_confidence,
					short model_selection
				) : SolutionBase(
					FaceDetection::GetModelPath(model_selection),
					noMap(),
					SolutionBase::create_graph_options(std::make_shared<FaceDetectionOptions>(), { {"min_score_thresh", _variant_t(model_selection)} }),
					noMap(),
					{ "detections" },
					noTypeMap()
				) {
					// Nothing to do
				}

				void FaceDetection::process(const cv::Mat& image, CV_OUT std::map<std::string, _variant_t>& solution_outputs) {
					_variant_t input_data_variant;
					VARIANT* out_val = &input_data_variant;
					autoit_from(::autoit::reference_internal(&image), out_val);
					std::map<std::string, _variant_t> input_dict;
					input_dict["image"] = input_data_variant;

					SolutionBase::process(input_dict, solution_outputs);
				}

				const std::string& FaceDetection::GetModelPath(short model_selection) {
					return model_selection == 1 ? _FULL_RANGE_GRAPH_FILE_PATH : _SHORT_RANGE_GRAPH_FILE_PATH;
				}
			}
		}
	}
}
