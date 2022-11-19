#include <opencv2/imgproc.hpp>
#include "binding/solutions/objectron.h"
#include "Cv_Mat_Object.h"
#include "Mediapipe_FrameAnnotation_Object.h"
#include "VectorOfObjectron_ObjectronOutputs_Object.h"

static const std::string _BINARYPB_FILE_PATH = "mediapipe/modules/objectron/objectron_cpu.binarypb";

template<typename _Tp>
cv::Mat repeated_to_mat(::google::protobuf::RepeatedField<_Tp> repeated) {
	const auto& rows = 1;
	auto cols = repeated.size();
	const auto& channels = 1;

	cv::Mat matrix(rows, cols, CV_MAKETYPE(
		cv::DataType<_Tp>::depth,
		channels
	));

	int idx = 0;
	for (const auto& value : repeated) {
		matrix.at<_Tp>(idx++) = value;
	}

	return matrix;
}

namespace mediapipe {
	namespace autoit {
		namespace solutions {
			namespace objectron {
				static std::map<std::string, ObjectronModel> _MODEL_DICT = {
					{"Shoe", ShoeModel()},
					{"Chair", ChairModel()},
					{"Cup", CupModel()},
					{"Camera", CameraModel()},
				};

				static void _download_oss_objectron_models(const std::string& objectron_model) {
					download_utils::download_oss_model(
						"mediapipe/modules/objectron/object_detection_ssd_mobilenetv2_oidv4_fp16.tflite"
					);
					download_utils::download_oss_model(objectron_model);
				}

				static std::tuple<int, int> _noSize = {0, 0};
				std::tuple<int, int>& noSize() {
					return _noSize;
				}

				ObjectronModel get_model_by_name(const std::string& name) {
					AUTOIT_ASSERT_THROW(_MODEL_DICT.count(name), name << " is not a valid model name for Objectron.");
					_download_oss_objectron_models(_MODEL_DICT[name].model_path);
					return _MODEL_DICT[name];
				}


				Objectron::Objectron(
					bool static_image_mode,
					int max_num_objects,
					float min_detection_confidence,
					float min_tracking_confidence,
					const std::string& model_name,
					const std::tuple<float, float>& focal_length,
					const std::tuple<float, float>& principal_point,
					const std::tuple<int, int> image_size
				) {
					// Get Camera parameters.
					auto [fx, fy] = focal_length;
					auto [px, py] = principal_point;
					auto [width, height] = image_size;

					if (width != 0 && height != 0) {
						auto half_width = width / 2.0;
						auto half_height = height / 2.0;
						fx = fx / half_width;
						fy = fy / half_height;
						px = -(px - half_width) / half_width;
						py = -(py - half_height) / half_height;
					}

					// Create and init model.
					auto model = get_model_by_name(model_name);

					__init__(
						_BINARYPB_FILE_PATH,
						{
							{"objectdetectionoidv4subgraph"
								"__TensorsToDetectionsCalculator.min_score_thresh",
								_variant_t(min_detection_confidence)},
							{"boxlandmarksubgraph__ThresholdingCalculator"
								".threshold",
								_variant_t(min_tracking_confidence)},
							{"Lift2DFrameAnnotationTo3DCalculator"
								".normalized_focal_x", _variant_t(fx)},
							{"Lift2DFrameAnnotationTo3DCalculator"
								".normalized_focal_y", _variant_t(fy)},
							{"Lift2DFrameAnnotationTo3DCalculator"
								".normalized_principal_point_x", _variant_t(px)},
							{"Lift2DFrameAnnotationTo3DCalculator"
								".normalized_principal_point_y", _variant_t(py)},
						},
						std::shared_ptr<google::protobuf::Message>(),
						{
							{"box_landmark_model_path", to_variant_t(model.model_path)},
							{"allowed_labels", to_variant_t(model.label_name)},
							{"max_num_objects", _variant_t(max_num_objects)},
							{"use_prev_landmarks", _variant_t(!static_image_mode)},
						},
						{ "detected_objects" }
					);
				}

				static _variant_t _convert_format(_variant_t inputs_variant) {
					FrameAnnotation inputs = ::autoit::cast<FrameAnnotation>(&inputs_variant);

					std::vector<ObjectronOutputs> new_outputs;
					new_outputs.reserve(inputs.annotations_size());

					for (const auto& annotation : inputs.annotations()) {
						// Get 3d object pose.
						auto rotation = repeated_to_mat(annotation.rotation()).reshape(1, 3);
						auto translation = repeated_to_mat(annotation.translation());
						auto scale = repeated_to_mat(annotation.scale());

						// Get 2d/3d landmarks.
						NormalizedLandmarkList landmarks_2d;
						LandmarkList landmarks_3d;
						for (const auto& keypoint : annotation.keypoints()) {
							const auto& point_2d = keypoint.point_2d();
							auto* landmarks_2d_added = landmarks_2d.add_landmark();
							landmarks_2d_added->set_x(point_2d.x());
							landmarks_2d_added->set_y(point_2d.y());

							const auto& point_3d = keypoint.point_3d();
							auto* landmarks_3d_added = landmarks_3d.add_landmark();
							landmarks_3d_added->set_x(point_3d.x());
							landmarks_3d_added->set_y(point_3d.y());
							landmarks_3d_added->set_z(point_3d.z());
						}

						// Add to objectron outputs.
						new_outputs.push_back({
							landmarks_2d,
							landmarks_3d,
							rotation,
							translation,
							scale
							});
					}

					return to_variant_t(new_outputs);
				}

				static _variant_t None = default_variant();

				void Objectron::process(const cv::Mat& image, CV_OUT std::map<std::string, _variant_t>& solution_outputs) {
					_variant_t input_data_variant;
					VARIANT* out_val = &input_data_variant;
					autoit_from(::autoit::reference_internal(&image), out_val);
					std::map<std::string, _variant_t> input_dict;
					input_dict["image"] = input_data_variant;

					SolutionBase::process(input_dict, solution_outputs);

					if (
						solution_outputs.count("detected_objects")
						&& !PARAMETER_MISSING(&solution_outputs["detected_objects"])
						) {
						solution_outputs["detected_objects"] = _convert_format(solution_outputs["detected_objects"]);
					}
					else {
						solution_outputs["detected_objects"] = None;
					}
				}
			}
		}
	}
}
