#include "Mediapipe_Packet_Object.h"

using namespace mediapipe;
using mediapipe::autoit::TimestampValueString;

const std::string CMediapipe_Packet_Object::str(HRESULT& hr) {
	const auto& packet = *__self->get();
	hr = S_OK;
	return absl::StrCat(
		"<mediapipe.Packet with timestamp: ",
		TimestampValueString(packet.Timestamp()),
		packet.IsEmpty()
			? " and no data>"
			: absl::StrCat(" and C++ type: ", packet.DebugTypeName(), ">")
	);
}
