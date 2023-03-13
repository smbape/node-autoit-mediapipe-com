#pragma once

#include <opencv2/core/mat.hpp>

namespace mediapipe {
	namespace tasks {
		namespace autoit {
			namespace components {
				namespace containers {
					namespace audio_data {
						struct CV_EXPORTS_W_SIMPLE AudioDataFormat {
							CV_WRAP AudioDataFormat(const AudioDataFormat& other) = default;
							AudioDataFormat& operator=(const AudioDataFormat& other) = default;

							CV_WRAP AudioDataFormat(int num_channels = 1, float sample_rate = 0.0f) : num_channels(num_channels), sample_rate(sample_rate) {}
							CV_PROP_RW int num_channels;
							CV_PROP_RW float sample_rate;
						};

						class CV_EXPORTS_W AudioData {
						public:
							CV_WRAP AudioData(int buffer_length, AudioDataFormat audio_format = AudioDataFormat())
								: _audio_format(audio_format), _buffer(cv::Mat::zeros(1, buffer_length, CV_MAKETYPE(CV_32F, audio_format.num_channels))) {};

							CV_WRAP void clear() {
								_buffer.setTo(0.0);
							}

							CV_WRAP void load_from_mat(cv::Mat src, int offset = 0, int size = -1);
							CV_WRAP static std::shared_ptr<AudioData> create_from_mat(cv::Mat src, float sample_rate = 0.0f);

							CV_WRAP_AS(get audio_format) AudioDataFormat audio_format() {
								return _audio_format;
							}

							CV_WRAP_AS(get buffer_length) int buffer_length() {
								return _buffer.size[0];
							}

							CV_WRAP_AS(get buffer) cv::Mat buffer() {
								return _buffer;
							}
						private:
							AudioDataFormat _audio_format;
							cv::Mat _buffer;
						};
					}
				}
			}
		}
	}
}
