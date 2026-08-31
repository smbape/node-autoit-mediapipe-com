#include "binding/tasks/vision/core/image_frame.h"
#include "mediapipe/framework/deps/file_helpers.h"
#include "exif.h"
#include "stb_image.h"

#include "mediapipe/framework/type_map.h"
MEDIAPIPE_REGISTER_TYPE(mediapipe::ImageFrame, "::mediapipe::ImageFrame", nullptr, nullptr);

namespace {
	using ::mediapipe::Image;
	using ::mediapipe::ImageFormat;
	using ::mediapipe::ImageFrame;

	std::string GetImageFormatFormatName(ImageFormat::Format format) {
		switch (format) {
		case ImageFormat::UNKNOWN:
			return "UNKNOWN";
		case ImageFormat::SRGB:
			return "SRGB";
		case ImageFormat::SRGBA:
			return "SRGBA";
		case ImageFormat::GRAY8:
			return "GRAY8";
		case ImageFormat::GRAY16:
			return "GRAY16";
		case ImageFormat::YCBCR420P:
			return "YCBCR420P";
		case ImageFormat::YCBCR420P10:
			return "YCBCR420P10";
		case ImageFormat::SRGB48:
			return "SRGB48";
		case ImageFormat::SRGBA64:
			return "SRGBA64";
		case ImageFormat::VEC32F1:
			return "VEC32F1";
		case ImageFormat::VEC32F2:
			return "VEC32F2";
		case ImageFormat::VEC32F4:
			return "VEC32F4";
		case ImageFormat::LAB8:
			return "LAB8";
		case ImageFormat::SBGRA:
			return "SBGRA";
		}
	}

	// EXIF orientation values (1-8)
	constexpr uint16_t kExifOrientationNormal = 1;
	constexpr uint16_t kExifOrientationMirrorHorizontal = 2;
	constexpr uint16_t kExifOrientationRotate180 = 3;
	constexpr uint16_t kExifOrientationMirrorVertical = 4;
	constexpr uint16_t kExifOrientationMirrorHorizontalRotate270CW = 5;
	constexpr uint16_t kExifOrientationRotate90CW = 6;
	constexpr uint16_t kExifOrientationMirrorHorizontalRotate90CW = 7;
	constexpr uint16_t kExifOrientationRotate270CW = 8;

	[[nodiscard]] absl::StatusOr<ImageFormat::Format> GetImageFormatFromChannels(int channels) {
		switch (channels) {
		case 1:
			return ImageFormat::GRAY8;
		case 3:
			return ImageFormat::SRGB;
		case 4:
			return ImageFormat::SRGBA;
		default:
			return absl::InvalidArgumentError(absl::StrFormat(
				"Expected image with 1 (grayscale), 3 (RGB) or 4 (RGBA) channels, "
				"found %d channels.",
				channels));
		}
	}

