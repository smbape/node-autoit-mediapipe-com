#include "autoit_bridge.h"
#include "binding/calculator_graph.h"
#include "binding/message.h"
#include "binding/repeated_container.h"
#include "binding/resource_util.h"
#include "binding/util.h"
#include "mediapipe/calculators/core/constant_side_packet_calculator.pb.h"
#include "mediapipe/calculators/image/image_transformation_calculator.pb.h"
#include "mediapipe/calculators/tensor/tensors_to_detections_calculator.pb.h"
#include "mediapipe/calculators/util/landmarks_smoothing_calculator.pb.h"
#include "mediapipe/calculators/util/logic_calculator.pb.h"
#include "mediapipe/calculators/util/thresholding_calculator.pb.h"
#include "mediapipe/modules/objectron/calculators/lift_2d_frame_annotation_to_3d_calculator.pb.h"
#include "Mediapipe_Autoit_Packet_creator_Object.h"
#include "Cv_Mat_Object.h"

#ifdef BOOL
#undef BOOL
#endif
#ifdef INT
#undef INT
#endif
#ifdef FLOAT
#undef FLOAT
#endif

using namespace google::protobuf::autoit::cmessage;
using namespace google::protobuf;
using namespace mediapipe::autoit::packet_getter;

// A mutex to guard the output stream observer autoit callback function.
// Only one autoit callback can run at once.
static absl::Mutex callback_mutex;

namespace {
	inline const bool startsWith(const std::string& s, const std::string& prefix) {
		return s.size() >= prefix.size() && s.compare(0, prefix.size(), prefix) == 0;
	}

	inline const bool startsWith(const std::string_view& s, const std::string_view& prefix) {
		return s.size() >= prefix.size() && s.compare(0, prefix.size(), prefix) == 0;
	}

	inline const bool endsWith(const std::string& s, const std::string& suffix) {
		return s.size() >= suffix.size() && s.compare(s.size() - suffix.size(), suffix.size(), suffix) == 0;
	}

	inline const bool endsWith(const std::string_view& s, const std::string_view& suffix) {
		return s.size() >= suffix.size() && s.compare(s.size() - suffix.size(), suffix.size(), suffix) == 0;
	}

	inline const size_t len(const std::string& str) {
		return str.length();
	}

	const std::string WHITESPACE = " \n\r\t\f\v";

	inline std::string trim(const std::string& s) {
		size_t start = s.find_first_not_of(WHITESPACE);
		size_t end = s.find_last_not_of(WHITESPACE);
		if (start == std::string::npos || end == std::string::npos) {
			return "";
		}
		return s.substr(start, end + 1);
	}

	inline std::vector<std::string> split(const std::string& s, const std::string& delimiter, bool trim_ = true) {
		size_t pos_start = 0;
		size_t delim_len = delimiter.length();
		size_t pos_end;
		std::string token;
		std::vector<std::string> res;

		while ((pos_end = s.find(delimiter, pos_start)) != std::string::npos) {
			token = s.substr(pos_start, pos_end - pos_start);
			pos_start = pos_end + delim_len;
			res.push_back(trim_ ? trim(token) : token);
		}

		res.push_back(s.substr(pos_start));
		return res;
	}
}

using RepeatedContainer = google::protobuf::autoit::RepeatedContainer;

#define StringifyPacketDataType(enum_value) PacketDataTypeToChar[static_cast<int>(enum_value)]

namespace {
	using namespace mediapipe::autoit::solution_base;
	using namespace mediapipe::autoit;
	using namespace mediapipe;

	using OptionsFieldList = std::vector<std::pair<std::string, _variant_t>>;
	using MapOfStringAndOptionsFieldList = std::map<std::string, OptionsFieldList>;

	const _variant_t None = default_variant();
	const std::map<std::string, _variant_t> _noneMap;
	const std::map<std::string, PacketDataType> _noneTypeMap;
	const std::vector<std::string> _noneVector;

