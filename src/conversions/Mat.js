const Point = "std::tuple<int, int>";

module.exports = (header = [], impl = [], options = {}) => {
    for (const args of [
        [
            ["int", "i0", "", []],
        ],
        [
            ["int", "row", "", []],
            ["int", "col", "", []],
        ],
        [
            ["int", "i0", "", []],
            ["int", "i1", "", []],
            ["int", "i2", "", []],
        ],
        [
            [Point, "pt", "", []],
        ],
    ]) {
        const argdecl = args.map(([argtype, argname]) => `${ argtype }${ argtype === Point ? "&" : "" } ${ argname }`).join(", ");
        const argexpr = args.map(([argtype, argname]) => (argtype === Point ? `cv::Point(std::get<0>(${ argname }), std::get<1>(${ argname }))` : argname)).join(", ");

        impl.push(`
            #include "Cv_Mat_Object.h"

            const double CCv_Mat_Object::at(${ argdecl }, HRESULT& hr) {
                const auto& m = *__self->get();

                switch (m.depth()) {
                case CV_8U:
                    return m.at<uchar>(${ argexpr });
                case CV_8S:
                    return m.at<char>(${ argexpr });
                case CV_16U:
                    return m.at<ushort>(${ argexpr });
                case CV_16S:
                    return m.at<short>(${ argexpr });
                case CV_32S:
                    return m.at<int>(${ argexpr });
                case CV_32F:
                    return m.at<float>(${ argexpr });
                case CV_64F:
                    return m.at<double>(${ argexpr });
                default:
                    hr = E_INVALIDARG;
                    return 0;
                }
            }

            void CCv_Mat_Object::set_at(${ argdecl }, double value, HRESULT& hr) {
                auto& m = *__self->get();

                switch (m.depth()) {
                case CV_8U:
                    m.at<uchar>(${ argexpr }) = static_cast<uchar>(value);
                    break;
                case CV_8S:
                    m.at<char>(${ argexpr }) = static_cast<char>(value);
                    break;
                case CV_16U:
                    m.at<ushort>(${ argexpr }) = static_cast<ushort>(value);
                    break;
                case CV_16S:
                    m.at<short>(${ argexpr }) = static_cast<short>(value);
                    break;
                case CV_32S:
                    m.at<int>(${ argexpr }) = static_cast<int>(value);
                    break;
                case CV_32F:
                    m.at<float>(${ argexpr }) = static_cast<float>(value);
                    break;
                case CV_64F:
                    m.at<double>(${ argexpr }) = value;
                    break;
                default:
                    hr = E_INVALIDARG;
                }
            }

        `.trim().replace(/^ {12}/mg, ""));
    }

    return [header.join("\n"), impl.join("\n")];
};
