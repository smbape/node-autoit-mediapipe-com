#pragma once

#include "mediapipe/framework/formats/location_data.pb.h"

namespace mediapipe {
	namespace tasks {
		namespace autoit {
			namespace components {
				namespace containers {
					namespace bounding_box {
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

							CV_WRAP std::shared_ptr<LocationData::BoundingBox> to_pb2();
							CV_WRAP static std::shared_ptr<BoundingBox> create_from_pb2(const LocationData::BoundingBox& pb2_obj);

							CV_PROP_RW int origin_x;
							CV_PROP_RW int origin_y;
							CV_PROP_RW int width;
							CV_PROP_RW int height;
						};
					}
				}
			}
		}
	}
}
