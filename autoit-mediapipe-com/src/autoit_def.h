#pragma once

#define AUTOIT_LIB_NAME mediapipe
#define AUTOIT_LIB_VERSION 0.8.11
#define AUTOIT_PTR std::shared_ptr
#define AUTOIT_MAKE_PTR std::make_shared

// https://github.com/abseil/abseil-cpp/issues/377
#ifdef StrCat
#undef StrCat
#endif
