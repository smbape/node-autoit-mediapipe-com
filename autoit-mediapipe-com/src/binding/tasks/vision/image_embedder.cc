#include "binding/tasks/vision/image_embedder.h"
#include "binding/packet_getter.h"
#include "binding/packet_creator.h"

PTR_BRIDGE_IMPL(mediapipe::tasks::autoit::vision::image_embedder::ImageEmbedderResultRawCallback);

template<typename _Ty1, typename _Ty2>
inline const HRESULT autoit_to_callback(VARIANT const* const& in_val, _Ty1& out_val) {
	_Ty2 result_callback;
	HRESULT hr = autoit_to(in_val, result_callback);
	if (SUCCEEDED(hr)) {
		out_val = result_callback;
	}
	return hr;
}

const HRESULT autoit_to(VARIANT const* const& in_val, mediapipe::tasks::autoit::vision::image_embedder::ImageEmbedderResultCallback& out_val) {
	return autoit_to_callback<
		mediapipe::tasks::autoit::vision::image_embedder::ImageEmbedderResultCallback,
		mediapipe::tasks::autoit::vision::image_embedder::ImageEmbedderResultRawCallback
	>(in_val, out_val);
}

namespace {
	using namespace mediapipe::tasks::vision::image_embedder::proto;
	using namespace mediapipe::tasks::autoit::vision::core::vision_task_running_mode;
	using namespace mediapipe::tasks::autoit::components::containers::embedding_result;
	using namespace mediapipe::tasks::autoit::core::base_options;
	using namespace mediapipe::tasks::autoit::core::task_info;
	using namespace mediapipe::tasks::autoit::components::utils;

	using mediapipe::autoit::PacketsCallback;
	using mediapipe::tasks::core::PacketMap;

	const std::string _EMBEDDINGS_OUT_STREAM_NAME = "embeddings_out";
	const std::string _EMBEDDINGS_TAG = "EMBEDDINGS";
	const std::string _IMAGE_IN_STREAM_NAME = "image_in";
	const std::string _IMAGE_OUT_STREAM_NAME = "image_out";
	const std::string _IMAGE_TAG = "IMAGE";
	const std::string _NORM_RECT_STREAM_NAME = "norm_rect_in";
	const std::string _NORM_RECT_TAG = "NORM_RECT";
	const std::string _TASK_GRAPH_NAME = "mediapipe.tasks.vision.image_embedder.ImageEmbedderGraph";
	const int64_t _MICRO_SECONDS_PER_MILLISECOND = 1000;
}

namespace mediapipe {
	namespace tasks {
		namespace autoit {
			namespace vision {
				namespace image_embedder {
					std::shared_ptr<ImageEmbedderGraphOptions> ImageEmbedderOptions::to_pb2() {
						auto pb2_obj = std::make_shared<ImageEmbedderGraphOptions>();

						pb2_obj->mutable_base_options()->CopyFrom(*base_options->to_pb2());
						pb2_obj->mutable_base_options()->set_use_stream_mode(running_mode != VisionTaskRunningMode::IMAGE);
						if (l2_normalize) pb2_obj->mutable_embedder_options()->set_l2_normalize(*l2_normalize);
						if (quantize) pb2_obj->mutable_embedder_options()->set_quantize(*quantize);

						return pb2_obj;
					}

					std::shared_ptr<ImageEmbedder> ImageEmbedder::create_from_model_path(const std::string& model_path) {
						auto base_options = std::make_shared<BaseOptions>(model_path);
						return create_from_options(std::make_shared<ImageEmbedderOptions>(base_options, VisionTaskRunningMode::IMAGE));
					}