	const std::map<std::string, PacketDataType> NAME_TO_TYPE = {
		{"string", PacketDataType::STRING},
		{"bool", PacketDataType::BOOL},
		{"::std::vector<bool>", PacketDataType::BOOL_LIST},
		{"int", PacketDataType::INT},
		{"::std::vector<int>", PacketDataType::INT_LIST},
		{"int64", PacketDataType::INT},
		{"int64_t", PacketDataType::INT},
		{"::std::vector<int64>", PacketDataType::INT_LIST},
		{"::std::vector<int64_t>", PacketDataType::INT_LIST},
		{"float", PacketDataType::FLOAT},
		{"::std::vector<float>", PacketDataType::FLOAT_LIST},
		{"::mediapipe::Matrix", PacketDataType::AUDIO},
		{"::mediapipe::ImageFrame", PacketDataType::IMAGE_FRAME},
		{"::mediapipe::Classification", PacketDataType::PROTO},
		{"::mediapipe::ClassificationList", PacketDataType::PROTO},
		{"::mediapipe::ClassificationListCollection", PacketDataType::PROTO},
		{"::mediapipe::Detection", PacketDataType::PROTO},
		{"::mediapipe::DetectionList", PacketDataType::PROTO},
		{"::mediapipe::Landmark", PacketDataType::PROTO},
		{"::mediapipe::LandmarkList", PacketDataType::PROTO},
		{"::mediapipe::LandmarkListCollection", PacketDataType::PROTO},
		{"::mediapipe::NormalizedLandmark", PacketDataType::PROTO},
		{"::mediapipe::FrameAnnotation", PacketDataType::PROTO},
		{"::mediapipe::Trigger", PacketDataType::PROTO},
		{"::mediapipe::Rect", PacketDataType::PROTO},
		{"::mediapipe::NormalizedRect", PacketDataType::PROTO},
		{"::mediapipe::NormalizedLandmarkList", PacketDataType::PROTO},
		{"::mediapipe::NormalizedLandmarkListCollection", PacketDataType::PROTO},
		{"::mediapipe::Image", PacketDataType::IMAGE},
		{"::std::vector<::mediapipe::Image>", PacketDataType::IMAGE_LIST},
		{"::std::vector<::mediapipe::Classification>", PacketDataType::PROTO_LIST},
		{"::std::vector<::mediapipe::ClassificationList>", PacketDataType::PROTO_LIST},
		{"::std::vector<::mediapipe::Detection>", PacketDataType::PROTO_LIST},
		{"::std::vector<::mediapipe::DetectionList>", PacketDataType::PROTO_LIST},
		{"::std::vector<::mediapipe::Landmark>", PacketDataType::PROTO_LIST},
		{"::std::vector<::mediapipe::LandmarkList>", PacketDataType::PROTO_LIST},
		{"::std::vector<::mediapipe::NormalizedLandmark>", PacketDataType::PROTO_LIST},
		{"::std::vector<::mediapipe::NormalizedLandmarkList>", PacketDataType::PROTO_LIST},
		{"::std::vector<::mediapipe::Rect>", PacketDataType::PROTO_LIST},
		{"::std::vector<::mediapipe::NormalizedRect>", PacketDataType::PROTO_LIST},
		{"::mediapipe::Joint", PacketDataType::PROTO},
		{"::mediapipe::JointList", PacketDataType::PROTO},
		{"::std::vector<::mediapipe::JointList>", PacketDataType::PROTO_LIST},
	};

	inline std::vector<std::string> TypeNamesFromOneOf(const std::string& oneof_type_name) {
		if (startsWith(oneof_type_name, "OneOf<") && endsWith(oneof_type_name, ">")) {
			return split(oneof_type_name.substr(len("OneOf<"), oneof_type_name.length() - len(">")), ",");
		}
		return std::vector<std::string>();
	}

	inline const [[nodiscard]] absl::StatusOr<PacketDataType> FromRegisteredName(const std::string& registered_name) {
		if (NAME_TO_TYPE.count(registered_name)) {
			return NAME_TO_TYPE.at(registered_name);
		}

		const auto names = TypeNamesFromOneOf(registered_name);
		for (const auto& name : names) {
			if (NAME_TO_TYPE.count(name)) {
				return NAME_TO_TYPE.at(name);
			}
		}

		MP_ASSERT_RETURN_IF_ERROR(false, "Unregistered stream packet type");
	}

	/**
	 * Gets name from a 'TAG:index:name' str.
	 * @param  tag_index_name
	 * @return
	 */
	inline std::string GetName(const std::string& tag_index_name) {
		auto const pos = tag_index_name.find_last_of(':');
		return std::string::npos == pos ? tag_index_name : tag_index_name.substr(pos + 1);
	}

	/**
	 * Gets the packet type information of the input streams and output streams
	 * from the user provided stream_type_hints field or validated calculator
	 * graph. The mappings from the stream names to the packet data types is
	 * for deciding which packet creator and getter methods to call in the
	 * process() method.
	 * @param  validated_graph
	 * @param  packet_tag_index_name
	 * @param  stream_type_hints
	 * @return
	 */
	inline const [[nodiscard]] absl::StatusOr<PacketDataType> GetStreamPacketType(
		ValidatedGraphConfig& validated_graph,
		const std::string& packet_tag_index_name,
		const std::map<std::string, PacketDataType>& stream_type_hints
	) {
		auto stream_name = GetName(packet_tag_index_name);
		if (stream_type_hints.count(stream_name)) {
			return stream_type_hints.at(stream_name);
		}

		MP_ASSIGN_OR_RETURN(auto stream_type_name, validated_graph.RegisteredStreamTypeName(stream_name));
		return FromRegisteredName(stream_type_name);
	}

