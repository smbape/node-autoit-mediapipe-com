#pragma once

#include "mediapipe/tasks/cc/vision/image_segmenter/image_segmenter.h"

namespace mediapipe::tasks::vision::image_segmenter {
	using ImageSegmenterResultRawCallback = void(*)(ImageSegmenterResult*, int, const char*, const Image&, int64_t);
	using ImageSegmenterResultCallback = std::function<void(absl::StatusOr<ImageSegmenterResult>, const Image&, int64_t)>;

	inline bool operator==(const ImageSegmenterResult& lhs, const ImageSegmenterResult& rhs) {
		return lhs.confidence_masks == rhs.confidence_masks
			&& lhs.category_mask == rhs.category_mask
			&& lhs.quality_scores == rhs.quality_scores;
	}
}

PTR_BRIDGE_DECL(mediapipe::tasks::vision::image_segmenter::ImageSegmenterResultRawCallback);
extern const HRESULT autoit_to(VARIANT const* in_val, mediapipe::tasks::vision::image_segmenter::ImageSegmenterResultCallback& out_val);
