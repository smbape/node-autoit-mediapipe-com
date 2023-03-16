#pragma once

#include "mediapipe/tasks/cc/audio/audio_embedder/proto/audio_embedder_graph_options.pb.h"
#include "mediapipe/tasks/cc/components/containers/proto/embeddings.pb.h"
#include "mediapipe/tasks/cc/components/processors/proto/embedder_options.pb.h"
#include "binding/packet.h"
#include "binding/tasks/audio/core/audio_task_running_mode.h"
#include "binding/tasks/audio/core/base_audio_task_api.h"
#include "binding/tasks/components/containers/audio_data.h"
#include "binding/tasks/components/containers/embedding_result.h"
#include "binding/tasks/components/utils/cosine_similarity.h"
#include "binding/tasks/core/base_options.h"
#include "binding/tasks/core/task_info.h"
#include <functional>

namespace mediapipe {
	namespace tasks {
		namespace autoit {
			namespace audio {
				namespace audio_embedder {
					using AudioEmbedderResult = components::containers::embedding_result::EmbeddingResult;
					using AudioEmbedderResultRawCallback = void(*)(const AudioEmbedderResult&, int64_t);
					using AudioEmbedderResultCallback = std::function<void(const AudioEmbedderResult&, int64_t)>;

					struct CV_EXPORTS_W_SIMPLE AudioEmbedderOptions {
						CV_WRAP AudioEmbedderOptions(const AudioEmbedderOptions& other) = default;
						AudioEmbedderOptions& operator=(const AudioEmbedderOptions& other) = default;

						CV_WRAP AudioEmbedderOptions(
							std::shared_ptr<autoit::core::base_options::BaseOptions> base_options = std::shared_ptr<autoit::core::base_options::BaseOptions>(),
							core::audio_task_running_mode::AudioTaskRunningMode running_mode = tasks::autoit::audio::core::audio_task_running_mode::AudioTaskRunningMode::AUDIO_CLIPS,
							std::optional<bool> l2_normalize = std::optional<bool>(),
							std::optional<bool> quantize = std::optional<bool>(),
							AudioEmbedderResultCallback result_callback = nullptr
						)
							:
							base_options(base_options),
							running_mode(running_mode),
							l2_normalize(l2_normalize),
							quantize(quantize),
							result_callback(result_callback)
						{}

						CV_WRAP std::shared_ptr<mediapipe::tasks::audio::audio_embedder::proto::AudioEmbedderGraphOptions> to_pb2();

						CV_PROP_RW std::shared_ptr<autoit::core::base_options::BaseOptions> base_options;
						CV_PROP_RW core::audio_task_running_mode::AudioTaskRunningMode running_mode;
						CV_PROP_RW std::optional<bool> l2_normalize;
						CV_PROP_RW std::optional<bool> quantize;
						CV_PROP_W  AudioEmbedderResultCallback result_callback;
					};

					class CV_EXPORTS_W AudioEmbedder : core::base_audio_task_api::BaseAudioTaskApi {
						using core::base_audio_task_api::BaseAudioTaskApi::BaseAudioTaskApi;

						CV_WRAP static std::shared_ptr<AudioEmbedder> create_from_model_path(const std::string& model_path);
						CV_WRAP static std::shared_ptr<AudioEmbedder> create_from_options(std::shared_ptr<AudioEmbedderOptions> options);
						CV_WRAP void embed(CV_OUT std::vector<std::shared_ptr<AudioEmbedderResult>>& output_list, const components::containers::audio_data::AudioData& audio_clip);
						CV_WRAP void embed_async(const components::containers::audio_data::AudioData& audio_block, int64_t timestamp_ms);
						CV_WRAP static float cosine_similarity(const components::containers::embedding_result::Embedding& u, const components::containers::embedding_result::Embedding& v);
					};
				}
			}
		}
	}
}

PTR_BRIDGE_DECL(mediapipe::tasks::autoit::audio::audio_embedder::AudioEmbedderResultRawCallback);
extern const HRESULT autoit_to(VARIANT const* const& in_val, mediapipe::tasks::autoit::audio::audio_embedder::AudioEmbedderResultCallback& out_val);
