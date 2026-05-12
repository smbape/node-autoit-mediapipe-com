#include "binding/tasks/components/containers/landmark_detection_result.h"

namespace mediapipe::tasks::components::containers {
	tasks::containers::proto::LandmarksDetectionResult ConvertLandmarkListToProto(LandmarksDetectionResult* landmarks_detection_result) {
		tasks::containers::proto::LandmarksDetectionResult landmarks_detection_result_proto;

		for (const auto& landmark : landmarks_detection_result->landmarks) {
			landmarks_detection_result_proto.mutable_landmarks()->add_landmark()->CopyFrom(ConvertNormalizedLandmarkToProto(const_cast<NormalizedLandmark*>(&landmark)));
		}

		for (const auto& world_landmark : landmarks_detection_result->world_landmarks) {
			landmarks_detection_result_proto.mutable_world_landmarks()->add_landmark()->CopyFrom(ConvertLandmarkToProto(const_cast<Landmark*>(&world_landmark)));
		}

		for (const auto& category : landmarks_detection_result->categories) {
			landmarks_detection_result_proto.mutable_classifications()->add_classification()->CopyFrom(ConvertCategoryToProto(const_cast<Category*>(&category)));
		}

		landmarks_detection_result_proto.mutable_rect()->CopyFrom(ConvertNormalizedRectToProto(const_cast<NormalizedRect*>(&landmarks_detection_result->rect)));

		return landmarks_detection_result_proto;
	}

	LandmarksDetectionResult ConvertToLandmarksDetectionResult(const tasks::containers::proto::LandmarksDetectionResult& proto) {
		LandmarksDetectionResult landmarks_dectection_result;

		landmarks_dectection_result.landmarks.reserve(proto.landmarks().landmark_size());
		for (const auto& landmark : proto.landmarks().landmark()) {
			landmarks_dectection_result.landmarks.push_back(ConvertToNormalizedLandmark(landmark));
		}

		landmarks_dectection_result.categories.reserve(proto.classifications().classification_size());
		for (const auto& classification : proto.classifications().classification()) {
			landmarks_dectection_result.categories.push_back(ConvertToCategory(classification));
		}

		landmarks_dectection_result.world_landmarks.reserve(proto.world_landmarks().landmark_size());
		for (const auto& landmark : proto.world_landmarks().landmark()) {
			landmarks_dectection_result.world_landmarks.push_back(ConvertToLandmark(landmark));
		}

		landmarks_dectection_result.rect = ConvertToNormalizedRect(proto.rect());

		return landmarks_dectection_result;
	}
}
