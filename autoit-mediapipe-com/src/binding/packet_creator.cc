#include "Mediapipe_Autoit_Packet_creator_Object.h"
#include <opencv2/core/eigen.hpp>

namespace {
	using namespace mediapipe::autoit;
	using namespace mediapipe;

	inline std::shared_ptr<Packet> CreateImageFramePacket(std::unique_ptr<ImageFrame>& image_frame) {
		const auto& packet = Adopt(image_frame.release());
		return std::make_shared<Packet>(std::move(packet));
	}

	inline std::shared_ptr<Packet> CreateImagePacket(std::unique_ptr<ImageFrame>& image_frame) {
		std::shared_ptr<ImageFrame> shared_image_frame = std::move(image_frame);
		const auto& packet = MakePacket<Image>(shared_image_frame);
		return std::make_shared<Packet>(std::move(packet));
	}

	inline void RaiseAutoItErrorIfOverflow(int64_t value, int64_t min, int64_t max) {
		if (value > max) {
			AUTOIT_THROW(value << " execeeds the maximum value (" << max << ") the data type can have.");
		}
		else if (value < min) {
			AUTOIT_THROW(value << " goes below the minimum value (" << min << ") the data type can have.");
		}
	}
}

namespace mediapipe::autoit::packet_creator {
	std::shared_ptr<Packet> create_int(int64_t data) {
		RaiseAutoItErrorIfOverflow(data, INT_MIN, INT_MAX);
		const auto& packet = MakePacket<int>(data);
		return std::make_shared<Packet>(std::move(packet));
	}

	std::shared_ptr<Packet> create_int8(int64_t data) {
		RaiseAutoItErrorIfOverflow(data, INT8_MIN, INT8_MAX);
		const auto& packet = MakePacket<int8_t>(data);
		return std::make_shared<Packet>(std::move(packet));
	}

	std::shared_ptr<Packet> create_int16(int64_t data) {
		RaiseAutoItErrorIfOverflow(data, INT16_MIN, INT16_MAX);
		const auto& packet = MakePacket<int16_t>(data);
		return std::make_shared<Packet>(std::move(packet));
	}

	std::shared_ptr<Packet> create_int32(int64_t data) {
		RaiseAutoItErrorIfOverflow(data, INT32_MIN, INT32_MAX);
		const auto& packet = MakePacket<int32_t>(data);
		return std::make_shared<Packet>(std::move(packet));
	}

	std::shared_ptr<Packet> create_uint8(int64_t data) {
		RaiseAutoItErrorIfOverflow(data, 0, UINT8_MAX);
		const auto& packet = MakePacket<uint8_t>(data);
		return std::make_shared<Packet>(std::move(packet));
	}

	std::shared_ptr<Packet> create_uint16(int64_t data) {
		RaiseAutoItErrorIfOverflow(data, 0, UINT16_MAX);
		const auto& packet = MakePacket<uint16_t>(data);
		return std::make_shared<Packet>(std::move(packet));
	}

	std::shared_ptr<Packet> create_uint32(int64_t data) {
		RaiseAutoItErrorIfOverflow(data, 0, UINT32_MAX);
		const auto& packet = MakePacket<uint32_t>(data);
		return std::make_shared<Packet>(std::move(packet));
	}

	std::shared_ptr<Packet> create_int_array(const std::vector<int>& data) {
		int* ints = new int[data.size()];
		std::copy(data.begin(), data.end(), ints);
		const auto& packet = Adopt(reinterpret_cast<int(*)[]>(ints));
		return std::make_shared<Packet>(std::move(packet));
	}

	std::shared_ptr<Packet> create_float_array(const std::vector<float>& data) {
		float* floats = new float[data.size()];
		std::copy(data.begin(), data.end(), floats);
		const auto& packet = Adopt(reinterpret_cast<float(*)[]>(floats));
		return std::make_shared<Packet>(std::move(packet));
	}

	std::shared_ptr<Packet> create_image_frame(const ImageFrame& data, bool copy) {
		return create_image_frame(data, data.Format(), copy);
	}

	std::shared_ptr<Packet> create_image_frame(const ImageFrame& data, ImageFormat::Format image_format, bool copy) {
		AUTOIT_ASSERT_THROW(data.Format() == image_format, "The provided image_format doesn't match the one from the data arg.");
		AUTOIT_ASSERT_THROW(copy, "Creating ImageFrame packet by taking a reference of another ImageFrame object is not supported yet.");

		auto image_frame = absl::make_unique<ImageFrame>();
		// Set alignment_boundary to kGlDefaultAlignmentBoundary so that
		// both GPU and CPU can process it.
		image_frame->CopyFrom(data, ImageFrame::kGlDefaultAlignmentBoundary);
		return CreateImageFramePacket(image_frame);
	}

