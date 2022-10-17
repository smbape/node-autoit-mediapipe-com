#include "Mediapipe_Autoit_Packet_creator_Object.h"

namespace mediapipe {
	namespace autoit {
		inline std::shared_ptr<Packet> CreateImageFramePacket(std::unique_ptr<ImageFrame>& image_frame) {
			const auto& packet = Adopt(image_frame.release());
			return std::make_shared<Packet>(std::move(packet));
		}

		inline std::shared_ptr<Packet> CreateImagePacket(std::unique_ptr<ImageFrame>& image_frame) {
			std::shared_ptr<ImageFrame> shared_image_frame = std::move(image_frame);
			const auto& packet = MakePacket<Image>(shared_image_frame);
			return std::make_shared<Packet>(std::move(packet));
		}
	}
}

using namespace mediapipe;
using namespace mediapipe::autoit;

const std::shared_ptr<Packet> mediapipe::autoit::packet_creator::create_int(int64 data) {
	RaiseAutoItErrorIfOverflow(data, INT_MIN, INT_MAX);
	const auto& packet = MakePacket<int>(data);
	return std::make_shared<Packet>(std::move(packet));
}

const std::shared_ptr<Packet> mediapipe::autoit::packet_creator::create_int8(int64 data) {
	RaiseAutoItErrorIfOverflow(data, INT8_MIN, INT8_MAX);
	const auto& packet = MakePacket<int8>(data);
	return std::make_shared<Packet>(std::move(packet));
}

const std::shared_ptr<Packet> mediapipe::autoit::packet_creator::create_int16(int64 data) {
	RaiseAutoItErrorIfOverflow(data, INT16_MIN, INT16_MAX);
	const auto& packet = MakePacket<int16>(data);
	return std::make_shared<Packet>(std::move(packet));
}

const std::shared_ptr<Packet> mediapipe::autoit::packet_creator::create_int32(int64 data) {
	RaiseAutoItErrorIfOverflow(data, INT32_MIN, INT32_MAX);
	const auto& packet = MakePacket<int32>(data);
	return std::make_shared<Packet>(std::move(packet));
}

const std::shared_ptr<Packet> mediapipe::autoit::packet_creator::create_uint8(int64 data) {
	RaiseAutoItErrorIfOverflow(data, 0, UINT8_MAX);
	const auto& packet = MakePacket<uint8>(data);
	return std::make_shared<Packet>(std::move(packet));
}

const std::shared_ptr<Packet> mediapipe::autoit::packet_creator::create_uint16(int64 data) {
	RaiseAutoItErrorIfOverflow(data, 0, UINT16_MAX);
	const auto& packet = MakePacket<uint16>(data);
	return std::make_shared<Packet>(std::move(packet));
}

const std::shared_ptr<Packet> mediapipe::autoit::packet_creator::create_uint32(int64 data) {
	RaiseAutoItErrorIfOverflow(data, 0, UINT32_MAX);
	const auto& packet = MakePacket<uint32>(data);
	return std::make_shared<Packet>(std::move(packet));
}

const std::shared_ptr<Packet> mediapipe::autoit::packet_creator::create_int_array(const std::vector<int>& data) {
	int* ints = new int[data.size()];
	std::copy(data.begin(), data.end(), ints);
	const auto& packet = Adopt(reinterpret_cast<int(*)[]>(ints));
	return std::make_shared<Packet>(std::move(packet));
}

const std::shared_ptr<Packet> mediapipe::autoit::packet_creator::create_float_array(const std::vector<float>& data) {
	float* floats = new float[data.size()];
	std::copy(data.begin(), data.end(), floats);
	const auto& packet = Adopt(reinterpret_cast<float(*)[]>(floats));
	return std::make_shared<Packet>(std::move(packet));
}

const std::shared_ptr<Packet> mediapipe::autoit::packet_creator::create_image_frame(const ImageFrame& data, bool copy) {
	return create_image_frame(data, data.Format(), copy);
}

