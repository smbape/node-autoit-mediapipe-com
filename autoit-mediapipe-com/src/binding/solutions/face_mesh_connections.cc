#include "binding/solutions/face_mesh_connections.h";

namespace mediapipe {
	namespace autoit {
		namespace solutions {
			namespace face_mesh_connections {
				static std::vector<std::tuple<int, int>> getFaceMeshContours() {
					std::vector<std::tuple<int, int>> contours;

					// preallocate memory
					contours.reserve(
						FACEMESH_LIPS.size() +
						FACEMESH_LEFT_EYE.size() +
						FACEMESH_LEFT_EYEBROW.size() +
						FACEMESH_RIGHT_EYE.size() +
						FACEMESH_RIGHT_EYEBROW.size() +
						FACEMESH_FACE_OVAL.size()
					);

					contours.insert(contours.end(), FACEMESH_LIPS.begin(), FACEMESH_LIPS.end());
					contours.insert(contours.end(), FACEMESH_LEFT_EYE.begin(), FACEMESH_LEFT_EYE.end());
					contours.insert(contours.end(), FACEMESH_LEFT_EYEBROW.begin(), FACEMESH_LEFT_EYEBROW.end());
					contours.insert(contours.end(), FACEMESH_RIGHT_EYE.begin(), FACEMESH_RIGHT_EYE.end());
					contours.insert(contours.end(), FACEMESH_RIGHT_EYEBROW.begin(), FACEMESH_RIGHT_EYEBROW.end());
					contours.insert(contours.end(), FACEMESH_FACE_OVAL.begin(), FACEMESH_FACE_OVAL.end());

					return contours;
				}

				static std::vector<std::tuple<int, int>> getFaceMeshIrises() {
					std::vector<std::tuple<int, int>> irises;

					// preallocate memory
					irises.reserve(
						FACEMESH_LEFT_IRIS.size() +
						FACEMESH_RIGHT_IRIS.size()
					);

					irises.insert(irises.end(), FACEMESH_LEFT_IRIS.begin(), FACEMESH_LEFT_IRIS.end());
					irises.insert(irises.end(), FACEMESH_RIGHT_IRIS.begin(), FACEMESH_RIGHT_IRIS.end());

					return irises;
				}

				std::vector<std::tuple<int, int>> FACEMESH_CONTOURS = getFaceMeshContours();
				std::vector<std::tuple<int, int>> FACEMESH_IRISES = getFaceMeshIrises();
			}
		}
	}
}