	// Applies EXIF orientation to the loaded image bytes directly writing to a
	// Creates an ImageFrame from loaded pixel data, applying EXIF orientation.
	// If orientation <= 1, wraps the loaded stbi pixel data zero-copy and uses
	// stbi_image_free deleter. If orientation > 1, creates a new aligned
	// ImageFrame, rotates the pixels from the loaded data, and frees the original
	// loaded data.
	std::shared_ptr<ImageFrame> CreateImageFrameWithOrientation(
		unsigned char* image_data, int width, int height, int channels,
		ImageFormat::Format format, uint16_t orientation) {
		if (orientation <= kExifOrientationNormal ||
			orientation > kExifOrientationRotate270CW) {
			return std::make_shared<ImageFrame>(format, width, height, channels * width,
				image_data, stbi_image_free);
		}

		int dest_width = width;
		int dest_height = height;
		if (orientation >= kExifOrientationMirrorHorizontalRotate270CW &&
			orientation <= kExifOrientationRotate270CW) {
			dest_width = height;
			dest_height = width;
		}

		auto image = std::make_shared<ImageFrame>(
			format, dest_width, dest_height, ImageFrame::kDefaultAlignmentBoundary);

		unsigned char* dest_data = image->MutablePixelData();
		int dest_width_step = image->WidthStep();

		// Helper lambda to abstract pixel copying with width step / row stride
		auto copy_pixel = [&](int dest_x, int dest_y, int src_x, int src_y) {
			std::memcpy(&dest_data[dest_y * dest_width_step + dest_x * channels],
				&image_data[(src_y * width + src_x) * channels], channels);
			};

		switch (orientation) {
		case kExifOrientationMirrorHorizontal:
			for (int y = 0; y < dest_height; ++y) {
				for (int x = 0; x < dest_width; ++x) {
					copy_pixel(x, y, width - 1 - x, y);
				}
			}
			break;
		case kExifOrientationRotate180:
			for (int y = 0; y < dest_height; ++y) {
				for (int x = 0; x < dest_width; ++x) {
					copy_pixel(x, y, width - 1 - x, height - 1 - y);
				}
			}
			break;
		case kExifOrientationMirrorVertical:
			for (int y = 0; y < dest_height; ++y) {
				std::memcpy(&dest_data[y * dest_width_step],
					&image_data[(height - 1 - y) * width * channels],
					dest_width * channels);
			}
			break;
		case kExifOrientationMirrorHorizontalRotate270CW:
			for (int y = 0; y < dest_height; ++y) {
				for (int x = 0; x < dest_width; ++x) {
					copy_pixel(x, y, y, x);
				}
			}
			break;
		case kExifOrientationRotate90CW:
			for (int y = 0; y < dest_height; ++y) {
				for (int x = 0; x < dest_width; ++x) {
					copy_pixel(x, y, y, height - 1 - x);
				}
			}
			break;
		case kExifOrientationMirrorHorizontalRotate90CW:
			for (int y = 0; y < dest_height; ++y) {
				for (int x = 0; x < dest_width; ++x) {
					copy_pixel(x, y, width - 1 - y, height - 1 - x);
				}
			}
			break;
		case kExifOrientationRotate270CW:
			for (int y = 0; y < dest_height; ++y) {
				for (int x = 0; x < dest_width; ++x) {
					copy_pixel(x, y, width - 1 - y, x);
				}
			}
			break;
		default:
			break;
		}

		stbi_image_free(image_data);
		return image;
	}
}

