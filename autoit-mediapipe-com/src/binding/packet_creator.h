#pragma once

#include "absl/memory/memory.h"
#include "google/protobuf/message.h"
#include "mediapipe/framework/formats/image.h"
#include "mediapipe/framework/formats/matrix.h"
#include "mediapipe/framework/packet.h"
#include "mediapipe/framework/port/integral_types.h"
#include "mediapipe/framework/timestamp.h"
#include "binding/image_frame.h"

namespace mediapipe {
	namespace autoit {
		namespace packet_creator {
			CV_WRAP const std::shared_ptr<Packet> create_int(int64 data);
			CV_WRAP const std::shared_ptr<Packet> create_int8(int64 data);
			CV_WRAP const std::shared_ptr<Packet> create_int16(int64 data);
			CV_WRAP const std::shared_ptr<Packet> create_int32(int64 data);
			CV_WRAP const std::shared_ptr<Packet> create_uint8(int64 data);
			CV_WRAP const std::shared_ptr<Packet> create_uint16(int64 data);
			CV_WRAP const std::shared_ptr<Packet> create_uint32(int64 data);
			CV_WRAP const std::shared_ptr<Packet> create_int_array(const std::vector<int>& data);
			CV_WRAP const std::shared_ptr<Packet> create_float_array(const std::vector<float>& data);
			CV_WRAP const std::shared_ptr<Packet> create_image_frame(const ImageFrame& data, bool copy);
			CV_WRAP const std::shared_ptr<Packet> create_image_frame(const ImageFrame& data, ImageFormat::Format format, bool copy);
			CV_WRAP const std::shared_ptr<Packet> create_image_frame(const cv::Mat& data, bool copy);
			CV_WRAP const std::shared_ptr<Packet> create_image_frame(const cv::Mat& data, ImageFormat::Format format, bool copy);
			CV_WRAP const std::shared_ptr<Packet> create_image(const Image& data, bool copy);
			CV_WRAP const std::shared_ptr<Packet> create_image(const Image& image, ImageFormat::Format format, bool copy);
			CV_WRAP const std::shared_ptr<Packet> create_image(const cv::Mat& data, bool copy);
			CV_WRAP const std::shared_ptr<Packet> create_image(const cv::Mat& data, ImageFormat::Format format, bool copy);
			CV_WRAP const std::shared_ptr<Packet> create_proto(const google::protobuf::Message& proto_message);
		}
	}
}
