#pragma once

#include "mediapipe/framework/formats/classification.pb.h"
#include "mediapipe/framework/formats/landmark.pb.h"
#include "mediapipe/framework/formats/matrix_data.pb.h"
#include "mediapipe/tasks/cc/vision/face_landmarker/proto/face_landmarker_graph_options.pb.h"
#include "binding/tasks/components/containers/category.h"
#include "binding/tasks/components/containers/landmark.h"
#include "binding/tasks/core/base_options.h"
#include "binding/tasks/core/task_info.h"
#include "binding/tasks/vision/core/base_vision_task_api.h"
#include "binding/tasks/vision/core/image_processing_options.h"
#include "binding/tasks/vision/core/vision_task_running_mode.h"
#include <functional>

namespace mediapipe::tasks::autoit::vision::face_landmarker {
	using namespace mediapipe::tasks::autoit::components::containers;
	using namespace mediapipe::tasks::autoit::components::processors;

	enum class Blendshapes {
		// The 52 blendshape coefficients.
		NEUTRAL = 0,
		BROW_DOWN_LEFT = 1,
		BROW_DOWN_RIGHT = 2,
		BROW_INNER_UP = 3,
		BROW_OUTER_UP_LEFT = 4,
		BROW_OUTER_UP_RIGHT = 5,
		CHEEK_PUFF = 6,
		CHEEK_SQUINT_LEFT = 7,
		CHEEK_SQUINT_RIGHT = 8,
		EYE_BLINK_LEFT = 9,
		EYE_BLINK_RIGHT = 10,
		EYE_LOOK_DOWN_LEFT = 11,
		EYE_LOOK_DOWN_RIGHT = 12,
		EYE_LOOK_IN_LEFT = 13,
		EYE_LOOK_IN_RIGHT = 14,
		EYE_LOOK_OUT_LEFT = 15,
		EYE_LOOK_OUT_RIGHT = 16,
		EYE_LOOK_UP_LEFT = 17,
		EYE_LOOK_UP_RIGHT = 18,
		EYE_SQUINT_LEFT = 19,
		EYE_SQUINT_RIGHT = 20,
		EYE_WIDE_LEFT = 21,
		EYE_WIDE_RIGHT = 22,
		JAW_FORWARD = 23,
		JAW_LEFT = 24,
		JAW_OPEN = 25,
		JAW_RIGHT = 26,
		MOUTH_CLOSE = 27,
		MOUTH_DIMPLE_LEFT = 28,
		MOUTH_DIMPLE_RIGHT = 29,
		MOUTH_FROWN_LEFT = 30,
		MOUTH_FROWN_RIGHT = 31,
		MOUTH_FUNNEL = 32,
		MOUTH_LEFT = 33,
		MOUTH_LOWER_DOWN_LEFT = 34,
		MOUTH_LOWER_DOWN_RIGHT = 35,
		MOUTH_PRESS_LEFT = 36,
		MOUTH_PRESS_RIGHT = 37,
		MOUTH_PUCKER = 38,
		MOUTH_RIGHT = 39,
		MOUTH_ROLL_LOWER = 40,
		MOUTH_ROLL_UPPER = 41,
		MOUTH_SHRUG_LOWER = 42,
		MOUTH_SHRUG_UPPER = 43,
		MOUTH_SMILE_LEFT = 44,
		MOUTH_SMILE_RIGHT = 45,
		MOUTH_STRETCH_LEFT = 46,
		MOUTH_STRETCH_RIGHT = 47,
		MOUTH_UPPER_UP_LEFT = 48,
		MOUTH_UPPER_UP_RIGHT = 49,
		NOSE_SNEER_LEFT = 50,
		NOSE_SNEER_RIGHT = 51,
	};

	struct CV_EXPORTS_W_SIMPLE FaceLandmarksConnections {
		struct CV_EXPORTS_W_SIMPLE Connection {
			CV_WRAP Connection(const Connection& other) = default;
			Connection& operator=(const Connection& other) = default;

			CV_WRAP Connection(int start = 0, int end = 0) : start(start), end(end) {}

			CV_PROP_RW int start;
			CV_PROP_RW int end;
		};

		CV_PROP static const std::vector<Connection> FACE_LANDMARKS_LIPS;
		CV_PROP static const std::vector<Connection> FACE_LANDMARKS_LEFT_EYE;
		CV_PROP static const std::vector<Connection> FACE_LANDMARKS_LEFT_EYEBROW;
		CV_PROP static const std::vector<Connection> FACE_LANDMARKS_LEFT_IRIS;
		CV_PROP static const std::vector<Connection> FACE_LANDMARKS_RIGHT_EYE;
		CV_PROP static const std::vector<Connection> FACE_LANDMARKS_RIGHT_EYEBROW;
		CV_PROP static const std::vector<Connection> FACE_LANDMARKS_RIGHT_IRIS;
		CV_PROP static const std::vector<Connection> FACE_LANDMARKS_FACE_OVAL;
		CV_PROP static const std::vector<Connection> FACE_LANDMARKS_CONTOURS;
		CV_PROP static const std::vector<Connection> FACE_LANDMARKS_TESSELATION;
	};

	struct CV_EXPORTS_W_SIMPLE FaceLandmarkerResult {
		CV_WRAP FaceLandmarkerResult(const FaceLandmarkerResult& other) = default;
		FaceLandmarkerResult& operator=(const FaceLandmarkerResult& other) = default;

