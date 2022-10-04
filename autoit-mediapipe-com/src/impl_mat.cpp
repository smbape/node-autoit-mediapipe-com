#include <array>
#include <cstdint>
#include <numeric>
#include <windows.h>
#include <gdiplus.h>

#include <opencv2/imgproc.hpp>
#include "Cv_Object.h"
#include "cvextra.h"

#pragma comment(lib, "gdiplus.lib")

namespace Gdiplus {
	class BitmapLock {
	private:
		bool isOk = false;

	public:
		BitmapLock(
			Bitmap& in_bitmap,
			IN const Rect* rect,
			IN UINT flags,
			IN PixelFormat format
		) : bitmap(in_bitmap) {
			CV_Assert(bitmap.LockBits(rect, flags, format, &data) == Ok);
			isOk = true;
		}

		BitmapLock(
			Bitmap& in_bitmap,
			IN UINT flags,
			IN PixelFormat format
		) : bitmap(in_bitmap) {
			auto rect = Gdiplus::Rect(0, 0, bitmap.GetWidth(), bitmap.GetHeight());
			CV_Assert(bitmap.LockBits(&rect, flags, format, &data) == Ok);
			isOk = true;
		}

		BitmapLock(
			Bitmap& in_bitmap,
			IN UINT flags
		) : bitmap(in_bitmap) {
			auto rect = Gdiplus::Rect(0, 0, bitmap.GetWidth(), bitmap.GetHeight());
			CV_Assert(bitmap.LockBits(&rect, flags, bitmap.GetPixelFormat(), &data) == Ok);
			isOk = true;
		}

		~BitmapLock() {
			if (isOk) {
				CV_Assert(bitmap.UnlockBits(&data) == Ok);
			}
		}

		Bitmap& bitmap;
		BitmapData data;
	};


	class CvBitmap : public Bitmap {
	public:
		CvBitmap() : Bitmap((GpBitmap*)NULL) {}
		CvBitmap(GpBitmap* nativeBitmap) : Bitmap(nativeBitmap) {}

		CvBitmap(
			_In_ INT width,
			_In_ INT height,
			_In_ INT format
		) : Bitmap(width, height, format) {}

		CvBitmap(
			_In_ INT width,
			_In_ INT height,
			_In_ size_t stride,
			_In_ PixelFormat format,
			_In_reads_opt_(_Inexpressible_("height * stride")) BYTE* scan0
		) : Bitmap(width, height, stride, format, scan0) {}

		GpBitmap* GetNativeImage() {
			return static_cast<GpBitmap*>(nativeImage);
		}

		void Attach(GpImage* newNativeImage) {
			Bitmap::SetNativeImage(newNativeImage);
		}

		GpBitmap* Detach() {
			auto oldNativeImage = static_cast<GpBitmap*>(nativeImage);
			Bitmap::SetNativeImage(NULL);
			return oldNativeImage;
		}

		GpBitmap* CloneNativeImage() {
			int x = 0;
			int y = 0;
			auto width = GetWidth();
			auto height = GetHeight();
			auto format = GetPixelFormat();

			GpBitmap* gpdstBitmap = NULL;
			auto status = DllExports::GdipCloneBitmapAreaI(
				x,
				y,
				width,
				height,
				format,
				static_cast<GpBitmap*>(nativeImage),
				&gpdstBitmap
			);
			CV_Assert(status == Ok);

			return gpdstBitmap;
		}
	};
}

/**
 *
 * @param bitmap
 * @param mat
 * @param copy   use the same data when possible, otherwise, make a copy
 * @see https://github.com/emgucv/emgucv/blob/4.5.4/Emgu.CV.Platform/Emgu.CV.Bitmap/BitmapExtension.cs#L300
 */
