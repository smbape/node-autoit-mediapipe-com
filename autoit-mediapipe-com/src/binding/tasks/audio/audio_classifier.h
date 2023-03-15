#pragma once

#include "mediapipe/tasks/cc/audio/audio_classifier/proto/audio_classifier_graph_options.pb.h"
#include "mediapipe/tasks/cc/components/containers/proto/classifications.pb.h"
#include "mediapipe/tasks/cc/components/processors/proto/classifier_options.pb.h"
#include "binding/packet.h"
#include "binding/tasks/audio/core/audio_task_running_mode.h"
#include "binding/tasks/audio/core/base_audio_task_api.h"
#include "binding/tasks/components/containers/audio_data.h"
#include "binding/tasks/components/containers/classification_result.h"
#include "binding/tasks/core/base_options.h"
#include "binding/tasks/core/task_info.h"
#include <functional>

namespace mediapipe {
	namespace tasks {
		namespace autoit {
			namespace audio {
				namespace audio_classifier {
					using AudioClassifierResult = components::containers::classification_result::ClassificationResult;
					using AudioClassifierResultRawCallback = void(*)(const AudioClassifierResult&, int64_t);
					using AudioClassifierResultCallback = std::function<void(const AudioClassifierResult&, int64_t)>;

					struct CV_EXPORTS_W_SIMPLE AudioClassifierOptions {
						CV_WRAP AudioClassifierOptions(const AudioClassifierOptions& other) = default;
						AudioClassifierOptions& operator=(const AudioClassifierOptions& other) = default;

						CV_WRAP AudioClassifierOptions(
							std::shared_ptr<autoit::core::base_options::BaseOptions> base_options = std::shared_ptr<autoit::core::base_options::BaseOptions>(),
							core::audio_task_running_mode::AudioTaskRunningMode running_mode = tasks::autoit::audio::core::audio_task_running_mode::AudioTaskRunningMode::AUDIO_CLIPS,
							const std::optional<std::string>& display_names_locale = std::optional<std::string>(),
							std::optional<int> max_results = std::optional<int>(),
							std::optional<float> score_threshold = std::optional<float>(),
							const std::vector<std::string>& category_allowlist = std::vector<std::string>(),
							const std::vector<std::string>& category_denylist = std::vector<std::string>(),
							AudioClassifierResultCallback result_callback = nullptr
						)
							:
							base_options(base_options),
							running_mode(running_mode),
							display_names_locale(display_names_locale),
							max_results(max_results),
							score_threshold(score_threshold),
							category_allowlist(category_allowlist),
							category_denylist(category_denylist),
							result_callback(result_callback)
						{}

						CV_WRAP std::shared_ptr<mediapipe::tasks::audio::audio_classifier::proto::AudioClassifierGraphOptions> to_pb2();

						CV_PROP_RW std::shared_ptr<autoit::core::base_options::BaseOptions> base_options;
						CV_PROP_RW core::audio_task_running_mode::AudioTaskRunningMode running_mode;
						CV_PROP_RW std::optional<std::string> display_names_locale;
						CV_PROP_RW std::optional<int> max_results;
						CV_PROP_RW std::optional<float> score_threshold;
						CV_PROP_RW std::vector<std::string> category_allowlist;
						CV_PROP_RW std::vector<std::string> category_denylist;
						CV_PROP_W  AudioClassifierResultCallback result_callback;
					};

					class CV_EXPORTS_W AudioClassifier : core::base_audio_task_api::BaseAudioTaskApi {
						using core::base_audio_task_api::BaseAudioTaskApi::BaseAudioTaskApi;

						CV_WRAP static std::shared_ptr<AudioClassifier> create_from_model_path(const std::string& model_path);
						CV_WRAP static std::shared_ptr<AudioClassifier> create_from_options(std::shared_ptr<AudioClassifierOptions> options);
						CV_WRAP std::vector<std::shared_ptr<components::containers::classification_result::ClassificationResult>> classify(const components::containers::audio_data::AudioData& audio_clip);
						CV_WRAP void classify_async(const components::containers::audio_data::AudioData& audio_block, int64_t timestamp_ms);
					};
				}
			}
		}
	}
}

PTR_BRIDGE_DECL(mediapipe::tasks::autoit::audio::audio_classifier::AudioClassifierResultRawCallback);
extern const HRESULT autoit_to(VARIANT const* const& in_val, mediapipe::tasks::autoit::audio::audio_classifier::AudioClassifierResultCallback& out_val);