		CV_WRAP FaceLandmarkerResult(
			std::vector<std::vector<std::shared_ptr<landmark::NormalizedLandmark>>> face_landmarks = std::vector<std::vector<std::shared_ptr<landmark::NormalizedLandmark>>>(),
			std::vector<std::vector<std::shared_ptr<category::Category>>> face_blendshapes = std::vector<std::vector<std::shared_ptr<category::Category>>>(),
			std::vector<cv::Mat> facial_transformation_matrixes = std::vector<cv::Mat>()
		) :
			face_landmarks(face_landmarks),
			face_blendshapes(face_blendshapes),
			facial_transformation_matrixes(facial_transformation_matrixes)
		{}

		CV_PROP_RW std::vector<std::vector<std::shared_ptr<landmark::NormalizedLandmark>>> face_landmarks;
		CV_PROP_RW std::vector<std::vector<std::shared_ptr<category::Category>>> face_blendshapes;
		CV_PROP_RW std::vector<cv::Mat> facial_transformation_matrixes;
	};

	using FaceLandmarkerResultRawCallback = void(*)(const FaceLandmarkerResult&, const Image&, int64_t);
	using FaceLandmarkerResultCallback = std::function<void(const FaceLandmarkerResult&, const Image&, int64_t)>;

	struct CV_EXPORTS_W_SIMPLE FaceLandmarkerOptions {
		CV_WRAP FaceLandmarkerOptions(const FaceLandmarkerOptions& other) = default;
		FaceLandmarkerOptions& operator=(const FaceLandmarkerOptions& other) = default;

		CV_WRAP FaceLandmarkerOptions(
			std::shared_ptr<autoit::core::base_options::BaseOptions> base_options = std::shared_ptr<autoit::core::base_options::BaseOptions>(),
			core::vision_task_running_mode::VisionTaskRunningMode running_mode = tasks::autoit::vision::core::vision_task_running_mode::VisionTaskRunningMode::IMAGE,
			int num_faces = 1,
			float min_face_detection_confidence = 0.5f,
			float min_face_presence_confidence = 0.5f,
			float min_tracking_confidence = 0.5f,
			bool output_face_blendshapes = false,
			bool output_facial_transformation_matrixes = false,
			FaceLandmarkerResultCallback result_callback = nullptr
		) :
			base_options(base_options),
			running_mode(running_mode),
			num_faces(num_faces),
			min_face_detection_confidence(min_face_detection_confidence),
			min_face_presence_confidence(min_face_presence_confidence),
			min_tracking_confidence(min_tracking_confidence),
			output_face_blendshapes(output_face_blendshapes),
			output_facial_transformation_matrixes(output_facial_transformation_matrixes),
			result_callback(result_callback)
		{}

		CV_WRAP std::shared_ptr<mediapipe::tasks::vision::face_landmarker::proto::FaceLandmarkerGraphOptions> to_pb2();

		CV_PROP_RW std::shared_ptr<autoit::core::base_options::BaseOptions> base_options;
		CV_PROP_RW core::vision_task_running_mode::VisionTaskRunningMode running_mode;
		CV_PROP_RW int num_faces;
		CV_PROP_RW float min_face_detection_confidence;
		CV_PROP_RW float min_face_presence_confidence;
		CV_PROP_RW float min_tracking_confidence;
		CV_PROP_RW bool output_face_blendshapes;
		CV_PROP_RW bool output_facial_transformation_matrixes;
		CV_PROP_W  FaceLandmarkerResultCallback result_callback;
	};

	class CV_EXPORTS_W FaceLandmarker : public ::mediapipe::tasks::autoit::vision::core::base_vision_task_api::BaseVisionTaskApi {
	public:
		using core::base_vision_task_api::BaseVisionTaskApi::BaseVisionTaskApi;

		CV_WRAP static std::shared_ptr<FaceLandmarker> create_from_model_path(const std::string& model_path);
		CV_WRAP static std::shared_ptr<FaceLandmarker> create_from_options(std::shared_ptr<FaceLandmarkerOptions> options);
		CV_WRAP std::shared_ptr<FaceLandmarkerResult> detect(
			const Image& image,
			std::shared_ptr<core::image_processing_options::ImageProcessingOptions> image_processing_option
			= std::shared_ptr<core::image_processing_options::ImageProcessingOptions>()
		);
		CV_WRAP std::shared_ptr<FaceLandmarkerResult> detect_for_video(
			const Image& image,
			int64_t timestamp_ms,
			std::shared_ptr<core::image_processing_options::ImageProcessingOptions> image_processing_options
			= std::shared_ptr<core::image_processing_options::ImageProcessingOptions>()
		);
		CV_WRAP void detect_async(
			const Image& image,
			int64_t timestamp_ms,
			std::shared_ptr<core::image_processing_options::ImageProcessingOptions> image_processing_options
			= std::shared_ptr<core::image_processing_options::ImageProcessingOptions>()
		);
	};
}

PTR_BRIDGE_DECL(mediapipe::tasks::autoit::vision::face_landmarker::FaceLandmarkerResultRawCallback);
extern const HRESULT autoit_to(VARIANT const* const& in_val, mediapipe::tasks::autoit::vision::face_landmarker::FaceLandmarkerResultCallback& out_val);