inline void createMatFromBitmap_(Gdiplus::Bitmap& bitmap, cv::Mat& mat, bool copy) {
	using namespace cv;
	using namespace Gdiplus;

	auto width = bitmap.GetWidth();
	auto height = bitmap.GetHeight();
	auto format = bitmap.GetPixelFormat();

	Gdiplus::Rect rect(0, 0, width, height);

	BitmapLock lock(bitmap, &rect, ImageLockModeRead, format);
	BitmapData& data = lock.data;

	if (format == PixelFormat32bppARGB) {
		Mat tmp(height, width, CV_8UC4, data.Scan0, data.Stride);
		if (copy) {
			tmp.copyTo(mat);
		}
		else {
			mat = tmp;
		}
	}
	else if (format == PixelFormat32bppRGB) {
		Mat tmp(height, width, CV_8UC4, data.Scan0, data.Stride);
		mixChannels(tmp, mat, { 0, 0, 1, 1, 2, 2 });
	}
	else if (format == PixelFormat24bppRGB) {
		Mat tmp(height, width, CV_8UC3, data.Scan0, data.Stride);
		if (copy) {
			tmp.copyTo(mat);
		}
		else {
			mat = tmp;
		}
	}
	else if (format == PixelFormat8bppIndexed) {
		Mat bTable(1, 256, CV_8U);
		Mat gTable(1, 256, CV_8U);
		Mat rTable(1, 256, CV_8U);
		Mat aTable(1, 256, CV_8U);

		auto bData = bTable.ptr();
		auto gData = gTable.ptr();
		auto rData = rTable.ptr();
		auto aData = aTable.ptr();

		Gdiplus::ColorPalette palette;
		bitmap.GetPalette(&palette, bitmap.GetPaletteSize());
		for (UINT i = 0; i < palette.Count; i++) {
			Gdiplus::Color color(palette.Entries[i]);
			bData[i] = color.GetBlue();
			gData[i] = color.GetGreen();
			rData[i] = color.GetRed();
			aData[i] = color.GetAlpha();
		}

		Mat indexValue(height, width, CV_8UC1, data.Scan0, data.Stride);

		Mat b, g, r, a;

		cv::LUT(indexValue, bTable, b);
		cv::LUT(indexValue, gTable, g);
		cv::LUT(indexValue, rTable, r);
		cv::LUT(indexValue, aTable, a);

		VectorOfMat mv = { b, g, r, a };
		cv::merge(mv, mat);
	}
	else {
		cv::error(cv::Error::StsAssert, "Unsupported bitmap format", CV_Func, __FILE__, __LINE__);
	}
}

cv::Mat cv::createMatFromBitmap(void* ptr, bool copy) {
	using namespace Gdiplus;

	auto nativeBitmap = static_cast<GpBitmap*>(ptr);

	// Attach nativeBitmap
	CvBitmap bitmap(nativeBitmap);
	CV_Assert(bitmap.GetLastStatus() == Ok);

	Mat mat; createMatFromBitmap_(bitmap, mat, copy);

	// Detach nativeBitmap
	bitmap.Detach();

	return copy ? mat.clone() : Mat(mat);
}

/**
 *
 * @param src
 * @param dst
 * @see https://github.com/opencv/opencv/blob/4.5.4/modules/highgui/src/precomp.hpp#L152
 */
const cv::Mat CCv_Mat_Object::convertToShow(cv::Mat& dst, bool toRGB, HRESULT& hr) {
	using namespace cv;

	auto& src = *this->__self->get();

	double scale = 1.0, shift = 0.0;
	double minVal = 0, maxVal = 0;
	Point minLoc, maxLoc;

	const int src_depth = src.depth();
	CV_Assert(src_depth != CV_16F && src_depth != CV_32S);
	Mat tmp;
	switch (src_depth)
	{
	case CV_8U:
		tmp = src;
		break;
	case CV_8S:
		cv::convertScaleAbs(src, tmp, 1, 127);
		break;
	case CV_16S:
		cv::convertScaleAbs(src, tmp, 1 / 255., 127);
		break;
	case CV_16U:
		cv::convertScaleAbs(src, tmp, 1 / 255.);
		break;
	case CV_32F:
	case CV_64F:
		if (src.channels() == 1) {
			cv::minMaxLoc(src, &minVal, &maxVal, &minLoc, &maxLoc);
		}
		else {
			cv::minMaxLoc(src.reshape(1), &minVal, &maxVal, &minLoc, &maxLoc);
		}

		scale = (float)maxVal == (float)minVal ? 0.0 : 255.0 / (maxVal - minVal);
		shift = scale == 0 ? minVal : -minVal * scale;

		src.convertTo(tmp, CV_8U, scale, shift);

		break;
	default:
		cv::error(cv::Error::StsAssert, "Unsupported mat type", CV_Func, __FILE__, __LINE__);
	}

	cv::cvtColor(tmp, dst, toRGB ? cv::COLOR_BGR2RGB : cv::COLOR_BGRA2BGR, dst.channels());

	return dst;
}

