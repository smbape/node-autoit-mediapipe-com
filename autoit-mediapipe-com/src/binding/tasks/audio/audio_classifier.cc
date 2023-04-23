#include "binding/tasks/audio/audio_classifier.h"
#include "binding/packet_getter.h"
#include "binding/packet_creator.h"
#include <opencv2/core/eigen.hpp>

PTR_BRIDGE_IMPL(mediapipe::tasks::autoit::audio::audio_classifier::AudioClassifierResultRawCallback);

template<typename _Ty1, typename _Ty2>
inline const HRESULT autoit_to_callback(VARIANT const* const& in_val, _Ty1& out_val) {
	_Ty2 result_callback;
	HRESULT hr = autoit_to(in_val, result_callback);
	if (SUCCEEDED(hr)) {
		out_val = result_callback;
	}
	return hr;
}

const HRESULT autoit_to(VARIANT const* const& in_val, mediapipe::tasks::autoit::audio::audio_classifier::AudioClassifierResultCallback& out_val) {
	return autoit_to_callback<
		mediapipe::tasks::autoit::audio::audio_classifier::AudioClassifierResultCallback,
		mediapipe::tasks::autoit::audio::audio_classifier::AudioClassifierResultRawCallback
	>(in_val, out_val);
}

namespace {
	using namespace mediapipe::tasks::audio::audio_classifier::proto;
	using namespace mediapipe::tasks::autoit::audio::core::audio_task_running_mode;
	using namespace mediapipe::tasks::autoit::components::containers::audio_data;
	using namespace mediapipe::tasks::autoit::components::containers::classification_result;
	using namespace mediapipe::tasks::autoit::core::base_options;
	using namespace mediapipe::tasks::autoit::core::task_info;
	using namespace mediapipe::autoit::packet_creator;
	using namespace mediapipe::autoit::packet_getter;
	using namespace google::protobuf;

	using mediapipe::autoit::PacketsCallback;
	using mediapipe::tasks::core::PacketMap;

	const std::string _AUDIO_IN_STREAM_NAME = "audio_in";
	const std::string _AUDIO_TAG = "AUDIO";
	const std::string _CLASSIFICATIONS_STREAM_NAME = "classifications_out";
	const std::string _CLASSIFICATIONS_TAG = "CLASSIFICATIONS";
	const std::string _SAMPLE_RATE_IN_STREAM_NAME = "sample_rate_in";
	const std::string _SAMPLE_RATE_TAG = "SAMPLE_RATE";
	const std::string _TASK_GRAPH_NAME = "mediapipe.tasks.audio.audio_classifier.AudioClassifierGraph";
	const std::string _TIMESTAMPED_CLASSIFICATIONS_STREAM_NAME = "timestamped_classifications_out";
	const std::string _TIMESTAMPED_CLASSIFICATIONS_TAG = "TIMESTAMPED_CLASSIFICATIONS";
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

namespace mediapipe::tasks::autoit::audio::audio_classifier {
	std::shared_ptr<AudioClassifierGraphOptions> AudioClassifierOptions::to_pb2() {
		auto pb2_obj = std::make_shared<AudioClassifierGraphOptions>();

		if (base_options) {
			pb2_obj->mutable_base_options()->CopyFrom(*base_options->to_pb2());
		}
		pb2_obj->mutable_base_options()->set_use_stream_mode(running_mode != AudioTaskRunningMode::AUDIO_CLIPS);

		if (score_threshold) pb2_obj->mutable_classifier_options()->set_score_threshold(*score_threshold);
		pb2_obj->mutable_classifier_options()->mutable_category_allowlist()->Add(category_allowlist.begin(), category_allowlist.end());
		pb2_obj->mutable_classifier_options()->mutable_category_denylist()->Add(category_denylist.begin(), category_denylist.end());
		if (display_names_locale) pb2_obj->mutable_classifier_options()->set_display_names_locale(*display_names_locale);
		if (max_results) pb2_obj->mutable_classifier_options()->set_max_results(*max_results);

		return pb2_obj;
	}

	std::shared_ptr<AudioClassifier> AudioClassifier::create_from_model_path(const std::string& model_path) {
		auto base_options = std::make_shared<BaseOptions>(model_path);
		return create_from_options(std::make_shared<AudioClassifierOptions>(base_options, AudioTaskRunningMode::AUDIO_CLIPS));
	}

	std::shared_ptr<AudioClassifier> AudioClassifier::create_from_options(std::shared_ptr<AudioClassifierOptions> options) {
		PacketsCallback packets_callback = nullptr;

		if (options->result_callback) {
			packets_callback = [options](const PacketMap& output_packets) {
				auto timestamp_ms = output_packets.at(_CLASSIFICATIONS_STREAM_NAME).Timestamp().Value() / _MICRO_SECONDS_PER_MILLISECOND;

				if (output_packets.at(_CLASSIFICATIONS_STREAM_NAME).IsEmpty()) {
					options->result_callback(AudioClassifierResult(), timestamp_ms);
					return;
				}

				mediapipe::tasks::components::containers::proto::ClassificationResult classification_result_proto;
				classification_result_proto.CopyFrom(
					*get_proto(output_packets.at(_CLASSIFICATIONS_STREAM_NAME))
				);
				options->result_callback(
					*AudioClassifierResult::create_from_pb2(classification_result_proto),
					timestamp_ms
				);
			};
		}

		TaskInfo task_info;
		task_info.task_graph = _TASK_GRAPH_NAME;
		task_info.input_streams = {
			_AUDIO_TAG + ":" + _AUDIO_IN_STREAM_NAME,
			_SAMPLE_RATE_TAG + ":" + _SAMPLE_RATE_IN_STREAM_NAME
		};
		task_info.output_streams = {
			_CLASSIFICATIONS_TAG + ":" + _CLASSIFICATIONS_STREAM_NAME,
			_TIMESTAMPED_CLASSIFICATIONS_TAG + ":" + _TIMESTAMPED_CLASSIFICATIONS_STREAM_NAME
		};
		task_info.task_options = options->to_pb2();

		return std::make_shared<AudioClassifier>(
			*task_info.generate_graph_config(false),
			options->running_mode,
			std::move(packets_callback)
			);
	}

	void AudioClassifier::classify(std::vector<std::shared_ptr<AudioClassifierResult>>& output_list, const AudioData& audio_clip) {
		AUTOIT_ASSERT_THROW(audio_clip.audio_format().sample_rate, "Must provide the audio sample rate in audio data.");
		auto packet = create_matrix(audio_clip.buffer(), true);

		auto output_packets = _process_audio_clip({
			{ _AUDIO_IN_STREAM_NAME, std::move(*std::move(packet)) },
			{ _SAMPLE_RATE_IN_STREAM_NAME, std::move(MakePacket<double>(*audio_clip.audio_format().sample_rate)) },
			});

		std::vector<std::shared_ptr<Message>> classification_result_proto_list;
		get_proto_list(output_packets.at(_TIMESTAMPED_CLASSIFICATIONS_STREAM_NAME), classification_result_proto_list);
		for (const auto& proto : classification_result_proto_list) {
			mediapipe::tasks::components::containers::proto::ClassificationResult classification_result_proto;
			classification_result_proto.CopyFrom(*proto);
			output_list.push_back(AudioClassifierResult::create_from_pb2(classification_result_proto));
		}
	}

	void AudioClassifier::classify_async(const AudioData& audio_block, int64_t timestamp_ms) {
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
}