	/**
	 * Gets the packet type information of the input side packets from the
	 * validated calculator graph. The mappings from the side packet names to the
	 * packet data types is for making the input_side_packets dict for graph
	 * start_run().
	 * @param  validated_graph
	 * @param  packet_tag_index_name
	 * @return
	 */
	inline absl::StatusOr<PacketDataType> GetSidePacketType(
		ValidatedGraphConfig& validated_graph,
		const std::string& packet_tag_index_name
	) {
		auto stream_name = GetName(packet_tag_index_name);

		MP_ASSIGN_OR_RETURN(auto stream_type_name, validated_graph.RegisteredSidePacketTypeName(stream_name));
		return FromRegisteredName(stream_type_name);
	}

	/**
	 * Reorganizes the calculator options field data by calculator name and puts
	 * all the field data of the same calculator in a list.
	 */
	inline absl::StatusOr<MapOfStringAndOptionsFieldList> GenerateNestedCalculatorParams(const std::map<std::string, _variant_t>& flat_map) {
		MapOfStringAndOptionsFieldList nested_map;

		for (auto const& [compound_name, field_value] : flat_map) {
			auto calculator_and_field_name = split(compound_name, ".", false);
			MP_ASSERT_RETURN_IF_ERROR(calculator_and_field_name.size() == 2, "The key '" << compound_name << "' in the calculator_params is invalid.");

			auto calculator_name = calculator_and_field_name[0];
			auto field_name = calculator_and_field_name[1];

			if (!nested_map.count(calculator_name)) {
				nested_map.insert_or_assign(calculator_name, OptionsFieldList());
			}

			nested_map.at(calculator_name).push_back({ field_name, field_value });
		}

		return nested_map;
	}

	[[nodiscard]] absl::Status ModifyOptionsFields(Message& calculator_options, const OptionsFieldList& options_field_list) {
		const auto descriptor = calculator_options.GetDescriptor();

		for (auto const& [field_name, field_value] : options_field_list) {
			if (PARAMETER_MISSING(&field_value)) {
				MP_RETURN_IF_ERROR(ClearField(calculator_options, field_name));
				continue;
			}

			const auto field_descriptor = FindFieldWithOneofs(calculator_options, field_name, descriptor);
			MP_ASSERT_RETURN_IF_ERROR(field_descriptor, "Field '" << field_name << "' does not belong to message '" << descriptor->full_name() << "'");

			if (!field_descriptor->is_repeated()) {
				MP_RETURN_IF_ERROR(SetFieldValue(calculator_options, field_descriptor, field_value).status());
				return absl::OkStatus();
			}

			std::vector<_variant_t> field_value_vector;
			HRESULT hr = autoit_to(&field_value, field_value_vector);

			MP_ASSERT_RETURN_IF_ERROR(SUCCEEDED(hr), field_name << " is a repeated proto field but the value "
				"to be set is " << V_VT(&field_value) << ", which is not iterable.");

			// TODO: Support resetting the entire repeated field
			// (array-option) and changing the individual values in the repeated
			// field (array-element-option).
			MP_RETURN_IF_ERROR(ClearField(calculator_options, field_name));

			RepeatedContainer repeated_container;
			repeated_container.message = ::autoit::reference_internal(&calculator_options);
			repeated_container.field_descriptor = ::autoit::reference_internal(field_descriptor);

			for (auto& value : field_value_vector) {
				MP_RETURN_IF_ERROR(repeated_container.Append(value));
			}
		}

		return absl::OkStatus();
	}