static Gdiplus::ColorPalette* GenerateGrayscalePalette() {
	using namespace Gdiplus;

	static Gdiplus::ColorPalette* palette = NULL;
	if (palette) {
		return palette;
	}

	Bitmap image(1, 1, PixelFormat8bppIndexed);
	int palsize = image.GetPaletteSize();
	palette = reinterpret_cast<Gdiplus::ColorPalette*>(new BYTE[palsize]);
	image.GetPalette(palette, palsize);

	for (int i = 0; i < 256; i++) {
		palette->Entries[i] = Gdiplus::Color(i, i, i).GetValue();
	}

	return palette;
}

// static Gdiplus::ColorPalette* GrayscalePalette = GenerateGrayscalePalette();

static void RawDataToBitmap(uchar* scan0, size_t step, cv::Size size, int dstColorType, int channels, int srcDepth, Gdiplus::CvBitmap& dst) {
	using namespace Gdiplus;

	if (dstColorType == CV_8UC1 && srcDepth == CV_8U) {
		CvBitmap bmpGray(
			size.width,
			size.height,
			step,
			PixelFormat8bppIndexed,
			scan0
		);

		CV_Assert(bmpGray.GetLastStatus() == Ok);

		bmpGray.SetPalette(GenerateGrayscalePalette());

		dst.Attach(bmpGray.Detach());
		return;
	}
	else if (dstColorType == CV_8UC3 && srcDepth == CV_8U) {
		CvBitmap bmp(
			size.width,
			size.height,
			step,
			PixelFormat24bppRGB,
			scan0
		);
		CV_Assert(bmp.GetLastStatus() == Ok);
		dst.Attach(bmp.Detach());
		return;
	}
	else if (dstColorType == CV_8UC4 && srcDepth == CV_8U) {
		CvBitmap bmp(
			size.width,
			size.height,
			step,
			PixelFormat32bppARGB,
			scan0
		);
		CV_Assert(bmp.GetLastStatus() == Ok);
		dst.Attach(bmp.Detach());
		return;
	}

	PixelFormat format;

	if (dstColorType == CV_8UC1) { // if this is a gray scale image
		format = PixelFormat8bppIndexed;
	}
	else if (dstColorType == CV_8UC4) { // if this is Bgra image
		format = PixelFormat32bppARGB;
	}
	else if (dstColorType == CV_8UC3) { // if this is a Bgr image
		format = PixelFormat24bppRGB;
	}
	else { // convert to a 3 channels matrix
		cv::Mat m(size.height, size.width, CV_MAKETYPE(srcDepth, channels), scan0, step);
		cv::Mat m2;
		cv::cvtColor(m, m2, dstColorType, CV_8UC3);
		RawDataToBitmap(m2.ptr(), m2.step1(), m2.size(), CV_8UC3, 3, srcDepth, dst);
		return;
	}

	CvBitmap bmp(size.width, size.height, format);
	CV_Assert(bmp.GetLastStatus() == Ok);

	{
		// Block to ensure unlocks before detach
		auto rect = Gdiplus::Rect(0, 0, size.width, size.height);
		BitmapLock lock(bmp, &rect, ImageLockModeWrite, format);
		BitmapData& data = lock.data;
		cv::Mat bmpMat(size.height, size.width, CV_MAKETYPE(CV_8U, channels), data.Scan0, data.Stride);
		cv::Mat srcMat(size.height, size.width, CV_MAKETYPE(srcDepth, channels), scan0, step);

		if (srcDepth == CV_8U) {
			srcMat.copyTo(bmpMat);
		}
		else {
			double scale = 1.0, shift = 0.0;
			double minVal = 0, maxVal = 0;
			cv::Point minLoc, maxLoc;
			if (channels == 1) {
				minMaxLoc(srcMat, &minVal, &maxVal, &minLoc, &maxLoc);
			}
			else {
				minMaxLoc(srcMat.reshape(1), &minVal, &maxVal, &minLoc, &maxLoc);
			}

			scale = (float)maxVal == (float)minVal ? 0.0 : 255.0 / (maxVal - minVal);
			shift = scale == 0 ? minVal : -minVal * scale;

			srcMat.convertTo(bmpMat, CV_8U, scale, shift);
		}
	}

	if (format == PixelFormat8bppIndexed) {
		bmp.SetPalette(GenerateGrayscalePalette());
	}

	dst.Attach(bmp.Detach());
}

