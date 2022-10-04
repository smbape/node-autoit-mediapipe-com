#include "Mediapipe_Autoit_Packet_getter_Object.h"

using namespace mediapipe;

// RegisteredTypeName()

const int64 CMediapipe_Autoit_Packet_getter_Object::get_int(Packet& packet, HRESULT& hr) {
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

const uint64 CMediapipe_Autoit_Packet_getter_Object::get_uint(Packet& packet, HRESULT& hr) {
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

const float CMediapipe_Autoit_Packet_getter_Object::get_float(Packet& packet, HRESULT& hr) {
	if (packet.ValidateAsType<float>().ok()) {
		return packet.Get<float>();
	}

	if (packet.ValidateAsType<double>().ok()) {
		return static_cast<float>(packet.Get<double>());
	}

	AUTOIT_THROW("Packet doesn't contain float or double data.");
}

const std::vector<int64> CMediapipe_Autoit_Packet_getter_Object::get_int_list(Packet& packet, HRESULT& hr) {
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

const std::vector<float> CMediapipe_Autoit_Packet_getter_Object::get_float_list(Packet& packet, HRESULT& hr) {
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
