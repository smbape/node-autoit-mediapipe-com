#pragma once

#include "binding/tasks/components/containers/rect.h"
#include "mediapipe/framework/formats/location_data.pb.h"

namespace mediapipe::tasks::components::containers {
	LocationData::BoundingBox ConvertRectToProto(Rect* rect);

}  // namespace mediapipe::tasks::components::containers

namespace std {
	inline std::string to_string(const mediapipe::tasks::components::containers::Rect& rect) {
		auto proto = mediapipe::tasks::components::containers::ConvertRectToProto(const_cast<mediapipe::tasks::components::containers::Rect*>(&rect));
		std::string output;
		if (!google::protobuf::TextFormat::PrintToString(proto, &output)) {
			output = "Failed to print message";
		}
		return output;
	}
}
