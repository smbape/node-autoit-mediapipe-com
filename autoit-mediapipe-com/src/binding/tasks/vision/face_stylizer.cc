#include "mediapipe/framework/port/status_macros.h"
#include "binding/tasks/vision/face_stylizer.h"

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
	absl::StatusOr<std::shared_ptr<FaceStylizerGraphOptions>> FaceStylizerOptions::to_pb2() const {
		auto pb2_obj = std::make_shared<FaceStylizerGraphOptions>();

		if (base_options) {
			MP_ASSIGN_OR_RETURN(auto base_options_proto, base_options->to_pb2());
			pb2_obj->mutable_base_options()->CopyFrom(*base_options_proto);
		}

		return pb2_obj;
	}

	absl::StatusOr<std::shared_ptr<FaceStylizer>> FaceStylizer::create(
		const CalculatorGraphConfig& graph_config,
		VisionTaskRunningMode running_mode,
		mediapipe::autoit::PacketsCallback packet_callback
	) {
		using BaseVisionTaskApi = core::base_vision_task_api::BaseVisionTaskApi;
		return BaseVisionTaskApi::create(graph_config, running_mode, std::move(packet_callback), static_cast<FaceStylizer*>(nullptr));
	}

	absl::StatusOr<std::shared_ptr<FaceStylizer>> FaceStylizer::create_from_model_path(const std::string& model_path) {
		auto base_options = std::make_shared<BaseOptions>(model_path);
		return create_from_options(std::make_shared<FaceStylizerOptions>(base_options));
	}

	absl::StatusOr<std::shared_ptr<FaceStylizer>> FaceStylizer::create_from_options(std::shared_ptr<FaceStylizerOptions> options) {
		TaskInfo task_info;
		task_info.task_graph = _TASK_GRAPH_NAME;
		*task_info.input_streams = {
			_IMAGE_TAG + ":" + _IMAGE_IN_STREAM_NAME,
			_NORM_RECT_TAG + ":" + _NORM_RECT_STREAM_NAME
		};
		*task_info.output_streams = {
			_STYLIZED_IMAGE_TAG + ":" + _STYLIZED_IMAGE_NAME,
			_IMAGE_TAG + ":" + _IMAGE_OUT_STREAM_NAME
		};
		MP_ASSIGN_OR_RETURN(task_info.task_options, options->to_pb2());

		MP_ASSIGN_OR_RETURN(auto config, task_info.generate_graph_config());

		return create(
			*config,
			VisionTaskRunningMode::IMAGE
		);
	}

	absl::StatusOr<std::shared_ptr<Image>> FaceStylizer::stylize(
		const Image& image,
		std::shared_ptr<ImageProcessingOptions> image_processing_options
	) {
		MP_ASSIGN_OR_RETURN(auto normalized_rect, convert_to_normalized_rect(image_processing_options, image));

		MP_ASSIGN_OR_RETURN(auto output_packets, _process_image_data({
			{ _IMAGE_IN_STREAM_NAME, std::move(*std::move(create_image(image))) },
			{ _NORM_RECT_STREAM_NAME, std::move(*std::move(create_proto(*normalized_rect.to_pb2()))) },
			}));

		const auto& stylized_image_packet = output_packets.at(_STYLIZED_IMAGE_NAME);
		if (stylized_image_packet.IsEmpty()) {
			return std::shared_ptr<Image>();
		}

		MP_PACKET_ASSIGN_OR_RETURN(const auto& stylized_image, Image, stylized_image_packet);
		return ::autoit::reference_internal(&stylized_image);
	}
}