	template<typename OptionsType>
	[[nodiscard]] absl::Status ModifyCalculatorOption(
		const MapOfStringAndOptionsFieldList& nested_calculator_params,
		CalculatorGraphConfig::Node& node
	) {
		const auto& options_field_list = nested_calculator_params.at(node.name());
		MP_ASSIGN_OR_RETURN(auto node_has_options, HasField(node, "options"));

		if (node.node_options_size() > 0) {
			MP_ASSERT_RETURN_IF_ERROR(!node_has_options, "Cannot modify the calculator options of " << node.name() << " because it "
				"has both options and node_options fields.");

			// The "node_options" case for the proto3 syntax.
			bool node_options_modified = false;
			size_t pos_end;
			std::string_view type_name;
			for (auto& elem : *node.mutable_node_options()) {
				const std::string& type_url = elem.type_url();
				pos_end = type_url.find_last_of('/');
				type_name = std::string_view(type_url).substr(pos_end == std::string::npos ? 0 : pos_end + 1);
				if (type_name != OptionsType::GetDescriptor()->full_name()) {
					continue;
				}

				OptionsType calculator_options;
				MP_RETURN_IF_ERROR(MergeFromString(&calculator_options, elem.value()));
				MP_RETURN_IF_ERROR(ModifyOptionsFields(calculator_options, options_field_list));
				std::string serialized;
				calculator_options.SerializeToString(&serialized);
				elem.set_value(std::move(serialized));
				node_options_modified = true;
				break;
			}

			// There is no existing node_options being modified. Add a new
			// node_options instead.
			if (!node_options_modified) {
				OptionsType calculator_options;
				MP_RETURN_IF_ERROR(ModifyOptionsFields(calculator_options, options_field_list));
				auto* new_node_options = node.add_node_options();
				new_node_options->PackFrom(calculator_options);
			}
		}
		else if (node_has_options) {
			// The "options" case for the proto2 syntax
			OptionsType* calculator_options = node.mutable_options()->MutableExtension(OptionsType::ext);
			MP_RETURN_IF_ERROR(ModifyOptionsFields(*calculator_options, options_field_list));
		}

		return absl::OkStatus();
	}

	/**
	 * Modifies the CalculatorOptions of the calculators listed in calculator_params.
	 * @param calculator_graph_config [description]
	 * @param calculator_params       [description]
	 */
	[[nodiscard]] absl::Status ModifyCalculatorOptions(
		CalculatorGraphConfig& calculator_graph_config,
		const std::map<std::string, _variant_t>& calculator_params
	) {
		MP_ASSIGN_OR_RETURN(auto nested_calculator_params, GenerateNestedCalculatorParams(calculator_params));

		int num_calculator_params = nested_calculator_params.size();
		for (CalculatorGraphConfig::Node& node : *calculator_graph_config.mutable_node()) {
			if (!nested_calculator_params.count(node.name())) {
				continue;
			}

			const std::string_view calculator(node.calculator());

			// TODO: Enable calculator options modification for more calculators.
			if (calculator == "ConstantSidePacketCalculator") {
				MP_RETURN_IF_ERROR(ModifyCalculatorOption<ConstantSidePacketCalculatorOptions>(nested_calculator_params, node));
			}
			else if (calculator == "ImageTransformationCalculator") {
				MP_RETURN_IF_ERROR(ModifyCalculatorOption<ImageTransformationCalculatorOptions>(nested_calculator_params, node));
			}
			else if (calculator == "LandmarksSmoothingCalculator") {
				MP_RETURN_IF_ERROR(ModifyCalculatorOption<LandmarksSmoothingCalculatorOptions>(nested_calculator_params, node));
			}
			else if (calculator == "LogicCalculator") {
				MP_RETURN_IF_ERROR(ModifyCalculatorOption<LogicCalculatorOptions>(nested_calculator_params, node));
			}
			else if (calculator == "ThresholdingCalculator") {
				MP_RETURN_IF_ERROR(ModifyCalculatorOption<ThresholdingCalculatorOptions>(nested_calculator_params, node));
			}
			else if (calculator == "TensorsToDetectionsCalculator") {
				MP_RETURN_IF_ERROR(ModifyCalculatorOption<TensorsToDetectionsCalculatorOptions>(nested_calculator_params, node));
			}
			else if (calculator == "Lift2DFrameAnnotationTo3DCalculator") {
				MP_RETURN_IF_ERROR(ModifyCalculatorOption<Lift2DFrameAnnotationTo3DCalculatorOptions>(nested_calculator_params, node));
			}
			else {
				MP_ASSERT_RETURN_IF_ERROR(false, "Modifying the calculator options of " << node.name() << " is not supported.");
			}

			if (--num_calculator_params == 0) {
				break;
			}
		}

		MP_ASSERT_RETURN_IF_ERROR(num_calculator_params == 0, "Not all calculator params are valid.");

		return absl::OkStatus();
	}

	inline bool InternalIs(const Any& self, const std::string_view type_name) {
		const std::string_view type_url(self.type_url());
		return type_url.size() >= type_name.size() + 1 &&
			type_url[type_url.size() - type_name.size() - 1] == '/' &&
			endsWith(type_url, type_name);
	}

	/**
	 * Sets one value in a repeated protobuf.Any extension field.
	 */
	inline void SetExtension(RepeatedPtrField<Any>* extension_list,
		const std::shared_ptr<google::protobuf::Message>& extension_value) {
		const std::string_view type_name(extension_value->GetDescriptor()->full_name());
		for (auto& extension_any : *extension_list) {
			if (!InternalIs(extension_any, type_name)) {
				continue;
			}

			std::unique_ptr<Message> sub_message(extension_value->New(nullptr));
			extension_any.UnpackTo(sub_message.get());
			sub_message->MergeFrom(*extension_value);
			extension_any.PackFrom(*sub_message);
			return;
		}

		extension_list->Add()->PackFrom(*extension_value);
	}

