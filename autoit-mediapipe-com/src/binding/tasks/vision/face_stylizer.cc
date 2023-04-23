#include "binding/tasks/vision/face_stylizer.h"

PTR_BRIDGE_IMPL(mediapipe::tasks::autoit::vision::face_stylizer::ImageRawCallback);

template<typename _Ty1, typename _Ty2>
inline const HRESULT autoit_to_callback(VARIANT const* const& in_val, _Ty1& out_val) {
	_Ty2 result_callback;
	HRESULT hr = autoit_to(in_val, result_callback);
	if (SUCCEEDED(hr)) {
		out_val = result_callback;
	}
	return hr;
}

const HRESULT autoit_to(VARIANT const* const& in_val, mediapipe::tasks::autoit::vision::face_stylizer::ImageCallback& out_val) {
	return autoit_to_callback<
		mediapipe::tasks::autoit::vision::face_stylizer::ImageCallback,
		mediapipe::tasks::autoit::vision::face_stylizer::ImageRawCallback
	>(in_val, out_val);
}

namespace {
	using namespace mediapipe::tasks::vision::face_stylizer::proto;
	using namespace mediapipe::tasks::autoit::vision::core::vision_task_running_mode;
	using namespace mediapipe::tasks::autoit::core::base_options;
	using namespace mediapipe::tasks::autoit::core::task_info;
	using namespace mediapipe::tasks::autoit::components::utils;;
	using namespace mediapipe::tasks::autoit::vision::core::image_processing_options;
	using namespace mediapipe::autoit::packet_creator;
	using namespace mediapipe::autoit::packet_getter;
	using namespace google::protobuf;

	using mediapipe::autoit::PacketsCallback;
	using mediapipe::tasks::core::PacketMap;

	const std::string _STYLIZED_IMAGE_NAME = "stylized_image";
	const std::string _STYLIZED_IMAGE_TAG = "STYLIZED_IMAGE";
	const std::string _NORM_RECT_STREAM_NAME = "norm_rect_in";
	const std::string _NORM_RECT_TAG = "NORM_RECT";
	const std::string _IMAGE_IN_STREAM_NAME = "image_in";
	const std::string _IMAGE_OUT_STREAM_NAME = "image_out";
	const std::string _IMAGE_TAG = "IMAGE";
	const std::string _TASK_GRAPH_NAME = "mediapipe.tasks.vision.face_stylizer.FaceStylizerGraph";
	const int64_t _MICRO_SECONDS_PER_MILLISECOND = 1000;
}

namespace mediapipe::tasks::autoit::vision::face_stylizer {
	std::shared_ptr<FaceStylizerGraphOptions> FaceStylizerOptions::to_pb2() {
		auto pb2_obj = std::make_shared<FaceStylizerGraphOptions>();

		if (base_options) {
			pb2_obj->mutable_base_options()->CopyFrom(*base_options->to_pb2());
		}
		pb2_obj->mutable_base_options()->set_use_stream_mode(running_mode != VisionTaskRunningMode::IMAGE);

		return pb2_obj;
	}

	std::shared_ptr<FaceStylizer> FaceStylizer::create_from_model_path(const std::string& model_path) {
		auto base_options = std::make_shared<BaseOptions>(model_path);
		return create_from_options(std::make_shared<FaceStylizerOptions>(base_options, VisionTaskRunningMode::IMAGE));
	}

