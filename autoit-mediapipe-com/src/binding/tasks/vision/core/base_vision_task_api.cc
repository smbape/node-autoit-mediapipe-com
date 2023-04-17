#include "binding/tasks/vision/core/base_vision_task_api.h"

#define _USE_MATH_DEFINES // for C++
#include <cmath>

namespace mediapipe::tasks::autoit::vision::core::base_vision_task_api {
	using vision_task_running_mode::VisionTaskRunningMode;
	using components::containers::rect::NormalizedRect;
	using image_processing_options::ImageProcessingOptions;

	BaseVisionTaskApi::BaseVisionTaskApi(
		const CalculatorGraphConfig& graph_config,
		VisionTaskRunningMode running_mode,
		mediapipe::autoit::PacketsCallback packet_callback
	) {
		if (running_mode == VisionTaskRunningMode::LIVE_STREAM) {
			AUTOIT_ASSERT_THROW(packet_callback, "The vision task is in live stream mode, a user-defined result "
				"callback must be provided.");
		}
		else {
			AUTOIT_ASSERT_THROW(!packet_callback, "The vision task is in image or video mode, a user-defined result "
				"callback should not be provided.");
		}

		_runner = mediapipe::autoit::task_runner::create(graph_config, std::move(packet_callback));
		_running_mode = running_mode;
	}

	std::map<std::string, Packet> BaseVisionTaskApi::_process_image_data(const std::map<std::string, Packet>& inputs) {
		AUTOIT_ASSERT_THROW(_running_mode == VisionTaskRunningMode::IMAGE,
			"Task is not initialized with the image mode. Current running mode: "
			<< StringifyVisionTaskRunningMode(_running_mode));
		return mediapipe::autoit::AssertAutoItValue(_runner->Process(inputs));
	}

	std::map<std::string, Packet> BaseVisionTaskApi::_process_video_data(const std::map<std::string, Packet>& inputs) {
		AUTOIT_ASSERT_THROW(_running_mode == VisionTaskRunningMode::VIDEO,
			"Task is not initialized with the video mode. Current running mode: "
			<< StringifyVisionTaskRunningMode(_running_mode));
		return mediapipe::autoit::AssertAutoItValue(_runner->Process(inputs));
	}

	void BaseVisionTaskApi::_send_live_stream_data(const std::map<std::string, Packet>& inputs) {
		AUTOIT_ASSERT_THROW(_running_mode == VisionTaskRunningMode::LIVE_STREAM,
			"Task is not initialized with the video mode. Current running mode: "
			<< StringifyVisionTaskRunningMode(_running_mode));
		_runner->Send(inputs);
	}

	NormalizedRect BaseVisionTaskApi::convert_to_normalized_rect(std::shared_ptr<ImageProcessingOptions> options, bool roi_allowed) {
		NormalizedRect normalized_rect;
		normalized_rect.rotation = 0;
		normalized_rect.x_center = 0.5;
		normalized_rect.y_center = 0.5;
		normalized_rect.width = 1;
		normalized_rect.height = 1;

		if (!options) {
			return normalized_rect;
		}

		AUTOIT_ASSERT_THROW(options->rotation_degrees % 90 == 0, "Expected rotation to be a multiple of 90°.");

		// Convert to radians counter-clockwise.
		normalized_rect.rotation = -options->rotation_degrees * M_PI / 180.0;

		if (options->region_of_interest) {
			AUTOIT_ASSERT_THROW(roi_allowed, "This task doesn't support region-of-interest.");
			const auto& roi = *options->region_of_interest;
			AUTOIT_ASSERT_THROW(roi.left < roi.right&& roi.top < roi.bottom, "Expected Rect with left < right and top < bottom.");
			AUTOIT_ASSERT_THROW(roi.left >= 0 && roi.top >= 0 && roi.right <= 1 && roi.bottom <= 1, "Expected Rect values to be in [0,1].");
			normalized_rect.x_center = (roi.left + roi.right) / 2.0;
			normalized_rect.y_center = (roi.top + roi.bottom) / 2.0;
			normalized_rect.width = roi.right - roi.left;
			normalized_rect.height = roi.bottom - roi.top;
		}

		return normalized_rect;
	}

	void BaseVisionTaskApi::close() {
		_runner->Close();
	}
}
