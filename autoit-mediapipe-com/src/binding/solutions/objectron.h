#pragma once

#include "mediapipe/framework/formats/landmark.pb.h"
#include "mediapipe/modules/objectron/calculators/annotation_data.pb.h"
#include "binding/util.h"
#include "binding/solution_base.h"
#include "binding/solutions/download_utils.h"
#include <opencv2/core/mat.hpp>

namespace mediapipe::autoit::solutions::objectron {
	using namespace mediapipe::autoit::solution_base;

	/**
	 * The 9 3D box landmarks.
	 */
	enum class BoxLandmark {
		//
		//       3 + + + + + + + + 7
		//       +\                +\          UP
		//       + \               + \
		//       +  \              +  \        |
		//       +   4 + + + + + + + + 8       | y
		//       +   +             +   +       |
		//       +   +             +   +       |
		//       +   +     (0)     +   +       .------- x
		//       +   +             +   +        \
		//       1 + + + + + + + + 5   +         \
		//        \  +              \  +          \ z
		//         \ +               \ +           \
		//          \+                \+
		//           2 + + + + + + + + 6
		CENTER = 0,
		BACK_BOTTOM_LEFT = 1,
		FRONT_BOTTOM_LEFT = 2,
		BACK_TOP_LEFT = 3,
		FRONT_TOP_LEFT = 4,
		BACK_BOTTOM_RIGHT = 5,
		FRONT_BOTTOM_RIGHT = 6,
		BACK_TOP_RIGHT = 7,
		FRONT_TOP_RIGHT = 8,
	};

	static std::vector<std::tuple<BoxLandmark, BoxLandmark>> BOX_CONNECTIONS({
		{BoxLandmark::BACK_BOTTOM_LEFT, BoxLandmark::FRONT_BOTTOM_LEFT},
		{BoxLandmark::BACK_BOTTOM_LEFT, BoxLandmark::BACK_TOP_LEFT},
		{BoxLandmark::BACK_BOTTOM_LEFT, BoxLandmark::BACK_BOTTOM_RIGHT},
		{BoxLandmark::FRONT_BOTTOM_LEFT, BoxLandmark::FRONT_TOP_LEFT},
		{BoxLandmark::FRONT_BOTTOM_LEFT, BoxLandmark::FRONT_BOTTOM_RIGHT},
		{BoxLandmark::BACK_TOP_LEFT, BoxLandmark::FRONT_TOP_LEFT},
		{BoxLandmark::BACK_TOP_LEFT, BoxLandmark::BACK_TOP_RIGHT},
		{BoxLandmark::FRONT_TOP_LEFT, BoxLandmark::FRONT_TOP_RIGHT},
		{BoxLandmark::BACK_BOTTOM_RIGHT, BoxLandmark::FRONT_BOTTOM_RIGHT},
		{BoxLandmark::BACK_BOTTOM_RIGHT, BoxLandmark::BACK_TOP_RIGHT},
		{BoxLandmark::FRONT_BOTTOM_RIGHT, BoxLandmark::FRONT_TOP_RIGHT},
		{BoxLandmark::BACK_TOP_RIGHT, BoxLandmark::FRONT_TOP_RIGHT},
	});

	struct CV_EXPORTS_W_SIMPLE ObjectronModel {
		ObjectronModel() = default;
		virtual ~ObjectronModel() = default;

		ObjectronModel(
			const std::string& model_path,
			const std::string& label_name
		) : model_path(model_path), label_name(label_name) {}

		CV_PROP_RW std::string model_path;
		CV_PROP_RW std::string label_name;
	};

	struct CV_EXPORTS_W_SIMPLE ShoeModel : public ObjectronModel {
		ShoeModel() :
			ObjectronModel(
				"mediapipe/modules/objectron/object_detection_3d_sneakers.tflite",
				"Footwear"
			) {}
	};

	struct CV_EXPORTS_W_SIMPLE ChairModel : public ObjectronModel {
		ChairModel() :
			ObjectronModel(
				"mediapipe/modules/objectron/object_detection_3d_chair.tflite",
				"Chair"
			) {}
	};

	struct CV_EXPORTS_W_SIMPLE CameraModel : public ObjectronModel {
		CameraModel() :
			ObjectronModel(
				"mediapipe/modules/objectron/object_detection_3d_camera.tflite",
				"Camera"
			) {}
	};

	struct CV_EXPORTS_W_SIMPLE CupModel : public ObjectronModel {
		CupModel() :
			ObjectronModel(
				"mediapipe/modules/objectron/object_detection_3d_cup.tflite",
				"Coffee cup, Mug"
			) {}
	};

	[[nodiscard]] absl::StatusOr<ObjectronModel> get_model_by_name(const std::string& name);

	struct CV_EXPORTS_W_SIMPLE ObjectronOutputs {
		CV_PROP_RW NormalizedLandmarkList landmarks_2d;
		CV_PROP_RW LandmarkList landmarks_3d;
		CV_PROP_RW cv::Mat rotation;
		CV_PROP_RW cv::Mat translation;
		CV_PROP_RW cv::Mat scale;
	};

	std::tuple<int, int>& noSize();

	class CV_EXPORTS_W Objectron : public ::mediapipe::autoit::solution_base::SolutionBase {
	public:
		using SolutionBase::SolutionBase;

		CV_WRAP [[nodiscard]] static absl::StatusOr<std::shared_ptr<Objectron>> create(
			bool static_image_mode = false,
			int max_num_objects = 5,
			float min_detection_confidence = 0.5,
			float min_tracking_confidence = 0.99,
			const std::string& model_name = "Shoe",
			const std::tuple<float, float>& focal_length = std::make_tuple<float, float>(1.0, 1.0),
			const std::tuple<float, float>& principal_point = std::make_tuple<float, float>(0.0, 0.0),
			const std::tuple<int, int> image_size = noSize()
		);

		CV_WRAP [[nodiscard]] absl::Status process(const cv::Mat& image, CV_OUT std::map<std::string, _variant_t>& solution_outputs);
	};
}
