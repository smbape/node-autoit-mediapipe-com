#include "binding/tasks/components/containers/detections.h"

using namespace mediapipe::tasks::components::containers;

namespace mediapipe::tasks::autoit::components::containers::detections {
	std::shared_ptr<mediapipe::Detection> Detection::to_pb2() const {
		auto pb2_obj = std::make_shared<mediapipe::Detection>();

		if (categories) {
			for (const auto& category : *categories) {
				pb2_obj->add_score(category->score);
				if (category->index >= 0) {
					pb2_obj->add_label_id(category->index);
				}
				if (!category->category_name.empty()) {
					pb2_obj->add_label(category->category_name);
				}
				if (!category->display_name.empty()) {
					pb2_obj->add_display_name(category->display_name);
				}
			}
		}

		pb2_obj->mutable_location_data()->set_format(LocationData::BOUNDING_BOX);

		if (bounding_box) {
			pb2_obj->mutable_location_data()->mutable_bounding_box()->CopyFrom(*bounding_box->to_pb2());
		}

		if (keypoints) {
			for (const auto& keypoint : *keypoints) {
				pb2_obj->mutable_location_data()->add_relative_keypoints()->CopyFrom(*keypoint->to_pb2());
			}
		}

		return pb2_obj;
	}

	std::shared_ptr<Detection> Detection::create_from_pb2(const mediapipe::Detection& pb2_obj) {
		std::shared_ptr<std::vector<std::shared_ptr<category::Category>>> categories = std::make_shared<std::vector<std::shared_ptr<category::Category>>>();
		int idx = 0;
		for (const auto& score : pb2_obj.score()) {
			auto category = std::make_shared<category::Category>();

			category->score = score;

			if (idx < pb2_obj.label_id_size()) {
				category->index = pb2_obj.label_id(idx);
			}

			if (idx < pb2_obj.label_size()) {
				category->category_name = pb2_obj.label(idx);
			}

			if (idx < pb2_obj.display_name_size()) {
				category->display_name = pb2_obj.display_name(idx);
			}

			categories->push_back(std::move(category));

			idx++;
		}

		std::shared_ptr<std::vector<std::shared_ptr<keypoint::NormalizedKeypoint>>> keypoints = std::make_shared<std::vector<std::shared_ptr<keypoint::NormalizedKeypoint>>>();
		for (const auto& keypoint : pb2_obj.location_data().relative_keypoints()) {
			keypoints->push_back(std::move(keypoint::NormalizedKeypoint::create_from_pb2(keypoint)));
		}

		return std::make_shared<Detection>(
			bounding_box::BoundingBox::create_from_pb2(pb2_obj.location_data().bounding_box()),
			categories,
			keypoints
		);
	}

	std::shared_ptr<mediapipe::DetectionList> DetectionResult::to_pb2() const {
		auto pb2_obj = std::make_shared<mediapipe::DetectionList>();

		if (detections) {
			for (const auto& detection : *detections) {
				pb2_obj->add_detection()->CopyFrom(*detection->to_pb2());
			}
		}

		return pb2_obj;
	}

	std::shared_ptr<DetectionResult> DetectionResult::create_from_pb2(const mediapipe::DetectionList& pb2_obj) {
		auto detection_result = std::make_shared<DetectionResult>();
		for (const auto& detection : pb2_obj.detection()) {
			detection_result->detections->push_back(std::move(Detection::create_from_pb2(detection)));
		}
		return detection_result;
	}
}
