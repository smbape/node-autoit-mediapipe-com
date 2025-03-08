#pragma once

#include "mediapipe/framework/formats/detection.pb.h"
#include "mediapipe/framework/formats/location_data.pb.h"
#include "binding/tasks/components/containers/bounding_box.h"
#include "binding/tasks/components/containers/category.h"
#include "binding/tasks/components/containers/keypoint.h"

namespace mediapipe::tasks::autoit::components::containers::detections {
	struct CV_EXPORTS_W_SIMPLE Detection {
		CV_WRAP Detection(const detections::Detection& other) = default;
		Detection& operator=(const Detection& other) = default;

		CV_WRAP Detection(
			std::shared_ptr<bounding_box::BoundingBox> bounding_box = std::shared_ptr<bounding_box::BoundingBox>(),
			const std::shared_ptr<std::vector<std::shared_ptr<category::Category>>>& categories = std::make_shared<std::vector<std::shared_ptr<category::Category>>>(),
			const std::shared_ptr<std::vector<std::shared_ptr<keypoint::NormalizedKeypoint>>>& keypoints = std::make_shared<std::vector<std::shared_ptr<keypoint::NormalizedKeypoint>>>()
		)
			:
			bounding_box(bounding_box),
			categories(categories),
			keypoints(keypoints)
		{}

		CV_WRAP std::shared_ptr<mediapipe::Detection> to_pb2() const;
		CV_WRAP static std::shared_ptr<detections::Detection> create_from_pb2(const mediapipe::Detection& pb2_obj);

		bool operator== (const Detection& other) const {
			return ::autoit::__eq__(bounding_box, other.bounding_box) &&
				::autoit::__eq__(categories, other.categories) &&
				::autoit::__eq__(keypoints, other.keypoints);
		}

		CV_PROP_RW std::shared_ptr<bounding_box::BoundingBox> bounding_box;
		CV_PROP_RW std::shared_ptr<std::vector<std::shared_ptr<category::Category>>> categories;
		CV_PROP_RW std::shared_ptr<std::vector<std::shared_ptr<keypoint::NormalizedKeypoint>>> keypoints;
	};

	struct CV_EXPORTS_W_SIMPLE DetectionResult {
		CV_WRAP DetectionResult(const DetectionResult& other) = default;
		DetectionResult& operator=(const DetectionResult& other) = default;

		CV_WRAP DetectionResult(
			const std::shared_ptr<std::vector<std::shared_ptr<detections::Detection>>>& detections = std::make_shared<std::vector<std::shared_ptr<detections::Detection>>>()
		)
			:
			detections(detections)
		{}

		CV_WRAP std::shared_ptr<mediapipe::DetectionList> to_pb2() const;
		CV_WRAP static std::shared_ptr<DetectionResult> create_from_pb2(const mediapipe::DetectionList& pb2_obj);

		bool operator== (const DetectionResult& other) const {
			return ::autoit::__eq__(detections, other.detections);
		}

		CV_PROP_RW std::shared_ptr<std::vector<std::shared_ptr<detections::Detection>>> detections;
	};
}
