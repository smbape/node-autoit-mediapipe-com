#pragma once

#include "absl/memory/memory.h"
#include "mediapipe/framework/formats/image_format.pb.h"
#include "mediapipe/framework/formats/image_frame.h"
#include "mediapipe/framework/formats/image_frame_opencv.h"
#include "mediapipe/framework/port/logging.h"
#include "binding/util.h"
#include <opencv2/imgcodecs.hpp>

namespace mediapipe {
	namespace autoit {
		inline std::unique_ptr<ImageFrame> CreateImageFrame(
			ImageFormat::Format format,
			const cv::Mat& data, bool copy = true
		) {
			switch (format) {
				case ImageFormat::SRGB:
				case ImageFormat::SRGBA:
				case ImageFormat::GRAY8:
				case ImageFormat::LAB8:
				case ImageFormat::SBGRA:
					AUTOIT_ASSERT_THROW(data.depth() == CV_8U, "uint8 image data should be one of the GRAY8, "
						"SRGB, SRGBA, LAB8 and SBGRA MediaPipe image formats.");
					break;
				case ImageFormat::GRAY16:
				case ImageFormat::SRGB48:
				case ImageFormat::SRGBA64:
					AUTOIT_ASSERT_THROW(data.depth() == CV_16U, "uint16 image data should be one of the GRAY16, "
						"SRGB48, and SRGBA64 MediaPipe image formats.");
					break;
				case ImageFormat::VEC32F1:
				case ImageFormat::VEC32F2:
					AUTOIT_ASSERT_THROW(data.depth() == CV_32F, "float image data should be either VEC32F1 or VEC32F2 "
						"MediaPipe image formats.");
					break;
				default:
					AUTOIT_THROW("Unsupported MediaPipe image format");
					break;
			}

			int rows = data.rows;
			int cols = data.cols;
			int channels = ImageFrame::NumberOfChannelsForFormat(format);
			int depth = ImageFrame::ByteDepthForFormat(format);
			size_t width_step = data.step;

			auto image_frame = std::make_unique<ImageFrame>(
				format, /*width=*/cols, /*height=*/rows, width_step,
				const_cast<uint8*>(data.ptr()),
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

		inline std::unique_ptr<ImageFrame> CreateImageFrame(const cv::Mat& data, bool copy = true) {
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
				}
			}

			AUTOIT_THROW("Unsupported image format. Supported formats are "
				"CV_8U, CV_8UC3, CV_8UC4, CV_16U, CV_16UC3, CV_16UC4, CV_32F, CV_32FC2");
		}

		template <typename T>
		cv::Mat GenerateContiguousDataArrayHelper(const ImageFrame& image_frame, cv::Mat& img) {
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

		inline cv::Mat GenerateContiguousDataArray(const ImageFrame& image_frame, cv::Mat& img) {
			switch (image_frame.ChannelSize()) {
				case sizeof(uint8) :
					return GenerateContiguousDataArrayHelper<uint8>(image_frame, img);
				case sizeof(uint16) :
					return GenerateContiguousDataArrayHelper<uint16>(image_frame, img);
				case sizeof(float) :
					return GenerateContiguousDataArrayHelper<float>(image_frame, img);
				default:
					AUTOIT_THROW("Unsupported image frame channel size. Data is not "
						"uint8, uint16, or float?");
			}
		}

		// Generates a contiguous data pyarray object on demand.
		// This function only accepts an image frame object that already stores
		// contiguous data. The output cv::Mat points to the raw pixel data array of
		// the image frame object directly.
		inline cv::Mat GenerateMatOnDemand(const ImageFrame& image_frame, cv::Mat& img) {
			AUTOIT_ASSERT_THROW(image_frame.IsContiguous(),
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
		inline cv::Mat GetCachedContiguousDataAttr(const ImageFrame& image_frame, cv::Mat& img) {
			AUTOIT_ASSERT_THROW(!image_frame.IsContiguous(), "GetCachedContiguousDataAttr must take an ImageFrame "
				"object that stores non-contiguous data.");

			AUTOIT_ASSERT_THROW(!image_frame.IsEmpty(), "ImageFrame is unallocated.");

			return GenerateContiguousDataArray(image_frame, img);
		}
	}
}
