#pragma once

#include "binding/tasks/core/utils.h"
#include "autoit_bridge_common.h"
#include <opencv2/core/eigen.hpp>

namespace mediapipe::tasks::autoit::core::utils {
	mediapipe::Matrix CppConvertToMatrix(const cv::Mat& data, bool transpose) {
		using _Tp = float;

		AUTOIT_ASSERT_THROW(data.type() == cv::traits::Type<_Tp>::value, "The data should be a float matrix");
		AUTOIT_ASSERT_THROW(data.dims <= 2, "The data is expected to have at most 2 dimensions");
		AUTOIT_ASSERT_THROW(data.cols == 1 || data.channels() == 1, "The data is expected be a 2d matrix");

		const auto& rows = data.rows;
		const auto& cols = data.cols * data.channels();

		mediapipe::Matrix matrix;

		if (transpose) {
			matrix.resize(cols, rows);
			if (!(matrix.Flags & Eigen::RowMajorBit)) {
				const cv::Mat _dst(matrix.cols(), matrix.rows(), cv::traits::Type<_Tp>::value,
					reinterpret_cast<void*>(matrix.data()), (size_t)(matrix.outerStride() * sizeof(_Tp)));
				data.reshape(1).convertTo(_dst, _dst.type());
			}
			else {
				const cv::Mat _dst(matrix.rows(), matrix.cols(), cv::traits::Type<_Tp>::value,
					reinterpret_cast<void*>(matrix.data()), (size_t)(matrix.outerStride() * sizeof(_Tp)));
				cv::transpose(data.reshape(1), _dst);
			}
		}
		else {
			matrix.resize(rows, cols);
			if (!(matrix.Flags & Eigen::RowMajorBit)) {
				const cv::Mat _dst(matrix.cols(), matrix.rows(), cv::traits::Type<_Tp>::value,
					reinterpret_cast<void*>(matrix.data()), (size_t)(matrix.outerStride() * sizeof(_Tp)));
				cv::transpose(data.reshape(1), _dst);
			}
			else {
				const cv::Mat _dst(matrix.rows(), matrix.cols(), cv::traits::Type<_Tp>::value,
					reinterpret_cast<void*>(matrix.data()), (size_t)(matrix.outerStride() * sizeof(_Tp)));
				data.reshape(1).convertTo(_dst, _dst.type());
			}
		}

		return matrix;
	}

	void CppConvertToMatrix(const std::optional<std::vector<cv::Mat>>& cv_matrixes, std::optional<std::vector<Matrix>>& mp_matrixes, HRESULT& hr, bool transpose) {
		if (!cv_matrixes) {
			mp_matrixes = std::nullopt;
			return;
		}

		mp_matrixes.emplace();
		mp_matrixes->reserve(cv_matrixes->size());
		for (const auto& data : *cv_matrixes) {
			mp_matrixes->push_back(CppConvertToMatrix(data, transpose));
		}
		hr = S_OK;
	}

	void CppConvertToMatrix(VARIANT* in_val, std::optional<std::vector<Matrix>>& mp_matrixes, HRESULT& hr, bool transpose) {
		std::optional<std::vector<cv::Mat>> cv_matrixes;
		hr = autoit_to(in_val, cv_matrixes);
		if (SUCCEEDED(hr)) {
			CppConvertToMatrix(cv_matrixes, mp_matrixes, hr, transpose);
		}
	}

	cv::Mat CppConvertToMatView(mediapipe::Matrix& matrix) {
		using _Tp = float;

		if (!(matrix.Flags & Eigen::RowMajorBit)) {
			return cv::Mat(matrix.cols(), matrix.rows(), cv::traits::Type<_Tp>::value,
				reinterpret_cast<void*>(matrix.data()), (size_t)(matrix.outerStride() * sizeof(_Tp)));
		}
		else {
			return cv::Mat(matrix.rows(), matrix.cols(), cv::traits::Type<_Tp>::value,
				reinterpret_cast<void*>(matrix.data()), (size_t)(matrix.outerStride() * sizeof(_Tp)));
		}
	}

	std::optional<std::vector<cv::Mat>> CppConvertToMatView(std::optional<std::vector<Matrix>>& mp_matrixes) {
		std::optional<std::vector<cv::Mat>> cv_matrixes = std::nullopt;

		if (!mp_matrixes) {
			return cv_matrixes;
		}

		cv_matrixes.emplace();
		cv_matrixes->reserve(mp_matrixes->size());
		for (auto& matrix : *mp_matrixes) {
			cv_matrixes->push_back(CppConvertToMatView(matrix));
		}

		return cv_matrixes;
	}
}
