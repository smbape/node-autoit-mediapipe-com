#include "binding/tasks/components/containers/audio_data.h"

namespace mediapipe {
	namespace tasks {
		namespace autoit {
			namespace components {
				namespace containers {
					namespace audio_data {
						void AudioData::load_from_mat(cv::Mat src, int offset, int size) {
							AUTOIT_ASSERT_THROW(src.dims == 2, "The audio data is expected to have at most 2 dimensions");

							int channels = src.channels();
							if (channels == 1) {
								if (src.rows != 1) {
									channels = src.cols;
								}
							}
							else {
								AUTOIT_ASSERT_THROW(src.rows == 1 || src.cols == 1, "The audio data is expected be a 1xN or Nx1 matrix");
							}

							if (channels == 1) {
								AUTOIT_ASSERT_THROW(_audio_format.num_channels == 1, "Input audio is mono, but the audio data is expected "
									"to have " << _audio_format.num_channels << " channels.");
							}
							else {
								AUTOIT_ASSERT_THROW(channels == _audio_format.num_channels, "Input audio contains an invalid number of channels. "
									"Expect " << _audio_format.num_channels << ".");
							}

							src = src.reshape(channels, 1);

							if (size < 0) {
								size = src.cols;
							}

							AUTOIT_ASSERT_THROW(
								offset + size <= src.cols,
								"Index out of range. offset " << offset << " + size " << size <<
								" should be <= src's length: " << src.cols);

							if (size >= _buffer.cols) {
								// If the internal buffer is shorter than the load target (src), copy
								// values from the end of the src array to the internal buffer.
								int new_size = _buffer.cols;
								int new_offset = src.cols - new_size;
								cv::Mat(src, cv::Rect(new_offset, 0, new_size, 1)).copyTo(_buffer);
							}
							else {
								// Shift the internal buffer backward and add the incoming data to the end
								// of the buffer.
								auto remaining_size = _buffer.cols - size;
								auto begining = cv::Mat(_buffer, cv::Rect(0, 0, remaining_size, 1));
								auto ending = cv::Mat(_buffer, cv::Rect(size, 0, remaining_size, 1));
								ending.copyTo(begining);

								auto incoming = cv::Mat(src, cv::Rect(offset, 0, size, 1));
								auto dst = cv::Mat(_buffer, cv::Rect(remaining_size, 0, size, 1));
								incoming.copyTo(dst);
							}
						}

						std::shared_ptr<AudioData> AudioData::create_from_mat(cv::Mat src, float sample_rate) {
							AUTOIT_ASSERT_THROW(src.dims == 2, "The audio data is expected to have at most 2 dimensions");

							int channels = src.channels();
							if (channels == 1) {
								if (src.rows != 1) {
									channels = src.cols;
								}
							}
							else {
								AUTOIT_ASSERT_THROW(src.rows == 1 || src.cols == 1, "The audio data is expected be a 1xN or Nx1 matrix");
							}

							src = src.reshape(channels, 1);

							auto obj = std::make_shared<AudioData>(src.cols, AudioDataFormat(channels, sample_rate));
							obj->load_from_mat(src);
							return obj;
						}
					}
				}
			}
		}
	}
}
