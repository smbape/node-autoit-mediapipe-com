#pragma once

#include "mediapipe/framework/formats/rect.pb.h"
#include <opencv2/core/cvdef.h>
#include "autoit_bridge_common.h"

namespace mediapipe::tasks::autoit::components::containers::rect {
	struct CV_EXPORTS_W_SIMPLE Rect {
		CV_WRAP Rect(const rect::Rect& other) = default;
		Rect& operator=(const rect::Rect& other) = default;

		CV_WRAP Rect(
			float left = 0.0f,
			float top = 0.0f,
			float right = 0.0f,
			float bottom = 0.0f
		)
			:
			left(left),
			top(top),
			right(right),
			bottom(bottom)
		{}

		bool operator== (const Rect& other) const {
			return ::autoit::__eq__(left, other.left) &&
				::autoit::__eq__(top, other.top) &&
				::autoit::__eq__(right, other.right) &&
				::autoit::__eq__(bottom, other.bottom);
		}

		float left;
		float top;
		float right;
		float bottom;
	};

	struct CV_EXPORTS_W_SIMPLE NormalizedRect {
		CV_WRAP NormalizedRect(const rect::NormalizedRect& other) = default;
		NormalizedRect& operator=(const rect::NormalizedRect& other) = default;

		CV_WRAP NormalizedRect(
			float x_center = 0.0f,
			float y_center = 0.0f,
			float width = 0.0f,
			float height = 0.0f,
			float rotation = 0.0f,
			int64_t rect_id = -1
		)
			:
			x_center(x_center),
			y_center(y_center),
			width(width),
			height(height),
			rotation(rotation),
			rect_id(rect_id)
		{}

		CV_WRAP std::shared_ptr<mediapipe::NormalizedRect> to_pb2() const;
		CV_WRAP static std::shared_ptr<rect::NormalizedRect> create_from_pb2(const mediapipe::NormalizedRect& pb2_obj);

		bool operator== (const NormalizedRect& other) const {
			return ::autoit::__eq__(x_center, other.x_center) &&
				::autoit::__eq__(y_center, other.y_center) &&
				::autoit::__eq__(width, other.width) &&
				::autoit::__eq__(height, other.height) &&
				::autoit::__eq__(rotation, other.rotation);
		}

		float x_center;
		float y_center;
		float width;
		float height;
		float rotation;
		int64_t rect_id;

	};
}
