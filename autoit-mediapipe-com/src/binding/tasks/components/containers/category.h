#pragma once

#include "mediapipe/framework/formats/classification.pb.h"

namespace mediapipe {
	namespace tasks {
		namespace autoit {
			namespace components {
				namespace containers {
					namespace category {
						struct CV_EXPORTS_W_SIMPLE Category {
							CV_WRAP Category(const Category& other) = default;
							Category& operator=(const Category& other) = default;

							CV_WRAP Category(
								int index = -1,
								float score = 0.0f,
								const std::string& display_name = "",
								const std::string& category_name = ""
							)
								:
								index(index),
								score(score),
								display_name(display_name),
								category_name(category_name)
							{}

							CV_WRAP std::shared_ptr<Classification> to_pb2();
							CV_WRAP static std::shared_ptr<Category> create_from_pb2(const Classification& pb2_obj);

							CV_PROP_RW int index;
							CV_PROP_RW float score;
							CV_PROP_RW std::string display_name;
							CV_PROP_RW std::string category_name;
						};
					}
				}
			}
		}
	}
}
