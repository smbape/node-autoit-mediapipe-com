#pragma once

#include "mediapipe/tasks/cc/components/containers/classification_result.h"
#include "binding/tasks/components/containers/category.h"
#include "binding/tasks/components/containers/utils.h"

namespace mediapipe::tasks::components::containers {
	inline bool operator==(const Classifications& lhs, const Classifications& rhs) {
		return lhs.categories == rhs.categories
			&& lhs.head_index == rhs.head_index
			&& is_optional_equal(lhs.head_name, rhs.head_name);
	}

	proto::Classifications ConvertClassificationsToProto(Classifications* classifications);

	proto::ClassificationResult ConvertClassificationResultToProto(ClassificationResult* classification_result);

	inline bool operator==(const ClassificationResult& lhs, const ClassificationResult& rhs) {
		return lhs.classifications == rhs.classifications
			&& is_optional_equal(lhs.timestamp_ms, rhs.timestamp_ms);
	}

	void CppConvertToClassificationsList(const std::vector<std::vector<Category>>& classifications_result, std::vector<Classifications>& classifications_list, HRESULT& hr);

	void CppConvertToClassificationsList(VARIANT* in_val, std::vector<Classifications>& classifications_list, HRESULT& hr);

	std::vector<std::vector<Category>> CppConvertToClassificationsResult(std::vector<Classifications>& classifications_list);

	void CppConvertToClassificationsList(const std::optional<std::vector<std::vector<Category>>>& classifications_result, std::optional<std::vector<Classifications>>& classifications_list, HRESULT& hr);

	void CppConvertToClassificationsList(VARIANT* in_val, std::optional<std::vector<Classifications>>& classifications_list, HRESULT& hr);

	std::optional<std::vector<std::vector<Category>>> CppConvertToClassificationsResult(std::optional<std::vector<Classifications>>& classifications_list);

}  // namespace mediapipe::tasks::components::containers

namespace std {
	inline std::string to_string(const mediapipe::tasks::components::containers::Classifications& classifications) {
		auto proto = mediapipe::tasks::components::containers::ConvertClassificationsToProto(const_cast<mediapipe::tasks::components::containers::Classifications*>(&classifications));
		std::string output;
		if (!google::protobuf::TextFormat::PrintToString(proto, &output)) {
			output = "Failed to print message";
		}
		return output;
	}

	inline std::string to_string(const mediapipe::tasks::components::containers::ClassificationResult& classification_result) {
		auto proto = mediapipe::tasks::components::containers::ConvertClassificationResultToProto(const_cast<mediapipe::tasks::components::containers::ClassificationResult*>(&classification_result));
		std::string output;
		if (!google::protobuf::TextFormat::PrintToString(proto, &output)) {
			output = "Failed to print message";
		}
		return output;
	}
}
