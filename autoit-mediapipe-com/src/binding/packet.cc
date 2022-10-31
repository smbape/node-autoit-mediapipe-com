#include "Mediapipe_Packet_Object.h"

using namespace mediapipe;
using mediapipe::autoit::TimestampValueString;

const std::string CMediapipe_Packet_Object::str(HRESULT& hr) {
	const auto& self = *__self->get();
	hr = S_OK;
	return absl::StrCat(
		"<mediapipe.Packet with timestamp: ",
		TimestampValueString(self.Timestamp()),
		self.IsEmpty()
			? " and no data>"
			: absl::StrCat(" and C++ type: ", self.DebugTypeName(), ">")
	);
}
