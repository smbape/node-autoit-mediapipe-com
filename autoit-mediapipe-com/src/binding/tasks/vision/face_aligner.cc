#include "binding/tasks/vision/face_aligner.h"

namespace {
	using namespace google::protobuf;
	using namespace mediapipe::autoit::packet_creator;
	using namespace mediapipe::autoit::packet_getter;
	using namespace mediapipe::tasks::autoit::components::utils;;
	using namespace mediapipe::tasks::autoit::core::base_options;
	using namespace mediapipe::tasks::autoit::core::task_info;
	using namespace mediapipe::tasks::autoit::vision::core::image_processing_options;
	using namespace mediapipe::tasks::autoit::vision::core::vision_task_running_mode;
	using namespace mediapipe::tasks::vision::face_stylizer::proto;

	const std::string _FACE_ALIGNMENT_IMAGE_NAME = "face_alignment";
	const std::string _FACE_ALIGNMENT_IMAGE_TAG = "FACE_ALIGNMENT";
	const std::string _NORM_RECT_STREAM_NAME = "norm_rect_in";
	const std::string _NORM_RECT_TAG = "NORM_RECT";
	const std::string _IMAGE_IN_STREAM_NAME = "image_in";
	const std::string _IMAGE_OUT_STREAM_NAME = "image_out";
	const std::string _IMAGE_TAG = "IMAGE";
	const std::string _TASK_GRAPH_NAME = "mediapipe.tasks.vision.face_stylizer.FaceStylizerGraph";
}

namespace mediapipe::tasks::autoit::vision::face_aligner {
	std::shared_ptr<FaceStylizerGraphOptions> FaceAlignerOptions::to_pb2() {
		auto pb2_obj = std::make_shared<FaceStylizerGraphOptions>();

		if (base_options) {
			pb2_obj->mutable_base_options()->CopyFrom(*base_options->to_pb2());
		}
		pb2_obj->mutable_base_options()->set_use_stream_mode(false);

		return pb2_obj;
	}

	std::shared_ptr<FaceAligner> FaceAligner::create_from_model_path(const std::string& model_path) {
		auto base_options = std::make_shared<BaseOptions>(model_path);
		return create_from_options(std::make_shared<FaceAlignerOptions>(base_options));
	}

	std::shared_ptr<FaceAligner> FaceAligner::create_from_options(std::shared_ptr<FaceAlignerOptions> options) {
		TaskInfo task_info;
		task_info.task_graph = _TASK_GRAPH_NAME;
		*task_info.input_streams = {
			_IMAGE_TAG + ":" + _IMAGE_IN_STREAM_NAME,
			_NORM_RECT_TAG + ":" + _NORM_RECT_STREAM_NAME
		};
		*task_info.output_streams = {
			_FACE_ALIGNMENT_IMAGE_TAG + ":" + _FACE_ALIGNMENT_IMAGE_NAME,
			_IMAGE_TAG + ":" + _IMAGE_OUT_STREAM_NAME
		};
		task_info.task_options = options->to_pb2();

		return std::make_shared<FaceAligner>(
			*task_info.generate_graph_config(false),
			VisionTaskRunningMode::IMAGE,
			nullptr
		);
	}

	std::shared_ptr<Image> FaceAligner::align(
		const Image& image,
		std::shared_ptr<ImageProcessingOptions> image_processing_options
	) {
		auto normalized_rect = convert_to_normalized_rect(image_processing_options, image);

		auto output_packets = _process_image_data({
			{ _IMAGE_IN_STREAM_NAME, std::move(*std::move(create_image(image))) },
			{ _NORM_RECT_STREAM_NAME, std::move(*std::move(create_proto(*normalized_rect.to_pb2()))) },
			});

		const auto& aligned_image_packet = output_packets.at(_FACE_ALIGNMENT_IMAGE_NAME);
		if (aligned_image_packet.IsEmpty()) {
			return std::shared_ptr<Image>();
		}

		const auto& stylized_image = GetContent<Image>(aligned_image_packet);
		return ::autoit::reference_internal(&stylized_image);
	}
}
