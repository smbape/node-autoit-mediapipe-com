#pragma once

#include "absl/memory/memory.h"
#include "mediapipe/framework/formats/image.h"
#include "mediapipe/framework/formats/image_format.pb.h"
#include "mediapipe/framework/formats/image_frame.h"
#include "mediapipe/framework/formats/image_frame_opencv.h"
#include "mediapipe/framework/port/logging.h"
#include "mediapipe/framework/port/status_macros.h"
#include "stb_image.h"
#include "binding/util.h"
#include <opencv2/imgcodecs.hpp>

namespace mediapipe::autoit {
	[[nodiscard]] inline absl::StatusOr<std::unique_ptr<ImageFrame>> CreateImageFrame(
		ImageFormat::Format format,
		const cv::Mat& data,
		bool copy = true
	) {
		switch (format) {
		case ImageFormat::SRGB:
		case ImageFormat::SRGBA:
		case ImageFormat::GRAY8:
		case ImageFormat::LAB8:
		case ImageFormat::SBGRA:
			MP_ASSERT_RETURN_IF_ERROR(data.depth() == CV_8U, "uint8 image data should be one of the GRAY8, "
				"SRGB, SRGBA, LAB8 and SBGRA MediaPipe image formats.");
			break;
		case ImageFormat::GRAY16:
		case ImageFormat::SRGB48:
		case ImageFormat::SRGBA64:
			MP_ASSERT_RETURN_IF_ERROR(data.depth() == CV_16U, "uint16 image data should be one of the GRAY16, "
				"SRGB48, and SRGBA64 MediaPipe image formats.");
			break;
		case ImageFormat::VEC32F1:
		case ImageFormat::VEC32F2:
		case ImageFormat::VEC32F4:
			MP_ASSERT_RETURN_IF_ERROR(data.depth() == CV_32F, "float image data should be either VEC32F1, VEC32F2, or "
				"VEC32F4 MediaPipe image formats.");
			break;
		default:
			MP_ASSERT_RETURN_IF_ERROR(false, "Unsupported MediaPipe image format");
		}

		int width = data.cols;
		int height = data.rows;
		int width_step = data.step;

		auto image_frame = std::make_unique<ImageFrame>(
			format, width, height, width_step,
			const_cast<uint8_t*>(data.ptr()),
			ImageFrame::PixelDataDeleter::kNone
		);

		if (copy) {
			auto image_frame_copy = std::make_unique<ImageFrame>();
			// Set alignment_boundary to kGlDefaultAlignmentBoundary so that both
			// GPU and CPU can process it.
			image_frame_copy->CopyFrom(*image_frame, ImageFrame::kGlDefaultAlignmentBoundary);
			return image_frame_copy;
		}

		return image_frame;
	}

	[[nodiscard]] inline absl::StatusOr<std::unique_ptr<ImageFrame>> CreateImageFrame(const cv::Mat& data, bool copy = true) {
		const auto rows = data.rows;
		const auto cols = data.cols;
		const auto channels = data.channels();
		const auto type = data.depth();
		switch (type) {
		case CV_8U:
			switch (channels) {
			case 1:
				return CreateImageFrame(ImageFormat::GRAY8, data, copy);
			case 3:
				return CreateImageFrame(ImageFormat::SRGB, data, copy);
			case 4:
				return CreateImageFrame(ImageFormat::SRGBA, data, copy);
			}
		case CV_16U:
			switch (channels) {
			case 1:
				return CreateImageFrame(ImageFormat::GRAY16, data, copy);
			case 3:
				return CreateImageFrame(ImageFormat::SRGB48, data, copy);
			case 4:
				return CreateImageFrame(ImageFormat::SRGBA64, data, copy);
			}
		case CV_32F:
			switch (channels) {
			case 1:
				return CreateImageFrame(ImageFormat::VEC32F1, data, copy);
			case 2:
				return CreateImageFrame(ImageFormat::VEC32F2, data, copy);
			case 4:
				return CreateImageFrame(ImageFormat::VEC32F4, data, copy);
			}
		}

		MP_ASSERT_RETURN_IF_ERROR(false, "Unsupported image format. Supported formats are "
			"CV_8U, CV_8UC3, CV_8UC4, CV_16U, CV_16UC3, CV_16UC4, CV_32F, CV_32FC2, CV_32FC4");
	}

