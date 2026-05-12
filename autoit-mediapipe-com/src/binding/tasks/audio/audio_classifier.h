#pragma once

#include "mediapipe/tasks/cc/audio/audio_classifier/audio_classifier.h"
#include "binding/tasks/core/base_options.h"

namespace mediapipe::tasks::audio::audio_classifier {
	using AudioClassifierResultRawCallback = void(*)(AudioClassifierResult*, int, const char*);
	using AudioClassifierResultCallback = std::function<void(absl::StatusOr<AudioClassifierResult>)>;
}

PTR_BRIDGE_DECL(mediapipe::tasks::audio::audio_classifier::AudioClassifierResultRawCallback);
extern const HRESULT autoit_to(VARIANT const* in_val, mediapipe::tasks::audio::audio_classifier::AudioClassifierResultCallback& out_val);