	[[nodiscard]] absl::StatusOr<std::shared_ptr<Packet>> MakePacket(
		PacketDataType packet_data_type,
		const _variant_t& data
	) {
		static CMediapipe_Autoit_Packet_creator_Object* pPacket_creator = nullptr;

		if (pPacket_creator == nullptr) {
			HRESULT hr = CoCreateInstance(
				CLSID_Mediapipe_Autoit_Packet_creator_Object,
				NULL,
				CLSCTX_INPROC_SERVER,
				IID_IMediapipe_Autoit_Packet_creator_Object,
				reinterpret_cast<void**>(&pPacket_creator)
			);

			MP_ASSERT_RETURN_IF_ERROR(SUCCEEDED(hr), "Failed to create a packet_creator instance");
		}

		static _variant_t image_format = None;
		static _variant_t copy_image = None;
		static VARIANT* v_image_format = &image_format;
		static VARIANT* v_copy_image = &copy_image;

		VARIANT* in_val = const_cast<VARIANT*>(static_cast<const VARIANT*>(&data));
		_variant_t _retval_var;
		VARIANT* _retval = &_retval_var;
		HRESULT hr;

		switch (packet_data_type) {
		case PacketDataType::STRING:
			hr = pPacket_creator->create_string(in_val, _retval);
			break;
		case PacketDataType::BOOL:
			hr = pPacket_creator->create_bool(in_val, _retval);
			break;
		case PacketDataType::BOOL_LIST:
			hr = pPacket_creator->create_bool_vector(in_val, _retval);
			break;
		case PacketDataType::INT:
			hr = pPacket_creator->create_int(in_val, _retval);
			break;
		case PacketDataType::INT_LIST:
			hr = pPacket_creator->create_int_vector(in_val, _retval);
			break;
		case PacketDataType::FLOAT:
			hr = pPacket_creator->create_float(in_val, _retval);
			break;
		case PacketDataType::FLOAT_LIST:
			hr = pPacket_creator->create_float_vector(in_val, _retval);
			break;
		case PacketDataType::IMAGE:
			hr = pPacket_creator->create_image(in_val, v_image_format, v_copy_image, _retval);
			break;
		case PacketDataType::IMAGE_FRAME:
			hr = pPacket_creator->create_image_frame(in_val, v_image_format, v_copy_image, _retval);
			break;
		case PacketDataType::IMAGE_LIST:
			hr = pPacket_creator->create_image_vector(in_val, _retval);
			break;
		case PacketDataType::PROTO:
			hr = pPacket_creator->create_proto(in_val, _retval);
			break;
		default:
			MP_ASSERT_RETURN_IF_ERROR(false, "create packet data type " << StringifyPacketDataType(packet_data_type) << " is not implemented");
		}

		ExtendedHolder::SetLength(0); // clear reference to packet in extended holder

		MP_ASSERT_RETURN_IF_ERROR(SUCCEEDED(hr), "failed to create a " << StringifyPacketDataType(packet_data_type) << " packet");
		const auto& pPacket = static_cast<CMediapipe_Packet_Object*>(V_DISPATCH(_retval));
		return *pPacket->__self; // copy the pointer
	}

