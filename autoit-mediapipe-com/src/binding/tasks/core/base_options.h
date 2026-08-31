#pragma once

#include "mediapipe/tasks/cc/core/base_options.h"

namespace mediapipe::tasks::core {
	inline bool operator==(const BaseOptions::CpuOptions& lhs, const BaseOptions::CpuOptions& rhs) {
		return true;
	}

	inline bool operator==(const BaseOptions::GpuOptions& lhs, const BaseOptions::GpuOptions& rhs) {
		return lhs.cached_kernel_path == rhs.cached_kernel_path
			&& lhs.serialized_model_dir == rhs.serialized_model_dir
			&& lhs.model_token == rhs.model_token;
	}

	inline bool operator==(const BaseOptions::FileDescriptorMeta& lhs, const BaseOptions::FileDescriptorMeta& rhs) {
		return lhs.fd == rhs.fd
			&& lhs.length == rhs.length
			&& lhs.offset == rhs.offset;
	}

	inline bool operator==(const BaseOptions& lhs, const BaseOptions& rhs) {
		return lhs.model_asset_buffer == rhs.model_asset_buffer
			&& lhs.model_asset_path == rhs.model_asset_path
			&& lhs.delegate == rhs.delegate
			&& lhs.model_asset_descriptor_meta == rhs.model_asset_descriptor_meta
			&& lhs.delegate_options == rhs.delegate_options
			&& lhs.disable_default_service == rhs.disable_default_service
			&& lhs.host_environment == rhs.host_environment
			&& lhs.host_system == rhs.host_system
			&& lhs.host_version == rhs.host_version
			&& lhs.ca_bundle_path == rhs.ca_bundle_path
			&& lhs.app_id == rhs.app_id
			&& lhs.app_version == rhs.app_version;
	}
}

namespace std {
	inline std::string to_string(const mediapipe::tasks::core::BaseOptions& base_options) {
		auto proto = mediapipe::tasks::core::ConvertBaseOptionsToProto(const_cast<mediapipe::tasks::core::BaseOptions*>(&base_options));
		std::string output;
		if (!google::protobuf::TextFormat::PrintToString(proto, &output)) {
			output = "Failed to print message";
		}
		return output;
	}
}
