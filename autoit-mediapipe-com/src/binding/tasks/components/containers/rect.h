#pragma once

#include "mediapipe/framework/formats/rect.pb.h"

namespace mediapipe {
	namespace tasks {
		namespace autoit {
			namespace components {
				namespace containers {
					namespace rect {
						struct CV_EXPORTS_W_SIMPLE Rect {
							CV_WRAP Rect(const rect::Rect& other) = default;
							Rect& operator=(const rect::Rect& other) = default;

							CV_WRAP Rect(
								float left = 0.0f,
								float top = 0.0f,
								float right = 0.0f,
								float bottom = 0.0f
							)
								:
								left(left),
								top(top),
								right(right),
								bottom(bottom)
							{}

							float left;
							float top;
							float right;
							float bottom;
						};

						struct CV_EXPORTS_W_SIMPLE NormalizedRect {
							CV_WRAP NormalizedRect(const rect::NormalizedRect& other) = default;
							NormalizedRect& operator=(const rect::NormalizedRect& other) = default;

							CV_WRAP NormalizedRect(
								float x_center = 0.0f,
								float y_center = 0.0f,
								float width = 0.0f,
								float height = 0.0f,
								float rotation = 0.0f,
								int rect_id = -1
							)
								:
								x_center(x_center),
								y_center(y_center),
								width(width),
								height(height),
								rotation(rotation),
								rect_id(rect_id)
							{}

							CV_WRAP std::shared_ptr<mediapipe::NormalizedRect> to_pb2();
							CV_WRAP static std::shared_ptr<rect::NormalizedRect> create_from_pb2(const mediapipe::NormalizedRect& pb2_obj);

							float x_center;
							float y_center;
							float width;
							float height;
							float rotation;
							int rect_id;

						};
					}
				}
			}
		}
	}
}