	[[nodiscard]] absl::StatusOr<_variant_t> GetPacketContent(PacketDataType packet_data_type, const Packet& output_packet) {
		if (output_packet.IsEmpty()) {
			return None;
		}

		_variant_t result;
		VARIANT* _retval = &result;
		HRESULT hr;

		switch (packet_data_type) {
		case PacketDataType::STRING: {
			MP_PACKET_ASSIGN_OR_RETURN(const auto& string_value, std::string, output_packet);
			hr = autoit_from(string_value, _retval);
			break;
		}
		case PacketDataType::BOOL: {
			MP_PACKET_ASSIGN_OR_RETURN(const auto& bool_value, bool, output_packet);
			hr = autoit_from(bool_value, _retval);
			break;
		}
		case PacketDataType::BOOL_LIST: {
			MP_PACKET_ASSIGN_OR_RETURN(const auto& bool_list, std::vector<bool>, output_packet);
			hr = autoit_from(bool_list, _retval);
			break;
		}
		case PacketDataType::INT:
			hr = autoit_from(get_int(output_packet), _retval);
			break;
		case PacketDataType::INT_LIST:
			hr = autoit_from(get_int_list(output_packet), _retval);
			break;
		case PacketDataType::FLOAT:
			hr = autoit_from(get_float(output_packet), _retval);
			break;
		case PacketDataType::FLOAT_LIST:
			hr = autoit_from(get_float_list(output_packet), _retval);
			break;
		case PacketDataType::IMAGE: {
			MP_PACKET_ASSIGN_OR_RETURN(const auto& image, Image, output_packet);
			hr = autoit_from(mediapipe::formats::MatView(image.GetImageFrameSharedPtr().get()).clone(), _retval);
			break;
		}
		case PacketDataType::IMAGE_FRAME: {
			MP_PACKET_ASSIGN_OR_THROW(const auto& image_frame, ImageFrame, output_packet);
			hr = autoit_from(mediapipe::formats::MatView(&image_frame).clone(), _retval);
			break;
		}
		case PacketDataType::IMAGE_LIST: {
			MP_PACKET_ASSIGN_OR_RETURN(const auto& image_list, std::vector<Image>, output_packet);
			std::vector<cv::Mat> mat_list;
			mat_list.resize(image_list.size());
			int i = 0;
			for (const auto& image : image_list) {
				mat_list[i++] = mediapipe::formats::MatView(image.GetImageFrameSharedPtr().get());
			}
			hr = autoit_from(image_list, _retval);
			break;
		}
		case PacketDataType::PROTO:
			hr = autoit_from(get_proto(output_packet), _retval);
			break;
		case PacketDataType::PROTO_LIST: {
			std::vector<std::shared_ptr<Message>> proto_list;
			MP_RETURN_IF_ERROR(get_proto_list(output_packet, proto_list));
			hr = autoit_from(proto_list, _retval);
			break;
		}
		default:
			MP_ASSERT_RETURN_IF_ERROR(false, "get packet content of data type " << StringifyPacketDataType(packet_data_type) << " is not implemented");
		}

		MP_ASSERT_RETURN_IF_ERROR(SUCCEEDED(hr), "failed to get a " << StringifyPacketDataType(packet_data_type) << " packet content");

		return result;
	}

	/**
	 * Gets graph interface type information and returns the canonical graph config proto.
	 * @param  graph_config      [description]
	 * @param  side_inputs       [description]
	 * @param  outputs           [description]
	 * @param  stream_type_hints [description]
	 * @return                   [description]
	 */
	[[nodiscard]] absl::StatusOr<CalculatorGraphConfig> InitializeGraphInterface(
		const CalculatorGraphConfig& graph_config,
		const std::map<std::string, _variant_t>& side_inputs,
		const std::vector<std::string>& outputs,
		const std::map<std::string, PacketDataType>& stream_type_hints,
		std::map<std::string, PacketDataType>& input_stream_type_info,
		std::map<std::string, PacketDataType>& output_stream_type_info,
		std::map<std::string, PacketDataType>& side_input_type_info
	) {
		ValidatedGraphConfig validated_graph;
		MP_RETURN_IF_ERROR(validated_graph.Initialize(graph_config));

		CalculatorGraphConfig canonical_graph_config_proto;
		canonical_graph_config_proto.ParseFromString(validated_graph.Config().SerializeAsString());

		for (const auto& tag_index_name : canonical_graph_config_proto.input_stream()) {
			MP_ASSIGN_OR_RETURN(input_stream_type_info[GetName(tag_index_name)], GetStreamPacketType(validated_graph, tag_index_name, stream_type_hints));
		}

		std::vector<std::string> output_streams;

		if (outputs.empty()) {
			const auto& output_stream = canonical_graph_config_proto.output_stream();
			output_streams = std::vector<std::string>(output_stream.begin(), output_stream.end());
		}
		else {
			output_streams = outputs;
		}

		for (const auto& tag_index_name : output_streams) {
			MP_ASSIGN_OR_RETURN(output_stream_type_info[GetName(tag_index_name)], GetStreamPacketType(validated_graph, tag_index_name, stream_type_hints));
		}

		for (auto it = side_inputs.begin(); it != side_inputs.end(); ++it) {
			const auto& tag_index_name = it->first;
			MP_ASSIGN_OR_RETURN(side_input_type_info[GetName(tag_index_name)], GetSidePacketType(validated_graph, tag_index_name));
		}

		return canonical_graph_config_proto;
	}

