#pragma once

#include "mediapipe/tasks/cc/vision/object_detector/object_detector.h"

namespace mediapipe::tasks::vision::object_detector {
	using ObjectDetectorResultRawCallback = void(*)(ObjectDetectorResult*, int, const char*, const Image&, int64_t);
	using ObjectDetectorResultCallback = std::function<void(absl::StatusOr<ObjectDetectorResult>, const Image&, int64_t)>;
}

PTR_BRIDGE_DECL(mediapipe::tasks::vision::object_detector::ObjectDetectorResultRawCallback);
extern const HRESULT autoit_to(VARIANT const* in_val, mediapipe::tasks::vision::object_detector::ObjectDetectorResultCallback& out_val);