const std::shared_ptr<Packet> mediapipe::autoit::packet_creator::create_image_frame(const ImageFrame& data, ImageFormat::Format format, bool copy) {
	AUTOIT_ASSERT_THROW(data.Format() == format, "The provided image_format doesn't match the one from the data arg.");
	AUTOIT_ASSERT_THROW(copy, "Creating ImageFrame packet by taking a reference of another ImageFrame object is not supported yet.");

	auto image_frame = absl::make_unique<ImageFrame>();
	// Set alignment_boundary to kGlDefaultAlignmentBoundary so that
	// both GPU and CPU can process it.
	image_frame->CopyFrom(data, ImageFrame::kGlDefaultAlignmentBoundary);
	return CreateImageFramePacket(image_frame);
}

const std::shared_ptr<Packet> mediapipe::autoit::packet_creator::create_image_frame(const cv::Mat& data, bool copy) {
	auto image_frame = CreateImageFrame(data, copy);
	return CreateImageFramePacket(image_frame);
}

const std::shared_ptr<Packet> mediapipe::autoit::packet_creator::create_image_frame(const cv::Mat& data, ImageFormat::Format format, bool copy) {
	auto image_frame = CreateImageFrame(format, data, copy);
	return CreateImageFramePacket(image_frame);
}

const std::shared_ptr<Packet> mediapipe::autoit::packet_creator::create_image(const Image& data, bool copy) {
	return create_image(data, data.image_format(), copy);
}

const std::shared_ptr<Packet> mediapipe::autoit::packet_creator::create_image(const Image& image, ImageFormat::Format format, bool copy) {
	AUTOIT_ASSERT_THROW(image.image_format() == format, "The provided image_format doesn't match the one from the data arg.");
	AUTOIT_ASSERT_THROW(copy, "Creating Image packet by taking a reference of another Image object is not supported yet.");

	auto image_frame = absl::make_unique<ImageFrame>();
	// Set alignment_boundary to kGlDefaultAlignmentBoundary so that
	// both GPU and CPU can process it.
	image_frame->CopyFrom(*image.GetImageFrameSharedPtr(), ImageFrame::kGlDefaultAlignmentBoundary);
	return CreateImagePacket(image_frame);
}

const std::shared_ptr<Packet> mediapipe::autoit::packet_creator::create_image(const cv::Mat& data, bool copy) {
	if (!copy) {
		AUTOIT_WARN("'data' is still writeable. Taking a reference of the data to create Image packet is dangerous.");
	}
	auto image_frame = CreateImageFrame(data, copy);
	return CreateImagePacket(image_frame);
}

const std::shared_ptr<Packet> mediapipe::autoit::packet_creator::create_image(const cv::Mat& data, ImageFormat::Format format, bool copy) {
	if (!copy)	 {
		AUTOIT_WARN("'data' is still writeable. Taking a reference of the data to create Image packet is dangerous.");
	}
	auto image_frame = CreateImageFrame(format, data, copy);
	return CreateImagePacket(image_frame);
}

const std::shared_ptr<Packet> mediapipe::autoit::packet_creator::create_proto(const google::protobuf::Message& proto_message) {
	using namespace google::protobuf;
	using packet_internal::HolderBase;

	auto type_name = proto_message.GetDescriptor()->full_name();
	std::string serialized_proto;
	proto_message.SerializeToString(&serialized_proto);

	absl::StatusOr<std::unique_ptr<HolderBase>> maybe_holder =
		packet_internal::MessageHolderRegistry::CreateByName(type_name);

	AUTOIT_ASSERT_THROW(maybe_holder.ok(), "Unregistered proto message type: " << type_name);

	// Creates a Packet with the concrete C++ payload type.
	std::unique_ptr<HolderBase> message_holder = std::move(maybe_holder).value();
	auto* copy = const_cast<proto_ns::MessageLite*>(message_holder->GetProtoMessageLite());
	copy->ParseFromString(serialized_proto);

	return std::make_shared<Packet>(std::move(packet_internal::Create(message_holder.release())));
}
