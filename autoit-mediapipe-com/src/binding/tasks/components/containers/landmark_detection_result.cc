#include "binding/tasks/components/containers/landmark_detection_result.h"

using namespace mediapipe::tasks::containers;

namespace mediapipe::tasks::autoit::components::containers::landmark_detection_result {
	std::shared_ptr<proto::LandmarksDetectionResult> LandmarksDetectionResult::to_pb2() const {
		auto pb2_obj = std::make_shared<proto::LandmarksDetectionResult>();

		if (landmarks) {
			for (const auto& landmark : *landmarks) {
				pb2_obj->mutable_landmarks()->add_landmark()->CopyFrom(*landmark->to_pb2());
			}
		}

		if (world_landmarks) {
			for (const auto& world_landmark : *world_landmarks) {
				pb2_obj->mutable_world_landmarks()->add_landmark()->CopyFrom(*world_landmark->to_pb2());
			}
		}

		if (categories) {
			for (const auto& category : *categories) {
				auto classification = pb2_obj->mutable_classifications()->add_classification();
				classification->set_index(category->index);
				classification->set_score(category->score);
				classification->set_label(category->category_name);
				classification->set_display_name(category->display_name);
			}
		}

		if (rect) {
			pb2_obj->mutable_rect()->CopyFrom(*rect->to_pb2());
		}

		return pb2_obj;
	}

	std::shared_ptr<LandmarksDetectionResult> LandmarksDetectionResult::create_from_pb2(const proto::LandmarksDetectionResult& pb2_obj) {
		auto landmarks_dectection_result = std::make_shared<LandmarksDetectionResult>();

		for (const auto& classification : pb2_obj.classifications().classification()) {
			landmarks_dectection_result->categories->push_back(std::move(std::make_shared<category::Category>(
				classification.index(),
				classification.score(),
				classification.display_name(),
				classification.label()
			)));
		}

		for (const auto& landmark : pb2_obj.landmarks().landmark()) {
			landmarks_dectection_result->landmarks->push_back(std::move(landmark::NormalizedLandmark::create_from_pb2(landmark)));
		}

		for (const auto& landmark : pb2_obj.world_landmarks().landmark()) {
			landmarks_dectection_result->world_landmarks->push_back(std::move(landmark::Landmark::create_from_pb2(landmark)));
		}

		landmarks_dectection_result->rect = rect::NormalizedRect::create_from_pb2(pb2_obj.rect());

		return landmarks_dectection_result;
	}
}
