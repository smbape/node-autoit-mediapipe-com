#pragma once

#include "absl/status/statusor.h"
#include "google/protobuf/message.h"
#include "mediapipe/framework/formats/image.h"
#include "mediapipe/framework/formats/matrix.h"
#include "mediapipe/framework/packet.h"
#include "mediapipe/framework/port/integral_types.h"
#include "mediapipe/framework/timestamp.h"
#include "binding/image_frame.h"

#define MP_PACKET_ASSIGN_OR_RETURN(lhs, T, packet)	\
MP_RETURN_IF_ERROR(packet.ValidateAsType<T>());		\
lhs = packet.Get<T>()

#define MP_PACKET_ASSIGN_OR_THROW(lhs, T, packet)	\
MP_THROW_IF_ERROR(packet.ValidateAsType<T>());		\
lhs = packet.Get<T>()

namespace mediapipe::autoit::packet_getter {
	template<typename T>
	const T& GetContent(const Packet& packet) {
		MP_THROW_IF_ERROR(packet.ValidateAsType<T>());
		return packet.Get<T>();
	}

	template<typename T>
	std::shared_ptr<T> ShareContent(const Packet& packet) {
		MP_THROW_IF_ERROR(packet.ValidateAsType<T>());
		const T* ptr = &packet.Get<T>();
		return std::shared_ptr<T>(std::shared_ptr<T>{}, const_cast<T*>(ptr));
	}

	[[nodiscard]] absl::StatusOr<std::shared_ptr<google::protobuf::Message>> MessageFromDynamicProto(const std::string& type_name, const std::string& serialized);

	CV_WRAP [[nodiscard]] absl::StatusOr<int64_t> get_int(const Packet& packet);
	CV_WRAP [[nodiscard]] absl::StatusOr<uint64_t> get_uint(const Packet& packet);
	CV_WRAP [[nodiscard]] absl::StatusOr<float> get_float(const Packet& packet);
	CV_WRAP [[nodiscard]] absl::StatusOr<std::vector<int64_t>> get_int_list(const Packet& packet);
	CV_WRAP [[nodiscard]] absl::StatusOr<std::vector<float>> get_float_list(const Packet& packet);
	CV_WRAP [[nodiscard]] absl::StatusOr<std::shared_ptr<google::protobuf::Message>> get_proto(const Packet& packet);
	CV_WRAP [[nodiscard]] absl::Status get_proto_list(const Packet& packet, CV_OUT std::vector<std::shared_ptr<google::protobuf::Message>>& proto_list);
}