	[[nodiscard]] inline absl::StatusOr<std::unique_ptr<ImageFrame>> CreateImageFrame(const std::string& file_name) {
		unsigned char* image_data = nullptr;
		int width;
		int height;
		int channels;

#if TARGET_OS_OSX && !MEDIAPIPE_DISABLE_GPU
		// Our ObjC layer does not support 3-channel images, so we read the
		// number of channels first and request RGBA if needed.
		if (stbi_info(file_name.c_str(), &width, &height, &channels)) {
			if (channels == 3) {
				channels = 4;
			}
			int unused;
			image_data =
				stbi_load(file_name.c_str(), &width, &height, &unused, channels);
		}
#else
		image_data = stbi_load(file_name.c_str(), &width, &height, &channels,
			/*desired_channels=*/0);
#endif  // TARGET_OS_OSX && !MEDIAPIPE_DISABLE_GPU

		MP_ASSERT_RETURN_IF_ERROR(image_data != nullptr, "Image decoding failed (" << stbi_failure_reason() << "): " << file_name);

		std::unique_ptr<ImageFrame> image_frame;
		switch (channels) {
		case 1:
			image_frame = std::make_unique<ImageFrame>(
				ImageFormat::GRAY8, width, height, width, image_data,
				stbi_image_free);
			break;
#if !TARGET_OS_OSX || MEDIAPIPE_DISABLE_GPU
		case 3:
			image_frame = std::make_unique<ImageFrame>(
				ImageFormat::SRGB, width, height, 3 * width, image_data,
				stbi_image_free);
			break;
#endif  // !TARGET_OS_OSX || MEDIAPIPE_DISABLE_GPU
		case 4:
			image_frame = std::make_unique<ImageFrame>(
				ImageFormat::SRGBA, width, height, 4 * width, image_data,
				stbi_image_free);
			break;
		default:
			MP_ASSERT_RETURN_IF_ERROR(false,
				"Expected image with 1 (grayscale), 3 (RGB) or 4 "
				"(RGBA) channels, found " << channels << " channels.");
		}

		return image_frame;
	}

	template<typename T>
	inline cv::Mat GenerateContiguousDataArrayHelper(const ImageFrame& image_frame, cv::Mat& img) {
		cv::Mat contiguous_data = formats::MatView(&image_frame);

		if (!image_frame.IsContiguous()) {
			int rows = image_frame.Height();
			int cols = image_frame.Width();
			int type = CV_MAKETYPE(cv::DataType<T>::depth, image_frame.NumberOfChannels());
			cv::Mat contiguous_data_copy = cv::Mat(rows, cols, type);
			contiguous_data.copyTo(contiguous_data_copy);
			contiguous_data = contiguous_data_copy;
		}

		img = contiguous_data;
		return contiguous_data;
	}

	[[nodiscard]] inline absl::StatusOr<cv::Mat> GenerateContiguousDataArray(const ImageFrame& image_frame, cv::Mat& img) {
		switch (image_frame.ChannelSize()) {
			case sizeof(uint8_t) :
				return GenerateContiguousDataArrayHelper<uint8_t>(image_frame, img);
			case sizeof(uint16_t) :
				return GenerateContiguousDataArrayHelper<uint16_t>(image_frame, img);
			case sizeof(float) :
				return GenerateContiguousDataArrayHelper<float>(image_frame, img);
			default:
				MP_ASSERT_RETURN_IF_ERROR(false, "Unsupported image frame channel size. Data is not "
					"uint8, uint16, or float?");
		}
	}

	// Generates a contiguous data pyarray object on demand.
	// This function only accepts an image frame object that already stores
	// contiguous data. The output cv::Mat points to the raw pixel data array of
	// the image frame object directly.
	[[nodiscard]] inline absl::StatusOr<cv::Mat> GenerateMatOnDemand(const ImageFrame& image_frame, cv::Mat& img) {
		MP_ASSERT_RETURN_IF_ERROR(image_frame.IsContiguous(),
			"GenerateMatOnDemand must take an ImageFrame "
			"object that stores contiguous data.");
		return GenerateContiguousDataArray(image_frame, img);
	}

	// Gets the cached contiguous data array from the "__contiguous_data" attribute.
	// If the attribute doesn't exist, the function calls
	// GenerateContiguousDataArray() to generate the contiguous cv::Mat,
	// which realigns and copies the data from the original image frame object.
	// Then, the cv::Mat is cached in the "__contiguous_data" attribute.
	// This function only accepts an image frame object that stores non-contiguous
	// data.
	[[nodiscard]] inline absl::StatusOr<cv::Mat> GetCachedContiguousDataAttr(const ImageFrame& image_frame, cv::Mat& img) {
		MP_ASSERT_RETURN_IF_ERROR(!image_frame.IsContiguous(), "GetCachedContiguousDataAttr must take an ImageFrame "
			"object that stores non-contiguous data.");

		MP_ASSERT_RETURN_IF_ERROR(!image_frame.IsEmpty(), "ImageFrame is unallocated.");

		return GenerateContiguousDataArray(image_frame, img);
	}

	template<typename... Args>
	[[nodiscard]] inline absl::StatusOr<std::shared_ptr<Image>> CreateSharedImage(Args&&... args) {
		MP_ASSIGN_OR_RETURN(auto unique_ptr, CreateImageFrame(std::forward<Args>(args)...));
		return std::make_shared<Image>(std::shared_ptr<ImageFrame>(unique_ptr.release()));
	}

	template<typename... Args>
	[[nodiscard]] inline absl::StatusOr<std::shared_ptr<ImageFrame>> CreateSharedImageFrame(Args&&... args) {
		MP_ASSIGN_OR_RETURN(auto unique_ptr, CreateImageFrame(std::forward<Args>(args)...));
		return std::shared_ptr<ImageFrame>(unique_ptr.release());
	}
}
