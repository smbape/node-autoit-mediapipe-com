workspace(name = "autoit-mediapipe-com")

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

http_archive(
    name = "bazel_skylib",
    urls = [
        "https://mirror.bazel.build/github.com/bazelbuild/bazel-skylib/releases/download/1.3.0/bazel-skylib-1.3.0.tar.gz",
        "https://github.com/bazelbuild/bazel-skylib/releases/download/1.3.0/bazel-skylib-1.3.0.tar.gz",
    ],
    sha256 = "74d544d96f4a5bb630d465ca8bbcfe231e3594e5aae57e1edbf17a6eb3ca2506",
)

load("@bazel_skylib//:workspace.bzl", "bazel_skylib_workspace")
bazel_skylib_workspace()

new_local_repository(
    name = "windows_opencv",
    build_file = "autoit-mediapipe-com/third_party/opencv_windows.BUILD",
    path = "opencv-4.6.0-vc14_vc15/opencv/build",
)

# http_archive(
#     name = "mediapipe",
#     urls = [
#         "https://fossies.org/linux/misc/mediapipe-0.8.11.tar.gz",
#         "https://github.com/google/mediapipe/archive/refs/tags/v0.8.11.tar.gz",
#     ],
#     sha256 = "5b331a46b459900d0789967f9e26e4a64d1466bc1e74dd0712eb3077358c5473",
# )
