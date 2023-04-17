#pragma once

#include "mediapipe/tasks/cc/core/proto/base_options.pb.h"
#include "mediapipe/tasks/cc/core/proto/external_file.pb.h"

namespace mediapipe::tasks::autoit::core::base_options {
	struct CV_EXPORTS_W_SIMPLE BaseOptions {
		CV_WRAP BaseOptions(const BaseOptions& other) = default;
		BaseOptions& operator=(const BaseOptions& other) = default;

		CV_WRAP BaseOptions(
			const std::string& model_asset_path = "",
			const std::string& model_asset_buffer = ""
		) : model_asset_path(model_asset_path), model_asset_buffer(model_asset_buffer) {}

		CV_WRAP std::shared_ptr<mediapipe::tasks::core::proto::BaseOptions> to_pb2();
		CV_WRAP static std::shared_ptr<BaseOptions> create_from_pb2(const mediapipe::tasks::core::proto::BaseOptions& pb2_obj);

		CV_PROP_RW std::string model_asset_path;
		CV_PROP_RW std::string model_asset_buffer;
	};
}
