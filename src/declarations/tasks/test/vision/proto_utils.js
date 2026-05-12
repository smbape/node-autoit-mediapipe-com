module.exports = ({language}) => [
    // expose test.vision.proto_utils properties like in mediapipe python
    [`mediapipe.tasks.${ language }.test.vision.proto_utils.create_bounding_box_from_proto`, "tasks::components::containers::Rect", ["/Call=tasks::components::containers::ConvertToRect"], [
        ["mediapipe::LocationData::BoundingBox", "pb2_obj", "", ["/C", "/Ref"]],
    ], "", ""],
    [`mediapipe.tasks.${ language }.test.vision.proto_utils.create_category_from_proto`, "tasks::components::containers::Category", ["/Call=tasks::components::containers::ConvertToCategory"], [
        ["mediapipe::Classification", "pb2_obj", "", ["/C", "/Ref"]],
    ], "", ""],
    [`mediapipe.tasks.${ language }.test.vision.proto_utils.create_normalized_keypoint_from_proto`, "tasks::components::containers::NormalizedKeypoint", ["/Call=tasks::components::containers::ConvertToNormalizedKeypoint"], [
        ["mediapipe::LocationData::RelativeKeypoint", "pb2_obj", "", ["/C", "/Ref"]],
    ], "", ""],
    [`mediapipe.tasks.${ language }.test.vision.proto_utils.create_detection_from_proto`, "tasks::components::containers::Detection", ["/Call=tasks::components::containers::ConvertToDetection"], [
        ["mediapipe::Detection", "pb2_obj", "", ["/C", "/Ref"]],
    ], "", ""],
    [`mediapipe.tasks.${ language }.test.vision.proto_utils.create_detection_from_proto`, "tasks::components::containers::Detection", ["/Call=tasks::components::containers::ConvertToDetection"], [
        ["mediapipe::Detection", "pb2_obj", "", ["/C", "/Ref"]],
        ["int", "image_width", "", []],
        ["int", "image_height", "", []],
    ], "", ""],
    [`mediapipe.tasks.${ language }.test.vision.proto_utils.create_landmark_from_proto`, "tasks::components::containers::Landmark", ["/Call=tasks::components::containers::ConvertToLandmark"], [
        ["mediapipe::Landmark", "pb2_obj", "", ["/C", "/Ref"]],
    ], "", ""],
    [`mediapipe.tasks.${ language }.test.vision.proto_utils.create_normalized_landmark_from_proto`, "tasks::components::containers::NormalizedLandmark", ["/Call=tasks::components::containers::ConvertToNormalizedLandmark"], [
        ["mediapipe::NormalizedLandmark", "pb2_obj", "", ["/C", "/Ref"]],
    ], "", ""],
    [`mediapipe.tasks.${ language }.test.vision.proto_utils.create_landmarks_detection_result_from_proto`, "tasks::components::containers::LandmarksDetectionResult", ["/Call=tasks::components::containers::ConvertToLandmarksDetectionResult"], [
        ["mediapipe::tasks::containers::proto::LandmarksDetectionResult", "pb2_obj", "", ["/C", "/Ref"]],
    ], "", ""],
    [`mediapipe.tasks.${ language }.test.vision.proto_utils.create_normalized_landmark_list_from_proto`, "std::vector<tasks::components::containers::NormalizedLandmark>", ["/Call=tasks::components::containers::ConvertToNormalizedLandmarks", "/Output=$0.landmarks"], [
        ["mediapipe::NormalizedLandmarkList", "pb2_obj", "", ["/C", "/Ref"]],
    ], "", ""],
    [`mediapipe.tasks.${ language }.test.vision.proto_utils.create_classification_list_from_proto`, "std::vector<tasks::components::containers::Category>", ["/Call=tasks::components::containers::ConvertToClassifications", "/Output=$0.categories"], [
        ["mediapipe::ClassificationList", "pb2_obj", "", ["/C", "/Ref"]],
    ], "", ""],
];