	[[nodiscard]] absl::Status _create_graph_options(Message& options_message, const std::map<std::string, _variant_t>& values) {
		for (const auto& [field, value] : values) {
			auto fields = split(field, ".");
			auto m = ::autoit::reference_internal(&options_message);
			auto last = fields.size() - 1;

			for (int i = 0; i < last; i++) {
				MP_ASSIGN_OR_RETURN(auto val, GetFieldValue(*m, fields[i]));
				MP_ASSERT_RETURN_IF_ERROR(SUCCEEDED(autoit_to(&val, m)), "property " << fields[i] << " is not a message");
			}

			const FieldDescriptor* field_descriptor = FindFieldWithOneofs(*m, fields[last]);
			MP_ASSERT_RETURN_IF_ERROR(field_descriptor != nullptr, "Protocol message has no \"" << field << "\" field.");

			if (field_descriptor->is_repeated()) {
				RepeatedContainer autoit_container;
				autoit_container.message = ::autoit::reference_internal(&options_message);
				autoit_container.field_descriptor = ::autoit::reference_internal(field_descriptor);

				std::vector<_variant_t> items;
				MP_ASSERT_RETURN_IF_ERROR(SUCCEEDED(autoit_to(&value, items)), "property " << field << " is not a vector");

				std::vector<_variant_t> list;
				MP_RETURN_IF_ERROR(autoit_container.Splice(list, 0, autoit_container.size()));

				MP_RETURN_IF_ERROR(autoit_container.Extend(items));
			}
			else if (field_descriptor->cpp_type() == FieldDescriptor::CPPTYPE_MESSAGE) {
				std::shared_ptr<Message> other_message;
				MP_ASSERT_RETURN_IF_ERROR(SUCCEEDED(autoit_to(&value, other_message)), "property " << field << " is not a message");
				MP_RETURN_IF_ERROR(CopyFrom(&options_message, other_message.get()));
			}
			else {
				MP_RETURN_IF_ERROR(SetFieldValue(*m, fields[last], value).status());
			}
		}

		return absl::OkStatus();
	}
}

namespace mediapipe::autoit::solution_base {
	const std::map<std::string, _variant_t>& noMap() {
		return _noneMap;
	}

	const std::map<std::string, PacketDataType>& noTypeMap() {
		return _noneTypeMap;
	}

	const std::vector<std::string>& noVector() {
		return _noneVector;
	}

	absl::StatusOr<std::shared_ptr<SolutionBase>> SolutionBase::create(
		const std::string& binary_graph_path,
		const std::map<std::string, _variant_t>& calculator_params,
		const std::shared_ptr<google::protobuf::Message>& graph_options,
		const std::map<std::string, _variant_t>& side_inputs,
		const std::vector<std::string>& outputs,
		const std::map<std::string, PacketDataType>& stream_type_hints
	) {
		CalculatorGraphConfig graph_config;
		MP_RETURN_IF_ERROR(ReadCalculatorGraphConfigFromFile(GetResourcePath(binary_graph_path), graph_config));
		return create(
			graph_config,
			calculator_params,
			graph_options,
			side_inputs,
			outputs,
			stream_type_hints
		);
	}

	absl::StatusOr<std::shared_ptr<SolutionBase>> SolutionBase::create(
		const CalculatorGraphConfig& graph_config,
		const std::map<std::string, _variant_t>& calculator_params,
		const std::shared_ptr<google::protobuf::Message>& graph_options,
		const std::map<std::string, _variant_t>& side_inputs,
		const std::vector<std::string>& outputs,
		const std::map<std::string, PacketDataType>& stream_type_hints
	) {
		return create(
			graph_config,
			calculator_params,
			graph_options,
			side_inputs,
			outputs,
			stream_type_hints,
			static_cast<SolutionBase*>(nullptr)
		);
	}

	absl::Status SolutionBase::process(const cv::Mat& input_data, std::map<std::string, _variant_t>& solution_outputs) {
		MP_ASSERT_RETURN_IF_ERROR(m_input_stream_type_info.size() != 0,
			"_input_stream_type_info is None in SolutionBase");
		MP_ASSERT_RETURN_IF_ERROR(m_input_stream_type_info.size() == 1,
			"Can't process single image input since the graph has more than one input streams.");

		_variant_t input_data_variant;
		VARIANT* out_val = &input_data_variant;
		autoit_from(::autoit::reference_internal(&input_data), out_val);
		std::map<std::string, _variant_t> input_dict;
		for (const auto& pair : m_input_stream_type_info) {
			input_dict[pair.first] = input_data_variant;
		}

		return process(input_dict, solution_outputs);
	}

