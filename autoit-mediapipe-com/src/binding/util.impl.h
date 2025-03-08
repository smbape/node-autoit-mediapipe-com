#include "binding/util.h"

template<typename Out>
inline const HRESULT autoit_from(const absl::Status& status, const Out& out_val) {
	if (status.ok()) {
		return S_OK;
	}

	AUTOIT_ERROR(::mediapipe::autoit::StatusCodeToError(status.code()) << ": " << status.message().data());
	return E_FAIL;
}

template<typename In, typename Out>
inline const HRESULT autoit_from(const absl::StatusOr<In>& status_or, Out& out_val) {
	if (!status_or.status().ok()) {
		return autoit_from(status_or.status(), static_cast<VARIANT*>(nullptr));
	}
	return autoit_from(status_or.value(), out_val);
}