	std::shared_ptr<Packet> create_image_frame(const cv::Mat& data, bool copy) {
		MP_ASSIGN_OR_THROW(auto image_frame, CreateImageFrame(data, copy));
		return CreateImageFramePacket(image_frame);
	}

	std::shared_ptr<Packet> create_image_frame(const cv::Mat& data, ImageFormat::Format image_format, bool copy) {
		MP_ASSIGN_OR_THROW(auto image_frame, CreateImageFrame(image_format, data, copy));
		return CreateImageFramePacket(image_frame);
	}

	std::shared_ptr<Packet> create_image(const Image& data, bool copy) {
		return create_image(data, data.image_format(), copy);
	}

	std::shared_ptr<Packet> create_image(const Image& image, ImageFormat::Format image_format, bool copy) {
		AUTOIT_ASSERT_THROW(image.image_format() == image_format, "The provided image_format doesn't match the one from the data arg.");
		AUTOIT_ASSERT_THROW(copy, "Creating Image packet by taking a reference of another Image object is not supported yet.");

		auto image_frame = absl::make_unique<ImageFrame>();
		// Set alignment_boundary to kGlDefaultAlignmentBoundary so that
		// both GPU and CPU can process it.
		image_frame->CopyFrom(*image.GetImageFrameSharedPtr(), ImageFrame::kGlDefaultAlignmentBoundary);
		return CreateImagePacket(image_frame);
	}

	std::shared_ptr<Packet> create_image(const cv::Mat& data, bool copy) {
		if (!copy) {
			AUTOIT_WARN("'data' is still writeable. Taking a reference of the data to create Image packet is dangerous.");
		}
		MP_ASSIGN_OR_THROW(auto image_frame, CreateImageFrame(data, copy));
		return CreateImagePacket(image_frame);
	}

	std::shared_ptr<Packet> create_image(const cv::Mat& data, ImageFormat::Format image_format, bool copy) {
		if (!copy) {
			AUTOIT_WARN("'data' is still writeable. Taking a reference of the data to create Image packet is dangerous.");
		}
		MP_ASSIGN_OR_THROW(auto image_frame, CreateImageFrame(image_format, data, copy));
		return CreateImagePacket(image_frame);
	}

	std::shared_ptr<Packet> create_matrix(const cv::Mat& data, bool transpose) {
		AUTOIT_ASSERT_THROW(data.type() == CV_32F, "The data should be a float matrix");
		AUTOIT_ASSERT_THROW(data.dims <= 2, "The data is expected to have at most 2 dimensions");
		AUTOIT_ASSERT_THROW(data.cols == 1 || data.channels() == 1, "The data is expected be a Nx1 matrix");

		// Eigen Map class
		// (https://eigen.tuxfamily.org/dox/group__TutorialMapClass.html) is the
		// way to reuse the external memory as an Eigen type. However, when
		// creating an Eigen::MatrixXf from an Eigen Map object, the data copy
		// still happens. We can  make a packet of an Eigen Map type for reusing
		// external memory. However,the packet data type is no longer
		// Eigen::MatrixXf.
		// https://stackoverflow.com/questions/54971083/how-to-use-cvmat-and-eigenmatrix-correctly-opencv-eigen/54975764#54975764
		// https://stackoverflow.com/questions/14783329/opencv-cvmat-and-eigenmatrix/14874440#14874440
		Eigen::MatrixXf matrix;
		cv::cv2eigen(data.reshape(1), matrix);
		return std::make_shared<Packet>(std::move(MakePacket<Matrix>(transpose ? matrix.transpose() : matrix)));
	}

	std::shared_ptr<Packet> create_proto(const google::protobuf::Message& message) {
		auto type_name = message.GetDescriptor()->full_name();

		std::string serialized;
		AUTOIT_ASSERT_THROW(message.SerializeToString(&serialized), "Failed to serialize message " << type_name);

		absl::StatusOr<Packet> packet = packet_internal::PacketFromDynamicProto(type_name, serialized);
		AUTOIT_ASSERT_THROW(packet.ok(), "Unregistered proto message type: " << type_name);

		return std::make_shared<Packet>(std::move(std::move(packet).value()));
	}

	std::shared_ptr<Packet> create_image_frame_vector(const std::vector<std::shared_ptr<ImageFrame>>& image_frame_list) {
		std::vector<ImageFrame> image_frame_vector;
		image_frame_vector.reserve(image_frame_list.size());

		for (const auto& image_frame : image_frame_list) {
			ImageFrame image_frame_copy;
			image_frame_copy.CopyFrom(*image_frame,
							  // Use kGlDefaultAlignmentBoundary so that both
							  // GPU and CPU can process it.
							  ImageFrame::kGlDefaultAlignmentBoundary);
			image_frame_vector.push_back(std::move(image_frame_copy));
		}

		const auto& packet = MakePacket<std::vector<ImageFrame>>(std::move(image_frame_vector));
		return std::make_shared<Packet>(std::move(packet));
	}
}
