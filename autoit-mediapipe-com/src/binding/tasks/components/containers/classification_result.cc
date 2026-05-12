#include "binding/tasks/components/containers/classification_result.h"

namespace mediapipe::tasks::components::containers {

	proto::Classifications ConvertClassificationsToProto(Classifications* classifications) {
		proto::Classifications classifications_proto;

		auto* classification_list = classifications_proto.mutable_classification_list();
		for (const auto& category : classifications->categories) {
			classification_list->add_classification()->CopyFrom(ConvertCategoryToProto(const_cast<Category*>(&category)));
		}

		classifications_proto.set_head_index(classifications->head_index);

		if (classifications->head_name) {
			classifications_proto.set_head_name(*classifications->head_name);
		}

		return classifications_proto;
	}

	proto::ClassificationResult ConvertClassificationResultToProto(ClassificationResult* classification_result) {
		proto::ClassificationResult classification_result_proto;

		for (const auto& classifications : classification_result->classifications) {
			classification_result_proto.add_classifications()->CopyFrom(ConvertClassificationsToProto(const_cast<Classifications*>(&classifications)));
		}

		if (classification_result->timestamp_ms) {
			classification_result_proto.set_timestamp_ms(*classification_result->timestamp_ms);
		}

		return classification_result_proto;
	}

	void CppConvertToClassificationsList(const std::vector<std::vector<Category>>& classifications_result, std::vector<Classifications>& classifications_list, HRESULT& hr) {
		classifications_list.clear();
		classifications_list.reserve(classifications_result.size());
		for (const auto& categories : classifications_result) {
			classifications_list.push_back({ .categories = categories, .head_index = -1 });
		}
		hr = S_OK;
	}

	void CppConvertToClassificationsList(VARIANT* in_val, std::vector<Classifications>& classifications_list, HRESULT& hr) {
		std::vector<std::vector<Category>> classifications_result;
		hr = autoit_to(in_val, classifications_result);
		if (SUCCEEDED(hr)) {
			CppConvertToClassificationsList(classifications_result, classifications_list, hr);
		}
	}

	std::vector<std::vector<Category>> CppConvertToClassificationsResult(std::vector<Classifications>& classifications_list) {
		std::vector<std::vector<Category>> classifications_result;
		classifications_result.reserve(classifications_list.size());
		for (const auto& classifications : classifications_list) {
			classifications_result.push_back(classifications.categories);
		}
		return classifications_result;
	}

	void CppConvertToClassificationsList(const std::optional<std::vector<std::vector<Category>>>& classifications_result, std::optional<std::vector<Classifications>>& classifications_list, HRESULT& hr) {
		if (classifications_result) {
			classifications_list.emplace();
			CppConvertToClassificationsList(*classifications_result, *classifications_list, hr);
		} else {
			classifications_list = std::nullopt;
		}
	}

	void CppConvertToClassificationsList(VARIANT* in_val, std::optional<std::vector<Classifications>>& classifications_list, HRESULT& hr) {
		std::optional<std::vector<std::vector<Category>>> classifications_result;
		hr = autoit_to(in_val, classifications_result);
		if (SUCCEEDED(hr)) {
			CppConvertToClassificationsList(classifications_result, classifications_list, hr);
		}
	}

	std::optional<std::vector<std::vector<Category>>> CppConvertToClassificationsResult(std::optional<std::vector<Classifications>>& classifications_list) {
		if (!classifications_list) {
			return std::nullopt;
		}
		return std::optional<std::vector<std::vector<Category>>>(CppConvertToClassificationsResult(*classifications_list));
	}

}