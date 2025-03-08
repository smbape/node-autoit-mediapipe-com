#include <math.h>
#include <opencv2/imgproc.hpp>

#include "mediapipe/framework/port/status_macros.h"
#include "binding/solutions/drawing_utils.h"
#include "binding/message.h"

using namespace google::protobuf::autoit::cmessage;

static const float _PRESENCE_THRESHOLD = 0.5f;
static const float _VISIBILITY_THRESHOLD = 0.5f;

namespace {
	using namespace mediapipe::autoit::solutions::drawing_utils;
	using namespace mediapipe::autoit::solutions;
	using namespace mediapipe::autoit;
	using namespace mediapipe;

	/**
	 * Usable AlmostEqual function
	 * @param  A       [description]
	 * @param  B       [description]
	 * @param  maxUlps [description]
	 * @see https://stackoverflow.com/a/17467
	 * @return         [description]
	 */
	inline bool AlmostEqual2sComplement(float A, float B, int maxUlps = 4)
	{
		// Make sure maxUlps is non-negative and small enough that the    
		// default NAN won't compare as equal to anything.    
		assert(maxUlps > 0 && maxUlps < 4 * 1024 * 1024);
		int aInt = *(int*)&A;
		// Make aInt lexicographically ordered as a twos-complement int    
		if (aInt < 0)
			aInt = 0x80000000 - aInt;
		// Make bInt lexicographically ordered as a twos-complement int    
		int bInt = *(int*)&B;
		if (bInt < 0)
			bInt = 0x80000000 - bInt;
		int intDiff = abs(aInt - bInt);
		if (intDiff <= maxUlps)
			return true;
		return false;
	}

	inline bool is_valid_normalized_value(float value) {
		return (value > 0 || AlmostEqual2sComplement(0, value)) &&
			(value < 1 || AlmostEqual2sComplement(1, value));
	}

	inline std::shared_ptr<cv::Point> _normalized_to_pixel_coordinates(
		float normalized_x,
		float normalized_y,
		int image_width,
		int image_height
	) {
		if (!is_valid_normalized_value(normalized_x) || !is_valid_normalized_value(normalized_y)) {
			return std::shared_ptr<cv::Point>();
		}

		int x_px = std::min(static_cast<int>(std::floor(normalized_x * image_width)), image_width - 1);
		int y_px = std::min(static_cast<int>(std::floor(normalized_y * image_height)), image_height - 1);

		return std::make_shared<cv::Point>(x_px, y_px);
	}

	inline cv::Scalar color_to_scalar(std::tuple<int, int, int> color) {
		const auto& [b, g, r] = color;
		return cv::Scalar(b, g, r);
	}

	template<typename _Tp>
	struct OptionalDrawingSpec;

	template<>
	struct OptionalDrawingSpec<DrawingSpec> {
		inline static const bool has(
			const DrawingSpec& connection_drawing_spec,
			const std::tuple<int, int> connection
		) {
			return true;
		}

		inline static const DrawingSpec& get(
			const DrawingSpec& connection_drawing_spec,
			const std::tuple<int, int> connection
		) {
			return connection_drawing_spec;
		}
	};

	template<>
	struct OptionalDrawingSpec<std::shared_ptr<DrawingSpec>> {
		inline static const bool empty(
			const std::shared_ptr<DrawingSpec>& landmark_drawing_spec
		) {
			return !landmark_drawing_spec.get();
		}

		inline static const bool has(
			const std::shared_ptr<DrawingSpec>& landmark_drawing_spec,
			int idx
		) {
			return landmark_drawing_spec.get();
		}

		inline static const DrawingSpec& get(
			const std::shared_ptr<DrawingSpec>& landmark_drawing_spec,
			int idx
		) {
			return *landmark_drawing_spec.get();
		}
	};

	template<>
	struct OptionalDrawingSpec<std::map<int, std::map<int, DrawingSpec>>> {
		inline static const bool has(
			const std::map<int, std::map<int, DrawingSpec>>& connection_drawing_spec,
			const std::tuple<int, int> connection
		) {
			if (!connection_drawing_spec.count(std::get<0>(connection))) {
				return false;
			}
			return connection_drawing_spec.at(std::get<0>(connection)).count(std::get<1>(connection));
		}

