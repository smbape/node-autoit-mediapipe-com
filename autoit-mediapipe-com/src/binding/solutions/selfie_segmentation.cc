#include "binding/solutions/selfie_segmentation.h"
#include "binding/solutions/face_detection.h"
#include "binding/solutions/download_utils.h"
#include "Cv_Mat_Object.h"

static const std::string _BINARYPB_FILE_PATH = "mediapipe/modules/selfie_segmentation/selfie_segmentation_cpu.binarypb";
static const std::string _GENERAL_TFLITE_FILE_PATH = "mediapipe/modules/selfie_segmentation/selfie_segmentation.tflite";
static const std::string _LANDSCAPE_TFLITE_FILE_PATH = "mediapipe/modules/selfie_segmentation/selfie_segmentation_landscape.tflite";

namespace mediapipe::autoit::solutions::selfie_segmentation {
	absl::StatusOr<std::shared_ptr<SelfieSegmentation>> SelfieSegmentation::create(uchar model_selection) {
		MP_RETURN_IF_ERROR(download_utils::download_oss_model(model_selection == 0 ? _GENERAL_TFLITE_FILE_PATH : _LANDSCAPE_TFLITE_FILE_PATH));

		return SolutionBase::create(
			_BINARYPB_FILE_PATH,
			noMap(),
			std::shared_ptr<google::protobuf::Message>(),
			{
				{"model_selection", _variant_t(model_selection)}
			},
			{ "segmentation_mask" },
			noTypeMap(),
			noTypeMap(),
			std::nullopt,
			static_cast<SelfieSegmentation*>(nullptr)
		);
	}

	absl::Status SelfieSegmentation::process(const cv::Mat& image, CV_OUT std::map<std::string, _variant_t>& solution_outputs) {
		_variant_t input_data_variant;
		VARIANT* out_val = &input_data_variant;
		autoit_from(::autoit::reference_internal(&image), out_val);
		std::map<std::string, _variant_t> input_dict;
		input_dict["image"] = input_data_variant;

		return SolutionBase::process(input_dict, solution_outputs);
	}
}
