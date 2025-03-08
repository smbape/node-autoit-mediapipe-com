#include "binding/message.h"
#include "binding/solutions/download_utils.h"
#include "binding/solutions/pose.h"
#include "Cv_Mat_Object.h"

static const std::string _BINARYPB_FILE_PATH = "mediapipe/modules/pose_landmark/pose_landmark_cpu.binarypb";

static const std::string _POSE_LANDMARK_LITE_TFLITE_FILE_PATH = "mediapipe/modules/pose_landmark/pose_landmark_lite.tflite";
static const std::string _POSE_LANDMARK_FULL_RANGE_TFLITE_FILE_PATH = "mediapipe/modules/pose_landmark/pose_landmark_full.tflite";
static const std::string _POSE_LANDMARK_HEAVY_RANGE_TFLITE_FILE_PATH = "mediapipe/modules/pose_landmark/pose_landmark_heavy.tflite";

static const std::string _POSE_DETECTION_TFLITE_FILE_PATH = "mediapipe/modules/pose_detection/pose_detection.tflite";

namespace mediapipe::autoit::solutions::pose {
	using namespace google::protobuf::autoit::cmessage;

	absl::StatusOr<std::shared_ptr<Pose>> Pose::create(
		bool static_image_mode,
		uint8_t model_complexity,
		bool smooth_landmarks,
		bool enable_segmentation,
		bool smooth_segmentation,
		float min_detection_confidence,
		float min_tracking_confidence
	) {
		MP_RETURN_IF_ERROR(download_utils::download_oss_model(_POSE_DETECTION_TFLITE_FILE_PATH));
		MP_RETURN_IF_ERROR(download_utils::download_oss_model(
			model_complexity == 1 ? _POSE_LANDMARK_FULL_RANGE_TFLITE_FILE_PATH :
			model_complexity == 2 ? _POSE_LANDMARK_HEAVY_RANGE_TFLITE_FILE_PATH :
			_POSE_LANDMARK_LITE_TFLITE_FILE_PATH
		));

		return SolutionBase::create(
			_BINARYPB_FILE_PATH,
			{
				{"posedetectioncpu__TensorsToDetectionsCalculator.min_score_thresh", _variant_t(min_detection_confidence)},
				{"poselandmarkbyroicpu__tensorstoposelandmarksandsegmentation__ThresholdingCalculator.threshold", _variant_t(min_tracking_confidence)},
			},
			std::shared_ptr<google::protobuf::Message>(),
			{
				{"model_complexity", _variant_t(model_complexity)},
				{"smooth_landmarks", _variant_t(smooth_landmarks && !static_image_mode)},
				{"enable_segmentation", _variant_t(enable_segmentation)},
				{"smooth_segmentation", _variant_t(smooth_segmentation && !static_image_mode)},
				{"use_prev_landmarks", _variant_t(!static_image_mode)},
			},
			{ "pose_landmarks", "pose_world_landmarks", "segmentation_mask" },
			noTypeMap(),
			static_cast<Pose*>(nullptr)
		);
	}

	absl::Status Pose::process(const cv::Mat& image, CV_OUT std::map<std::string, _variant_t>& solution_outputs) {
		_variant_t input_data_variant;
		VARIANT* out_val = &input_data_variant;
		autoit_from(::autoit::reference_internal(&image), out_val);
		std::map<std::string, _variant_t> input_dict;
		input_dict["image"] = input_data_variant;

		MP_RETURN_IF_ERROR(SolutionBase::process(input_dict, solution_outputs));

		if (
			solution_outputs.count("pose_landmarks")
			&& !PARAMETER_MISSING(&solution_outputs["pose_landmarks"])
		) {
			NormalizedLandmarkList pose_landmarks = ::autoit::cast<NormalizedLandmarkList>(&solution_outputs["pose_landmarks"]);
			for (auto& landmark : *pose_landmarks.mutable_landmark()) {
				MP_RETURN_IF_ERROR(ClearField(landmark, "presence"));
			}
		}

		if (
			solution_outputs.count("pose_world_landmarks")
			&& !PARAMETER_MISSING(&solution_outputs["pose_world_landmarks"])
		) {
			LandmarkList pose_world_landmarks = ::autoit::cast<LandmarkList>(&solution_outputs["pose_world_landmarks"]);
			for (auto& landmark : *pose_world_landmarks.mutable_landmark()) {
				MP_RETURN_IF_ERROR(ClearField(landmark, "presence"));
			}
		}

		return absl::OkStatus();
	}
}
