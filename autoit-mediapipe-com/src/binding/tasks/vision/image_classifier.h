#pragma once

#include "mediapipe/tasks/cc/vision/image_classifier/image_classifier.h"

namespace mediapipe::tasks::vision::image_classifier {
	using ImageClassifierResultRawCallback = void(*)(ImageClassifierResult*, int, const char*, const Image&, int64_t);
	using ImageClassifierResultCallback = std::function<void(absl::StatusOr<ImageClassifierResult>, const Image&, int64_t)>;
}

PTR_BRIDGE_DECL(mediapipe::tasks::vision::image_classifier::ImageClassifierResultRawCallback);
extern const HRESULT autoit_to(VARIANT const* in_val, mediapipe::tasks::vision::image_classifier::ImageClassifierResultCallback& out_val);
