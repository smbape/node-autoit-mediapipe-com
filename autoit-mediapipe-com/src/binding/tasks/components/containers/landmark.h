#pragma once

#include "mediapipe/tasks/cc/components/containers/landmark.h"
#include "mediapipe/framework/formats/landmark.pb.h"

namespace mediapipe::tasks::components::containers {
	struct Connection {
		int start;
		int end;
	};

	inline bool operator==(const Landmarks& lhs, const Landmarks& rhs) {
		return lhs.landmarks == rhs.landmarks;
	}

	inline bool operator==(const NormalizedLandmarks& lhs, const NormalizedLandmarks& rhs) {
		return lhs.landmarks == rhs.landmarks;
	}

	mediapipe::Landmark ConvertLandmarkToProto(Landmark* landmark);

	mediapipe::NormalizedLandmark ConvertNormalizedLandmarkToProto(NormalizedLandmark* normalized_landmark);

	mediapipe::LandmarkList ConvertLandmarkListToProto(Landmarks* landmarks);

	mediapipe::NormalizedLandmarkList ConvertNormalizedLandmarkListToProto(NormalizedLandmarks* normalized_landmarks);

	void CppConvertToLandmarks(const std::vector<Landmark>& landmark_result, Landmarks& landmarks, HRESULT& hr);

	void CppConvertToLandmarks(VARIANT* in_val, Landmarks& landmarks, HRESULT& hr);

	std::vector<Landmark>& CppConvertToLandmarkList(Landmarks& landmarks);

	void CppConvertToNormalizedLandmarks(const std::vector<NormalizedLandmark>& normalized_landmark_result, NormalizedLandmarks& normalized_landmarks, HRESULT& hr);

	void CppConvertToNormalizedLandmarks(VARIANT* in_val, NormalizedLandmarks& normalized_landmarks, HRESULT& hr);

	std::vector<NormalizedLandmark>& CppConvertToNormalizedLandmarkList(NormalizedLandmarks& normalized_landmarks);

	void CppConvertToLandmarksList(const std::vector<std::vector<Landmark>>& landmark_list_list, std::vector<Landmarks>& landmarks_list, HRESULT& hr);

	void CppConvertToLandmarksList(VARIANT* in_val, std::vector<Landmarks>& landmarks_list, HRESULT& hr);

	std::vector<std::vector<Landmark>> CppConvertToLandmarkListList(std::vector<Landmarks>& landmarks_list);

	void CppConvertToNormalizedLandmarksList(const std::vector<std::vector<NormalizedLandmark>>& normalized_landmark_list_list, std::vector<NormalizedLandmarks>& normalized_landmarks_list, HRESULT& hr);

	void CppConvertToNormalizedLandmarksList(VARIANT* in_val, std::vector<NormalizedLandmarks>& normalized_landmarks_list, HRESULT& hr);

	std::vector<std::vector<NormalizedLandmark>> CppConvertToNormalizedLandmarkListList(std::vector<NormalizedLandmarks>& normalized_landmarks_list);

}  // namespace mediapipe::tasks::components::containers

namespace std {
	inline std::string to_string(const mediapipe::tasks::components::containers::Landmark& landmark) {
		auto proto = mediapipe::tasks::components::containers::ConvertLandmarkToProto(const_cast<mediapipe::tasks::components::containers::Landmark*>(&landmark));
		std::string output;
		if (!google::protobuf::TextFormat::PrintToString(proto, &output)) {
			output = "Failed to print message";
		}
		return output;
	}

	inline std::string to_string(const mediapipe::tasks::components::containers::NormalizedLandmark& normalized_landmark) {
		auto proto = mediapipe::tasks::components::containers::ConvertNormalizedLandmarkToProto(const_cast<mediapipe::tasks::components::containers::NormalizedLandmark*>(&normalized_landmark));
		std::string output;
		if (!google::protobuf::TextFormat::PrintToString(proto, &output)) {
			output = "Failed to print message";
		}
		return output;
	}

	inline std::string to_string(const mediapipe::tasks::components::containers::Landmarks& landmarks) {
		auto proto = mediapipe::tasks::components::containers::ConvertLandmarkListToProto(const_cast<mediapipe::tasks::components::containers::Landmarks*>(&landmarks));
		std::string output;
		if (!google::protobuf::TextFormat::PrintToString(proto, &output)) {
			output = "Failed to print message";
		}
		return output;
	}

	inline std::string to_string(const mediapipe::tasks::components::containers::NormalizedLandmarks& normalized_landmarks) {
		auto proto = mediapipe::tasks::components::containers::ConvertNormalizedLandmarkListToProto(const_cast<mediapipe::tasks::components::containers::NormalizedLandmarks*>(&normalized_landmarks));
		std::string output;
		if (!google::protobuf::TextFormat::PrintToString(proto, &output)) {
			output = "Failed to print message";
		}
		return output;
	}
}