		inline static const DrawingSpec& get(
			const std::map<int, std::map<int, DrawingSpec>>& connection_drawing_spec,
			const std::tuple<int, int> connection
		) {
			return connection_drawing_spec.at(std::get<0>(connection)).at(std::get<1>(connection));
		}
	};

	template<>
	struct OptionalDrawingSpec<std::map<int, DrawingSpec>> {
		inline static const bool empty(
			const std::map<int, DrawingSpec>& landmark_drawing_spec
		) {
			return landmark_drawing_spec.empty();
		}

		inline static const bool has(
			const std::map<int, DrawingSpec>& landmark_drawing_spec,
			int idx
		) {
			return landmark_drawing_spec.count(idx);
		}

		inline static const DrawingSpec& get(
			const std::map<int, DrawingSpec>& landmark_drawing_spec,
			int idx
		) {
			return landmark_drawing_spec.at(idx);
		}
	};

	template<typename _LandmarkType, typename _ConnectionType>
	[[nodiscard]] absl::Status _draw_landmarks(
		cv::Mat& image,
		const NormalizedLandmarkList& landmark_list,
		const std::vector<std::tuple<int, int>>& connections,
		const _LandmarkType& landmark_drawing_spec,
		const _ConnectionType& connection_drawing_spec,
		const bool is_drawing_landmarks
	) {
		auto image_rows = image.rows;
		auto image_cols = image.cols;
		std::map<int, cv::Point> idx_to_coordinates;

		int idx = -1;
		for (const auto& landmark : landmark_list.landmark()) {
			idx++;
			MP_ASSIGN_OR_RETURN(auto landmark_has_visibility, HasField(landmark, "visibility"));
			MP_ASSIGN_OR_RETURN(auto landmark_has_presence, HasField(landmark, "presence"));

			if (
				(landmark_has_visibility && landmark.visibility() < _VISIBILITY_THRESHOLD)
				|| (landmark_has_presence && landmark.presence() < _PRESENCE_THRESHOLD)
				) {
				continue;
			}

			auto landmark_px = _normalized_to_pixel_coordinates(landmark.x(), landmark.y(), image_cols, image_rows);
			if (landmark_px) {
				idx_to_coordinates.insert_or_assign(idx, *landmark_px);
			}
		}

		if (!connections.empty()) {
			auto num_landmarks = landmark_list.landmark_size();

			// Draws the connections if the start and end landmarks are both visible.
			for (const auto& connection : connections) {
				auto start_idx = std::get<0>(connection);
				auto end_idx = std::get<1>(connection);
				MP_ASSERT_RETURN_IF_ERROR(0 <= start_idx < num_landmarks && 0 <= end_idx < num_landmarks,
					"Landmark index is out of range. Invalid connection "
					"from landmark " << start_idx << " to landmark " << end_idx << ".");

				if (
					idx_to_coordinates.count(start_idx)
					&& idx_to_coordinates.count(end_idx)
					&& OptionalDrawingSpec<_ConnectionType>::has(connection_drawing_spec, connection)
					) {
					auto drawing_spec = OptionalDrawingSpec<_ConnectionType>::get(connection_drawing_spec, connection);

					cv::line(
						image,
						idx_to_coordinates.at(start_idx),
						idx_to_coordinates.at(end_idx),
						color_to_scalar(drawing_spec.color),
						drawing_spec.thickness
					);
				}
			}
		}

		if (!is_drawing_landmarks || OptionalDrawingSpec<_LandmarkType>::empty(landmark_drawing_spec)) {
			return absl::OkStatus();
		}

		// Draws landmark points after finishing the connection lines, which is
		// aesthetically better.
		for (const auto& [idx, landmark_px] : idx_to_coordinates) {
			if (!OptionalDrawingSpec<_LandmarkType>::has(landmark_drawing_spec, idx)) {
				continue;
			}

			auto drawing_spec = OptionalDrawingSpec<_LandmarkType>::get(landmark_drawing_spec, idx);

			//  White circle border
			auto circle_border_radius = std::max(
				drawing_spec.circle_radius + 1,
				static_cast<int>(drawing_spec.circle_radius * 1.2)
			);

			cv::circle(image, landmark_px, circle_border_radius, color_to_scalar(WHITE_COLOR),
				drawing_spec.thickness);

			//  Fill color into the circle
			cv::circle(image, landmark_px, drawing_spec.circle_radius,
				color_to_scalar(drawing_spec.color), drawing_spec.thickness);
		}

		return absl::OkStatus();
	}
}