namespace mediapipe::autoit {
	absl::StatusOr<std::shared_ptr<ImageFrame>> CreateImageFrame(
		ImageFormat::Format format,
		const cv::Mat& data,
		bool copy
	) {
		switch (format) {
		case ImageFormat::UNKNOWN:
			// Invalid; Default to uchar.
			MP_ASSERT_RETURN_IF_ERROR(data.depth() == CV_8U, "ImageFormat::Format " << GetImageFormatFormatName(format) << " can only match to OpenCV Mat CV_8U depth.");
			break;
		case ImageFormat::GRAY8:
		case ImageFormat::LAB8:
		case ImageFormat::SRGB:
		case ImageFormat::SRGBA:
		case ImageFormat::SBGRA:
			MP_ASSERT_RETURN_IF_ERROR(data.depth() == CV_8U, "ImageFormat::Format " << GetImageFormatFormatName(format) << " can only match to OpenCV Mat CV_8U depth.");
			break;
		case ImageFormat::GRAY16:
		case ImageFormat::SRGB48:
		case ImageFormat::SRGBA64:
			MP_ASSERT_RETURN_IF_ERROR(data.depth() == CV_16U, "ImageFormat::Format " << GetImageFormatFormatName(format) << " can only match to OpenCV Mat CV_16U depth.");
			break;
		case ImageFormat::VEC32F1:
		case ImageFormat::VEC32F2:
		case ImageFormat::VEC32F4:
			MP_ASSERT_RETURN_IF_ERROR(data.depth() == CV_32F, "ImageFormat::Format " << GetImageFormatFormatName(format) << " can only match to OpenCV Mat CV_32F depth.");
			break;
		case mediapipe::ImageFormat::YCBCR420P:
			// Invalid; Default to uchar.
			MP_ASSERT_RETURN_IF_ERROR(data.depth() == CV_8U, "ImageFormat::Format " << GetImageFormatFormatName(format) << " can only match to OpenCV Mat CV_8U depth.");
			break;
		case mediapipe::ImageFormat::YCBCR420P10:
			// Invalid; Default to uint16.
			MP_ASSERT_RETURN_IF_ERROR(data.depth() == CV_16U, "ImageFormat::Format " << GetImageFormatFormatName(format) << " can only match to OpenCV Mat CV_16U depth.");
			break;
		default:
			// Invalid or unknown; Default to uchar.
			MP_ASSERT_RETURN_IF_ERROR(data.depth() == CV_8U, "ImageFormat::Format " << GetImageFormatFormatName(format) << " can only match to OpenCV Mat CV_8U depth.");
		}

		int width = data.cols;
		int height = data.rows;
		int width_step = data.step;

		auto image_frame = std::make_shared<ImageFrame>(
			format, width, height, width_step,
			const_cast<uint8_t*>(data.ptr()),
			ImageFrame::PixelDataDeleter::kNone
		);

		if (copy) {
			auto image_frame_copy = std::make_shared<ImageFrame>();
			// Set alignment_boundary to kGlDefaultAlignmentBoundary so that both
			// GPU and CPU can process it.
			image_frame_copy->CopyFrom(*image_frame, ImageFrame::kGlDefaultAlignmentBoundary);
			return image_frame_copy;
		}

		return image_frame;
	}

	absl::StatusOr<std::shared_ptr<ImageFrame>> CreateImageFrame(const cv::Mat& data, bool copy) {
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

	absl::StatusOr<std::shared_ptr<ImageFrame>> CreateImageFrame(const std::string& file_name) {
		if (file_name.empty()) {
			return absl::InvalidArgumentError("File name is empty");
		}

		std::string file_contents;
		absl::Status file_status = ::mediapipe::file::GetContents(
			file_name, &file_contents, /*read_as_binary=*/true);
		if (!file_status.ok()) {
			return file_status;
		}

		uint16_t orientation = 1;
		easyexif::EXIFInfo exif_info;
		if (exif_info.parseFrom(
			reinterpret_cast<const unsigned char*>(file_contents.data()),
			file_contents.size()) == 0) {
			orientation = exif_info.Orientation;
		}

		unsigned char* image_data = nullptr;
		int width = 0;
		int height = 0;
		int channels = 0;

#if TARGET_OS_OSX && !MEDIAPIPE_DISABLE_GPU
		// On MacOS, stbi_load does not support 3-channel images, so we read the
		// number of channels first and request RGBA if needed.
		if (stbi_info_from_memory(
			reinterpret_cast<const unsigned char*>(file_contents.data()),
			file_contents.size(), &width, &height, &channels)) {
			if (channels == 3) {
				channels = 4;
			}
			int unused;
			image_data = stbi_load_from_memory(
				reinterpret_cast<const unsigned char*>(file_contents.data()),
				file_contents.size(), &width, &height, &unused, channels);
		}
#else
		image_data = stbi_load_from_memory(
			reinterpret_cast<const unsigned char*>(file_contents.data()),
			file_contents.size(), &width, &height, &channels,
			/*desired_channels=*/0);
#endif  // TARGET_OS_OSX && !MEDIAPIPE_DISABLE_GPU

		MP_ASSERT_RETURN_IF_ERROR(image_data != nullptr, "Image decoding failed (" << stbi_failure_reason() << "): " << file_name);

		auto format = GetImageFormatFromChannels(channels);
		if (!format.ok()) {
			return format.status();
		}

		return CreateImageFrameWithOrientation(image_data, width, height,
			channels, *format, orientation);
	}
}
