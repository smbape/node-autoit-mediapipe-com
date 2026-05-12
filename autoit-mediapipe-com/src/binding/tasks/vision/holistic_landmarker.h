#pragma once

#include "mediapipe/tasks/cc/vision/holistic_landmarker/holistic_landmarker.h"
#include "mediapipe/tasks/cc/vision/holistic_landmarker/proto/holistic_result.pb.h"

namespace mediapipe::tasks::vision::holistic_landmarker {
	using HolisticLandmarkerResultRawCallback = void(*)(HolisticLandmarkerResult*, int, const char*, const Image&, int64_t);
	using HolisticLandmarkerResultCallback = std::function<void(absl::StatusOr<HolisticLandmarkerResult>, const Image&, int64_t)>;

	inline bool operator==(const HolisticLandmarkerResult& lhs, const HolisticLandmarkerResult& rhs) {
		return lhs.face_landmarks == rhs.face_landmarks
			&& lhs.face_blendshapes == rhs.face_blendshapes
			&& lhs.pose_landmarks == rhs.pose_landmarks
			&& lhs.pose_world_landmarks == rhs.pose_world_landmarks
			&& lhs.left_hand_landmarks == rhs.left_hand_landmarks
			&& lhs.right_hand_landmarks == rhs.right_hand_landmarks
			&& lhs.left_hand_world_landmarks == rhs.left_hand_world_landmarks
			&& lhs.right_hand_world_landmarks == rhs.right_hand_world_landmarks
			&& lhs.pose_segmentation_masks == rhs.pose_segmentation_masks;
	}
}

PTR_BRIDGE_DECL(mediapipe::tasks::vision::holistic_landmarker::HolisticLandmarkerResultRawCallback);
extern const HRESULT autoit_to(VARIANT const* in_val, mediapipe::tasks::vision::holistic_landmarker::HolisticLandmarkerResultCallback& out_val);
