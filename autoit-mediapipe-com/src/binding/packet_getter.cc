#include "Mediapipe_Autoit_Packet_getter_Object.h"

using namespace mediapipe;
using namespace proto_ns;

// RegisteredTypeName()

namespace mediapipe::autoit::packet_getter {
	const int64_t get_int(const Packet& packet) {
		if (packet.ValidateAsType<int>().ok()) {
			return static_cast<int64_t>(packet.Get<int>());
		}

		if (packet.ValidateAsType<int8_t>().ok()) {
			return static_cast<int64_t>(packet.Get<int8_t>());
		}

		if (packet.ValidateAsType<int16_t>().ok()) {
			return static_cast<int64_t>(packet.Get<int16_t>());
		}

		if (packet.ValidateAsType<int32_t>().ok()) {
			return static_cast<int64_t>(packet.Get<int32_t>());
		}

		if (packet.ValidateAsType<int64_t>().ok()) {
			return static_cast<int64_t>(packet.Get<int64_t>());
		}

		AUTOIT_THROW("Packet doesn't contain int, int8, int16, int32, or int64 data.");
	}

	const uint64_t get_uint(const Packet& packet) {
		if (packet.ValidateAsType<uint8_t>().ok()) {
			return static_cast<std::uint64_t>(packet.Get<uint8_t>());
		}

		if (packet.ValidateAsType<uint16_t>().ok()) {
			return static_cast<std::uint64_t>(packet.Get<uint16_t>());
		}

		if (packet.ValidateAsType<uint32_t>().ok()) {
			return static_cast<std::uint64_t>(packet.Get<uint32_t>());
		}

		if (packet.ValidateAsType<uint64_t>().ok()) {
			return static_cast<std::uint64_t>(packet.Get<uint64_t>());
		}

		AUTOIT_THROW("Packet doesn't contain uint8, uint16, uint32, or uint64 data.");
	}

	const float get_float(const Packet& packet) {
		if (packet.ValidateAsType<float>().ok()) {
			return packet.Get<float>();
		}

		if (packet.ValidateAsType<double>().ok()) {
			return static_cast<float>(packet.Get<double>());
		}

		AUTOIT_THROW("Packet doesn't contain float or double data.");
	}

	const std::vector<int64_t> get_int_list(const Packet& packet) {
		if (packet.ValidateAsType<std::vector<int>>().ok()) {
			auto int_list = packet.Get<std::vector<int>>();
			return std::vector<int64_t>(int_list.begin(), int_list.end());
		}

		if (packet.ValidateAsType<std::vector<int8_t>>().ok()) {
			auto int_list = packet.Get<std::vector<int8_t>>();
			return std::vector<int64_t>(int_list.begin(), int_list.end());
		}

		if (packet.ValidateAsType<std::vector<int16_t>>().ok()) {
			auto int_list = packet.Get<std::vector<int16_t>>();
			return std::vector<int64_t>(int_list.begin(), int_list.end());
		}

		if (packet.ValidateAsType<std::vector<int32_t>>().ok()) {
			auto int_list = packet.Get<std::vector<int32_t>>();
			return std::vector<int64_t>(int_list.begin(), int_list.end());
		}

		if (packet.ValidateAsType<std::vector<int64_t>>().ok()) {
			auto int_list = packet.Get<std::vector<int64_t>>();
			return std::vector<int64_t>(int_list.begin(), int_list.end());
		}

		AUTOIT_THROW("Packet doesn't contain int, int8, int16, int32, or int64 containers.");
	}

	const std::vector<float> get_float_list(const Packet& packet) {
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

	std::shared_ptr<Message> MessageFromDynamicProto(const std::string& type_name, const std::string& serialized) {
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

	const std::shared_ptr<Message> get_proto(const Packet& packet) {
		const auto& message = packet.GetProtoMessageLite();
		const std::string& type_name = message.GetTypeName();
		const std::string& serialized = message.SerializeAsString();
		return MessageFromDynamicProto(type_name, serialized);
	}

	const std::vector<std::shared_ptr<Message>> get_proto_list(const Packet& packet) {
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
}