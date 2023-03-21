#include "binding/solutions/face_mesh.h"
#include "binding/solutions/download_utils.h"
#include "Cv_Mat_Object.h"

static const std::string _BINARYPB_FILE_PATH = "mediapipe/modules/face_landmark/face_landmark_front_cpu.binarypb";

static const std::string _FACE_LANDMARK_TFLITE_FILE_PATH = "mediapipe/modules/face_landmark/face_landmark.tflite";
static const std::string _FACE_LANDMARK_WITH_ATTENTION_TFLITE_FILE_PATH = "mediapipe/modules/face_landmark/face_landmark_with_attention.tflite";

static const std::string _SHORT_RANGE_TFLITE_FILE_PATH = "mediapipe/modules/face_detection/face_detection_short_range.tflite";
static const std::string _FULL_RANGE_TFLITE_FILE_PATH = "mediapipe/modules/face_detection/face_detection_full_range_sparse.tflite";

namespace mediapipe::autoit::solutions::face_mesh {
	FaceMesh::FaceMesh(
		bool static_image_mode,
		int max_num_faces,
		bool refine_landmarks,
		float min_detection_confidence,
		float min_tracking_confidence
	) {
		download_utils::download_oss_model(refine_landmarks ? _FACE_LANDMARK_WITH_ATTENTION_TFLITE_FILE_PATH : _FACE_LANDMARK_TFLITE_FILE_PATH);
		download_utils::download_oss_model(refine_landmarks ? _FULL_RANGE_TFLITE_FILE_PATH : _SHORT_RANGE_TFLITE_FILE_PATH);

		__init__(
			_BINARYPB_FILE_PATH,
			{
				{"facedetectionshortrangecpu__facedetectionshortrange__facedetection__TensorsToDetectionsCalculator.min_score_thresh", _variant_t(min_detection_confidence)},
				{"facelandmarkcpu__ThresholdingCalculator.threshold", _variant_t(min_tracking_confidence)},
			},
			std::shared_ptr<google::protobuf::Message>(),
			{
				{"num_faces", _variant_t(max_num_faces)},
				{"with_attention", _variant_t(refine_landmarks)},
				{"use_prev_landmarks", _variant_t(!static_image_mode)},
			},
			{ "multi_face_landmarks" },
			noTypeMap()
			);
	}

	void FaceMesh::process(const cv::Mat& image, CV_OUT std::map<std::string, _variant_t>& solution_outputs) {
		_variant_t input_data_variant;
		VARIANT* out_val = &input_data_variant;
		autoit_from(::autoit::reference_internal(&image), out_val);
		std::map<std::string, _variant_t> input_dict;
		input_dict["image"] = input_data_variant;

		SolutionBase::process(input_dict, solution_outputs);
	}
}
