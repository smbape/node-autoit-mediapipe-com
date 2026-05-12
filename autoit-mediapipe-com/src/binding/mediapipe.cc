#include "Mediapipe_Object.h"

STDMETHODIMP CMediapipe_Object::get_extended(VARIANT* _retval) {
	CActCtxActivator ScopedContext(ExtendedHolder::_ActCtx);

	VARIANT out_val = { 0 };
	V_VT(&out_val) = VT_ARRAY | VT_VARIANT;
	V_ARRAY(&out_val) = ExtendedHolder::extended.Detach();

	VariantInit(_retval);
	HRESULT hr = VariantCopy(_retval, &out_val);
	ExtendedHolder::extended.Attach(V_ARRAY(&out_val));
	return hr;
}

const _variant_t CMediapipe_Object::variant(void* ptr, HRESULT& hr) {
	return _variant_t(static_cast<VARIANT*>(ptr));
}

namespace mediapipe {
	template<typename T>
	inline bool _check__eq__() {
		T o1;
		T o2;
		return static_cast<bool>(o1 == o2);
	}

	void check__eq__() {
		_check__eq__<tasks::audio::audio_classifier::AudioClassifierResult>();
		_check__eq__<tasks::text::language_detector::LanguageDetectorResult>();
		_check__eq__<tasks::text::text_classifier::TextClassifierResult>();
		_check__eq__<tasks::text::text_embedder::TextEmbedderResult>();
		_check__eq__<tasks::vision::face_detector::FaceDetectorResult>();
		_check__eq__<tasks::vision::face_landmarker::FaceLandmarkerResult>();
		_check__eq__<tasks::autoit::vision::gesture_recognizer::GestureRecognizerResult>();
		_check__eq__<tasks::vision::hand_landmarker::HandLandmarkerResult>();
		_check__eq__<tasks::vision::holistic_landmarker::HolisticLandmarkerResult>();
		_check__eq__<tasks::vision::image_classifier::ImageClassifierResult>();
		_check__eq__<tasks::vision::image_embedder::ImageEmbedderResult>();
		_check__eq__<tasks::vision::image_segmenter::ImageSegmenterResult>();
		_check__eq__<tasks::vision::ObjectDetectorResult>();
		_check__eq__<tasks::vision::pose_landmarker::PoseLandmarkerResult>();
	}

	template<typename T>
	inline std::string _check__str__() {
		T obj;
		return std::to_string(obj);
	}

	void check__str__() {
		_check__str__<tasks::components::containers::Category>();
		_check__str__<tasks::components::containers::Classifications>();
		_check__str__<tasks::components::containers::ClassificationResult>();
		_check__str__<tasks::components::containers::Detection>();
		_check__str__<tasks::components::containers::DetectionResult>();
		_check__str__<tasks::components::containers::Embedding>();
		_check__str__<tasks::components::containers::EmbeddingResult>();
		_check__str__<tasks::components::containers::NormalizedKeypoint>();
		_check__str__<tasks::components::containers::Landmark>();
		_check__str__<tasks::components::containers::NormalizedLandmark>();
		_check__str__<tasks::components::containers::Landmarks>();
		_check__str__<tasks::components::containers::NormalizedLandmarks>();
		_check__str__<tasks::components::containers::LandmarksDetectionResult>();
		_check__str__<tasks::components::containers::Rect>();
		// _check__str__<tasks::components::containers::RectF>();
		_check__str__<tasks::components::containers::NormalizedRect>();

		_check__str__<tasks::components::processors::ClassifierOptions>();
		_check__str__<tasks::components::processors::EmbedderOptions>();

		_check__str__<tasks::core::BaseOptions>();
	}

}
