#pragma once

#include "mediapipe/framework/formats/location_data.pb.h"

namespace mediapipe::tasks::autoit::components::containers::keypoint {
	struct CV_EXPORTS_W_SIMPLE NormalizedKeypoint {
		CV_WRAP NormalizedKeypoint(const NormalizedKeypoint& other) = default;
		NormalizedKeypoint& operator=(const NormalizedKeypoint& other) = default;

		CV_WRAP NormalizedKeypoint(
			const std::optional<float>& x = std::optional<float>(),
			const std::optional<float>& y = std::optional<float>(),
			const std::optional<std::string>& label = std::optional<std::string>(),
			const std::optional<float>& score = std::optional<float>()
		)
			:
			x(x),
			y(y),
			label(label),
			score(score)
		{}

		CV_WRAP std::shared_ptr<LocationData::RelativeKeypoint> to_pb2();
		CV_WRAP static std::shared_ptr<NormalizedKeypoint> create_from_pb2(const LocationData::RelativeKeypoint& pb2_obj);

		CV_PROP_RW std::optional<float> x;
		CV_PROP_RW std::optional<float> y;
		CV_PROP_RW std::optional<std::string> label;
		CV_PROP_RW std::optional<float> score;
	};
}