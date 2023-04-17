#pragma once

#include "binding/tasks/components/containers/rect.h"

namespace mediapipe::tasks::autoit::vision::core::image_processing_options {
	struct CV_EXPORTS_W_SIMPLE ImageProcessingOptions {
		CV_WRAP ImageProcessingOptions(const ImageProcessingOptions& other) = default;
		ImageProcessingOptions& operator=(const ImageProcessingOptions& other) = default;

		CV_WRAP ImageProcessingOptions(
			std::shared_ptr<components::containers::rect::Rect> region_of_interest = std::shared_ptr<components::containers::rect::Rect>(),
			int rotation_degrees = 0
		) :
			region_of_interest(region_of_interest),
			rotation_degrees(rotation_degrees)
		{}

		CV_PROP_RW std::shared_ptr<components::containers::rect::Rect> region_of_interest;
		CV_PROP_RW int rotation_degrees;
	};
}
