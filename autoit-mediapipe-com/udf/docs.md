# AutoIt Mediapipe UDF

## Table Of Contents

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->


- [mediapipe::resource_util](#mediapiperesource_util)
  - [mediapipe::resource_util::set_resource_dir](#mediapiperesource_utilset_resource_dir)
- [cv](#cv)
  - [cv::createMatFromBitmap](#cvcreatematfrombitmap)
  - [cv::haveImageReader](#cvhaveimagereader)
  - [cv::haveImageWriter](#cvhaveimagewriter)
  - [cv::imcount](#cvimcount)
  - [cv::imdecode](#cvimdecode)
  - [cv::imencode](#cvimencode)
  - [cv::imread](#cvimread)
  - [cv::imreadmulti](#cvimreadmulti)
  - [cv::imwrite](#cvimwrite)
  - [cv::imwritemulti](#cvimwritemulti)
- [mediapipe::CalculatorGraph](#mediapipecalculatorgraph)
  - [mediapipe::CalculatorGraph::get_create](#mediapipecalculatorgraphget_create)
  - [mediapipe::CalculatorGraph::add_packet_to_input_stream](#mediapipecalculatorgraphadd_packet_to_input_stream)
  - [mediapipe::CalculatorGraph::close_all_packet_sources](#mediapipecalculatorgraphclose_all_packet_sources)
  - [mediapipe::CalculatorGraph::close_input_stream](#mediapipecalculatorgraphclose_input_stream)
  - [mediapipe::CalculatorGraph::get_combined_error_message](#mediapipecalculatorgraphget_combined_error_message)
  - [mediapipe::CalculatorGraph::get_output_side_packet](#mediapipecalculatorgraphget_output_side_packet)
  - [mediapipe::CalculatorGraph::has_error](#mediapipecalculatorgraphhas_error)
  - [mediapipe::CalculatorGraph::observe_output_stream](#mediapipecalculatorgraphobserve_output_stream)
  - [mediapipe::CalculatorGraph::start_run](#mediapipecalculatorgraphstart_run)
  - [mediapipe::CalculatorGraph::wait_for_observed_output](#mediapipecalculatorgraphwait_for_observed_output)
  - [mediapipe::CalculatorGraph::wait_until_done](#mediapipecalculatorgraphwait_until_done)
  - [mediapipe::CalculatorGraph::wait_until_idle](#mediapipecalculatorgraphwait_until_idle)
- [mediapipe::CalculatorGraphConfig](#mediapipecalculatorgraphconfig)
  - [mediapipe::CalculatorGraphConfig::get_create](#mediapipecalculatorgraphconfigget_create)
- [mediapipe::Image](#mediapipeimage)
  - [mediapipe::Image::get_create](#mediapipeimageget_create)
  - [mediapipe::Image::is_aligned](#mediapipeimageis_aligned)
  - [mediapipe::Image::is_contiguous](#mediapipeimageis_contiguous)
  - [mediapipe::Image::is_empty](#mediapipeimageis_empty)
  - [mediapipe::Image::mat_view](#mediapipeimagemat_view)
  - [mediapipe::Image::uses_gpu](#mediapipeimageuses_gpu)
- [mediapipe::ImageFrame](#mediapipeimageframe)
  - [mediapipe::ImageFrame::get_create](#mediapipeimageframeget_create)
  - [mediapipe::ImageFrame::is_aligned](#mediapipeimageframeis_aligned)
  - [mediapipe::ImageFrame::is_contiguous](#mediapipeimageframeis_contiguous)
  - [mediapipe::ImageFrame::is_empty](#mediapipeimageframeis_empty)
  - [mediapipe::ImageFrame::mat_view](#mediapipeimageframemat_view)
- [cv::Mat](#cvmat)
  - [cv::Mat::create](#cvmatcreate)
  - [cv::Mat::GdiplusResize](#cvmatgdiplusresize)
  - [cv::Mat::at](#cvmatat)
  - [cv::Mat::channels](#cvmatchannels)
  - [cv::Mat::checkVector](#cvmatcheckvector)
  - [cv::Mat::clone](#cvmatclone)
  - [cv::Mat::col](#cvmatcol)
  - [cv::Mat::colRange](#cvmatcolrange)
  - [cv::Mat::convertToBitmap](#cvmatconverttobitmap)
  - [cv::Mat::convertToShow](#cvmatconverttoshow)
  - [cv::Mat::copy](#cvmatcopy)
  - [cv::Mat::depth](#cvmatdepth)
  - [cv::Mat::diag](#cvmatdiag)
  - [cv::Mat::elemSize](#cvmatelemsize)
  - [cv::Mat::elemSize1](#cvmatelemsize1)
  - [cv::Mat::empty](#cvmatempty)
  - [cv::Mat::eye](#cvmateye)
  - [cv::Mat::get_Item](#cvmatget_item)
  - [cv::Mat::isContinuous](#cvmatiscontinuous)
  - [cv::Mat::isSubmatrix](#cvmatissubmatrix)
  - [cv::Mat::ones](#cvmatones)
  - [cv::Mat::pop_back](#cvmatpop_back)
  - [cv::Mat::ptr](#cvmatptr)
  - [cv::Mat::push_back](#cvmatpush_back)
  - [cv::Mat::put_Item](#cvmatput_item)
  - [cv::Mat::reshape](#cvmatreshape)
  - [cv::Mat::row](#cvmatrow)
  - [cv::Mat::rowRange](#cvmatrowrange)
  - [cv::Mat::set_at](#cvmatset_at)
  - [cv::Mat::size](#cvmatsize)
  - [cv::Mat::step1](#cvmatstep1)
  - [cv::Mat::t](#cvmatt)
  - [cv::Mat::total](#cvmattotal)
  - [cv::Mat::type](#cvmattype)
  - [cv::Mat::zeros](#cvmatzeros)
- [mediapipe::Packet](#mediapipepacket)
  - [mediapipe::Packet::get_create](#mediapipepacketget_create)
  - [mediapipe::Packet::at](#mediapipepacketat)
  - [mediapipe::Packet::get_timestamp](#mediapipepacketget_timestamp)
  - [mediapipe::Packet::is_empty](#mediapipepacketis_empty)
  - [mediapipe::Packet::put_timestamp](#mediapipepacketput_timestamp)
  - [mediapipe::Packet::str](#mediapipepacketstr)
- [mediapipe::autoit::packet_creator](#mediapipeautoitpacket_creator)
  - [mediapipe::autoit::packet_creator::create_bool](#mediapipeautoitpacket_creatorcreate_bool)
  - [mediapipe::autoit::packet_creator::create_bool_vector](#mediapipeautoitpacket_creatorcreate_bool_vector)
  - [mediapipe::autoit::packet_creator::create_double](#mediapipeautoitpacket_creatorcreate_double)
  - [mediapipe::autoit::packet_creator::create_float](#mediapipeautoitpacket_creatorcreate_float)
  - [mediapipe::autoit::packet_creator::create_float_array](#mediapipeautoitpacket_creatorcreate_float_array)
  - [mediapipe::autoit::packet_creator::create_float_vector](#mediapipeautoitpacket_creatorcreate_float_vector)
  - [mediapipe::autoit::packet_creator::create_image](#mediapipeautoitpacket_creatorcreate_image)
  - [mediapipe::autoit::packet_creator::create_image_frame](#mediapipeautoitpacket_creatorcreate_image_frame)
  - [mediapipe::autoit::packet_creator::create_image_vector](#mediapipeautoitpacket_creatorcreate_image_vector)
  - [mediapipe::autoit::packet_creator::create_int](#mediapipeautoitpacket_creatorcreate_int)
  - [mediapipe::autoit::packet_creator::create_int16](#mediapipeautoitpacket_creatorcreate_int16)
  - [mediapipe::autoit::packet_creator::create_int32](#mediapipeautoitpacket_creatorcreate_int32)
  - [mediapipe::autoit::packet_creator::create_int64](#mediapipeautoitpacket_creatorcreate_int64)
  - [mediapipe::autoit::packet_creator::create_int8](#mediapipeautoitpacket_creatorcreate_int8)
  - [mediapipe::autoit::packet_creator::create_int_array](#mediapipeautoitpacket_creatorcreate_int_array)
  - [mediapipe::autoit::packet_creator::create_int_vector](#mediapipeautoitpacket_creatorcreate_int_vector)
  - [mediapipe::autoit::packet_creator::create_packet_vector](#mediapipeautoitpacket_creatorcreate_packet_vector)
  - [mediapipe::autoit::packet_creator::create_proto](#mediapipeautoitpacket_creatorcreate_proto)
  - [mediapipe::autoit::packet_creator::create_string](#mediapipeautoitpacket_creatorcreate_string)
  - [mediapipe::autoit::packet_creator::create_string_to_packet_map](#mediapipeautoitpacket_creatorcreate_string_to_packet_map)
  - [mediapipe::autoit::packet_creator::create_string_vector](#mediapipeautoitpacket_creatorcreate_string_vector)
  - [mediapipe::autoit::packet_creator::create_uint16](#mediapipeautoitpacket_creatorcreate_uint16)
  - [mediapipe::autoit::packet_creator::create_uint32](#mediapipeautoitpacket_creatorcreate_uint32)
  - [mediapipe::autoit::packet_creator::create_uint64](#mediapipeautoitpacket_creatorcreate_uint64)
  - [mediapipe::autoit::packet_creator::create_uint8](#mediapipeautoitpacket_creatorcreate_uint8)
- [mediapipe::autoit::packet_getter](#mediapipeautoitpacket_getter)
  - [mediapipe::autoit::packet_getter::get_bool](#mediapipeautoitpacket_getterget_bool)
  - [mediapipe::autoit::packet_getter::get_bool_list](#mediapipeautoitpacket_getterget_bool_list)
  - [mediapipe::autoit::packet_getter::get_float](#mediapipeautoitpacket_getterget_float)
  - [mediapipe::autoit::packet_getter::get_float_list](#mediapipeautoitpacket_getterget_float_list)
  - [mediapipe::autoit::packet_getter::get_image](#mediapipeautoitpacket_getterget_image)
  - [mediapipe::autoit::packet_getter::get_image_frame](#mediapipeautoitpacket_getterget_image_frame)
  - [mediapipe::autoit::packet_getter::get_image_list](#mediapipeautoitpacket_getterget_image_list)
  - [mediapipe::autoit::packet_getter::get_int](#mediapipeautoitpacket_getterget_int)
  - [mediapipe::autoit::packet_getter::get_int_list](#mediapipeautoitpacket_getterget_int_list)
  - [mediapipe::autoit::packet_getter::get_packet_list](#mediapipeautoitpacket_getterget_packet_list)
  - [mediapipe::autoit::packet_getter::get_str](#mediapipeautoitpacket_getterget_str)
  - [mediapipe::autoit::packet_getter::get_str_list](#mediapipeautoitpacket_getterget_str_list)
  - [mediapipe::autoit::packet_getter::get_str_to_packet_dict](#mediapipeautoitpacket_getterget_str_to_packet_dict)
  - [mediapipe::autoit::packet_getter::get_uint](#mediapipeautoitpacket_getterget_uint)
- [mediapipe::Detection](#mediapipedetection)
  - [mediapipe::Detection::get_create](#mediapipedetectionget_create)
- [google::protobuf::TextFormat](#googleprotobuftextformat)
  - [google::protobuf::TextFormat::Parse](#googleprotobuftextformatparse)
- [cv::Range](#cvrange)
  - [cv::Range::get_create](#cvrangeget_create)
  - [cv::Range::all](#cvrangeall)
  - [cv::Range::empty](#cvrangeempty)
  - [cv::Range::size](#cvrangesize)
- [mediapipe::Timestamp](#mediapipetimestamp)
  - [mediapipe::Timestamp::get_create](#mediapipetimestampget_create)
  - [mediapipe::Timestamp::eq](#mediapipetimestampeq)
  - [mediapipe::Timestamp::from_seconds](#mediapipetimestampfrom_seconds)
  - [mediapipe::Timestamp::ge](#mediapipetimestampge)
  - [mediapipe::Timestamp::gt](#mediapipetimestampgt)
  - [mediapipe::Timestamp::is_allowed_in_stream](#mediapipetimestampis_allowed_in_stream)
  - [mediapipe::Timestamp::is_range_value](#mediapipetimestampis_range_value)
  - [mediapipe::Timestamp::is_special_value](#mediapipetimestampis_special_value)
  - [mediapipe::Timestamp::le](#mediapipetimestample)
  - [mediapipe::Timestamp::lt](#mediapipetimestamplt)
  - [mediapipe::Timestamp::microseconds](#mediapipetimestampmicroseconds)
  - [mediapipe::Timestamp::ne](#mediapipetimestampne)
  - [mediapipe::Timestamp::seconds](#mediapipetimestampseconds)
  - [mediapipe::Timestamp::str](#mediapipetimestampstr)
- [mediapipe::ValidatedGraphConfig](#mediapipevalidatedgraphconfig)
  - [mediapipe::ValidatedGraphConfig::get_create](#mediapipevalidatedgraphconfigget_create)
  - [mediapipe::ValidatedGraphConfig::initialize](#mediapipevalidatedgraphconfiginitialize)
  - [mediapipe::ValidatedGraphConfig::initialized](#mediapipevalidatedgraphconfiginitialized)
  - [mediapipe::ValidatedGraphConfig::registered_side_packet_type_name](#mediapipevalidatedgraphconfigregistered_side_packet_type_name)
  - [mediapipe::ValidatedGraphConfig::registered_stream_type_name](#mediapipevalidatedgraphconfigregistered_stream_type_name)
- [VectorOfVariant](#vectorofvariant)
  - [VectorOfVariant::create](#vectorofvariantcreate)
  - [VectorOfVariant::Add](#vectorofvariantadd)
  - [VectorOfVariant::Items](#vectorofvariantitems)
  - [VectorOfVariant::Keys](#vectorofvariantkeys)
  - [VectorOfVariant::Remove](#vectorofvariantremove)
  - [VectorOfVariant::at](#vectorofvariantat)
  - [VectorOfVariant::clear](#vectorofvariantclear)
  - [VectorOfVariant::empty](#vectorofvariantempty)
  - [VectorOfVariant::end](#vectorofvariantend)
  - [VectorOfVariant::get_Item](#vectorofvariantget_item)
  - [VectorOfVariant::push_back](#vectorofvariantpush_back)
  - [VectorOfVariant::push_vector](#vectorofvariantpush_vector)
  - [VectorOfVariant::put_Item](#vectorofvariantput_item)
  - [VectorOfVariant::size](#vectorofvariantsize)
  - [VectorOfVariant::slice](#vectorofvariantslice)
  - [VectorOfVariant::sort](#vectorofvariantsort)
  - [VectorOfVariant::sort_variant](#vectorofvariantsort_variant)
  - [VectorOfVariant::start](#vectorofvariantstart)
- [VectorOfInt](#vectorofint)
  - [VectorOfInt::create](#vectorofintcreate)
  - [VectorOfInt::Add](#vectorofintadd)
  - [VectorOfInt::Items](#vectorofintitems)
  - [VectorOfInt::Keys](#vectorofintkeys)
  - [VectorOfInt::Remove](#vectorofintremove)
  - [VectorOfInt::at](#vectorofintat)
  - [VectorOfInt::clear](#vectorofintclear)
  - [VectorOfInt::empty](#vectorofintempty)
  - [VectorOfInt::end](#vectorofintend)
  - [VectorOfInt::get_Item](#vectorofintget_item)
  - [VectorOfInt::push_back](#vectorofintpush_back)
  - [VectorOfInt::push_vector](#vectorofintpush_vector)
  - [VectorOfInt::put_Item](#vectorofintput_item)
  - [VectorOfInt::size](#vectorofintsize)
  - [VectorOfInt::slice](#vectorofintslice)
  - [VectorOfInt::sort](#vectorofintsort)
  - [VectorOfInt::sort_variant](#vectorofintsort_variant)
  - [VectorOfInt::start](#vectorofintstart)
- [VectorOfUchar](#vectorofuchar)
  - [VectorOfUchar::create](#vectorofucharcreate)
  - [VectorOfUchar::Add](#vectorofucharadd)
  - [VectorOfUchar::Items](#vectorofucharitems)
  - [VectorOfUchar::Keys](#vectorofucharkeys)
  - [VectorOfUchar::Remove](#vectorofucharremove)
  - [VectorOfUchar::at](#vectorofucharat)
  - [VectorOfUchar::clear](#vectorofucharclear)
  - [VectorOfUchar::empty](#vectorofucharempty)
  - [VectorOfUchar::end](#vectorofucharend)
  - [VectorOfUchar::get_Item](#vectorofucharget_item)
  - [VectorOfUchar::push_back](#vectorofucharpush_back)
  - [VectorOfUchar::push_vector](#vectorofucharpush_vector)
  - [VectorOfUchar::put_Item](#vectorofucharput_item)
  - [VectorOfUchar::size](#vectorofucharsize)
  - [VectorOfUchar::slice](#vectorofucharslice)
  - [VectorOfUchar::sort](#vectorofucharsort)
  - [VectorOfUchar::sort_variant](#vectorofucharsort_variant)
  - [VectorOfUchar::start](#vectorofucharstart)
- [VectorOfMat](#vectorofmat)
  - [VectorOfMat::create](#vectorofmatcreate)
  - [VectorOfMat::Add](#vectorofmatadd)
  - [VectorOfMat::Items](#vectorofmatitems)
  - [VectorOfMat::Keys](#vectorofmatkeys)
  - [VectorOfMat::Remove](#vectorofmatremove)
  - [VectorOfMat::at](#vectorofmatat)
  - [VectorOfMat::clear](#vectorofmatclear)
  - [VectorOfMat::empty](#vectorofmatempty)
  - [VectorOfMat::end](#vectorofmatend)
  - [VectorOfMat::get_Item](#vectorofmatget_item)
  - [VectorOfMat::push_back](#vectorofmatpush_back)
  - [VectorOfMat::push_vector](#vectorofmatpush_vector)
  - [VectorOfMat::put_Item](#vectorofmatput_item)
  - [VectorOfMat::size](#vectorofmatsize)
  - [VectorOfMat::slice](#vectorofmatslice)
  - [VectorOfMat::sort](#vectorofmatsort)
  - [VectorOfMat::sort_variant](#vectorofmatsort_variant)
  - [VectorOfMat::start](#vectorofmatstart)
- [MapOfStringAndPacket](#mapofstringandpacket)
  - [MapOfStringAndPacket::create](#mapofstringandpacketcreate)
  - [MapOfStringAndPacket::Add](#mapofstringandpacketadd)
  - [MapOfStringAndPacket::Get](#mapofstringandpacketget)
  - [MapOfStringAndPacket::Items](#mapofstringandpacketitems)
  - [MapOfStringAndPacket::Keys](#mapofstringandpacketkeys)
  - [MapOfStringAndPacket::Remove](#mapofstringandpacketremove)
  - [MapOfStringAndPacket::clear](#mapofstringandpacketclear)
  - [MapOfStringAndPacket::contains](#mapofstringandpacketcontains)
  - [MapOfStringAndPacket::count](#mapofstringandpacketcount)
  - [MapOfStringAndPacket::empty](#mapofstringandpacketempty)
  - [MapOfStringAndPacket::erase](#mapofstringandpacketerase)
  - [MapOfStringAndPacket::get_Item](#mapofstringandpacketget_item)
  - [MapOfStringAndPacket::has](#mapofstringandpackethas)
  - [MapOfStringAndPacket::max_size](#mapofstringandpacketmax_size)
  - [MapOfStringAndPacket::merge](#mapofstringandpacketmerge)
  - [MapOfStringAndPacket::put_Item](#mapofstringandpacketput_item)
  - [MapOfStringAndPacket::size](#mapofstringandpacketsize)
- [VectorOfBool](#vectorofbool)
  - [VectorOfBool::create](#vectorofboolcreate)
  - [VectorOfBool::Add](#vectorofbooladd)
  - [VectorOfBool::Items](#vectorofboolitems)
  - [VectorOfBool::Keys](#vectorofboolkeys)
  - [VectorOfBool::Remove](#vectorofboolremove)
  - [VectorOfBool::at](#vectorofboolat)
  - [VectorOfBool::clear](#vectorofboolclear)
  - [VectorOfBool::empty](#vectorofboolempty)
  - [VectorOfBool::end](#vectorofboolend)
  - [VectorOfBool::get_Item](#vectorofboolget_item)
  - [VectorOfBool::push_back](#vectorofboolpush_back)
  - [VectorOfBool::push_vector](#vectorofboolpush_vector)
  - [VectorOfBool::put_Item](#vectorofboolput_item)
  - [VectorOfBool::size](#vectorofboolsize)
  - [VectorOfBool::slice](#vectorofboolslice)
  - [VectorOfBool::sort](#vectorofboolsort)
  - [VectorOfBool::sort_variant](#vectorofboolsort_variant)
  - [VectorOfBool::start](#vectorofboolstart)
- [VectorOfFloat](#vectoroffloat)
  - [VectorOfFloat::create](#vectoroffloatcreate)
  - [VectorOfFloat::Add](#vectoroffloatadd)
  - [VectorOfFloat::Items](#vectoroffloatitems)
  - [VectorOfFloat::Keys](#vectoroffloatkeys)
  - [VectorOfFloat::Remove](#vectoroffloatremove)
  - [VectorOfFloat::at](#vectoroffloatat)
  - [VectorOfFloat::clear](#vectoroffloatclear)
  - [VectorOfFloat::empty](#vectoroffloatempty)
  - [VectorOfFloat::end](#vectoroffloatend)
  - [VectorOfFloat::get_Item](#vectoroffloatget_item)
  - [VectorOfFloat::push_back](#vectoroffloatpush_back)
  - [VectorOfFloat::push_vector](#vectoroffloatpush_vector)
  - [VectorOfFloat::put_Item](#vectoroffloatput_item)
  - [VectorOfFloat::size](#vectoroffloatsize)
  - [VectorOfFloat::slice](#vectoroffloatslice)
  - [VectorOfFloat::sort](#vectoroffloatsort)
  - [VectorOfFloat::sort_variant](#vectoroffloatsort_variant)
  - [VectorOfFloat::start](#vectoroffloatstart)
- [VectorOfImage](#vectorofimage)
  - [VectorOfImage::create](#vectorofimagecreate)
  - [VectorOfImage::Add](#vectorofimageadd)
  - [VectorOfImage::Items](#vectorofimageitems)
  - [VectorOfImage::Keys](#vectorofimagekeys)
  - [VectorOfImage::Remove](#vectorofimageremove)
  - [VectorOfImage::at](#vectorofimageat)
  - [VectorOfImage::clear](#vectorofimageclear)
  - [VectorOfImage::empty](#vectorofimageempty)
  - [VectorOfImage::end](#vectorofimageend)
  - [VectorOfImage::get_Item](#vectorofimageget_item)
  - [VectorOfImage::push_back](#vectorofimagepush_back)
  - [VectorOfImage::push_vector](#vectorofimagepush_vector)
  - [VectorOfImage::put_Item](#vectorofimageput_item)
  - [VectorOfImage::size](#vectorofimagesize)
  - [VectorOfImage::slice](#vectorofimageslice)
  - [VectorOfImage::sort](#vectorofimagesort)
  - [VectorOfImage::sort_variant](#vectorofimagesort_variant)
  - [VectorOfImage::start](#vectorofimagestart)
- [VectorOfPacket](#vectorofpacket)
  - [VectorOfPacket::create](#vectorofpacketcreate)
  - [VectorOfPacket::Add](#vectorofpacketadd)
  - [VectorOfPacket::Items](#vectorofpacketitems)
  - [VectorOfPacket::Keys](#vectorofpacketkeys)
  - [VectorOfPacket::Remove](#vectorofpacketremove)
  - [VectorOfPacket::at](#vectorofpacketat)
  - [VectorOfPacket::clear](#vectorofpacketclear)
  - [VectorOfPacket::empty](#vectorofpacketempty)
  - [VectorOfPacket::end](#vectorofpacketend)
  - [VectorOfPacket::get_Item](#vectorofpacketget_item)
  - [VectorOfPacket::push_back](#vectorofpacketpush_back)
  - [VectorOfPacket::push_vector](#vectorofpacketpush_vector)
  - [VectorOfPacket::put_Item](#vectorofpacketput_item)
  - [VectorOfPacket::size](#vectorofpacketsize)
  - [VectorOfPacket::slice](#vectorofpacketslice)
  - [VectorOfPacket::sort](#vectorofpacketsort)
  - [VectorOfPacket::sort_variant](#vectorofpacketsort_variant)
  - [VectorOfPacket::start](#vectorofpacketstart)
- [VectorOfString](#vectorofstring)
  - [VectorOfString::create](#vectorofstringcreate)
  - [VectorOfString::Add](#vectorofstringadd)
  - [VectorOfString::Items](#vectorofstringitems)
  - [VectorOfString::Keys](#vectorofstringkeys)
  - [VectorOfString::Remove](#vectorofstringremove)
  - [VectorOfString::at](#vectorofstringat)
  - [VectorOfString::clear](#vectorofstringclear)
  - [VectorOfString::empty](#vectorofstringempty)
  - [VectorOfString::end](#vectorofstringend)
  - [VectorOfString::get_Item](#vectorofstringget_item)
  - [VectorOfString::push_back](#vectorofstringpush_back)
  - [VectorOfString::push_vector](#vectorofstringpush_vector)
  - [VectorOfString::put_Item](#vectorofstringput_item)
  - [VectorOfString::size](#vectorofstringsize)
  - [VectorOfString::slice](#vectorofstringslice)
  - [VectorOfString::sort](#vectorofstringsort)
  - [VectorOfString::sort_variant](#vectorofstringsort_variant)
  - [VectorOfString::start](#vectorofstringstart)
- [VectorOfInt64](#vectorofint64)
  - [VectorOfInt64::create](#vectorofint64create)
  - [VectorOfInt64::Add](#vectorofint64add)
  - [VectorOfInt64::Items](#vectorofint64items)
  - [VectorOfInt64::Keys](#vectorofint64keys)
  - [VectorOfInt64::Remove](#vectorofint64remove)
  - [VectorOfInt64::at](#vectorofint64at)
  - [VectorOfInt64::clear](#vectorofint64clear)
  - [VectorOfInt64::empty](#vectorofint64empty)
  - [VectorOfInt64::end](#vectorofint64end)
  - [VectorOfInt64::get_Item](#vectorofint64get_item)
  - [VectorOfInt64::push_back](#vectorofint64push_back)
  - [VectorOfInt64::push_vector](#vectorofint64push_vector)
  - [VectorOfInt64::put_Item](#vectorofint64put_item)
  - [VectorOfInt64::size](#vectorofint64size)
  - [VectorOfInt64::slice](#vectorofint64slice)
  - [VectorOfInt64::sort](#vectorofint64sort)
  - [VectorOfInt64::sort_variant](#vectorofint64sort_variant)
  - [VectorOfInt64::start](#vectorofint64start)
- [VectorOfPairOfStringAndPacket](#vectorofpairofstringandpacket)
  - [VectorOfPairOfStringAndPacket::create](#vectorofpairofstringandpacketcreate)
  - [VectorOfPairOfStringAndPacket::Add](#vectorofpairofstringandpacketadd)
  - [VectorOfPairOfStringAndPacket::Items](#vectorofpairofstringandpacketitems)
  - [VectorOfPairOfStringAndPacket::Keys](#vectorofpairofstringandpacketkeys)
  - [VectorOfPairOfStringAndPacket::Remove](#vectorofpairofstringandpacketremove)
  - [VectorOfPairOfStringAndPacket::at](#vectorofpairofstringandpacketat)
  - [VectorOfPairOfStringAndPacket::clear](#vectorofpairofstringandpacketclear)
  - [VectorOfPairOfStringAndPacket::empty](#vectorofpairofstringandpacketempty)
  - [VectorOfPairOfStringAndPacket::end](#vectorofpairofstringandpacketend)
  - [VectorOfPairOfStringAndPacket::get_Item](#vectorofpairofstringandpacketget_item)
  - [VectorOfPairOfStringAndPacket::push_back](#vectorofpairofstringandpacketpush_back)
  - [VectorOfPairOfStringAndPacket::push_vector](#vectorofpairofstringandpacketpush_vector)
  - [VectorOfPairOfStringAndPacket::put_Item](#vectorofpairofstringandpacketput_item)
  - [VectorOfPairOfStringAndPacket::size](#vectorofpairofstringandpacketsize)
  - [VectorOfPairOfStringAndPacket::slice](#vectorofpairofstringandpacketslice)
  - [VectorOfPairOfStringAndPacket::sort](#vectorofpairofstringandpacketsort)
  - [VectorOfPairOfStringAndPacket::sort_variant](#vectorofpairofstringandpacketsort_variant)
  - [VectorOfPairOfStringAndPacket::start](#vectorofpairofstringandpacketstart)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## mediapipe::resource_util

### mediapipe::resource_util::set_resource_dir

```cpp
void mediapipe::resource_util::set_resource_dir( const std::string& str );
AutoIt:
    _Mediapipe_ObjCreate("mediapipe.resource_util").set_resource_dir( $str ) -> None
```

## cv

### cv::createMatFromBitmap

```cpp
cv::Mat cv::createMatFromBitmap( void* ptr,
                                 bool  copy = true );
AutoIt:
    _Mediapipe_ObjCreate("cv").createMatFromBitmap( $ptr[, $copy] ) -> retval
```

### cv::haveImageReader

```cpp
bool cv::haveImageReader( std::string filename );
AutoIt:
    _Mediapipe_ObjCreate("cv").haveImageReader( $filename ) -> retval
```

### cv::haveImageWriter

```cpp
bool cv::haveImageWriter( std::string filename );
AutoIt:
    _Mediapipe_ObjCreate("cv").haveImageWriter( $filename ) -> retval
```

### cv::imcount

```cpp
size_t cv::imcount( std::string filename,
                    int         flags = IMREAD_ANYCOLOR );
AutoIt:
    _Mediapipe_ObjCreate("cv").imcount( $filename[, $flags] ) -> retval
```

### cv::imdecode

```cpp
cv::Mat cv::imdecode( cv::Mat buf,
                      int     flags );
AutoIt:
    _Mediapipe_ObjCreate("cv").imdecode( $buf, $flags ) -> retval
```

### cv::imencode

```cpp
bool cv::imencode( std::string        ext,
                   cv::Mat            img,
                   std::vector<uchar> buf,
                   std::vector<int>   params = std::vector<int>() );
AutoIt:
    _Mediapipe_ObjCreate("cv").imencode( $ext, $img[, $params[, $buf]] ) -> retval, $buf
```

### cv::imread

```cpp
cv::Mat cv::imread( std::string filename,
                    int         flags = IMREAD_COLOR );
AutoIt:
    _Mediapipe_ObjCreate("cv").imread( $filename[, $flags] ) -> retval
```

### cv::imreadmulti

```cpp
bool cv::imreadmulti( std::string          filename,
                      std::vector<cv::Mat> mats,
                      int                  flags = IMREAD_ANYCOLOR );
AutoIt:
    _Mediapipe_ObjCreate("cv").imreadmulti( $filename[, $flags[, $mats]] ) -> retval, $mats
```

```cpp
bool cv::imreadmulti( std::string          filename,
                      std::vector<cv::Mat> mats,
                      int                  start,
                      int                  count,
                      int                  flags = IMREAD_ANYCOLOR );
AutoIt:
    _Mediapipe_ObjCreate("cv").imreadmulti( $filename, $start, $count[, $flags[, $mats]] ) -> retval, $mats
```

### cv::imwrite

```cpp
bool cv::imwrite( std::string      filename,
                  cv::Mat          img,
                  std::vector<int> params = std::vector<int>() );
AutoIt:
    _Mediapipe_ObjCreate("cv").imwrite( $filename, $img[, $params] ) -> retval
```

### cv::imwritemulti

```cpp
bool cv::imwritemulti( std::string          filename,
                       std::vector<cv::Mat> img,
                       std::vector<int>     params = std::vector<int>() );
AutoIt:
    _Mediapipe_ObjCreate("cv").imwritemulti( $filename, $img[, $params] ) -> retval
```

## mediapipe::CalculatorGraph

### mediapipe::CalculatorGraph::get_create

```cpp
static std::shared_ptr<mediapipe::CalculatorGraph> mediapipe::CalculatorGraph::get_create( mediapipe::CalculatorGraphConfig& graph_config_proto );
AutoIt:
    _Mediapipe_ObjCreate("mediapipe.CalculatorGraph").create( $graph_config_proto ) -> retval
    _Mediapipe_ObjCreate("mediapipe.CalculatorGraph")( $graph_config_proto ) -> retval
```

```cpp
static std::shared_ptr<mediapipe::CalculatorGraph> mediapipe::CalculatorGraph::get_create( std::string& binary_graph_path = "",
                                                                                           std::string& graph_config = "" );
AutoIt:
    _Mediapipe_ObjCreate("mediapipe.CalculatorGraph").create( [$binary_graph_path[, $graph_config]] ) -> retval
    _Mediapipe_ObjCreate("mediapipe.CalculatorGraph")( [$binary_graph_path[, $graph_config]] ) -> retval
```

```cpp
static std::shared_ptr<mediapipe::CalculatorGraph> mediapipe::CalculatorGraph::get_create( mediapipe::ValidatedGraphConfig& validated_graph_config );
AutoIt:
    _Mediapipe_ObjCreate("mediapipe.CalculatorGraph").create( $validated_graph_config ) -> retval
    _Mediapipe_ObjCreate("mediapipe.CalculatorGraph")( $validated_graph_config ) -> retval
```

### mediapipe::CalculatorGraph::add_packet_to_input_stream

```cpp
void mediapipe::CalculatorGraph::add_packet_to_input_stream( std::string&          stream,
                                                             mediapipe::Packet&    packet,
                                                             mediapipe::Timestamp& timestamp = Timestamp::Unset() );
AutoIt:
    $oCalculatorGraph.add_packet_to_input_stream( $stream, $packet[, $timestamp] ) -> None
```

### mediapipe::CalculatorGraph::close_all_packet_sources

```cpp
void mediapipe::CalculatorGraph::close_all_packet_sources();
AutoIt:
    $oCalculatorGraph.close_all_packet_sources() -> None
```

### mediapipe::CalculatorGraph::close_input_stream

```cpp
void mediapipe::CalculatorGraph::close_input_stream( std::string& stream );
AutoIt:
    $oCalculatorGraph.close_input_stream( $stream ) -> None
```

### mediapipe::CalculatorGraph::get_combined_error_message

```cpp
std::string mediapipe::CalculatorGraph::get_combined_error_message();
AutoIt:
    $oCalculatorGraph.get_combined_error_message() -> retval
```

### mediapipe::CalculatorGraph::get_output_side_packet

```cpp
mediapipe::Packet mediapipe::CalculatorGraph::get_output_side_packet( std::string& packet_name );
AutoIt:
    $oCalculatorGraph.get_output_side_packet( $packet_name ) -> retval
```

### mediapipe::CalculatorGraph::has_error

```cpp
bool mediapipe::CalculatorGraph::has_error();
AutoIt:
    $oCalculatorGraph.has_error() -> retval
```

### mediapipe::CalculatorGraph::observe_output_stream

```cpp
void mediapipe::CalculatorGraph::observe_output_stream( std::string&                            stream_name,
                                                        mediapipe::autoit::StreamPacketCallback callback_fn,
                                                        bool                                    observe_timestamp_bounds = false );
AutoIt:
    $oCalculatorGraph.observe_output_stream( $stream_name, $callback_fn[, $observe_timestamp_bounds] ) -> None
```

### mediapipe::CalculatorGraph::start_run

```cpp
void mediapipe::CalculatorGraph::start_run( std::map<std::string, mediapipe::Packet>& input_side_packets );
AutoIt:
    $oCalculatorGraph.start_run( $input_side_packets ) -> None
```

### mediapipe::CalculatorGraph::wait_for_observed_output

```cpp
void mediapipe::CalculatorGraph::wait_for_observed_output();
AutoIt:
    $oCalculatorGraph.wait_for_observed_output() -> None
```

### mediapipe::CalculatorGraph::wait_until_done

```cpp
void mediapipe::CalculatorGraph::wait_until_done();
AutoIt:
    $oCalculatorGraph.wait_until_done() -> None
```

### mediapipe::CalculatorGraph::wait_until_idle

```cpp
void mediapipe::CalculatorGraph::wait_until_idle();
AutoIt:
    $oCalculatorGraph.wait_until_idle() -> None
```

## mediapipe::CalculatorGraphConfig

### mediapipe::CalculatorGraphConfig::get_create

```cpp
static mediapipe::CalculatorGraphConfig mediapipe::CalculatorGraphConfig::get_create();
AutoIt:
    _Mediapipe_ObjCreate("mediapipe.CalculatorGraphConfig").create() -> <mediapipe.CalculatorGraphConfig object>
    _Mediapipe_ObjCreate("mediapipe.CalculatorGraphConfig")() -> <mediapipe.CalculatorGraphConfig object>
```

## mediapipe::Image

### mediapipe::Image::get_create

```cpp
static mediapipe::Image mediapipe::Image::get_create();
AutoIt:
    _Mediapipe_ObjCreate("mediapipe.Image").create() -> <mediapipe.Image object>
    _Mediapipe_ObjCreate("mediapipe.Image")() -> <mediapipe.Image object>
```

```cpp
static std::shared_ptr<mediapipe::Image> mediapipe::Image::get_create( int            image_format,
                                                                       const cv::Mat& image,
                                                                       bool           copy = true );
AutoIt:
    _Mediapipe_ObjCreate("mediapipe.Image").create( $image_format, $image[, $copy] ) -> retval
    _Mediapipe_ObjCreate("mediapipe.Image")( $image_format, $image[, $copy] ) -> retval
```

```cpp
static std::shared_ptr<mediapipe::Image> mediapipe::Image::get_create( const cv::Mat& image,
                                                                       bool           copy = true );
AutoIt:
    _Mediapipe_ObjCreate("mediapipe.Image").create( $image[, $copy] ) -> retval
    _Mediapipe_ObjCreate("mediapipe.Image")( $image[, $copy] ) -> retval
```

### mediapipe::Image::is_aligned

```cpp
bool mediapipe::Image::is_aligned( uint32 alignment_boundary );
AutoIt:
    $oImage.is_aligned( $alignment_boundary ) -> retval
```

### mediapipe::Image::is_contiguous

```cpp
bool mediapipe::Image::is_contiguous();
AutoIt:
    $oImage.is_contiguous() -> retval
```

### mediapipe::Image::is_empty

```cpp
bool mediapipe::Image::is_empty();
AutoIt:
    $oImage.is_empty() -> retval
```

### mediapipe::Image::mat_view

```cpp
cv::Mat mediapipe::Image::mat_view();
AutoIt:
    $oImage.mat_view() -> retval
```

### mediapipe::Image::uses_gpu

```cpp
bool mediapipe::Image::uses_gpu();
AutoIt:
    $oImage.uses_gpu() -> retval
```

## mediapipe::ImageFrame

### mediapipe::ImageFrame::get_create

```cpp
static std::shared_ptr<mediapipe::ImageFrame> mediapipe::ImageFrame::get_create( int            image_format,
                                                                                 const cv::Mat& image,
                                                                                 bool           copy = true );
AutoIt:
    _Mediapipe_ObjCreate("mediapipe.ImageFrame").create( $image_format, $image[, $copy] ) -> retval
    _Mediapipe_ObjCreate("mediapipe.ImageFrame")( $image_format, $image[, $copy] ) -> retval
```

```cpp
static std::shared_ptr<mediapipe::ImageFrame> mediapipe::ImageFrame::get_create( const cv::Mat& image,
                                                                                 bool           copy = true );
AutoIt:
    _Mediapipe_ObjCreate("mediapipe.ImageFrame").create( $image[, $copy] ) -> retval
    _Mediapipe_ObjCreate("mediapipe.ImageFrame")( $image[, $copy] ) -> retval
```

### mediapipe::ImageFrame::is_aligned

```cpp
bool mediapipe::ImageFrame::is_aligned( uint32 alignment_boundary );
AutoIt:
    $oImageFrame.is_aligned( $alignment_boundary ) -> retval
```

### mediapipe::ImageFrame::is_contiguous

```cpp
bool mediapipe::ImageFrame::is_contiguous();
AutoIt:
    $oImageFrame.is_contiguous() -> retval
```

### mediapipe::ImageFrame::is_empty

```cpp
bool mediapipe::ImageFrame::is_empty();
AutoIt:
    $oImageFrame.is_empty() -> retval
```

### mediapipe::ImageFrame::mat_view

```cpp
cv::Mat mediapipe::ImageFrame::mat_view();
AutoIt:
    $oImageFrame.mat_view() -> retval
```

## cv::Mat

### cv::Mat::create

```cpp
static cv::Mat cv::Mat::create();
AutoIt:
    _Mediapipe_ObjCreate("cv.Mat").create() -> <cv.Mat object>
```

```cpp
static cv::Mat cv::Mat::create( int rows,
                                int cols,
                                int type );
AutoIt:
    _Mediapipe_ObjCreate("cv.Mat").create( $rows, $cols, $type ) -> <cv.Mat object>
```

```cpp
static cv::Mat cv::Mat::create( std::tuple<int, int> size,
                                int                  type );
AutoIt:
    _Mediapipe_ObjCreate("cv.Mat").create( $size, $type ) -> <cv.Mat object>
```

```cpp
static cv::Mat cv::Mat::create( int                                        rows,
                                int                                        cols,
                                int                                        type,
                                std::tuple<double, double, double, double> s );
AutoIt:
    _Mediapipe_ObjCreate("cv.Mat").create( $rows, $cols, $type, $s ) -> <cv.Mat object>
```

```cpp
static cv::Mat cv::Mat::create( std::tuple<int, int>                       size,
                                int                                        type,
                                std::tuple<double, double, double, double> s );
AutoIt:
    _Mediapipe_ObjCreate("cv.Mat").create( $size, $type, $s ) -> <cv.Mat object>
```

```cpp
static cv::Mat cv::Mat::create( int    rows,
                                int    cols,
                                int    type,
                                void*  data,
                                size_t step = cv::Mat::AUTO_STEP );
AutoIt:
    _Mediapipe_ObjCreate("cv.Mat").create( $rows, $cols, $type, $data[, $step] ) -> <cv.Mat object>
```

```cpp
static cv::Mat cv::Mat::create( cv::Mat m );
AutoIt:
    _Mediapipe_ObjCreate("cv.Mat").create( $m ) -> <cv.Mat object>
```

```cpp
static cv::Mat cv::Mat::create( cv::Mat                        src,
                                std::tuple<int, int, int, int> roi );
AutoIt:
    _Mediapipe_ObjCreate("cv.Mat").create( $src, $roi ) -> <cv.Mat object>
```

### cv::Mat::GdiplusResize

```cpp
cv::Mat cv::Mat::GdiplusResize( float newWidth,
                                float newHeight,
                                int   interpolation = 7 );
AutoIt:
    $oMat.GdiplusResize( $newWidth, $newHeight[, $interpolation] ) -> retval
```

### cv::Mat::at

```cpp
double cv::Mat::at( int i0 );
AutoIt:
    $oMat.at( $i0 ) -> retval
```

```cpp
double cv::Mat::at( int row,
                    int col );
AutoIt:
    $oMat.at( $row, $col ) -> retval
```

```cpp
double cv::Mat::at( int i0,
                    int i1,
                    int i2 );
AutoIt:
    $oMat.at( $i0, $i1, $i2 ) -> retval
```

```cpp
double cv::Mat::at( std::tuple<int, int> pt );
AutoIt:
    $oMat.at( $pt ) -> retval
```

### cv::Mat::channels

```cpp
int cv::Mat::channels();
AutoIt:
    $oMat.channels() -> retval
```

### cv::Mat::checkVector

```cpp
int cv::Mat::checkVector( int elemChannels,
                          int depth = -1,
                          int requireContinuous = true );
AutoIt:
    $oMat.checkVector( $elemChannels[, $depth[, $requireContinuous]] ) -> retval
```

### cv::Mat::clone

```cpp
cv::Mat cv::Mat::clone();
AutoIt:
    $oMat.clone() -> retval
```

### cv::Mat::col

```cpp
cv::Mat cv::Mat::col( int x );
AutoIt:
    $oMat.col( $x ) -> retval
```

### cv::Mat::colRange

```cpp
cv::Mat cv::Mat::colRange( int startcol,
                           int endcol );
AutoIt:
    $oMat.colRange( $startcol, $endcol ) -> retval
```

```cpp
cv::Mat cv::Mat::colRange( cv::Range r );
AutoIt:
    $oMat.colRange( $r ) -> retval
```

### cv::Mat::convertToBitmap

```cpp
void* cv::Mat::convertToBitmap( bool copy = true );
AutoIt:
    $oMat.convertToBitmap( [$copy] ) -> retval
```

### cv::Mat::convertToShow

```cpp
cv::Mat cv::Mat::convertToShow( cv::Mat dst = Mat::zeros(this->__self->get()->rows, this->__self->get()->cols, CV_8UC3),
                                bool    toRGB = false );
AutoIt:
    $oMat.convertToShow( [$dst[, $toRGB]] ) -> retval, $dst
```

### cv::Mat::copy

```cpp
cv::Mat cv::Mat::copy();
AutoIt:
    $oMat.copy() -> retval
```

### cv::Mat::depth

```cpp
int cv::Mat::depth();
AutoIt:
    $oMat.depth() -> retval
```

### cv::Mat::diag

```cpp
cv::Mat cv::Mat::diag( int d = 0 );
AutoIt:
    $oMat.diag( [$d] ) -> retval
```

### cv::Mat::elemSize

```cpp
size_t cv::Mat::elemSize();
AutoIt:
    $oMat.elemSize() -> retval
```

### cv::Mat::elemSize1

```cpp
size_t cv::Mat::elemSize1();
AutoIt:
    $oMat.elemSize1() -> retval
```

### cv::Mat::empty

```cpp
bool cv::Mat::empty();
AutoIt:
    $oMat.empty() -> retval
```

### cv::Mat::eye

```cpp
static cv::Mat cv::Mat::eye( int rows,
                             int cols,
                             int type );
AutoIt:
    _Mediapipe_ObjCreate("cv.Mat").eye( $rows, $cols, $type ) -> retval
```

### cv::Mat::get_Item

```cpp
double cv::Mat::get_Item( int i0 );
AutoIt:
    $oMat.Item( $i0 ) -> retval
    $oMat( $i0 ) -> retval
```

```cpp
double cv::Mat::get_Item( int row,
                          int col );
AutoIt:
    $oMat.Item( $row, $col ) -> retval
    $oMat( $row, $col ) -> retval
```

```cpp
double cv::Mat::get_Item( int i0,
                          int i1,
                          int i2 );
AutoIt:
    $oMat.Item( $i0, $i1, $i2 ) -> retval
    $oMat( $i0, $i1, $i2 ) -> retval
```

```cpp
double cv::Mat::get_Item( std::tuple<int, int> pt );
AutoIt:
    $oMat.Item( $pt ) -> retval
    $oMat( $pt ) -> retval
```

### cv::Mat::isContinuous

```cpp
bool cv::Mat::isContinuous();
AutoIt:
    $oMat.isContinuous() -> retval
```

### cv::Mat::isSubmatrix

```cpp
bool cv::Mat::isSubmatrix();
AutoIt:
    $oMat.isSubmatrix() -> retval
```

### cv::Mat::ones

```cpp
static cv::Mat cv::Mat::ones( int rows,
                              int cols,
                              int type );
AutoIt:
    _Mediapipe_ObjCreate("cv.Mat").ones( $rows, $cols, $type ) -> retval
```

```cpp
static cv::Mat cv::Mat::ones( std::tuple<int, int> size,
                              int                  type );
AutoIt:
    _Mediapipe_ObjCreate("cv.Mat").ones( $size, $type ) -> retval
```

### cv::Mat::pop_back

```cpp
void cv::Mat::pop_back( size_t value );
AutoIt:
    $oMat.pop_back( $value ) -> None
```

### cv::Mat::ptr

```cpp
uchar* cv::Mat::ptr( int y = 0 );
AutoIt:
    $oMat.ptr( [$y] ) -> retval
```

```cpp
uchar* cv::Mat::ptr( int i0,
                     int i1 );
AutoIt:
    $oMat.ptr( $i0, $i1 ) -> retval
```

```cpp
uchar* cv::Mat::ptr( int i0,
                     int i1,
                     int i2 );
AutoIt:
    $oMat.ptr( $i0, $i1, $i2 ) -> retval
```

### cv::Mat::push_back

```cpp
void cv::Mat::push_back( cv::Mat value );
AutoIt:
    $oMat.push_back( $value ) -> None
```

### cv::Mat::put_Item

```cpp
void cv::Mat::put_Item( int    i0,
                        double value );
AutoIt:
    $oMat.Item( $i0 ) = $value
```

```cpp
void cv::Mat::put_Item( int    row,
                        int    col,
                        double value );
AutoIt:
    $oMat.Item( $row, $col ) = $value
```

```cpp
void cv::Mat::put_Item( int    i0,
                        int    i1,
                        int    i2,
                        double value );
AutoIt:
    $oMat.Item( $i0, $i1, $i2 ) = $value
```

```cpp
void cv::Mat::put_Item( std::tuple<int, int> pt,
                        double               value );
AutoIt:
    $oMat.Item( $pt ) = $value
```

### cv::Mat::reshape

```cpp
cv::Mat cv::Mat::reshape( int cn,
                          int rows = 0 );
AutoIt:
    $oMat.reshape( $cn[, $rows] ) -> retval
```

### cv::Mat::row

```cpp
cv::Mat cv::Mat::row( int y );
AutoIt:
    $oMat.row( $y ) -> retval
```

### cv::Mat::rowRange

```cpp
cv::Mat cv::Mat::rowRange( int startrow,
                           int endrow );
AutoIt:
    $oMat.rowRange( $startrow, $endrow ) -> retval
```

```cpp
cv::Mat cv::Mat::rowRange( cv::Range r );
AutoIt:
    $oMat.rowRange( $r ) -> retval
```

### cv::Mat::set_at

```cpp
void cv::Mat::set_at( int    i0,
                      double value );
AutoIt:
    $oMat.set_at( $i0, $value ) -> None
```

```cpp
void cv::Mat::set_at( int    row,
                      int    col,
                      double value );
AutoIt:
    $oMat.set_at( $row, $col, $value ) -> None
```

```cpp
void cv::Mat::set_at( int    i0,
                      int    i1,
                      int    i2,
                      double value );
AutoIt:
    $oMat.set_at( $i0, $i1, $i2, $value ) -> None
```

```cpp
void cv::Mat::set_at( std::tuple<int, int> pt,
                      double               value );
AutoIt:
    $oMat.set_at( $pt, $value ) -> None
```

### cv::Mat::size

```cpp
std::tuple<int, int> cv::Mat::size();
AutoIt:
    $oMat.size() -> retval
```

### cv::Mat::step1

```cpp
size_t cv::Mat::step1( int i = 0 );
AutoIt:
    $oMat.step1( [$i] ) -> retval
```

### cv::Mat::t

```cpp
cv::Mat cv::Mat::t();
AutoIt:
    $oMat.t() -> retval
```

### cv::Mat::total

```cpp
size_t cv::Mat::total();
AutoIt:
    $oMat.total() -> retval
```

```cpp
size_t cv::Mat::total( int startDim,
                       int endDim = INT_MAX );
AutoIt:
    $oMat.total( $startDim[, $endDim] ) -> retval
```

### cv::Mat::type

```cpp
int cv::Mat::type();
AutoIt:
    $oMat.type() -> retval
```

### cv::Mat::zeros

```cpp
static cv::Mat cv::Mat::zeros( int rows,
                               int cols,
                               int type );
AutoIt:
    _Mediapipe_ObjCreate("cv.Mat").zeros( $rows, $cols, $type ) -> retval
```

```cpp
static cv::Mat cv::Mat::zeros( std::tuple<int, int> size,
                               int                  type );
AutoIt:
    _Mediapipe_ObjCreate("cv.Mat").zeros( $size, $type ) -> retval
```

## mediapipe::Packet

### mediapipe::Packet::get_create

```cpp
static mediapipe::Packet mediapipe::Packet::get_create();
AutoIt:
    _Mediapipe_ObjCreate("mediapipe.Packet").create() -> <mediapipe.Packet object>
    _Mediapipe_ObjCreate("mediapipe.Packet")() -> <mediapipe.Packet object>
```

```cpp
static mediapipe::Packet mediapipe::Packet::get_create( const mediapipe::Packet& Packet );
AutoIt:
    _Mediapipe_ObjCreate("mediapipe.Packet").create( $Packet ) -> <mediapipe.Packet object>
    _Mediapipe_ObjCreate("mediapipe.Packet")( $Packet ) -> <mediapipe.Packet object>
```

### mediapipe::Packet::at

```cpp
mediapipe::Packet mediapipe::Packet::at( int64 ts_value );
AutoIt:
    $oPacket.at( $ts_value ) -> retval
```

```cpp
mediapipe::Packet mediapipe::Packet::at( mediapipe::Timestamp ts );
AutoIt:
    $oPacket.at( $ts ) -> retval
```

### mediapipe::Packet::get_timestamp

```cpp
mediapipe::Timestamp mediapipe::Packet::get_timestamp();
AutoIt:
    $oPacket.timestamp() -> retval
```

### mediapipe::Packet::is_empty

```cpp
bool mediapipe::Packet::is_empty();
AutoIt:
    $oPacket.is_empty() -> retval
```

### mediapipe::Packet::put_timestamp

```cpp
void mediapipe::Packet::put_timestamp( int64 ts_value );
AutoIt:
    $oPacket.timestamp( $ts_value ) -> None
```

### mediapipe::Packet::str

```cpp
std::string mediapipe::Packet::str();
AutoIt:
    $oPacket.str() -> retval
```

## mediapipe::autoit::packet_creator

### mediapipe::autoit::packet_creator::create_bool

```cpp
std::shared_ptr<mediapipe::Packet> mediapipe::autoit::packet_creator::create_bool( bool data );
AutoIt:
    _Mediapipe_ObjCreate("mediapipe.autoit.packet_creator").create_bool( $data ) -> retval
```

### mediapipe::autoit::packet_creator::create_bool_vector

```cpp
std::shared_ptr<mediapipe::Packet> mediapipe::autoit::packet_creator::create_bool_vector( const std::vector<bool>& data );
AutoIt:
    _Mediapipe_ObjCreate("mediapipe.autoit.packet_creator").create_bool_vector( $data ) -> retval
```

### mediapipe::autoit::packet_creator::create_double

```cpp
std::shared_ptr<mediapipe::Packet> mediapipe::autoit::packet_creator::create_double( double data );
AutoIt:
    _Mediapipe_ObjCreate("mediapipe.autoit.packet_creator").create_double( $data ) -> retval
```

### mediapipe::autoit::packet_creator::create_float

```cpp
std::shared_ptr<mediapipe::Packet> mediapipe::autoit::packet_creator::create_float( float data );
AutoIt:
    _Mediapipe_ObjCreate("mediapipe.autoit.packet_creator").create_float( $data ) -> retval
```

### mediapipe::autoit::packet_creator::create_float_array

```cpp
std::shared_ptr<mediapipe::Packet> mediapipe::autoit::packet_creator::create_float_array( const std::vector<float>& data );
AutoIt:
    _Mediapipe_ObjCreate("mediapipe.autoit.packet_creator").create_float_array( $data ) -> retval
```

### mediapipe::autoit::packet_creator::create_float_vector

```cpp
std::shared_ptr<mediapipe::Packet> mediapipe::autoit::packet_creator::create_float_vector( const std::vector<float>& data );
AutoIt:
    _Mediapipe_ObjCreate("mediapipe.autoit.packet_creator").create_float_vector( $data ) -> retval
```

### mediapipe::autoit::packet_creator::create_image

```cpp
std::shared_ptr<mediapipe::Packet> mediapipe::autoit::packet_creator::create_image( mediapipe::Image& data,
                                                                                    bool              copy = true );
AutoIt:
    _Mediapipe_ObjCreate("mediapipe.autoit.packet_creator").create_image( $data[, $copy] ) -> retval
```

```cpp
std::shared_ptr<mediapipe::Packet> mediapipe::autoit::packet_creator::create_image( mediapipe::Image& data,
                                                                                    int               image_format,
                                                                                    bool              copy = true );
AutoIt:
    _Mediapipe_ObjCreate("mediapipe.autoit.packet_creator").create_image( $data, $image_format[, $copy] ) -> retval
```

```cpp
std::shared_ptr<mediapipe::Packet> mediapipe::autoit::packet_creator::create_image( cv::Mat& data,
                                                                                    bool     copy = true );
AutoIt:
    _Mediapipe_ObjCreate("mediapipe.autoit.packet_creator").create_image( $data[, $copy] ) -> retval
```

```cpp
std::shared_ptr<mediapipe::Packet> mediapipe::autoit::packet_creator::create_image( cv::Mat& data,
                                                                                    int      image_format,
                                                                                    bool     copy = true );
AutoIt:
    _Mediapipe_ObjCreate("mediapipe.autoit.packet_creator").create_image( $data, $image_format[, $copy] ) -> retval
```

### mediapipe::autoit::packet_creator::create_image_frame

```cpp
std::shared_ptr<mediapipe::Packet> mediapipe::autoit::packet_creator::create_image_frame( mediapipe::ImageFrame& data,
                                                                                          bool                   copy = true );
AutoIt:
    _Mediapipe_ObjCreate("mediapipe.autoit.packet_creator").create_image_frame( $data[, $copy] ) -> retval
```

```cpp
std::shared_ptr<mediapipe::Packet> mediapipe::autoit::packet_creator::create_image_frame( mediapipe::ImageFrame& data,
                                                                                          int                    image_format,
                                                                                          bool                   copy = true );
AutoIt:
    _Mediapipe_ObjCreate("mediapipe.autoit.packet_creator").create_image_frame( $data, $image_format[, $copy] ) -> retval
```

```cpp
std::shared_ptr<mediapipe::Packet> mediapipe::autoit::packet_creator::create_image_frame( cv::Mat& data,
                                                                                          bool     copy = true );
AutoIt:
    _Mediapipe_ObjCreate("mediapipe.autoit.packet_creator").create_image_frame( $data[, $copy] ) -> retval
```

```cpp
std::shared_ptr<mediapipe::Packet> mediapipe::autoit::packet_creator::create_image_frame( cv::Mat& data,
                                                                                          int      image_format,
                                                                                          bool     copy = true );
AutoIt:
    _Mediapipe_ObjCreate("mediapipe.autoit.packet_creator").create_image_frame( $data, $image_format[, $copy] ) -> retval
```

### mediapipe::autoit::packet_creator::create_image_vector

```cpp
std::shared_ptr<mediapipe::Packet> mediapipe::autoit::packet_creator::create_image_vector( const std::vector<mediapipe::Image>& data );
AutoIt:
    _Mediapipe_ObjCreate("mediapipe.autoit.packet_creator").create_image_vector( $data ) -> retval
```

### mediapipe::autoit::packet_creator::create_int

```cpp
std::shared_ptr<mediapipe::Packet> mediapipe::autoit::packet_creator::create_int( int64 data );
AutoIt:
    _Mediapipe_ObjCreate("mediapipe.autoit.packet_creator").create_int( $data ) -> retval
```

### mediapipe::autoit::packet_creator::create_int16

```cpp
std::shared_ptr<mediapipe::Packet> mediapipe::autoit::packet_creator::create_int16( int64 data );
AutoIt:
    _Mediapipe_ObjCreate("mediapipe.autoit.packet_creator").create_int16( $data ) -> retval
```

### mediapipe::autoit::packet_creator::create_int32

```cpp
std::shared_ptr<mediapipe::Packet> mediapipe::autoit::packet_creator::create_int32( int64 data );
AutoIt:
    _Mediapipe_ObjCreate("mediapipe.autoit.packet_creator").create_int32( $data ) -> retval
```

### mediapipe::autoit::packet_creator::create_int64

```cpp
std::shared_ptr<mediapipe::Packet> mediapipe::autoit::packet_creator::create_int64( int64 data );
AutoIt:
    _Mediapipe_ObjCreate("mediapipe.autoit.packet_creator").create_int64( $data ) -> retval
```

### mediapipe::autoit::packet_creator::create_int8

```cpp
std::shared_ptr<mediapipe::Packet> mediapipe::autoit::packet_creator::create_int8( int64 data );
AutoIt:
    _Mediapipe_ObjCreate("mediapipe.autoit.packet_creator").create_int8( $data ) -> retval
```

### mediapipe::autoit::packet_creator::create_int_array

```cpp
std::shared_ptr<mediapipe::Packet> mediapipe::autoit::packet_creator::create_int_array( const std::vector<int>& data );
AutoIt:
    _Mediapipe_ObjCreate("mediapipe.autoit.packet_creator").create_int_array( $data ) -> retval
```

### mediapipe::autoit::packet_creator::create_int_vector

```cpp
std::shared_ptr<mediapipe::Packet> mediapipe::autoit::packet_creator::create_int_vector( const std::vector<int>& data );
AutoIt:
    _Mediapipe_ObjCreate("mediapipe.autoit.packet_creator").create_int_vector( $data ) -> retval
```

### mediapipe::autoit::packet_creator::create_packet_vector

```cpp
std::shared_ptr<mediapipe::Packet> mediapipe::autoit::packet_creator::create_packet_vector( const std::vector<mediapipe::Packet>& data );
AutoIt:
    _Mediapipe_ObjCreate("mediapipe.autoit.packet_creator").create_packet_vector( $data ) -> retval
```

### mediapipe::autoit::packet_creator::create_proto

```cpp
std::shared_ptr<mediapipe::Packet> mediapipe::autoit::packet_creator::create_proto( google::protobuf::Message& proto_message );
AutoIt:
    _Mediapipe_ObjCreate("mediapipe.autoit.packet_creator").create_proto( $proto_message ) -> retval
```

### mediapipe::autoit::packet_creator::create_string

```cpp
std::shared_ptr<mediapipe::Packet> mediapipe::autoit::packet_creator::create_string( std::string& data );
AutoIt:
    _Mediapipe_ObjCreate("mediapipe.autoit.packet_creator").create_string( $data ) -> retval
```

### mediapipe::autoit::packet_creator::create_string_to_packet_map

```cpp
std::shared_ptr<mediapipe::Packet> mediapipe::autoit::packet_creator::create_string_to_packet_map( const std::map<std::string, mediapipe::Packet>& data );
AutoIt:
    _Mediapipe_ObjCreate("mediapipe.autoit.packet_creator").create_string_to_packet_map( $data ) -> retval
```

### mediapipe::autoit::packet_creator::create_string_vector

```cpp
std::shared_ptr<mediapipe::Packet> mediapipe::autoit::packet_creator::create_string_vector( const std::vector<std::string>& data );
AutoIt:
    _Mediapipe_ObjCreate("mediapipe.autoit.packet_creator").create_string_vector( $data ) -> retval
```

### mediapipe::autoit::packet_creator::create_uint16

```cpp
std::shared_ptr<mediapipe::Packet> mediapipe::autoit::packet_creator::create_uint16( int64 data );
AutoIt:
    _Mediapipe_ObjCreate("mediapipe.autoit.packet_creator").create_uint16( $data ) -> retval
```

### mediapipe::autoit::packet_creator::create_uint32

```cpp
std::shared_ptr<mediapipe::Packet> mediapipe::autoit::packet_creator::create_uint32( int64 data );
AutoIt:
    _Mediapipe_ObjCreate("mediapipe.autoit.packet_creator").create_uint32( $data ) -> retval
```

### mediapipe::autoit::packet_creator::create_uint64

```cpp
std::shared_ptr<mediapipe::Packet> mediapipe::autoit::packet_creator::create_uint64( uint64 data );
AutoIt:
    _Mediapipe_ObjCreate("mediapipe.autoit.packet_creator").create_uint64( $data ) -> retval
```

### mediapipe::autoit::packet_creator::create_uint8

```cpp
std::shared_ptr<mediapipe::Packet> mediapipe::autoit::packet_creator::create_uint8( int64 data );
AutoIt:
    _Mediapipe_ObjCreate("mediapipe.autoit.packet_creator").create_uint8( $data ) -> retval
```

## mediapipe::autoit::packet_getter

### mediapipe::autoit::packet_getter::get_bool

```cpp
bool mediapipe::autoit::packet_getter::get_bool( mediapipe::Packet& packet );
AutoIt:
    _Mediapipe_ObjCreate("mediapipe.autoit.packet_getter").get_bool( $packet ) -> retval
```

### mediapipe::autoit::packet_getter::get_bool_list

```cpp
std::vector<bool> mediapipe::autoit::packet_getter::get_bool_list( mediapipe::Packet& packet );
AutoIt:
    _Mediapipe_ObjCreate("mediapipe.autoit.packet_getter").get_bool_list( $packet ) -> retval
```

### mediapipe::autoit::packet_getter::get_float

```cpp
float mediapipe::autoit::packet_getter::get_float( mediapipe::Packet& packet );
AutoIt:
    _Mediapipe_ObjCreate("mediapipe.autoit.packet_getter").get_float( $packet ) -> retval
```

### mediapipe::autoit::packet_getter::get_float_list

```cpp
std::vector<float> mediapipe::autoit::packet_getter::get_float_list( mediapipe::Packet& packet );
AutoIt:
    _Mediapipe_ObjCreate("mediapipe.autoit.packet_getter").get_float_list( $packet ) -> retval
```

### mediapipe::autoit::packet_getter::get_image

```cpp
mediapipe::Image mediapipe::autoit::packet_getter::get_image( mediapipe::Packet& packet );
AutoIt:
    _Mediapipe_ObjCreate("mediapipe.autoit.packet_getter").get_image( $packet ) -> retval
```

### mediapipe::autoit::packet_getter::get_image_frame

```cpp
mediapipe::ImageFrame mediapipe::autoit::packet_getter::get_image_frame( mediapipe::Packet& packet );
AutoIt:
    _Mediapipe_ObjCreate("mediapipe.autoit.packet_getter").get_image_frame( $packet ) -> retval
```

### mediapipe::autoit::packet_getter::get_image_list

```cpp
std::vector<mediapipe::Image> mediapipe::autoit::packet_getter::get_image_list( mediapipe::Packet& packet );
AutoIt:
    _Mediapipe_ObjCreate("mediapipe.autoit.packet_getter").get_image_list( $packet ) -> retval
```

### mediapipe::autoit::packet_getter::get_int

```cpp
int64 mediapipe::autoit::packet_getter::get_int( mediapipe::Packet& packet );
AutoIt:
    _Mediapipe_ObjCreate("mediapipe.autoit.packet_getter").get_int( $packet ) -> retval
```

### mediapipe::autoit::packet_getter::get_int_list

```cpp
std::vector<int64> mediapipe::autoit::packet_getter::get_int_list( mediapipe::Packet& packet );
AutoIt:
    _Mediapipe_ObjCreate("mediapipe.autoit.packet_getter").get_int_list( $packet ) -> retval
```

### mediapipe::autoit::packet_getter::get_packet_list

```cpp
std::vector<mediapipe::Packet> mediapipe::autoit::packet_getter::get_packet_list( mediapipe::Packet& packet );
AutoIt:
    _Mediapipe_ObjCreate("mediapipe.autoit.packet_getter").get_packet_list( $packet ) -> retval
```

### mediapipe::autoit::packet_getter::get_str

```cpp
std::string mediapipe::autoit::packet_getter::get_str( mediapipe::Packet& packet );
AutoIt:
    _Mediapipe_ObjCreate("mediapipe.autoit.packet_getter").get_str( $packet ) -> retval
```

### mediapipe::autoit::packet_getter::get_str_list

```cpp
std::vector<std::string> mediapipe::autoit::packet_getter::get_str_list( mediapipe::Packet& packet );
AutoIt:
    _Mediapipe_ObjCreate("mediapipe.autoit.packet_getter").get_str_list( $packet ) -> retval
```

### mediapipe::autoit::packet_getter::get_str_to_packet_dict

```cpp
std::map<std::string, mediapipe::Packet> mediapipe::autoit::packet_getter::get_str_to_packet_dict( mediapipe::Packet& packet );
AutoIt:
    _Mediapipe_ObjCreate("mediapipe.autoit.packet_getter").get_str_to_packet_dict( $packet ) -> retval
```

### mediapipe::autoit::packet_getter::get_uint

```cpp
uint64 mediapipe::autoit::packet_getter::get_uint( mediapipe::Packet& packet );
AutoIt:
    _Mediapipe_ObjCreate("mediapipe.autoit.packet_getter").get_uint( $packet ) -> retval
```

## mediapipe::Detection

### mediapipe::Detection::get_create

```cpp
static mediapipe::Detection mediapipe::Detection::get_create();
AutoIt:
    _Mediapipe_ObjCreate("mediapipe.Detection").create() -> <mediapipe.Detection object>
    _Mediapipe_ObjCreate("mediapipe.Detection")() -> <mediapipe.Detection object>
```

## google::protobuf::TextFormat

### google::protobuf::TextFormat::Parse

```cpp
bool google::protobuf::TextFormat::Parse( const std::string&                         input,
                                          std::shared_ptr<google::protobuf::Message> output );
AutoIt:
    _Mediapipe_ObjCreate("google.protobuf.text_format").Parse( $input, $output ) -> retval
```

## cv::Range

### cv::Range::get_create

```cpp
static cv::Range cv::Range::get_create();
AutoIt:
    _Mediapipe_ObjCreate("cv.Range").create() -> <cv.Range object>
    _Mediapipe_ObjCreate("cv.Range")() -> <cv.Range object>
```

```cpp
static cv::Range cv::Range::get_create( int start,
                                        int end );
AutoIt:
    _Mediapipe_ObjCreate("cv.Range").create( $start, $end ) -> <cv.Range object>
    _Mediapipe_ObjCreate("cv.Range")( $start, $end ) -> <cv.Range object>
```

### cv::Range::all

```cpp
static cv::Range cv::Range::all();
AutoIt:
    _Mediapipe_ObjCreate("cv.Range").all() -> retval
```

### cv::Range::empty

```cpp
bool cv::Range::empty();
AutoIt:
    $oRange.empty() -> retval
```

### cv::Range::size

```cpp
int cv::Range::size();
AutoIt:
    $oRange.size() -> retval
```

## mediapipe::Timestamp

### mediapipe::Timestamp::get_create

```cpp
static mediapipe::Timestamp mediapipe::Timestamp::get_create( const mediapipe::Timestamp& timestamp );
AutoIt:
    _Mediapipe_ObjCreate("mediapipe.Timestamp").create( $timestamp ) -> <mediapipe.Timestamp object>
    _Mediapipe_ObjCreate("mediapipe.Timestamp")( $timestamp ) -> <mediapipe.Timestamp object>
```

```cpp
static mediapipe::Timestamp mediapipe::Timestamp::get_create( int64 timestamp );
AutoIt:
    _Mediapipe_ObjCreate("mediapipe.Timestamp").create( $timestamp ) -> <mediapipe.Timestamp object>
    _Mediapipe_ObjCreate("mediapipe.Timestamp")( $timestamp ) -> <mediapipe.Timestamp object>
```

### mediapipe::Timestamp::eq

```cpp
static bool mediapipe::Timestamp::eq( const mediapipe::Timestamp& a,
                                      const mediapipe::Timestamp& b );
AutoIt:
    _Mediapipe_ObjCreate("mediapipe.Timestamp").eq( $a, $b ) -> retval
```

```cpp
bool mediapipe::Timestamp::eq( const mediapipe::Timestamp& other );
AutoIt:
    $oTimestamp.eq( $other ) -> retval
```

### mediapipe::Timestamp::from_seconds

```cpp
static mediapipe::Timestamp mediapipe::Timestamp::from_seconds( double seconds );
AutoIt:
    _Mediapipe_ObjCreate("mediapipe.Timestamp").from_seconds( $seconds ) -> retval
```

### mediapipe::Timestamp::ge

```cpp
static bool mediapipe::Timestamp::ge( const mediapipe::Timestamp& a,
                                      const mediapipe::Timestamp& b );
AutoIt:
    _Mediapipe_ObjCreate("mediapipe.Timestamp").ge( $a, $b ) -> retval
```

```cpp
bool mediapipe::Timestamp::ge( const mediapipe::Timestamp& other );
AutoIt:
    $oTimestamp.ge( $other ) -> retval
```

### mediapipe::Timestamp::gt

```cpp
static bool mediapipe::Timestamp::gt( const mediapipe::Timestamp& a,
                                      const mediapipe::Timestamp& b );
AutoIt:
    _Mediapipe_ObjCreate("mediapipe.Timestamp").gt( $a, $b ) -> retval
```

```cpp
bool mediapipe::Timestamp::gt( const mediapipe::Timestamp& other );
AutoIt:
    $oTimestamp.gt( $other ) -> retval
```

### mediapipe::Timestamp::is_allowed_in_stream

```cpp
bool mediapipe::Timestamp::is_allowed_in_stream();
AutoIt:
    $oTimestamp.is_allowed_in_stream() -> retval
```

### mediapipe::Timestamp::is_range_value

```cpp
bool mediapipe::Timestamp::is_range_value();
AutoIt:
    $oTimestamp.is_range_value() -> retval
```

### mediapipe::Timestamp::is_special_value

```cpp
bool mediapipe::Timestamp::is_special_value();
AutoIt:
    $oTimestamp.is_special_value() -> retval
```

### mediapipe::Timestamp::le

```cpp
static bool mediapipe::Timestamp::le( const mediapipe::Timestamp& a,
                                      const mediapipe::Timestamp& b );
AutoIt:
    _Mediapipe_ObjCreate("mediapipe.Timestamp").le( $a, $b ) -> retval
```

```cpp
bool mediapipe::Timestamp::le( const mediapipe::Timestamp& other );
AutoIt:
    $oTimestamp.le( $other ) -> retval
```

### mediapipe::Timestamp::lt

```cpp
static bool mediapipe::Timestamp::lt( const mediapipe::Timestamp& a,
                                      const mediapipe::Timestamp& b );
AutoIt:
    _Mediapipe_ObjCreate("mediapipe.Timestamp").lt( $a, $b ) -> retval
```

```cpp
bool mediapipe::Timestamp::lt( const mediapipe::Timestamp& other );
AutoIt:
    $oTimestamp.lt( $other ) -> retval
```

### mediapipe::Timestamp::microseconds

```cpp
int64 mediapipe::Timestamp::microseconds();
AutoIt:
    $oTimestamp.microseconds() -> retval
```

### mediapipe::Timestamp::ne

```cpp
static bool mediapipe::Timestamp::ne( const mediapipe::Timestamp& a,
                                      const mediapipe::Timestamp& b );
AutoIt:
    _Mediapipe_ObjCreate("mediapipe.Timestamp").ne( $a, $b ) -> retval
```

```cpp
bool mediapipe::Timestamp::ne( const mediapipe::Timestamp& other );
AutoIt:
    $oTimestamp.ne( $other ) -> retval
```

### mediapipe::Timestamp::seconds

```cpp
double mediapipe::Timestamp::seconds();
AutoIt:
    $oTimestamp.seconds() -> retval
```

### mediapipe::Timestamp::str

```cpp
std::string mediapipe::Timestamp::str();
AutoIt:
    $oTimestamp.str() -> retval
```

## mediapipe::ValidatedGraphConfig

### mediapipe::ValidatedGraphConfig::get_create

```cpp
static mediapipe::ValidatedGraphConfig mediapipe::ValidatedGraphConfig::get_create();
AutoIt:
    _Mediapipe_ObjCreate("mediapipe.ValidatedGraphConfig").create() -> <mediapipe.ValidatedGraphConfig object>
    _Mediapipe_ObjCreate("mediapipe.ValidatedGraphConfig")() -> <mediapipe.ValidatedGraphConfig object>
```

### mediapipe::ValidatedGraphConfig::initialize

```cpp
void mediapipe::ValidatedGraphConfig::initialize( std::string binary_graph_path );
AutoIt:
    $oValidatedGraphConfig.initialize( $binary_graph_path ) -> None
```

```cpp
void mediapipe::ValidatedGraphConfig::initialize( mediapipe::CalculatorGraphConfig& graph_config );
AutoIt:
    $oValidatedGraphConfig.initialize( $graph_config ) -> None
```

### mediapipe::ValidatedGraphConfig::initialized

```cpp
bool mediapipe::ValidatedGraphConfig::initialized();
AutoIt:
    $oValidatedGraphConfig.initialized() -> retval
```

### mediapipe::ValidatedGraphConfig::registered_side_packet_type_name

```cpp
std::string mediapipe::ValidatedGraphConfig::registered_side_packet_type_name( std::string side_packet_name );
AutoIt:
    $oValidatedGraphConfig.registered_side_packet_type_name( $side_packet_name ) -> retval
```

### mediapipe::ValidatedGraphConfig::registered_stream_type_name

```cpp
std::string mediapipe::ValidatedGraphConfig::registered_stream_type_name( std::string stream_name );
AutoIt:
    $oValidatedGraphConfig.registered_stream_type_name( $stream_name ) -> retval
```

## VectorOfVariant

### VectorOfVariant::create

```cpp
static VectorOfVariant VectorOfVariant::create();
AutoIt:
    _Mediapipe_ObjCreate("VectorOfVariant").create() -> <VectorOfVariant object>
```

```cpp
static VectorOfVariant VectorOfVariant::create( size_t size );
AutoIt:
    _Mediapipe_ObjCreate("VectorOfVariant").create( $size ) -> <VectorOfVariant object>
```

```cpp
static VectorOfVariant VectorOfVariant::create( VectorOfVariant other );
AutoIt:
    _Mediapipe_ObjCreate("VectorOfVariant").create( $other ) -> <VectorOfVariant object>
```

### VectorOfVariant::Add

```cpp
void VectorOfVariant::Add( _variant_t value );
AutoIt:
    $oVectorOfVariant.Add( $value ) -> None
```

### VectorOfVariant::Items

```cpp
VectorOfVariant VectorOfVariant::Items();
AutoIt:
    $oVectorOfVariant.Items() -> retval
```

### VectorOfVariant::Keys

```cpp
std::vector<int> VectorOfVariant::Keys();
AutoIt:
    $oVectorOfVariant.Keys() -> retval
```

### VectorOfVariant::Remove

```cpp
void VectorOfVariant::Remove( size_t index );
AutoIt:
    $oVectorOfVariant.Remove( $index ) -> None
```

### VectorOfVariant::at

```cpp
_variant_t VectorOfVariant::at( size_t index );
AutoIt:
    $oVectorOfVariant.at( $index ) -> retval
```

```cpp
void VectorOfVariant::at( size_t     index,
                          _variant_t value );
AutoIt:
    $oVectorOfVariant.at( $index, $value ) -> None
```

### VectorOfVariant::clear

```cpp
void VectorOfVariant::clear();
AutoIt:
    $oVectorOfVariant.clear() -> None
```

### VectorOfVariant::empty

```cpp
bool VectorOfVariant::empty();
AutoIt:
    $oVectorOfVariant.empty() -> retval
```

### VectorOfVariant::end

```cpp
void* VectorOfVariant::end();
AutoIt:
    $oVectorOfVariant.end() -> retval
```

### VectorOfVariant::get_Item

```cpp
_variant_t VectorOfVariant::get_Item( size_t vIndex );
AutoIt:
    $oVectorOfVariant.Item( $vIndex ) -> retval
    $oVectorOfVariant( $vIndex ) -> retval
```

### VectorOfVariant::push_back

```cpp
void VectorOfVariant::push_back( _variant_t value );
AutoIt:
    $oVectorOfVariant.push_back( $value ) -> None
```

### VectorOfVariant::push_vector

```cpp
void VectorOfVariant::push_vector( VectorOfVariant other );
AutoIt:
    $oVectorOfVariant.push_vector( $other ) -> None
```

```cpp
void VectorOfVariant::push_vector( VectorOfVariant other,
                                   size_t          count,
                                   size_t          start = 0 );
AutoIt:
    $oVectorOfVariant.push_vector( $other, $count[, $start] ) -> None
```

### VectorOfVariant::put_Item

```cpp
void VectorOfVariant::put_Item( size_t     vIndex,
                                _variant_t vItem );
AutoIt:
    $oVectorOfVariant.Item( $vIndex ) = $vItem
```

### VectorOfVariant::size

```cpp
size_t VectorOfVariant::size();
AutoIt:
    $oVectorOfVariant.size() -> retval
```

### VectorOfVariant::slice

```cpp
VectorOfVariant VectorOfVariant::slice( size_t start = 0,
                                        size_t count = this->__self->get()->size() );
AutoIt:
    $oVectorOfVariant.slice( [$start[, $count]] ) -> retval
```

### VectorOfVariant::sort

```cpp
void VectorOfVariant::sort( void*  comparator,
                            size_t start = 0,
                            size_t count = this->__self->get()->size() );
AutoIt:
    $oVectorOfVariant.sort( $comparator[, $start[, $count]] ) -> None
```

### VectorOfVariant::sort_variant

```cpp
void VectorOfVariant::sort_variant( void*  comparator,
                                    size_t start = 0,
                                    size_t count = this->__self->get()->size() );
AutoIt:
    $oVectorOfVariant.sort_variant( $comparator[, $start[, $count]] ) -> None
```

### VectorOfVariant::start

```cpp
void* VectorOfVariant::start();
AutoIt:
    $oVectorOfVariant.start() -> retval
```

## VectorOfInt

### VectorOfInt::create

```cpp
static VectorOfInt VectorOfInt::create();
AutoIt:
    _Mediapipe_ObjCreate("VectorOfInt").create() -> <VectorOfInt object>
```

```cpp
static VectorOfInt VectorOfInt::create( size_t size );
AutoIt:
    _Mediapipe_ObjCreate("VectorOfInt").create( $size ) -> <VectorOfInt object>
```

```cpp
static VectorOfInt VectorOfInt::create( VectorOfInt other );
AutoIt:
    _Mediapipe_ObjCreate("VectorOfInt").create( $other ) -> <VectorOfInt object>
```

### VectorOfInt::Add

```cpp
void VectorOfInt::Add( int value );
AutoIt:
    $oVectorOfInt.Add( $value ) -> None
```

### VectorOfInt::Items

```cpp
VectorOfInt VectorOfInt::Items();
AutoIt:
    $oVectorOfInt.Items() -> retval
```

### VectorOfInt::Keys

```cpp
std::vector<int> VectorOfInt::Keys();
AutoIt:
    $oVectorOfInt.Keys() -> retval
```

### VectorOfInt::Remove

```cpp
void VectorOfInt::Remove( size_t index );
AutoIt:
    $oVectorOfInt.Remove( $index ) -> None
```

### VectorOfInt::at

```cpp
int VectorOfInt::at( size_t index );
AutoIt:
    $oVectorOfInt.at( $index ) -> retval
```

```cpp
void VectorOfInt::at( size_t index,
                      int    value );
AutoIt:
    $oVectorOfInt.at( $index, $value ) -> None
```

### VectorOfInt::clear

```cpp
void VectorOfInt::clear();
AutoIt:
    $oVectorOfInt.clear() -> None
```

### VectorOfInt::empty

```cpp
bool VectorOfInt::empty();
AutoIt:
    $oVectorOfInt.empty() -> retval
```

### VectorOfInt::end

```cpp
void* VectorOfInt::end();
AutoIt:
    $oVectorOfInt.end() -> retval
```

### VectorOfInt::get_Item

```cpp
int VectorOfInt::get_Item( size_t vIndex );
AutoIt:
    $oVectorOfInt.Item( $vIndex ) -> retval
    $oVectorOfInt( $vIndex ) -> retval
```

### VectorOfInt::push_back

```cpp
void VectorOfInt::push_back( int value );
AutoIt:
    $oVectorOfInt.push_back( $value ) -> None
```

### VectorOfInt::push_vector

```cpp
void VectorOfInt::push_vector( VectorOfInt other );
AutoIt:
    $oVectorOfInt.push_vector( $other ) -> None
```

```cpp
void VectorOfInt::push_vector( VectorOfInt other,
                               size_t      count,
                               size_t      start = 0 );
AutoIt:
    $oVectorOfInt.push_vector( $other, $count[, $start] ) -> None
```

### VectorOfInt::put_Item

```cpp
void VectorOfInt::put_Item( size_t vIndex,
                            int    vItem );
AutoIt:
    $oVectorOfInt.Item( $vIndex ) = $vItem
```

### VectorOfInt::size

```cpp
size_t VectorOfInt::size();
AutoIt:
    $oVectorOfInt.size() -> retval
```

### VectorOfInt::slice

```cpp
VectorOfInt VectorOfInt::slice( size_t start = 0,
                                size_t count = this->__self->get()->size() );
AutoIt:
    $oVectorOfInt.slice( [$start[, $count]] ) -> retval
```

### VectorOfInt::sort

```cpp
void VectorOfInt::sort( void*  comparator,
                        size_t start = 0,
                        size_t count = this->__self->get()->size() );
AutoIt:
    $oVectorOfInt.sort( $comparator[, $start[, $count]] ) -> None
```

### VectorOfInt::sort_variant

```cpp
void VectorOfInt::sort_variant( void*  comparator,
                                size_t start = 0,
                                size_t count = this->__self->get()->size() );
AutoIt:
    $oVectorOfInt.sort_variant( $comparator[, $start[, $count]] ) -> None
```

### VectorOfInt::start

```cpp
void* VectorOfInt::start();
AutoIt:
    $oVectorOfInt.start() -> retval
```

## VectorOfUchar

### VectorOfUchar::create

```cpp
static VectorOfUchar VectorOfUchar::create();
AutoIt:
    _Mediapipe_ObjCreate("VectorOfUchar").create() -> <VectorOfUchar object>
```

```cpp
static VectorOfUchar VectorOfUchar::create( size_t size );
AutoIt:
    _Mediapipe_ObjCreate("VectorOfUchar").create( $size ) -> <VectorOfUchar object>
```

```cpp
static VectorOfUchar VectorOfUchar::create( VectorOfUchar other );
AutoIt:
    _Mediapipe_ObjCreate("VectorOfUchar").create( $other ) -> <VectorOfUchar object>
```

### VectorOfUchar::Add

```cpp
void VectorOfUchar::Add( uchar value );
AutoIt:
    $oVectorOfUchar.Add( $value ) -> None
```

### VectorOfUchar::Items

```cpp
VectorOfUchar VectorOfUchar::Items();
AutoIt:
    $oVectorOfUchar.Items() -> retval
```

### VectorOfUchar::Keys

```cpp
std::vector<int> VectorOfUchar::Keys();
AutoIt:
    $oVectorOfUchar.Keys() -> retval
```

### VectorOfUchar::Remove

```cpp
void VectorOfUchar::Remove( size_t index );
AutoIt:
    $oVectorOfUchar.Remove( $index ) -> None
```

### VectorOfUchar::at

```cpp
uchar VectorOfUchar::at( size_t index );
AutoIt:
    $oVectorOfUchar.at( $index ) -> retval
```

```cpp
void VectorOfUchar::at( size_t index,
                        uchar  value );
AutoIt:
    $oVectorOfUchar.at( $index, $value ) -> None
```

### VectorOfUchar::clear

```cpp
void VectorOfUchar::clear();
AutoIt:
    $oVectorOfUchar.clear() -> None
```

### VectorOfUchar::empty

```cpp
bool VectorOfUchar::empty();
AutoIt:
    $oVectorOfUchar.empty() -> retval
```

### VectorOfUchar::end

```cpp
void* VectorOfUchar::end();
AutoIt:
    $oVectorOfUchar.end() -> retval
```

### VectorOfUchar::get_Item

```cpp
uchar VectorOfUchar::get_Item( size_t vIndex );
AutoIt:
    $oVectorOfUchar.Item( $vIndex ) -> retval
    $oVectorOfUchar( $vIndex ) -> retval
```

### VectorOfUchar::push_back

```cpp
void VectorOfUchar::push_back( uchar value );
AutoIt:
    $oVectorOfUchar.push_back( $value ) -> None
```

### VectorOfUchar::push_vector

```cpp
void VectorOfUchar::push_vector( VectorOfUchar other );
AutoIt:
    $oVectorOfUchar.push_vector( $other ) -> None
```

```cpp
void VectorOfUchar::push_vector( VectorOfUchar other,
                                 size_t        count,
                                 size_t        start = 0 );
AutoIt:
    $oVectorOfUchar.push_vector( $other, $count[, $start] ) -> None
```

### VectorOfUchar::put_Item

```cpp
void VectorOfUchar::put_Item( size_t vIndex,
                              uchar  vItem );
AutoIt:
    $oVectorOfUchar.Item( $vIndex ) = $vItem
```

### VectorOfUchar::size

```cpp
size_t VectorOfUchar::size();
AutoIt:
    $oVectorOfUchar.size() -> retval
```

### VectorOfUchar::slice

```cpp
VectorOfUchar VectorOfUchar::slice( size_t start = 0,
                                    size_t count = this->__self->get()->size() );
AutoIt:
    $oVectorOfUchar.slice( [$start[, $count]] ) -> retval
```

### VectorOfUchar::sort

```cpp
void VectorOfUchar::sort( void*  comparator,
                          size_t start = 0,
                          size_t count = this->__self->get()->size() );
AutoIt:
    $oVectorOfUchar.sort( $comparator[, $start[, $count]] ) -> None
```

### VectorOfUchar::sort_variant

```cpp
void VectorOfUchar::sort_variant( void*  comparator,
                                  size_t start = 0,
                                  size_t count = this->__self->get()->size() );
AutoIt:
    $oVectorOfUchar.sort_variant( $comparator[, $start[, $count]] ) -> None
```

### VectorOfUchar::start

```cpp
void* VectorOfUchar::start();
AutoIt:
    $oVectorOfUchar.start() -> retval
```

## VectorOfMat

### VectorOfMat::create

```cpp
static VectorOfMat VectorOfMat::create();
AutoIt:
    _Mediapipe_ObjCreate("VectorOfMat").create() -> <VectorOfMat object>
```

```cpp
static VectorOfMat VectorOfMat::create( size_t size );
AutoIt:
    _Mediapipe_ObjCreate("VectorOfMat").create( $size ) -> <VectorOfMat object>
```

```cpp
static VectorOfMat VectorOfMat::create( VectorOfMat other );
AutoIt:
    _Mediapipe_ObjCreate("VectorOfMat").create( $other ) -> <VectorOfMat object>
```

### VectorOfMat::Add

```cpp
void VectorOfMat::Add( cv::Mat value );
AutoIt:
    $oVectorOfMat.Add( $value ) -> None
```

### VectorOfMat::Items

```cpp
VectorOfMat VectorOfMat::Items();
AutoIt:
    $oVectorOfMat.Items() -> retval
```

### VectorOfMat::Keys

```cpp
std::vector<int> VectorOfMat::Keys();
AutoIt:
    $oVectorOfMat.Keys() -> retval
```

### VectorOfMat::Remove

```cpp
void VectorOfMat::Remove( size_t index );
AutoIt:
    $oVectorOfMat.Remove( $index ) -> None
```

### VectorOfMat::at

```cpp
cv::Mat VectorOfMat::at( size_t index );
AutoIt:
    $oVectorOfMat.at( $index ) -> retval
```

```cpp
void VectorOfMat::at( size_t  index,
                      cv::Mat value );
AutoIt:
    $oVectorOfMat.at( $index, $value ) -> None
```

### VectorOfMat::clear

```cpp
void VectorOfMat::clear();
AutoIt:
    $oVectorOfMat.clear() -> None
```

### VectorOfMat::empty

```cpp
bool VectorOfMat::empty();
AutoIt:
    $oVectorOfMat.empty() -> retval
```

### VectorOfMat::end

```cpp
void* VectorOfMat::end();
AutoIt:
    $oVectorOfMat.end() -> retval
```

### VectorOfMat::get_Item

```cpp
cv::Mat VectorOfMat::get_Item( size_t vIndex );
AutoIt:
    $oVectorOfMat.Item( $vIndex ) -> retval
    $oVectorOfMat( $vIndex ) -> retval
```

### VectorOfMat::push_back

```cpp
void VectorOfMat::push_back( cv::Mat value );
AutoIt:
    $oVectorOfMat.push_back( $value ) -> None
```

### VectorOfMat::push_vector

```cpp
void VectorOfMat::push_vector( VectorOfMat other );
AutoIt:
    $oVectorOfMat.push_vector( $other ) -> None
```

```cpp
void VectorOfMat::push_vector( VectorOfMat other,
                               size_t      count,
                               size_t      start = 0 );
AutoIt:
    $oVectorOfMat.push_vector( $other, $count[, $start] ) -> None
```

### VectorOfMat::put_Item

```cpp
void VectorOfMat::put_Item( size_t  vIndex,
                            cv::Mat vItem );
AutoIt:
    $oVectorOfMat.Item( $vIndex ) = $vItem
```

### VectorOfMat::size

```cpp
size_t VectorOfMat::size();
AutoIt:
    $oVectorOfMat.size() -> retval
```

### VectorOfMat::slice

```cpp
VectorOfMat VectorOfMat::slice( size_t start = 0,
                                size_t count = this->__self->get()->size() );
AutoIt:
    $oVectorOfMat.slice( [$start[, $count]] ) -> retval
```

### VectorOfMat::sort

```cpp
void VectorOfMat::sort( void*  comparator,
                        size_t start = 0,
                        size_t count = this->__self->get()->size() );
AutoIt:
    $oVectorOfMat.sort( $comparator[, $start[, $count]] ) -> None
```

### VectorOfMat::sort_variant

```cpp
void VectorOfMat::sort_variant( void*  comparator,
                                size_t start = 0,
                                size_t count = this->__self->get()->size() );
AutoIt:
    $oVectorOfMat.sort_variant( $comparator[, $start[, $count]] ) -> None
```

### VectorOfMat::start

```cpp
void* VectorOfMat::start();
AutoIt:
    $oVectorOfMat.start() -> retval
```

## MapOfStringAndPacket

### MapOfStringAndPacket::create

```cpp
static MapOfStringAndPacket MapOfStringAndPacket::create();
AutoIt:
    _Mediapipe_ObjCreate("MapOfStringAndPacket").create() -> <MapOfStringAndPacket object>
```

```cpp
static std::shared_ptr<MapOfStringAndPacket> MapOfStringAndPacket::create( std::vector<std::pair<std::string, mediapipe::Packet>> pairs );
AutoIt:
    _Mediapipe_ObjCreate("MapOfStringAndPacket").create( $pairs ) -> retval
```

### MapOfStringAndPacket::Add

```cpp
void MapOfStringAndPacket::Add( std::string       key,
                                mediapipe::Packet value );
AutoIt:
    $oMapOfStringAndPacket.Add( $key, $value ) -> None
```

### MapOfStringAndPacket::Get

```cpp
mediapipe::Packet MapOfStringAndPacket::Get( std::string key );
AutoIt:
    $oMapOfStringAndPacket.Get( $key ) -> retval
```

### MapOfStringAndPacket::Items

```cpp
std::vector<mediapipe::Packet> MapOfStringAndPacket::Items();
AutoIt:
    $oMapOfStringAndPacket.Items() -> retval
```

### MapOfStringAndPacket::Keys

```cpp
std::vector<std::string> MapOfStringAndPacket::Keys();
AutoIt:
    $oMapOfStringAndPacket.Keys() -> retval
```

### MapOfStringAndPacket::Remove

```cpp
size_t MapOfStringAndPacket::Remove( std::string key );
AutoIt:
    $oMapOfStringAndPacket.Remove( $key ) -> retval
```

### MapOfStringAndPacket::clear

```cpp
void MapOfStringAndPacket::clear();
AutoIt:
    $oMapOfStringAndPacket.clear() -> None
```

### MapOfStringAndPacket::contains

```cpp
bool MapOfStringAndPacket::contains( std::string key );
AutoIt:
    $oMapOfStringAndPacket.contains( $key ) -> retval
```

### MapOfStringAndPacket::count

```cpp
size_t MapOfStringAndPacket::count( std::string key );
AutoIt:
    $oMapOfStringAndPacket.count( $key ) -> retval
```

### MapOfStringAndPacket::empty

```cpp
bool MapOfStringAndPacket::empty();
AutoIt:
    $oMapOfStringAndPacket.empty() -> retval
```

### MapOfStringAndPacket::erase

```cpp
size_t MapOfStringAndPacket::erase( std::string key );
AutoIt:
    $oMapOfStringAndPacket.erase( $key ) -> retval
```

### MapOfStringAndPacket::get_Item

```cpp
mediapipe::Packet MapOfStringAndPacket::get_Item( std::string vKey );
AutoIt:
    $oMapOfStringAndPacket.Item( $vKey ) -> retval
    $oMapOfStringAndPacket( $vKey ) -> retval
```

### MapOfStringAndPacket::has

```cpp
bool MapOfStringAndPacket::has( std::string key );
AutoIt:
    $oMapOfStringAndPacket.has( $key ) -> retval
```

### MapOfStringAndPacket::max_size

```cpp
size_t MapOfStringAndPacket::max_size();
AutoIt:
    $oMapOfStringAndPacket.max_size() -> retval
```

### MapOfStringAndPacket::merge

```cpp
void MapOfStringAndPacket::merge( MapOfStringAndPacket other );
AutoIt:
    $oMapOfStringAndPacket.merge( $other ) -> None
```

### MapOfStringAndPacket::put_Item

```cpp
void MapOfStringAndPacket::put_Item( std::string       vKey,
                                     mediapipe::Packet vItem );
AutoIt:
    $oMapOfStringAndPacket.Item( $vKey ) = $vItem
```

### MapOfStringAndPacket::size

```cpp
size_t MapOfStringAndPacket::size();
AutoIt:
    $oMapOfStringAndPacket.size() -> retval
```

## VectorOfBool

### VectorOfBool::create

```cpp
static VectorOfBool VectorOfBool::create();
AutoIt:
    _Mediapipe_ObjCreate("VectorOfBool").create() -> <VectorOfBool object>
```

```cpp
static VectorOfBool VectorOfBool::create( size_t size );
AutoIt:
    _Mediapipe_ObjCreate("VectorOfBool").create( $size ) -> <VectorOfBool object>
```

```cpp
static VectorOfBool VectorOfBool::create( VectorOfBool other );
AutoIt:
    _Mediapipe_ObjCreate("VectorOfBool").create( $other ) -> <VectorOfBool object>
```

### VectorOfBool::Add

```cpp
void VectorOfBool::Add( bool value );
AutoIt:
    $oVectorOfBool.Add( $value ) -> None
```

### VectorOfBool::Items

```cpp
VectorOfBool VectorOfBool::Items();
AutoIt:
    $oVectorOfBool.Items() -> retval
```

### VectorOfBool::Keys

```cpp
std::vector<int> VectorOfBool::Keys();
AutoIt:
    $oVectorOfBool.Keys() -> retval
```

### VectorOfBool::Remove

```cpp
void VectorOfBool::Remove( size_t index );
AutoIt:
    $oVectorOfBool.Remove( $index ) -> None
```

### VectorOfBool::at

```cpp
bool VectorOfBool::at( size_t index );
AutoIt:
    $oVectorOfBool.at( $index ) -> retval
```

```cpp
void VectorOfBool::at( size_t index,
                       bool   value );
AutoIt:
    $oVectorOfBool.at( $index, $value ) -> None
```

### VectorOfBool::clear

```cpp
void VectorOfBool::clear();
AutoIt:
    $oVectorOfBool.clear() -> None
```

### VectorOfBool::empty

```cpp
bool VectorOfBool::empty();
AutoIt:
    $oVectorOfBool.empty() -> retval
```

### VectorOfBool::end

```cpp
void* VectorOfBool::end();
AutoIt:
    $oVectorOfBool.end() -> retval
```

### VectorOfBool::get_Item

```cpp
bool VectorOfBool::get_Item( size_t vIndex );
AutoIt:
    $oVectorOfBool.Item( $vIndex ) -> retval
    $oVectorOfBool( $vIndex ) -> retval
```

### VectorOfBool::push_back

```cpp
void VectorOfBool::push_back( bool value );
AutoIt:
    $oVectorOfBool.push_back( $value ) -> None
```

### VectorOfBool::push_vector

```cpp
void VectorOfBool::push_vector( VectorOfBool other );
AutoIt:
    $oVectorOfBool.push_vector( $other ) -> None
```

```cpp
void VectorOfBool::push_vector( VectorOfBool other,
                                size_t       count,
                                size_t       start = 0 );
AutoIt:
    $oVectorOfBool.push_vector( $other, $count[, $start] ) -> None
```

### VectorOfBool::put_Item

```cpp
void VectorOfBool::put_Item( size_t vIndex,
                             bool   vItem );
AutoIt:
    $oVectorOfBool.Item( $vIndex ) = $vItem
```

### VectorOfBool::size

```cpp
size_t VectorOfBool::size();
AutoIt:
    $oVectorOfBool.size() -> retval
```

### VectorOfBool::slice

```cpp
VectorOfBool VectorOfBool::slice( size_t start = 0,
                                  size_t count = this->__self->get()->size() );
AutoIt:
    $oVectorOfBool.slice( [$start[, $count]] ) -> retval
```

### VectorOfBool::sort

```cpp
void VectorOfBool::sort( void*  comparator,
                         size_t start = 0,
                         size_t count = this->__self->get()->size() );
AutoIt:
    $oVectorOfBool.sort( $comparator[, $start[, $count]] ) -> None
```

### VectorOfBool::sort_variant

```cpp
void VectorOfBool::sort_variant( void*  comparator,
                                 size_t start = 0,
                                 size_t count = this->__self->get()->size() );
AutoIt:
    $oVectorOfBool.sort_variant( $comparator[, $start[, $count]] ) -> None
```

### VectorOfBool::start

```cpp
void* VectorOfBool::start();
AutoIt:
    $oVectorOfBool.start() -> retval
```

## VectorOfFloat

### VectorOfFloat::create

```cpp
static VectorOfFloat VectorOfFloat::create();
AutoIt:
    _Mediapipe_ObjCreate("VectorOfFloat").create() -> <VectorOfFloat object>
```

```cpp
static VectorOfFloat VectorOfFloat::create( size_t size );
AutoIt:
    _Mediapipe_ObjCreate("VectorOfFloat").create( $size ) -> <VectorOfFloat object>
```

```cpp
static VectorOfFloat VectorOfFloat::create( VectorOfFloat other );
AutoIt:
    _Mediapipe_ObjCreate("VectorOfFloat").create( $other ) -> <VectorOfFloat object>
```

### VectorOfFloat::Add

```cpp
void VectorOfFloat::Add( float value );
AutoIt:
    $oVectorOfFloat.Add( $value ) -> None
```

### VectorOfFloat::Items

```cpp
VectorOfFloat VectorOfFloat::Items();
AutoIt:
    $oVectorOfFloat.Items() -> retval
```

### VectorOfFloat::Keys

```cpp
std::vector<int> VectorOfFloat::Keys();
AutoIt:
    $oVectorOfFloat.Keys() -> retval
```

### VectorOfFloat::Remove

```cpp
void VectorOfFloat::Remove( size_t index );
AutoIt:
    $oVectorOfFloat.Remove( $index ) -> None
```

### VectorOfFloat::at

```cpp
float VectorOfFloat::at( size_t index );
AutoIt:
    $oVectorOfFloat.at( $index ) -> retval
```

```cpp
void VectorOfFloat::at( size_t index,
                        float  value );
AutoIt:
    $oVectorOfFloat.at( $index, $value ) -> None
```

### VectorOfFloat::clear

```cpp
void VectorOfFloat::clear();
AutoIt:
    $oVectorOfFloat.clear() -> None
```

### VectorOfFloat::empty

```cpp
bool VectorOfFloat::empty();
AutoIt:
    $oVectorOfFloat.empty() -> retval
```

### VectorOfFloat::end

```cpp
void* VectorOfFloat::end();
AutoIt:
    $oVectorOfFloat.end() -> retval
```

### VectorOfFloat::get_Item

```cpp
float VectorOfFloat::get_Item( size_t vIndex );
AutoIt:
    $oVectorOfFloat.Item( $vIndex ) -> retval
    $oVectorOfFloat( $vIndex ) -> retval
```

### VectorOfFloat::push_back

```cpp
void VectorOfFloat::push_back( float value );
AutoIt:
    $oVectorOfFloat.push_back( $value ) -> None
```

### VectorOfFloat::push_vector

```cpp
void VectorOfFloat::push_vector( VectorOfFloat other );
AutoIt:
    $oVectorOfFloat.push_vector( $other ) -> None
```

```cpp
void VectorOfFloat::push_vector( VectorOfFloat other,
                                 size_t        count,
                                 size_t        start = 0 );
AutoIt:
    $oVectorOfFloat.push_vector( $other, $count[, $start] ) -> None
```

### VectorOfFloat::put_Item

```cpp
void VectorOfFloat::put_Item( size_t vIndex,
                              float  vItem );
AutoIt:
    $oVectorOfFloat.Item( $vIndex ) = $vItem
```

### VectorOfFloat::size

```cpp
size_t VectorOfFloat::size();
AutoIt:
    $oVectorOfFloat.size() -> retval
```

### VectorOfFloat::slice

```cpp
VectorOfFloat VectorOfFloat::slice( size_t start = 0,
                                    size_t count = this->__self->get()->size() );
AutoIt:
    $oVectorOfFloat.slice( [$start[, $count]] ) -> retval
```

### VectorOfFloat::sort

```cpp
void VectorOfFloat::sort( void*  comparator,
                          size_t start = 0,
                          size_t count = this->__self->get()->size() );
AutoIt:
    $oVectorOfFloat.sort( $comparator[, $start[, $count]] ) -> None
```

### VectorOfFloat::sort_variant

```cpp
void VectorOfFloat::sort_variant( void*  comparator,
                                  size_t start = 0,
                                  size_t count = this->__self->get()->size() );
AutoIt:
    $oVectorOfFloat.sort_variant( $comparator[, $start[, $count]] ) -> None
```

### VectorOfFloat::start

```cpp
void* VectorOfFloat::start();
AutoIt:
    $oVectorOfFloat.start() -> retval
```

## VectorOfImage

### VectorOfImage::create

```cpp
static VectorOfImage VectorOfImage::create();
AutoIt:
    _Mediapipe_ObjCreate("VectorOfImage").create() -> <VectorOfImage object>
```

```cpp
static VectorOfImage VectorOfImage::create( size_t size );
AutoIt:
    _Mediapipe_ObjCreate("VectorOfImage").create( $size ) -> <VectorOfImage object>
```

```cpp
static VectorOfImage VectorOfImage::create( VectorOfImage other );
AutoIt:
    _Mediapipe_ObjCreate("VectorOfImage").create( $other ) -> <VectorOfImage object>
```

### VectorOfImage::Add

```cpp
void VectorOfImage::Add( mediapipe::Image value );
AutoIt:
    $oVectorOfImage.Add( $value ) -> None
```

### VectorOfImage::Items

```cpp
VectorOfImage VectorOfImage::Items();
AutoIt:
    $oVectorOfImage.Items() -> retval
```

### VectorOfImage::Keys

```cpp
std::vector<int> VectorOfImage::Keys();
AutoIt:
    $oVectorOfImage.Keys() -> retval
```

### VectorOfImage::Remove

```cpp
void VectorOfImage::Remove( size_t index );
AutoIt:
    $oVectorOfImage.Remove( $index ) -> None
```

### VectorOfImage::at

```cpp
mediapipe::Image VectorOfImage::at( size_t index );
AutoIt:
    $oVectorOfImage.at( $index ) -> retval
```

```cpp
void VectorOfImage::at( size_t           index,
                        mediapipe::Image value );
AutoIt:
    $oVectorOfImage.at( $index, $value ) -> None
```

### VectorOfImage::clear

```cpp
void VectorOfImage::clear();
AutoIt:
    $oVectorOfImage.clear() -> None
```

### VectorOfImage::empty

```cpp
bool VectorOfImage::empty();
AutoIt:
    $oVectorOfImage.empty() -> retval
```

### VectorOfImage::end

```cpp
void* VectorOfImage::end();
AutoIt:
    $oVectorOfImage.end() -> retval
```

### VectorOfImage::get_Item

```cpp
mediapipe::Image VectorOfImage::get_Item( size_t vIndex );
AutoIt:
    $oVectorOfImage.Item( $vIndex ) -> retval
    $oVectorOfImage( $vIndex ) -> retval
```

### VectorOfImage::push_back

```cpp
void VectorOfImage::push_back( mediapipe::Image value );
AutoIt:
    $oVectorOfImage.push_back( $value ) -> None
```

### VectorOfImage::push_vector

```cpp
void VectorOfImage::push_vector( VectorOfImage other );
AutoIt:
    $oVectorOfImage.push_vector( $other ) -> None
```

```cpp
void VectorOfImage::push_vector( VectorOfImage other,
                                 size_t        count,
                                 size_t        start = 0 );
AutoIt:
    $oVectorOfImage.push_vector( $other, $count[, $start] ) -> None
```

### VectorOfImage::put_Item

```cpp
void VectorOfImage::put_Item( size_t           vIndex,
                              mediapipe::Image vItem );
AutoIt:
    $oVectorOfImage.Item( $vIndex ) = $vItem
```

### VectorOfImage::size

```cpp
size_t VectorOfImage::size();
AutoIt:
    $oVectorOfImage.size() -> retval
```

### VectorOfImage::slice

```cpp
VectorOfImage VectorOfImage::slice( size_t start = 0,
                                    size_t count = this->__self->get()->size() );
AutoIt:
    $oVectorOfImage.slice( [$start[, $count]] ) -> retval
```

### VectorOfImage::sort

```cpp
void VectorOfImage::sort( void*  comparator,
                          size_t start = 0,
                          size_t count = this->__self->get()->size() );
AutoIt:
    $oVectorOfImage.sort( $comparator[, $start[, $count]] ) -> None
```

### VectorOfImage::sort_variant

```cpp
void VectorOfImage::sort_variant( void*  comparator,
                                  size_t start = 0,
                                  size_t count = this->__self->get()->size() );
AutoIt:
    $oVectorOfImage.sort_variant( $comparator[, $start[, $count]] ) -> None
```

### VectorOfImage::start

```cpp
void* VectorOfImage::start();
AutoIt:
    $oVectorOfImage.start() -> retval
```

## VectorOfPacket

### VectorOfPacket::create

```cpp
static VectorOfPacket VectorOfPacket::create();
AutoIt:
    _Mediapipe_ObjCreate("VectorOfPacket").create() -> <VectorOfPacket object>
```

```cpp
static VectorOfPacket VectorOfPacket::create( size_t size );
AutoIt:
    _Mediapipe_ObjCreate("VectorOfPacket").create( $size ) -> <VectorOfPacket object>
```

```cpp
static VectorOfPacket VectorOfPacket::create( VectorOfPacket other );
AutoIt:
    _Mediapipe_ObjCreate("VectorOfPacket").create( $other ) -> <VectorOfPacket object>
```

### VectorOfPacket::Add

```cpp
void VectorOfPacket::Add( mediapipe::Packet value );
AutoIt:
    $oVectorOfPacket.Add( $value ) -> None
```

### VectorOfPacket::Items

```cpp
VectorOfPacket VectorOfPacket::Items();
AutoIt:
    $oVectorOfPacket.Items() -> retval
```

### VectorOfPacket::Keys

```cpp
std::vector<int> VectorOfPacket::Keys();
AutoIt:
    $oVectorOfPacket.Keys() -> retval
```

### VectorOfPacket::Remove

```cpp
void VectorOfPacket::Remove( size_t index );
AutoIt:
    $oVectorOfPacket.Remove( $index ) -> None
```

### VectorOfPacket::at

```cpp
mediapipe::Packet VectorOfPacket::at( size_t index );
AutoIt:
    $oVectorOfPacket.at( $index ) -> retval
```

```cpp
void VectorOfPacket::at( size_t            index,
                         mediapipe::Packet value );
AutoIt:
    $oVectorOfPacket.at( $index, $value ) -> None
```

### VectorOfPacket::clear

```cpp
void VectorOfPacket::clear();
AutoIt:
    $oVectorOfPacket.clear() -> None
```

### VectorOfPacket::empty

```cpp
bool VectorOfPacket::empty();
AutoIt:
    $oVectorOfPacket.empty() -> retval
```

### VectorOfPacket::end

```cpp
void* VectorOfPacket::end();
AutoIt:
    $oVectorOfPacket.end() -> retval
```

### VectorOfPacket::get_Item

```cpp
mediapipe::Packet VectorOfPacket::get_Item( size_t vIndex );
AutoIt:
    $oVectorOfPacket.Item( $vIndex ) -> retval
    $oVectorOfPacket( $vIndex ) -> retval
```

### VectorOfPacket::push_back

```cpp
void VectorOfPacket::push_back( mediapipe::Packet value );
AutoIt:
    $oVectorOfPacket.push_back( $value ) -> None
```

### VectorOfPacket::push_vector

```cpp
void VectorOfPacket::push_vector( VectorOfPacket other );
AutoIt:
    $oVectorOfPacket.push_vector( $other ) -> None
```

```cpp
void VectorOfPacket::push_vector( VectorOfPacket other,
                                  size_t         count,
                                  size_t         start = 0 );
AutoIt:
    $oVectorOfPacket.push_vector( $other, $count[, $start] ) -> None
```

### VectorOfPacket::put_Item

```cpp
void VectorOfPacket::put_Item( size_t            vIndex,
                               mediapipe::Packet vItem );
AutoIt:
    $oVectorOfPacket.Item( $vIndex ) = $vItem
```

### VectorOfPacket::size

```cpp
size_t VectorOfPacket::size();
AutoIt:
    $oVectorOfPacket.size() -> retval
```

### VectorOfPacket::slice

```cpp
VectorOfPacket VectorOfPacket::slice( size_t start = 0,
                                      size_t count = this->__self->get()->size() );
AutoIt:
    $oVectorOfPacket.slice( [$start[, $count]] ) -> retval
```

### VectorOfPacket::sort

```cpp
void VectorOfPacket::sort( void*  comparator,
                           size_t start = 0,
                           size_t count = this->__self->get()->size() );
AutoIt:
    $oVectorOfPacket.sort( $comparator[, $start[, $count]] ) -> None
```

### VectorOfPacket::sort_variant

```cpp
void VectorOfPacket::sort_variant( void*  comparator,
                                   size_t start = 0,
                                   size_t count = this->__self->get()->size() );
AutoIt:
    $oVectorOfPacket.sort_variant( $comparator[, $start[, $count]] ) -> None
```

### VectorOfPacket::start

```cpp
void* VectorOfPacket::start();
AutoIt:
    $oVectorOfPacket.start() -> retval
```

## VectorOfString

### VectorOfString::create

```cpp
static VectorOfString VectorOfString::create();
AutoIt:
    _Mediapipe_ObjCreate("VectorOfString").create() -> <VectorOfString object>
```

```cpp
static VectorOfString VectorOfString::create( size_t size );
AutoIt:
    _Mediapipe_ObjCreate("VectorOfString").create( $size ) -> <VectorOfString object>
```

```cpp
static VectorOfString VectorOfString::create( VectorOfString other );
AutoIt:
    _Mediapipe_ObjCreate("VectorOfString").create( $other ) -> <VectorOfString object>
```

### VectorOfString::Add

```cpp
void VectorOfString::Add( std::string value );
AutoIt:
    $oVectorOfString.Add( $value ) -> None
```

### VectorOfString::Items

```cpp
VectorOfString VectorOfString::Items();
AutoIt:
    $oVectorOfString.Items() -> retval
```

### VectorOfString::Keys

```cpp
std::vector<int> VectorOfString::Keys();
AutoIt:
    $oVectorOfString.Keys() -> retval
```

### VectorOfString::Remove

```cpp
void VectorOfString::Remove( size_t index );
AutoIt:
    $oVectorOfString.Remove( $index ) -> None
```

### VectorOfString::at

```cpp
std::string VectorOfString::at( size_t index );
AutoIt:
    $oVectorOfString.at( $index ) -> retval
```

```cpp
void VectorOfString::at( size_t      index,
                         std::string value );
AutoIt:
    $oVectorOfString.at( $index, $value ) -> None
```

### VectorOfString::clear

```cpp
void VectorOfString::clear();
AutoIt:
    $oVectorOfString.clear() -> None
```

### VectorOfString::empty

```cpp
bool VectorOfString::empty();
AutoIt:
    $oVectorOfString.empty() -> retval
```

### VectorOfString::end

```cpp
void* VectorOfString::end();
AutoIt:
    $oVectorOfString.end() -> retval
```

### VectorOfString::get_Item

```cpp
std::string VectorOfString::get_Item( size_t vIndex );
AutoIt:
    $oVectorOfString.Item( $vIndex ) -> retval
    $oVectorOfString( $vIndex ) -> retval
```

### VectorOfString::push_back

```cpp
void VectorOfString::push_back( std::string value );
AutoIt:
    $oVectorOfString.push_back( $value ) -> None
```

### VectorOfString::push_vector

```cpp
void VectorOfString::push_vector( VectorOfString other );
AutoIt:
    $oVectorOfString.push_vector( $other ) -> None
```

```cpp
void VectorOfString::push_vector( VectorOfString other,
                                  size_t         count,
                                  size_t         start = 0 );
AutoIt:
    $oVectorOfString.push_vector( $other, $count[, $start] ) -> None
```

### VectorOfString::put_Item

```cpp
void VectorOfString::put_Item( size_t      vIndex,
                               std::string vItem );
AutoIt:
    $oVectorOfString.Item( $vIndex ) = $vItem
```

### VectorOfString::size

```cpp
size_t VectorOfString::size();
AutoIt:
    $oVectorOfString.size() -> retval
```

### VectorOfString::slice

```cpp
VectorOfString VectorOfString::slice( size_t start = 0,
                                      size_t count = this->__self->get()->size() );
AutoIt:
    $oVectorOfString.slice( [$start[, $count]] ) -> retval
```

### VectorOfString::sort

```cpp
void VectorOfString::sort( void*  comparator,
                           size_t start = 0,
                           size_t count = this->__self->get()->size() );
AutoIt:
    $oVectorOfString.sort( $comparator[, $start[, $count]] ) -> None
```

### VectorOfString::sort_variant

```cpp
void VectorOfString::sort_variant( void*  comparator,
                                   size_t start = 0,
                                   size_t count = this->__self->get()->size() );
AutoIt:
    $oVectorOfString.sort_variant( $comparator[, $start[, $count]] ) -> None
```

### VectorOfString::start

```cpp
void* VectorOfString::start();
AutoIt:
    $oVectorOfString.start() -> retval
```

## VectorOfInt64

### VectorOfInt64::create

```cpp
static VectorOfInt64 VectorOfInt64::create();
AutoIt:
    _Mediapipe_ObjCreate("VectorOfInt64").create() -> <VectorOfInt64 object>
```

```cpp
static VectorOfInt64 VectorOfInt64::create( size_t size );
AutoIt:
    _Mediapipe_ObjCreate("VectorOfInt64").create( $size ) -> <VectorOfInt64 object>
```

```cpp
static VectorOfInt64 VectorOfInt64::create( VectorOfInt64 other );
AutoIt:
    _Mediapipe_ObjCreate("VectorOfInt64").create( $other ) -> <VectorOfInt64 object>
```

### VectorOfInt64::Add

```cpp
void VectorOfInt64::Add( int64 value );
AutoIt:
    $oVectorOfInt64.Add( $value ) -> None
```

### VectorOfInt64::Items

```cpp
VectorOfInt64 VectorOfInt64::Items();
AutoIt:
    $oVectorOfInt64.Items() -> retval
```

### VectorOfInt64::Keys

```cpp
std::vector<int> VectorOfInt64::Keys();
AutoIt:
    $oVectorOfInt64.Keys() -> retval
```

### VectorOfInt64::Remove

```cpp
void VectorOfInt64::Remove( size_t index );
AutoIt:
    $oVectorOfInt64.Remove( $index ) -> None
```

### VectorOfInt64::at

```cpp
int64 VectorOfInt64::at( size_t index );
AutoIt:
    $oVectorOfInt64.at( $index ) -> retval
```

```cpp
void VectorOfInt64::at( size_t index,
                        int64  value );
AutoIt:
    $oVectorOfInt64.at( $index, $value ) -> None
```

### VectorOfInt64::clear

```cpp
void VectorOfInt64::clear();
AutoIt:
    $oVectorOfInt64.clear() -> None
```

### VectorOfInt64::empty

```cpp
bool VectorOfInt64::empty();
AutoIt:
    $oVectorOfInt64.empty() -> retval
```

### VectorOfInt64::end

```cpp
void* VectorOfInt64::end();
AutoIt:
    $oVectorOfInt64.end() -> retval
```

### VectorOfInt64::get_Item

```cpp
int64 VectorOfInt64::get_Item( size_t vIndex );
AutoIt:
    $oVectorOfInt64.Item( $vIndex ) -> retval
    $oVectorOfInt64( $vIndex ) -> retval
```

### VectorOfInt64::push_back

```cpp
void VectorOfInt64::push_back( int64 value );
AutoIt:
    $oVectorOfInt64.push_back( $value ) -> None
```

### VectorOfInt64::push_vector

```cpp
void VectorOfInt64::push_vector( VectorOfInt64 other );
AutoIt:
    $oVectorOfInt64.push_vector( $other ) -> None
```

```cpp
void VectorOfInt64::push_vector( VectorOfInt64 other,
                                 size_t        count,
                                 size_t        start = 0 );
AutoIt:
    $oVectorOfInt64.push_vector( $other, $count[, $start] ) -> None
```

### VectorOfInt64::put_Item

```cpp
void VectorOfInt64::put_Item( size_t vIndex,
                              int64  vItem );
AutoIt:
    $oVectorOfInt64.Item( $vIndex ) = $vItem
```

### VectorOfInt64::size

```cpp
size_t VectorOfInt64::size();
AutoIt:
    $oVectorOfInt64.size() -> retval
```

### VectorOfInt64::slice

```cpp
VectorOfInt64 VectorOfInt64::slice( size_t start = 0,
                                    size_t count = this->__self->get()->size() );
AutoIt:
    $oVectorOfInt64.slice( [$start[, $count]] ) -> retval
```

### VectorOfInt64::sort

```cpp
void VectorOfInt64::sort( void*  comparator,
                          size_t start = 0,
                          size_t count = this->__self->get()->size() );
AutoIt:
    $oVectorOfInt64.sort( $comparator[, $start[, $count]] ) -> None
```

### VectorOfInt64::sort_variant

```cpp
void VectorOfInt64::sort_variant( void*  comparator,
                                  size_t start = 0,
                                  size_t count = this->__self->get()->size() );
AutoIt:
    $oVectorOfInt64.sort_variant( $comparator[, $start[, $count]] ) -> None
```

### VectorOfInt64::start

```cpp
void* VectorOfInt64::start();
AutoIt:
    $oVectorOfInt64.start() -> retval
```

## VectorOfPairOfStringAndPacket

### VectorOfPairOfStringAndPacket::create

```cpp
static VectorOfPairOfStringAndPacket VectorOfPairOfStringAndPacket::create();
AutoIt:
    _Mediapipe_ObjCreate("VectorOfPairOfStringAndPacket").create() -> <VectorOfPairOfStringAndPacket object>
```

```cpp
static VectorOfPairOfStringAndPacket VectorOfPairOfStringAndPacket::create( size_t size );
AutoIt:
    _Mediapipe_ObjCreate("VectorOfPairOfStringAndPacket").create( $size ) -> <VectorOfPairOfStringAndPacket object>
```

```cpp
static VectorOfPairOfStringAndPacket VectorOfPairOfStringAndPacket::create( VectorOfPairOfStringAndPacket other );
AutoIt:
    _Mediapipe_ObjCreate("VectorOfPairOfStringAndPacket").create( $other ) -> <VectorOfPairOfStringAndPacket object>
```

### VectorOfPairOfStringAndPacket::Add

```cpp
void VectorOfPairOfStringAndPacket::Add( std::pair<std::string, mediapipe::Packet> value );
AutoIt:
    $oVectorOfPairOfStringAndPacket.Add( $value ) -> None
```

### VectorOfPairOfStringAndPacket::Items

```cpp
VectorOfPairOfStringAndPacket VectorOfPairOfStringAndPacket::Items();
AutoIt:
    $oVectorOfPairOfStringAndPacket.Items() -> retval
```

### VectorOfPairOfStringAndPacket::Keys

```cpp
std::vector<int> VectorOfPairOfStringAndPacket::Keys();
AutoIt:
    $oVectorOfPairOfStringAndPacket.Keys() -> retval
```

### VectorOfPairOfStringAndPacket::Remove

```cpp
void VectorOfPairOfStringAndPacket::Remove( size_t index );
AutoIt:
    $oVectorOfPairOfStringAndPacket.Remove( $index ) -> None
```

### VectorOfPairOfStringAndPacket::at

```cpp
std::pair<std::string, mediapipe::Packet> VectorOfPairOfStringAndPacket::at( size_t index );
AutoIt:
    $oVectorOfPairOfStringAndPacket.at( $index ) -> retval
```

```cpp
void VectorOfPairOfStringAndPacket::at( size_t                                    index,
                                        std::pair<std::string, mediapipe::Packet> value );
AutoIt:
    $oVectorOfPairOfStringAndPacket.at( $index, $value ) -> None
```

### VectorOfPairOfStringAndPacket::clear

```cpp
void VectorOfPairOfStringAndPacket::clear();
AutoIt:
    $oVectorOfPairOfStringAndPacket.clear() -> None
```

### VectorOfPairOfStringAndPacket::empty

```cpp
bool VectorOfPairOfStringAndPacket::empty();
AutoIt:
    $oVectorOfPairOfStringAndPacket.empty() -> retval
```

### VectorOfPairOfStringAndPacket::end

```cpp
void* VectorOfPairOfStringAndPacket::end();
AutoIt:
    $oVectorOfPairOfStringAndPacket.end() -> retval
```

### VectorOfPairOfStringAndPacket::get_Item

```cpp
std::pair<std::string, mediapipe::Packet> VectorOfPairOfStringAndPacket::get_Item( size_t vIndex );
AutoIt:
    $oVectorOfPairOfStringAndPacket.Item( $vIndex ) -> retval
    $oVectorOfPairOfStringAndPacket( $vIndex ) -> retval
```

### VectorOfPairOfStringAndPacket::push_back

```cpp
void VectorOfPairOfStringAndPacket::push_back( std::pair<std::string, mediapipe::Packet> value );
AutoIt:
    $oVectorOfPairOfStringAndPacket.push_back( $value ) -> None
```

### VectorOfPairOfStringAndPacket::push_vector

```cpp
void VectorOfPairOfStringAndPacket::push_vector( VectorOfPairOfStringAndPacket other );
AutoIt:
    $oVectorOfPairOfStringAndPacket.push_vector( $other ) -> None
```

```cpp
void VectorOfPairOfStringAndPacket::push_vector( VectorOfPairOfStringAndPacket other,
                                                 size_t                        count,
                                                 size_t                        start = 0 );
AutoIt:
    $oVectorOfPairOfStringAndPacket.push_vector( $other, $count[, $start] ) -> None
```

### VectorOfPairOfStringAndPacket::put_Item

```cpp
void VectorOfPairOfStringAndPacket::put_Item( size_t                                    vIndex,
                                              std::pair<std::string, mediapipe::Packet> vItem );
AutoIt:
    $oVectorOfPairOfStringAndPacket.Item( $vIndex ) = $vItem
```

### VectorOfPairOfStringAndPacket::size

```cpp
size_t VectorOfPairOfStringAndPacket::size();
AutoIt:
    $oVectorOfPairOfStringAndPacket.size() -> retval
```

### VectorOfPairOfStringAndPacket::slice

```cpp
VectorOfPairOfStringAndPacket VectorOfPairOfStringAndPacket::slice( size_t start = 0,
                                                                    size_t count = this->__self->get()->size() );
AutoIt:
    $oVectorOfPairOfStringAndPacket.slice( [$start[, $count]] ) -> retval
```

### VectorOfPairOfStringAndPacket::sort

```cpp
void VectorOfPairOfStringAndPacket::sort( void*  comparator,
                                          size_t start = 0,
                                          size_t count = this->__self->get()->size() );
AutoIt:
    $oVectorOfPairOfStringAndPacket.sort( $comparator[, $start[, $count]] ) -> None
```

### VectorOfPairOfStringAndPacket::sort_variant

```cpp
void VectorOfPairOfStringAndPacket::sort_variant( void*  comparator,
                                                  size_t start = 0,
                                                  size_t count = this->__self->get()->size() );
AutoIt:
    $oVectorOfPairOfStringAndPacket.sort_variant( $comparator[, $start[, $count]] ) -> None
```

### VectorOfPairOfStringAndPacket::start

```cpp
void* VectorOfPairOfStringAndPacket::start();
AutoIt:
    $oVectorOfPairOfStringAndPacket.start() -> retval
```
