#include "binding/solutions/face_detection.h"
#include "binding/solutions/download_utils.h"
#include "Cv_Mat_Object.h"

static const std::string _BINARYPB_FILE_PATH = "mediapipe/modules/selfie_segmentation/selfie_segmentation_cpu.binarypb";
static const std::string _GENERAL_TFLITE_FILE_PATH = "mediapipe/modules/selfie_segmentation/selfie_segmentation.tflite";
static const std::string _LANDSCAPE_TFLITE_FILE_PATH = "mediapipe/modules/selfie_segmentation/selfie_segmentation_landscape.tflite";

namespace mediapipe {
	namespace autoit {
		namespace solutions {
			namespace selfie_segmentation {
				SelfieSegmentation::SelfieSegmentation(BYTE model_selection) {
					download_utils::download_oss_model(model_selection == 0 ? _GENERAL_TFLITE_FILE_PATH : _LANDSCAPE_TFLITE_FILE_PATH);

					__init__(
						_BINARYPB_FILE_PATH,
						noMap(),
						std::shared_ptr<google::protobuf::Message>(),
						{
							{"model_selection", _variant_t(model_selection)}
						},
						{ "segmentation_mask" },
						noTypeMap()
					);
				}

				void SelfieSegmentation::process(const cv::Mat& image, CV_OUT std::map<std::string, _variant_t>& solution_outputs) {
					_variant_t input_data_variant;
					VARIANT* out_val = &input_data_variant;
					autoit_from(::autoit::reference_internal(&image), out_val);
					std::map<std::string, _variant_t> input_dict;
					input_dict["image"] = input_data_variant;

					SolutionBase::process(input_dict, solution_outputs);
				}
			}
		}
	}
}
