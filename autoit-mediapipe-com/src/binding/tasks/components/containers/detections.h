#pragma once

#include "mediapipe/framework/formats/detection.pb.h"
#include "mediapipe/framework/formats/location_data.pb.h"
#include "binding/tasks/components/containers/bounding_box.h"
#include "binding/tasks/components/containers/category.h"

namespace mediapipe {
	namespace tasks {
		namespace autoit {
			namespace components {
				namespace containers {
					namespace detections {
						struct CV_EXPORTS_W_SIMPLE Detection {
							CV_WRAP Detection(const detections::Detection& other) = default;
							Detection& operator=(const Detection& other) = default;

							CV_WRAP Detection(
								std::shared_ptr<bounding_box::BoundingBox> bounding_box = std::shared_ptr<bounding_box::BoundingBox>(),
								const std::vector<std::shared_ptr<category::Category>>& categories = std::vector<std::shared_ptr<category::Category>>()
							)
								:
								bounding_box(bounding_box),
								categories(categories)
							{}

							CV_WRAP std::shared_ptr<mediapipe::Detection> to_pb2();
							CV_WRAP static std::shared_ptr<detections::Detection> create_from_pb2(const mediapipe::Detection& pb2_obj);

							CV_PROP_RW std::shared_ptr<bounding_box::BoundingBox> bounding_box;
							CV_PROP_RW std::vector<std::shared_ptr<category::Category>> categories;
						};

						struct CV_EXPORTS_W_SIMPLE DetectionResult {
							CV_WRAP DetectionResult(const DetectionResult& other) = default;
							DetectionResult& operator=(const DetectionResult& other) = default;

							CV_WRAP DetectionResult(
								const std::vector<std::shared_ptr<detections::Detection>>& detections = std::vector<std::shared_ptr<detections::Detection>>()
							)
								:
								detections(detections)
							{}

							CV_WRAP std::shared_ptr<mediapipe::DetectionList> to_pb2();
							CV_WRAP static std::shared_ptr<DetectionResult> create_from_pb2(const mediapipe::DetectionList& pb2_obj);

							CV_PROP_RW std::vector<std::shared_ptr<detections::Detection>> detections;
						};
					}
				}
			}
		}
	}
}
