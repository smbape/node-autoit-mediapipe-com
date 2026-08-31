#pragma once

#include "absl/memory/memory.h"
#include "mediapipe/framework/formats/image.h"
#include "mediapipe/framework/formats/image_format.pb.h"
#include "mediapipe/framework/formats/image_frame.h"
#include "mediapipe/framework/formats/image_frame_opencv.h"
#include "mediapipe/framework/port/logging.h"
#include "mediapipe/framework/port/status_macros.h"
#include "binding/util.h"
#include <opencv2/imgcodecs.hpp>

namespace mediapipe::autoit {
	[[nodiscard]] absl::StatusOr<std::shared_ptr<ImageFrame>> CreateImageFrame(
		ImageFormat::Format format,
		const cv::Mat& data,
		bool copy = true
	);

	[[nodiscard]] absl::StatusOr<std::shared_ptr<ImageFrame>> CreateImageFrame(const cv::Mat& data, bool copy = true);

	[[nodiscard]] absl::StatusOr<std::shared_ptr<ImageFrame>> CreateImageFrame(const std::string& file_name);

	template<typename... Args>
	[[nodiscard]] inline absl::StatusOr<std::shared_ptr<Image>> CreateImage(Args&&... args) {
		MP_ASSIGN_OR_RETURN(auto shared_ptr, CreateImageFrame(std::forward<Args>(args)...));
		return std::make_shared<Image>(shared_ptr);
	}
}
