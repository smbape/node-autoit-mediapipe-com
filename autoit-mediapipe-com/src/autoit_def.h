#pragma once

#define AUTOIT_LIB_NAME mediapipe
#define AUTOIT_LIB_VERSION 0.9.3.0
#define AUTOIT_PTR std::shared_ptr
#define AUTOIT_MAKE_PTR std::make_shared

// https://github.com/abseil/abseil-cpp/issues/377
#ifdef StrCat
#undef StrCat
#endif

// mediapipe/modules/objectron/calculators/a_r_capture_metadata.proto
// define 2 enums RELATIVE and ABSOLUTE
// which conflict with RELATIVE and ABSOLUTE macro on windows
#ifdef RELATIVE
#undef RELATIVE
#endif
#ifdef ABSOLUTE
#undef ABSOLUTE
#endif
