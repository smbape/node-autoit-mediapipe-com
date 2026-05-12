#pragma once

#include "mediapipe/tasks/cc/components/containers/keypoint.h"
#include "mediapipe/tasks/cc/components/containers/rect.h"
#include "mediapipe/framework/formats/location_data.pb.h"

namespace mediapipe::tasks::components::containers {
	Rect ConvertToRect(const mediapipe::LocationData::BoundingBox& proto);

	NormalizedKeypoint ConvertToNormalizedKeypoint(const mediapipe::LocationData::RelativeKeypoint& proto);
}
