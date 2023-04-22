#pragma once

#include "absl/status/statusor.h"
#include "google/protobuf/message.h"
#include "mediapipe/framework/formats/image.h"
#include "mediapipe/framework/formats/matrix.h"
#include "mediapipe/framework/packet.h"
#include "mediapipe/framework/port/integral_types.h"
#include "mediapipe/framework/timestamp.h"
#include "binding/image_frame.h"

namespace mediapipe::autoit::packet_getter {
	template <typename T>
	const T& GetContent(const Packet& packet) {
		RaiseAutoItErrorIfNotOk(packet.ValidateAsType<T>());
		return packet.Get<T>();
	}

	std::shared_ptr<google::protobuf::Message> MessageFromDynamicProto(const std::string& type_name, const std::string& serialized);

	CV_WRAP const int64_t get_int(const Packet& packet);
	CV_WRAP const uint64_t get_uint(const Packet& packet);
	CV_WRAP const float get_float(const Packet& packet);
	CV_WRAP const std::vector<int64_t> get_int_list(const Packet& packet);
	CV_WRAP const std::vector<float> get_float_list(const Packet& packet);
	CV_WRAP const std::shared_ptr<google::protobuf::Message> get_proto(const Packet& packet);
	CV_WRAP const std::vector<std::shared_ptr<google::protobuf::Message>> get_proto_list(const Packet& packet);
}
