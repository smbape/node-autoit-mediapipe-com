#include "binding/tasks/audio/audio_embedder.h"
#include "binding/packet_getter.h"
#include "binding/packet_creator.h"
#include <opencv2/core/eigen.hpp>

PTR_BRIDGE_IMPL(mediapipe::tasks::autoit::audio::audio_embedder::AudioEmbedderResultRawCallback);

template<typename _Ty1, typename _Ty2>
inline const HRESULT autoit_to_callback(VARIANT const* const& in_val, _Ty1& out_val) {
	_Ty2 result_callback;
	HRESULT hr = autoit_to(in_val, result_callback);
	if (SUCCEEDED(hr)) {
		out_val = result_callback;
	}
	return hr;
}

const HRESULT autoit_to(VARIANT const* const& in_val, mediapipe::tasks::autoit::audio::audio_embedder::AudioEmbedderResultCallback& out_val) {
	return autoit_to_callback<
		mediapipe::tasks::autoit::audio::audio_embedder::AudioEmbedderResultCallback,
		mediapipe::tasks::autoit::audio::audio_embedder::AudioEmbedderResultRawCallback
	>(in_val, out_val);
}

namespace {
	using namespace google::protobuf;
	using namespace mediapipe::autoit::packet_creator;
	using namespace mediapipe::autoit::packet_getter;
	using namespace mediapipe::tasks::audio::audio_embedder::proto;
	using namespace mediapipe::tasks::autoit::audio::core::audio_task_running_mode;
	using namespace mediapipe::tasks::autoit::components::containers::audio_data;
	using namespace mediapipe::tasks::autoit::components::containers::embedding_result;
	using namespace mediapipe::tasks::autoit::components::utils;
	using namespace mediapipe::tasks::autoit::core::base_options;
	using namespace mediapipe::tasks::autoit::core::task_info;

	using mediapipe::autoit::PacketsCallback;
	using mediapipe::tasks::core::PacketMap;

	const std::string _AUDIO_IN_STREAM_NAME = "audio_in";
	const std::string _AUDIO_TAG = "AUDIO";
	const std::string _EMBEDDINGS_STREAM_NAME = "embeddings_out";
	const std::string _EMBEDDINGS_TAG = "EMBEDDINGS";
	const std::string _SAMPLE_RATE_IN_STREAM_NAME = "sample_rate_in";
	const std::string _SAMPLE_RATE_TAG = "SAMPLE_RATE";
	const std::string _TASK_GRAPH_NAME = "mediapipe.tasks.audio.audio_embedder.AudioEmbedderGraph";
	const std::string _TIMESTAMPED_EMBEDDINGS_STREAM_NAME = "timestamped_embeddings_out";
	const std::string _TIMESTAMPED_EMBEDDINGS_TAG = "TIMESTAMPED_EMBEDDINGS";
	const int64_t _MICRO_SECONDS_PER_MILLISECOND = 1000;

	const std::string optional_to_string(const std::optional<float>& v) {
		std::ostringstream ss;
		if (v.has_value()) {
			ss << *v;
		}
		else {
			ss << "None";
		}
		return ss.str();
	}
}

namespace mediapipe::tasks::autoit::audio::audio_embedder {
	std::shared_ptr<AudioEmbedderGraphOptions> AudioEmbedderOptions::to_pb2() {
		auto pb2_obj = std::make_shared<AudioEmbedderGraphOptions>();

		if (base_options) {
			pb2_obj->mutable_base_options()->CopyFrom(*base_options->to_pb2());
		}
		pb2_obj->mutable_base_options()->set_use_stream_mode(running_mode != AudioTaskRunningMode::AUDIO_CLIPS);
		if (l2_normalize) pb2_obj->mutable_embedder_options()->set_l2_normalize(*l2_normalize);
		if (quantize) pb2_obj->mutable_embedder_options()->set_quantize(*quantize);

		return pb2_obj;
	}

	std::shared_ptr<AudioEmbedder> AudioEmbedder::create_from_model_path(const std::string& model_path) {
		auto base_options = std::make_shared<BaseOptions>(model_path);
		return create_from_options(std::make_shared<AudioEmbedderOptions>(base_options, AudioTaskRunningMode::AUDIO_CLIPS));
	}

