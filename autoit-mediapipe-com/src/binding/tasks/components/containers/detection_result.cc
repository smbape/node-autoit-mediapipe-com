#include "binding/tasks/components/containers/detection_result.h"
#include "binding/tasks/components/containers/bounding_box.h"
#include "binding/tasks/components/containers/keypoint.h"

namespace mediapipe::tasks::components::containers {

	mediapipe::Detection ConvertDetectionToProto(Detection* detection) {
		mediapipe::Detection detection_proto;

		for (const auto& category : detection->categories) {
			detection_proto.add_score(category.score);
			if (category.index >= 0) {
				detection_proto.add_label_id(category.index);
			}
			if (category.category_name) {
				detection_proto.add_label(*category.category_name);
			}
			if (category.display_name) {
				detection_proto.add_display_name(*category.display_name);
			}
		}

		detection_proto.mutable_location_data()->set_format(LocationData::BOUNDING_BOX);

		if (detection->bounding_box.left != 0 || detection->bounding_box.top != 0 || detection->bounding_box.right != 0 || detection->bounding_box.bottom != 0) {
			detection_proto.mutable_location_data()->mutable_bounding_box()->CopyFrom(ConvertRectToProto(const_cast<Rect*>(&detection->bounding_box)));
		}

		if (detection->keypoints) {
			for (const auto& keypoint : *detection->keypoints) {
				detection_proto.mutable_location_data()->add_relative_keypoints()->CopyFrom(ConvertNormalizedKeypointToProto(const_cast<NormalizedKeypoint*>(&keypoint)));
			}
		}

		return detection_proto;
	}

	mediapipe::DetectionList ConvertDetectionResultToProto(DetectionResult* detection_result) {
		mediapipe::DetectionList detection_list_proto;

		for (const auto& detection : detection_result->detections) {
			detection_list_proto.add_detection()->CopyFrom(ConvertDetectionToProto(const_cast<Detection*>(&detection)));
		}

		return detection_list_proto;
	}

	constexpr int kDefaultCategoryIndex = -1;

	Detection ConvertToDetection(const mediapipe::Detection& detection_proto, int image_width, int image_height) {
		Detection detection;
		for (int idx = 0; idx < detection_proto.score_size(); ++idx) {
			detection.categories.push_back({
				.index = detection_proto.label_id_size() > idx ? detection_proto.label_id(idx) : kDefaultCategoryIndex,
				.score = detection_proto.score(idx),
				.category_name = detection_proto.label_size() > idx ? detection_proto.label(idx) : "",
				.display_name = detection_proto.display_name_size() > idx ? detection_proto.display_name(idx) : ""
				});
		}

		Rect bounding_box{ 0, 0, 0, 0 };
		if (detection_proto.location_data().has_relative_bounding_box()) {
			mediapipe::LocationData::RelativeBoundingBox relative_bounding_box_proto = detection_proto.location_data().relative_bounding_box();
			bounding_box.left = relative_bounding_box_proto.xmin() * image_width;
			bounding_box.top = relative_bounding_box_proto.ymin() * image_height;
			bounding_box.right = bounding_box.left + relative_bounding_box_proto.width() * image_width;
			bounding_box.bottom = bounding_box.top + relative_bounding_box_proto.height() * image_height;
		}
		detection.bounding_box = bounding_box;

		if (!detection_proto.location_data().relative_keypoints().empty()) {
			detection.keypoints = std::vector<NormalizedKeypoint>();
			detection.keypoints->reserve(
				detection_proto.location_data().relative_keypoints_size());
			for (const auto& keypoint :
				detection_proto.location_data().relative_keypoints()) {
				detection.keypoints->push_back(
					{ keypoint.x(), keypoint.y(),
					 keypoint.has_keypoint_label()
						 ? std::make_optional(keypoint.keypoint_label())
						 : std::nullopt,
					 keypoint.has_score() ? std::make_optional(keypoint.score())
										  : std::nullopt });
			}
		}

		return detection;
	}
}
