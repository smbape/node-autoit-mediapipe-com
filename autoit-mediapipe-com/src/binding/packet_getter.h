#pragma once

#include "absl/status/statusor.h"
#include "mediapipe/framework/formats/image.h"
#include "mediapipe/framework/formats/matrix.h"
#include "mediapipe/framework/packet.h"
#include "mediapipe/framework/port/integral_types.h"
#include "mediapipe/framework/timestamp.h"
#include "binding/image_frame.h"

namespace mediapipe {
    namespace autoit {
        template <typename T>
        const T& GetContent(const Packet& packet) {
            RaiseAutoItErrorIfNotOk(packet.ValidateAsType<T>());
            return packet.Get<T>();
        }
    }
}
