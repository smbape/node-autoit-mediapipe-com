#pragma once

#include "mediapipe/tasks/cc/vision/gesture_recognizer/gesture_recognizer.h"
#include "binding/tasks/vision/gesture_recognizer_result.h"
#include "binding/tasks/core/utils.h"

namespace mediapipe::tasks::vision::gesture_recognizer {
	using GestureRecognizerResultRawCallback = void(*)(tasks::autoit::vision::gesture_recognizer::GestureRecognizerResult*, int, const char*, const Image&, int64_t);
	using GestureRecognizerResultCallback = std::function<void(absl::StatusOr<GestureRecognizerResult>, const Image&, int64_t)>;
}

namespace mediapipe::tasks::autoit::core::utils {
	tasks::vision::gesture_recognizer::GestureRecognizerResultCallback CppConvertToGestureRecognizerResultCallback(
		tasks::vision::gesture_recognizer::GestureRecognizerResultRawCallback c_callback
	);

	void CppConvertToGestureRecognizerResultCallback(tasks::vision::gesture_recognizer::GestureRecognizerResultRawCallback c_callback, tasks::vision::gesture_recognizer::GestureRecognizerResultCallback& fn, HRESULT& hr);

	void CppConvertToGestureRecognizerResultCallback(VARIANT* in_val, tasks::vision::gesture_recognizer::GestureRecognizerResultCallback& fn, HRESULT& hr);
}

PTR_BRIDGE_DECL(mediapipe::tasks::vision::gesture_recognizer::GestureRecognizerResultRawCallback);
extern const HRESULT autoit_to(VARIANT const* in_val, mediapipe::tasks::vision::gesture_recognizer::GestureRecognizerResultCallback& out_val);