					std::shared_ptr<ImageEmbedder> ImageEmbedder::create_from_options(std::shared_ptr<ImageEmbedderOptions> options) {
						PacketsCallback packets_callback = nullptr;

						if (options->result_callback) {
							packets_callback = [options](const PacketMap& output_packets) {
								if (output_packets.at(_IMAGE_OUT_STREAM_NAME).IsEmpty()) {
									return;
								}

								mediapipe::tasks::components::containers::proto::EmbeddingResult embedding_result_proto;
								embedding_result_proto.CopyFrom(
									*mediapipe::autoit::packet_getter::get_proto(output_packets.at(_EMBEDDINGS_OUT_STREAM_NAME))
								);

								auto image = mediapipe::autoit::packet_getter::GetContent<Image>(output_packets.at(_IMAGE_OUT_STREAM_NAME));
								auto timestamp_ms = output_packets.at(_IMAGE_OUT_STREAM_NAME).Timestamp().Value() / _MICRO_SECONDS_PER_MILLISECOND;

								options->result_callback(
									*ImageEmbedderResult::create_from_pb2(embedding_result_proto),
									image,
									timestamp_ms
								);
							};
						}

						TaskInfo task_info;
						task_info.task_graph = _TASK_GRAPH_NAME;
						task_info.input_streams = {
							_IMAGE_TAG + ":" + _IMAGE_IN_STREAM_NAME,
							_NORM_RECT_TAG + ":" + _NORM_RECT_STREAM_NAME
						};
						task_info.output_streams = {
							_EMBEDDINGS_TAG + ":" + _EMBEDDINGS_OUT_STREAM_NAME,
							_IMAGE_TAG + ":" + _IMAGE_OUT_STREAM_NAME
						};
						task_info.task_options = options->to_pb2();

						return std::make_shared<ImageEmbedder>(
							*task_info.generate_graph_config(options->running_mode == VisionTaskRunningMode::LIVE_STREAM),
							options->running_mode,
							std::move(packets_callback)
							);
					}

					std::shared_ptr<ImageEmbedderResult> ImageEmbedder::embed(
						const Image& image,
						std::shared_ptr<core::image_processing_options::ImageProcessingOptions> image_processing_options
					) {
						auto normalized_rect = convert_to_normalized_rect(image_processing_options);
						auto output_packets = _process_image_data({
							{ _IMAGE_IN_STREAM_NAME, std::move(*std::move(mediapipe::autoit::packet_creator::create_image(image))) },
							{ _NORM_RECT_STREAM_NAME, std::move(*std::move(mediapipe::autoit::packet_creator::create_proto(*normalized_rect.to_pb2()))) },
							});

						mediapipe::tasks::components::containers::proto::EmbeddingResult embedding_result_proto;
						embedding_result_proto.CopyFrom(
							*mediapipe::autoit::packet_getter::get_proto(output_packets.at(_EMBEDDINGS_OUT_STREAM_NAME))
						);

						return ImageEmbedderResult::create_from_pb2(embedding_result_proto);
					}

					std::shared_ptr<ImageEmbedderResult> ImageEmbedder::embed_for_video(
						const Image& image,
						int64_t timestamp_ms,
						std::shared_ptr<core::image_processing_options::ImageProcessingOptions> image_processing_options
					) {
						auto normalized_rect = convert_to_normalized_rect(image_processing_options);

						auto output_packets = _process_video_data({
							{ _IMAGE_IN_STREAM_NAME, std::move(std::move(mediapipe::autoit::packet_creator::create_image(image))->At(
								Timestamp(timestamp_ms * _MICRO_SECONDS_PER_MILLISECOND)
							)) },
							{ _NORM_RECT_STREAM_NAME, std::move(std::move(mediapipe::autoit::packet_creator::create_proto(*normalized_rect.to_pb2()))->At(
								Timestamp(timestamp_ms * _MICRO_SECONDS_PER_MILLISECOND)
							)) },
							});

						mediapipe::tasks::components::containers::proto::EmbeddingResult embedding_result_proto;
						embedding_result_proto.CopyFrom(
							*mediapipe::autoit::packet_getter::get_proto(output_packets.at(_EMBEDDINGS_OUT_STREAM_NAME))
						);

						return ImageEmbedderResult::create_from_pb2(embedding_result_proto);
					}

					void ImageEmbedder::embed_async(
						const Image& image,
						int64_t timestamp_ms,
						std::shared_ptr<core::image_processing_options::ImageProcessingOptions> image_processing_options
					) {
						auto normalized_rect = convert_to_normalized_rect(image_processing_options);

						_send_live_stream_data({
							{ _IMAGE_IN_STREAM_NAME, std::move(std::move(mediapipe::autoit::packet_creator::create_image(image))->At(
								Timestamp(timestamp_ms * _MICRO_SECONDS_PER_MILLISECOND)
							)) },
							{ _NORM_RECT_STREAM_NAME, std::move(std::move(mediapipe::autoit::packet_creator::create_proto(*normalized_rect.to_pb2()))->At(
								Timestamp(timestamp_ms * _MICRO_SECONDS_PER_MILLISECOND)
							)) },
							});
					}

					float ImageEmbedder::cosine_similarity(const Embedding& u, const Embedding& v) {
						return cosine_similarity::cosine_similarity(u, v);
					}
				}
			}
		}
	}
}
