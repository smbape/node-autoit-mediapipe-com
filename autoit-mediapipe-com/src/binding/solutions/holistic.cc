#include "binding/message.h"
#include "binding/solutions/holistic.h"
#include "binding/solutions/download_utils.h"
#include "Cv_Mat_Object.h"

static const std::string _BINARYPB_FILE_PATH = "mediapipe/modules/holistic_landmark/holistic_landmark_cpu.binarypb";

static const std::string _HOLISTIC_LANDMARK_HAND_RECROP_TFLITE_FILE_PATH = "mediapipe/modules/holistic_landmark/hand_recrop.tflite";

static const std::string _FACE_LANDMARK_TFLITE_FILE_PATH = "mediapipe/modules/face_landmark/face_landmark.tflite";
static const std::string _FACE_LANDMARK_WITH_ATTENTION_TFLITE_FILE_PATH = "mediapipe/modules/face_landmark/face_landmark_with_attention.tflite";

static const std::string _SHORT_RANGE_TFLITE_FILE_PATH = "mediapipe/modules/face_detection/face_detection_short_range.tflite";
static const std::string _FULL_RANGE_TFLITE_FILE_PATH = "mediapipe/modules/face_detection/face_detection_full_range_sparse.tflite";

static const std::string _HAND_LANDMARK_LITE_TFLITE_FILE_PATH = "mediapipe/modules/hand_landmark/hand_landmark_lite.tflite";
static const std::string _HAND_LANDMARK_FULL_RANGE_TFLITE_FILE_PATH = "mediapipe/modules/hand_landmark/hand_landmark_full.tflite";

static const std::string _POSE_LANDMARK_LITE_TFLITE_FILE_PATH = "mediapipe/modules/pose_landmark/pose_landmark_lite.tflite";
static const std::string _POSE_LANDMARK_FULL_RANGE_TFLITE_FILE_PATH = "mediapipe/modules/pose_landmark/pose_landmark_full.tflite";
static const std::string _POSE_LANDMARK_HEAVY_RANGE_TFLITE_FILE_PATH = "mediapipe/modules/pose_landmark/pose_landmark_heavy.tflite";

static const std::string _POSE_DETECTION_TFLITE_FILE_PATH = "mediapipe/modules/pose_detection/pose_detection.tflite";

namespace mediapipe::autoit::solutions::holistic {
	using namespace google::protobuf::autoit::cmessage;

	Holistic::Holistic(
		bool static_image_mode,
		BYTE model_complexity,
		bool smooth_landmarks,
		bool enable_segmentation,
		bool smooth_segmentation,
		bool refine_face_landmarks,
		float min_detection_confidence,
		float min_tracking_confidence
	) {
		download_utils::download_oss_model(refine_face_landmarks ? _FACE_LANDMARK_WITH_ATTENTION_TFLITE_FILE_PATH : _FACE_LANDMARK_TFLITE_FILE_PATH);
		download_utils::download_oss_model(refine_face_landmarks ? _FULL_RANGE_TFLITE_FILE_PATH : _SHORT_RANGE_TFLITE_FILE_PATH);

		download_utils::download_oss_model(
			model_complexity == 0 ? _HAND_LANDMARK_LITE_TFLITE_FILE_PATH : _HAND_LANDMARK_FULL_RANGE_TFLITE_FILE_PATH
		);

		download_utils::download_oss_model(_POSE_DETECTION_TFLITE_FILE_PATH);
		download_utils::download_oss_model(
			model_complexity == 1 ? _POSE_LANDMARK_FULL_RANGE_TFLITE_FILE_PATH :
			model_complexity == 2 ? _POSE_LANDMARK_HEAVY_RANGE_TFLITE_FILE_PATH :
			_POSE_LANDMARK_LITE_TFLITE_FILE_PATH
		);

		download_utils::download_oss_model(_HOLISTIC_LANDMARK_HAND_RECROP_TFLITE_FILE_PATH);

		__init__(
			_BINARYPB_FILE_PATH,
			{
				{"poselandmarkcpu__posedetectioncpu__TensorsToDetectionsCalculator.min_score_thresh", _variant_t(min_detection_confidence)},
				{"poselandmarkcpu__poselandmarkbyroicpu__tensorstoposelandmarksandsegmentation__ThresholdingCalculator.threshold", _variant_t(min_tracking_confidence)},
			},
			std::shared_ptr<google::protobuf::Message>(),
			{
				{"model_complexity", _variant_t(model_complexity)},
				{"smooth_landmarks", _variant_t(smooth_landmarks && !static_image_mode)},
				{"enable_segmentation", _variant_t(enable_segmentation)},
				{"smooth_segmentation", _variant_t(smooth_segmentation && !static_image_mode)},
				{"refine_face_landmarks", _variant_t(refine_face_landmarks)},
				{"use_prev_landmarks", _variant_t(!static_image_mode)},
			},
			{
				"pose_landmarks", "pose_world_landmarks", "left_hand_landmarks",
				"right_hand_landmarks", "face_landmarks", "segmentation_mask"
			},
			noTypeMap()
		);
	}

	void Holistic::process(const cv::Mat& image, CV_OUT std::map<std::string, _variant_t>& solution_outputs) {
		_variant_t input_data_variant;
		VARIANT* out_val = &input_data_variant;
		autoit_from(::autoit::reference_internal(&image), out_val);
		std::map<std::string, _variant_t> input_dict;
		input_dict["image"] = input_data_variant;

		SolutionBase::process(input_dict, solution_outputs);

		if (
			solution_outputs.count("pose_landmarks")
			&& !PARAMETER_MISSING(&solution_outputs["pose_landmarks"])
		) {
			NormalizedLandmarkList pose_landmarks = ::autoit::cast<NormalizedLandmarkList>(&solution_outputs["pose_landmarks"]);
			for (auto& landmark : *pose_landmarks.mutable_landmark()) {
				ClearField(landmark, "presence");
			}
		}

		if (
			solution_outputs.count("pose_world_landmarks")
			&& !PARAMETER_MISSING(&solution_outputs["pose_world_landmarks"])
		) {
			LandmarkList pose_world_landmarks = ::autoit::cast<LandmarkList>(&solution_outputs["pose_world_landmarks"]);
			for (auto& landmark : *pose_world_landmarks.mutable_landmark()) {
				ClearField(landmark, "presence");
			}
		}
	}
}