	std::shared_ptr<FaceStylizer> FaceStylizer::create_from_options(std::shared_ptr<FaceStylizerOptions> options) {
		PacketsCallback packets_callback = nullptr;

		if (options->result_callback) {
			packets_callback = [options](const PacketMap& output_packets) {
				const auto image_out_packet = output_packets.at(_IMAGE_OUT_STREAM_NAME);
				if (image_out_packet.IsEmpty()) {
					return;
				}

				auto image = GetContent<Image>(image_out_packet);
				const auto& stylized_image_packet = output_packets.at(_STYLIZED_IMAGE_NAME);
				auto timestamp = stylized_image_packet.Timestamp().Value();
				auto timestamp_ms = timestamp / _MICRO_SECONDS_PER_MILLISECOND;

				if (stylized_image_packet.IsEmpty()) {
					options->result_callback(nullptr, image, timestamp_ms);
					return;
				}

				auto stylized_image = GetContent<Image>(stylized_image_packet);
				options->result_callback(&stylized_image, image, timestamp_ms);
			};
		}

		TaskInfo task_info;
		task_info.task_graph = _TASK_GRAPH_NAME;
		task_info.input_streams = {
			_IMAGE_TAG + ":" + _IMAGE_IN_STREAM_NAME,
			_NORM_RECT_TAG + ":" + _NORM_RECT_STREAM_NAME
		};
		task_info.output_streams = {
			_STYLIZED_IMAGE_TAG + ":" + _STYLIZED_IMAGE_NAME,
			_IMAGE_TAG + ":" + _IMAGE_OUT_STREAM_NAME
		};
		task_info.task_options = options->to_pb2();

		return std::make_shared<FaceStylizer>(
			*task_info.generate_graph_config(options->running_mode == VisionTaskRunningMode::LIVE_STREAM),
			options->running_mode,
			std::move(packets_callback)
			);
	}

	std::shared_ptr<Image> FaceStylizer::stylize(
		const Image& image,
		std::shared_ptr<ImageProcessingOptions> image_processing_options
	) {
		auto normalized_rect = convert_to_normalized_rect(image_processing_options, image, false);

		auto output_packets = _process_image_data({
			{ _IMAGE_IN_STREAM_NAME, std::move(*std::move(create_image(image))) },
			{ _NORM_RECT_STREAM_NAME, std::move(*std::move(create_proto(*normalized_rect.to_pb2()))) },
			});

		const auto& stylized_image_packet = output_packets.at(_STYLIZED_IMAGE_NAME);
		if (stylized_image_packet.IsEmpty()) {
			return std::shared_ptr<Image>();
		}

		auto stylized_image = GetContent<Image>(stylized_image_packet);
		return ::autoit::reference_internal(&stylized_image);
	}

	std::shared_ptr<Image> FaceStylizer::stylize_for_video(
		const Image& image,
		int64_t timestamp_ms,
		std::shared_ptr<ImageProcessingOptions> image_processing_options
	) {
		auto normalized_rect = convert_to_normalized_rect(image_processing_options, image, false);

		auto output_packets = _process_video_data({
			{ _IMAGE_IN_STREAM_NAME, std::move(std::move(create_image(image))->At(
				Timestamp(timestamp_ms * _MICRO_SECONDS_PER_MILLISECOND)
			)) },
			{ _NORM_RECT_STREAM_NAME, std::move(std::move(create_proto(*normalized_rect.to_pb2()))->At(
				Timestamp(timestamp_ms * _MICRO_SECONDS_PER_MILLISECOND)
			)) },
			});

		const auto& stylized_image_packet = output_packets.at(_STYLIZED_IMAGE_NAME);
		if (stylized_image_packet.IsEmpty()) {
			return std::shared_ptr<Image>();
		}

		auto stylized_image = GetContent<Image>(stylized_image_packet);
		return ::autoit::reference_internal(&stylized_image);
	}

	void FaceStylizer::stylize_async(
		const Image& image,
		int64_t timestamp_ms,
		std::shared_ptr<ImageProcessingOptions> image_processing_options
	) {
		auto normalized_rect = convert_to_normalized_rect(image_processing_options, image, false);

		_send_live_stream_data({
			{ _IMAGE_IN_STREAM_NAME, std::move(std::move(create_image(image))->At(
				Timestamp(timestamp_ms * _MICRO_SECONDS_PER_MILLISECOND)
			)) },
			{ _NORM_RECT_STREAM_NAME, std::move(std::move(create_proto(*normalized_rect.to_pb2()))->At(
				Timestamp(timestamp_ms * _MICRO_SECONDS_PER_MILLISECOND)
			)) },
			});
	}
}
