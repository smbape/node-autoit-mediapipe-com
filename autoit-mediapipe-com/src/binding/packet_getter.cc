#include "Mediapipe_Autoit_Packet_getter_Object.h"

using namespace mediapipe;
using namespace proto_ns;

// RegisteredTypeName()

const int64 mediapipe::autoit::packet_getter::get_int(const Packet& packet) {
	if (packet.ValidateAsType<int>().ok()) {
		return static_cast<int64>(packet.Get<int>());
	}

	if (packet.ValidateAsType<int8>().ok()) {
		return static_cast<int64>(packet.Get<int8>());
	}

	if (packet.ValidateAsType<int16>().ok()) {
		return static_cast<int64>(packet.Get<int16>());
	}

	if (packet.ValidateAsType<int32>().ok()) {
		return static_cast<int64>(packet.Get<int32>());
	}

	if (packet.ValidateAsType<int64>().ok()) {
		return static_cast<int64>(packet.Get<int64>());
	}

	AUTOIT_THROW("Packet doesn't contain int, int8, int16, int32, or int64 data.");
}

const uint64 mediapipe::autoit::packet_getter::get_uint(const Packet& packet) {
	if (packet.ValidateAsType<uint8>().ok()) {
		return static_cast<std::uint64_t>(packet.Get<uint8>());
	}

	if (packet.ValidateAsType<uint16>().ok()) {
		return static_cast<std::uint64_t>(packet.Get<uint16>());
	}

	if (packet.ValidateAsType<uint32>().ok()) {
		return static_cast<std::uint64_t>(packet.Get<uint32>());
	}

	if (packet.ValidateAsType<uint64>().ok()) {
		return static_cast<std::uint64_t>(packet.Get<uint64>());
	}

	AUTOIT_THROW("Packet doesn't contain uint8, uint16, uint32, or uint64 data.");
}

const float mediapipe::autoit::packet_getter::get_float(const Packet& packet) {
	if (packet.ValidateAsType<float>().ok()) {
		return packet.Get<float>();
	}

	if (packet.ValidateAsType<double>().ok()) {
		return static_cast<float>(packet.Get<double>());
	}

	AUTOIT_THROW("Packet doesn't contain float or double data.");
}

const std::vector<int64> mediapipe::autoit::packet_getter::get_int_list(const Packet& packet) {
	if (packet.ValidateAsType<std::vector<int>>().ok()) {
		auto int_list = packet.Get<std::vector<int>>();
		return std::vector<int64>(int_list.begin(), int_list.end());
	}

	if (packet.ValidateAsType<std::vector<int8>>().ok()) {
		auto int_list = packet.Get<std::vector<int8>>();
		return std::vector<int64>(int_list.begin(), int_list.end());
	}

	if (packet.ValidateAsType<std::vector<int16>>().ok()) {
		auto int_list = packet.Get<std::vector<int16>>();
		return std::vector<int64>(int_list.begin(), int_list.end());
	}

	if (packet.ValidateAsType<std::vector<int32>>().ok()) {
		auto int_list = packet.Get<std::vector<int32>>();
		return std::vector<int64>(int_list.begin(), int_list.end());
	}

	if (packet.ValidateAsType<std::vector<int64>>().ok()) {
		auto int_list = packet.Get<std::vector<int64>>();
		return std::vector<int64>(int_list.begin(), int_list.end());
	}
	
	AUTOIT_THROW("Packet doesn't contain int, int8, int16, int32, or int64 containers.");
}

const std::vector<float> mediapipe::autoit::packet_getter::get_float_list(const Packet& packet) {
	if (packet.ValidateAsType<std::vector<float>>().ok()) {
		return packet.Get<std::vector<float>>();
	}

	if (packet.ValidateAsType<std::array<float, 16>>().ok()) {
		auto float_array = packet.Get<std::array<float, 16>>();
		return std::vector<float>(float_array.begin(), float_array.end());
	}

	if (packet.ValidateAsType<std::array<float, 4>>().ok()) {
		auto float_array = packet.Get<std::array<float, 4>>();
		return std::vector<float>(float_array.begin(), float_array.end());
	}

	AUTOIT_THROW("Packet doesn't contain std::vector<float> or std::array<float, 4 / 16> containers.");
}

std::shared_ptr<Message> mediapipe::autoit::packet_getter::MessageFromDynamicProto(const std::string& type_name, const std::string& serialized) {
	using namespace packet_internal;

	absl::StatusOr<std::unique_ptr<HolderBase>> maybe_holder =
		MessageHolderRegistry::CreateByName(type_name);

	RaiseAutoItErrorIfNotOk(maybe_holder.status());

	std::unique_ptr<HolderBase> holder_ = std::move(maybe_holder).value();
	absl::StatusOr<std::unique_ptr<Message>> release_result = static_cast<Holder<Message>*>(holder_.get())->Release();
	RaiseAutoItErrorIfNotOk(release_result.status());

	std::unique_ptr<Message> new_message = std::move(release_result).value();
	AUTOIT_ASSERT_THROW(new_message->ParseFromString(serialized), "Failed to get proto message from packet " << type_name);

	return std::shared_ptr<Message>(new_message.release());
}

const std::shared_ptr<Message> mediapipe::autoit::packet_getter::get_proto(const Packet& packet) {
	const auto& message = packet.GetProtoMessageLite();
	const std::string& type_name = message.GetTypeName();
	const std::string& serialized = message.SerializeAsString();
	return MessageFromDynamicProto(type_name, serialized);
}

const std::vector<std::shared_ptr<Message>> mediapipe::autoit::packet_getter::get_proto_list(const Packet& packet) {
	absl::StatusOr<std::vector<const MessageLite*>> proto_vector_ = packet.GetVectorOfProtoMessageLitePtrs();
	RaiseAutoItErrorIfNotOk(proto_vector_.status());

	std::vector<const MessageLite*> proto_vector = std::move(proto_vector_).value();
	auto size = proto_vector.size();

	std::vector<std::shared_ptr<Message>> proto_list;

	if (size == 0) {
		return proto_list;
	}

	proto_list.resize(size);
	auto type_name = proto_vector[0]->GetTypeName();

	int i = 0;
	for (const MessageLite* proto : proto_vector) {
		const std::string& serialized = proto->SerializeAsString();
		proto_list[i++] = MessageFromDynamicProto(type_name, serialized);
	}

	return proto_list;
}