	std::shared_ptr<AudioEmbedder> AudioEmbedder::create_from_options(std::shared_ptr<AudioEmbedderOptions> options) {
		PacketsCallback packets_callback = nullptr;

		if (options->result_callback) {
			packets_callback = [options](const PacketMap& output_packets) {
				auto timestamp_ms = output_packets.at(_EMBEDDINGS_STREAM_NAME).Timestamp().Value() / _MICRO_SECONDS_PER_MILLISECOND;

				if (output_packets.at(_EMBEDDINGS_STREAM_NAME).IsEmpty()) {
					options->result_callback(AudioEmbedderResult(), timestamp_ms);
					return;
				}

				const auto& embedding_result_proto = GetContent<mediapipe::tasks::components::containers::proto::EmbeddingResult>(output_packets.at(_EMBEDDINGS_STREAM_NAME));
				options->result_callback(
					*AudioEmbedderResult::create_from_pb2(embedding_result_proto),
					timestamp_ms
				);
			};
		}

		TaskInfo task_info;
		task_info.task_graph = _TASK_GRAPH_NAME;
		*task_info.input_streams = {
			_AUDIO_TAG + ":" + _AUDIO_IN_STREAM_NAME,
			_SAMPLE_RATE_TAG + ":" + _SAMPLE_RATE_IN_STREAM_NAME
		};
		*task_info.output_streams = {
			_EMBEDDINGS_TAG + ":" + _EMBEDDINGS_STREAM_NAME,
			_TIMESTAMPED_EMBEDDINGS_TAG + ":" + _TIMESTAMPED_EMBEDDINGS_STREAM_NAME
		};
		task_info.task_options = options->to_pb2();

		return std::make_shared<AudioEmbedder>(
			*task_info.generate_graph_config(false),
			options->running_mode,
			std::move(packets_callback)
			);
	}

	void AudioEmbedder::embed(std::vector<std::shared_ptr<AudioEmbedderResult>>& output_list, const AudioData& audio_clip) {
		AUTOIT_ASSERT_THROW(audio_clip.audio_format().sample_rate, "Must provide the audio sample rate in audio data.");
		auto packet = create_matrix(audio_clip.buffer(), true);

		auto output_packets = _process_audio_clip({
			{ _AUDIO_IN_STREAM_NAME, std::move(*std::move(packet)) },
			{ _SAMPLE_RATE_IN_STREAM_NAME, std::move(MakePacket<double>(*audio_clip.audio_format().sample_rate)) },
			});

		const auto& embedding_result_proto_list = GetContent<std::vector<mediapipe::tasks::components::containers::proto::EmbeddingResult>>(output_packets.at(_TIMESTAMPED_EMBEDDINGS_STREAM_NAME));
		for (const auto& embedding_result_proto : embedding_result_proto_list) {
			output_list.push_back(AudioEmbedderResult::create_from_pb2(embedding_result_proto));
		}
	}

	void AudioEmbedder::embed_async(const AudioData& audio_block, int64_t timestamp_ms) {
		AUTOIT_ASSERT_THROW(audio_block.audio_format().sample_rate, "Must provide the audio sample rate in audio data.");
		if (!_default_sample_rate) {
			_default_sample_rate = audio_block.audio_format().sample_rate;
			_set_sample_rate(_SAMPLE_RATE_IN_STREAM_NAME, *_default_sample_rate);
		}
		else {
			AUTOIT_ASSERT_THROW(_default_sample_rate == audio_block.audio_format().sample_rate,
				"The audio sample rate provided in audio data: "
				<< optional_to_string(audio_block.audio_format().sample_rate) << " is inconsistent with "
				"the previously received: " << optional_to_string(_default_sample_rate) << "."
			);
		}

		auto packet = create_matrix(audio_block.buffer(), true);

		_send_audio_stream_data({
			{ _AUDIO_IN_STREAM_NAME, std::move(std::move(packet)->At(Timestamp(timestamp_ms * _MICRO_SECONDS_PER_MILLISECOND))) }
			});
	}

	float AudioEmbedder::cosine_similarity(const Embedding& u, const Embedding& v) {
		return cosine_similarity::cosine_similarity(u, v);
	}
}
