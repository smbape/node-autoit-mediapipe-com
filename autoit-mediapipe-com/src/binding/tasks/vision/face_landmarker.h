#pragma once

#include "mediapipe/tasks/cc/vision/face_landmarker/face_landmarker.h"

namespace mediapipe::tasks::vision::face_landmarker {
	using FaceLandmarkerResultRawCallback = void(*)(FaceLandmarkerResult*, int, const char*, const Image&, int64_t);
	using FaceLandmarkerResultCallback = std::function<void(absl::StatusOr<FaceLandmarkerResult>, const Image&, int64_t)>;

	inline bool operator==(const FaceLandmarkerResult& lhs, const FaceLandmarkerResult& rhs) {
		return lhs.face_landmarks == rhs.face_landmarks
			&& lhs.face_blendshapes == rhs.face_blendshapes
			&& lhs.facial_transformation_matrixes == rhs.facial_transformation_matrixes;
	}

	enum class Blendshapes {
		// The 52 blendshape coefficients.
		NEUTRAL = 0,
		BROW_DOWN_LEFT = 1,
		BROW_DOWN_RIGHT = 2,
		BROW_INNER_UP = 3,
		BROW_OUTER_UP_LEFT = 4,
		BROW_OUTER_UP_RIGHT = 5,
		CHEEK_PUFF = 6,
		CHEEK_SQUINT_LEFT = 7,
		CHEEK_SQUINT_RIGHT = 8,
		EYE_BLINK_LEFT = 9,
		EYE_BLINK_RIGHT = 10,
		EYE_LOOK_DOWN_LEFT = 11,
		EYE_LOOK_DOWN_RIGHT = 12,
		EYE_LOOK_IN_LEFT = 13,
		EYE_LOOK_IN_RIGHT = 14,
		EYE_LOOK_OUT_LEFT = 15,
		EYE_LOOK_OUT_RIGHT = 16,
		EYE_LOOK_UP_LEFT = 17,
		EYE_LOOK_UP_RIGHT = 18,
		EYE_SQUINT_LEFT = 19,
		EYE_SQUINT_RIGHT = 20,
		EYE_WIDE_LEFT = 21,
		EYE_WIDE_RIGHT = 22,
		JAW_FORWARD = 23,
		JAW_LEFT = 24,
		JAW_OPEN = 25,
		JAW_RIGHT = 26,
		MOUTH_CLOSE = 27,
		MOUTH_DIMPLE_LEFT = 28,
		MOUTH_DIMPLE_RIGHT = 29,
		MOUTH_FROWN_LEFT = 30,
		MOUTH_FROWN_RIGHT = 31,
		MOUTH_FUNNEL = 32,
		MOUTH_LEFT = 33,
		MOUTH_LOWER_DOWN_LEFT = 34,
		MOUTH_LOWER_DOWN_RIGHT = 35,
		MOUTH_PRESS_LEFT = 36,
		MOUTH_PRESS_RIGHT = 37,
		MOUTH_PUCKER = 38,
		MOUTH_RIGHT = 39,
		MOUTH_ROLL_LOWER = 40,
		MOUTH_ROLL_UPPER = 41,
		MOUTH_SHRUG_LOWER = 42,
		MOUTH_SHRUG_UPPER = 43,
		MOUTH_SMILE_LEFT = 44,
		MOUTH_SMILE_RIGHT = 45,
		MOUTH_STRETCH_LEFT = 46,
		MOUTH_STRETCH_RIGHT = 47,
		MOUTH_UPPER_UP_LEFT = 48,
		MOUTH_UPPER_UP_RIGHT = 49,
		NOSE_SNEER_LEFT = 50,
		NOSE_SNEER_RIGHT = 51,
	};

	struct CV_EXPORTS_W_SIMPLE FaceLandmarksConnections {
		using Connection = mediapipe::tasks::components::containers::Connection;

		CV_WRAP_AS(get FACE_LANDMARKS_LIPS) static const std::vector<Connection>& FACE_LANDMARKS_LIPS();
		CV_WRAP_AS(get FACE_LANDMARKS_LEFT_EYE) static const std::vector<Connection>& FACE_LANDMARKS_LEFT_EYE();
		CV_WRAP_AS(get FACE_LANDMARKS_LEFT_EYEBROW) static const std::vector<Connection>& FACE_LANDMARKS_LEFT_EYEBROW();
		CV_WRAP_AS(get FACE_LANDMARKS_LEFT_IRIS) static const std::vector<Connection>& FACE_LANDMARKS_LEFT_IRIS();
		CV_WRAP_AS(get FACE_LANDMARKS_RIGHT_EYE) static const std::vector<Connection>& FACE_LANDMARKS_RIGHT_EYE();
		CV_WRAP_AS(get FACE_LANDMARKS_RIGHT_EYEBROW) static const std::vector<Connection>& FACE_LANDMARKS_RIGHT_EYEBROW();
		CV_WRAP_AS(get FACE_LANDMARKS_RIGHT_IRIS) static const std::vector<Connection>& FACE_LANDMARKS_RIGHT_IRIS();
		CV_WRAP_AS(get FACE_LANDMARKS_FACE_OVAL) static const std::vector<Connection>& FACE_LANDMARKS_FACE_OVAL();
		CV_WRAP_AS(get FACE_LANDMARKS_NOSE) static const std::vector<Connection>& FACE_LANDMARKS_NOSE();
		CV_WRAP_AS(get FACE_LANDMARKS_CONTOURS) static const std::vector<Connection>& FACE_LANDMARKS_CONTOURS();
		CV_WRAP_AS(get FACE_LANDMARKS_TESSELATION) static const std::vector<Connection>& FACE_LANDMARKS_TESSELATION();
	};
}

PTR_BRIDGE_DECL(mediapipe::tasks::vision::face_landmarker::FaceLandmarkerResultRawCallback);
extern const HRESULT autoit_to(VARIANT const* in_val, mediapipe::tasks::vision::face_landmarker::FaceLandmarkerResultCallback& out_val);