namespace mediapipe::autoit::solutions::drawing_utils {
	absl::Status draw_detection(
		cv::Mat& image,
		const Detection& detection,
		const DrawingSpec& keypoint_drawing_spec,
		const DrawingSpec& bbox_drawing_spec
	) {
		if (!detection.has_location_data()) {
			return absl::OkStatus();
		}

		const auto& location = detection.location_data();
		MP_ASSERT_RETURN_IF_ERROR(location.format() == LocationData::RELATIVE_BOUNDING_BOX,
			"LocationData must be relative for this drawing funtion to work.");

		auto image_rows = image.rows;
		auto image_cols = image.cols;
		auto color = color_to_scalar(keypoint_drawing_spec.color);

		for (const auto& keypoint : location.relative_keypoints()) {
			auto keypoint_px = _normalized_to_pixel_coordinates(keypoint.x(), keypoint.y(), image_cols, image_rows);
			MP_ASSERT_RETURN_IF_ERROR(keypoint_px.get(), "Failed to get keypoint pixel coordinates");
			cv::circle(
				image,
				*keypoint_px,
				keypoint_drawing_spec.circle_radius,
				color,
				keypoint_drawing_spec.thickness
			);
		}

		MP_ASSIGN_OR_RETURN(auto location_has_relative_bounding_box, HasField(location, "relative_bounding_box"));
		if (!location_has_relative_bounding_box) {
			return absl::OkStatus();
		}

		const auto& relative_bounding_box = location.relative_bounding_box();

		auto rect_start_point = _normalized_to_pixel_coordinates(
			relative_bounding_box.xmin(), relative_bounding_box.ymin(), image_cols,
			image_rows);
		MP_ASSERT_RETURN_IF_ERROR(rect_start_point.get(), "Failed to get relative_bounding_box pixel coordinates");

		auto rect_end_point = _normalized_to_pixel_coordinates(
			relative_bounding_box.xmin() + relative_bounding_box.width(),
			relative_bounding_box.ymin() + relative_bounding_box.height(), image_cols,
			image_rows);
		MP_ASSERT_RETURN_IF_ERROR(rect_end_point.get(), "Failed to get relative_bounding_box pixel coordinates");

		cv::rectangle(
			image,
			*rect_start_point,
			*rect_end_point,
			color_to_scalar(bbox_drawing_spec.color),
			bbox_drawing_spec.thickness
		);

		return absl::OkStatus();
	}

	absl::Status draw_landmarks(
		cv::Mat& image,
		const NormalizedLandmarkList& landmark_list,
		const std::vector<std::tuple<int, int>>& connections,
		const std::shared_ptr<DrawingSpec>& landmark_drawing_spec,
		const DrawingSpec& connection_drawing_spec,
		const bool is_drawing_landmarks
	) {
		return _draw_landmarks(image, landmark_list, connections, landmark_drawing_spec, connection_drawing_spec, is_drawing_landmarks);
	}

	absl::Status draw_landmarks(
		cv::Mat& image,
		const NormalizedLandmarkList& landmark_list,
		const std::vector<std::tuple<int, int>>& connections,
		const std::map<int, DrawingSpec>& landmark_drawing_spec,
		const DrawingSpec& connection_drawing_spec,
		const bool is_drawing_landmarks
	) {
		return _draw_landmarks(image, landmark_list, connections, landmark_drawing_spec, connection_drawing_spec, is_drawing_landmarks);
	}

