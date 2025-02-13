#include "binding/solutions/hands.h"
#include "binding/solutions/download_utils.h"
#include "Cv_Mat_Object.h"

static const std::string _BINARYPB_FILE_PATH = "mediapipe/modules/hand_landmark/hand_landmark_tracking_cpu.binarypb";

static const std::string _HAND_LANDMARK_LITE_TFLITE_FILE_PATH = "mediapipe/modules/hand_landmark/hand_landmark_lite.tflite";
static const std::string _HAND_LANDMARK_FULL_RANGE_TFLITE_FILE_PATH = "mediapipe/modules/hand_landmark/hand_landmark_full.tflite";

static const std::string _PALM_DETECTION_LITE_TFLITE_FILE_PATH = "mediapipe/modules/palm_detection/palm_detection_lite.tflite";
static const std::string _PALM_DETECTION_FULL_RANGE_TFLITE_FILE_PATH = "mediapipe/modules/palm_detection/palm_detection_full.tflite";

namespace mediapipe::autoit::solutions::hands {
	absl::StatusOr<std::shared_ptr<Hands>> Hands::create(
		bool static_image_mode,
		int max_num_hands,
		uint8_t model_complexity,
		float min_detection_confidence,
		float min_tracking_confidence
	) {
		MP_RETURN_IF_ERROR(download_utils::download_oss_model(
			model_complexity == 0 ? _HAND_LANDMARK_LITE_TFLITE_FILE_PATH : _HAND_LANDMARK_FULL_RANGE_TFLITE_FILE_PATH
		));

		MP_RETURN_IF_ERROR(download_utils::download_oss_model(
			model_complexity == 0 ? _PALM_DETECTION_LITE_TFLITE_FILE_PATH : _PALM_DETECTION_FULL_RANGE_TFLITE_FILE_PATH
		));

		return SolutionBase::create(
			_BINARYPB_FILE_PATH,
			{
				{"palmdetectioncpu__TensorsToDetectionsCalculator.min_score_thresh", _variant_t(min_detection_confidence)},
				{"handlandmarkcpu__ThresholdingCalculator.threshold", _variant_t(min_tracking_confidence)},
			},
			std::shared_ptr<google::protobuf::Message>(),
			{
				{"model_complexity", _variant_t(model_complexity)},
				{"num_hands", _variant_t(max_num_hands)},
				{"use_prev_landmarks", _variant_t(!static_image_mode)},
			},
			{ "multi_hand_landmarks", "multi_hand_world_landmarks", "multi_handedness" },
			noTypeMap(),
			static_cast<Hands*>(nullptr)
		);
	}

	absl::Status Hands::process(const cv::Mat& image, CV_OUT std::map<std::string, _variant_t>& solution_outputs) {
		_variant_t input_data_variant;
		VARIANT* out_val = &input_data_variant;
		autoit_from(::autoit::reference_internal(&image), out_val);
		std::map<std::string, _variant_t> input_dict;
		input_dict["image"] = input_data_variant;

		return SolutionBase::process(input_dict, solution_outputs);
	}
}
