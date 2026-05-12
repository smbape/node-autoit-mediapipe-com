#pragma once

#include "mediapipe/tasks/cc/vision/image_embedder/image_embedder.h"

namespace mediapipe::tasks::vision::image_embedder {
	using ImageEmbedderResultRawCallback = void(*)(ImageEmbedderResult*, int, const char*, const Image&, int64_t);
	using ImageEmbedderResultCallback = std::function<void(absl::StatusOr<ImageEmbedderResult>, const Image&, int64_t)>;
}

PTR_BRIDGE_DECL(mediapipe::tasks::vision::image_embedder::ImageEmbedderResultRawCallback);
extern const HRESULT autoit_to(VARIANT const* in_val, mediapipe::tasks::vision::image_embedder::ImageEmbedderResultCallback& out_val);
