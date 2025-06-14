#include "mediapipe/framework/port/status_macros.h"
#include "binding/solutions/face_detection.h"
#include "binding/solutions/download_utils.h"
#include "Cv_Mat_Object.h"

static const std::string _SHORT_RANGE_GRAPH_FILE_PATH = "mediapipe/modules/face_detection/face_detection_short_range_cpu.binarypb";
static const std::string _FULL_RANGE_GRAPH_FILE_PATH = "mediapipe/modules/face_detection/face_detection_full_range_cpu.binarypb";

static const std::string _SHORT_RANGE_TFLITE_FILE_PATH = "mediapipe/modules/face_detection/face_detection_short_range.tflite";
static const std::string _FULL_RANGE_TFLITE_FILE_PATH = "mediapipe/modules/face_detection/face_detection_full_range_sparse.tflite";

namespace {
	using namespace mediapipe::autoit::solutions::face_detection;
	using namespace mediapipe::autoit::solutions;
}

namespace mediapipe::autoit::solutions::face_detection {
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

	absl::StatusOr<std::shared_ptr<FaceDetection>> FaceDetection::create(
		float min_detection_confidence,
		uchar model_selection
	) {
		MP_RETURN_IF_ERROR(download_utils::download_oss_model(model_selection == 1 ? _FULL_RANGE_TFLITE_FILE_PATH : _SHORT_RANGE_TFLITE_FILE_PATH));
		const auto& model_path = model_selection == 1 ? _FULL_RANGE_GRAPH_FILE_PATH : _SHORT_RANGE_GRAPH_FILE_PATH;

		MP_ASSIGN_OR_RETURN(auto graph_options, SolutionBase::create_graph_options(std::make_shared<FaceDetectionOptions>(), { {"min_score_thresh", _variant_t(model_selection)} }));

		return SolutionBase::create(
			model_path,
			noMap(),
			graph_options,
			noMap(),
			{ "detections" },
			noTypeMap(),
			noTypeMap(),
			std::nullopt,
			static_cast<FaceDetection*>(nullptr)
		);
	}

	absl::Status FaceDetection::process(const cv::Mat& image, CV_OUT std::map<std::string, _variant_t>& solution_outputs) {
		_variant_t input_data_variant;
		VARIANT* out_val = &input_data_variant;
		autoit_from(::autoit::reference_internal(&image), out_val);
		std::map<std::string, _variant_t> input_dict;
		input_dict["image"] = input_data_variant;

		return SolutionBase::process(input_dict, solution_outputs);
	}
}
