#pragma once

#include "mediapipe/framework/formats/location_data.pb.h"
#include <opencv2/core/cvdef.h>
#include "autoit_bridge_common.h"

namespace mediapipe::tasks::autoit::components::containers::bounding_box {
	struct CV_EXPORTS_W_SIMPLE BoundingBox {
		CV_WRAP BoundingBox(const BoundingBox& other) = default;
		BoundingBox& operator=(const BoundingBox& other) = default;

		CV_WRAP BoundingBox(
			int origin_x = 0,
			int origin_y = 0,
			int width = 0,
			int height = 0
		)
			:
			origin_x(origin_x),
			origin_y(origin_y),
			width(width),
			height(height)
		{}

		CV_WRAP std::shared_ptr<LocationData::BoundingBox> to_pb2() const;
		CV_WRAP static std::shared_ptr<BoundingBox> create_from_pb2(const LocationData::BoundingBox& pb2_obj);

		bool operator== (const BoundingBox& other) const {
			return ::autoit::__eq__(origin_x, other.origin_x) &&
				::autoit::__eq__(origin_y, other.origin_y) &&
				::autoit::__eq__(width, other.width) &&
				::autoit::__eq__(height, other.height);
		}

		CV_PROP_RW int origin_x;
		CV_PROP_RW int origin_y;
		CV_PROP_RW int width;
		CV_PROP_RW int height;
	};
}