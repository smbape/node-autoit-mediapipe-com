#pragma once

#include "binding/solution_base.h"

namespace mediapipe::autoit::solutions::hands {
	using namespace mediapipe::autoit::solution_base;

	enum class HandLandmark {
		// The 21 hand landmarks.
		WRIST = 0,
		THUMB_CMC = 1,
		THUMB_MCP = 2,
		THUMB_IP = 3,
		THUMB_TIP = 4,
		INDEX_FINGER_MCP = 5,
		INDEX_FINGER_PIP = 6,
		INDEX_FINGER_DIP = 7,
		INDEX_FINGER_TIP = 8,
		MIDDLE_FINGER_MCP = 9,
		MIDDLE_FINGER_PIP = 10,
		MIDDLE_FINGER_DIP = 11,
		MIDDLE_FINGER_TIP = 12,
		RING_FINGER_MCP = 13,
		RING_FINGER_PIP = 14,
		RING_FINGER_DIP = 15,
		RING_FINGER_TIP = 16,
		PINKY_MCP = 17,
		PINKY_PIP = 18,
		PINKY_DIP = 19,
		PINKY_TIP = 20,
	};

	class CV_EXPORTS_W Hands : public ::mediapipe::autoit::solution_base::SolutionBase {
	public:
		using SolutionBase::SolutionBase;

		CV_WRAP [[nodiscard]] static absl::StatusOr<std::shared_ptr<Hands>> create(
			bool static_image_mode = false,
			int max_num_hands = 2,
			BYTE model_complexity = 1,
			float min_detection_confidence = 0.5f,
			float min_tracking_confidence = 0.5f
		);

		CV_WRAP [[nodiscard]] absl::Status process(const cv::Mat& image, CV_OUT std::map<std::string, _variant_t>& solution_outputs);
	};
}