/**
 * [CCv_Mat_Object::convertToBitmap description]
 * @param copy   use the same data when possible, otherwise, make a copy
 * @param hr
 * @return   a pointer to a GpBitmap with Mat data copied
 * @see https://github.com/emgucv/emgucv/blob/4.5.4/Emgu.CV.Platform/Emgu.CV.Bitmap/BitmapExtension.cs#L206
 */
const void* CCv_Mat_Object::convertToBitmap(bool copy, HRESULT& hr) {
	using namespace Gdiplus;
	auto& src = *this->__self->get();

	if (src.dims > 3 || src.empty()) {
		return NULL;
	}

	auto channels = src.channels();
	int colorType = CV_MAKETYPE(CV_8U, channels);

	if (channels == 1) {
		if ((src.cols | 3) != 0) { //handle the special case where width is not a multiple of 4
			CvBitmap bitmap(src.cols, src.rows, PixelFormat8bppIndexed);
			CV_Assert(bitmap.GetLastStatus() == Ok);

			bitmap.SetPalette(GenerateGrayscalePalette());
			{
				// Block to ensure unlocks before detach
				auto rect = Gdiplus::Rect(0, 0, bitmap.GetWidth(), bitmap.GetHeight());
				BitmapLock lock(bitmap, &rect, ImageLockModeWrite, PixelFormat8bppIndexed);
				BitmapData& bitmapData = lock.data;
				cv::Mat dst(src.size(), CV_8UC1, bitmapData.Scan0, bitmapData.Stride);
				src.copyTo(dst);
			}

			return bitmap.Detach();
		}
	}
	else if (channels != 3 && channels != 4) {
		cv::error(cv::Error::StsAssert, "Unknown color type", CV_Func, __FILE__, __LINE__);
	}

	CvBitmap dst;
	RawDataToBitmap(src.ptr(), src.step1(), src.size(), colorType, channels, src.depth(), dst);
	return copy ? dst.CloneNativeImage() : dst.Detach();
}

const cv::Mat CCv_Mat_Object::GdiplusResize(float newWidth, float newHeight, int interpolation, HRESULT& hr) {
	using namespace Gdiplus;

	GpBitmap* nativeBitmap = static_cast<GpBitmap*>(const_cast<void*>(convertToBitmap(true, hr)));
	CvBitmap bitmap(nativeBitmap);
	CV_Assert(bitmap.GetLastStatus() == Ok);

	CvBitmap hBitmap(static_cast<int>(newWidth), static_cast<int>(newHeight), bitmap.GetPixelFormat());
	CV_Assert(hBitmap.GetLastStatus() == Ok);

	Gdiplus::Graphics hBmpCtxt(&hBitmap);
	CV_Assert(hBmpCtxt.GetLastStatus() == Ok);

	CV_Assert(hBmpCtxt.SetInterpolationMode(static_cast<Gdiplus::InterpolationMode>(interpolation)) == Ok);
	CV_Assert(hBmpCtxt.DrawImage(&bitmap, 0.0, 0.0, newWidth, newHeight) == Ok);

	cv::Mat mat; createMatFromBitmap_(hBitmap, mat, true);

	return mat.clone();
}
