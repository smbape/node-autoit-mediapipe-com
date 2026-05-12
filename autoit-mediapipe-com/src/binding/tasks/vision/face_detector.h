#pragma once

#include "mediapipe/tasks/cc/vision/face_detector/face_detector.h"

namespace mediapipe::tasks::vision::face_detector {
	using FaceDetectorResultRawCallback = void(*)(FaceDetectorResult*, int, const char*, const Image&, uint64_t);
	using FaceDetectorResultCallback = std::function<void(absl::StatusOr<FaceDetectorResult>, const Image&, uint64_t)>;
}

PTR_BRIDGE_DECL(mediapipe::tasks::vision::face_detector::FaceDetectorResultRawCallback);
extern const HRESULT autoit_to(VARIANT const* in_val, mediapipe::tasks::vision::face_detector::FaceDetectorResultCallback& out_val);
