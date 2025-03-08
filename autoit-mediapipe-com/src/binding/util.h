#pragma once

#include "mediapipe/framework/calculator.pb.h"
#include "mediapipe/framework/calculator.pb.h"
#include "mediapipe/framework/deps/status_macros.h"
#include "mediapipe/framework/port/file_helpers.h"
#include "mediapipe/framework/port/status.h"
#include "mediapipe/framework/timestamp.h"

#include "autoit_bridge_common.h"
#include "absl/status/status.h"
#include "absl/status/statusor.h"

#define MP_THROW_IF_ERROR(status) AUTOIT_ASSERT_THROW(status.ok(), ::mediapipe::autoit::StatusCodeToError(status.code()) << ": " << status.message().data())

#define MP_ASSERT_RETURN_IF_ERROR( expr, _message ) do { if(!!(expr)) ; else { \
	std::ostringstream _out; _out << _message;	\
	auto fmt = "\n%s (%s)\n in %s, file %s, line %d\n";					\
	int sz = std::snprintf(nullptr, 0, fmt, _out.str().c_str(), #expr, AutoIt_Func, __FILE__, __LINE__);	\
	std::vector<char> buf(sz + 1);																			\
	std::sprintf(buf.data(), fmt, _out.str().c_str(), #expr, AutoIt_Func, __FILE__, __LINE__);				\
	return absl::Status(absl::StatusCode::kFailedPrecondition, buf.data()); 								\
} } while(0)

#define MP_ASSIGN_OR_THROW( lhs, rexpr ) auto MP_STATUS_MACROS_IMPL_CONCAT_(_status_or_value_, __LINE__) = (rexpr); \
MP_THROW_IF_ERROR(MP_STATUS_MACROS_IMPL_CONCAT_(_status_or_value_, __LINE__).status()); \
lhs = std::move(MP_STATUS_MACROS_IMPL_CONCAT_(_status_or_value_, __LINE__)).value()

#define MP_RETURN_HR_IF_ERROR( expr ) do {								\
MP_STATUS_MACROS_IMPL_ELSE_BLOCKER_										\
if (mediapipe::status_macro_internal::StatusAdaptorForMacros			\
  	status_macro_internal_adaptor = {(expr), MEDIAPIPE_LOC}) {			\
} else {																\
	absl::Status status = status_macro_internal_adaptor.Consume();		\
	std::ostringstream _out; _out << ::mediapipe::autoit::StatusCodeToError(status.code()) << ": " << status.message().data();	\
	fflush(stdout); fflush(stderr);										\
	fprintf(stderr, "%s (%s)\n in %s, file %s, line %d\n", _out.str().c_str(), #expr, AutoIt_Func, __FILE__, __LINE__);					\
	fflush(stdout); fflush(stderr);										\
	return E_FAIL; 														\
} } while(0)

namespace mediapipe::autoit {
	inline std::string StatusCodeToError(const ::absl::StatusCode& code) {
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

	// Reads a CalculatorGraphConfig from a file.
	[[nodiscard]] inline absl::Status ReadCalculatorGraphConfigFromFile(const std::string& file_name, ::mediapipe::CalculatorGraphConfig& graph_config_proto) {
		auto status = file::Exists(file_name);
		MP_ASSERT_RETURN_IF_ERROR(status.ok(), "File " << file_name << " was not found: " << status.message().data());

		std::string graph_config_string;
		MP_RETURN_IF_ERROR(file::GetContents(file_name, &graph_config_string, /*read_as_binary=*/true));
		if (!graph_config_proto.ParseFromArray(graph_config_string.c_str(), graph_config_string.length())) {
			MP_ASSERT_RETURN_IF_ERROR(false, "Failed to parse the binary graph: " << file_name);
		}

		return absl::OkStatus();
	}

	// Reads a CalculatorGraphConfig from a file.
	inline ::mediapipe::CalculatorGraphConfig ReadCalculatorGraphConfigFromFile(const std::string& file_name) {
		::mediapipe::CalculatorGraphConfig graph_config_proto;
		MP_THROW_IF_ERROR(ReadCalculatorGraphConfigFromFile(file_name, graph_config_proto));
		return graph_config_proto;
	}

	template<typename T>
	[[nodiscard]] inline absl::Status ParseProto(const std::string& proto_str, T& proto) {
		MP_ASSERT_RETURN_IF_ERROR(ParseTextProto<T>(proto_str, &proto), "Failed to parse: " << proto_str);
		return absl::OkStatus();
	}

	inline _variant_t default_variant() {
		_variant_t vtDefault;
		V_VT(&vtDefault) = VT_ERROR;
		V_ERROR(&vtDefault) = DISP_E_PARAMNOTFOUND;
		return vtDefault;
	}

	inline _variant_t null_variant() {
		_variant_t vtNull;
		V_VT(&vtNull) = VT_NULL;
		return vtNull;
	}

	template<typename _Tp>
	inline _variant_t to_variant_t(_Tp in_val) {
		_variant_t out;
		VARIANT* out_val = &out;
		autoit_from(in_val, out_val);
		return out;
	}
}

template<typename Out>
inline const HRESULT autoit_from(const absl::Status& status, const Out& out_val);

template<typename In, typename Out>
const HRESULT autoit_from(const absl::StatusOr<In>& status_or, Out& out_val);
