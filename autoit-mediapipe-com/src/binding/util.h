#pragma once

#include "mediapipe/framework/calculator.pb.h"
#include "mediapipe/framework/port/file_helpers.h"
#include "mediapipe/framework/port/status.h"
#include "mediapipe/framework/timestamp.h"

#include "autoit_bridge_common.h"

namespace mediapipe {
	namespace autoit {
		inline std::string StatusCodeToAutoItError(const ::absl::StatusCode& code) {
			switch (code) {
			case absl::StatusCode::kInvalidArgument:
				return "Invalid argument";
			case absl::StatusCode::kAlreadyExists:
				return "File already exists";
			case absl::StatusCode::kUnimplemented:
				return "Not implemented";
			default:
				return "Runtime error";
			}
		}

		inline void RaiseAutoItErrorIfNotOk(const absl::Status& status) {
			AUTOIT_ASSERT_THROW(status.ok(), StatusCodeToAutoItError(status.code()) << ": " << status.message().data());
		}

		inline void RaiseAutoItErrorIfOverflow(int64 value, int64 min, int64 max) {
			if (value > max) {
				AUTOIT_THROW(value << " execeeds the maximum value (" << max << ") the data type can have.");
			}
			else if (value < min) {
				AUTOIT_THROW(value << " goes below the minimum value (" << min << ") the data type can have.");
			}
		}

		inline std::string TimestampValueString(const Timestamp& timestamp) {
			if (timestamp == Timestamp::Unset()) {
				return "UNSET";
			}
			else if (timestamp == Timestamp::Unstarted()) {
				return "UNSTARTED";
			}
			else if (timestamp == Timestamp::PreStream()) {
				return "PRESTREAM";
			}
			else if (timestamp == Timestamp::Min()) {
				return "MIN";
			}
			else if (timestamp == Timestamp::Max()) {
				return "MAX";
			}
			else if (timestamp == Timestamp::PostStream()) {
				return "POSTSTREAM";
			}
			else if (timestamp == Timestamp::OneOverPostStream()) {
				return "ONEOVERPOSTSTREAM";
			}
			else if (timestamp == Timestamp::Done()) {
				return "DONE";
			}
			else {
				return timestamp.DebugString();
			}
		}

		// Reads a CalculatorGraphConfig from a file. If failed, raises an AutoItError.
		inline ::mediapipe::CalculatorGraphConfig ReadCalculatorGraphConfigFromFile(const std::string& file_name) {
			::mediapipe::CalculatorGraphConfig graph_config_proto;
			auto status = file::Exists(file_name);
			AUTOIT_ASSERT_THROW(status.ok(), "File not found: " << status.message().data());

			std::string graph_config_string;
			RaiseAutoItErrorIfNotOk(file::GetContents(file_name, &graph_config_string, /*read_as_binary=*/true));
			if (!graph_config_proto.ParseFromArray(graph_config_string.c_str(), graph_config_string.length())) {
				AUTOIT_THROW("Failed to parse the binary graph: " << file_name);
			}
			return graph_config_proto;
		}

		template <typename T>
		inline T ParseProto(const std::string& proto_str) {
			T proto;
			AUTOIT_ASSERT_THROW(ParseTextProto<T>(proto_str, &proto), "Failed to parse: " << proto_str);
			return proto;
		}

		template <typename T>
		inline auto AssertAutoItValue(const T& wrapper) {
			RaiseAutoItErrorIfNotOk(wrapper.status());
			return wrapper.value();
		}
	}
}