	absl::Status SolutionBase::process(const std::map<std::string, _variant_t>& input_data, std::map<std::string, _variant_t>& solution_outputs) {
		m_graph_outputs.clear();

		// Set the timestamp increment to 33333 us to simulate the 30 fps video
		// input.
		m_simulated_timestamp += 33333;
		const auto simulated_timestamp = Timestamp(m_simulated_timestamp);

		MP_ASSERT_RETURN_IF_ERROR(static_cast<bool>(m_graph),
			"_graph is None in SolutionBase");

		for (auto const& [stream_name, data] : input_data) {
			const auto& input_stream_type = m_input_stream_type_info[stream_name];

			switch (input_stream_type) {
			case PacketDataType::PROTO_LIST:
			case PacketDataType::AUDIO:
				// TODO: Support audio data.
				MP_ASSERT_RETURN_IF_ERROR(false,
					"SolutionBase can only process non-audio and non-proto-list data. "
					<< StringifyPacketDataType(m_input_stream_type_info[stream_name]) <<
					"type is not supported yet."
				);
			}

			MP_ASSIGN_OR_RETURN(auto packet_shared, ::MakePacket(input_stream_type, data));

			MP_ASSERT_RETURN_IF_ERROR(packet_shared.use_count() == 1, "Packet must have a unique holder");
			auto packet = std::move(*packet_shared.get()).At(simulated_timestamp);
			MP_RETURN_IF_ERROR(m_graph->AddPacketToInputStream(stream_name, std::move(packet)));
		}

		MP_RETURN_IF_ERROR(m_graph->WaitUntilIdle());

		// Create a NamedTuple object where the field names are mapping to the graph
		// output stream names.
		MP_ASSERT_RETURN_IF_ERROR(m_output_stream_type_info.size() != 0,
			"_output_stream_type_info is None in SolutionBase");

		solution_outputs.clear();

		for (auto const& [stream_name, packet_data_type] : m_output_stream_type_info) {
			if (m_graph_outputs.count(stream_name)) {
				MP_ASSIGN_OR_RETURN(solution_outputs[stream_name], GetPacketContent(packet_data_type, m_graph_outputs[stream_name]));
			}
			else {
				solution_outputs[stream_name] = None;
			}
		}

		return absl::OkStatus();
	}

	absl::Status SolutionBase::close() {
		MP_ASSERT_RETURN_IF_ERROR(static_cast<bool>(m_graph),
			"Closing SolutionBase._graph which is already None");

		MP_RETURN_IF_ERROR(calculator_graph::close(m_graph.get()));
		m_graph.reset();
		m_input_stream_type_info.clear();
		m_output_stream_type_info.clear();
		return absl::OkStatus();
	}

	absl::Status SolutionBase::reset() {
		if (m_graph) {
			MP_RETURN_IF_ERROR(calculator_graph::close(m_graph.get()));
			MP_RETURN_IF_ERROR(m_graph->StartRun(m_input_side_packets));
		}
		return absl::OkStatus();
	}

	absl::StatusOr<std::shared_ptr<Message>> SolutionBase::create_graph_options(
		std::shared_ptr<Message> options_message,
		const std::map<std::string, _variant_t>& values
	) {
		if (values.count("items")) {
			std::map<std::string, _variant_t> items;
			const auto& value = values.at("items");
			HRESULT hr = autoit_to(&value, items);
			MP_ASSERT_RETURN_IF_ERROR(SUCCEEDED(hr), "items property must be a map<string, _variant_t>");
			MP_RETURN_IF_ERROR(_create_graph_options(*options_message, items));
		}
		else {
			MP_RETURN_IF_ERROR(_create_graph_options(*options_message, values));
		}
		return options_message;
	}

	absl::Status SolutionBase::__init__(
		const CalculatorGraphConfig& graph_config,
		const std::map<std::string, _variant_t>& calculator_params,
		const std::shared_ptr<google::protobuf::Message>& graph_options,
		const std::map<std::string, _variant_t>& side_inputs,
		const std::vector<std::string>& outputs,
		const std::map<std::string, PacketDataType>& stream_type_hints
	) {
		m_graph = std::make_unique<CalculatorGraph>();

		MP_ASSIGN_OR_RETURN(auto canonical_graph_config_proto, InitializeGraphInterface(
			graph_config,
			side_inputs,
			outputs,
			stream_type_hints,
			m_input_stream_type_info,
			m_output_stream_type_info,
			m_side_input_type_info
		));

		if (!calculator_params.empty()) {
			MP_RETURN_IF_ERROR(ModifyCalculatorOptions(canonical_graph_config_proto, calculator_params));
		}

		if (graph_options.get()) {
			SetExtension(canonical_graph_config_proto.mutable_graph_options(), graph_options);
		}

		MP_RETURN_IF_ERROR(m_graph->Initialize(canonical_graph_config_proto));

		for (const auto& stream : m_output_stream_type_info) {
			std::string stream_name = stream.first;

			MP_RETURN_IF_ERROR(m_graph->ObserveOutputStream(
				stream_name,
				std::move([this, stream_name](const Packet& output_packet) {
					absl::MutexLock lock(&callback_mutex);
					m_graph_outputs[stream_name] = output_packet;
					return absl::OkStatus();
				}),
				true
			));
		}

		for (auto const& [name, data] : side_inputs) {
			MP_ASSIGN_OR_RETURN(auto packet_status, ::MakePacket(m_side_input_type_info[name], data));
			m_input_side_packets[name] = *packet_status;
		}

		return m_graph->StartRun(m_input_side_packets);
	}
}