	absl::Status draw_landmarks(
		cv::Mat& image,
		const NormalizedLandmarkList& landmark_list,
		const std::vector<std::tuple<int, int>>& connections,
		const std::shared_ptr<DrawingSpec>& landmark_drawing_spec,
		const std::map<int, std::map<int, DrawingSpec>>& connection_drawing_spec,
		const bool is_drawing_landmarks
	) {
		return _draw_landmarks(image, landmark_list, connections, landmark_drawing_spec, connection_drawing_spec, is_drawing_landmarks);
	}

	absl::Status draw_landmarks(
		cv::Mat& image,
		const NormalizedLandmarkList& landmark_list,
		const std::vector<std::tuple<int, int>>& connections,
		const std::map<int, DrawingSpec>& landmark_drawing_spec,
		const std::map<int, std::map<int, DrawingSpec>>& connection_drawing_spec,
		const bool is_drawing_landmarks
	) {
		return _draw_landmarks(image, landmark_list, connections, landmark_drawing_spec, connection_drawing_spec, is_drawing_landmarks);
	}

	static cv::Mat clip(cv::Mat a, float a_min, float a_max) {
		cv::Mat dst;
		cv::max(a, a_min, dst);
		cv::min(dst, a_max, dst);
		return dst;
	}

	void draw_axis(
		cv::Mat& image,
		cv::Mat& rotation,
		cv::Mat& _translation,
		const std::tuple<float, float>& focal_length,
		const std::tuple<float, float>& principal_point,
		float axis_length,
		const DrawingSpec& axis_drawing_spec
	) {
		auto image_rows = image.rows;
		auto image_cols = image.cols;

		// Create axis points in camera coordinate frame.
		cv::Mat axis_world = (cv::Mat_<float>({
			0, 0, 0,
			1, 0, 0,
			0, 1, 0,
			0, 0, 1
			})).reshape(1, 4);

		cv::Mat transposed;
		cv::transpose(axis_world, transposed);
		transposed *= axis_length;
		transposed = rotation.reshape(1) * transposed;

		cv::Mat axis_cam;
		cv::transpose(transposed, axis_cam);

		// translation only works with CV_64F matrixes
		cv::Mat translation;
		if (_translation.depth() != CV_64F) {
			_translation.convertTo(translation, CV_64F);
		}
		else {
			translation = _translation;
		}

		axis_cam = axis_cam.reshape(3) + translation.reshape(1, 1);

		cv::Mat channels[3];
		cv::split(axis_cam, channels);

		auto x = channels[0];
		auto y = channels[1];
		auto z = channels[2];

		// Project 3D points to NDC space.
		auto [fx, fy] = focal_length;
		auto [px, py] = principal_point;
		cv::Mat x_ndc = clip(-fx * x / (z + 1e-5) + px, -1., 1.);
		cv::Mat y_ndc = clip(-fy * y / (z + 1e-5) + py, -1., 1.);

		// Convert from NDC space to image space.
		x_ndc = (1 + x_ndc) * 0.5 * image_cols;
		y_ndc = (1 - y_ndc) * 0.5 * image_rows;
		cv::Mat x_im; x_ndc.convertTo(x_im, CV_32S);
		cv::Mat y_im; y_ndc.convertTo(y_im, CV_32S);

		// Draw xyz axis on the image.
		cv::Point origin(x_im.at<int>(0), y_im.at<int>(0));
		cv::Point x_axis(x_im.at<int>(1), y_im.at<int>(1));
		cv::Point y_axis(x_im.at<int>(2), y_im.at<int>(2));
		cv::Point z_axis(x_im.at<int>(3), y_im.at<int>(3));

		cv::arrowedLine(image, origin, x_axis, color_to_scalar(RED_COLOR), axis_drawing_spec.thickness);
		cv::arrowedLine(image, origin, y_axis, color_to_scalar(GREEN_COLOR),
			axis_drawing_spec.thickness);
		cv::arrowedLine(image, origin, z_axis, color_to_scalar(BLUE_COLOR),
			axis_drawing_spec.thickness);
	}
}
