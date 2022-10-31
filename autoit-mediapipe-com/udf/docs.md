# AutoIt Mediapipe UDF

## Table Of Contents

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->


- [google::protobuf::autoit::MapContainer](#googleprotobufautoitmapcontainer)
  - [google::protobuf::autoit::MapContainer::create](#googleprotobufautoitmapcontainercreate)
  - [google::protobuf::autoit::MapContainer::MergeFrom](#googleprotobufautoitmapcontainermergefrom)
  - [google::protobuf::autoit::MapContainer::clear](#googleprotobufautoitmapcontainerclear)
  - [google::protobuf::autoit::MapContainer::contains](#googleprotobufautoitmapcontainercontains)
  - [google::protobuf::autoit::MapContainer::get](#googleprotobufautoitmapcontainerget)
  - [google::protobuf::autoit::MapContainer::get_Item](#googleprotobufautoitmapcontainerget_item)
  - [google::protobuf::autoit::MapContainer::get__NewEnum](#googleprotobufautoitmapcontainerget__newenum)
  - [google::protobuf::autoit::MapContainer::length](#googleprotobufautoitmapcontainerlength)
  - [google::protobuf::autoit::MapContainer::put_Item](#googleprotobufautoitmapcontainerput_item)
  - [google::protobuf::autoit::MapContainer::setFields](#googleprotobufautoitmapcontainersetfields)
  - [google::protobuf::autoit::MapContainer::size](#googleprotobufautoitmapcontainersize)
  - [google::protobuf::autoit::MapContainer::str](#googleprotobufautoitmapcontainerstr)
- [google::protobuf::autoit::cmessage](#googleprotobufautoitcmessage)
  - [google::protobuf::autoit::cmessage::GetFieldValue](#googleprotobufautoitcmessagegetfieldvalue)
  - [google::protobuf::autoit::cmessage::SetFieldValue](#googleprotobufautoitcmessagesetfieldvalue)
- [mediapipe](#mediapipe)
  - [mediapipe::variant](#mediapipevariant)
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
  - [mediapipe::autoit::packet_getter::get_proto](#mediapipeautoitpacket_getterget_proto)
  - [mediapipe::autoit::packet_getter::get_proto_list](#mediapipeautoitpacket_getterget_proto_list)
  - [mediapipe::autoit::packet_getter::get_str](#mediapipeautoitpacket_getterget_str)
  - [mediapipe::autoit::packet_getter::get_str_list](#mediapipeautoitpacket_getterget_str_list)
  - [mediapipe::autoit::packet_getter::get_str_to_packet_dict](#mediapipeautoitpacket_getterget_str_to_packet_dict)
  - [mediapipe::autoit::packet_getter::get_uint](#mediapipeautoitpacket_getterget_uint)
- [google::protobuf::autoit::RepeatedContainer](#googleprotobufautoitrepeatedcontainer)
  - [google::protobuf::autoit::RepeatedContainer::create](#googleprotobufautoitrepeatedcontainercreate)
  - [google::protobuf::autoit::RepeatedContainer::MergeFrom](#googleprotobufautoitrepeatedcontainermergefrom)
  - [google::protobuf::autoit::RepeatedContainer::add](#googleprotobufautoitrepeatedcontaineradd)
  - [google::protobuf::autoit::RepeatedContainer::append](#googleprotobufautoitrepeatedcontainerappend)
  - [google::protobuf::autoit::RepeatedContainer::clear](#googleprotobufautoitrepeatedcontainerclear)
  - [google::protobuf::autoit::RepeatedContainer::deepcopy](#googleprotobufautoitrepeatedcontainerdeepcopy)
  - [google::protobuf::autoit::RepeatedContainer::extend](#googleprotobufautoitrepeatedcontainerextend)
  - [google::protobuf::autoit::RepeatedContainer::get_Item](#googleprotobufautoitrepeatedcontainerget_item)
  - [google::protobuf::autoit::RepeatedContainer::get__NewEnum](#googleprotobufautoitrepeatedcontainerget__newenum)
  - [google::protobuf::autoit::RepeatedContainer::insert](#googleprotobufautoitrepeatedcontainerinsert)
  - [google::protobuf::autoit::RepeatedContainer::length](#googleprotobufautoitrepeatedcontainerlength)
  - [google::protobuf::autoit::RepeatedContainer::pop](#googleprotobufautoitrepeatedcontainerpop)
  - [google::protobuf::autoit::RepeatedContainer::put_Item](#googleprotobufautoitrepeatedcontainerput_item)
  - [google::protobuf::autoit::RepeatedContainer::reverse](#googleprotobufautoitrepeatedcontainerreverse)
  - [google::protobuf::autoit::RepeatedContainer::size](#googleprotobufautoitrepeatedcontainersize)
  - [google::protobuf::autoit::RepeatedContainer::slice](#googleprotobufautoitrepeatedcontainerslice)
  - [google::protobuf::autoit::RepeatedContainer::sort](#googleprotobufautoitrepeatedcontainersort)
  - [google::protobuf::autoit::RepeatedContainer::splice](#googleprotobufautoitrepeatedcontainersplice)
  - [google::protobuf::autoit::RepeatedContainer::str](#googleprotobufautoitrepeatedcontainerstr)
- [mediapipe::resource_util](#mediapiperesource_util)
  - [mediapipe::resource_util::set_resource_dir](#mediapiperesource_utilset_resource_dir)
- [mediapipe::autoit::solution_base::SolutionBase](#mediapipeautoitsolution_basesolutionbase)
  - [mediapipe::autoit::solution_base::SolutionBase::get_create](#mediapipeautoitsolution_basesolutionbaseget_create)
  - [mediapipe::autoit::solution_base::SolutionBase::process](#mediapipeautoitsolution_basesolutionbaseprocess)
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
- [google::protobuf::Message](#googleprotobufmessage)
  - [google::protobuf::Message::str](#googleprotobufmessagestr)
- [google::protobuf::TextFormat](#googleprotobuftextformat)
  - [google::protobuf::TextFormat::MergeFromString](#googleprotobuftextformatmergefromstring)
  - [google::protobuf::TextFormat::Parse](#googleprotobuftextformatparse)
  - [google::protobuf::TextFormat::ParseFromString](#googleprotobuftextformatparsefromstring)
  - [google::protobuf::TextFormat::Print](#googleprotobuftextformatprint)
  - [google::protobuf::TextFormat::PrintToString](#googleprotobuftextformatprinttostring)
- [google::protobuf::Any](#googleprotobufany)
  - [google::protobuf::Any::get_create](#googleprotobufanyget_create)
  - [google::protobuf::Any::Pack](#googleprotobufanypack)
  - [google::protobuf::Any::Unpack](#googleprotobufanyunpack)
  - [google::protobuf::Any::str](#googleprotobufanystr)
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
- [mediapipe::CalculatorOptions](#mediapipecalculatoroptions)
  - [mediapipe::CalculatorOptions::get_create](#mediapipecalculatoroptionsget_create)
  - [mediapipe::CalculatorOptions::get_Extensions](#mediapipecalculatoroptionsget_extensions)
  - [mediapipe::CalculatorOptions::str](#mediapipecalculatoroptionsstr)
- [mediapipe::MediaPipeOptions](#mediapipemediapipeoptions)
  - [mediapipe::MediaPipeOptions::get_create](#mediapipemediapipeoptionsget_create)
  - [mediapipe::MediaPipeOptions::str](#mediapipemediapipeoptionsstr)
- [mediapipe::PacketFactoryOptions](#mediapipepacketfactoryoptions)
  - [mediapipe::PacketFactoryOptions::get_create](#mediapipepacketfactoryoptionsget_create)
  - [mediapipe::PacketFactoryOptions::str](#mediapipepacketfactoryoptionsstr)
- [mediapipe::PacketFactoryConfig](#mediapipepacketfactoryconfig)
  - [mediapipe::PacketFactoryConfig::get_create](#mediapipepacketfactoryconfigget_create)
  - [mediapipe::PacketFactoryConfig::str](#mediapipepacketfactoryconfigstr)
- [mediapipe::PacketManagerConfig](#mediapipepacketmanagerconfig)
  - [mediapipe::PacketManagerConfig::get_create](#mediapipepacketmanagerconfigget_create)
  - [mediapipe::PacketManagerConfig::str](#mediapipepacketmanagerconfigstr)
- [google::protobuf::Repeated_mediapipe_PacketFactoryConfig](#googleprotobufrepeated_mediapipe_packetfactoryconfig)
  - [google::protobuf::Repeated_mediapipe_PacketFactoryConfig::create](#googleprotobufrepeated_mediapipe_packetfactoryconfigcreate)
  - [google::protobuf::Repeated_mediapipe_PacketFactoryConfig::CopyFrom](#googleprotobufrepeated_mediapipe_packetfactoryconfigcopyfrom)
  - [google::protobuf::Repeated_mediapipe_PacketFactoryConfig::MergeFrom](#googleprotobufrepeated_mediapipe_packetfactoryconfigmergefrom)
  - [google::protobuf::Repeated_mediapipe_PacketFactoryConfig::Swap](#googleprotobufrepeated_mediapipe_packetfactoryconfigswap)
  - [google::protobuf::Repeated_mediapipe_PacketFactoryConfig::SwapElements](#googleprotobufrepeated_mediapipe_packetfactoryconfigswapelements)
  - [google::protobuf::Repeated_mediapipe_PacketFactoryConfig::add](#googleprotobufrepeated_mediapipe_packetfactoryconfigadd)
  - [google::protobuf::Repeated_mediapipe_PacketFactoryConfig::clear](#googleprotobufrepeated_mediapipe_packetfactoryconfigclear)
  - [google::protobuf::Repeated_mediapipe_PacketFactoryConfig::empty](#googleprotobufrepeated_mediapipe_packetfactoryconfigempty)
  - [google::protobuf::Repeated_mediapipe_PacketFactoryConfig::extend](#googleprotobufrepeated_mediapipe_packetfactoryconfigextend)
  - [google::protobuf::Repeated_mediapipe_PacketFactoryConfig::get_Item](#googleprotobufrepeated_mediapipe_packetfactoryconfigget_item)
  - [google::protobuf::Repeated_mediapipe_PacketFactoryConfig::get__NewEnum](#googleprotobufrepeated_mediapipe_packetfactoryconfigget__newenum)
  - [google::protobuf::Repeated_mediapipe_PacketFactoryConfig::insert](#googleprotobufrepeated_mediapipe_packetfactoryconfiginsert)
  - [google::protobuf::Repeated_mediapipe_PacketFactoryConfig::pop](#googleprotobufrepeated_mediapipe_packetfactoryconfigpop)
  - [google::protobuf::Repeated_mediapipe_PacketFactoryConfig::reverse](#googleprotobufrepeated_mediapipe_packetfactoryconfigreverse)
  - [google::protobuf::Repeated_mediapipe_PacketFactoryConfig::size](#googleprotobufrepeated_mediapipe_packetfactoryconfigsize)
  - [google::protobuf::Repeated_mediapipe_PacketFactoryConfig::slice](#googleprotobufrepeated_mediapipe_packetfactoryconfigslice)
  - [google::protobuf::Repeated_mediapipe_PacketFactoryConfig::sort](#googleprotobufrepeated_mediapipe_packetfactoryconfigsort)
  - [google::protobuf::Repeated_mediapipe_PacketFactoryConfig::sort_variant](#googleprotobufrepeated_mediapipe_packetfactoryconfigsort_variant)
  - [google::protobuf::Repeated_mediapipe_PacketFactoryConfig::splice](#googleprotobufrepeated_mediapipe_packetfactoryconfigsplice)
- [mediapipe::PacketGeneratorOptions](#mediapipepacketgeneratoroptions)
  - [mediapipe::PacketGeneratorOptions::get_create](#mediapipepacketgeneratoroptionsget_create)
  - [mediapipe::PacketGeneratorOptions::str](#mediapipepacketgeneratoroptionsstr)
- [mediapipe::PacketGeneratorConfig](#mediapipepacketgeneratorconfig)
  - [mediapipe::PacketGeneratorConfig::get_create](#mediapipepacketgeneratorconfigget_create)
  - [mediapipe::PacketGeneratorConfig::str](#mediapipepacketgeneratorconfigstr)
- [google::protobuf::Repeated_std_string](#googleprotobufrepeated_std_string)
  - [google::protobuf::Repeated_std_string::create](#googleprotobufrepeated_std_stringcreate)
  - [google::protobuf::Repeated_std_string::CopyFrom](#googleprotobufrepeated_std_stringcopyfrom)
  - [google::protobuf::Repeated_std_string::MergeFrom](#googleprotobufrepeated_std_stringmergefrom)
  - [google::protobuf::Repeated_std_string::Swap](#googleprotobufrepeated_std_stringswap)
  - [google::protobuf::Repeated_std_string::SwapElements](#googleprotobufrepeated_std_stringswapelements)
  - [google::protobuf::Repeated_std_string::append](#googleprotobufrepeated_std_stringappend)
  - [google::protobuf::Repeated_std_string::clear](#googleprotobufrepeated_std_stringclear)
  - [google::protobuf::Repeated_std_string::empty](#googleprotobufrepeated_std_stringempty)
  - [google::protobuf::Repeated_std_string::extend](#googleprotobufrepeated_std_stringextend)
  - [google::protobuf::Repeated_std_string::get_Item](#googleprotobufrepeated_std_stringget_item)
  - [google::protobuf::Repeated_std_string::get__NewEnum](#googleprotobufrepeated_std_stringget__newenum)
  - [google::protobuf::Repeated_std_string::insert](#googleprotobufrepeated_std_stringinsert)
  - [google::protobuf::Repeated_std_string::pop](#googleprotobufrepeated_std_stringpop)
  - [google::protobuf::Repeated_std_string::reverse](#googleprotobufrepeated_std_stringreverse)
  - [google::protobuf::Repeated_std_string::set](#googleprotobufrepeated_std_stringset)
  - [google::protobuf::Repeated_std_string::size](#googleprotobufrepeated_std_stringsize)
  - [google::protobuf::Repeated_std_string::slice](#googleprotobufrepeated_std_stringslice)
  - [google::protobuf::Repeated_std_string::sort](#googleprotobufrepeated_std_stringsort)
  - [google::protobuf::Repeated_std_string::sort_variant](#googleprotobufrepeated_std_stringsort_variant)
  - [google::protobuf::Repeated_std_string::splice](#googleprotobufrepeated_std_stringsplice)
- [mediapipe::StatusHandlerConfig](#mediapipestatushandlerconfig)
  - [mediapipe::StatusHandlerConfig::get_create](#mediapipestatushandlerconfigget_create)
  - [mediapipe::StatusHandlerConfig::str](#mediapipestatushandlerconfigstr)
- [mediapipe::InputStreamHandlerConfig](#mediapipeinputstreamhandlerconfig)
  - [mediapipe::InputStreamHandlerConfig::get_create](#mediapipeinputstreamhandlerconfigget_create)
  - [mediapipe::InputStreamHandlerConfig::str](#mediapipeinputstreamhandlerconfigstr)
- [mediapipe::OutputStreamHandlerConfig](#mediapipeoutputstreamhandlerconfig)
  - [mediapipe::OutputStreamHandlerConfig::get_create](#mediapipeoutputstreamhandlerconfigget_create)
  - [mediapipe::OutputStreamHandlerConfig::str](#mediapipeoutputstreamhandlerconfigstr)
- [mediapipe::ExecutorConfig](#mediapipeexecutorconfig)
  - [mediapipe::ExecutorConfig::get_create](#mediapipeexecutorconfigget_create)
  - [mediapipe::ExecutorConfig::str](#mediapipeexecutorconfigstr)
- [mediapipe::InputCollection](#mediapipeinputcollection)
  - [mediapipe::InputCollection::get_create](#mediapipeinputcollectionget_create)
  - [mediapipe::InputCollection::str](#mediapipeinputcollectionstr)
- [mediapipe::InputCollectionSet](#mediapipeinputcollectionset)
  - [mediapipe::InputCollectionSet::get_create](#mediapipeinputcollectionsetget_create)
  - [mediapipe::InputCollectionSet::str](#mediapipeinputcollectionsetstr)
- [google::protobuf::Repeated_mediapipe_InputCollection](#googleprotobufrepeated_mediapipe_inputcollection)
  - [google::protobuf::Repeated_mediapipe_InputCollection::create](#googleprotobufrepeated_mediapipe_inputcollectioncreate)
  - [google::protobuf::Repeated_mediapipe_InputCollection::CopyFrom](#googleprotobufrepeated_mediapipe_inputcollectioncopyfrom)
  - [google::protobuf::Repeated_mediapipe_InputCollection::MergeFrom](#googleprotobufrepeated_mediapipe_inputcollectionmergefrom)
  - [google::protobuf::Repeated_mediapipe_InputCollection::Swap](#googleprotobufrepeated_mediapipe_inputcollectionswap)
  - [google::protobuf::Repeated_mediapipe_InputCollection::SwapElements](#googleprotobufrepeated_mediapipe_inputcollectionswapelements)
  - [google::protobuf::Repeated_mediapipe_InputCollection::add](#googleprotobufrepeated_mediapipe_inputcollectionadd)
  - [google::protobuf::Repeated_mediapipe_InputCollection::clear](#googleprotobufrepeated_mediapipe_inputcollectionclear)
  - [google::protobuf::Repeated_mediapipe_InputCollection::empty](#googleprotobufrepeated_mediapipe_inputcollectionempty)
  - [google::protobuf::Repeated_mediapipe_InputCollection::extend](#googleprotobufrepeated_mediapipe_inputcollectionextend)
  - [google::protobuf::Repeated_mediapipe_InputCollection::get_Item](#googleprotobufrepeated_mediapipe_inputcollectionget_item)
  - [google::protobuf::Repeated_mediapipe_InputCollection::get__NewEnum](#googleprotobufrepeated_mediapipe_inputcollectionget__newenum)
  - [google::protobuf::Repeated_mediapipe_InputCollection::insert](#googleprotobufrepeated_mediapipe_inputcollectioninsert)
  - [google::protobuf::Repeated_mediapipe_InputCollection::pop](#googleprotobufrepeated_mediapipe_inputcollectionpop)
  - [google::protobuf::Repeated_mediapipe_InputCollection::reverse](#googleprotobufrepeated_mediapipe_inputcollectionreverse)
  - [google::protobuf::Repeated_mediapipe_InputCollection::size](#googleprotobufrepeated_mediapipe_inputcollectionsize)
  - [google::protobuf::Repeated_mediapipe_InputCollection::slice](#googleprotobufrepeated_mediapipe_inputcollectionslice)
  - [google::protobuf::Repeated_mediapipe_InputCollection::sort](#googleprotobufrepeated_mediapipe_inputcollectionsort)
  - [google::protobuf::Repeated_mediapipe_InputCollection::sort_variant](#googleprotobufrepeated_mediapipe_inputcollectionsort_variant)
  - [google::protobuf::Repeated_mediapipe_InputCollection::splice](#googleprotobufrepeated_mediapipe_inputcollectionsplice)
- [mediapipe::InputStreamInfo](#mediapipeinputstreaminfo)
  - [mediapipe::InputStreamInfo::get_create](#mediapipeinputstreaminfoget_create)
  - [mediapipe::InputStreamInfo::str](#mediapipeinputstreaminfostr)
- [mediapipe::ProfilerConfig](#mediapipeprofilerconfig)
  - [mediapipe::ProfilerConfig::get_create](#mediapipeprofilerconfigget_create)
  - [mediapipe::ProfilerConfig::str](#mediapipeprofilerconfigstr)
- [google::protobuf::Repeated_int](#googleprotobufrepeated_int)
  - [google::protobuf::Repeated_int::create](#googleprotobufrepeated_intcreate)
  - [google::protobuf::Repeated_int::CopyFrom](#googleprotobufrepeated_intcopyfrom)
  - [google::protobuf::Repeated_int::MergeFrom](#googleprotobufrepeated_intmergefrom)
  - [google::protobuf::Repeated_int::Swap](#googleprotobufrepeated_intswap)
  - [google::protobuf::Repeated_int::SwapElements](#googleprotobufrepeated_intswapelements)
  - [google::protobuf::Repeated_int::append](#googleprotobufrepeated_intappend)
  - [google::protobuf::Repeated_int::clear](#googleprotobufrepeated_intclear)
  - [google::protobuf::Repeated_int::empty](#googleprotobufrepeated_intempty)
  - [google::protobuf::Repeated_int::extend](#googleprotobufrepeated_intextend)
  - [google::protobuf::Repeated_int::get_Item](#googleprotobufrepeated_intget_item)
  - [google::protobuf::Repeated_int::get__NewEnum](#googleprotobufrepeated_intget__newenum)
  - [google::protobuf::Repeated_int::insert](#googleprotobufrepeated_intinsert)
  - [google::protobuf::Repeated_int::pop](#googleprotobufrepeated_intpop)
  - [google::protobuf::Repeated_int::reverse](#googleprotobufrepeated_intreverse)
  - [google::protobuf::Repeated_int::set](#googleprotobufrepeated_intset)
  - [google::protobuf::Repeated_int::size](#googleprotobufrepeated_intsize)
  - [google::protobuf::Repeated_int::slice](#googleprotobufrepeated_intslice)
  - [google::protobuf::Repeated_int::sort](#googleprotobufrepeated_intsort)
  - [google::protobuf::Repeated_int::sort_variant](#googleprotobufrepeated_intsort_variant)
  - [google::protobuf::Repeated_int::splice](#googleprotobufrepeated_intsplice)
- [mediapipe::CalculatorGraphConfig](#mediapipecalculatorgraphconfig)
  - [mediapipe::CalculatorGraphConfig::get_create](#mediapipecalculatorgraphconfigget_create)
  - [mediapipe::CalculatorGraphConfig::str](#mediapipecalculatorgraphconfigstr)
- [google::protobuf::Repeated_mediapipe_CalculatorGraphConfig_Node](#googleprotobufrepeated_mediapipe_calculatorgraphconfig_node)
  - [google::protobuf::Repeated_mediapipe_CalculatorGraphConfig_Node::create](#googleprotobufrepeated_mediapipe_calculatorgraphconfig_nodecreate)
  - [google::protobuf::Repeated_mediapipe_CalculatorGraphConfig_Node::CopyFrom](#googleprotobufrepeated_mediapipe_calculatorgraphconfig_nodecopyfrom)
  - [google::protobuf::Repeated_mediapipe_CalculatorGraphConfig_Node::MergeFrom](#googleprotobufrepeated_mediapipe_calculatorgraphconfig_nodemergefrom)
  - [google::protobuf::Repeated_mediapipe_CalculatorGraphConfig_Node::Swap](#googleprotobufrepeated_mediapipe_calculatorgraphconfig_nodeswap)
  - [google::protobuf::Repeated_mediapipe_CalculatorGraphConfig_Node::SwapElements](#googleprotobufrepeated_mediapipe_calculatorgraphconfig_nodeswapelements)
  - [google::protobuf::Repeated_mediapipe_CalculatorGraphConfig_Node::add](#googleprotobufrepeated_mediapipe_calculatorgraphconfig_nodeadd)
  - [google::protobuf::Repeated_mediapipe_CalculatorGraphConfig_Node::clear](#googleprotobufrepeated_mediapipe_calculatorgraphconfig_nodeclear)
  - [google::protobuf::Repeated_mediapipe_CalculatorGraphConfig_Node::empty](#googleprotobufrepeated_mediapipe_calculatorgraphconfig_nodeempty)
  - [google::protobuf::Repeated_mediapipe_CalculatorGraphConfig_Node::extend](#googleprotobufrepeated_mediapipe_calculatorgraphconfig_nodeextend)
  - [google::protobuf::Repeated_mediapipe_CalculatorGraphConfig_Node::get_Item](#googleprotobufrepeated_mediapipe_calculatorgraphconfig_nodeget_item)
  - [google::protobuf::Repeated_mediapipe_CalculatorGraphConfig_Node::get__NewEnum](#googleprotobufrepeated_mediapipe_calculatorgraphconfig_nodeget__newenum)
  - [google::protobuf::Repeated_mediapipe_CalculatorGraphConfig_Node::insert](#googleprotobufrepeated_mediapipe_calculatorgraphconfig_nodeinsert)
  - [google::protobuf::Repeated_mediapipe_CalculatorGraphConfig_Node::pop](#googleprotobufrepeated_mediapipe_calculatorgraphconfig_nodepop)
  - [google::protobuf::Repeated_mediapipe_CalculatorGraphConfig_Node::reverse](#googleprotobufrepeated_mediapipe_calculatorgraphconfig_nodereverse)
  - [google::protobuf::Repeated_mediapipe_CalculatorGraphConfig_Node::size](#googleprotobufrepeated_mediapipe_calculatorgraphconfig_nodesize)
  - [google::protobuf::Repeated_mediapipe_CalculatorGraphConfig_Node::slice](#googleprotobufrepeated_mediapipe_calculatorgraphconfig_nodeslice)
  - [google::protobuf::Repeated_mediapipe_CalculatorGraphConfig_Node::sort](#googleprotobufrepeated_mediapipe_calculatorgraphconfig_nodesort)
  - [google::protobuf::Repeated_mediapipe_CalculatorGraphConfig_Node::sort_variant](#googleprotobufrepeated_mediapipe_calculatorgraphconfig_nodesort_variant)
  - [google::protobuf::Repeated_mediapipe_CalculatorGraphConfig_Node::splice](#googleprotobufrepeated_mediapipe_calculatorgraphconfig_nodesplice)
- [google::protobuf::Repeated_mediapipe_PacketGeneratorConfig](#googleprotobufrepeated_mediapipe_packetgeneratorconfig)
  - [google::protobuf::Repeated_mediapipe_PacketGeneratorConfig::create](#googleprotobufrepeated_mediapipe_packetgeneratorconfigcreate)
  - [google::protobuf::Repeated_mediapipe_PacketGeneratorConfig::CopyFrom](#googleprotobufrepeated_mediapipe_packetgeneratorconfigcopyfrom)
  - [google::protobuf::Repeated_mediapipe_PacketGeneratorConfig::MergeFrom](#googleprotobufrepeated_mediapipe_packetgeneratorconfigmergefrom)
  - [google::protobuf::Repeated_mediapipe_PacketGeneratorConfig::Swap](#googleprotobufrepeated_mediapipe_packetgeneratorconfigswap)
  - [google::protobuf::Repeated_mediapipe_PacketGeneratorConfig::SwapElements](#googleprotobufrepeated_mediapipe_packetgeneratorconfigswapelements)
  - [google::protobuf::Repeated_mediapipe_PacketGeneratorConfig::add](#googleprotobufrepeated_mediapipe_packetgeneratorconfigadd)
  - [google::protobuf::Repeated_mediapipe_PacketGeneratorConfig::clear](#googleprotobufrepeated_mediapipe_packetgeneratorconfigclear)
  - [google::protobuf::Repeated_mediapipe_PacketGeneratorConfig::empty](#googleprotobufrepeated_mediapipe_packetgeneratorconfigempty)
  - [google::protobuf::Repeated_mediapipe_PacketGeneratorConfig::extend](#googleprotobufrepeated_mediapipe_packetgeneratorconfigextend)
  - [google::protobuf::Repeated_mediapipe_PacketGeneratorConfig::get_Item](#googleprotobufrepeated_mediapipe_packetgeneratorconfigget_item)
  - [google::protobuf::Repeated_mediapipe_PacketGeneratorConfig::get__NewEnum](#googleprotobufrepeated_mediapipe_packetgeneratorconfigget__newenum)
  - [google::protobuf::Repeated_mediapipe_PacketGeneratorConfig::insert](#googleprotobufrepeated_mediapipe_packetgeneratorconfiginsert)
  - [google::protobuf::Repeated_mediapipe_PacketGeneratorConfig::pop](#googleprotobufrepeated_mediapipe_packetgeneratorconfigpop)
  - [google::protobuf::Repeated_mediapipe_PacketGeneratorConfig::reverse](#googleprotobufrepeated_mediapipe_packetgeneratorconfigreverse)
  - [google::protobuf::Repeated_mediapipe_PacketGeneratorConfig::size](#googleprotobufrepeated_mediapipe_packetgeneratorconfigsize)
  - [google::protobuf::Repeated_mediapipe_PacketGeneratorConfig::slice](#googleprotobufrepeated_mediapipe_packetgeneratorconfigslice)
  - [google::protobuf::Repeated_mediapipe_PacketGeneratorConfig::sort](#googleprotobufrepeated_mediapipe_packetgeneratorconfigsort)
  - [google::protobuf::Repeated_mediapipe_PacketGeneratorConfig::sort_variant](#googleprotobufrepeated_mediapipe_packetgeneratorconfigsort_variant)
  - [google::protobuf::Repeated_mediapipe_PacketGeneratorConfig::splice](#googleprotobufrepeated_mediapipe_packetgeneratorconfigsplice)
- [google::protobuf::Repeated_mediapipe_StatusHandlerConfig](#googleprotobufrepeated_mediapipe_statushandlerconfig)
  - [google::protobuf::Repeated_mediapipe_StatusHandlerConfig::create](#googleprotobufrepeated_mediapipe_statushandlerconfigcreate)
  - [google::protobuf::Repeated_mediapipe_StatusHandlerConfig::CopyFrom](#googleprotobufrepeated_mediapipe_statushandlerconfigcopyfrom)
  - [google::protobuf::Repeated_mediapipe_StatusHandlerConfig::MergeFrom](#googleprotobufrepeated_mediapipe_statushandlerconfigmergefrom)
  - [google::protobuf::Repeated_mediapipe_StatusHandlerConfig::Swap](#googleprotobufrepeated_mediapipe_statushandlerconfigswap)
  - [google::protobuf::Repeated_mediapipe_StatusHandlerConfig::SwapElements](#googleprotobufrepeated_mediapipe_statushandlerconfigswapelements)
  - [google::protobuf::Repeated_mediapipe_StatusHandlerConfig::add](#googleprotobufrepeated_mediapipe_statushandlerconfigadd)
  - [google::protobuf::Repeated_mediapipe_StatusHandlerConfig::clear](#googleprotobufrepeated_mediapipe_statushandlerconfigclear)
  - [google::protobuf::Repeated_mediapipe_StatusHandlerConfig::empty](#googleprotobufrepeated_mediapipe_statushandlerconfigempty)
  - [google::protobuf::Repeated_mediapipe_StatusHandlerConfig::extend](#googleprotobufrepeated_mediapipe_statushandlerconfigextend)
  - [google::protobuf::Repeated_mediapipe_StatusHandlerConfig::get_Item](#googleprotobufrepeated_mediapipe_statushandlerconfigget_item)
  - [google::protobuf::Repeated_mediapipe_StatusHandlerConfig::get__NewEnum](#googleprotobufrepeated_mediapipe_statushandlerconfigget__newenum)
  - [google::protobuf::Repeated_mediapipe_StatusHandlerConfig::insert](#googleprotobufrepeated_mediapipe_statushandlerconfiginsert)
  - [google::protobuf::Repeated_mediapipe_StatusHandlerConfig::pop](#googleprotobufrepeated_mediapipe_statushandlerconfigpop)
  - [google::protobuf::Repeated_mediapipe_StatusHandlerConfig::reverse](#googleprotobufrepeated_mediapipe_statushandlerconfigreverse)
  - [google::protobuf::Repeated_mediapipe_StatusHandlerConfig::size](#googleprotobufrepeated_mediapipe_statushandlerconfigsize)
  - [google::protobuf::Repeated_mediapipe_StatusHandlerConfig::slice](#googleprotobufrepeated_mediapipe_statushandlerconfigslice)
  - [google::protobuf::Repeated_mediapipe_StatusHandlerConfig::sort](#googleprotobufrepeated_mediapipe_statushandlerconfigsort)
  - [google::protobuf::Repeated_mediapipe_StatusHandlerConfig::sort_variant](#googleprotobufrepeated_mediapipe_statushandlerconfigsort_variant)
  - [google::protobuf::Repeated_mediapipe_StatusHandlerConfig::splice](#googleprotobufrepeated_mediapipe_statushandlerconfigsplice)
- [google::protobuf::Repeated_mediapipe_ExecutorConfig](#googleprotobufrepeated_mediapipe_executorconfig)
  - [google::protobuf::Repeated_mediapipe_ExecutorConfig::create](#googleprotobufrepeated_mediapipe_executorconfigcreate)
  - [google::protobuf::Repeated_mediapipe_ExecutorConfig::CopyFrom](#googleprotobufrepeated_mediapipe_executorconfigcopyfrom)
  - [google::protobuf::Repeated_mediapipe_ExecutorConfig::MergeFrom](#googleprotobufrepeated_mediapipe_executorconfigmergefrom)
  - [google::protobuf::Repeated_mediapipe_ExecutorConfig::Swap](#googleprotobufrepeated_mediapipe_executorconfigswap)
  - [google::protobuf::Repeated_mediapipe_ExecutorConfig::SwapElements](#googleprotobufrepeated_mediapipe_executorconfigswapelements)
  - [google::protobuf::Repeated_mediapipe_ExecutorConfig::add](#googleprotobufrepeated_mediapipe_executorconfigadd)
  - [google::protobuf::Repeated_mediapipe_ExecutorConfig::clear](#googleprotobufrepeated_mediapipe_executorconfigclear)
  - [google::protobuf::Repeated_mediapipe_ExecutorConfig::empty](#googleprotobufrepeated_mediapipe_executorconfigempty)
  - [google::protobuf::Repeated_mediapipe_ExecutorConfig::extend](#googleprotobufrepeated_mediapipe_executorconfigextend)
  - [google::protobuf::Repeated_mediapipe_ExecutorConfig::get_Item](#googleprotobufrepeated_mediapipe_executorconfigget_item)
  - [google::protobuf::Repeated_mediapipe_ExecutorConfig::get__NewEnum](#googleprotobufrepeated_mediapipe_executorconfigget__newenum)
  - [google::protobuf::Repeated_mediapipe_ExecutorConfig::insert](#googleprotobufrepeated_mediapipe_executorconfiginsert)
  - [google::protobuf::Repeated_mediapipe_ExecutorConfig::pop](#googleprotobufrepeated_mediapipe_executorconfigpop)
  - [google::protobuf::Repeated_mediapipe_ExecutorConfig::reverse](#googleprotobufrepeated_mediapipe_executorconfigreverse)
  - [google::protobuf::Repeated_mediapipe_ExecutorConfig::size](#googleprotobufrepeated_mediapipe_executorconfigsize)
  - [google::protobuf::Repeated_mediapipe_ExecutorConfig::slice](#googleprotobufrepeated_mediapipe_executorconfigslice)
  - [google::protobuf::Repeated_mediapipe_ExecutorConfig::sort](#googleprotobufrepeated_mediapipe_executorconfigsort)
  - [google::protobuf::Repeated_mediapipe_ExecutorConfig::sort_variant](#googleprotobufrepeated_mediapipe_executorconfigsort_variant)
  - [google::protobuf::Repeated_mediapipe_ExecutorConfig::splice](#googleprotobufrepeated_mediapipe_executorconfigsplice)
- [google::protobuf::Repeated_google_protobuf_Any](#googleprotobufrepeated_google_protobuf_any)
  - [google::protobuf::Repeated_google_protobuf_Any::create](#googleprotobufrepeated_google_protobuf_anycreate)
  - [google::protobuf::Repeated_google_protobuf_Any::CopyFrom](#googleprotobufrepeated_google_protobuf_anycopyfrom)
  - [google::protobuf::Repeated_google_protobuf_Any::MergeFrom](#googleprotobufrepeated_google_protobuf_anymergefrom)
  - [google::protobuf::Repeated_google_protobuf_Any::Swap](#googleprotobufrepeated_google_protobuf_anyswap)
  - [google::protobuf::Repeated_google_protobuf_Any::SwapElements](#googleprotobufrepeated_google_protobuf_anyswapelements)
  - [google::protobuf::Repeated_google_protobuf_Any::add](#googleprotobufrepeated_google_protobuf_anyadd)
  - [google::protobuf::Repeated_google_protobuf_Any::clear](#googleprotobufrepeated_google_protobuf_anyclear)
  - [google::protobuf::Repeated_google_protobuf_Any::empty](#googleprotobufrepeated_google_protobuf_anyempty)
  - [google::protobuf::Repeated_google_protobuf_Any::extend](#googleprotobufrepeated_google_protobuf_anyextend)
  - [google::protobuf::Repeated_google_protobuf_Any::get_Item](#googleprotobufrepeated_google_protobuf_anyget_item)
  - [google::protobuf::Repeated_google_protobuf_Any::get__NewEnum](#googleprotobufrepeated_google_protobuf_anyget__newenum)
  - [google::protobuf::Repeated_google_protobuf_Any::insert](#googleprotobufrepeated_google_protobuf_anyinsert)
  - [google::protobuf::Repeated_google_protobuf_Any::pop](#googleprotobufrepeated_google_protobuf_anypop)
  - [google::protobuf::Repeated_google_protobuf_Any::reverse](#googleprotobufrepeated_google_protobuf_anyreverse)
  - [google::protobuf::Repeated_google_protobuf_Any::size](#googleprotobufrepeated_google_protobuf_anysize)
  - [google::protobuf::Repeated_google_protobuf_Any::slice](#googleprotobufrepeated_google_protobuf_anyslice)
  - [google::protobuf::Repeated_google_protobuf_Any::sort](#googleprotobufrepeated_google_protobuf_anysort)
  - [google::protobuf::Repeated_google_protobuf_Any::sort_variant](#googleprotobufrepeated_google_protobuf_anysort_variant)
  - [google::protobuf::Repeated_google_protobuf_Any::splice](#googleprotobufrepeated_google_protobuf_anysplice)
- [mediapipe::CalculatorGraphConfig::Node](#mediapipecalculatorgraphconfignode)
  - [mediapipe::CalculatorGraphConfig::Node::get_create](#mediapipecalculatorgraphconfignodeget_create)
  - [mediapipe::CalculatorGraphConfig::Node::str](#mediapipecalculatorgraphconfignodestr)
- [google::protobuf::Repeated_mediapipe_InputStreamInfo](#googleprotobufrepeated_mediapipe_inputstreaminfo)
  - [google::protobuf::Repeated_mediapipe_InputStreamInfo::create](#googleprotobufrepeated_mediapipe_inputstreaminfocreate)
  - [google::protobuf::Repeated_mediapipe_InputStreamInfo::CopyFrom](#googleprotobufrepeated_mediapipe_inputstreaminfocopyfrom)
  - [google::protobuf::Repeated_mediapipe_InputStreamInfo::MergeFrom](#googleprotobufrepeated_mediapipe_inputstreaminfomergefrom)
  - [google::protobuf::Repeated_mediapipe_InputStreamInfo::Swap](#googleprotobufrepeated_mediapipe_inputstreaminfoswap)
  - [google::protobuf::Repeated_mediapipe_InputStreamInfo::SwapElements](#googleprotobufrepeated_mediapipe_inputstreaminfoswapelements)
  - [google::protobuf::Repeated_mediapipe_InputStreamInfo::add](#googleprotobufrepeated_mediapipe_inputstreaminfoadd)
  - [google::protobuf::Repeated_mediapipe_InputStreamInfo::clear](#googleprotobufrepeated_mediapipe_inputstreaminfoclear)
  - [google::protobuf::Repeated_mediapipe_InputStreamInfo::empty](#googleprotobufrepeated_mediapipe_inputstreaminfoempty)
  - [google::protobuf::Repeated_mediapipe_InputStreamInfo::extend](#googleprotobufrepeated_mediapipe_inputstreaminfoextend)
  - [google::protobuf::Repeated_mediapipe_InputStreamInfo::get_Item](#googleprotobufrepeated_mediapipe_inputstreaminfoget_item)
  - [google::protobuf::Repeated_mediapipe_InputStreamInfo::get__NewEnum](#googleprotobufrepeated_mediapipe_inputstreaminfoget__newenum)
  - [google::protobuf::Repeated_mediapipe_InputStreamInfo::insert](#googleprotobufrepeated_mediapipe_inputstreaminfoinsert)
  - [google::protobuf::Repeated_mediapipe_InputStreamInfo::pop](#googleprotobufrepeated_mediapipe_inputstreaminfopop)
  - [google::protobuf::Repeated_mediapipe_InputStreamInfo::reverse](#googleprotobufrepeated_mediapipe_inputstreaminforeverse)
  - [google::protobuf::Repeated_mediapipe_InputStreamInfo::size](#googleprotobufrepeated_mediapipe_inputstreaminfosize)
  - [google::protobuf::Repeated_mediapipe_InputStreamInfo::slice](#googleprotobufrepeated_mediapipe_inputstreaminfoslice)
  - [google::protobuf::Repeated_mediapipe_InputStreamInfo::sort](#googleprotobufrepeated_mediapipe_inputstreaminfosort)
  - [google::protobuf::Repeated_mediapipe_InputStreamInfo::sort_variant](#googleprotobufrepeated_mediapipe_inputstreaminfosort_variant)
  - [google::protobuf::Repeated_mediapipe_InputStreamInfo::splice](#googleprotobufrepeated_mediapipe_inputstreaminfosplice)
- [mediapipe::Rasterization](#mediapiperasterization)
  - [mediapipe::Rasterization::get_create](#mediapiperasterizationget_create)
  - [mediapipe::Rasterization::str](#mediapiperasterizationstr)
- [google::protobuf::Repeated_mediapipe_Rasterization_Interval](#googleprotobufrepeated_mediapipe_rasterization_interval)
  - [google::protobuf::Repeated_mediapipe_Rasterization_Interval::create](#googleprotobufrepeated_mediapipe_rasterization_intervalcreate)
  - [google::protobuf::Repeated_mediapipe_Rasterization_Interval::CopyFrom](#googleprotobufrepeated_mediapipe_rasterization_intervalcopyfrom)
  - [google::protobuf::Repeated_mediapipe_Rasterization_Interval::MergeFrom](#googleprotobufrepeated_mediapipe_rasterization_intervalmergefrom)
  - [google::protobuf::Repeated_mediapipe_Rasterization_Interval::Swap](#googleprotobufrepeated_mediapipe_rasterization_intervalswap)
  - [google::protobuf::Repeated_mediapipe_Rasterization_Interval::SwapElements](#googleprotobufrepeated_mediapipe_rasterization_intervalswapelements)
  - [google::protobuf::Repeated_mediapipe_Rasterization_Interval::add](#googleprotobufrepeated_mediapipe_rasterization_intervaladd)
  - [google::protobuf::Repeated_mediapipe_Rasterization_Interval::clear](#googleprotobufrepeated_mediapipe_rasterization_intervalclear)
  - [google::protobuf::Repeated_mediapipe_Rasterization_Interval::empty](#googleprotobufrepeated_mediapipe_rasterization_intervalempty)
  - [google::protobuf::Repeated_mediapipe_Rasterization_Interval::extend](#googleprotobufrepeated_mediapipe_rasterization_intervalextend)
  - [google::protobuf::Repeated_mediapipe_Rasterization_Interval::get_Item](#googleprotobufrepeated_mediapipe_rasterization_intervalget_item)
  - [google::protobuf::Repeated_mediapipe_Rasterization_Interval::get__NewEnum](#googleprotobufrepeated_mediapipe_rasterization_intervalget__newenum)
  - [google::protobuf::Repeated_mediapipe_Rasterization_Interval::insert](#googleprotobufrepeated_mediapipe_rasterization_intervalinsert)
  - [google::protobuf::Repeated_mediapipe_Rasterization_Interval::pop](#googleprotobufrepeated_mediapipe_rasterization_intervalpop)
  - [google::protobuf::Repeated_mediapipe_Rasterization_Interval::reverse](#googleprotobufrepeated_mediapipe_rasterization_intervalreverse)
  - [google::protobuf::Repeated_mediapipe_Rasterization_Interval::size](#googleprotobufrepeated_mediapipe_rasterization_intervalsize)
  - [google::protobuf::Repeated_mediapipe_Rasterization_Interval::slice](#googleprotobufrepeated_mediapipe_rasterization_intervalslice)
  - [google::protobuf::Repeated_mediapipe_Rasterization_Interval::sort](#googleprotobufrepeated_mediapipe_rasterization_intervalsort)
  - [google::protobuf::Repeated_mediapipe_Rasterization_Interval::sort_variant](#googleprotobufrepeated_mediapipe_rasterization_intervalsort_variant)
  - [google::protobuf::Repeated_mediapipe_Rasterization_Interval::splice](#googleprotobufrepeated_mediapipe_rasterization_intervalsplice)
- [mediapipe::Rasterization::Interval](#mediapiperasterizationinterval)
  - [mediapipe::Rasterization::Interval::get_create](#mediapiperasterizationintervalget_create)
  - [mediapipe::Rasterization::Interval::str](#mediapiperasterizationintervalstr)
- [mediapipe::LocationData](#mediapipelocationdata)
  - [mediapipe::LocationData::get_create](#mediapipelocationdataget_create)
  - [mediapipe::LocationData::str](#mediapipelocationdatastr)
- [google::protobuf::Repeated_mediapipe_LocationData_RelativeKeypoint](#googleprotobufrepeated_mediapipe_locationdata_relativekeypoint)
  - [google::protobuf::Repeated_mediapipe_LocationData_RelativeKeypoint::create](#googleprotobufrepeated_mediapipe_locationdata_relativekeypointcreate)
  - [google::protobuf::Repeated_mediapipe_LocationData_RelativeKeypoint::CopyFrom](#googleprotobufrepeated_mediapipe_locationdata_relativekeypointcopyfrom)
  - [google::protobuf::Repeated_mediapipe_LocationData_RelativeKeypoint::MergeFrom](#googleprotobufrepeated_mediapipe_locationdata_relativekeypointmergefrom)
  - [google::protobuf::Repeated_mediapipe_LocationData_RelativeKeypoint::Swap](#googleprotobufrepeated_mediapipe_locationdata_relativekeypointswap)
  - [google::protobuf::Repeated_mediapipe_LocationData_RelativeKeypoint::SwapElements](#googleprotobufrepeated_mediapipe_locationdata_relativekeypointswapelements)
  - [google::protobuf::Repeated_mediapipe_LocationData_RelativeKeypoint::add](#googleprotobufrepeated_mediapipe_locationdata_relativekeypointadd)
  - [google::protobuf::Repeated_mediapipe_LocationData_RelativeKeypoint::clear](#googleprotobufrepeated_mediapipe_locationdata_relativekeypointclear)
  - [google::protobuf::Repeated_mediapipe_LocationData_RelativeKeypoint::empty](#googleprotobufrepeated_mediapipe_locationdata_relativekeypointempty)
  - [google::protobuf::Repeated_mediapipe_LocationData_RelativeKeypoint::extend](#googleprotobufrepeated_mediapipe_locationdata_relativekeypointextend)
  - [google::protobuf::Repeated_mediapipe_LocationData_RelativeKeypoint::get_Item](#googleprotobufrepeated_mediapipe_locationdata_relativekeypointget_item)
  - [google::protobuf::Repeated_mediapipe_LocationData_RelativeKeypoint::get__NewEnum](#googleprotobufrepeated_mediapipe_locationdata_relativekeypointget__newenum)
  - [google::protobuf::Repeated_mediapipe_LocationData_RelativeKeypoint::insert](#googleprotobufrepeated_mediapipe_locationdata_relativekeypointinsert)
  - [google::protobuf::Repeated_mediapipe_LocationData_RelativeKeypoint::pop](#googleprotobufrepeated_mediapipe_locationdata_relativekeypointpop)
  - [google::protobuf::Repeated_mediapipe_LocationData_RelativeKeypoint::reverse](#googleprotobufrepeated_mediapipe_locationdata_relativekeypointreverse)
  - [google::protobuf::Repeated_mediapipe_LocationData_RelativeKeypoint::size](#googleprotobufrepeated_mediapipe_locationdata_relativekeypointsize)
  - [google::protobuf::Repeated_mediapipe_LocationData_RelativeKeypoint::slice](#googleprotobufrepeated_mediapipe_locationdata_relativekeypointslice)
  - [google::protobuf::Repeated_mediapipe_LocationData_RelativeKeypoint::sort](#googleprotobufrepeated_mediapipe_locationdata_relativekeypointsort)
  - [google::protobuf::Repeated_mediapipe_LocationData_RelativeKeypoint::sort_variant](#googleprotobufrepeated_mediapipe_locationdata_relativekeypointsort_variant)
  - [google::protobuf::Repeated_mediapipe_LocationData_RelativeKeypoint::splice](#googleprotobufrepeated_mediapipe_locationdata_relativekeypointsplice)
- [mediapipe::LocationData::BoundingBox](#mediapipelocationdataboundingbox)
  - [mediapipe::LocationData::BoundingBox::get_create](#mediapipelocationdataboundingboxget_create)
  - [mediapipe::LocationData::BoundingBox::str](#mediapipelocationdataboundingboxstr)
- [mediapipe::LocationData::RelativeBoundingBox](#mediapipelocationdatarelativeboundingbox)
  - [mediapipe::LocationData::RelativeBoundingBox::get_create](#mediapipelocationdatarelativeboundingboxget_create)
  - [mediapipe::LocationData::RelativeBoundingBox::str](#mediapipelocationdatarelativeboundingboxstr)
- [mediapipe::LocationData::BinaryMask](#mediapipelocationdatabinarymask)
  - [mediapipe::LocationData::BinaryMask::get_create](#mediapipelocationdatabinarymaskget_create)
  - [mediapipe::LocationData::BinaryMask::str](#mediapipelocationdatabinarymaskstr)
- [mediapipe::LocationData::RelativeKeypoint](#mediapipelocationdatarelativekeypoint)
  - [mediapipe::LocationData::RelativeKeypoint::get_create](#mediapipelocationdatarelativekeypointget_create)
  - [mediapipe::LocationData::RelativeKeypoint::str](#mediapipelocationdatarelativekeypointstr)
- [mediapipe::Detection](#mediapipedetection)
  - [mediapipe::Detection::get_create](#mediapipedetectionget_create)
  - [mediapipe::Detection::str](#mediapipedetectionstr)
- [google::protobuf::Repeated_float](#googleprotobufrepeated_float)
  - [google::protobuf::Repeated_float::create](#googleprotobufrepeated_floatcreate)
  - [google::protobuf::Repeated_float::CopyFrom](#googleprotobufrepeated_floatcopyfrom)
  - [google::protobuf::Repeated_float::MergeFrom](#googleprotobufrepeated_floatmergefrom)
  - [google::protobuf::Repeated_float::Swap](#googleprotobufrepeated_floatswap)
  - [google::protobuf::Repeated_float::SwapElements](#googleprotobufrepeated_floatswapelements)
  - [google::protobuf::Repeated_float::append](#googleprotobufrepeated_floatappend)
  - [google::protobuf::Repeated_float::clear](#googleprotobufrepeated_floatclear)
  - [google::protobuf::Repeated_float::empty](#googleprotobufrepeated_floatempty)
  - [google::protobuf::Repeated_float::extend](#googleprotobufrepeated_floatextend)
  - [google::protobuf::Repeated_float::get_Item](#googleprotobufrepeated_floatget_item)
  - [google::protobuf::Repeated_float::get__NewEnum](#googleprotobufrepeated_floatget__newenum)
  - [google::protobuf::Repeated_float::insert](#googleprotobufrepeated_floatinsert)
  - [google::protobuf::Repeated_float::pop](#googleprotobufrepeated_floatpop)
  - [google::protobuf::Repeated_float::reverse](#googleprotobufrepeated_floatreverse)
  - [google::protobuf::Repeated_float::set](#googleprotobufrepeated_floatset)
  - [google::protobuf::Repeated_float::size](#googleprotobufrepeated_floatsize)
  - [google::protobuf::Repeated_float::slice](#googleprotobufrepeated_floatslice)
  - [google::protobuf::Repeated_float::sort](#googleprotobufrepeated_floatsort)
  - [google::protobuf::Repeated_float::sort_variant](#googleprotobufrepeated_floatsort_variant)
  - [google::protobuf::Repeated_float::splice](#googleprotobufrepeated_floatsplice)
- [google::protobuf::Repeated_mediapipe_Detection_AssociatedDetection](#googleprotobufrepeated_mediapipe_detection_associateddetection)
  - [google::protobuf::Repeated_mediapipe_Detection_AssociatedDetection::create](#googleprotobufrepeated_mediapipe_detection_associateddetectioncreate)
  - [google::protobuf::Repeated_mediapipe_Detection_AssociatedDetection::CopyFrom](#googleprotobufrepeated_mediapipe_detection_associateddetectioncopyfrom)
  - [google::protobuf::Repeated_mediapipe_Detection_AssociatedDetection::MergeFrom](#googleprotobufrepeated_mediapipe_detection_associateddetectionmergefrom)
  - [google::protobuf::Repeated_mediapipe_Detection_AssociatedDetection::Swap](#googleprotobufrepeated_mediapipe_detection_associateddetectionswap)
  - [google::protobuf::Repeated_mediapipe_Detection_AssociatedDetection::SwapElements](#googleprotobufrepeated_mediapipe_detection_associateddetectionswapelements)
  - [google::protobuf::Repeated_mediapipe_Detection_AssociatedDetection::add](#googleprotobufrepeated_mediapipe_detection_associateddetectionadd)
  - [google::protobuf::Repeated_mediapipe_Detection_AssociatedDetection::clear](#googleprotobufrepeated_mediapipe_detection_associateddetectionclear)
  - [google::protobuf::Repeated_mediapipe_Detection_AssociatedDetection::empty](#googleprotobufrepeated_mediapipe_detection_associateddetectionempty)
  - [google::protobuf::Repeated_mediapipe_Detection_AssociatedDetection::extend](#googleprotobufrepeated_mediapipe_detection_associateddetectionextend)
  - [google::protobuf::Repeated_mediapipe_Detection_AssociatedDetection::get_Item](#googleprotobufrepeated_mediapipe_detection_associateddetectionget_item)
  - [google::protobuf::Repeated_mediapipe_Detection_AssociatedDetection::get__NewEnum](#googleprotobufrepeated_mediapipe_detection_associateddetectionget__newenum)
  - [google::protobuf::Repeated_mediapipe_Detection_AssociatedDetection::insert](#googleprotobufrepeated_mediapipe_detection_associateddetectioninsert)
  - [google::protobuf::Repeated_mediapipe_Detection_AssociatedDetection::pop](#googleprotobufrepeated_mediapipe_detection_associateddetectionpop)
  - [google::protobuf::Repeated_mediapipe_Detection_AssociatedDetection::reverse](#googleprotobufrepeated_mediapipe_detection_associateddetectionreverse)
  - [google::protobuf::Repeated_mediapipe_Detection_AssociatedDetection::size](#googleprotobufrepeated_mediapipe_detection_associateddetectionsize)
  - [google::protobuf::Repeated_mediapipe_Detection_AssociatedDetection::slice](#googleprotobufrepeated_mediapipe_detection_associateddetectionslice)
  - [google::protobuf::Repeated_mediapipe_Detection_AssociatedDetection::sort](#googleprotobufrepeated_mediapipe_detection_associateddetectionsort)
  - [google::protobuf::Repeated_mediapipe_Detection_AssociatedDetection::sort_variant](#googleprotobufrepeated_mediapipe_detection_associateddetectionsort_variant)
  - [google::protobuf::Repeated_mediapipe_Detection_AssociatedDetection::splice](#googleprotobufrepeated_mediapipe_detection_associateddetectionsplice)
- [mediapipe::Detection::AssociatedDetection](#mediapipedetectionassociateddetection)
  - [mediapipe::Detection::AssociatedDetection::get_create](#mediapipedetectionassociateddetectionget_create)
  - [mediapipe::Detection::AssociatedDetection::str](#mediapipedetectionassociateddetectionstr)
- [mediapipe::DetectionList](#mediapipedetectionlist)
  - [mediapipe::DetectionList::get_create](#mediapipedetectionlistget_create)
  - [mediapipe::DetectionList::str](#mediapipedetectionliststr)
- [google::protobuf::Repeated_mediapipe_Detection](#googleprotobufrepeated_mediapipe_detection)
  - [google::protobuf::Repeated_mediapipe_Detection::create](#googleprotobufrepeated_mediapipe_detectioncreate)
  - [google::protobuf::Repeated_mediapipe_Detection::CopyFrom](#googleprotobufrepeated_mediapipe_detectioncopyfrom)
  - [google::protobuf::Repeated_mediapipe_Detection::MergeFrom](#googleprotobufrepeated_mediapipe_detectionmergefrom)
  - [google::protobuf::Repeated_mediapipe_Detection::Swap](#googleprotobufrepeated_mediapipe_detectionswap)
  - [google::protobuf::Repeated_mediapipe_Detection::SwapElements](#googleprotobufrepeated_mediapipe_detectionswapelements)
  - [google::protobuf::Repeated_mediapipe_Detection::add](#googleprotobufrepeated_mediapipe_detectionadd)
  - [google::protobuf::Repeated_mediapipe_Detection::clear](#googleprotobufrepeated_mediapipe_detectionclear)
  - [google::protobuf::Repeated_mediapipe_Detection::empty](#googleprotobufrepeated_mediapipe_detectionempty)
  - [google::protobuf::Repeated_mediapipe_Detection::extend](#googleprotobufrepeated_mediapipe_detectionextend)
  - [google::protobuf::Repeated_mediapipe_Detection::get_Item](#googleprotobufrepeated_mediapipe_detectionget_item)
  - [google::protobuf::Repeated_mediapipe_Detection::get__NewEnum](#googleprotobufrepeated_mediapipe_detectionget__newenum)
  - [google::protobuf::Repeated_mediapipe_Detection::insert](#googleprotobufrepeated_mediapipe_detectioninsert)
  - [google::protobuf::Repeated_mediapipe_Detection::pop](#googleprotobufrepeated_mediapipe_detectionpop)
  - [google::protobuf::Repeated_mediapipe_Detection::reverse](#googleprotobufrepeated_mediapipe_detectionreverse)
  - [google::protobuf::Repeated_mediapipe_Detection::size](#googleprotobufrepeated_mediapipe_detectionsize)
  - [google::protobuf::Repeated_mediapipe_Detection::slice](#googleprotobufrepeated_mediapipe_detectionslice)
  - [google::protobuf::Repeated_mediapipe_Detection::sort](#googleprotobufrepeated_mediapipe_detectionsort)
  - [google::protobuf::Repeated_mediapipe_Detection::sort_variant](#googleprotobufrepeated_mediapipe_detectionsort_variant)
  - [google::protobuf::Repeated_mediapipe_Detection::splice](#googleprotobufrepeated_mediapipe_detectionsplice)
- [mediapipe::ImageFormat](#mediapipeimageformat)
  - [mediapipe::ImageFormat::get_create](#mediapipeimageformatget_create)
  - [mediapipe::ImageFormat::str](#mediapipeimageformatstr)
- [mediapipe::Classification](#mediapipeclassification)
  - [mediapipe::Classification::get_create](#mediapipeclassificationget_create)
  - [mediapipe::Classification::str](#mediapipeclassificationstr)
- [mediapipe::ClassificationList](#mediapipeclassificationlist)
  - [mediapipe::ClassificationList::get_create](#mediapipeclassificationlistget_create)
  - [mediapipe::ClassificationList::str](#mediapipeclassificationliststr)
- [google::protobuf::Repeated_mediapipe_Classification](#googleprotobufrepeated_mediapipe_classification)
  - [google::protobuf::Repeated_mediapipe_Classification::create](#googleprotobufrepeated_mediapipe_classificationcreate)
  - [google::protobuf::Repeated_mediapipe_Classification::CopyFrom](#googleprotobufrepeated_mediapipe_classificationcopyfrom)
  - [google::protobuf::Repeated_mediapipe_Classification::MergeFrom](#googleprotobufrepeated_mediapipe_classificationmergefrom)
  - [google::protobuf::Repeated_mediapipe_Classification::Swap](#googleprotobufrepeated_mediapipe_classificationswap)
  - [google::protobuf::Repeated_mediapipe_Classification::SwapElements](#googleprotobufrepeated_mediapipe_classificationswapelements)
  - [google::protobuf::Repeated_mediapipe_Classification::add](#googleprotobufrepeated_mediapipe_classificationadd)
  - [google::protobuf::Repeated_mediapipe_Classification::clear](#googleprotobufrepeated_mediapipe_classificationclear)
  - [google::protobuf::Repeated_mediapipe_Classification::empty](#googleprotobufrepeated_mediapipe_classificationempty)
  - [google::protobuf::Repeated_mediapipe_Classification::extend](#googleprotobufrepeated_mediapipe_classificationextend)
  - [google::protobuf::Repeated_mediapipe_Classification::get_Item](#googleprotobufrepeated_mediapipe_classificationget_item)
  - [google::protobuf::Repeated_mediapipe_Classification::get__NewEnum](#googleprotobufrepeated_mediapipe_classificationget__newenum)
  - [google::protobuf::Repeated_mediapipe_Classification::insert](#googleprotobufrepeated_mediapipe_classificationinsert)
  - [google::protobuf::Repeated_mediapipe_Classification::pop](#googleprotobufrepeated_mediapipe_classificationpop)
  - [google::protobuf::Repeated_mediapipe_Classification::reverse](#googleprotobufrepeated_mediapipe_classificationreverse)
  - [google::protobuf::Repeated_mediapipe_Classification::size](#googleprotobufrepeated_mediapipe_classificationsize)
  - [google::protobuf::Repeated_mediapipe_Classification::slice](#googleprotobufrepeated_mediapipe_classificationslice)
  - [google::protobuf::Repeated_mediapipe_Classification::sort](#googleprotobufrepeated_mediapipe_classificationsort)
  - [google::protobuf::Repeated_mediapipe_Classification::sort_variant](#googleprotobufrepeated_mediapipe_classificationsort_variant)
  - [google::protobuf::Repeated_mediapipe_Classification::splice](#googleprotobufrepeated_mediapipe_classificationsplice)
- [mediapipe::ClassificationListCollection](#mediapipeclassificationlistcollection)
  - [mediapipe::ClassificationListCollection::get_create](#mediapipeclassificationlistcollectionget_create)
  - [mediapipe::ClassificationListCollection::str](#mediapipeclassificationlistcollectionstr)
- [google::protobuf::Repeated_mediapipe_ClassificationList](#googleprotobufrepeated_mediapipe_classificationlist)
  - [google::protobuf::Repeated_mediapipe_ClassificationList::create](#googleprotobufrepeated_mediapipe_classificationlistcreate)
  - [google::protobuf::Repeated_mediapipe_ClassificationList::CopyFrom](#googleprotobufrepeated_mediapipe_classificationlistcopyfrom)
  - [google::protobuf::Repeated_mediapipe_ClassificationList::MergeFrom](#googleprotobufrepeated_mediapipe_classificationlistmergefrom)
  - [google::protobuf::Repeated_mediapipe_ClassificationList::Swap](#googleprotobufrepeated_mediapipe_classificationlistswap)
  - [google::protobuf::Repeated_mediapipe_ClassificationList::SwapElements](#googleprotobufrepeated_mediapipe_classificationlistswapelements)
  - [google::protobuf::Repeated_mediapipe_ClassificationList::add](#googleprotobufrepeated_mediapipe_classificationlistadd)
  - [google::protobuf::Repeated_mediapipe_ClassificationList::clear](#googleprotobufrepeated_mediapipe_classificationlistclear)
  - [google::protobuf::Repeated_mediapipe_ClassificationList::empty](#googleprotobufrepeated_mediapipe_classificationlistempty)
  - [google::protobuf::Repeated_mediapipe_ClassificationList::extend](#googleprotobufrepeated_mediapipe_classificationlistextend)
  - [google::protobuf::Repeated_mediapipe_ClassificationList::get_Item](#googleprotobufrepeated_mediapipe_classificationlistget_item)
  - [google::protobuf::Repeated_mediapipe_ClassificationList::get__NewEnum](#googleprotobufrepeated_mediapipe_classificationlistget__newenum)
  - [google::protobuf::Repeated_mediapipe_ClassificationList::insert](#googleprotobufrepeated_mediapipe_classificationlistinsert)
  - [google::protobuf::Repeated_mediapipe_ClassificationList::pop](#googleprotobufrepeated_mediapipe_classificationlistpop)
  - [google::protobuf::Repeated_mediapipe_ClassificationList::reverse](#googleprotobufrepeated_mediapipe_classificationlistreverse)
  - [google::protobuf::Repeated_mediapipe_ClassificationList::size](#googleprotobufrepeated_mediapipe_classificationlistsize)
  - [google::protobuf::Repeated_mediapipe_ClassificationList::slice](#googleprotobufrepeated_mediapipe_classificationlistslice)
  - [google::protobuf::Repeated_mediapipe_ClassificationList::sort](#googleprotobufrepeated_mediapipe_classificationlistsort)
  - [google::protobuf::Repeated_mediapipe_ClassificationList::sort_variant](#googleprotobufrepeated_mediapipe_classificationlistsort_variant)
  - [google::protobuf::Repeated_mediapipe_ClassificationList::splice](#googleprotobufrepeated_mediapipe_classificationlistsplice)
- [mediapipe::Landmark](#mediapipelandmark)
  - [mediapipe::Landmark::get_create](#mediapipelandmarkget_create)
  - [mediapipe::Landmark::str](#mediapipelandmarkstr)
- [mediapipe::LandmarkList](#mediapipelandmarklist)
  - [mediapipe::LandmarkList::get_create](#mediapipelandmarklistget_create)
  - [mediapipe::LandmarkList::str](#mediapipelandmarkliststr)
- [google::protobuf::Repeated_mediapipe_Landmark](#googleprotobufrepeated_mediapipe_landmark)
  - [google::protobuf::Repeated_mediapipe_Landmark::create](#googleprotobufrepeated_mediapipe_landmarkcreate)
  - [google::protobuf::Repeated_mediapipe_Landmark::CopyFrom](#googleprotobufrepeated_mediapipe_landmarkcopyfrom)
  - [google::protobuf::Repeated_mediapipe_Landmark::MergeFrom](#googleprotobufrepeated_mediapipe_landmarkmergefrom)
  - [google::protobuf::Repeated_mediapipe_Landmark::Swap](#googleprotobufrepeated_mediapipe_landmarkswap)
  - [google::protobuf::Repeated_mediapipe_Landmark::SwapElements](#googleprotobufrepeated_mediapipe_landmarkswapelements)
  - [google::protobuf::Repeated_mediapipe_Landmark::add](#googleprotobufrepeated_mediapipe_landmarkadd)
  - [google::protobuf::Repeated_mediapipe_Landmark::clear](#googleprotobufrepeated_mediapipe_landmarkclear)
  - [google::protobuf::Repeated_mediapipe_Landmark::empty](#googleprotobufrepeated_mediapipe_landmarkempty)
  - [google::protobuf::Repeated_mediapipe_Landmark::extend](#googleprotobufrepeated_mediapipe_landmarkextend)
  - [google::protobuf::Repeated_mediapipe_Landmark::get_Item](#googleprotobufrepeated_mediapipe_landmarkget_item)
  - [google::protobuf::Repeated_mediapipe_Landmark::get__NewEnum](#googleprotobufrepeated_mediapipe_landmarkget__newenum)
  - [google::protobuf::Repeated_mediapipe_Landmark::insert](#googleprotobufrepeated_mediapipe_landmarkinsert)
  - [google::protobuf::Repeated_mediapipe_Landmark::pop](#googleprotobufrepeated_mediapipe_landmarkpop)
  - [google::protobuf::Repeated_mediapipe_Landmark::reverse](#googleprotobufrepeated_mediapipe_landmarkreverse)
  - [google::protobuf::Repeated_mediapipe_Landmark::size](#googleprotobufrepeated_mediapipe_landmarksize)
  - [google::protobuf::Repeated_mediapipe_Landmark::slice](#googleprotobufrepeated_mediapipe_landmarkslice)
  - [google::protobuf::Repeated_mediapipe_Landmark::sort](#googleprotobufrepeated_mediapipe_landmarksort)
  - [google::protobuf::Repeated_mediapipe_Landmark::sort_variant](#googleprotobufrepeated_mediapipe_landmarksort_variant)
  - [google::protobuf::Repeated_mediapipe_Landmark::splice](#googleprotobufrepeated_mediapipe_landmarksplice)
- [mediapipe::LandmarkListCollection](#mediapipelandmarklistcollection)
  - [mediapipe::LandmarkListCollection::get_create](#mediapipelandmarklistcollectionget_create)
  - [mediapipe::LandmarkListCollection::str](#mediapipelandmarklistcollectionstr)
- [google::protobuf::Repeated_mediapipe_LandmarkList](#googleprotobufrepeated_mediapipe_landmarklist)
  - [google::protobuf::Repeated_mediapipe_LandmarkList::create](#googleprotobufrepeated_mediapipe_landmarklistcreate)
  - [google::protobuf::Repeated_mediapipe_LandmarkList::CopyFrom](#googleprotobufrepeated_mediapipe_landmarklistcopyfrom)
  - [google::protobuf::Repeated_mediapipe_LandmarkList::MergeFrom](#googleprotobufrepeated_mediapipe_landmarklistmergefrom)
  - [google::protobuf::Repeated_mediapipe_LandmarkList::Swap](#googleprotobufrepeated_mediapipe_landmarklistswap)
  - [google::protobuf::Repeated_mediapipe_LandmarkList::SwapElements](#googleprotobufrepeated_mediapipe_landmarklistswapelements)
  - [google::protobuf::Repeated_mediapipe_LandmarkList::add](#googleprotobufrepeated_mediapipe_landmarklistadd)
  - [google::protobuf::Repeated_mediapipe_LandmarkList::clear](#googleprotobufrepeated_mediapipe_landmarklistclear)
  - [google::protobuf::Repeated_mediapipe_LandmarkList::empty](#googleprotobufrepeated_mediapipe_landmarklistempty)
  - [google::protobuf::Repeated_mediapipe_LandmarkList::extend](#googleprotobufrepeated_mediapipe_landmarklistextend)
  - [google::protobuf::Repeated_mediapipe_LandmarkList::get_Item](#googleprotobufrepeated_mediapipe_landmarklistget_item)
  - [google::protobuf::Repeated_mediapipe_LandmarkList::get__NewEnum](#googleprotobufrepeated_mediapipe_landmarklistget__newenum)
  - [google::protobuf::Repeated_mediapipe_LandmarkList::insert](#googleprotobufrepeated_mediapipe_landmarklistinsert)
  - [google::protobuf::Repeated_mediapipe_LandmarkList::pop](#googleprotobufrepeated_mediapipe_landmarklistpop)
  - [google::protobuf::Repeated_mediapipe_LandmarkList::reverse](#googleprotobufrepeated_mediapipe_landmarklistreverse)
  - [google::protobuf::Repeated_mediapipe_LandmarkList::size](#googleprotobufrepeated_mediapipe_landmarklistsize)
  - [google::protobuf::Repeated_mediapipe_LandmarkList::slice](#googleprotobufrepeated_mediapipe_landmarklistslice)
  - [google::protobuf::Repeated_mediapipe_LandmarkList::sort](#googleprotobufrepeated_mediapipe_landmarklistsort)
  - [google::protobuf::Repeated_mediapipe_LandmarkList::sort_variant](#googleprotobufrepeated_mediapipe_landmarklistsort_variant)
  - [google::protobuf::Repeated_mediapipe_LandmarkList::splice](#googleprotobufrepeated_mediapipe_landmarklistsplice)
- [mediapipe::NormalizedLandmark](#mediapipenormalizedlandmark)
  - [mediapipe::NormalizedLandmark::get_create](#mediapipenormalizedlandmarkget_create)
  - [mediapipe::NormalizedLandmark::str](#mediapipenormalizedlandmarkstr)
- [mediapipe::NormalizedLandmarkList](#mediapipenormalizedlandmarklist)
  - [mediapipe::NormalizedLandmarkList::get_create](#mediapipenormalizedlandmarklistget_create)
  - [mediapipe::NormalizedLandmarkList::str](#mediapipenormalizedlandmarkliststr)
- [google::protobuf::Repeated_mediapipe_NormalizedLandmark](#googleprotobufrepeated_mediapipe_normalizedlandmark)
  - [google::protobuf::Repeated_mediapipe_NormalizedLandmark::create](#googleprotobufrepeated_mediapipe_normalizedlandmarkcreate)
  - [google::protobuf::Repeated_mediapipe_NormalizedLandmark::CopyFrom](#googleprotobufrepeated_mediapipe_normalizedlandmarkcopyfrom)
  - [google::protobuf::Repeated_mediapipe_NormalizedLandmark::MergeFrom](#googleprotobufrepeated_mediapipe_normalizedlandmarkmergefrom)
  - [google::protobuf::Repeated_mediapipe_NormalizedLandmark::Swap](#googleprotobufrepeated_mediapipe_normalizedlandmarkswap)
  - [google::protobuf::Repeated_mediapipe_NormalizedLandmark::SwapElements](#googleprotobufrepeated_mediapipe_normalizedlandmarkswapelements)
  - [google::protobuf::Repeated_mediapipe_NormalizedLandmark::add](#googleprotobufrepeated_mediapipe_normalizedlandmarkadd)
  - [google::protobuf::Repeated_mediapipe_NormalizedLandmark::clear](#googleprotobufrepeated_mediapipe_normalizedlandmarkclear)
  - [google::protobuf::Repeated_mediapipe_NormalizedLandmark::empty](#googleprotobufrepeated_mediapipe_normalizedlandmarkempty)
  - [google::protobuf::Repeated_mediapipe_NormalizedLandmark::extend](#googleprotobufrepeated_mediapipe_normalizedlandmarkextend)
  - [google::protobuf::Repeated_mediapipe_NormalizedLandmark::get_Item](#googleprotobufrepeated_mediapipe_normalizedlandmarkget_item)
  - [google::protobuf::Repeated_mediapipe_NormalizedLandmark::get__NewEnum](#googleprotobufrepeated_mediapipe_normalizedlandmarkget__newenum)
  - [google::protobuf::Repeated_mediapipe_NormalizedLandmark::insert](#googleprotobufrepeated_mediapipe_normalizedlandmarkinsert)
  - [google::protobuf::Repeated_mediapipe_NormalizedLandmark::pop](#googleprotobufrepeated_mediapipe_normalizedlandmarkpop)
  - [google::protobuf::Repeated_mediapipe_NormalizedLandmark::reverse](#googleprotobufrepeated_mediapipe_normalizedlandmarkreverse)
  - [google::protobuf::Repeated_mediapipe_NormalizedLandmark::size](#googleprotobufrepeated_mediapipe_normalizedlandmarksize)
  - [google::protobuf::Repeated_mediapipe_NormalizedLandmark::slice](#googleprotobufrepeated_mediapipe_normalizedlandmarkslice)
  - [google::protobuf::Repeated_mediapipe_NormalizedLandmark::sort](#googleprotobufrepeated_mediapipe_normalizedlandmarksort)
  - [google::protobuf::Repeated_mediapipe_NormalizedLandmark::sort_variant](#googleprotobufrepeated_mediapipe_normalizedlandmarksort_variant)
  - [google::protobuf::Repeated_mediapipe_NormalizedLandmark::splice](#googleprotobufrepeated_mediapipe_normalizedlandmarksplice)
- [mediapipe::NormalizedLandmarkListCollection](#mediapipenormalizedlandmarklistcollection)
  - [mediapipe::NormalizedLandmarkListCollection::get_create](#mediapipenormalizedlandmarklistcollectionget_create)
  - [mediapipe::NormalizedLandmarkListCollection::str](#mediapipenormalizedlandmarklistcollectionstr)
- [google::protobuf::Repeated_mediapipe_NormalizedLandmarkList](#googleprotobufrepeated_mediapipe_normalizedlandmarklist)
  - [google::protobuf::Repeated_mediapipe_NormalizedLandmarkList::create](#googleprotobufrepeated_mediapipe_normalizedlandmarklistcreate)
  - [google::protobuf::Repeated_mediapipe_NormalizedLandmarkList::CopyFrom](#googleprotobufrepeated_mediapipe_normalizedlandmarklistcopyfrom)
  - [google::protobuf::Repeated_mediapipe_NormalizedLandmarkList::MergeFrom](#googleprotobufrepeated_mediapipe_normalizedlandmarklistmergefrom)
  - [google::protobuf::Repeated_mediapipe_NormalizedLandmarkList::Swap](#googleprotobufrepeated_mediapipe_normalizedlandmarklistswap)
  - [google::protobuf::Repeated_mediapipe_NormalizedLandmarkList::SwapElements](#googleprotobufrepeated_mediapipe_normalizedlandmarklistswapelements)
  - [google::protobuf::Repeated_mediapipe_NormalizedLandmarkList::add](#googleprotobufrepeated_mediapipe_normalizedlandmarklistadd)
  - [google::protobuf::Repeated_mediapipe_NormalizedLandmarkList::clear](#googleprotobufrepeated_mediapipe_normalizedlandmarklistclear)
  - [google::protobuf::Repeated_mediapipe_NormalizedLandmarkList::empty](#googleprotobufrepeated_mediapipe_normalizedlandmarklistempty)
  - [google::protobuf::Repeated_mediapipe_NormalizedLandmarkList::extend](#googleprotobufrepeated_mediapipe_normalizedlandmarklistextend)
  - [google::protobuf::Repeated_mediapipe_NormalizedLandmarkList::get_Item](#googleprotobufrepeated_mediapipe_normalizedlandmarklistget_item)
  - [google::protobuf::Repeated_mediapipe_NormalizedLandmarkList::get__NewEnum](#googleprotobufrepeated_mediapipe_normalizedlandmarklistget__newenum)
  - [google::protobuf::Repeated_mediapipe_NormalizedLandmarkList::insert](#googleprotobufrepeated_mediapipe_normalizedlandmarklistinsert)
  - [google::protobuf::Repeated_mediapipe_NormalizedLandmarkList::pop](#googleprotobufrepeated_mediapipe_normalizedlandmarklistpop)
  - [google::protobuf::Repeated_mediapipe_NormalizedLandmarkList::reverse](#googleprotobufrepeated_mediapipe_normalizedlandmarklistreverse)
  - [google::protobuf::Repeated_mediapipe_NormalizedLandmarkList::size](#googleprotobufrepeated_mediapipe_normalizedlandmarklistsize)
  - [google::protobuf::Repeated_mediapipe_NormalizedLandmarkList::slice](#googleprotobufrepeated_mediapipe_normalizedlandmarklistslice)
  - [google::protobuf::Repeated_mediapipe_NormalizedLandmarkList::sort](#googleprotobufrepeated_mediapipe_normalizedlandmarklistsort)
  - [google::protobuf::Repeated_mediapipe_NormalizedLandmarkList::sort_variant](#googleprotobufrepeated_mediapipe_normalizedlandmarklistsort_variant)
  - [google::protobuf::Repeated_mediapipe_NormalizedLandmarkList::splice](#googleprotobufrepeated_mediapipe_normalizedlandmarklistsplice)
- [mediapipe::ConstantSidePacketCalculatorOptions](#mediapipeconstantsidepacketcalculatoroptions)
  - [mediapipe::ConstantSidePacketCalculatorOptions::get_create](#mediapipeconstantsidepacketcalculatoroptionsget_create)
  - [mediapipe::ConstantSidePacketCalculatorOptions::str](#mediapipeconstantsidepacketcalculatoroptionsstr)
- [google::protobuf::Repeated_mediapipe_ConstantSidePacketCalculatorOptions_ConstantSidePacket](#googleprotobufrepeated_mediapipe_constantsidepacketcalculatoroptions_constantsidepacket)
  - [google::protobuf::Repeated_mediapipe_ConstantSidePacketCalculatorOptions_ConstantSidePacket::create](#googleprotobufrepeated_mediapipe_constantsidepacketcalculatoroptions_constantsidepacketcreate)
  - [google::protobuf::Repeated_mediapipe_ConstantSidePacketCalculatorOptions_ConstantSidePacket::CopyFrom](#googleprotobufrepeated_mediapipe_constantsidepacketcalculatoroptions_constantsidepacketcopyfrom)
  - [google::protobuf::Repeated_mediapipe_ConstantSidePacketCalculatorOptions_ConstantSidePacket::MergeFrom](#googleprotobufrepeated_mediapipe_constantsidepacketcalculatoroptions_constantsidepacketmergefrom)
  - [google::protobuf::Repeated_mediapipe_ConstantSidePacketCalculatorOptions_ConstantSidePacket::Swap](#googleprotobufrepeated_mediapipe_constantsidepacketcalculatoroptions_constantsidepacketswap)
  - [google::protobuf::Repeated_mediapipe_ConstantSidePacketCalculatorOptions_ConstantSidePacket::SwapElements](#googleprotobufrepeated_mediapipe_constantsidepacketcalculatoroptions_constantsidepacketswapelements)
  - [google::protobuf::Repeated_mediapipe_ConstantSidePacketCalculatorOptions_ConstantSidePacket::add](#googleprotobufrepeated_mediapipe_constantsidepacketcalculatoroptions_constantsidepacketadd)
  - [google::protobuf::Repeated_mediapipe_ConstantSidePacketCalculatorOptions_ConstantSidePacket::clear](#googleprotobufrepeated_mediapipe_constantsidepacketcalculatoroptions_constantsidepacketclear)
  - [google::protobuf::Repeated_mediapipe_ConstantSidePacketCalculatorOptions_ConstantSidePacket::empty](#googleprotobufrepeated_mediapipe_constantsidepacketcalculatoroptions_constantsidepacketempty)
  - [google::protobuf::Repeated_mediapipe_ConstantSidePacketCalculatorOptions_ConstantSidePacket::extend](#googleprotobufrepeated_mediapipe_constantsidepacketcalculatoroptions_constantsidepacketextend)
  - [google::protobuf::Repeated_mediapipe_ConstantSidePacketCalculatorOptions_ConstantSidePacket::get_Item](#googleprotobufrepeated_mediapipe_constantsidepacketcalculatoroptions_constantsidepacketget_item)
  - [google::protobuf::Repeated_mediapipe_ConstantSidePacketCalculatorOptions_ConstantSidePacket::get__NewEnum](#googleprotobufrepeated_mediapipe_constantsidepacketcalculatoroptions_constantsidepacketget__newenum)
  - [google::protobuf::Repeated_mediapipe_ConstantSidePacketCalculatorOptions_ConstantSidePacket::insert](#googleprotobufrepeated_mediapipe_constantsidepacketcalculatoroptions_constantsidepacketinsert)
  - [google::protobuf::Repeated_mediapipe_ConstantSidePacketCalculatorOptions_ConstantSidePacket::pop](#googleprotobufrepeated_mediapipe_constantsidepacketcalculatoroptions_constantsidepacketpop)
  - [google::protobuf::Repeated_mediapipe_ConstantSidePacketCalculatorOptions_ConstantSidePacket::reverse](#googleprotobufrepeated_mediapipe_constantsidepacketcalculatoroptions_constantsidepacketreverse)
  - [google::protobuf::Repeated_mediapipe_ConstantSidePacketCalculatorOptions_ConstantSidePacket::size](#googleprotobufrepeated_mediapipe_constantsidepacketcalculatoroptions_constantsidepacketsize)
  - [google::protobuf::Repeated_mediapipe_ConstantSidePacketCalculatorOptions_ConstantSidePacket::slice](#googleprotobufrepeated_mediapipe_constantsidepacketcalculatoroptions_constantsidepacketslice)
  - [google::protobuf::Repeated_mediapipe_ConstantSidePacketCalculatorOptions_ConstantSidePacket::sort](#googleprotobufrepeated_mediapipe_constantsidepacketcalculatoroptions_constantsidepacketsort)
  - [google::protobuf::Repeated_mediapipe_ConstantSidePacketCalculatorOptions_ConstantSidePacket::sort_variant](#googleprotobufrepeated_mediapipe_constantsidepacketcalculatoroptions_constantsidepacketsort_variant)
  - [google::protobuf::Repeated_mediapipe_ConstantSidePacketCalculatorOptions_ConstantSidePacket::splice](#googleprotobufrepeated_mediapipe_constantsidepacketcalculatoroptions_constantsidepacketsplice)
- [mediapipe::ConstantSidePacketCalculatorOptions::ConstantSidePacket](#mediapipeconstantsidepacketcalculatoroptionsconstantsidepacket)
  - [mediapipe::ConstantSidePacketCalculatorOptions::ConstantSidePacket::get_create](#mediapipeconstantsidepacketcalculatoroptionsconstantsidepacketget_create)
  - [mediapipe::ConstantSidePacketCalculatorOptions::ConstantSidePacket::str](#mediapipeconstantsidepacketcalculatoroptionsconstantsidepacketstr)
- [mediapipe::ScaleMode](#mediapipescalemode)
  - [mediapipe::ScaleMode::get_create](#mediapipescalemodeget_create)
  - [mediapipe::ScaleMode::str](#mediapipescalemodestr)
- [mediapipe::RotationMode](#mediapiperotationmode)
  - [mediapipe::RotationMode::get_create](#mediapiperotationmodeget_create)
  - [mediapipe::RotationMode::str](#mediapiperotationmodestr)
- [mediapipe::ImageTransformationCalculatorOptions](#mediapipeimagetransformationcalculatoroptions)
  - [mediapipe::ImageTransformationCalculatorOptions::get_create](#mediapipeimagetransformationcalculatoroptionsget_create)
  - [mediapipe::ImageTransformationCalculatorOptions::str](#mediapipeimagetransformationcalculatoroptionsstr)
- [mediapipe::TensorsToDetectionsCalculatorOptions](#mediapipetensorstodetectionscalculatoroptions)
  - [mediapipe::TensorsToDetectionsCalculatorOptions::get_create](#mediapipetensorstodetectionscalculatoroptionsget_create)
  - [mediapipe::TensorsToDetectionsCalculatorOptions::str](#mediapipetensorstodetectionscalculatoroptionsstr)
- [mediapipe::TensorsToDetectionsCalculatorOptions::TensorMapping](#mediapipetensorstodetectionscalculatoroptionstensormapping)
  - [mediapipe::TensorsToDetectionsCalculatorOptions::TensorMapping::get_create](#mediapipetensorstodetectionscalculatoroptionstensormappingget_create)
  - [mediapipe::TensorsToDetectionsCalculatorOptions::TensorMapping::str](#mediapipetensorstodetectionscalculatoroptionstensormappingstr)
- [mediapipe::TensorsToDetectionsCalculatorOptions::BoxBoundariesIndices](#mediapipetensorstodetectionscalculatoroptionsboxboundariesindices)
  - [mediapipe::TensorsToDetectionsCalculatorOptions::BoxBoundariesIndices::get_create](#mediapipetensorstodetectionscalculatoroptionsboxboundariesindicesget_create)
  - [mediapipe::TensorsToDetectionsCalculatorOptions::BoxBoundariesIndices::str](#mediapipetensorstodetectionscalculatoroptionsboxboundariesindicesstr)
- [mediapipe::LandmarksSmoothingCalculatorOptions](#mediapipelandmarkssmoothingcalculatoroptions)
  - [mediapipe::LandmarksSmoothingCalculatorOptions::get_create](#mediapipelandmarkssmoothingcalculatoroptionsget_create)
  - [mediapipe::LandmarksSmoothingCalculatorOptions::str](#mediapipelandmarkssmoothingcalculatoroptionsstr)
- [mediapipe::LandmarksSmoothingCalculatorOptions::NoFilter](#mediapipelandmarkssmoothingcalculatoroptionsnofilter)
  - [mediapipe::LandmarksSmoothingCalculatorOptions::NoFilter::get_create](#mediapipelandmarkssmoothingcalculatoroptionsnofilterget_create)
  - [mediapipe::LandmarksSmoothingCalculatorOptions::NoFilter::str](#mediapipelandmarkssmoothingcalculatoroptionsnofilterstr)
- [mediapipe::LandmarksSmoothingCalculatorOptions::VelocityFilter](#mediapipelandmarkssmoothingcalculatoroptionsvelocityfilter)
  - [mediapipe::LandmarksSmoothingCalculatorOptions::VelocityFilter::get_create](#mediapipelandmarkssmoothingcalculatoroptionsvelocityfilterget_create)
  - [mediapipe::LandmarksSmoothingCalculatorOptions::VelocityFilter::str](#mediapipelandmarkssmoothingcalculatoroptionsvelocityfilterstr)
- [mediapipe::LandmarksSmoothingCalculatorOptions::OneEuroFilter](#mediapipelandmarkssmoothingcalculatoroptionsoneeurofilter)
  - [mediapipe::LandmarksSmoothingCalculatorOptions::OneEuroFilter::get_create](#mediapipelandmarkssmoothingcalculatoroptionsoneeurofilterget_create)
  - [mediapipe::LandmarksSmoothingCalculatorOptions::OneEuroFilter::str](#mediapipelandmarkssmoothingcalculatoroptionsoneeurofilterstr)
- [mediapipe::LogicCalculatorOptions](#mediapipelogiccalculatoroptions)
  - [mediapipe::LogicCalculatorOptions::get_create](#mediapipelogiccalculatoroptionsget_create)
  - [mediapipe::LogicCalculatorOptions::str](#mediapipelogiccalculatoroptionsstr)
- [google::protobuf::Repeated_bool](#googleprotobufrepeated_bool)
  - [google::protobuf::Repeated_bool::create](#googleprotobufrepeated_boolcreate)
  - [google::protobuf::Repeated_bool::CopyFrom](#googleprotobufrepeated_boolcopyfrom)
  - [google::protobuf::Repeated_bool::MergeFrom](#googleprotobufrepeated_boolmergefrom)
  - [google::protobuf::Repeated_bool::Swap](#googleprotobufrepeated_boolswap)
  - [google::protobuf::Repeated_bool::SwapElements](#googleprotobufrepeated_boolswapelements)
  - [google::protobuf::Repeated_bool::append](#googleprotobufrepeated_boolappend)
  - [google::protobuf::Repeated_bool::clear](#googleprotobufrepeated_boolclear)
  - [google::protobuf::Repeated_bool::empty](#googleprotobufrepeated_boolempty)
  - [google::protobuf::Repeated_bool::extend](#googleprotobufrepeated_boolextend)
  - [google::protobuf::Repeated_bool::get_Item](#googleprotobufrepeated_boolget_item)
  - [google::protobuf::Repeated_bool::get__NewEnum](#googleprotobufrepeated_boolget__newenum)
  - [google::protobuf::Repeated_bool::insert](#googleprotobufrepeated_boolinsert)
  - [google::protobuf::Repeated_bool::pop](#googleprotobufrepeated_boolpop)
  - [google::protobuf::Repeated_bool::reverse](#googleprotobufrepeated_boolreverse)
  - [google::protobuf::Repeated_bool::set](#googleprotobufrepeated_boolset)
  - [google::protobuf::Repeated_bool::size](#googleprotobufrepeated_boolsize)
  - [google::protobuf::Repeated_bool::slice](#googleprotobufrepeated_boolslice)
  - [google::protobuf::Repeated_bool::sort](#googleprotobufrepeated_boolsort)
  - [google::protobuf::Repeated_bool::sort_variant](#googleprotobufrepeated_boolsort_variant)
  - [google::protobuf::Repeated_bool::splice](#googleprotobufrepeated_boolsplice)
- [mediapipe::ThresholdingCalculatorOptions](#mediapipethresholdingcalculatoroptions)
  - [mediapipe::ThresholdingCalculatorOptions::get_create](#mediapipethresholdingcalculatoroptionsget_create)
  - [mediapipe::ThresholdingCalculatorOptions::str](#mediapipethresholdingcalculatoroptionsstr)
- [mediapipe::BeliefDecoderConfig](#mediapipebeliefdecoderconfig)
  - [mediapipe::BeliefDecoderConfig::get_create](#mediapipebeliefdecoderconfigget_create)
  - [mediapipe::BeliefDecoderConfig::str](#mediapipebeliefdecoderconfigstr)
- [mediapipe::Lift2DFrameAnnotationTo3DCalculatorOptions](#mediapipelift2dframeannotationto3dcalculatoroptions)
  - [mediapipe::Lift2DFrameAnnotationTo3DCalculatorOptions::get_create](#mediapipelift2dframeannotationto3dcalculatoroptionsget_create)
  - [mediapipe::Lift2DFrameAnnotationTo3DCalculatorOptions::str](#mediapipelift2dframeannotationto3dcalculatoroptionsstr)
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
  - [VectorOfVariant::get__NewEnum](#vectorofvariantget__newenum)
  - [VectorOfVariant::push_back](#vectorofvariantpush_back)
  - [VectorOfVariant::push_vector](#vectorofvariantpush_vector)
  - [VectorOfVariant::put_Item](#vectorofvariantput_item)
  - [VectorOfVariant::size](#vectorofvariantsize)
  - [VectorOfVariant::slice](#vectorofvariantslice)
  - [VectorOfVariant::sort](#vectorofvariantsort)
  - [VectorOfVariant::sort_variant](#vectorofvariantsort_variant)
  - [VectorOfVariant::start](#vectorofvariantstart)
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
  - [VectorOfBool::get__NewEnum](#vectorofboolget__newenum)
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
  - [VectorOfFloat::get__NewEnum](#vectoroffloatget__newenum)
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
  - [VectorOfImage::get__NewEnum](#vectorofimageget__newenum)
  - [VectorOfImage::push_back](#vectorofimagepush_back)
  - [VectorOfImage::push_vector](#vectorofimagepush_vector)
  - [VectorOfImage::put_Item](#vectorofimageput_item)
  - [VectorOfImage::size](#vectorofimagesize)
  - [VectorOfImage::slice](#vectorofimageslice)
  - [VectorOfImage::sort](#vectorofimagesort)
  - [VectorOfImage::sort_variant](#vectorofimagesort_variant)
  - [VectorOfImage::start](#vectorofimagestart)
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
  - [VectorOfInt::get__NewEnum](#vectorofintget__newenum)
  - [VectorOfInt::push_back](#vectorofintpush_back)
  - [VectorOfInt::push_vector](#vectorofintpush_vector)
  - [VectorOfInt::put_Item](#vectorofintput_item)
  - [VectorOfInt::size](#vectorofintsize)
  - [VectorOfInt::slice](#vectorofintslice)
  - [VectorOfInt::sort](#vectorofintsort)
  - [VectorOfInt::sort_variant](#vectorofintsort_variant)
  - [VectorOfInt::start](#vectorofintstart)
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
  - [VectorOfPacket::get__NewEnum](#vectorofpacketget__newenum)
  - [VectorOfPacket::push_back](#vectorofpacketpush_back)
  - [VectorOfPacket::push_vector](#vectorofpacketpush_vector)
  - [VectorOfPacket::put_Item](#vectorofpacketput_item)
  - [VectorOfPacket::size](#vectorofpacketsize)
  - [VectorOfPacket::slice](#vectorofpacketslice)
  - [VectorOfPacket::sort](#vectorofpacketsort)
  - [VectorOfPacket::sort_variant](#vectorofpacketsort_variant)
  - [VectorOfPacket::start](#vectorofpacketstart)
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
  - [MapOfStringAndPacket::get__NewEnum](#mapofstringandpacketget__newenum)
  - [MapOfStringAndPacket::has](#mapofstringandpackethas)
  - [MapOfStringAndPacket::max_size](#mapofstringandpacketmax_size)
  - [MapOfStringAndPacket::merge](#mapofstringandpacketmerge)
  - [MapOfStringAndPacket::put_Item](#mapofstringandpacketput_item)
  - [MapOfStringAndPacket::size](#mapofstringandpacketsize)
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
  - [VectorOfString::get__NewEnum](#vectorofstringget__newenum)
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
  - [VectorOfInt64::get__NewEnum](#vectorofint64get__newenum)
  - [VectorOfInt64::push_back](#vectorofint64push_back)
  - [VectorOfInt64::push_vector](#vectorofint64push_vector)
  - [VectorOfInt64::put_Item](#vectorofint64put_item)
  - [VectorOfInt64::size](#vectorofint64size)
  - [VectorOfInt64::slice](#vectorofint64slice)
  - [VectorOfInt64::sort](#vectorofint64sort)
  - [VectorOfInt64::sort_variant](#vectorofint64sort_variant)
  - [VectorOfInt64::start](#vectorofint64start)
- [VectorOfShared_ptrMessage](#vectorofshared_ptrmessage)
  - [VectorOfShared_ptrMessage::create](#vectorofshared_ptrmessagecreate)
  - [VectorOfShared_ptrMessage::Add](#vectorofshared_ptrmessageadd)
  - [VectorOfShared_ptrMessage::Items](#vectorofshared_ptrmessageitems)
  - [VectorOfShared_ptrMessage::Keys](#vectorofshared_ptrmessagekeys)
  - [VectorOfShared_ptrMessage::Remove](#vectorofshared_ptrmessageremove)
  - [VectorOfShared_ptrMessage::at](#vectorofshared_ptrmessageat)
  - [VectorOfShared_ptrMessage::clear](#vectorofshared_ptrmessageclear)
  - [VectorOfShared_ptrMessage::empty](#vectorofshared_ptrmessageempty)
  - [VectorOfShared_ptrMessage::end](#vectorofshared_ptrmessageend)
  - [VectorOfShared_ptrMessage::get_Item](#vectorofshared_ptrmessageget_item)
  - [VectorOfShared_ptrMessage::get__NewEnum](#vectorofshared_ptrmessageget__newenum)
  - [VectorOfShared_ptrMessage::push_back](#vectorofshared_ptrmessagepush_back)
  - [VectorOfShared_ptrMessage::push_vector](#vectorofshared_ptrmessagepush_vector)
  - [VectorOfShared_ptrMessage::put_Item](#vectorofshared_ptrmessageput_item)
  - [VectorOfShared_ptrMessage::size](#vectorofshared_ptrmessagesize)
  - [VectorOfShared_ptrMessage::slice](#vectorofshared_ptrmessageslice)
  - [VectorOfShared_ptrMessage::sort](#vectorofshared_ptrmessagesort)
  - [VectorOfShared_ptrMessage::sort_variant](#vectorofshared_ptrmessagesort_variant)
  - [VectorOfShared_ptrMessage::start](#vectorofshared_ptrmessagestart)
- [MapOfStringAndPacketDataType](#mapofstringandpacketdatatype)
  - [MapOfStringAndPacketDataType::create](#mapofstringandpacketdatatypecreate)
  - [MapOfStringAndPacketDataType::Add](#mapofstringandpacketdatatypeadd)
  - [MapOfStringAndPacketDataType::Get](#mapofstringandpacketdatatypeget)
  - [MapOfStringAndPacketDataType::Items](#mapofstringandpacketdatatypeitems)
  - [MapOfStringAndPacketDataType::Keys](#mapofstringandpacketdatatypekeys)
  - [MapOfStringAndPacketDataType::Remove](#mapofstringandpacketdatatyperemove)
  - [MapOfStringAndPacketDataType::clear](#mapofstringandpacketdatatypeclear)
  - [MapOfStringAndPacketDataType::contains](#mapofstringandpacketdatatypecontains)
  - [MapOfStringAndPacketDataType::count](#mapofstringandpacketdatatypecount)
  - [MapOfStringAndPacketDataType::empty](#mapofstringandpacketdatatypeempty)
  - [MapOfStringAndPacketDataType::erase](#mapofstringandpacketdatatypeerase)
  - [MapOfStringAndPacketDataType::get_Item](#mapofstringandpacketdatatypeget_item)
  - [MapOfStringAndPacketDataType::get__NewEnum](#mapofstringandpacketdatatypeget__newenum)
  - [MapOfStringAndPacketDataType::has](#mapofstringandpacketdatatypehas)
  - [MapOfStringAndPacketDataType::max_size](#mapofstringandpacketdatatypemax_size)
  - [MapOfStringAndPacketDataType::merge](#mapofstringandpacketdatatypemerge)
  - [MapOfStringAndPacketDataType::put_Item](#mapofstringandpacketdatatypeput_item)
  - [MapOfStringAndPacketDataType::size](#mapofstringandpacketdatatypesize)
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
  - [VectorOfUchar::get__NewEnum](#vectorofucharget__newenum)
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
  - [VectorOfMat::get__NewEnum](#vectorofmatget__newenum)
  - [VectorOfMat::push_back](#vectorofmatpush_back)
  - [VectorOfMat::push_vector](#vectorofmatpush_vector)
  - [VectorOfMat::put_Item](#vectorofmatput_item)
  - [VectorOfMat::size](#vectorofmatsize)
  - [VectorOfMat::slice](#vectorofmatslice)
  - [VectorOfMat::sort](#vectorofmatsort)
  - [VectorOfMat::sort_variant](#vectorofmatsort_variant)
  - [VectorOfMat::start](#vectorofmatstart)
- [VectorOfShared_ptrPacketFactoryConfig](#vectorofshared_ptrpacketfactoryconfig)
  - [VectorOfShared_ptrPacketFactoryConfig::create](#vectorofshared_ptrpacketfactoryconfigcreate)
  - [VectorOfShared_ptrPacketFactoryConfig::Add](#vectorofshared_ptrpacketfactoryconfigadd)
  - [VectorOfShared_ptrPacketFactoryConfig::Items](#vectorofshared_ptrpacketfactoryconfigitems)
  - [VectorOfShared_ptrPacketFactoryConfig::Keys](#vectorofshared_ptrpacketfactoryconfigkeys)
  - [VectorOfShared_ptrPacketFactoryConfig::Remove](#vectorofshared_ptrpacketfactoryconfigremove)
  - [VectorOfShared_ptrPacketFactoryConfig::at](#vectorofshared_ptrpacketfactoryconfigat)
  - [VectorOfShared_ptrPacketFactoryConfig::clear](#vectorofshared_ptrpacketfactoryconfigclear)
  - [VectorOfShared_ptrPacketFactoryConfig::empty](#vectorofshared_ptrpacketfactoryconfigempty)
  - [VectorOfShared_ptrPacketFactoryConfig::end](#vectorofshared_ptrpacketfactoryconfigend)
  - [VectorOfShared_ptrPacketFactoryConfig::get_Item](#vectorofshared_ptrpacketfactoryconfigget_item)
  - [VectorOfShared_ptrPacketFactoryConfig::get__NewEnum](#vectorofshared_ptrpacketfactoryconfigget__newenum)
  - [VectorOfShared_ptrPacketFactoryConfig::push_back](#vectorofshared_ptrpacketfactoryconfigpush_back)
  - [VectorOfShared_ptrPacketFactoryConfig::push_vector](#vectorofshared_ptrpacketfactoryconfigpush_vector)
  - [VectorOfShared_ptrPacketFactoryConfig::put_Item](#vectorofshared_ptrpacketfactoryconfigput_item)
  - [VectorOfShared_ptrPacketFactoryConfig::size](#vectorofshared_ptrpacketfactoryconfigsize)
  - [VectorOfShared_ptrPacketFactoryConfig::slice](#vectorofshared_ptrpacketfactoryconfigslice)
  - [VectorOfShared_ptrPacketFactoryConfig::sort](#vectorofshared_ptrpacketfactoryconfigsort)
  - [VectorOfShared_ptrPacketFactoryConfig::sort_variant](#vectorofshared_ptrpacketfactoryconfigsort_variant)
  - [VectorOfShared_ptrPacketFactoryConfig::start](#vectorofshared_ptrpacketfactoryconfigstart)
- [VectorOfShared_ptrInputCollection](#vectorofshared_ptrinputcollection)
  - [VectorOfShared_ptrInputCollection::create](#vectorofshared_ptrinputcollectioncreate)
  - [VectorOfShared_ptrInputCollection::Add](#vectorofshared_ptrinputcollectionadd)
  - [VectorOfShared_ptrInputCollection::Items](#vectorofshared_ptrinputcollectionitems)
  - [VectorOfShared_ptrInputCollection::Keys](#vectorofshared_ptrinputcollectionkeys)
  - [VectorOfShared_ptrInputCollection::Remove](#vectorofshared_ptrinputcollectionremove)
  - [VectorOfShared_ptrInputCollection::at](#vectorofshared_ptrinputcollectionat)
  - [VectorOfShared_ptrInputCollection::clear](#vectorofshared_ptrinputcollectionclear)
  - [VectorOfShared_ptrInputCollection::empty](#vectorofshared_ptrinputcollectionempty)
  - [VectorOfShared_ptrInputCollection::end](#vectorofshared_ptrinputcollectionend)
  - [VectorOfShared_ptrInputCollection::get_Item](#vectorofshared_ptrinputcollectionget_item)
  - [VectorOfShared_ptrInputCollection::get__NewEnum](#vectorofshared_ptrinputcollectionget__newenum)
  - [VectorOfShared_ptrInputCollection::push_back](#vectorofshared_ptrinputcollectionpush_back)
  - [VectorOfShared_ptrInputCollection::push_vector](#vectorofshared_ptrinputcollectionpush_vector)
  - [VectorOfShared_ptrInputCollection::put_Item](#vectorofshared_ptrinputcollectionput_item)
  - [VectorOfShared_ptrInputCollection::size](#vectorofshared_ptrinputcollectionsize)
  - [VectorOfShared_ptrInputCollection::slice](#vectorofshared_ptrinputcollectionslice)
  - [VectorOfShared_ptrInputCollection::sort](#vectorofshared_ptrinputcollectionsort)
  - [VectorOfShared_ptrInputCollection::sort_variant](#vectorofshared_ptrinputcollectionsort_variant)
  - [VectorOfShared_ptrInputCollection::start](#vectorofshared_ptrinputcollectionstart)
- [VectorOfShared_ptrNode](#vectorofshared_ptrnode)
  - [VectorOfShared_ptrNode::create](#vectorofshared_ptrnodecreate)
  - [VectorOfShared_ptrNode::Add](#vectorofshared_ptrnodeadd)
  - [VectorOfShared_ptrNode::Items](#vectorofshared_ptrnodeitems)
  - [VectorOfShared_ptrNode::Keys](#vectorofshared_ptrnodekeys)
  - [VectorOfShared_ptrNode::Remove](#vectorofshared_ptrnoderemove)
  - [VectorOfShared_ptrNode::at](#vectorofshared_ptrnodeat)
  - [VectorOfShared_ptrNode::clear](#vectorofshared_ptrnodeclear)
  - [VectorOfShared_ptrNode::empty](#vectorofshared_ptrnodeempty)
  - [VectorOfShared_ptrNode::end](#vectorofshared_ptrnodeend)
  - [VectorOfShared_ptrNode::get_Item](#vectorofshared_ptrnodeget_item)
  - [VectorOfShared_ptrNode::get__NewEnum](#vectorofshared_ptrnodeget__newenum)
  - [VectorOfShared_ptrNode::push_back](#vectorofshared_ptrnodepush_back)
  - [VectorOfShared_ptrNode::push_vector](#vectorofshared_ptrnodepush_vector)
  - [VectorOfShared_ptrNode::put_Item](#vectorofshared_ptrnodeput_item)
  - [VectorOfShared_ptrNode::size](#vectorofshared_ptrnodesize)
  - [VectorOfShared_ptrNode::slice](#vectorofshared_ptrnodeslice)
  - [VectorOfShared_ptrNode::sort](#vectorofshared_ptrnodesort)
  - [VectorOfShared_ptrNode::sort_variant](#vectorofshared_ptrnodesort_variant)
  - [VectorOfShared_ptrNode::start](#vectorofshared_ptrnodestart)
- [VectorOfShared_ptrPacketGeneratorConfig](#vectorofshared_ptrpacketgeneratorconfig)
  - [VectorOfShared_ptrPacketGeneratorConfig::create](#vectorofshared_ptrpacketgeneratorconfigcreate)
  - [VectorOfShared_ptrPacketGeneratorConfig::Add](#vectorofshared_ptrpacketgeneratorconfigadd)
  - [VectorOfShared_ptrPacketGeneratorConfig::Items](#vectorofshared_ptrpacketgeneratorconfigitems)
  - [VectorOfShared_ptrPacketGeneratorConfig::Keys](#vectorofshared_ptrpacketgeneratorconfigkeys)
  - [VectorOfShared_ptrPacketGeneratorConfig::Remove](#vectorofshared_ptrpacketgeneratorconfigremove)
  - [VectorOfShared_ptrPacketGeneratorConfig::at](#vectorofshared_ptrpacketgeneratorconfigat)
  - [VectorOfShared_ptrPacketGeneratorConfig::clear](#vectorofshared_ptrpacketgeneratorconfigclear)
  - [VectorOfShared_ptrPacketGeneratorConfig::empty](#vectorofshared_ptrpacketgeneratorconfigempty)
  - [VectorOfShared_ptrPacketGeneratorConfig::end](#vectorofshared_ptrpacketgeneratorconfigend)
  - [VectorOfShared_ptrPacketGeneratorConfig::get_Item](#vectorofshared_ptrpacketgeneratorconfigget_item)
  - [VectorOfShared_ptrPacketGeneratorConfig::get__NewEnum](#vectorofshared_ptrpacketgeneratorconfigget__newenum)
  - [VectorOfShared_ptrPacketGeneratorConfig::push_back](#vectorofshared_ptrpacketgeneratorconfigpush_back)
  - [VectorOfShared_ptrPacketGeneratorConfig::push_vector](#vectorofshared_ptrpacketgeneratorconfigpush_vector)
  - [VectorOfShared_ptrPacketGeneratorConfig::put_Item](#vectorofshared_ptrpacketgeneratorconfigput_item)
  - [VectorOfShared_ptrPacketGeneratorConfig::size](#vectorofshared_ptrpacketgeneratorconfigsize)
  - [VectorOfShared_ptrPacketGeneratorConfig::slice](#vectorofshared_ptrpacketgeneratorconfigslice)
  - [VectorOfShared_ptrPacketGeneratorConfig::sort](#vectorofshared_ptrpacketgeneratorconfigsort)
  - [VectorOfShared_ptrPacketGeneratorConfig::sort_variant](#vectorofshared_ptrpacketgeneratorconfigsort_variant)
  - [VectorOfShared_ptrPacketGeneratorConfig::start](#vectorofshared_ptrpacketgeneratorconfigstart)
- [VectorOfShared_ptrStatusHandlerConfig](#vectorofshared_ptrstatushandlerconfig)
  - [VectorOfShared_ptrStatusHandlerConfig::create](#vectorofshared_ptrstatushandlerconfigcreate)
  - [VectorOfShared_ptrStatusHandlerConfig::Add](#vectorofshared_ptrstatushandlerconfigadd)
  - [VectorOfShared_ptrStatusHandlerConfig::Items](#vectorofshared_ptrstatushandlerconfigitems)
  - [VectorOfShared_ptrStatusHandlerConfig::Keys](#vectorofshared_ptrstatushandlerconfigkeys)
  - [VectorOfShared_ptrStatusHandlerConfig::Remove](#vectorofshared_ptrstatushandlerconfigremove)
  - [VectorOfShared_ptrStatusHandlerConfig::at](#vectorofshared_ptrstatushandlerconfigat)
  - [VectorOfShared_ptrStatusHandlerConfig::clear](#vectorofshared_ptrstatushandlerconfigclear)
  - [VectorOfShared_ptrStatusHandlerConfig::empty](#vectorofshared_ptrstatushandlerconfigempty)
  - [VectorOfShared_ptrStatusHandlerConfig::end](#vectorofshared_ptrstatushandlerconfigend)
  - [VectorOfShared_ptrStatusHandlerConfig::get_Item](#vectorofshared_ptrstatushandlerconfigget_item)
  - [VectorOfShared_ptrStatusHandlerConfig::get__NewEnum](#vectorofshared_ptrstatushandlerconfigget__newenum)
  - [VectorOfShared_ptrStatusHandlerConfig::push_back](#vectorofshared_ptrstatushandlerconfigpush_back)
  - [VectorOfShared_ptrStatusHandlerConfig::push_vector](#vectorofshared_ptrstatushandlerconfigpush_vector)
  - [VectorOfShared_ptrStatusHandlerConfig::put_Item](#vectorofshared_ptrstatushandlerconfigput_item)
  - [VectorOfShared_ptrStatusHandlerConfig::size](#vectorofshared_ptrstatushandlerconfigsize)
  - [VectorOfShared_ptrStatusHandlerConfig::slice](#vectorofshared_ptrstatushandlerconfigslice)
  - [VectorOfShared_ptrStatusHandlerConfig::sort](#vectorofshared_ptrstatushandlerconfigsort)
  - [VectorOfShared_ptrStatusHandlerConfig::sort_variant](#vectorofshared_ptrstatushandlerconfigsort_variant)
  - [VectorOfShared_ptrStatusHandlerConfig::start](#vectorofshared_ptrstatushandlerconfigstart)
- [VectorOfShared_ptrExecutorConfig](#vectorofshared_ptrexecutorconfig)
  - [VectorOfShared_ptrExecutorConfig::create](#vectorofshared_ptrexecutorconfigcreate)
  - [VectorOfShared_ptrExecutorConfig::Add](#vectorofshared_ptrexecutorconfigadd)
  - [VectorOfShared_ptrExecutorConfig::Items](#vectorofshared_ptrexecutorconfigitems)
  - [VectorOfShared_ptrExecutorConfig::Keys](#vectorofshared_ptrexecutorconfigkeys)
  - [VectorOfShared_ptrExecutorConfig::Remove](#vectorofshared_ptrexecutorconfigremove)
  - [VectorOfShared_ptrExecutorConfig::at](#vectorofshared_ptrexecutorconfigat)
  - [VectorOfShared_ptrExecutorConfig::clear](#vectorofshared_ptrexecutorconfigclear)
  - [VectorOfShared_ptrExecutorConfig::empty](#vectorofshared_ptrexecutorconfigempty)
  - [VectorOfShared_ptrExecutorConfig::end](#vectorofshared_ptrexecutorconfigend)
  - [VectorOfShared_ptrExecutorConfig::get_Item](#vectorofshared_ptrexecutorconfigget_item)
  - [VectorOfShared_ptrExecutorConfig::get__NewEnum](#vectorofshared_ptrexecutorconfigget__newenum)
  - [VectorOfShared_ptrExecutorConfig::push_back](#vectorofshared_ptrexecutorconfigpush_back)
  - [VectorOfShared_ptrExecutorConfig::push_vector](#vectorofshared_ptrexecutorconfigpush_vector)
  - [VectorOfShared_ptrExecutorConfig::put_Item](#vectorofshared_ptrexecutorconfigput_item)
  - [VectorOfShared_ptrExecutorConfig::size](#vectorofshared_ptrexecutorconfigsize)
  - [VectorOfShared_ptrExecutorConfig::slice](#vectorofshared_ptrexecutorconfigslice)
  - [VectorOfShared_ptrExecutorConfig::sort](#vectorofshared_ptrexecutorconfigsort)
  - [VectorOfShared_ptrExecutorConfig::sort_variant](#vectorofshared_ptrexecutorconfigsort_variant)
  - [VectorOfShared_ptrExecutorConfig::start](#vectorofshared_ptrexecutorconfigstart)
- [VectorOfShared_ptrAny](#vectorofshared_ptrany)
  - [VectorOfShared_ptrAny::create](#vectorofshared_ptranycreate)
  - [VectorOfShared_ptrAny::Add](#vectorofshared_ptranyadd)
  - [VectorOfShared_ptrAny::Items](#vectorofshared_ptranyitems)
  - [VectorOfShared_ptrAny::Keys](#vectorofshared_ptranykeys)
  - [VectorOfShared_ptrAny::Remove](#vectorofshared_ptranyremove)
  - [VectorOfShared_ptrAny::at](#vectorofshared_ptranyat)
  - [VectorOfShared_ptrAny::clear](#vectorofshared_ptranyclear)
  - [VectorOfShared_ptrAny::empty](#vectorofshared_ptranyempty)
  - [VectorOfShared_ptrAny::end](#vectorofshared_ptranyend)
  - [VectorOfShared_ptrAny::get_Item](#vectorofshared_ptranyget_item)
  - [VectorOfShared_ptrAny::get__NewEnum](#vectorofshared_ptranyget__newenum)
  - [VectorOfShared_ptrAny::push_back](#vectorofshared_ptranypush_back)
  - [VectorOfShared_ptrAny::push_vector](#vectorofshared_ptranypush_vector)
  - [VectorOfShared_ptrAny::put_Item](#vectorofshared_ptranyput_item)
  - [VectorOfShared_ptrAny::size](#vectorofshared_ptranysize)
  - [VectorOfShared_ptrAny::slice](#vectorofshared_ptranyslice)
  - [VectorOfShared_ptrAny::sort](#vectorofshared_ptranysort)
  - [VectorOfShared_ptrAny::sort_variant](#vectorofshared_ptranysort_variant)
  - [VectorOfShared_ptrAny::start](#vectorofshared_ptranystart)
- [VectorOfShared_ptrInputStreamInfo](#vectorofshared_ptrinputstreaminfo)
  - [VectorOfShared_ptrInputStreamInfo::create](#vectorofshared_ptrinputstreaminfocreate)
  - [VectorOfShared_ptrInputStreamInfo::Add](#vectorofshared_ptrinputstreaminfoadd)
  - [VectorOfShared_ptrInputStreamInfo::Items](#vectorofshared_ptrinputstreaminfoitems)
  - [VectorOfShared_ptrInputStreamInfo::Keys](#vectorofshared_ptrinputstreaminfokeys)
  - [VectorOfShared_ptrInputStreamInfo::Remove](#vectorofshared_ptrinputstreaminforemove)
  - [VectorOfShared_ptrInputStreamInfo::at](#vectorofshared_ptrinputstreaminfoat)
  - [VectorOfShared_ptrInputStreamInfo::clear](#vectorofshared_ptrinputstreaminfoclear)
  - [VectorOfShared_ptrInputStreamInfo::empty](#vectorofshared_ptrinputstreaminfoempty)
  - [VectorOfShared_ptrInputStreamInfo::end](#vectorofshared_ptrinputstreaminfoend)
  - [VectorOfShared_ptrInputStreamInfo::get_Item](#vectorofshared_ptrinputstreaminfoget_item)
  - [VectorOfShared_ptrInputStreamInfo::get__NewEnum](#vectorofshared_ptrinputstreaminfoget__newenum)
  - [VectorOfShared_ptrInputStreamInfo::push_back](#vectorofshared_ptrinputstreaminfopush_back)
  - [VectorOfShared_ptrInputStreamInfo::push_vector](#vectorofshared_ptrinputstreaminfopush_vector)
  - [VectorOfShared_ptrInputStreamInfo::put_Item](#vectorofshared_ptrinputstreaminfoput_item)
  - [VectorOfShared_ptrInputStreamInfo::size](#vectorofshared_ptrinputstreaminfosize)
  - [VectorOfShared_ptrInputStreamInfo::slice](#vectorofshared_ptrinputstreaminfoslice)
  - [VectorOfShared_ptrInputStreamInfo::sort](#vectorofshared_ptrinputstreaminfosort)
  - [VectorOfShared_ptrInputStreamInfo::sort_variant](#vectorofshared_ptrinputstreaminfosort_variant)
  - [VectorOfShared_ptrInputStreamInfo::start](#vectorofshared_ptrinputstreaminfostart)
- [VectorOfShared_ptrInterval](#vectorofshared_ptrinterval)
  - [VectorOfShared_ptrInterval::create](#vectorofshared_ptrintervalcreate)
  - [VectorOfShared_ptrInterval::Add](#vectorofshared_ptrintervaladd)
  - [VectorOfShared_ptrInterval::Items](#vectorofshared_ptrintervalitems)
  - [VectorOfShared_ptrInterval::Keys](#vectorofshared_ptrintervalkeys)
  - [VectorOfShared_ptrInterval::Remove](#vectorofshared_ptrintervalremove)
  - [VectorOfShared_ptrInterval::at](#vectorofshared_ptrintervalat)
  - [VectorOfShared_ptrInterval::clear](#vectorofshared_ptrintervalclear)
  - [VectorOfShared_ptrInterval::empty](#vectorofshared_ptrintervalempty)
  - [VectorOfShared_ptrInterval::end](#vectorofshared_ptrintervalend)
  - [VectorOfShared_ptrInterval::get_Item](#vectorofshared_ptrintervalget_item)
  - [VectorOfShared_ptrInterval::get__NewEnum](#vectorofshared_ptrintervalget__newenum)
  - [VectorOfShared_ptrInterval::push_back](#vectorofshared_ptrintervalpush_back)
  - [VectorOfShared_ptrInterval::push_vector](#vectorofshared_ptrintervalpush_vector)
  - [VectorOfShared_ptrInterval::put_Item](#vectorofshared_ptrintervalput_item)
  - [VectorOfShared_ptrInterval::size](#vectorofshared_ptrintervalsize)
  - [VectorOfShared_ptrInterval::slice](#vectorofshared_ptrintervalslice)
  - [VectorOfShared_ptrInterval::sort](#vectorofshared_ptrintervalsort)
  - [VectorOfShared_ptrInterval::sort_variant](#vectorofshared_ptrintervalsort_variant)
  - [VectorOfShared_ptrInterval::start](#vectorofshared_ptrintervalstart)
- [VectorOfShared_ptrRelativeKeypoint](#vectorofshared_ptrrelativekeypoint)
  - [VectorOfShared_ptrRelativeKeypoint::create](#vectorofshared_ptrrelativekeypointcreate)
  - [VectorOfShared_ptrRelativeKeypoint::Add](#vectorofshared_ptrrelativekeypointadd)
  - [VectorOfShared_ptrRelativeKeypoint::Items](#vectorofshared_ptrrelativekeypointitems)
  - [VectorOfShared_ptrRelativeKeypoint::Keys](#vectorofshared_ptrrelativekeypointkeys)
  - [VectorOfShared_ptrRelativeKeypoint::Remove](#vectorofshared_ptrrelativekeypointremove)
  - [VectorOfShared_ptrRelativeKeypoint::at](#vectorofshared_ptrrelativekeypointat)
  - [VectorOfShared_ptrRelativeKeypoint::clear](#vectorofshared_ptrrelativekeypointclear)
  - [VectorOfShared_ptrRelativeKeypoint::empty](#vectorofshared_ptrrelativekeypointempty)
  - [VectorOfShared_ptrRelativeKeypoint::end](#vectorofshared_ptrrelativekeypointend)
  - [VectorOfShared_ptrRelativeKeypoint::get_Item](#vectorofshared_ptrrelativekeypointget_item)
  - [VectorOfShared_ptrRelativeKeypoint::get__NewEnum](#vectorofshared_ptrrelativekeypointget__newenum)
  - [VectorOfShared_ptrRelativeKeypoint::push_back](#vectorofshared_ptrrelativekeypointpush_back)
  - [VectorOfShared_ptrRelativeKeypoint::push_vector](#vectorofshared_ptrrelativekeypointpush_vector)
  - [VectorOfShared_ptrRelativeKeypoint::put_Item](#vectorofshared_ptrrelativekeypointput_item)
  - [VectorOfShared_ptrRelativeKeypoint::size](#vectorofshared_ptrrelativekeypointsize)
  - [VectorOfShared_ptrRelativeKeypoint::slice](#vectorofshared_ptrrelativekeypointslice)
  - [VectorOfShared_ptrRelativeKeypoint::sort](#vectorofshared_ptrrelativekeypointsort)
  - [VectorOfShared_ptrRelativeKeypoint::sort_variant](#vectorofshared_ptrrelativekeypointsort_variant)
  - [VectorOfShared_ptrRelativeKeypoint::start](#vectorofshared_ptrrelativekeypointstart)
- [VectorOfShared_ptrAssociatedDetection](#vectorofshared_ptrassociateddetection)
  - [VectorOfShared_ptrAssociatedDetection::create](#vectorofshared_ptrassociateddetectioncreate)
  - [VectorOfShared_ptrAssociatedDetection::Add](#vectorofshared_ptrassociateddetectionadd)
  - [VectorOfShared_ptrAssociatedDetection::Items](#vectorofshared_ptrassociateddetectionitems)
  - [VectorOfShared_ptrAssociatedDetection::Keys](#vectorofshared_ptrassociateddetectionkeys)
  - [VectorOfShared_ptrAssociatedDetection::Remove](#vectorofshared_ptrassociateddetectionremove)
  - [VectorOfShared_ptrAssociatedDetection::at](#vectorofshared_ptrassociateddetectionat)
  - [VectorOfShared_ptrAssociatedDetection::clear](#vectorofshared_ptrassociateddetectionclear)
  - [VectorOfShared_ptrAssociatedDetection::empty](#vectorofshared_ptrassociateddetectionempty)
  - [VectorOfShared_ptrAssociatedDetection::end](#vectorofshared_ptrassociateddetectionend)
  - [VectorOfShared_ptrAssociatedDetection::get_Item](#vectorofshared_ptrassociateddetectionget_item)
  - [VectorOfShared_ptrAssociatedDetection::get__NewEnum](#vectorofshared_ptrassociateddetectionget__newenum)
  - [VectorOfShared_ptrAssociatedDetection::push_back](#vectorofshared_ptrassociateddetectionpush_back)
  - [VectorOfShared_ptrAssociatedDetection::push_vector](#vectorofshared_ptrassociateddetectionpush_vector)
  - [VectorOfShared_ptrAssociatedDetection::put_Item](#vectorofshared_ptrassociateddetectionput_item)
  - [VectorOfShared_ptrAssociatedDetection::size](#vectorofshared_ptrassociateddetectionsize)
  - [VectorOfShared_ptrAssociatedDetection::slice](#vectorofshared_ptrassociateddetectionslice)
  - [VectorOfShared_ptrAssociatedDetection::sort](#vectorofshared_ptrassociateddetectionsort)
  - [VectorOfShared_ptrAssociatedDetection::sort_variant](#vectorofshared_ptrassociateddetectionsort_variant)
  - [VectorOfShared_ptrAssociatedDetection::start](#vectorofshared_ptrassociateddetectionstart)
- [VectorOfShared_ptrDetection](#vectorofshared_ptrdetection)
  - [VectorOfShared_ptrDetection::create](#vectorofshared_ptrdetectioncreate)
  - [VectorOfShared_ptrDetection::Add](#vectorofshared_ptrdetectionadd)
  - [VectorOfShared_ptrDetection::Items](#vectorofshared_ptrdetectionitems)
  - [VectorOfShared_ptrDetection::Keys](#vectorofshared_ptrdetectionkeys)
  - [VectorOfShared_ptrDetection::Remove](#vectorofshared_ptrdetectionremove)
  - [VectorOfShared_ptrDetection::at](#vectorofshared_ptrdetectionat)
  - [VectorOfShared_ptrDetection::clear](#vectorofshared_ptrdetectionclear)
  - [VectorOfShared_ptrDetection::empty](#vectorofshared_ptrdetectionempty)
  - [VectorOfShared_ptrDetection::end](#vectorofshared_ptrdetectionend)
  - [VectorOfShared_ptrDetection::get_Item](#vectorofshared_ptrdetectionget_item)
  - [VectorOfShared_ptrDetection::get__NewEnum](#vectorofshared_ptrdetectionget__newenum)
  - [VectorOfShared_ptrDetection::push_back](#vectorofshared_ptrdetectionpush_back)
  - [VectorOfShared_ptrDetection::push_vector](#vectorofshared_ptrdetectionpush_vector)
  - [VectorOfShared_ptrDetection::put_Item](#vectorofshared_ptrdetectionput_item)
  - [VectorOfShared_ptrDetection::size](#vectorofshared_ptrdetectionsize)
  - [VectorOfShared_ptrDetection::slice](#vectorofshared_ptrdetectionslice)
  - [VectorOfShared_ptrDetection::sort](#vectorofshared_ptrdetectionsort)
  - [VectorOfShared_ptrDetection::sort_variant](#vectorofshared_ptrdetectionsort_variant)
  - [VectorOfShared_ptrDetection::start](#vectorofshared_ptrdetectionstart)
- [VectorOfShared_ptrClassification](#vectorofshared_ptrclassification)
  - [VectorOfShared_ptrClassification::create](#vectorofshared_ptrclassificationcreate)
  - [VectorOfShared_ptrClassification::Add](#vectorofshared_ptrclassificationadd)
  - [VectorOfShared_ptrClassification::Items](#vectorofshared_ptrclassificationitems)
  - [VectorOfShared_ptrClassification::Keys](#vectorofshared_ptrclassificationkeys)
  - [VectorOfShared_ptrClassification::Remove](#vectorofshared_ptrclassificationremove)
  - [VectorOfShared_ptrClassification::at](#vectorofshared_ptrclassificationat)
  - [VectorOfShared_ptrClassification::clear](#vectorofshared_ptrclassificationclear)
  - [VectorOfShared_ptrClassification::empty](#vectorofshared_ptrclassificationempty)
  - [VectorOfShared_ptrClassification::end](#vectorofshared_ptrclassificationend)
  - [VectorOfShared_ptrClassification::get_Item](#vectorofshared_ptrclassificationget_item)
  - [VectorOfShared_ptrClassification::get__NewEnum](#vectorofshared_ptrclassificationget__newenum)
  - [VectorOfShared_ptrClassification::push_back](#vectorofshared_ptrclassificationpush_back)
  - [VectorOfShared_ptrClassification::push_vector](#vectorofshared_ptrclassificationpush_vector)
  - [VectorOfShared_ptrClassification::put_Item](#vectorofshared_ptrclassificationput_item)
  - [VectorOfShared_ptrClassification::size](#vectorofshared_ptrclassificationsize)
  - [VectorOfShared_ptrClassification::slice](#vectorofshared_ptrclassificationslice)
  - [VectorOfShared_ptrClassification::sort](#vectorofshared_ptrclassificationsort)
  - [VectorOfShared_ptrClassification::sort_variant](#vectorofshared_ptrclassificationsort_variant)
  - [VectorOfShared_ptrClassification::start](#vectorofshared_ptrclassificationstart)
- [VectorOfShared_ptrClassificationList](#vectorofshared_ptrclassificationlist)
  - [VectorOfShared_ptrClassificationList::create](#vectorofshared_ptrclassificationlistcreate)
  - [VectorOfShared_ptrClassificationList::Add](#vectorofshared_ptrclassificationlistadd)
  - [VectorOfShared_ptrClassificationList::Items](#vectorofshared_ptrclassificationlistitems)
  - [VectorOfShared_ptrClassificationList::Keys](#vectorofshared_ptrclassificationlistkeys)
  - [VectorOfShared_ptrClassificationList::Remove](#vectorofshared_ptrclassificationlistremove)
  - [VectorOfShared_ptrClassificationList::at](#vectorofshared_ptrclassificationlistat)
  - [VectorOfShared_ptrClassificationList::clear](#vectorofshared_ptrclassificationlistclear)
  - [VectorOfShared_ptrClassificationList::empty](#vectorofshared_ptrclassificationlistempty)
  - [VectorOfShared_ptrClassificationList::end](#vectorofshared_ptrclassificationlistend)
  - [VectorOfShared_ptrClassificationList::get_Item](#vectorofshared_ptrclassificationlistget_item)
  - [VectorOfShared_ptrClassificationList::get__NewEnum](#vectorofshared_ptrclassificationlistget__newenum)
  - [VectorOfShared_ptrClassificationList::push_back](#vectorofshared_ptrclassificationlistpush_back)
  - [VectorOfShared_ptrClassificationList::push_vector](#vectorofshared_ptrclassificationlistpush_vector)
  - [VectorOfShared_ptrClassificationList::put_Item](#vectorofshared_ptrclassificationlistput_item)
  - [VectorOfShared_ptrClassificationList::size](#vectorofshared_ptrclassificationlistsize)
  - [VectorOfShared_ptrClassificationList::slice](#vectorofshared_ptrclassificationlistslice)
  - [VectorOfShared_ptrClassificationList::sort](#vectorofshared_ptrclassificationlistsort)
  - [VectorOfShared_ptrClassificationList::sort_variant](#vectorofshared_ptrclassificationlistsort_variant)
  - [VectorOfShared_ptrClassificationList::start](#vectorofshared_ptrclassificationliststart)
- [VectorOfShared_ptrLandmark](#vectorofshared_ptrlandmark)
  - [VectorOfShared_ptrLandmark::create](#vectorofshared_ptrlandmarkcreate)
  - [VectorOfShared_ptrLandmark::Add](#vectorofshared_ptrlandmarkadd)
  - [VectorOfShared_ptrLandmark::Items](#vectorofshared_ptrlandmarkitems)
  - [VectorOfShared_ptrLandmark::Keys](#vectorofshared_ptrlandmarkkeys)
  - [VectorOfShared_ptrLandmark::Remove](#vectorofshared_ptrlandmarkremove)
  - [VectorOfShared_ptrLandmark::at](#vectorofshared_ptrlandmarkat)
  - [VectorOfShared_ptrLandmark::clear](#vectorofshared_ptrlandmarkclear)
  - [VectorOfShared_ptrLandmark::empty](#vectorofshared_ptrlandmarkempty)
  - [VectorOfShared_ptrLandmark::end](#vectorofshared_ptrlandmarkend)
  - [VectorOfShared_ptrLandmark::get_Item](#vectorofshared_ptrlandmarkget_item)
  - [VectorOfShared_ptrLandmark::get__NewEnum](#vectorofshared_ptrlandmarkget__newenum)
  - [VectorOfShared_ptrLandmark::push_back](#vectorofshared_ptrlandmarkpush_back)
  - [VectorOfShared_ptrLandmark::push_vector](#vectorofshared_ptrlandmarkpush_vector)
  - [VectorOfShared_ptrLandmark::put_Item](#vectorofshared_ptrlandmarkput_item)
  - [VectorOfShared_ptrLandmark::size](#vectorofshared_ptrlandmarksize)
  - [VectorOfShared_ptrLandmark::slice](#vectorofshared_ptrlandmarkslice)
  - [VectorOfShared_ptrLandmark::sort](#vectorofshared_ptrlandmarksort)
  - [VectorOfShared_ptrLandmark::sort_variant](#vectorofshared_ptrlandmarksort_variant)
  - [VectorOfShared_ptrLandmark::start](#vectorofshared_ptrlandmarkstart)
- [VectorOfShared_ptrLandmarkList](#vectorofshared_ptrlandmarklist)
  - [VectorOfShared_ptrLandmarkList::create](#vectorofshared_ptrlandmarklistcreate)
  - [VectorOfShared_ptrLandmarkList::Add](#vectorofshared_ptrlandmarklistadd)
  - [VectorOfShared_ptrLandmarkList::Items](#vectorofshared_ptrlandmarklistitems)
  - [VectorOfShared_ptrLandmarkList::Keys](#vectorofshared_ptrlandmarklistkeys)
  - [VectorOfShared_ptrLandmarkList::Remove](#vectorofshared_ptrlandmarklistremove)
  - [VectorOfShared_ptrLandmarkList::at](#vectorofshared_ptrlandmarklistat)
  - [VectorOfShared_ptrLandmarkList::clear](#vectorofshared_ptrlandmarklistclear)
  - [VectorOfShared_ptrLandmarkList::empty](#vectorofshared_ptrlandmarklistempty)
  - [VectorOfShared_ptrLandmarkList::end](#vectorofshared_ptrlandmarklistend)
  - [VectorOfShared_ptrLandmarkList::get_Item](#vectorofshared_ptrlandmarklistget_item)
  - [VectorOfShared_ptrLandmarkList::get__NewEnum](#vectorofshared_ptrlandmarklistget__newenum)
  - [VectorOfShared_ptrLandmarkList::push_back](#vectorofshared_ptrlandmarklistpush_back)
  - [VectorOfShared_ptrLandmarkList::push_vector](#vectorofshared_ptrlandmarklistpush_vector)
  - [VectorOfShared_ptrLandmarkList::put_Item](#vectorofshared_ptrlandmarklistput_item)
  - [VectorOfShared_ptrLandmarkList::size](#vectorofshared_ptrlandmarklistsize)
  - [VectorOfShared_ptrLandmarkList::slice](#vectorofshared_ptrlandmarklistslice)
  - [VectorOfShared_ptrLandmarkList::sort](#vectorofshared_ptrlandmarklistsort)
  - [VectorOfShared_ptrLandmarkList::sort_variant](#vectorofshared_ptrlandmarklistsort_variant)
  - [VectorOfShared_ptrLandmarkList::start](#vectorofshared_ptrlandmarkliststart)
- [VectorOfShared_ptrNormalizedLandmark](#vectorofshared_ptrnormalizedlandmark)
  - [VectorOfShared_ptrNormalizedLandmark::create](#vectorofshared_ptrnormalizedlandmarkcreate)
  - [VectorOfShared_ptrNormalizedLandmark::Add](#vectorofshared_ptrnormalizedlandmarkadd)
  - [VectorOfShared_ptrNormalizedLandmark::Items](#vectorofshared_ptrnormalizedlandmarkitems)
  - [VectorOfShared_ptrNormalizedLandmark::Keys](#vectorofshared_ptrnormalizedlandmarkkeys)
  - [VectorOfShared_ptrNormalizedLandmark::Remove](#vectorofshared_ptrnormalizedlandmarkremove)
  - [VectorOfShared_ptrNormalizedLandmark::at](#vectorofshared_ptrnormalizedlandmarkat)
  - [VectorOfShared_ptrNormalizedLandmark::clear](#vectorofshared_ptrnormalizedlandmarkclear)
  - [VectorOfShared_ptrNormalizedLandmark::empty](#vectorofshared_ptrnormalizedlandmarkempty)
  - [VectorOfShared_ptrNormalizedLandmark::end](#vectorofshared_ptrnormalizedlandmarkend)
  - [VectorOfShared_ptrNormalizedLandmark::get_Item](#vectorofshared_ptrnormalizedlandmarkget_item)
  - [VectorOfShared_ptrNormalizedLandmark::get__NewEnum](#vectorofshared_ptrnormalizedlandmarkget__newenum)
  - [VectorOfShared_ptrNormalizedLandmark::push_back](#vectorofshared_ptrnormalizedlandmarkpush_back)
  - [VectorOfShared_ptrNormalizedLandmark::push_vector](#vectorofshared_ptrnormalizedlandmarkpush_vector)
  - [VectorOfShared_ptrNormalizedLandmark::put_Item](#vectorofshared_ptrnormalizedlandmarkput_item)
  - [VectorOfShared_ptrNormalizedLandmark::size](#vectorofshared_ptrnormalizedlandmarksize)
  - [VectorOfShared_ptrNormalizedLandmark::slice](#vectorofshared_ptrnormalizedlandmarkslice)
  - [VectorOfShared_ptrNormalizedLandmark::sort](#vectorofshared_ptrnormalizedlandmarksort)
  - [VectorOfShared_ptrNormalizedLandmark::sort_variant](#vectorofshared_ptrnormalizedlandmarksort_variant)
  - [VectorOfShared_ptrNormalizedLandmark::start](#vectorofshared_ptrnormalizedlandmarkstart)
- [VectorOfShared_ptrNormalizedLandmarkList](#vectorofshared_ptrnormalizedlandmarklist)
  - [VectorOfShared_ptrNormalizedLandmarkList::create](#vectorofshared_ptrnormalizedlandmarklistcreate)
  - [VectorOfShared_ptrNormalizedLandmarkList::Add](#vectorofshared_ptrnormalizedlandmarklistadd)
  - [VectorOfShared_ptrNormalizedLandmarkList::Items](#vectorofshared_ptrnormalizedlandmarklistitems)
  - [VectorOfShared_ptrNormalizedLandmarkList::Keys](#vectorofshared_ptrnormalizedlandmarklistkeys)
  - [VectorOfShared_ptrNormalizedLandmarkList::Remove](#vectorofshared_ptrnormalizedlandmarklistremove)
  - [VectorOfShared_ptrNormalizedLandmarkList::at](#vectorofshared_ptrnormalizedlandmarklistat)
  - [VectorOfShared_ptrNormalizedLandmarkList::clear](#vectorofshared_ptrnormalizedlandmarklistclear)
  - [VectorOfShared_ptrNormalizedLandmarkList::empty](#vectorofshared_ptrnormalizedlandmarklistempty)
  - [VectorOfShared_ptrNormalizedLandmarkList::end](#vectorofshared_ptrnormalizedlandmarklistend)
  - [VectorOfShared_ptrNormalizedLandmarkList::get_Item](#vectorofshared_ptrnormalizedlandmarklistget_item)
  - [VectorOfShared_ptrNormalizedLandmarkList::get__NewEnum](#vectorofshared_ptrnormalizedlandmarklistget__newenum)
  - [VectorOfShared_ptrNormalizedLandmarkList::push_back](#vectorofshared_ptrnormalizedlandmarklistpush_back)
  - [VectorOfShared_ptrNormalizedLandmarkList::push_vector](#vectorofshared_ptrnormalizedlandmarklistpush_vector)
  - [VectorOfShared_ptrNormalizedLandmarkList::put_Item](#vectorofshared_ptrnormalizedlandmarklistput_item)
  - [VectorOfShared_ptrNormalizedLandmarkList::size](#vectorofshared_ptrnormalizedlandmarklistsize)
  - [VectorOfShared_ptrNormalizedLandmarkList::slice](#vectorofshared_ptrnormalizedlandmarklistslice)
  - [VectorOfShared_ptrNormalizedLandmarkList::sort](#vectorofshared_ptrnormalizedlandmarklistsort)
  - [VectorOfShared_ptrNormalizedLandmarkList::sort_variant](#vectorofshared_ptrnormalizedlandmarklistsort_variant)
  - [VectorOfShared_ptrNormalizedLandmarkList::start](#vectorofshared_ptrnormalizedlandmarkliststart)
- [VectorOfShared_ptrConstantSidePacket](#vectorofshared_ptrconstantsidepacket)
  - [VectorOfShared_ptrConstantSidePacket::create](#vectorofshared_ptrconstantsidepacketcreate)
  - [VectorOfShared_ptrConstantSidePacket::Add](#vectorofshared_ptrconstantsidepacketadd)
  - [VectorOfShared_ptrConstantSidePacket::Items](#vectorofshared_ptrconstantsidepacketitems)
  - [VectorOfShared_ptrConstantSidePacket::Keys](#vectorofshared_ptrconstantsidepacketkeys)
  - [VectorOfShared_ptrConstantSidePacket::Remove](#vectorofshared_ptrconstantsidepacketremove)
  - [VectorOfShared_ptrConstantSidePacket::at](#vectorofshared_ptrconstantsidepacketat)
  - [VectorOfShared_ptrConstantSidePacket::clear](#vectorofshared_ptrconstantsidepacketclear)
  - [VectorOfShared_ptrConstantSidePacket::empty](#vectorofshared_ptrconstantsidepacketempty)
  - [VectorOfShared_ptrConstantSidePacket::end](#vectorofshared_ptrconstantsidepacketend)
  - [VectorOfShared_ptrConstantSidePacket::get_Item](#vectorofshared_ptrconstantsidepacketget_item)
  - [VectorOfShared_ptrConstantSidePacket::get__NewEnum](#vectorofshared_ptrconstantsidepacketget__newenum)
  - [VectorOfShared_ptrConstantSidePacket::push_back](#vectorofshared_ptrconstantsidepacketpush_back)
  - [VectorOfShared_ptrConstantSidePacket::push_vector](#vectorofshared_ptrconstantsidepacketpush_vector)
  - [VectorOfShared_ptrConstantSidePacket::put_Item](#vectorofshared_ptrconstantsidepacketput_item)
  - [VectorOfShared_ptrConstantSidePacket::size](#vectorofshared_ptrconstantsidepacketsize)
  - [VectorOfShared_ptrConstantSidePacket::slice](#vectorofshared_ptrconstantsidepacketslice)
  - [VectorOfShared_ptrConstantSidePacket::sort](#vectorofshared_ptrconstantsidepacketsort)
  - [VectorOfShared_ptrConstantSidePacket::sort_variant](#vectorofshared_ptrconstantsidepacketsort_variant)
  - [VectorOfShared_ptrConstantSidePacket::start](#vectorofshared_ptrconstantsidepacketstart)
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
  - [VectorOfPairOfStringAndPacket::get__NewEnum](#vectorofpairofstringandpacketget__newenum)
  - [VectorOfPairOfStringAndPacket::push_back](#vectorofpairofstringandpacketpush_back)
  - [VectorOfPairOfStringAndPacket::push_vector](#vectorofpairofstringandpacketpush_vector)
  - [VectorOfPairOfStringAndPacket::put_Item](#vectorofpairofstringandpacketput_item)
  - [VectorOfPairOfStringAndPacket::size](#vectorofpairofstringandpacketsize)
  - [VectorOfPairOfStringAndPacket::slice](#vectorofpairofstringandpacketslice)
  - [VectorOfPairOfStringAndPacket::sort](#vectorofpairofstringandpacketsort)
  - [VectorOfPairOfStringAndPacket::sort_variant](#vectorofpairofstringandpacketsort_variant)
  - [VectorOfPairOfStringAndPacket::start](#vectorofpairofstringandpacketstart)
- [VectorOfPairOfStringAndPacketDataType](#vectorofpairofstringandpacketdatatype)
  - [VectorOfPairOfStringAndPacketDataType::create](#vectorofpairofstringandpacketdatatypecreate)
  - [VectorOfPairOfStringAndPacketDataType::Add](#vectorofpairofstringandpacketdatatypeadd)
  - [VectorOfPairOfStringAndPacketDataType::Items](#vectorofpairofstringandpacketdatatypeitems)
  - [VectorOfPairOfStringAndPacketDataType::Keys](#vectorofpairofstringandpacketdatatypekeys)
  - [VectorOfPairOfStringAndPacketDataType::Remove](#vectorofpairofstringandpacketdatatyperemove)
  - [VectorOfPairOfStringAndPacketDataType::at](#vectorofpairofstringandpacketdatatypeat)
  - [VectorOfPairOfStringAndPacketDataType::clear](#vectorofpairofstringandpacketdatatypeclear)
  - [VectorOfPairOfStringAndPacketDataType::empty](#vectorofpairofstringandpacketdatatypeempty)
  - [VectorOfPairOfStringAndPacketDataType::end](#vectorofpairofstringandpacketdatatypeend)
  - [VectorOfPairOfStringAndPacketDataType::get_Item](#vectorofpairofstringandpacketdatatypeget_item)
  - [VectorOfPairOfStringAndPacketDataType::get__NewEnum](#vectorofpairofstringandpacketdatatypeget__newenum)
  - [VectorOfPairOfStringAndPacketDataType::push_back](#vectorofpairofstringandpacketdatatypepush_back)
  - [VectorOfPairOfStringAndPacketDataType::push_vector](#vectorofpairofstringandpacketdatatypepush_vector)
  - [VectorOfPairOfStringAndPacketDataType::put_Item](#vectorofpairofstringandpacketdatatypeput_item)
  - [VectorOfPairOfStringAndPacketDataType::size](#vectorofpairofstringandpacketdatatypesize)
  - [VectorOfPairOfStringAndPacketDataType::slice](#vectorofpairofstringandpacketdatatypeslice)
  - [VectorOfPairOfStringAndPacketDataType::sort](#vectorofpairofstringandpacketdatatypesort)
  - [VectorOfPairOfStringAndPacketDataType::sort_variant](#vectorofpairofstringandpacketdatatypesort_variant)
  - [VectorOfPairOfStringAndPacketDataType::start](#vectorofpairofstringandpacketdatatypestart)
- [VectorOfPacketDataType](#vectorofpacketdatatype)
  - [VectorOfPacketDataType::create](#vectorofpacketdatatypecreate)
  - [VectorOfPacketDataType::Add](#vectorofpacketdatatypeadd)
  - [VectorOfPacketDataType::Items](#vectorofpacketdatatypeitems)
  - [VectorOfPacketDataType::Keys](#vectorofpacketdatatypekeys)
  - [VectorOfPacketDataType::Remove](#vectorofpacketdatatyperemove)
  - [VectorOfPacketDataType::at](#vectorofpacketdatatypeat)
  - [VectorOfPacketDataType::clear](#vectorofpacketdatatypeclear)
  - [VectorOfPacketDataType::empty](#vectorofpacketdatatypeempty)
  - [VectorOfPacketDataType::end](#vectorofpacketdatatypeend)
  - [VectorOfPacketDataType::get_Item](#vectorofpacketdatatypeget_item)
  - [VectorOfPacketDataType::get__NewEnum](#vectorofpacketdatatypeget__newenum)
  - [VectorOfPacketDataType::push_back](#vectorofpacketdatatypepush_back)
  - [VectorOfPacketDataType::push_vector](#vectorofpacketdatatypepush_vector)
  - [VectorOfPacketDataType::put_Item](#vectorofpacketdatatypeput_item)
  - [VectorOfPacketDataType::size](#vectorofpacketdatatypesize)
  - [VectorOfPacketDataType::slice](#vectorofpacketdatatypeslice)
  - [VectorOfPacketDataType::sort](#vectorofpacketdatatypesort)
  - [VectorOfPacketDataType::sort_variant](#vectorofpacketdatatypesort_variant)
  - [VectorOfPacketDataType::start](#vectorofpacketdatatypestart)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## google::protobuf::autoit::MapContainer

### google::protobuf::autoit::MapContainer::create

```cpp
static google::protobuf::autoit::MapContainer google::protobuf::autoit::MapContainer::create();
AutoIt:
    _Mediapipe_ObjCreate("google.protobuf.autoit.MapContainer").create() -> <google.protobuf.autoit.MapContainer object>
```

```cpp
static google::protobuf::autoit::MapContainer google::protobuf::autoit::MapContainer::create( const google::protobuf::autoit::MapContainer& other );
AutoIt:
    _Mediapipe_ObjCreate("google.protobuf.autoit.MapContainer").create( $other ) -> <google.protobuf.autoit.MapContainer object>
```

### google::protobuf::autoit::MapContainer::MergeFrom

```cpp
void google::protobuf::autoit::MapContainer::MergeFrom( const google::protobuf::autoit::MapContainer& other );
AutoIt:
    $oMapContainer.MergeFrom( $other ) -> None
```

### google::protobuf::autoit::MapContainer::clear

```cpp
void google::protobuf::autoit::MapContainer::clear();
AutoIt:
    $oMapContainer.clear() -> None
```

### google::protobuf::autoit::MapContainer::contains

```cpp
bool google::protobuf::autoit::MapContainer::contains( _variant_t key ) const;
AutoIt:
    $oMapContainer.contains( $key ) -> retval
```

### google::protobuf::autoit::MapContainer::get

```cpp
_variant_t google::protobuf::autoit::MapContainer::get( _variant_t key,
                                                        _variant_t default_value = noValue() ) const;
AutoIt:
    $oMapContainer.get( $key[, $default_value] ) -> retval
```

### google::protobuf::autoit::MapContainer::get_Item

```cpp
_variant_t google::protobuf::autoit::MapContainer::get_Item( _variant_t key ) const;
AutoIt:
    $oMapContainer.Item( $key ) -> retval
    $oMapContainer( $key ) -> retval
```

### google::protobuf::autoit::MapContainer::get__NewEnum

```cpp
IUnknown* google::protobuf::autoit::MapContainer::get__NewEnum();
AutoIt:
    $oMapContainer._NewEnum() -> retval
```

### google::protobuf::autoit::MapContainer::length

```cpp
size_t google::protobuf::autoit::MapContainer::length() const;
AutoIt:
    $oMapContainer.length() -> retval
```

### google::protobuf::autoit::MapContainer::put_Item

```cpp
void google::protobuf::autoit::MapContainer::put_Item( _variant_t key,
                                                       _variant_t arg );
AutoIt:
    $oMapContainer.Item( $key ) = $arg
```

### google::protobuf::autoit::MapContainer::setFields

```cpp
void google::protobuf::autoit::MapContainer::setFields( std::vector<std::pair<_variant_t, _variant_t>>& fields );
AutoIt:
    $oMapContainer.setFields( $fields ) -> None
```

### google::protobuf::autoit::MapContainer::size

```cpp
size_t google::protobuf::autoit::MapContainer::size() const;
AutoIt:
    $oMapContainer.size() -> retval
```

### google::protobuf::autoit::MapContainer::str

```cpp
std::string google::protobuf::autoit::MapContainer::str() const;
AutoIt:
    $oMapContainer.str() -> retval
```

## google::protobuf::autoit::cmessage

### google::protobuf::autoit::cmessage::GetFieldValue

```cpp
_variant_t google::protobuf::autoit::cmessage::GetFieldValue( google::protobuf::Message& message,
                                                              const std::string&         field_name );
AutoIt:
    _Mediapipe_ObjCreate("google.protobuf.autoit.cmessage").GetFieldValue( $message, $field_name ) -> retval
```

### google::protobuf::autoit::cmessage::SetFieldValue

```cpp
int google::protobuf::autoit::cmessage::SetFieldValue( google::protobuf::Message& message,
                                                       const std::string&         field_name,
                                                       const _variant_t&          arg );
AutoIt:
    _Mediapipe_ObjCreate("google.protobuf.autoit.cmessage").SetFieldValue( $message, $field_name, $arg ) -> retval
```

## mediapipe

### mediapipe::variant

```cpp
_variant_t mediapipe::variant( void* ptr );
AutoIt:
    _Mediapipe_ObjCreate("mediapipe").variant( $ptr ) -> retval
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
std::shared_ptr<mediapipe::Packet> mediapipe::autoit::packet_creator::create_image( const mediapipe::Image& data,
                                                                                    bool                    copy = true );
AutoIt:
    _Mediapipe_ObjCreate("mediapipe.autoit.packet_creator").create_image( $data[, $copy] ) -> retval
```

```cpp
std::shared_ptr<mediapipe::Packet> mediapipe::autoit::packet_creator::create_image( const mediapipe::Image&        image,
                                                                                    mediapipe::ImageFormat::Format format,
                                                                                    bool                           copy = true );
AutoIt:
    _Mediapipe_ObjCreate("mediapipe.autoit.packet_creator").create_image( $image, $format[, $copy] ) -> retval
```

```cpp
std::shared_ptr<mediapipe::Packet> mediapipe::autoit::packet_creator::create_image( const cv::Mat& data,
                                                                                    bool           copy = true );
AutoIt:
    _Mediapipe_ObjCreate("mediapipe.autoit.packet_creator").create_image( $data[, $copy] ) -> retval
```

```cpp
std::shared_ptr<mediapipe::Packet> mediapipe::autoit::packet_creator::create_image( const cv::Mat&                 data,
                                                                                    mediapipe::ImageFormat::Format format,
                                                                                    bool                           copy = true );
AutoIt:
    _Mediapipe_ObjCreate("mediapipe.autoit.packet_creator").create_image( $data, $format[, $copy] ) -> retval
```

### mediapipe::autoit::packet_creator::create_image_frame

```cpp
std::shared_ptr<mediapipe::Packet> mediapipe::autoit::packet_creator::create_image_frame( const mediapipe::ImageFrame& data,
                                                                                          bool                         copy = true );
AutoIt:
    _Mediapipe_ObjCreate("mediapipe.autoit.packet_creator").create_image_frame( $data[, $copy] ) -> retval
```

```cpp
std::shared_ptr<mediapipe::Packet> mediapipe::autoit::packet_creator::create_image_frame( const mediapipe::ImageFrame&   data,
                                                                                          mediapipe::ImageFormat::Format format,
                                                                                          bool                           copy = true );
AutoIt:
    _Mediapipe_ObjCreate("mediapipe.autoit.packet_creator").create_image_frame( $data, $format[, $copy] ) -> retval
```

```cpp
std::shared_ptr<mediapipe::Packet> mediapipe::autoit::packet_creator::create_image_frame( const cv::Mat& data,
                                                                                          bool           copy = true );
AutoIt:
    _Mediapipe_ObjCreate("mediapipe.autoit.packet_creator").create_image_frame( $data[, $copy] ) -> retval
```

```cpp
std::shared_ptr<mediapipe::Packet> mediapipe::autoit::packet_creator::create_image_frame( const cv::Mat&                 data,
                                                                                          mediapipe::ImageFormat::Format format,
                                                                                          bool                           copy = true );
AutoIt:
    _Mediapipe_ObjCreate("mediapipe.autoit.packet_creator").create_image_frame( $data, $format[, $copy] ) -> retval
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
std::shared_ptr<mediapipe::Packet> mediapipe::autoit::packet_creator::create_proto( const google::protobuf::Message& message );
AutoIt:
    _Mediapipe_ObjCreate("mediapipe.autoit.packet_creator").create_proto( $message ) -> retval
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
float mediapipe::autoit::packet_getter::get_float( const mediapipe::Packet& packet );
AutoIt:
    _Mediapipe_ObjCreate("mediapipe.autoit.packet_getter").get_float( $packet ) -> retval
```

### mediapipe::autoit::packet_getter::get_float_list

```cpp
std::vector<float> mediapipe::autoit::packet_getter::get_float_list( const mediapipe::Packet& packet );
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
int64 mediapipe::autoit::packet_getter::get_int( const mediapipe::Packet& packet );
AutoIt:
    _Mediapipe_ObjCreate("mediapipe.autoit.packet_getter").get_int( $packet ) -> retval
```

### mediapipe::autoit::packet_getter::get_int_list

```cpp
std::vector<int64> mediapipe::autoit::packet_getter::get_int_list( const mediapipe::Packet& packet );
AutoIt:
    _Mediapipe_ObjCreate("mediapipe.autoit.packet_getter").get_int_list( $packet ) -> retval
```

### mediapipe::autoit::packet_getter::get_packet_list

```cpp
std::vector<mediapipe::Packet> mediapipe::autoit::packet_getter::get_packet_list( mediapipe::Packet& packet );
AutoIt:
    _Mediapipe_ObjCreate("mediapipe.autoit.packet_getter").get_packet_list( $packet ) -> retval
```

### mediapipe::autoit::packet_getter::get_proto

```cpp
std::shared_ptr<google::protobuf::Message> mediapipe::autoit::packet_getter::get_proto( const mediapipe::Packet& packet );
AutoIt:
    _Mediapipe_ObjCreate("mediapipe.autoit.packet_getter").get_proto( $packet ) -> retval
```

### mediapipe::autoit::packet_getter::get_proto_list

```cpp
std::vector<std::shared_ptr<google::protobuf::Message>> mediapipe::autoit::packet_getter::get_proto_list( const mediapipe::Packet& packet );
AutoIt:
    _Mediapipe_ObjCreate("mediapipe.autoit.packet_getter").get_proto_list( $packet ) -> retval
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
uint64 mediapipe::autoit::packet_getter::get_uint( const mediapipe::Packet& packet );
AutoIt:
    _Mediapipe_ObjCreate("mediapipe.autoit.packet_getter").get_uint( $packet ) -> retval
```

## google::protobuf::autoit::RepeatedContainer

### google::protobuf::autoit::RepeatedContainer::create

```cpp
static google::protobuf::autoit::RepeatedContainer google::protobuf::autoit::RepeatedContainer::create();
AutoIt:
    _Mediapipe_ObjCreate("google.protobuf.autoit.RepeatedContainer").create() -> <google.protobuf.autoit.RepeatedContainer object>
```

```cpp
static google::protobuf::autoit::RepeatedContainer google::protobuf::autoit::RepeatedContainer::create( const google::protobuf::autoit::RepeatedContainer& other );
AutoIt:
    _Mediapipe_ObjCreate("google.protobuf.autoit.RepeatedContainer").create( $other ) -> <google.protobuf.autoit.RepeatedContainer object>
```

### google::protobuf::autoit::RepeatedContainer::MergeFrom

```cpp
void google::protobuf::autoit::RepeatedContainer::MergeFrom( const google::protobuf::autoit::RepeatedContainer& other );
AutoIt:
    $oRepeatedContainer.MergeFrom( $other ) -> None
```

```cpp
void google::protobuf::autoit::RepeatedContainer::MergeFrom( const std::vector<_variant_t>& other );
AutoIt:
    $oRepeatedContainer.MergeFrom( $other ) -> None
```

### google::protobuf::autoit::RepeatedContainer::add

```cpp
google::protobuf::Message* google::protobuf::autoit::RepeatedContainer::add( std::map<std::string, _variant_t>& attrs = std::map<std::string, _variant_t>() );
AutoIt:
    $oRepeatedContainer.add( [$attrs] ) -> retval
```

### google::protobuf::autoit::RepeatedContainer::append

```cpp
void google::protobuf::autoit::RepeatedContainer::append( _variant_t item );
AutoIt:
    $oRepeatedContainer.append( $item ) -> None
```

### google::protobuf::autoit::RepeatedContainer::clear

```cpp
void google::protobuf::autoit::RepeatedContainer::clear();
AutoIt:
    $oRepeatedContainer.clear() -> None
```

### google::protobuf::autoit::RepeatedContainer::deepcopy

```cpp
_variant_t google::protobuf::autoit::RepeatedContainer::deepcopy();
AutoIt:
    $oRepeatedContainer.deepcopy() -> retval
```

### google::protobuf::autoit::RepeatedContainer::extend

```cpp
void google::protobuf::autoit::RepeatedContainer::extend( std::vector<_variant_t>& items );
AutoIt:
    $oRepeatedContainer.extend( $items ) -> None
```

### google::protobuf::autoit::RepeatedContainer::get_Item

```cpp
_variant_t google::protobuf::autoit::RepeatedContainer::get_Item( SSIZE_T index ) const;
AutoIt:
    $oRepeatedContainer.Item( $index ) -> retval
    $oRepeatedContainer( $index ) -> retval
```

### google::protobuf::autoit::RepeatedContainer::get__NewEnum

```cpp
IUnknown* google::protobuf::autoit::RepeatedContainer::get__NewEnum();
AutoIt:
    $oRepeatedContainer._NewEnum() -> retval
```

### google::protobuf::autoit::RepeatedContainer::insert

```cpp
void google::protobuf::autoit::RepeatedContainer::insert( SSIZE_T    index,
                                                          _variant_t item );
AutoIt:
    $oRepeatedContainer.insert( $index, $item ) -> None
```

```cpp
void google::protobuf::autoit::RepeatedContainer::insert( std::tuple<SSIZE_T, _variant_t>& args );
AutoIt:
    $oRepeatedContainer.insert( $args ) -> None
```

### google::protobuf::autoit::RepeatedContainer::length

```cpp
size_t google::protobuf::autoit::RepeatedContainer::length() const;
AutoIt:
    $oRepeatedContainer.length() -> retval
```

### google::protobuf::autoit::RepeatedContainer::pop

```cpp
_variant_t google::protobuf::autoit::RepeatedContainer::pop( SSIZE_T index = -1 );
AutoIt:
    $oRepeatedContainer.pop( [$index] ) -> retval
```

### google::protobuf::autoit::RepeatedContainer::put_Item

```cpp
void google::protobuf::autoit::RepeatedContainer::put_Item( SSIZE_T    index,
                                                            _variant_t arg );
AutoIt:
    $oRepeatedContainer.Item( $index ) = $arg
```

### google::protobuf::autoit::RepeatedContainer::reverse

```cpp
void google::protobuf::autoit::RepeatedContainer::reverse();
AutoIt:
    $oRepeatedContainer.reverse() -> None
```

### google::protobuf::autoit::RepeatedContainer::size

```cpp
size_t google::protobuf::autoit::RepeatedContainer::size() const;
AutoIt:
    $oRepeatedContainer.size() -> retval
```

### google::protobuf::autoit::RepeatedContainer::slice

```cpp
void google::protobuf::autoit::RepeatedContainer::slice( std::vector<_variant_t>& list,
                                                         SSIZE_T                  start = 0 ) const;
AutoIt:
    $oRepeatedContainer.slice( [$start[, $list]] ) -> $list
```

```cpp
void google::protobuf::autoit::RepeatedContainer::slice( std::vector<_variant_t>& list,
                                                         SSIZE_T                  start,
                                                         SSIZE_T                  count ) const;
AutoIt:
    $oRepeatedContainer.slice( $start, $count[, $list] ) -> $list
```

### google::protobuf::autoit::RepeatedContainer::sort

```cpp
void google::protobuf::autoit::RepeatedContainer::sort( void* comparator );
AutoIt:
    $oRepeatedContainer.sort( $comparator ) -> None
```

### google::protobuf::autoit::RepeatedContainer::splice

```cpp
void google::protobuf::autoit::RepeatedContainer::splice( std::vector<_variant_t>& list,
                                                          SSIZE_T                  start = 0 );
AutoIt:
    $oRepeatedContainer.splice( [$start[, $list]] ) -> $list
```

```cpp
void google::protobuf::autoit::RepeatedContainer::splice( std::vector<_variant_t>& list,
                                                          SSIZE_T                  start,
                                                          SSIZE_T                  deleteCount );
AutoIt:
    $oRepeatedContainer.splice( $start, $deleteCount[, $list] ) -> $list
```

### google::protobuf::autoit::RepeatedContainer::str

```cpp
std::string google::protobuf::autoit::RepeatedContainer::str() const;
AutoIt:
    $oRepeatedContainer.str() -> retval
```

## mediapipe::resource_util

### mediapipe::resource_util::set_resource_dir

```cpp
void mediapipe::resource_util::set_resource_dir( const std::string& str );
AutoIt:
    _Mediapipe_ObjCreate("mediapipe.resource_util").set_resource_dir( $str ) -> None
```

## mediapipe::autoit::solution_base::SolutionBase

### mediapipe::autoit::solution_base::SolutionBase::get_create

```cpp
static mediapipe::autoit::solution_base::SolutionBase mediapipe::autoit::solution_base::SolutionBase::get_create( const mediapipe::CalculatorGraphConfig&                                        graph_config,
                                                                                                                  const std::map<std::string, _variant_t>&                                       calculator_params = noMap(),
                                                                                                                  const google::protobuf::Message*                                               graph_options = nullptr,
                                                                                                                  const std::map<std::string, _variant_t>&                                       side_inputs = noMap(),
                                                                                                                  const std::vector<std::string>&                                                outputs = noVector(),
                                                                                                                  const std::map<std::string, mediapipe::autoit::solution_base::PacketDataType>& stream_type_hints = noTypeMap() );
AutoIt:
    _Mediapipe_ObjCreate("mediapipe.autoit.solution_base.SolutionBase").create( $graph_config[, $calculator_params[, $graph_options[, $side_inputs[, $outputs[, $stream_type_hints]]]]] ) -> <mediapipe.autoit.solution_base.SolutionBase object>
    _Mediapipe_ObjCreate("mediapipe.autoit.solution_base.SolutionBase")( $graph_config[, $calculator_params[, $graph_options[, $side_inputs[, $outputs[, $stream_type_hints]]]]] ) -> <mediapipe.autoit.solution_base.SolutionBase object>
```

```cpp
static mediapipe::autoit::solution_base::SolutionBase mediapipe::autoit::solution_base::SolutionBase::get_create( const std::string&                                                             binary_graph_path,
                                                                                                                  const std::map<std::string, _variant_t>&                                       calculator_params = noMap(),
                                                                                                                  const google::protobuf::Message*                                               graph_options = nullptr,
                                                                                                                  const std::map<std::string, _variant_t>&                                       side_inputs = noMap(),
                                                                                                                  const std::vector<std::string>&                                                outputs = noVector(),
                                                                                                                  const std::map<std::string, mediapipe::autoit::solution_base::PacketDataType>& stream_type_hints = noTypeMap() );
AutoIt:
    _Mediapipe_ObjCreate("mediapipe.autoit.solution_base.SolutionBase").create( $binary_graph_path[, $calculator_params[, $graph_options[, $side_inputs[, $outputs[, $stream_type_hints]]]]] ) -> <mediapipe.autoit.solution_base.SolutionBase object>
    _Mediapipe_ObjCreate("mediapipe.autoit.solution_base.SolutionBase")( $binary_graph_path[, $calculator_params[, $graph_options[, $side_inputs[, $outputs[, $stream_type_hints]]]]] ) -> <mediapipe.autoit.solution_base.SolutionBase object>
```

### mediapipe::autoit::solution_base::SolutionBase::process

```cpp
void mediapipe::autoit::solution_base::SolutionBase::process( const cv::Mat&                     input_data,
                                                              std::map<std::string, _variant_t>& solution_outputs );
AutoIt:
    $oSolutionBase.process( $input_data[, $solution_outputs] ) -> $solution_outputs
```

```cpp
void mediapipe::autoit::solution_base::SolutionBase::process( const std::map<std::string, _variant_t>& input_dict,
                                                              std::map<std::string, _variant_t>&       solution_outputs );
AutoIt:
    $oSolutionBase.process( $input_dict[, $solution_outputs] ) -> $solution_outputs
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
void mediapipe::CalculatorGraph::observe_output_stream( std::string                             stream_name,
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

## mediapipe::Image

### mediapipe::Image::get_create

```cpp
static mediapipe::Image mediapipe::Image::get_create();
AutoIt:
    _Mediapipe_ObjCreate("mediapipe.Image").create() -> <mediapipe.Image object>
    _Mediapipe_ObjCreate("mediapipe.Image")() -> <mediapipe.Image object>
```

```cpp
static std::shared_ptr<mediapipe::Image> mediapipe::Image::get_create( mediapipe::ImageFormat::Format image_format,
                                                                       const cv::Mat&                 image,
                                                                       bool                           copy = true );
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
static std::shared_ptr<mediapipe::ImageFrame> mediapipe::ImageFrame::get_create( mediapipe::ImageFormat::Format image_format,
                                                                                 const cv::Mat&                 image,
                                                                                 bool                           copy = true );
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
cv::Mat cv::Mat::convertToShow( cv::Mat dst = Mat::zeros(__self->get()->rows, __self->get()->cols, CV_8UC3),
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

## google::protobuf::Message

### google::protobuf::Message::str

```cpp
void google::protobuf::Message::str( std::string* output );
AutoIt:
    $oMessage.str( [$output] ) -> $output
```

## google::protobuf::TextFormat

### google::protobuf::TextFormat::MergeFromString

```cpp
bool google::protobuf::TextFormat::MergeFromString( const std::string&         input,
                                                    google::protobuf::Message* message );
AutoIt:
    _Mediapipe_ObjCreate("google.protobuf.text_format").MergeFromString( $input, $message ) -> retval
```

### google::protobuf::TextFormat::Parse

```cpp
google::protobuf::Message* google::protobuf::TextFormat::Parse( const std::string&         input,
                                                                google::protobuf::Message* message );
AutoIt:
    _Mediapipe_ObjCreate("google.protobuf.text_format").Parse( $input, $message ) -> retval
```

### google::protobuf::TextFormat::ParseFromString

```cpp
bool google::protobuf::TextFormat::ParseFromString( const std::string&         input,
                                                    google::protobuf::Message* message );
AutoIt:
    _Mediapipe_ObjCreate("google.protobuf.text_format").ParseFromString( $input, $message ) -> retval
```

### google::protobuf::TextFormat::Print

```cpp
void google::protobuf::TextFormat::Print( const std::shared_ptr<google::protobuf::Message>& message,
                                          std::string*                                      output );
AutoIt:
    _Mediapipe_ObjCreate("google.protobuf.text_format").Print( $message[, $output] ) -> $output
```

### google::protobuf::TextFormat::PrintToString

```cpp
bool google::protobuf::TextFormat::PrintToString( const std::shared_ptr<google::protobuf::Message>& message,
                                                  std::string*                                      output );
AutoIt:
    _Mediapipe_ObjCreate("google.protobuf.text_format").PrintToString( $message[, $output] ) -> retval, $output
```

## google::protobuf::Any

### google::protobuf::Any::get_create

```cpp
static google::protobuf::Any google::protobuf::Any::get_create();
AutoIt:
    _Mediapipe_ObjCreate("google.protobuf.Any").create() -> <google.protobuf.Any object>
    _Mediapipe_ObjCreate("google.protobuf.Any")() -> <google.protobuf.Any object>
```

### google::protobuf::Any::Pack

```cpp
void google::protobuf::Any::Pack( const google::protobuf::Message& message );
AutoIt:
    $oAny.Pack( $message ) -> None
```

### google::protobuf::Any::Unpack

```cpp
void google::protobuf::Any::Unpack( google::protobuf::Message* message );
AutoIt:
    $oAny.Unpack( $message ) -> None
```

### google::protobuf::Any::str

```cpp
void google::protobuf::Any::str( std::string* output );
AutoIt:
    $oAny.str( [$output] ) -> $output
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

## mediapipe::CalculatorOptions

### mediapipe::CalculatorOptions::get_create

```cpp
static mediapipe::CalculatorOptions mediapipe::CalculatorOptions::get_create();
AutoIt:
    _Mediapipe_ObjCreate("mediapipe.CalculatorOptions").create() -> <mediapipe.CalculatorOptions object>
    _Mediapipe_ObjCreate("mediapipe.CalculatorOptions")() -> <mediapipe.CalculatorOptions object>
```

### mediapipe::CalculatorOptions::get_Extensions

```cpp
mediapipe::ConstantSidePacketCalculatorOptions* mediapipe::CalculatorOptions::get_Extensions( const google::protobuf::autoit::Extend_mediapipe_CalculatorOptionsWithmediapipe_ConstantSidePacketCalculatorOptions& vKey );
AutoIt:
    $oCalculatorOptions.Extensions( $vKey ) -> retval
```

```cpp
mediapipe::ImageTransformationCalculatorOptions* mediapipe::CalculatorOptions::get_Extensions( const google::protobuf::autoit::Extend_mediapipe_CalculatorOptionsWithmediapipe_ImageTransformationCalculatorOptions& vKey );
AutoIt:
    $oCalculatorOptions.Extensions( $vKey ) -> retval
```

```cpp
mediapipe::TensorsToDetectionsCalculatorOptions* mediapipe::CalculatorOptions::get_Extensions( const google::protobuf::autoit::Extend_mediapipe_CalculatorOptionsWithmediapipe_TensorsToDetectionsCalculatorOptions& vKey );
AutoIt:
    $oCalculatorOptions.Extensions( $vKey ) -> retval
```

```cpp
mediapipe::LandmarksSmoothingCalculatorOptions* mediapipe::CalculatorOptions::get_Extensions( const google::protobuf::autoit::Extend_mediapipe_CalculatorOptionsWithmediapipe_LandmarksSmoothingCalculatorOptions& vKey );
AutoIt:
    $oCalculatorOptions.Extensions( $vKey ) -> retval
```

```cpp
mediapipe::LogicCalculatorOptions* mediapipe::CalculatorOptions::get_Extensions( const google::protobuf::autoit::Extend_mediapipe_CalculatorOptionsWithmediapipe_LogicCalculatorOptions& vKey );
AutoIt:
    $oCalculatorOptions.Extensions( $vKey ) -> retval
```

```cpp
mediapipe::ThresholdingCalculatorOptions* mediapipe::CalculatorOptions::get_Extensions( const google::protobuf::autoit::Extend_mediapipe_CalculatorOptionsWithmediapipe_ThresholdingCalculatorOptions& vKey );
AutoIt:
    $oCalculatorOptions.Extensions( $vKey ) -> retval
```

```cpp
mediapipe::Lift2DFrameAnnotationTo3DCalculatorOptions* mediapipe::CalculatorOptions::get_Extensions( const google::protobuf::autoit::Extend_mediapipe_CalculatorOptionsWithmediapipe_Lift2DFrameAnnotationTo3DCalculatorOptions& vKey );
AutoIt:
    $oCalculatorOptions.Extensions( $vKey ) -> retval
```

### mediapipe::CalculatorOptions::str

```cpp
void mediapipe::CalculatorOptions::str( std::string* output );
AutoIt:
    $oCalculatorOptions.str( [$output] ) -> $output
```

## mediapipe::MediaPipeOptions

### mediapipe::MediaPipeOptions::get_create

```cpp
static mediapipe::MediaPipeOptions mediapipe::MediaPipeOptions::get_create();
AutoIt:
    _Mediapipe_ObjCreate("mediapipe.MediaPipeOptions").create() -> <mediapipe.MediaPipeOptions object>
    _Mediapipe_ObjCreate("mediapipe.MediaPipeOptions")() -> <mediapipe.MediaPipeOptions object>
```

### mediapipe::MediaPipeOptions::str

```cpp
void mediapipe::MediaPipeOptions::str( std::string* output );
AutoIt:
    $oMediaPipeOptions.str( [$output] ) -> $output
```

## mediapipe::PacketFactoryOptions

### mediapipe::PacketFactoryOptions::get_create

```cpp
static mediapipe::PacketFactoryOptions mediapipe::PacketFactoryOptions::get_create();
AutoIt:
    _Mediapipe_ObjCreate("mediapipe.PacketFactoryOptions").create() -> <mediapipe.PacketFactoryOptions object>
    _Mediapipe_ObjCreate("mediapipe.PacketFactoryOptions")() -> <mediapipe.PacketFactoryOptions object>
```

### mediapipe::PacketFactoryOptions::str

```cpp
void mediapipe::PacketFactoryOptions::str( std::string* output );
AutoIt:
    $oPacketFactoryOptions.str( [$output] ) -> $output
```

## mediapipe::PacketFactoryConfig

### mediapipe::PacketFactoryConfig::get_create

```cpp
static mediapipe::PacketFactoryConfig mediapipe::PacketFactoryConfig::get_create();
AutoIt:
    _Mediapipe_ObjCreate("mediapipe.PacketFactoryConfig").create() -> <mediapipe.PacketFactoryConfig object>
    _Mediapipe_ObjCreate("mediapipe.PacketFactoryConfig")() -> <mediapipe.PacketFactoryConfig object>
```

### mediapipe::PacketFactoryConfig::str

```cpp
void mediapipe::PacketFactoryConfig::str( std::string* output );
AutoIt:
    $oPacketFactoryConfig.str( [$output] ) -> $output
```

## mediapipe::PacketManagerConfig

### mediapipe::PacketManagerConfig::get_create

```cpp
static mediapipe::PacketManagerConfig mediapipe::PacketManagerConfig::get_create();
AutoIt:
    _Mediapipe_ObjCreate("mediapipe.PacketManagerConfig").create() -> <mediapipe.PacketManagerConfig object>
    _Mediapipe_ObjCreate("mediapipe.PacketManagerConfig")() -> <mediapipe.PacketManagerConfig object>
```

### mediapipe::PacketManagerConfig::str

```cpp
void mediapipe::PacketManagerConfig::str( std::string* output );
AutoIt:
    $oPacketManagerConfig.str( [$output] ) -> $output
```

## google::protobuf::Repeated_mediapipe_PacketFactoryConfig

### google::protobuf::Repeated_mediapipe_PacketFactoryConfig::create

```cpp
static google::protobuf::Repeated_mediapipe_PacketFactoryConfig google::protobuf::Repeated_mediapipe_PacketFactoryConfig::create();
AutoIt:
    _Mediapipe_ObjCreate("google.protobuf.Repeated_mediapipe_PacketFactoryConfig").create() -> <google.protobuf.Repeated_mediapipe_PacketFactoryConfig object>
```

### google::protobuf::Repeated_mediapipe_PacketFactoryConfig::CopyFrom

```cpp
void google::protobuf::Repeated_mediapipe_PacketFactoryConfig::CopyFrom( const google::protobuf::Repeated_mediapipe_PacketFactoryConfig other );
AutoIt:
    $oRepeated_mediapipe_PacketFactoryConfig.CopyFrom( $other ) -> None
```

### google::protobuf::Repeated_mediapipe_PacketFactoryConfig::MergeFrom

```cpp
void google::protobuf::Repeated_mediapipe_PacketFactoryConfig::MergeFrom( const google::protobuf::Repeated_mediapipe_PacketFactoryConfig other );
AutoIt:
    $oRepeated_mediapipe_PacketFactoryConfig.MergeFrom( $other ) -> None
```

### google::protobuf::Repeated_mediapipe_PacketFactoryConfig::Swap

```cpp
void google::protobuf::Repeated_mediapipe_PacketFactoryConfig::Swap( google::protobuf::Repeated_mediapipe_PacketFactoryConfig* other );
AutoIt:
    $oRepeated_mediapipe_PacketFactoryConfig.Swap( $other ) -> None
```

### google::protobuf::Repeated_mediapipe_PacketFactoryConfig::SwapElements

```cpp
void google::protobuf::Repeated_mediapipe_PacketFactoryConfig::SwapElements( int index1,
                                                                             int index2 );
AutoIt:
    $oRepeated_mediapipe_PacketFactoryConfig.SwapElements( $index1, $index2 ) -> None
```

### google::protobuf::Repeated_mediapipe_PacketFactoryConfig::add

```cpp
mediapipe::PacketFactoryConfig* google::protobuf::Repeated_mediapipe_PacketFactoryConfig::add();
AutoIt:
    $oRepeated_mediapipe_PacketFactoryConfig.add() -> retval
```

```cpp
mediapipe::PacketFactoryConfig* google::protobuf::Repeated_mediapipe_PacketFactoryConfig::add( const mediapipe::PacketFactoryConfig* value );
AutoIt:
    $oRepeated_mediapipe_PacketFactoryConfig.add( $value ) -> retval
```

```cpp
mediapipe::PacketFactoryConfig* google::protobuf::Repeated_mediapipe_PacketFactoryConfig::add( std::map<std::string, _variant_t> attrs );
AutoIt:
    $oRepeated_mediapipe_PacketFactoryConfig.add( $attrs ) -> retval
```

### google::protobuf::Repeated_mediapipe_PacketFactoryConfig::clear

```cpp
void google::protobuf::Repeated_mediapipe_PacketFactoryConfig::clear();
AutoIt:
    $oRepeated_mediapipe_PacketFactoryConfig.clear() -> None
```

### google::protobuf::Repeated_mediapipe_PacketFactoryConfig::empty

```cpp
bool google::protobuf::Repeated_mediapipe_PacketFactoryConfig::empty();
AutoIt:
    $oRepeated_mediapipe_PacketFactoryConfig.empty() -> retval
```

### google::protobuf::Repeated_mediapipe_PacketFactoryConfig::extend

```cpp
void google::protobuf::Repeated_mediapipe_PacketFactoryConfig::extend( const google::protobuf::Repeated_mediapipe_PacketFactoryConfig& items );
AutoIt:
    $oRepeated_mediapipe_PacketFactoryConfig.extend( $items ) -> None
```

```cpp
void google::protobuf::Repeated_mediapipe_PacketFactoryConfig::extend( const std::vector<std::shared_ptr<mediapipe::PacketFactoryConfig>>& items );
AutoIt:
    $oRepeated_mediapipe_PacketFactoryConfig.extend( $items ) -> None
```

```cpp
void google::protobuf::Repeated_mediapipe_PacketFactoryConfig::extend( const std::vector<_variant_t>& items );
AutoIt:
    $oRepeated_mediapipe_PacketFactoryConfig.extend( $items ) -> None
```

### google::protobuf::Repeated_mediapipe_PacketFactoryConfig::get_Item

```cpp
mediapipe::PacketFactoryConfig* google::protobuf::Repeated_mediapipe_PacketFactoryConfig::get_Item( int index );
AutoIt:
    $oRepeated_mediapipe_PacketFactoryConfig.Item( $index ) -> retval
    $oRepeated_mediapipe_PacketFactoryConfig( $index ) -> retval
```

### google::protobuf::Repeated_mediapipe_PacketFactoryConfig::get__NewEnum

```cpp
IUnknown* google::protobuf::Repeated_mediapipe_PacketFactoryConfig::get__NewEnum();
AutoIt:
    $oRepeated_mediapipe_PacketFactoryConfig._NewEnum() -> retval
```

### google::protobuf::Repeated_mediapipe_PacketFactoryConfig::insert

```cpp
void google::protobuf::Repeated_mediapipe_PacketFactoryConfig::insert( SSIZE_T                                index,
                                                                       const mediapipe::PacketFactoryConfig*& item );
AutoIt:
    $oRepeated_mediapipe_PacketFactoryConfig.insert( $index, $item ) -> None
```

### google::protobuf::Repeated_mediapipe_PacketFactoryConfig::pop

```cpp
std::shared_ptr<mediapipe::PacketFactoryConfig> google::protobuf::Repeated_mediapipe_PacketFactoryConfig::pop( SSIZE_T index = -1 );
AutoIt:
    $oRepeated_mediapipe_PacketFactoryConfig.pop( [$index] ) -> retval
```

### google::protobuf::Repeated_mediapipe_PacketFactoryConfig::reverse

```cpp
void google::protobuf::Repeated_mediapipe_PacketFactoryConfig::reverse();
AutoIt:
    $oRepeated_mediapipe_PacketFactoryConfig.reverse() -> None
```

### google::protobuf::Repeated_mediapipe_PacketFactoryConfig::size

```cpp
int google::protobuf::Repeated_mediapipe_PacketFactoryConfig::size();
AutoIt:
    $oRepeated_mediapipe_PacketFactoryConfig.size() -> retval
```

### google::protobuf::Repeated_mediapipe_PacketFactoryConfig::slice

```cpp
void google::protobuf::Repeated_mediapipe_PacketFactoryConfig::slice( std::vector<std::shared_ptr<mediapipe::PacketFactoryConfig>> list,
                                                                      SSIZE_T                                                      start,
                                                                      SSIZE_T                                                      count );
AutoIt:
    $oRepeated_mediapipe_PacketFactoryConfig.slice( $start, $count[, $list] ) -> $list
```

```cpp
void google::protobuf::Repeated_mediapipe_PacketFactoryConfig::slice( std::vector<std::shared_ptr<mediapipe::PacketFactoryConfig>> list,
                                                                      SSIZE_T                                                      start = 0 );
AutoIt:
    $oRepeated_mediapipe_PacketFactoryConfig.slice( [$start[, $list]] ) -> $list
```

### google::protobuf::Repeated_mediapipe_PacketFactoryConfig::sort

```cpp
void google::protobuf::Repeated_mediapipe_PacketFactoryConfig::sort( void*  comparator,
                                                                     size_t start = 0,
                                                                     size_t count = __self->get()->size() );
AutoIt:
    $oRepeated_mediapipe_PacketFactoryConfig.sort( $comparator[, $start[, $count]] ) -> None
```

### google::protobuf::Repeated_mediapipe_PacketFactoryConfig::sort_variant

```cpp
void google::protobuf::Repeated_mediapipe_PacketFactoryConfig::sort_variant( void*  comparator,
                                                                             size_t start = 0,
                                                                             size_t count = __self->get()->size() );
AutoIt:
    $oRepeated_mediapipe_PacketFactoryConfig.sort_variant( $comparator[, $start[, $count]] ) -> None
```

### google::protobuf::Repeated_mediapipe_PacketFactoryConfig::splice

```cpp
void google::protobuf::Repeated_mediapipe_PacketFactoryConfig::splice( std::vector<std::shared_ptr<mediapipe::PacketFactoryConfig>> list,
                                                                       SSIZE_T                                                      start,
                                                                       SSIZE_T                                                      deleteCount );
AutoIt:
    $oRepeated_mediapipe_PacketFactoryConfig.splice( $start, $deleteCount[, $list] ) -> $list
```

```cpp
void google::protobuf::Repeated_mediapipe_PacketFactoryConfig::splice( std::vector<std::shared_ptr<mediapipe::PacketFactoryConfig>> list,
                                                                       SSIZE_T                                                      start = 0 );
AutoIt:
    $oRepeated_mediapipe_PacketFactoryConfig.splice( [$start[, $list]] ) -> $list
```

## mediapipe::PacketGeneratorOptions

### mediapipe::PacketGeneratorOptions::get_create

```cpp
static mediapipe::PacketGeneratorOptions mediapipe::PacketGeneratorOptions::get_create();
AutoIt:
    _Mediapipe_ObjCreate("mediapipe.PacketGeneratorOptions").create() -> <mediapipe.PacketGeneratorOptions object>
    _Mediapipe_ObjCreate("mediapipe.PacketGeneratorOptions")() -> <mediapipe.PacketGeneratorOptions object>
```

### mediapipe::PacketGeneratorOptions::str

```cpp
void mediapipe::PacketGeneratorOptions::str( std::string* output );
AutoIt:
    $oPacketGeneratorOptions.str( [$output] ) -> $output
```

## mediapipe::PacketGeneratorConfig

### mediapipe::PacketGeneratorConfig::get_create

```cpp
static mediapipe::PacketGeneratorConfig mediapipe::PacketGeneratorConfig::get_create();
AutoIt:
    _Mediapipe_ObjCreate("mediapipe.PacketGeneratorConfig").create() -> <mediapipe.PacketGeneratorConfig object>
    _Mediapipe_ObjCreate("mediapipe.PacketGeneratorConfig")() -> <mediapipe.PacketGeneratorConfig object>
```

### mediapipe::PacketGeneratorConfig::str

```cpp
void mediapipe::PacketGeneratorConfig::str( std::string* output );
AutoIt:
    $oPacketGeneratorConfig.str( [$output] ) -> $output
```

## google::protobuf::Repeated_std_string

### google::protobuf::Repeated_std_string::create

```cpp
static google::protobuf::Repeated_std_string google::protobuf::Repeated_std_string::create();
AutoIt:
    _Mediapipe_ObjCreate("google.protobuf.Repeated_std_string").create() -> <google.protobuf.Repeated_std_string object>
```

### google::protobuf::Repeated_std_string::CopyFrom

```cpp
void google::protobuf::Repeated_std_string::CopyFrom( const google::protobuf::Repeated_std_string other );
AutoIt:
    $oRepeated_std_string.CopyFrom( $other ) -> None
```

### google::protobuf::Repeated_std_string::MergeFrom

```cpp
void google::protobuf::Repeated_std_string::MergeFrom( const google::protobuf::Repeated_std_string other );
AutoIt:
    $oRepeated_std_string.MergeFrom( $other ) -> None
```

### google::protobuf::Repeated_std_string::Swap

```cpp
void google::protobuf::Repeated_std_string::Swap( google::protobuf::Repeated_std_string* other );
AutoIt:
    $oRepeated_std_string.Swap( $other ) -> None
```

### google::protobuf::Repeated_std_string::SwapElements

```cpp
void google::protobuf::Repeated_std_string::SwapElements( int index1,
                                                          int index2 );
AutoIt:
    $oRepeated_std_string.SwapElements( $index1, $index2 ) -> None
```

### google::protobuf::Repeated_std_string::append

```cpp
void google::protobuf::Repeated_std_string::append( const std::string&& value );
AutoIt:
    $oRepeated_std_string.append( $value ) -> None
```

### google::protobuf::Repeated_std_string::clear

```cpp
void google::protobuf::Repeated_std_string::clear();
AutoIt:
    $oRepeated_std_string.clear() -> None
```

### google::protobuf::Repeated_std_string::empty

```cpp
bool google::protobuf::Repeated_std_string::empty();
AutoIt:
    $oRepeated_std_string.empty() -> retval
```

### google::protobuf::Repeated_std_string::extend

```cpp
void google::protobuf::Repeated_std_string::extend( const google::protobuf::Repeated_std_string& items );
AutoIt:
    $oRepeated_std_string.extend( $items ) -> None
```

```cpp
void google::protobuf::Repeated_std_string::extend( const std::vector<std::string>& items );
AutoIt:
    $oRepeated_std_string.extend( $items ) -> None
```

### google::protobuf::Repeated_std_string::get_Item

```cpp
std::string google::protobuf::Repeated_std_string::get_Item( int index );
AutoIt:
    $oRepeated_std_string.Item( $index ) -> retval
    $oRepeated_std_string( $index ) -> retval
```

### google::protobuf::Repeated_std_string::get__NewEnum

```cpp
IUnknown* google::protobuf::Repeated_std_string::get__NewEnum();
AutoIt:
    $oRepeated_std_string._NewEnum() -> retval
```

### google::protobuf::Repeated_std_string::insert

```cpp
void google::protobuf::Repeated_std_string::insert( SSIZE_T            index,
                                                    const std::string& item );
AutoIt:
    $oRepeated_std_string.insert( $index, $item ) -> None
```

### google::protobuf::Repeated_std_string::pop

```cpp
std::string google::protobuf::Repeated_std_string::pop( SSIZE_T index = -1 );
AutoIt:
    $oRepeated_std_string.pop( [$index] ) -> retval
```

### google::protobuf::Repeated_std_string::reverse

```cpp
void google::protobuf::Repeated_std_string::reverse();
AutoIt:
    $oRepeated_std_string.reverse() -> None
```

### google::protobuf::Repeated_std_string::set

```cpp
void google::protobuf::Repeated_std_string::set( int                index,
                                                 const std::string& value );
AutoIt:
    $oRepeated_std_string.set( $index, $value ) -> None
```

### google::protobuf::Repeated_std_string::size

```cpp
int google::protobuf::Repeated_std_string::size();
AutoIt:
    $oRepeated_std_string.size() -> retval
```

### google::protobuf::Repeated_std_string::slice

```cpp
void google::protobuf::Repeated_std_string::slice( std::vector<std::string> list,
                                                   SSIZE_T                  start,
                                                   SSIZE_T                  deleteCount );
AutoIt:
    $oRepeated_std_string.slice( $start, $deleteCount[, $list] ) -> $list
```

```cpp
void google::protobuf::Repeated_std_string::slice( std::vector<std::string> list,
                                                   SSIZE_T                  start = 0 );
AutoIt:
    $oRepeated_std_string.slice( [$start[, $list]] ) -> $list
```

### google::protobuf::Repeated_std_string::sort

```cpp
void google::protobuf::Repeated_std_string::sort( void*  comparator,
                                                  size_t start = 0,
                                                  size_t count = __self->get()->size() );
AutoIt:
    $oRepeated_std_string.sort( $comparator[, $start[, $count]] ) -> None
```

### google::protobuf::Repeated_std_string::sort_variant

```cpp
void google::protobuf::Repeated_std_string::sort_variant( void*  comparator,
                                                          size_t start = 0,
                                                          size_t count = __self->get()->size() );
AutoIt:
    $oRepeated_std_string.sort_variant( $comparator[, $start[, $count]] ) -> None
```

### google::protobuf::Repeated_std_string::splice

```cpp
void google::protobuf::Repeated_std_string::splice( std::vector<std::string> list,
                                                    SSIZE_T                  start,
                                                    SSIZE_T                  deleteCount );
AutoIt:
    $oRepeated_std_string.splice( $start, $deleteCount[, $list] ) -> $list
```

```cpp
void google::protobuf::Repeated_std_string::splice( std::vector<std::string> list,
                                                    SSIZE_T                  start = 0 );
AutoIt:
    $oRepeated_std_string.splice( [$start[, $list]] ) -> $list
```

## mediapipe::StatusHandlerConfig

### mediapipe::StatusHandlerConfig::get_create

```cpp
static mediapipe::StatusHandlerConfig mediapipe::StatusHandlerConfig::get_create();
AutoIt:
    _Mediapipe_ObjCreate("mediapipe.StatusHandlerConfig").create() -> <mediapipe.StatusHandlerConfig object>
    _Mediapipe_ObjCreate("mediapipe.StatusHandlerConfig")() -> <mediapipe.StatusHandlerConfig object>
```

### mediapipe::StatusHandlerConfig::str

```cpp
void mediapipe::StatusHandlerConfig::str( std::string* output );
AutoIt:
    $oStatusHandlerConfig.str( [$output] ) -> $output
```

## mediapipe::InputStreamHandlerConfig

### mediapipe::InputStreamHandlerConfig::get_create

```cpp
static mediapipe::InputStreamHandlerConfig mediapipe::InputStreamHandlerConfig::get_create();
AutoIt:
    _Mediapipe_ObjCreate("mediapipe.InputStreamHandlerConfig").create() -> <mediapipe.InputStreamHandlerConfig object>
    _Mediapipe_ObjCreate("mediapipe.InputStreamHandlerConfig")() -> <mediapipe.InputStreamHandlerConfig object>
```

### mediapipe::InputStreamHandlerConfig::str

```cpp
void mediapipe::InputStreamHandlerConfig::str( std::string* output );
AutoIt:
    $oInputStreamHandlerConfig.str( [$output] ) -> $output
```

## mediapipe::OutputStreamHandlerConfig

### mediapipe::OutputStreamHandlerConfig::get_create

```cpp
static mediapipe::OutputStreamHandlerConfig mediapipe::OutputStreamHandlerConfig::get_create();
AutoIt:
    _Mediapipe_ObjCreate("mediapipe.OutputStreamHandlerConfig").create() -> <mediapipe.OutputStreamHandlerConfig object>
    _Mediapipe_ObjCreate("mediapipe.OutputStreamHandlerConfig")() -> <mediapipe.OutputStreamHandlerConfig object>
```

### mediapipe::OutputStreamHandlerConfig::str

```cpp
void mediapipe::OutputStreamHandlerConfig::str( std::string* output );
AutoIt:
    $oOutputStreamHandlerConfig.str( [$output] ) -> $output
```

## mediapipe::ExecutorConfig

### mediapipe::ExecutorConfig::get_create

```cpp
static mediapipe::ExecutorConfig mediapipe::ExecutorConfig::get_create();
AutoIt:
    _Mediapipe_ObjCreate("mediapipe.ExecutorConfig").create() -> <mediapipe.ExecutorConfig object>
    _Mediapipe_ObjCreate("mediapipe.ExecutorConfig")() -> <mediapipe.ExecutorConfig object>
```

### mediapipe::ExecutorConfig::str

```cpp
void mediapipe::ExecutorConfig::str( std::string* output );
AutoIt:
    $oExecutorConfig.str( [$output] ) -> $output
```

## mediapipe::InputCollection

### mediapipe::InputCollection::get_create

```cpp
static mediapipe::InputCollection mediapipe::InputCollection::get_create();
AutoIt:
    _Mediapipe_ObjCreate("mediapipe.InputCollection").create() -> <mediapipe.InputCollection object>
    _Mediapipe_ObjCreate("mediapipe.InputCollection")() -> <mediapipe.InputCollection object>
```

### mediapipe::InputCollection::str

```cpp
void mediapipe::InputCollection::str( std::string* output );
AutoIt:
    $oInputCollection.str( [$output] ) -> $output
```

## mediapipe::InputCollectionSet

### mediapipe::InputCollectionSet::get_create

```cpp
static mediapipe::InputCollectionSet mediapipe::InputCollectionSet::get_create();
AutoIt:
    _Mediapipe_ObjCreate("mediapipe.InputCollectionSet").create() -> <mediapipe.InputCollectionSet object>
    _Mediapipe_ObjCreate("mediapipe.InputCollectionSet")() -> <mediapipe.InputCollectionSet object>
```

### mediapipe::InputCollectionSet::str

```cpp
void mediapipe::InputCollectionSet::str( std::string* output );
AutoIt:
    $oInputCollectionSet.str( [$output] ) -> $output
```

## google::protobuf::Repeated_mediapipe_InputCollection

### google::protobuf::Repeated_mediapipe_InputCollection::create

```cpp
static google::protobuf::Repeated_mediapipe_InputCollection google::protobuf::Repeated_mediapipe_InputCollection::create();
AutoIt:
    _Mediapipe_ObjCreate("google.protobuf.Repeated_mediapipe_InputCollection").create() -> <google.protobuf.Repeated_mediapipe_InputCollection object>
```

### google::protobuf::Repeated_mediapipe_InputCollection::CopyFrom

```cpp
void google::protobuf::Repeated_mediapipe_InputCollection::CopyFrom( const google::protobuf::Repeated_mediapipe_InputCollection other );
AutoIt:
    $oRepeated_mediapipe_InputCollection.CopyFrom( $other ) -> None
```

### google::protobuf::Repeated_mediapipe_InputCollection::MergeFrom

```cpp
void google::protobuf::Repeated_mediapipe_InputCollection::MergeFrom( const google::protobuf::Repeated_mediapipe_InputCollection other );
AutoIt:
    $oRepeated_mediapipe_InputCollection.MergeFrom( $other ) -> None
```

### google::protobuf::Repeated_mediapipe_InputCollection::Swap

```cpp
void google::protobuf::Repeated_mediapipe_InputCollection::Swap( google::protobuf::Repeated_mediapipe_InputCollection* other );
AutoIt:
    $oRepeated_mediapipe_InputCollection.Swap( $other ) -> None
```

### google::protobuf::Repeated_mediapipe_InputCollection::SwapElements

```cpp
void google::protobuf::Repeated_mediapipe_InputCollection::SwapElements( int index1,
                                                                         int index2 );
AutoIt:
    $oRepeated_mediapipe_InputCollection.SwapElements( $index1, $index2 ) -> None
```

### google::protobuf::Repeated_mediapipe_InputCollection::add

```cpp
mediapipe::InputCollection* google::protobuf::Repeated_mediapipe_InputCollection::add();
AutoIt:
    $oRepeated_mediapipe_InputCollection.add() -> retval
```

```cpp
mediapipe::InputCollection* google::protobuf::Repeated_mediapipe_InputCollection::add( const mediapipe::InputCollection* value );
AutoIt:
    $oRepeated_mediapipe_InputCollection.add( $value ) -> retval
```

```cpp
mediapipe::InputCollection* google::protobuf::Repeated_mediapipe_InputCollection::add( std::map<std::string, _variant_t> attrs );
AutoIt:
    $oRepeated_mediapipe_InputCollection.add( $attrs ) -> retval
```

### google::protobuf::Repeated_mediapipe_InputCollection::clear

```cpp
void google::protobuf::Repeated_mediapipe_InputCollection::clear();
AutoIt:
    $oRepeated_mediapipe_InputCollection.clear() -> None
```

### google::protobuf::Repeated_mediapipe_InputCollection::empty

```cpp
bool google::protobuf::Repeated_mediapipe_InputCollection::empty();
AutoIt:
    $oRepeated_mediapipe_InputCollection.empty() -> retval
```

### google::protobuf::Repeated_mediapipe_InputCollection::extend

```cpp
void google::protobuf::Repeated_mediapipe_InputCollection::extend( const google::protobuf::Repeated_mediapipe_InputCollection& items );
AutoIt:
    $oRepeated_mediapipe_InputCollection.extend( $items ) -> None
```

```cpp
void google::protobuf::Repeated_mediapipe_InputCollection::extend( const std::vector<std::shared_ptr<mediapipe::InputCollection>>& items );
AutoIt:
    $oRepeated_mediapipe_InputCollection.extend( $items ) -> None
```

```cpp
void google::protobuf::Repeated_mediapipe_InputCollection::extend( const std::vector<_variant_t>& items );
AutoIt:
    $oRepeated_mediapipe_InputCollection.extend( $items ) -> None
```

### google::protobuf::Repeated_mediapipe_InputCollection::get_Item

```cpp
mediapipe::InputCollection* google::protobuf::Repeated_mediapipe_InputCollection::get_Item( int index );
AutoIt:
    $oRepeated_mediapipe_InputCollection.Item( $index ) -> retval
    $oRepeated_mediapipe_InputCollection( $index ) -> retval
```

### google::protobuf::Repeated_mediapipe_InputCollection::get__NewEnum

```cpp
IUnknown* google::protobuf::Repeated_mediapipe_InputCollection::get__NewEnum();
AutoIt:
    $oRepeated_mediapipe_InputCollection._NewEnum() -> retval
```

### google::protobuf::Repeated_mediapipe_InputCollection::insert

```cpp
void google::protobuf::Repeated_mediapipe_InputCollection::insert( SSIZE_T                            index,
                                                                   const mediapipe::InputCollection*& item );
AutoIt:
    $oRepeated_mediapipe_InputCollection.insert( $index, $item ) -> None
```

### google::protobuf::Repeated_mediapipe_InputCollection::pop

```cpp
std::shared_ptr<mediapipe::InputCollection> google::protobuf::Repeated_mediapipe_InputCollection::pop( SSIZE_T index = -1 );
AutoIt:
    $oRepeated_mediapipe_InputCollection.pop( [$index] ) -> retval
```

### google::protobuf::Repeated_mediapipe_InputCollection::reverse

```cpp
void google::protobuf::Repeated_mediapipe_InputCollection::reverse();
AutoIt:
    $oRepeated_mediapipe_InputCollection.reverse() -> None
```

### google::protobuf::Repeated_mediapipe_InputCollection::size

```cpp
int google::protobuf::Repeated_mediapipe_InputCollection::size();
AutoIt:
    $oRepeated_mediapipe_InputCollection.size() -> retval
```

### google::protobuf::Repeated_mediapipe_InputCollection::slice

```cpp
void google::protobuf::Repeated_mediapipe_InputCollection::slice( std::vector<std::shared_ptr<mediapipe::InputCollection>> list,
                                                                  SSIZE_T                                                  start,
                                                                  SSIZE_T                                                  count );
AutoIt:
    $oRepeated_mediapipe_InputCollection.slice( $start, $count[, $list] ) -> $list
```

```cpp
void google::protobuf::Repeated_mediapipe_InputCollection::slice( std::vector<std::shared_ptr<mediapipe::InputCollection>> list,
                                                                  SSIZE_T                                                  start = 0 );
AutoIt:
    $oRepeated_mediapipe_InputCollection.slice( [$start[, $list]] ) -> $list
```

### google::protobuf::Repeated_mediapipe_InputCollection::sort

```cpp
void google::protobuf::Repeated_mediapipe_InputCollection::sort( void*  comparator,
                                                                 size_t start = 0,
                                                                 size_t count = __self->get()->size() );
AutoIt:
    $oRepeated_mediapipe_InputCollection.sort( $comparator[, $start[, $count]] ) -> None
```

### google::protobuf::Repeated_mediapipe_InputCollection::sort_variant

```cpp
void google::protobuf::Repeated_mediapipe_InputCollection::sort_variant( void*  comparator,
                                                                         size_t start = 0,
                                                                         size_t count = __self->get()->size() );
AutoIt:
    $oRepeated_mediapipe_InputCollection.sort_variant( $comparator[, $start[, $count]] ) -> None
```

### google::protobuf::Repeated_mediapipe_InputCollection::splice

```cpp
void google::protobuf::Repeated_mediapipe_InputCollection::splice( std::vector<std::shared_ptr<mediapipe::InputCollection>> list,
                                                                   SSIZE_T                                                  start,
                                                                   SSIZE_T                                                  deleteCount );
AutoIt:
    $oRepeated_mediapipe_InputCollection.splice( $start, $deleteCount[, $list] ) -> $list
```

```cpp
void google::protobuf::Repeated_mediapipe_InputCollection::splice( std::vector<std::shared_ptr<mediapipe::InputCollection>> list,
                                                                   SSIZE_T                                                  start = 0 );
AutoIt:
    $oRepeated_mediapipe_InputCollection.splice( [$start[, $list]] ) -> $list
```

## mediapipe::InputStreamInfo

### mediapipe::InputStreamInfo::get_create

```cpp
static mediapipe::InputStreamInfo mediapipe::InputStreamInfo::get_create();
AutoIt:
    _Mediapipe_ObjCreate("mediapipe.InputStreamInfo").create() -> <mediapipe.InputStreamInfo object>
    _Mediapipe_ObjCreate("mediapipe.InputStreamInfo")() -> <mediapipe.InputStreamInfo object>
```

### mediapipe::InputStreamInfo::str

```cpp
void mediapipe::InputStreamInfo::str( std::string* output );
AutoIt:
    $oInputStreamInfo.str( [$output] ) -> $output
```

## mediapipe::ProfilerConfig

### mediapipe::ProfilerConfig::get_create

```cpp
static mediapipe::ProfilerConfig mediapipe::ProfilerConfig::get_create();
AutoIt:
    _Mediapipe_ObjCreate("mediapipe.ProfilerConfig").create() -> <mediapipe.ProfilerConfig object>
    _Mediapipe_ObjCreate("mediapipe.ProfilerConfig")() -> <mediapipe.ProfilerConfig object>
```

### mediapipe::ProfilerConfig::str

```cpp
void mediapipe::ProfilerConfig::str( std::string* output );
AutoIt:
    $oProfilerConfig.str( [$output] ) -> $output
```

## google::protobuf::Repeated_int

### google::protobuf::Repeated_int::create

```cpp
static google::protobuf::Repeated_int google::protobuf::Repeated_int::create();
AutoIt:
    _Mediapipe_ObjCreate("google.protobuf.Repeated_int").create() -> <google.protobuf.Repeated_int object>
```

### google::protobuf::Repeated_int::CopyFrom

```cpp
void google::protobuf::Repeated_int::CopyFrom( const google::protobuf::Repeated_int other );
AutoIt:
    $oRepeated_int.CopyFrom( $other ) -> None
```

### google::protobuf::Repeated_int::MergeFrom

```cpp
void google::protobuf::Repeated_int::MergeFrom( const google::protobuf::Repeated_int other );
AutoIt:
    $oRepeated_int.MergeFrom( $other ) -> None
```

### google::protobuf::Repeated_int::Swap

```cpp
void google::protobuf::Repeated_int::Swap( google::protobuf::Repeated_int* other );
AutoIt:
    $oRepeated_int.Swap( $other ) -> None
```

### google::protobuf::Repeated_int::SwapElements

```cpp
void google::protobuf::Repeated_int::SwapElements( int index1,
                                                   int index2 );
AutoIt:
    $oRepeated_int.SwapElements( $index1, $index2 ) -> None
```

### google::protobuf::Repeated_int::append

```cpp
void google::protobuf::Repeated_int::append( const int value );
AutoIt:
    $oRepeated_int.append( $value ) -> None
```

### google::protobuf::Repeated_int::clear

```cpp
void google::protobuf::Repeated_int::clear();
AutoIt:
    $oRepeated_int.clear() -> None
```

### google::protobuf::Repeated_int::empty

```cpp
bool google::protobuf::Repeated_int::empty();
AutoIt:
    $oRepeated_int.empty() -> retval
```

### google::protobuf::Repeated_int::extend

```cpp
void google::protobuf::Repeated_int::extend( const google::protobuf::Repeated_int& items );
AutoIt:
    $oRepeated_int.extend( $items ) -> None
```

```cpp
void google::protobuf::Repeated_int::extend( const std::vector<int>& items );
AutoIt:
    $oRepeated_int.extend( $items ) -> None
```

### google::protobuf::Repeated_int::get_Item

```cpp
int google::protobuf::Repeated_int::get_Item( int index );
AutoIt:
    $oRepeated_int.Item( $index ) -> retval
    $oRepeated_int( $index ) -> retval
```

### google::protobuf::Repeated_int::get__NewEnum

```cpp
IUnknown* google::protobuf::Repeated_int::get__NewEnum();
AutoIt:
    $oRepeated_int._NewEnum() -> retval
```

### google::protobuf::Repeated_int::insert

```cpp
void google::protobuf::Repeated_int::insert( SSIZE_T    index,
                                             const int& item );
AutoIt:
    $oRepeated_int.insert( $index, $item ) -> None
```

### google::protobuf::Repeated_int::pop

```cpp
int google::protobuf::Repeated_int::pop( SSIZE_T index = -1 );
AutoIt:
    $oRepeated_int.pop( [$index] ) -> retval
```

### google::protobuf::Repeated_int::reverse

```cpp
void google::protobuf::Repeated_int::reverse();
AutoIt:
    $oRepeated_int.reverse() -> None
```

### google::protobuf::Repeated_int::set

```cpp
void google::protobuf::Repeated_int::set( int        index,
                                          const int& value );
AutoIt:
    $oRepeated_int.set( $index, $value ) -> None
```

### google::protobuf::Repeated_int::size

```cpp
int google::protobuf::Repeated_int::size();
AutoIt:
    $oRepeated_int.size() -> retval
```

### google::protobuf::Repeated_int::slice

```cpp
void google::protobuf::Repeated_int::slice( std::vector<int> list,
                                            SSIZE_T          start,
                                            SSIZE_T          deleteCount );
AutoIt:
    $oRepeated_int.slice( $start, $deleteCount[, $list] ) -> $list
```

```cpp
void google::protobuf::Repeated_int::slice( std::vector<int> list,
                                            SSIZE_T          start = 0 );
AutoIt:
    $oRepeated_int.slice( [$start[, $list]] ) -> $list
```

### google::protobuf::Repeated_int::sort

```cpp
void google::protobuf::Repeated_int::sort( void*  comparator,
                                           size_t start = 0,
                                           size_t count = __self->get()->size() );
AutoIt:
    $oRepeated_int.sort( $comparator[, $start[, $count]] ) -> None
```

### google::protobuf::Repeated_int::sort_variant

```cpp
void google::protobuf::Repeated_int::sort_variant( void*  comparator,
                                                   size_t start = 0,
                                                   size_t count = __self->get()->size() );
AutoIt:
    $oRepeated_int.sort_variant( $comparator[, $start[, $count]] ) -> None
```

### google::protobuf::Repeated_int::splice

```cpp
void google::protobuf::Repeated_int::splice( std::vector<int> list,
                                             SSIZE_T          start,
                                             SSIZE_T          deleteCount );
AutoIt:
    $oRepeated_int.splice( $start, $deleteCount[, $list] ) -> $list
```

```cpp
void google::protobuf::Repeated_int::splice( std::vector<int> list,
                                             SSIZE_T          start = 0 );
AutoIt:
    $oRepeated_int.splice( [$start[, $list]] ) -> $list
```

## mediapipe::CalculatorGraphConfig

### mediapipe::CalculatorGraphConfig::get_create

```cpp
static mediapipe::CalculatorGraphConfig mediapipe::CalculatorGraphConfig::get_create();
AutoIt:
    _Mediapipe_ObjCreate("mediapipe.CalculatorGraphConfig").create() -> <mediapipe.CalculatorGraphConfig object>
    _Mediapipe_ObjCreate("mediapipe.CalculatorGraphConfig")() -> <mediapipe.CalculatorGraphConfig object>
```

### mediapipe::CalculatorGraphConfig::str

```cpp
void mediapipe::CalculatorGraphConfig::str( std::string* output );
AutoIt:
    $oCalculatorGraphConfig.str( [$output] ) -> $output
```

## google::protobuf::Repeated_mediapipe_CalculatorGraphConfig_Node

### google::protobuf::Repeated_mediapipe_CalculatorGraphConfig_Node::create

```cpp
static google::protobuf::Repeated_mediapipe_CalculatorGraphConfig_Node google::protobuf::Repeated_mediapipe_CalculatorGraphConfig_Node::create();
AutoIt:
    _Mediapipe_ObjCreate("google.protobuf.Repeated_mediapipe_CalculatorGraphConfig_Node").create() -> <google.protobuf.Repeated_mediapipe_CalculatorGraphConfig_Node object>
```

### google::protobuf::Repeated_mediapipe_CalculatorGraphConfig_Node::CopyFrom

```cpp
void google::protobuf::Repeated_mediapipe_CalculatorGraphConfig_Node::CopyFrom( const google::protobuf::Repeated_mediapipe_CalculatorGraphConfig_Node other );
AutoIt:
    $oRepeated_mediapipe_CalculatorGraphConfig_Node.CopyFrom( $other ) -> None
```

### google::protobuf::Repeated_mediapipe_CalculatorGraphConfig_Node::MergeFrom

```cpp
void google::protobuf::Repeated_mediapipe_CalculatorGraphConfig_Node::MergeFrom( const google::protobuf::Repeated_mediapipe_CalculatorGraphConfig_Node other );
AutoIt:
    $oRepeated_mediapipe_CalculatorGraphConfig_Node.MergeFrom( $other ) -> None
```

### google::protobuf::Repeated_mediapipe_CalculatorGraphConfig_Node::Swap

```cpp
void google::protobuf::Repeated_mediapipe_CalculatorGraphConfig_Node::Swap( google::protobuf::Repeated_mediapipe_CalculatorGraphConfig_Node* other );
AutoIt:
    $oRepeated_mediapipe_CalculatorGraphConfig_Node.Swap( $other ) -> None
```

### google::protobuf::Repeated_mediapipe_CalculatorGraphConfig_Node::SwapElements

```cpp
void google::protobuf::Repeated_mediapipe_CalculatorGraphConfig_Node::SwapElements( int index1,
                                                                                    int index2 );
AutoIt:
    $oRepeated_mediapipe_CalculatorGraphConfig_Node.SwapElements( $index1, $index2 ) -> None
```

### google::protobuf::Repeated_mediapipe_CalculatorGraphConfig_Node::add

```cpp
mediapipe::CalculatorGraphConfig::Node* google::protobuf::Repeated_mediapipe_CalculatorGraphConfig_Node::add();
AutoIt:
    $oRepeated_mediapipe_CalculatorGraphConfig_Node.add() -> retval
```

```cpp
mediapipe::CalculatorGraphConfig::Node* google::protobuf::Repeated_mediapipe_CalculatorGraphConfig_Node::add( const mediapipe::CalculatorGraphConfig::Node* value );
AutoIt:
    $oRepeated_mediapipe_CalculatorGraphConfig_Node.add( $value ) -> retval
```

```cpp
mediapipe::CalculatorGraphConfig::Node* google::protobuf::Repeated_mediapipe_CalculatorGraphConfig_Node::add( std::map<std::string, _variant_t> attrs );
AutoIt:
    $oRepeated_mediapipe_CalculatorGraphConfig_Node.add( $attrs ) -> retval
```

### google::protobuf::Repeated_mediapipe_CalculatorGraphConfig_Node::clear

```cpp
void google::protobuf::Repeated_mediapipe_CalculatorGraphConfig_Node::clear();
AutoIt:
    $oRepeated_mediapipe_CalculatorGraphConfig_Node.clear() -> None
```

### google::protobuf::Repeated_mediapipe_CalculatorGraphConfig_Node::empty

```cpp
bool google::protobuf::Repeated_mediapipe_CalculatorGraphConfig_Node::empty();
AutoIt:
    $oRepeated_mediapipe_CalculatorGraphConfig_Node.empty() -> retval
```

### google::protobuf::Repeated_mediapipe_CalculatorGraphConfig_Node::extend

```cpp
void google::protobuf::Repeated_mediapipe_CalculatorGraphConfig_Node::extend( const google::protobuf::Repeated_mediapipe_CalculatorGraphConfig_Node& items );
AutoIt:
    $oRepeated_mediapipe_CalculatorGraphConfig_Node.extend( $items ) -> None
```

```cpp
void google::protobuf::Repeated_mediapipe_CalculatorGraphConfig_Node::extend( const std::vector<std::shared_ptr<mediapipe::CalculatorGraphConfig::Node>>& items );
AutoIt:
    $oRepeated_mediapipe_CalculatorGraphConfig_Node.extend( $items ) -> None
```

```cpp
void google::protobuf::Repeated_mediapipe_CalculatorGraphConfig_Node::extend( const std::vector<_variant_t>& items );
AutoIt:
    $oRepeated_mediapipe_CalculatorGraphConfig_Node.extend( $items ) -> None
```

### google::protobuf::Repeated_mediapipe_CalculatorGraphConfig_Node::get_Item

```cpp
mediapipe::CalculatorGraphConfig::Node* google::protobuf::Repeated_mediapipe_CalculatorGraphConfig_Node::get_Item( int index );
AutoIt:
    $oRepeated_mediapipe_CalculatorGraphConfig_Node.Item( $index ) -> retval
    $oRepeated_mediapipe_CalculatorGraphConfig_Node( $index ) -> retval
```

### google::protobuf::Repeated_mediapipe_CalculatorGraphConfig_Node::get__NewEnum

```cpp
IUnknown* google::protobuf::Repeated_mediapipe_CalculatorGraphConfig_Node::get__NewEnum();
AutoIt:
    $oRepeated_mediapipe_CalculatorGraphConfig_Node._NewEnum() -> retval
```

### google::protobuf::Repeated_mediapipe_CalculatorGraphConfig_Node::insert

```cpp
void google::protobuf::Repeated_mediapipe_CalculatorGraphConfig_Node::insert( SSIZE_T                                        index,
                                                                              const mediapipe::CalculatorGraphConfig::Node*& item );
AutoIt:
    $oRepeated_mediapipe_CalculatorGraphConfig_Node.insert( $index, $item ) -> None
```

### google::protobuf::Repeated_mediapipe_CalculatorGraphConfig_Node::pop

```cpp
std::shared_ptr<mediapipe::CalculatorGraphConfig::Node> google::protobuf::Repeated_mediapipe_CalculatorGraphConfig_Node::pop( SSIZE_T index = -1 );
AutoIt:
    $oRepeated_mediapipe_CalculatorGraphConfig_Node.pop( [$index] ) -> retval
```

### google::protobuf::Repeated_mediapipe_CalculatorGraphConfig_Node::reverse

```cpp
void google::protobuf::Repeated_mediapipe_CalculatorGraphConfig_Node::reverse();
AutoIt:
    $oRepeated_mediapipe_CalculatorGraphConfig_Node.reverse() -> None
```

### google::protobuf::Repeated_mediapipe_CalculatorGraphConfig_Node::size

```cpp
int google::protobuf::Repeated_mediapipe_CalculatorGraphConfig_Node::size();
AutoIt:
    $oRepeated_mediapipe_CalculatorGraphConfig_Node.size() -> retval
```

### google::protobuf::Repeated_mediapipe_CalculatorGraphConfig_Node::slice

```cpp
void google::protobuf::Repeated_mediapipe_CalculatorGraphConfig_Node::slice( std::vector<std::shared_ptr<mediapipe::CalculatorGraphConfig::Node>> list,
                                                                             SSIZE_T                                                              start,
                                                                             SSIZE_T                                                              count );
AutoIt:
    $oRepeated_mediapipe_CalculatorGraphConfig_Node.slice( $start, $count[, $list] ) -> $list
```

```cpp
void google::protobuf::Repeated_mediapipe_CalculatorGraphConfig_Node::slice( std::vector<std::shared_ptr<mediapipe::CalculatorGraphConfig::Node>> list,
                                                                             SSIZE_T                                                              start = 0 );
AutoIt:
    $oRepeated_mediapipe_CalculatorGraphConfig_Node.slice( [$start[, $list]] ) -> $list
```

### google::protobuf::Repeated_mediapipe_CalculatorGraphConfig_Node::sort

```cpp
void google::protobuf::Repeated_mediapipe_CalculatorGraphConfig_Node::sort( void*  comparator,
                                                                            size_t start = 0,
                                                                            size_t count = __self->get()->size() );
AutoIt:
    $oRepeated_mediapipe_CalculatorGraphConfig_Node.sort( $comparator[, $start[, $count]] ) -> None
```

### google::protobuf::Repeated_mediapipe_CalculatorGraphConfig_Node::sort_variant

```cpp
void google::protobuf::Repeated_mediapipe_CalculatorGraphConfig_Node::sort_variant( void*  comparator,
                                                                                    size_t start = 0,
                                                                                    size_t count = __self->get()->size() );
AutoIt:
    $oRepeated_mediapipe_CalculatorGraphConfig_Node.sort_variant( $comparator[, $start[, $count]] ) -> None
```

### google::protobuf::Repeated_mediapipe_CalculatorGraphConfig_Node::splice

```cpp
void google::protobuf::Repeated_mediapipe_CalculatorGraphConfig_Node::splice( std::vector<std::shared_ptr<mediapipe::CalculatorGraphConfig::Node>> list,
                                                                              SSIZE_T                                                              start,
                                                                              SSIZE_T                                                              deleteCount );
AutoIt:
    $oRepeated_mediapipe_CalculatorGraphConfig_Node.splice( $start, $deleteCount[, $list] ) -> $list
```

```cpp
void google::protobuf::Repeated_mediapipe_CalculatorGraphConfig_Node::splice( std::vector<std::shared_ptr<mediapipe::CalculatorGraphConfig::Node>> list,
                                                                              SSIZE_T                                                              start = 0 );
AutoIt:
    $oRepeated_mediapipe_CalculatorGraphConfig_Node.splice( [$start[, $list]] ) -> $list
```

## google::protobuf::Repeated_mediapipe_PacketGeneratorConfig

### google::protobuf::Repeated_mediapipe_PacketGeneratorConfig::create

```cpp
static google::protobuf::Repeated_mediapipe_PacketGeneratorConfig google::protobuf::Repeated_mediapipe_PacketGeneratorConfig::create();
AutoIt:
    _Mediapipe_ObjCreate("google.protobuf.Repeated_mediapipe_PacketGeneratorConfig").create() -> <google.protobuf.Repeated_mediapipe_PacketGeneratorConfig object>
```

### google::protobuf::Repeated_mediapipe_PacketGeneratorConfig::CopyFrom

```cpp
void google::protobuf::Repeated_mediapipe_PacketGeneratorConfig::CopyFrom( const google::protobuf::Repeated_mediapipe_PacketGeneratorConfig other );
AutoIt:
    $oRepeated_mediapipe_PacketGeneratorConfig.CopyFrom( $other ) -> None
```

### google::protobuf::Repeated_mediapipe_PacketGeneratorConfig::MergeFrom

```cpp
void google::protobuf::Repeated_mediapipe_PacketGeneratorConfig::MergeFrom( const google::protobuf::Repeated_mediapipe_PacketGeneratorConfig other );
AutoIt:
    $oRepeated_mediapipe_PacketGeneratorConfig.MergeFrom( $other ) -> None
```

### google::protobuf::Repeated_mediapipe_PacketGeneratorConfig::Swap

```cpp
void google::protobuf::Repeated_mediapipe_PacketGeneratorConfig::Swap( google::protobuf::Repeated_mediapipe_PacketGeneratorConfig* other );
AutoIt:
    $oRepeated_mediapipe_PacketGeneratorConfig.Swap( $other ) -> None
```

### google::protobuf::Repeated_mediapipe_PacketGeneratorConfig::SwapElements

```cpp
void google::protobuf::Repeated_mediapipe_PacketGeneratorConfig::SwapElements( int index1,
                                                                               int index2 );
AutoIt:
    $oRepeated_mediapipe_PacketGeneratorConfig.SwapElements( $index1, $index2 ) -> None
```

### google::protobuf::Repeated_mediapipe_PacketGeneratorConfig::add

```cpp
mediapipe::PacketGeneratorConfig* google::protobuf::Repeated_mediapipe_PacketGeneratorConfig::add();
AutoIt:
    $oRepeated_mediapipe_PacketGeneratorConfig.add() -> retval
```

```cpp
mediapipe::PacketGeneratorConfig* google::protobuf::Repeated_mediapipe_PacketGeneratorConfig::add( const mediapipe::PacketGeneratorConfig* value );
AutoIt:
    $oRepeated_mediapipe_PacketGeneratorConfig.add( $value ) -> retval
```

```cpp
mediapipe::PacketGeneratorConfig* google::protobuf::Repeated_mediapipe_PacketGeneratorConfig::add( std::map<std::string, _variant_t> attrs );
AutoIt:
    $oRepeated_mediapipe_PacketGeneratorConfig.add( $attrs ) -> retval
```

### google::protobuf::Repeated_mediapipe_PacketGeneratorConfig::clear

```cpp
void google::protobuf::Repeated_mediapipe_PacketGeneratorConfig::clear();
AutoIt:
    $oRepeated_mediapipe_PacketGeneratorConfig.clear() -> None
```

### google::protobuf::Repeated_mediapipe_PacketGeneratorConfig::empty

```cpp
bool google::protobuf::Repeated_mediapipe_PacketGeneratorConfig::empty();
AutoIt:
    $oRepeated_mediapipe_PacketGeneratorConfig.empty() -> retval
```

### google::protobuf::Repeated_mediapipe_PacketGeneratorConfig::extend

```cpp
void google::protobuf::Repeated_mediapipe_PacketGeneratorConfig::extend( const google::protobuf::Repeated_mediapipe_PacketGeneratorConfig& items );
AutoIt:
    $oRepeated_mediapipe_PacketGeneratorConfig.extend( $items ) -> None
```

```cpp
void google::protobuf::Repeated_mediapipe_PacketGeneratorConfig::extend( const std::vector<std::shared_ptr<mediapipe::PacketGeneratorConfig>>& items );
AutoIt:
    $oRepeated_mediapipe_PacketGeneratorConfig.extend( $items ) -> None
```

```cpp
void google::protobuf::Repeated_mediapipe_PacketGeneratorConfig::extend( const std::vector<_variant_t>& items );
AutoIt:
    $oRepeated_mediapipe_PacketGeneratorConfig.extend( $items ) -> None
```

### google::protobuf::Repeated_mediapipe_PacketGeneratorConfig::get_Item

```cpp
mediapipe::PacketGeneratorConfig* google::protobuf::Repeated_mediapipe_PacketGeneratorConfig::get_Item( int index );
AutoIt:
    $oRepeated_mediapipe_PacketGeneratorConfig.Item( $index ) -> retval
    $oRepeated_mediapipe_PacketGeneratorConfig( $index ) -> retval
```

### google::protobuf::Repeated_mediapipe_PacketGeneratorConfig::get__NewEnum

```cpp
IUnknown* google::protobuf::Repeated_mediapipe_PacketGeneratorConfig::get__NewEnum();
AutoIt:
    $oRepeated_mediapipe_PacketGeneratorConfig._NewEnum() -> retval
```

### google::protobuf::Repeated_mediapipe_PacketGeneratorConfig::insert

```cpp
void google::protobuf::Repeated_mediapipe_PacketGeneratorConfig::insert( SSIZE_T                                  index,
                                                                         const mediapipe::PacketGeneratorConfig*& item );
AutoIt:
    $oRepeated_mediapipe_PacketGeneratorConfig.insert( $index, $item ) -> None
```

### google::protobuf::Repeated_mediapipe_PacketGeneratorConfig::pop

```cpp
std::shared_ptr<mediapipe::PacketGeneratorConfig> google::protobuf::Repeated_mediapipe_PacketGeneratorConfig::pop( SSIZE_T index = -1 );
AutoIt:
    $oRepeated_mediapipe_PacketGeneratorConfig.pop( [$index] ) -> retval
```

### google::protobuf::Repeated_mediapipe_PacketGeneratorConfig::reverse

```cpp
void google::protobuf::Repeated_mediapipe_PacketGeneratorConfig::reverse();
AutoIt:
    $oRepeated_mediapipe_PacketGeneratorConfig.reverse() -> None
```

### google::protobuf::Repeated_mediapipe_PacketGeneratorConfig::size

```cpp
int google::protobuf::Repeated_mediapipe_PacketGeneratorConfig::size();
AutoIt:
    $oRepeated_mediapipe_PacketGeneratorConfig.size() -> retval
```

### google::protobuf::Repeated_mediapipe_PacketGeneratorConfig::slice

```cpp
void google::protobuf::Repeated_mediapipe_PacketGeneratorConfig::slice( std::vector<std::shared_ptr<mediapipe::PacketGeneratorConfig>> list,
                                                                        SSIZE_T                                                        start,
                                                                        SSIZE_T                                                        count );
AutoIt:
    $oRepeated_mediapipe_PacketGeneratorConfig.slice( $start, $count[, $list] ) -> $list
```

```cpp
void google::protobuf::Repeated_mediapipe_PacketGeneratorConfig::slice( std::vector<std::shared_ptr<mediapipe::PacketGeneratorConfig>> list,
                                                                        SSIZE_T                                                        start = 0 );
AutoIt:
    $oRepeated_mediapipe_PacketGeneratorConfig.slice( [$start[, $list]] ) -> $list
```

### google::protobuf::Repeated_mediapipe_PacketGeneratorConfig::sort

```cpp
void google::protobuf::Repeated_mediapipe_PacketGeneratorConfig::sort( void*  comparator,
                                                                       size_t start = 0,
                                                                       size_t count = __self->get()->size() );
AutoIt:
    $oRepeated_mediapipe_PacketGeneratorConfig.sort( $comparator[, $start[, $count]] ) -> None
```

### google::protobuf::Repeated_mediapipe_PacketGeneratorConfig::sort_variant

```cpp
void google::protobuf::Repeated_mediapipe_PacketGeneratorConfig::sort_variant( void*  comparator,
                                                                               size_t start = 0,
                                                                               size_t count = __self->get()->size() );
AutoIt:
    $oRepeated_mediapipe_PacketGeneratorConfig.sort_variant( $comparator[, $start[, $count]] ) -> None
```

### google::protobuf::Repeated_mediapipe_PacketGeneratorConfig::splice

```cpp
void google::protobuf::Repeated_mediapipe_PacketGeneratorConfig::splice( std::vector<std::shared_ptr<mediapipe::PacketGeneratorConfig>> list,
                                                                         SSIZE_T                                                        start,
                                                                         SSIZE_T                                                        deleteCount );
AutoIt:
    $oRepeated_mediapipe_PacketGeneratorConfig.splice( $start, $deleteCount[, $list] ) -> $list
```

```cpp
void google::protobuf::Repeated_mediapipe_PacketGeneratorConfig::splice( std::vector<std::shared_ptr<mediapipe::PacketGeneratorConfig>> list,
                                                                         SSIZE_T                                                        start = 0 );
AutoIt:
    $oRepeated_mediapipe_PacketGeneratorConfig.splice( [$start[, $list]] ) -> $list
```

## google::protobuf::Repeated_mediapipe_StatusHandlerConfig

### google::protobuf::Repeated_mediapipe_StatusHandlerConfig::create

```cpp
static google::protobuf::Repeated_mediapipe_StatusHandlerConfig google::protobuf::Repeated_mediapipe_StatusHandlerConfig::create();
AutoIt:
    _Mediapipe_ObjCreate("google.protobuf.Repeated_mediapipe_StatusHandlerConfig").create() -> <google.protobuf.Repeated_mediapipe_StatusHandlerConfig object>
```

### google::protobuf::Repeated_mediapipe_StatusHandlerConfig::CopyFrom

```cpp
void google::protobuf::Repeated_mediapipe_StatusHandlerConfig::CopyFrom( const google::protobuf::Repeated_mediapipe_StatusHandlerConfig other );
AutoIt:
    $oRepeated_mediapipe_StatusHandlerConfig.CopyFrom( $other ) -> None
```

### google::protobuf::Repeated_mediapipe_StatusHandlerConfig::MergeFrom

```cpp
void google::protobuf::Repeated_mediapipe_StatusHandlerConfig::MergeFrom( const google::protobuf::Repeated_mediapipe_StatusHandlerConfig other );
AutoIt:
    $oRepeated_mediapipe_StatusHandlerConfig.MergeFrom( $other ) -> None
```

### google::protobuf::Repeated_mediapipe_StatusHandlerConfig::Swap

```cpp
void google::protobuf::Repeated_mediapipe_StatusHandlerConfig::Swap( google::protobuf::Repeated_mediapipe_StatusHandlerConfig* other );
AutoIt:
    $oRepeated_mediapipe_StatusHandlerConfig.Swap( $other ) -> None
```

### google::protobuf::Repeated_mediapipe_StatusHandlerConfig::SwapElements

```cpp
void google::protobuf::Repeated_mediapipe_StatusHandlerConfig::SwapElements( int index1,
                                                                             int index2 );
AutoIt:
    $oRepeated_mediapipe_StatusHandlerConfig.SwapElements( $index1, $index2 ) -> None
```

### google::protobuf::Repeated_mediapipe_StatusHandlerConfig::add

```cpp
mediapipe::StatusHandlerConfig* google::protobuf::Repeated_mediapipe_StatusHandlerConfig::add();
AutoIt:
    $oRepeated_mediapipe_StatusHandlerConfig.add() -> retval
```

```cpp
mediapipe::StatusHandlerConfig* google::protobuf::Repeated_mediapipe_StatusHandlerConfig::add( const mediapipe::StatusHandlerConfig* value );
AutoIt:
    $oRepeated_mediapipe_StatusHandlerConfig.add( $value ) -> retval
```

```cpp
mediapipe::StatusHandlerConfig* google::protobuf::Repeated_mediapipe_StatusHandlerConfig::add( std::map<std::string, _variant_t> attrs );
AutoIt:
    $oRepeated_mediapipe_StatusHandlerConfig.add( $attrs ) -> retval
```

### google::protobuf::Repeated_mediapipe_StatusHandlerConfig::clear

```cpp
void google::protobuf::Repeated_mediapipe_StatusHandlerConfig::clear();
AutoIt:
    $oRepeated_mediapipe_StatusHandlerConfig.clear() -> None
```

### google::protobuf::Repeated_mediapipe_StatusHandlerConfig::empty

```cpp
bool google::protobuf::Repeated_mediapipe_StatusHandlerConfig::empty();
AutoIt:
    $oRepeated_mediapipe_StatusHandlerConfig.empty() -> retval
```

### google::protobuf::Repeated_mediapipe_StatusHandlerConfig::extend

```cpp
void google::protobuf::Repeated_mediapipe_StatusHandlerConfig::extend( const google::protobuf::Repeated_mediapipe_StatusHandlerConfig& items );
AutoIt:
    $oRepeated_mediapipe_StatusHandlerConfig.extend( $items ) -> None
```

```cpp
void google::protobuf::Repeated_mediapipe_StatusHandlerConfig::extend( const std::vector<std::shared_ptr<mediapipe::StatusHandlerConfig>>& items );
AutoIt:
    $oRepeated_mediapipe_StatusHandlerConfig.extend( $items ) -> None
```

```cpp
void google::protobuf::Repeated_mediapipe_StatusHandlerConfig::extend( const std::vector<_variant_t>& items );
AutoIt:
    $oRepeated_mediapipe_StatusHandlerConfig.extend( $items ) -> None
```

### google::protobuf::Repeated_mediapipe_StatusHandlerConfig::get_Item

```cpp
mediapipe::StatusHandlerConfig* google::protobuf::Repeated_mediapipe_StatusHandlerConfig::get_Item( int index );
AutoIt:
    $oRepeated_mediapipe_StatusHandlerConfig.Item( $index ) -> retval
    $oRepeated_mediapipe_StatusHandlerConfig( $index ) -> retval
```

### google::protobuf::Repeated_mediapipe_StatusHandlerConfig::get__NewEnum

```cpp
IUnknown* google::protobuf::Repeated_mediapipe_StatusHandlerConfig::get__NewEnum();
AutoIt:
    $oRepeated_mediapipe_StatusHandlerConfig._NewEnum() -> retval
```

### google::protobuf::Repeated_mediapipe_StatusHandlerConfig::insert

```cpp
void google::protobuf::Repeated_mediapipe_StatusHandlerConfig::insert( SSIZE_T                                index,
                                                                       const mediapipe::StatusHandlerConfig*& item );
AutoIt:
    $oRepeated_mediapipe_StatusHandlerConfig.insert( $index, $item ) -> None
```

### google::protobuf::Repeated_mediapipe_StatusHandlerConfig::pop

```cpp
std::shared_ptr<mediapipe::StatusHandlerConfig> google::protobuf::Repeated_mediapipe_StatusHandlerConfig::pop( SSIZE_T index = -1 );
AutoIt:
    $oRepeated_mediapipe_StatusHandlerConfig.pop( [$index] ) -> retval
```

### google::protobuf::Repeated_mediapipe_StatusHandlerConfig::reverse

```cpp
void google::protobuf::Repeated_mediapipe_StatusHandlerConfig::reverse();
AutoIt:
    $oRepeated_mediapipe_StatusHandlerConfig.reverse() -> None
```

### google::protobuf::Repeated_mediapipe_StatusHandlerConfig::size

```cpp
int google::protobuf::Repeated_mediapipe_StatusHandlerConfig::size();
AutoIt:
    $oRepeated_mediapipe_StatusHandlerConfig.size() -> retval
```

### google::protobuf::Repeated_mediapipe_StatusHandlerConfig::slice

```cpp
void google::protobuf::Repeated_mediapipe_StatusHandlerConfig::slice( std::vector<std::shared_ptr<mediapipe::StatusHandlerConfig>> list,
                                                                      SSIZE_T                                                      start,
                                                                      SSIZE_T                                                      count );
AutoIt:
    $oRepeated_mediapipe_StatusHandlerConfig.slice( $start, $count[, $list] ) -> $list
```

```cpp
void google::protobuf::Repeated_mediapipe_StatusHandlerConfig::slice( std::vector<std::shared_ptr<mediapipe::StatusHandlerConfig>> list,
                                                                      SSIZE_T                                                      start = 0 );
AutoIt:
    $oRepeated_mediapipe_StatusHandlerConfig.slice( [$start[, $list]] ) -> $list
```

### google::protobuf::Repeated_mediapipe_StatusHandlerConfig::sort

```cpp
void google::protobuf::Repeated_mediapipe_StatusHandlerConfig::sort( void*  comparator,
                                                                     size_t start = 0,
                                                                     size_t count = __self->get()->size() );
AutoIt:
    $oRepeated_mediapipe_StatusHandlerConfig.sort( $comparator[, $start[, $count]] ) -> None
```

### google::protobuf::Repeated_mediapipe_StatusHandlerConfig::sort_variant

```cpp
void google::protobuf::Repeated_mediapipe_StatusHandlerConfig::sort_variant( void*  comparator,
                                                                             size_t start = 0,
                                                                             size_t count = __self->get()->size() );
AutoIt:
    $oRepeated_mediapipe_StatusHandlerConfig.sort_variant( $comparator[, $start[, $count]] ) -> None
```

### google::protobuf::Repeated_mediapipe_StatusHandlerConfig::splice

```cpp
void google::protobuf::Repeated_mediapipe_StatusHandlerConfig::splice( std::vector<std::shared_ptr<mediapipe::StatusHandlerConfig>> list,
                                                                       SSIZE_T                                                      start,
                                                                       SSIZE_T                                                      deleteCount );
AutoIt:
    $oRepeated_mediapipe_StatusHandlerConfig.splice( $start, $deleteCount[, $list] ) -> $list
```

```cpp
void google::protobuf::Repeated_mediapipe_StatusHandlerConfig::splice( std::vector<std::shared_ptr<mediapipe::StatusHandlerConfig>> list,
                                                                       SSIZE_T                                                      start = 0 );
AutoIt:
    $oRepeated_mediapipe_StatusHandlerConfig.splice( [$start[, $list]] ) -> $list
```

## google::protobuf::Repeated_mediapipe_ExecutorConfig

### google::protobuf::Repeated_mediapipe_ExecutorConfig::create

```cpp
static google::protobuf::Repeated_mediapipe_ExecutorConfig google::protobuf::Repeated_mediapipe_ExecutorConfig::create();
AutoIt:
    _Mediapipe_ObjCreate("google.protobuf.Repeated_mediapipe_ExecutorConfig").create() -> <google.protobuf.Repeated_mediapipe_ExecutorConfig object>
```

### google::protobuf::Repeated_mediapipe_ExecutorConfig::CopyFrom

```cpp
void google::protobuf::Repeated_mediapipe_ExecutorConfig::CopyFrom( const google::protobuf::Repeated_mediapipe_ExecutorConfig other );
AutoIt:
    $oRepeated_mediapipe_ExecutorConfig.CopyFrom( $other ) -> None
```

### google::protobuf::Repeated_mediapipe_ExecutorConfig::MergeFrom

```cpp
void google::protobuf::Repeated_mediapipe_ExecutorConfig::MergeFrom( const google::protobuf::Repeated_mediapipe_ExecutorConfig other );
AutoIt:
    $oRepeated_mediapipe_ExecutorConfig.MergeFrom( $other ) -> None
```

### google::protobuf::Repeated_mediapipe_ExecutorConfig::Swap

```cpp
void google::protobuf::Repeated_mediapipe_ExecutorConfig::Swap( google::protobuf::Repeated_mediapipe_ExecutorConfig* other );
AutoIt:
    $oRepeated_mediapipe_ExecutorConfig.Swap( $other ) -> None
```

### google::protobuf::Repeated_mediapipe_ExecutorConfig::SwapElements

```cpp
void google::protobuf::Repeated_mediapipe_ExecutorConfig::SwapElements( int index1,
                                                                        int index2 );
AutoIt:
    $oRepeated_mediapipe_ExecutorConfig.SwapElements( $index1, $index2 ) -> None
```

### google::protobuf::Repeated_mediapipe_ExecutorConfig::add

```cpp
mediapipe::ExecutorConfig* google::protobuf::Repeated_mediapipe_ExecutorConfig::add();
AutoIt:
    $oRepeated_mediapipe_ExecutorConfig.add() -> retval
```

```cpp
mediapipe::ExecutorConfig* google::protobuf::Repeated_mediapipe_ExecutorConfig::add( const mediapipe::ExecutorConfig* value );
AutoIt:
    $oRepeated_mediapipe_ExecutorConfig.add( $value ) -> retval
```

```cpp
mediapipe::ExecutorConfig* google::protobuf::Repeated_mediapipe_ExecutorConfig::add( std::map<std::string, _variant_t> attrs );
AutoIt:
    $oRepeated_mediapipe_ExecutorConfig.add( $attrs ) -> retval
```

### google::protobuf::Repeated_mediapipe_ExecutorConfig::clear

```cpp
void google::protobuf::Repeated_mediapipe_ExecutorConfig::clear();
AutoIt:
    $oRepeated_mediapipe_ExecutorConfig.clear() -> None
```

### google::protobuf::Repeated_mediapipe_ExecutorConfig::empty

```cpp
bool google::protobuf::Repeated_mediapipe_ExecutorConfig::empty();
AutoIt:
    $oRepeated_mediapipe_ExecutorConfig.empty() -> retval
```

### google::protobuf::Repeated_mediapipe_ExecutorConfig::extend

```cpp
void google::protobuf::Repeated_mediapipe_ExecutorConfig::extend( const google::protobuf::Repeated_mediapipe_ExecutorConfig& items );
AutoIt:
    $oRepeated_mediapipe_ExecutorConfig.extend( $items ) -> None
```

```cpp
void google::protobuf::Repeated_mediapipe_ExecutorConfig::extend( const std::vector<std::shared_ptr<mediapipe::ExecutorConfig>>& items );
AutoIt:
    $oRepeated_mediapipe_ExecutorConfig.extend( $items ) -> None
```

```cpp
void google::protobuf::Repeated_mediapipe_ExecutorConfig::extend( const std::vector<_variant_t>& items );
AutoIt:
    $oRepeated_mediapipe_ExecutorConfig.extend( $items ) -> None
```

### google::protobuf::Repeated_mediapipe_ExecutorConfig::get_Item

```cpp
mediapipe::ExecutorConfig* google::protobuf::Repeated_mediapipe_ExecutorConfig::get_Item( int index );
AutoIt:
    $oRepeated_mediapipe_ExecutorConfig.Item( $index ) -> retval
    $oRepeated_mediapipe_ExecutorConfig( $index ) -> retval
```

### google::protobuf::Repeated_mediapipe_ExecutorConfig::get__NewEnum

```cpp
IUnknown* google::protobuf::Repeated_mediapipe_ExecutorConfig::get__NewEnum();
AutoIt:
    $oRepeated_mediapipe_ExecutorConfig._NewEnum() -> retval
```

### google::protobuf::Repeated_mediapipe_ExecutorConfig::insert

```cpp
void google::protobuf::Repeated_mediapipe_ExecutorConfig::insert( SSIZE_T                           index,
                                                                  const mediapipe::ExecutorConfig*& item );
AutoIt:
    $oRepeated_mediapipe_ExecutorConfig.insert( $index, $item ) -> None
```

### google::protobuf::Repeated_mediapipe_ExecutorConfig::pop

```cpp
std::shared_ptr<mediapipe::ExecutorConfig> google::protobuf::Repeated_mediapipe_ExecutorConfig::pop( SSIZE_T index = -1 );
AutoIt:
    $oRepeated_mediapipe_ExecutorConfig.pop( [$index] ) -> retval
```

### google::protobuf::Repeated_mediapipe_ExecutorConfig::reverse

```cpp
void google::protobuf::Repeated_mediapipe_ExecutorConfig::reverse();
AutoIt:
    $oRepeated_mediapipe_ExecutorConfig.reverse() -> None
```

### google::protobuf::Repeated_mediapipe_ExecutorConfig::size

```cpp
int google::protobuf::Repeated_mediapipe_ExecutorConfig::size();
AutoIt:
    $oRepeated_mediapipe_ExecutorConfig.size() -> retval
```

### google::protobuf::Repeated_mediapipe_ExecutorConfig::slice

```cpp
void google::protobuf::Repeated_mediapipe_ExecutorConfig::slice( std::vector<std::shared_ptr<mediapipe::ExecutorConfig>> list,
                                                                 SSIZE_T                                                 start,
                                                                 SSIZE_T                                                 count );
AutoIt:
    $oRepeated_mediapipe_ExecutorConfig.slice( $start, $count[, $list] ) -> $list
```

```cpp
void google::protobuf::Repeated_mediapipe_ExecutorConfig::slice( std::vector<std::shared_ptr<mediapipe::ExecutorConfig>> list,
                                                                 SSIZE_T                                                 start = 0 );
AutoIt:
    $oRepeated_mediapipe_ExecutorConfig.slice( [$start[, $list]] ) -> $list
```

### google::protobuf::Repeated_mediapipe_ExecutorConfig::sort

```cpp
void google::protobuf::Repeated_mediapipe_ExecutorConfig::sort( void*  comparator,
                                                                size_t start = 0,
                                                                size_t count = __self->get()->size() );
AutoIt:
    $oRepeated_mediapipe_ExecutorConfig.sort( $comparator[, $start[, $count]] ) -> None
```

### google::protobuf::Repeated_mediapipe_ExecutorConfig::sort_variant

```cpp
void google::protobuf::Repeated_mediapipe_ExecutorConfig::sort_variant( void*  comparator,
                                                                        size_t start = 0,
                                                                        size_t count = __self->get()->size() );
AutoIt:
    $oRepeated_mediapipe_ExecutorConfig.sort_variant( $comparator[, $start[, $count]] ) -> None
```

### google::protobuf::Repeated_mediapipe_ExecutorConfig::splice

```cpp
void google::protobuf::Repeated_mediapipe_ExecutorConfig::splice( std::vector<std::shared_ptr<mediapipe::ExecutorConfig>> list,
                                                                  SSIZE_T                                                 start,
                                                                  SSIZE_T                                                 deleteCount );
AutoIt:
    $oRepeated_mediapipe_ExecutorConfig.splice( $start, $deleteCount[, $list] ) -> $list
```

```cpp
void google::protobuf::Repeated_mediapipe_ExecutorConfig::splice( std::vector<std::shared_ptr<mediapipe::ExecutorConfig>> list,
                                                                  SSIZE_T                                                 start = 0 );
AutoIt:
    $oRepeated_mediapipe_ExecutorConfig.splice( [$start[, $list]] ) -> $list
```

## google::protobuf::Repeated_google_protobuf_Any

### google::protobuf::Repeated_google_protobuf_Any::create

```cpp
static google::protobuf::Repeated_google_protobuf_Any google::protobuf::Repeated_google_protobuf_Any::create();
AutoIt:
    _Mediapipe_ObjCreate("google.protobuf.Repeated_google_protobuf_Any").create() -> <google.protobuf.Repeated_google_protobuf_Any object>
```

### google::protobuf::Repeated_google_protobuf_Any::CopyFrom

```cpp
void google::protobuf::Repeated_google_protobuf_Any::CopyFrom( const google::protobuf::Repeated_google_protobuf_Any other );
AutoIt:
    $oRepeated_google_protobuf_Any.CopyFrom( $other ) -> None
```

### google::protobuf::Repeated_google_protobuf_Any::MergeFrom

```cpp
void google::protobuf::Repeated_google_protobuf_Any::MergeFrom( const google::protobuf::Repeated_google_protobuf_Any other );
AutoIt:
    $oRepeated_google_protobuf_Any.MergeFrom( $other ) -> None
```

### google::protobuf::Repeated_google_protobuf_Any::Swap

```cpp
void google::protobuf::Repeated_google_protobuf_Any::Swap( google::protobuf::Repeated_google_protobuf_Any* other );
AutoIt:
    $oRepeated_google_protobuf_Any.Swap( $other ) -> None
```

### google::protobuf::Repeated_google_protobuf_Any::SwapElements

```cpp
void google::protobuf::Repeated_google_protobuf_Any::SwapElements( int index1,
                                                                   int index2 );
AutoIt:
    $oRepeated_google_protobuf_Any.SwapElements( $index1, $index2 ) -> None
```

### google::protobuf::Repeated_google_protobuf_Any::add

```cpp
google::protobuf::Any* google::protobuf::Repeated_google_protobuf_Any::add();
AutoIt:
    $oRepeated_google_protobuf_Any.add() -> retval
```

```cpp
google::protobuf::Any* google::protobuf::Repeated_google_protobuf_Any::add( const google::protobuf::Any* value );
AutoIt:
    $oRepeated_google_protobuf_Any.add( $value ) -> retval
```

```cpp
google::protobuf::Any* google::protobuf::Repeated_google_protobuf_Any::add( std::map<std::string, _variant_t> attrs );
AutoIt:
    $oRepeated_google_protobuf_Any.add( $attrs ) -> retval
```

### google::protobuf::Repeated_google_protobuf_Any::clear

```cpp
void google::protobuf::Repeated_google_protobuf_Any::clear();
AutoIt:
    $oRepeated_google_protobuf_Any.clear() -> None
```

### google::protobuf::Repeated_google_protobuf_Any::empty

```cpp
bool google::protobuf::Repeated_google_protobuf_Any::empty();
AutoIt:
    $oRepeated_google_protobuf_Any.empty() -> retval
```

### google::protobuf::Repeated_google_protobuf_Any::extend

```cpp
void google::protobuf::Repeated_google_protobuf_Any::extend( const google::protobuf::Repeated_google_protobuf_Any& items );
AutoIt:
    $oRepeated_google_protobuf_Any.extend( $items ) -> None
```

```cpp
void google::protobuf::Repeated_google_protobuf_Any::extend( const std::vector<std::shared_ptr<google::protobuf::Any>>& items );
AutoIt:
    $oRepeated_google_protobuf_Any.extend( $items ) -> None
```

```cpp
void google::protobuf::Repeated_google_protobuf_Any::extend( const std::vector<_variant_t>& items );
AutoIt:
    $oRepeated_google_protobuf_Any.extend( $items ) -> None
```

### google::protobuf::Repeated_google_protobuf_Any::get_Item

```cpp
google::protobuf::Any* google::protobuf::Repeated_google_protobuf_Any::get_Item( int index );
AutoIt:
    $oRepeated_google_protobuf_Any.Item( $index ) -> retval
    $oRepeated_google_protobuf_Any( $index ) -> retval
```

### google::protobuf::Repeated_google_protobuf_Any::get__NewEnum

```cpp
IUnknown* google::protobuf::Repeated_google_protobuf_Any::get__NewEnum();
AutoIt:
    $oRepeated_google_protobuf_Any._NewEnum() -> retval
```

### google::protobuf::Repeated_google_protobuf_Any::insert

```cpp
void google::protobuf::Repeated_google_protobuf_Any::insert( SSIZE_T                       index,
                                                             const google::protobuf::Any*& item );
AutoIt:
    $oRepeated_google_protobuf_Any.insert( $index, $item ) -> None
```

### google::protobuf::Repeated_google_protobuf_Any::pop

```cpp
std::shared_ptr<google::protobuf::Any> google::protobuf::Repeated_google_protobuf_Any::pop( SSIZE_T index = -1 );
AutoIt:
    $oRepeated_google_protobuf_Any.pop( [$index] ) -> retval
```

### google::protobuf::Repeated_google_protobuf_Any::reverse

```cpp
void google::protobuf::Repeated_google_protobuf_Any::reverse();
AutoIt:
    $oRepeated_google_protobuf_Any.reverse() -> None
```

### google::protobuf::Repeated_google_protobuf_Any::size

```cpp
int google::protobuf::Repeated_google_protobuf_Any::size();
AutoIt:
    $oRepeated_google_protobuf_Any.size() -> retval
```

### google::protobuf::Repeated_google_protobuf_Any::slice

```cpp
void google::protobuf::Repeated_google_protobuf_Any::slice( std::vector<std::shared_ptr<google::protobuf::Any>> list,
                                                            SSIZE_T                                             start,
                                                            SSIZE_T                                             count );
AutoIt:
    $oRepeated_google_protobuf_Any.slice( $start, $count[, $list] ) -> $list
```

```cpp
void google::protobuf::Repeated_google_protobuf_Any::slice( std::vector<std::shared_ptr<google::protobuf::Any>> list,
                                                            SSIZE_T                                             start = 0 );
AutoIt:
    $oRepeated_google_protobuf_Any.slice( [$start[, $list]] ) -> $list
```

### google::protobuf::Repeated_google_protobuf_Any::sort

```cpp
void google::protobuf::Repeated_google_protobuf_Any::sort( void*  comparator,
                                                           size_t start = 0,
                                                           size_t count = __self->get()->size() );
AutoIt:
    $oRepeated_google_protobuf_Any.sort( $comparator[, $start[, $count]] ) -> None
```

### google::protobuf::Repeated_google_protobuf_Any::sort_variant

```cpp
void google::protobuf::Repeated_google_protobuf_Any::sort_variant( void*  comparator,
                                                                   size_t start = 0,
                                                                   size_t count = __self->get()->size() );
AutoIt:
    $oRepeated_google_protobuf_Any.sort_variant( $comparator[, $start[, $count]] ) -> None
```

### google::protobuf::Repeated_google_protobuf_Any::splice

```cpp
void google::protobuf::Repeated_google_protobuf_Any::splice( std::vector<std::shared_ptr<google::protobuf::Any>> list,
                                                             SSIZE_T                                             start,
                                                             SSIZE_T                                             deleteCount );
AutoIt:
    $oRepeated_google_protobuf_Any.splice( $start, $deleteCount[, $list] ) -> $list
```

```cpp
void google::protobuf::Repeated_google_protobuf_Any::splice( std::vector<std::shared_ptr<google::protobuf::Any>> list,
                                                             SSIZE_T                                             start = 0 );
AutoIt:
    $oRepeated_google_protobuf_Any.splice( [$start[, $list]] ) -> $list
```

## mediapipe::CalculatorGraphConfig::Node

### mediapipe::CalculatorGraphConfig::Node::get_create

```cpp
static mediapipe::CalculatorGraphConfig::Node mediapipe::CalculatorGraphConfig::Node::get_create();
AutoIt:
    _Mediapipe_ObjCreate("mediapipe.CalculatorGraphConfig.Node").create() -> <mediapipe.CalculatorGraphConfig.Node object>
    _Mediapipe_ObjCreate("mediapipe.CalculatorGraphConfig.Node")() -> <mediapipe.CalculatorGraphConfig.Node object>
```

### mediapipe::CalculatorGraphConfig::Node::str

```cpp
void mediapipe::CalculatorGraphConfig::Node::str( std::string* output );
AutoIt:
    $oNode.str( [$output] ) -> $output
```

## google::protobuf::Repeated_mediapipe_InputStreamInfo

### google::protobuf::Repeated_mediapipe_InputStreamInfo::create

```cpp
static google::protobuf::Repeated_mediapipe_InputStreamInfo google::protobuf::Repeated_mediapipe_InputStreamInfo::create();
AutoIt:
    _Mediapipe_ObjCreate("google.protobuf.Repeated_mediapipe_InputStreamInfo").create() -> <google.protobuf.Repeated_mediapipe_InputStreamInfo object>
```

### google::protobuf::Repeated_mediapipe_InputStreamInfo::CopyFrom

```cpp
void google::protobuf::Repeated_mediapipe_InputStreamInfo::CopyFrom( const google::protobuf::Repeated_mediapipe_InputStreamInfo other );
AutoIt:
    $oRepeated_mediapipe_InputStreamInfo.CopyFrom( $other ) -> None
```

### google::protobuf::Repeated_mediapipe_InputStreamInfo::MergeFrom

```cpp
void google::protobuf::Repeated_mediapipe_InputStreamInfo::MergeFrom( const google::protobuf::Repeated_mediapipe_InputStreamInfo other );
AutoIt:
    $oRepeated_mediapipe_InputStreamInfo.MergeFrom( $other ) -> None
```

### google::protobuf::Repeated_mediapipe_InputStreamInfo::Swap

```cpp
void google::protobuf::Repeated_mediapipe_InputStreamInfo::Swap( google::protobuf::Repeated_mediapipe_InputStreamInfo* other );
AutoIt:
    $oRepeated_mediapipe_InputStreamInfo.Swap( $other ) -> None
```

### google::protobuf::Repeated_mediapipe_InputStreamInfo::SwapElements

```cpp
void google::protobuf::Repeated_mediapipe_InputStreamInfo::SwapElements( int index1,
                                                                         int index2 );
AutoIt:
    $oRepeated_mediapipe_InputStreamInfo.SwapElements( $index1, $index2 ) -> None
```

### google::protobuf::Repeated_mediapipe_InputStreamInfo::add

```cpp
mediapipe::InputStreamInfo* google::protobuf::Repeated_mediapipe_InputStreamInfo::add();
AutoIt:
    $oRepeated_mediapipe_InputStreamInfo.add() -> retval
```

```cpp
mediapipe::InputStreamInfo* google::protobuf::Repeated_mediapipe_InputStreamInfo::add( const mediapipe::InputStreamInfo* value );
AutoIt:
    $oRepeated_mediapipe_InputStreamInfo.add( $value ) -> retval
```

```cpp
mediapipe::InputStreamInfo* google::protobuf::Repeated_mediapipe_InputStreamInfo::add( std::map<std::string, _variant_t> attrs );
AutoIt:
    $oRepeated_mediapipe_InputStreamInfo.add( $attrs ) -> retval
```

### google::protobuf::Repeated_mediapipe_InputStreamInfo::clear

```cpp
void google::protobuf::Repeated_mediapipe_InputStreamInfo::clear();
AutoIt:
    $oRepeated_mediapipe_InputStreamInfo.clear() -> None
```

### google::protobuf::Repeated_mediapipe_InputStreamInfo::empty

```cpp
bool google::protobuf::Repeated_mediapipe_InputStreamInfo::empty();
AutoIt:
    $oRepeated_mediapipe_InputStreamInfo.empty() -> retval
```

### google::protobuf::Repeated_mediapipe_InputStreamInfo::extend

```cpp
void google::protobuf::Repeated_mediapipe_InputStreamInfo::extend( const google::protobuf::Repeated_mediapipe_InputStreamInfo& items );
AutoIt:
    $oRepeated_mediapipe_InputStreamInfo.extend( $items ) -> None
```

```cpp
void google::protobuf::Repeated_mediapipe_InputStreamInfo::extend( const std::vector<std::shared_ptr<mediapipe::InputStreamInfo>>& items );
AutoIt:
    $oRepeated_mediapipe_InputStreamInfo.extend( $items ) -> None
```

```cpp
void google::protobuf::Repeated_mediapipe_InputStreamInfo::extend( const std::vector<_variant_t>& items );
AutoIt:
    $oRepeated_mediapipe_InputStreamInfo.extend( $items ) -> None
```

### google::protobuf::Repeated_mediapipe_InputStreamInfo::get_Item

```cpp
mediapipe::InputStreamInfo* google::protobuf::Repeated_mediapipe_InputStreamInfo::get_Item( int index );
AutoIt:
    $oRepeated_mediapipe_InputStreamInfo.Item( $index ) -> retval
    $oRepeated_mediapipe_InputStreamInfo( $index ) -> retval
```

### google::protobuf::Repeated_mediapipe_InputStreamInfo::get__NewEnum

```cpp
IUnknown* google::protobuf::Repeated_mediapipe_InputStreamInfo::get__NewEnum();
AutoIt:
    $oRepeated_mediapipe_InputStreamInfo._NewEnum() -> retval
```

### google::protobuf::Repeated_mediapipe_InputStreamInfo::insert

```cpp
void google::protobuf::Repeated_mediapipe_InputStreamInfo::insert( SSIZE_T                            index,
                                                                   const mediapipe::InputStreamInfo*& item );
AutoIt:
    $oRepeated_mediapipe_InputStreamInfo.insert( $index, $item ) -> None
```

### google::protobuf::Repeated_mediapipe_InputStreamInfo::pop

```cpp
std::shared_ptr<mediapipe::InputStreamInfo> google::protobuf::Repeated_mediapipe_InputStreamInfo::pop( SSIZE_T index = -1 );
AutoIt:
    $oRepeated_mediapipe_InputStreamInfo.pop( [$index] ) -> retval
```

### google::protobuf::Repeated_mediapipe_InputStreamInfo::reverse

```cpp
void google::protobuf::Repeated_mediapipe_InputStreamInfo::reverse();
AutoIt:
    $oRepeated_mediapipe_InputStreamInfo.reverse() -> None
```

### google::protobuf::Repeated_mediapipe_InputStreamInfo::size

```cpp
int google::protobuf::Repeated_mediapipe_InputStreamInfo::size();
AutoIt:
    $oRepeated_mediapipe_InputStreamInfo.size() -> retval
```

### google::protobuf::Repeated_mediapipe_InputStreamInfo::slice

```cpp
void google::protobuf::Repeated_mediapipe_InputStreamInfo::slice( std::vector<std::shared_ptr<mediapipe::InputStreamInfo>> list,
                                                                  SSIZE_T                                                  start,
                                                                  SSIZE_T                                                  count );
AutoIt:
    $oRepeated_mediapipe_InputStreamInfo.slice( $start, $count[, $list] ) -> $list
```

```cpp
void google::protobuf::Repeated_mediapipe_InputStreamInfo::slice( std::vector<std::shared_ptr<mediapipe::InputStreamInfo>> list,
                                                                  SSIZE_T                                                  start = 0 );
AutoIt:
    $oRepeated_mediapipe_InputStreamInfo.slice( [$start[, $list]] ) -> $list
```

### google::protobuf::Repeated_mediapipe_InputStreamInfo::sort

```cpp
void google::protobuf::Repeated_mediapipe_InputStreamInfo::sort( void*  comparator,
                                                                 size_t start = 0,
                                                                 size_t count = __self->get()->size() );
AutoIt:
    $oRepeated_mediapipe_InputStreamInfo.sort( $comparator[, $start[, $count]] ) -> None
```

### google::protobuf::Repeated_mediapipe_InputStreamInfo::sort_variant

```cpp
void google::protobuf::Repeated_mediapipe_InputStreamInfo::sort_variant( void*  comparator,
                                                                         size_t start = 0,
                                                                         size_t count = __self->get()->size() );
AutoIt:
    $oRepeated_mediapipe_InputStreamInfo.sort_variant( $comparator[, $start[, $count]] ) -> None
```

### google::protobuf::Repeated_mediapipe_InputStreamInfo::splice

```cpp
void google::protobuf::Repeated_mediapipe_InputStreamInfo::splice( std::vector<std::shared_ptr<mediapipe::InputStreamInfo>> list,
                                                                   SSIZE_T                                                  start,
                                                                   SSIZE_T                                                  deleteCount );
AutoIt:
    $oRepeated_mediapipe_InputStreamInfo.splice( $start, $deleteCount[, $list] ) -> $list
```

```cpp
void google::protobuf::Repeated_mediapipe_InputStreamInfo::splice( std::vector<std::shared_ptr<mediapipe::InputStreamInfo>> list,
                                                                   SSIZE_T                                                  start = 0 );
AutoIt:
    $oRepeated_mediapipe_InputStreamInfo.splice( [$start[, $list]] ) -> $list
```

## mediapipe::Rasterization

### mediapipe::Rasterization::get_create

```cpp
static mediapipe::Rasterization mediapipe::Rasterization::get_create();
AutoIt:
    _Mediapipe_ObjCreate("mediapipe.Rasterization").create() -> <mediapipe.Rasterization object>
    _Mediapipe_ObjCreate("mediapipe.Rasterization")() -> <mediapipe.Rasterization object>
```

### mediapipe::Rasterization::str

```cpp
void mediapipe::Rasterization::str( std::string* output );
AutoIt:
    $oRasterization.str( [$output] ) -> $output
```

## google::protobuf::Repeated_mediapipe_Rasterization_Interval

### google::protobuf::Repeated_mediapipe_Rasterization_Interval::create

```cpp
static google::protobuf::Repeated_mediapipe_Rasterization_Interval google::protobuf::Repeated_mediapipe_Rasterization_Interval::create();
AutoIt:
    _Mediapipe_ObjCreate("google.protobuf.Repeated_mediapipe_Rasterization_Interval").create() -> <google.protobuf.Repeated_mediapipe_Rasterization_Interval object>
```

### google::protobuf::Repeated_mediapipe_Rasterization_Interval::CopyFrom

```cpp
void google::protobuf::Repeated_mediapipe_Rasterization_Interval::CopyFrom( const google::protobuf::Repeated_mediapipe_Rasterization_Interval other );
AutoIt:
    $oRepeated_mediapipe_Rasterization_Interval.CopyFrom( $other ) -> None
```

### google::protobuf::Repeated_mediapipe_Rasterization_Interval::MergeFrom

```cpp
void google::protobuf::Repeated_mediapipe_Rasterization_Interval::MergeFrom( const google::protobuf::Repeated_mediapipe_Rasterization_Interval other );
AutoIt:
    $oRepeated_mediapipe_Rasterization_Interval.MergeFrom( $other ) -> None
```

### google::protobuf::Repeated_mediapipe_Rasterization_Interval::Swap

```cpp
void google::protobuf::Repeated_mediapipe_Rasterization_Interval::Swap( google::protobuf::Repeated_mediapipe_Rasterization_Interval* other );
AutoIt:
    $oRepeated_mediapipe_Rasterization_Interval.Swap( $other ) -> None
```

### google::protobuf::Repeated_mediapipe_Rasterization_Interval::SwapElements

```cpp
void google::protobuf::Repeated_mediapipe_Rasterization_Interval::SwapElements( int index1,
                                                                                int index2 );
AutoIt:
    $oRepeated_mediapipe_Rasterization_Interval.SwapElements( $index1, $index2 ) -> None
```

### google::protobuf::Repeated_mediapipe_Rasterization_Interval::add

```cpp
mediapipe::Rasterization::Interval* google::protobuf::Repeated_mediapipe_Rasterization_Interval::add();
AutoIt:
    $oRepeated_mediapipe_Rasterization_Interval.add() -> retval
```

```cpp
mediapipe::Rasterization::Interval* google::protobuf::Repeated_mediapipe_Rasterization_Interval::add( const mediapipe::Rasterization::Interval* value );
AutoIt:
    $oRepeated_mediapipe_Rasterization_Interval.add( $value ) -> retval
```

```cpp
mediapipe::Rasterization::Interval* google::protobuf::Repeated_mediapipe_Rasterization_Interval::add( std::map<std::string, _variant_t> attrs );
AutoIt:
    $oRepeated_mediapipe_Rasterization_Interval.add( $attrs ) -> retval
```

### google::protobuf::Repeated_mediapipe_Rasterization_Interval::clear

```cpp
void google::protobuf::Repeated_mediapipe_Rasterization_Interval::clear();
AutoIt:
    $oRepeated_mediapipe_Rasterization_Interval.clear() -> None
```

### google::protobuf::Repeated_mediapipe_Rasterization_Interval::empty

```cpp
bool google::protobuf::Repeated_mediapipe_Rasterization_Interval::empty();
AutoIt:
    $oRepeated_mediapipe_Rasterization_Interval.empty() -> retval
```

### google::protobuf::Repeated_mediapipe_Rasterization_Interval::extend

```cpp
void google::protobuf::Repeated_mediapipe_Rasterization_Interval::extend( const google::protobuf::Repeated_mediapipe_Rasterization_Interval& items );
AutoIt:
    $oRepeated_mediapipe_Rasterization_Interval.extend( $items ) -> None
```

```cpp
void google::protobuf::Repeated_mediapipe_Rasterization_Interval::extend( const std::vector<std::shared_ptr<mediapipe::Rasterization::Interval>>& items );
AutoIt:
    $oRepeated_mediapipe_Rasterization_Interval.extend( $items ) -> None
```

```cpp
void google::protobuf::Repeated_mediapipe_Rasterization_Interval::extend( const std::vector<_variant_t>& items );
AutoIt:
    $oRepeated_mediapipe_Rasterization_Interval.extend( $items ) -> None
```

### google::protobuf::Repeated_mediapipe_Rasterization_Interval::get_Item

```cpp
mediapipe::Rasterization::Interval* google::protobuf::Repeated_mediapipe_Rasterization_Interval::get_Item( int index );
AutoIt:
    $oRepeated_mediapipe_Rasterization_Interval.Item( $index ) -> retval
    $oRepeated_mediapipe_Rasterization_Interval( $index ) -> retval
```

### google::protobuf::Repeated_mediapipe_Rasterization_Interval::get__NewEnum

```cpp
IUnknown* google::protobuf::Repeated_mediapipe_Rasterization_Interval::get__NewEnum();
AutoIt:
    $oRepeated_mediapipe_Rasterization_Interval._NewEnum() -> retval
```

### google::protobuf::Repeated_mediapipe_Rasterization_Interval::insert

```cpp
void google::protobuf::Repeated_mediapipe_Rasterization_Interval::insert( SSIZE_T                                    index,
                                                                          const mediapipe::Rasterization::Interval*& item );
AutoIt:
    $oRepeated_mediapipe_Rasterization_Interval.insert( $index, $item ) -> None
```

### google::protobuf::Repeated_mediapipe_Rasterization_Interval::pop

```cpp
std::shared_ptr<mediapipe::Rasterization::Interval> google::protobuf::Repeated_mediapipe_Rasterization_Interval::pop( SSIZE_T index = -1 );
AutoIt:
    $oRepeated_mediapipe_Rasterization_Interval.pop( [$index] ) -> retval
```

### google::protobuf::Repeated_mediapipe_Rasterization_Interval::reverse

```cpp
void google::protobuf::Repeated_mediapipe_Rasterization_Interval::reverse();
AutoIt:
    $oRepeated_mediapipe_Rasterization_Interval.reverse() -> None
```

### google::protobuf::Repeated_mediapipe_Rasterization_Interval::size

```cpp
int google::protobuf::Repeated_mediapipe_Rasterization_Interval::size();
AutoIt:
    $oRepeated_mediapipe_Rasterization_Interval.size() -> retval
```

### google::protobuf::Repeated_mediapipe_Rasterization_Interval::slice

```cpp
void google::protobuf::Repeated_mediapipe_Rasterization_Interval::slice( std::vector<std::shared_ptr<mediapipe::Rasterization::Interval>> list,
                                                                         SSIZE_T                                                          start,
                                                                         SSIZE_T                                                          count );
AutoIt:
    $oRepeated_mediapipe_Rasterization_Interval.slice( $start, $count[, $list] ) -> $list
```

```cpp
void google::protobuf::Repeated_mediapipe_Rasterization_Interval::slice( std::vector<std::shared_ptr<mediapipe::Rasterization::Interval>> list,
                                                                         SSIZE_T                                                          start = 0 );
AutoIt:
    $oRepeated_mediapipe_Rasterization_Interval.slice( [$start[, $list]] ) -> $list
```

### google::protobuf::Repeated_mediapipe_Rasterization_Interval::sort

```cpp
void google::protobuf::Repeated_mediapipe_Rasterization_Interval::sort( void*  comparator,
                                                                        size_t start = 0,
                                                                        size_t count = __self->get()->size() );
AutoIt:
    $oRepeated_mediapipe_Rasterization_Interval.sort( $comparator[, $start[, $count]] ) -> None
```

### google::protobuf::Repeated_mediapipe_Rasterization_Interval::sort_variant

```cpp
void google::protobuf::Repeated_mediapipe_Rasterization_Interval::sort_variant( void*  comparator,
                                                                                size_t start = 0,
                                                                                size_t count = __self->get()->size() );
AutoIt:
    $oRepeated_mediapipe_Rasterization_Interval.sort_variant( $comparator[, $start[, $count]] ) -> None
```

### google::protobuf::Repeated_mediapipe_Rasterization_Interval::splice

```cpp
void google::protobuf::Repeated_mediapipe_Rasterization_Interval::splice( std::vector<std::shared_ptr<mediapipe::Rasterization::Interval>> list,
                                                                          SSIZE_T                                                          start,
                                                                          SSIZE_T                                                          deleteCount );
AutoIt:
    $oRepeated_mediapipe_Rasterization_Interval.splice( $start, $deleteCount[, $list] ) -> $list
```

```cpp
void google::protobuf::Repeated_mediapipe_Rasterization_Interval::splice( std::vector<std::shared_ptr<mediapipe::Rasterization::Interval>> list,
                                                                          SSIZE_T                                                          start = 0 );
AutoIt:
    $oRepeated_mediapipe_Rasterization_Interval.splice( [$start[, $list]] ) -> $list
```

## mediapipe::Rasterization::Interval

### mediapipe::Rasterization::Interval::get_create

```cpp
static mediapipe::Rasterization::Interval mediapipe::Rasterization::Interval::get_create();
AutoIt:
    _Mediapipe_ObjCreate("mediapipe.Rasterization.Interval").create() -> <mediapipe.Rasterization.Interval object>
    _Mediapipe_ObjCreate("mediapipe.Rasterization.Interval")() -> <mediapipe.Rasterization.Interval object>
```

### mediapipe::Rasterization::Interval::str

```cpp
void mediapipe::Rasterization::Interval::str( std::string* output );
AutoIt:
    $oInterval.str( [$output] ) -> $output
```

## mediapipe::LocationData

### mediapipe::LocationData::get_create

```cpp
static mediapipe::LocationData mediapipe::LocationData::get_create();
AutoIt:
    _Mediapipe_ObjCreate("mediapipe.LocationData").create() -> <mediapipe.LocationData object>
    _Mediapipe_ObjCreate("mediapipe.LocationData")() -> <mediapipe.LocationData object>
```

### mediapipe::LocationData::str

```cpp
void mediapipe::LocationData::str( std::string* output );
AutoIt:
    $oLocationData.str( [$output] ) -> $output
```

## google::protobuf::Repeated_mediapipe_LocationData_RelativeKeypoint

### google::protobuf::Repeated_mediapipe_LocationData_RelativeKeypoint::create

```cpp
static google::protobuf::Repeated_mediapipe_LocationData_RelativeKeypoint google::protobuf::Repeated_mediapipe_LocationData_RelativeKeypoint::create();
AutoIt:
    _Mediapipe_ObjCreate("google.protobuf.Repeated_mediapipe_LocationData_RelativeKeypoint").create() -> <google.protobuf.Repeated_mediapipe_LocationData_RelativeKeypoint object>
```

### google::protobuf::Repeated_mediapipe_LocationData_RelativeKeypoint::CopyFrom

```cpp
void google::protobuf::Repeated_mediapipe_LocationData_RelativeKeypoint::CopyFrom( const google::protobuf::Repeated_mediapipe_LocationData_RelativeKeypoint other );
AutoIt:
    $oRepeated_mediapipe_LocationData_RelativeKeypoint.CopyFrom( $other ) -> None
```

### google::protobuf::Repeated_mediapipe_LocationData_RelativeKeypoint::MergeFrom

```cpp
void google::protobuf::Repeated_mediapipe_LocationData_RelativeKeypoint::MergeFrom( const google::protobuf::Repeated_mediapipe_LocationData_RelativeKeypoint other );
AutoIt:
    $oRepeated_mediapipe_LocationData_RelativeKeypoint.MergeFrom( $other ) -> None
```

### google::protobuf::Repeated_mediapipe_LocationData_RelativeKeypoint::Swap

```cpp
void google::protobuf::Repeated_mediapipe_LocationData_RelativeKeypoint::Swap( google::protobuf::Repeated_mediapipe_LocationData_RelativeKeypoint* other );
AutoIt:
    $oRepeated_mediapipe_LocationData_RelativeKeypoint.Swap( $other ) -> None
```

### google::protobuf::Repeated_mediapipe_LocationData_RelativeKeypoint::SwapElements

```cpp
void google::protobuf::Repeated_mediapipe_LocationData_RelativeKeypoint::SwapElements( int index1,
                                                                                       int index2 );
AutoIt:
    $oRepeated_mediapipe_LocationData_RelativeKeypoint.SwapElements( $index1, $index2 ) -> None
```

### google::protobuf::Repeated_mediapipe_LocationData_RelativeKeypoint::add

```cpp
mediapipe::LocationData::RelativeKeypoint* google::protobuf::Repeated_mediapipe_LocationData_RelativeKeypoint::add();
AutoIt:
    $oRepeated_mediapipe_LocationData_RelativeKeypoint.add() -> retval
```

```cpp
mediapipe::LocationData::RelativeKeypoint* google::protobuf::Repeated_mediapipe_LocationData_RelativeKeypoint::add( const mediapipe::LocationData::RelativeKeypoint* value );
AutoIt:
    $oRepeated_mediapipe_LocationData_RelativeKeypoint.add( $value ) -> retval
```

```cpp
mediapipe::LocationData::RelativeKeypoint* google::protobuf::Repeated_mediapipe_LocationData_RelativeKeypoint::add( std::map<std::string, _variant_t> attrs );
AutoIt:
    $oRepeated_mediapipe_LocationData_RelativeKeypoint.add( $attrs ) -> retval
```

### google::protobuf::Repeated_mediapipe_LocationData_RelativeKeypoint::clear

```cpp
void google::protobuf::Repeated_mediapipe_LocationData_RelativeKeypoint::clear();
AutoIt:
    $oRepeated_mediapipe_LocationData_RelativeKeypoint.clear() -> None
```

### google::protobuf::Repeated_mediapipe_LocationData_RelativeKeypoint::empty

```cpp
bool google::protobuf::Repeated_mediapipe_LocationData_RelativeKeypoint::empty();
AutoIt:
    $oRepeated_mediapipe_LocationData_RelativeKeypoint.empty() -> retval
```

### google::protobuf::Repeated_mediapipe_LocationData_RelativeKeypoint::extend

```cpp
void google::protobuf::Repeated_mediapipe_LocationData_RelativeKeypoint::extend( const google::protobuf::Repeated_mediapipe_LocationData_RelativeKeypoint& items );
AutoIt:
    $oRepeated_mediapipe_LocationData_RelativeKeypoint.extend( $items ) -> None
```

```cpp
void google::protobuf::Repeated_mediapipe_LocationData_RelativeKeypoint::extend( const std::vector<std::shared_ptr<mediapipe::LocationData::RelativeKeypoint>>& items );
AutoIt:
    $oRepeated_mediapipe_LocationData_RelativeKeypoint.extend( $items ) -> None
```

```cpp
void google::protobuf::Repeated_mediapipe_LocationData_RelativeKeypoint::extend( const std::vector<_variant_t>& items );
AutoIt:
    $oRepeated_mediapipe_LocationData_RelativeKeypoint.extend( $items ) -> None
```

### google::protobuf::Repeated_mediapipe_LocationData_RelativeKeypoint::get_Item

```cpp
mediapipe::LocationData::RelativeKeypoint* google::protobuf::Repeated_mediapipe_LocationData_RelativeKeypoint::get_Item( int index );
AutoIt:
    $oRepeated_mediapipe_LocationData_RelativeKeypoint.Item( $index ) -> retval
    $oRepeated_mediapipe_LocationData_RelativeKeypoint( $index ) -> retval
```

### google::protobuf::Repeated_mediapipe_LocationData_RelativeKeypoint::get__NewEnum

```cpp
IUnknown* google::protobuf::Repeated_mediapipe_LocationData_RelativeKeypoint::get__NewEnum();
AutoIt:
    $oRepeated_mediapipe_LocationData_RelativeKeypoint._NewEnum() -> retval
```

### google::protobuf::Repeated_mediapipe_LocationData_RelativeKeypoint::insert

```cpp
void google::protobuf::Repeated_mediapipe_LocationData_RelativeKeypoint::insert( SSIZE_T                                           index,
                                                                                 const mediapipe::LocationData::RelativeKeypoint*& item );
AutoIt:
    $oRepeated_mediapipe_LocationData_RelativeKeypoint.insert( $index, $item ) -> None
```

### google::protobuf::Repeated_mediapipe_LocationData_RelativeKeypoint::pop

```cpp
std::shared_ptr<mediapipe::LocationData::RelativeKeypoint> google::protobuf::Repeated_mediapipe_LocationData_RelativeKeypoint::pop( SSIZE_T index = -1 );
AutoIt:
    $oRepeated_mediapipe_LocationData_RelativeKeypoint.pop( [$index] ) -> retval
```

### google::protobuf::Repeated_mediapipe_LocationData_RelativeKeypoint::reverse

```cpp
void google::protobuf::Repeated_mediapipe_LocationData_RelativeKeypoint::reverse();
AutoIt:
    $oRepeated_mediapipe_LocationData_RelativeKeypoint.reverse() -> None
```

### google::protobuf::Repeated_mediapipe_LocationData_RelativeKeypoint::size

```cpp
int google::protobuf::Repeated_mediapipe_LocationData_RelativeKeypoint::size();
AutoIt:
    $oRepeated_mediapipe_LocationData_RelativeKeypoint.size() -> retval
```

### google::protobuf::Repeated_mediapipe_LocationData_RelativeKeypoint::slice

```cpp
void google::protobuf::Repeated_mediapipe_LocationData_RelativeKeypoint::slice( std::vector<std::shared_ptr<mediapipe::LocationData::RelativeKeypoint>> list,
                                                                                SSIZE_T                                                                 start,
                                                                                SSIZE_T                                                                 count );
AutoIt:
    $oRepeated_mediapipe_LocationData_RelativeKeypoint.slice( $start, $count[, $list] ) -> $list
```

```cpp
void google::protobuf::Repeated_mediapipe_LocationData_RelativeKeypoint::slice( std::vector<std::shared_ptr<mediapipe::LocationData::RelativeKeypoint>> list,
                                                                                SSIZE_T                                                                 start = 0 );
AutoIt:
    $oRepeated_mediapipe_LocationData_RelativeKeypoint.slice( [$start[, $list]] ) -> $list
```

### google::protobuf::Repeated_mediapipe_LocationData_RelativeKeypoint::sort

```cpp
void google::protobuf::Repeated_mediapipe_LocationData_RelativeKeypoint::sort( void*  comparator,
                                                                               size_t start = 0,
                                                                               size_t count = __self->get()->size() );
AutoIt:
    $oRepeated_mediapipe_LocationData_RelativeKeypoint.sort( $comparator[, $start[, $count]] ) -> None
```

### google::protobuf::Repeated_mediapipe_LocationData_RelativeKeypoint::sort_variant

```cpp
void google::protobuf::Repeated_mediapipe_LocationData_RelativeKeypoint::sort_variant( void*  comparator,
                                                                                       size_t start = 0,
                                                                                       size_t count = __self->get()->size() );
AutoIt:
    $oRepeated_mediapipe_LocationData_RelativeKeypoint.sort_variant( $comparator[, $start[, $count]] ) -> None
```

### google::protobuf::Repeated_mediapipe_LocationData_RelativeKeypoint::splice

```cpp
void google::protobuf::Repeated_mediapipe_LocationData_RelativeKeypoint::splice( std::vector<std::shared_ptr<mediapipe::LocationData::RelativeKeypoint>> list,
                                                                                 SSIZE_T                                                                 start,
                                                                                 SSIZE_T                                                                 deleteCount );
AutoIt:
    $oRepeated_mediapipe_LocationData_RelativeKeypoint.splice( $start, $deleteCount[, $list] ) -> $list
```

```cpp
void google::protobuf::Repeated_mediapipe_LocationData_RelativeKeypoint::splice( std::vector<std::shared_ptr<mediapipe::LocationData::RelativeKeypoint>> list,
                                                                                 SSIZE_T                                                                 start = 0 );
AutoIt:
    $oRepeated_mediapipe_LocationData_RelativeKeypoint.splice( [$start[, $list]] ) -> $list
```

## mediapipe::LocationData::BoundingBox

### mediapipe::LocationData::BoundingBox::get_create

```cpp
static mediapipe::LocationData::BoundingBox mediapipe::LocationData::BoundingBox::get_create();
AutoIt:
    _Mediapipe_ObjCreate("mediapipe.LocationData.BoundingBox").create() -> <mediapipe.LocationData.BoundingBox object>
    _Mediapipe_ObjCreate("mediapipe.LocationData.BoundingBox")() -> <mediapipe.LocationData.BoundingBox object>
```

### mediapipe::LocationData::BoundingBox::str

```cpp
void mediapipe::LocationData::BoundingBox::str( std::string* output );
AutoIt:
    $oBoundingBox.str( [$output] ) -> $output
```

## mediapipe::LocationData::RelativeBoundingBox

### mediapipe::LocationData::RelativeBoundingBox::get_create

```cpp
static mediapipe::LocationData::RelativeBoundingBox mediapipe::LocationData::RelativeBoundingBox::get_create();
AutoIt:
    _Mediapipe_ObjCreate("mediapipe.LocationData.RelativeBoundingBox").create() -> <mediapipe.LocationData.RelativeBoundingBox object>
    _Mediapipe_ObjCreate("mediapipe.LocationData.RelativeBoundingBox")() -> <mediapipe.LocationData.RelativeBoundingBox object>
```

### mediapipe::LocationData::RelativeBoundingBox::str

```cpp
void mediapipe::LocationData::RelativeBoundingBox::str( std::string* output );
AutoIt:
    $oRelativeBoundingBox.str( [$output] ) -> $output
```

## mediapipe::LocationData::BinaryMask

### mediapipe::LocationData::BinaryMask::get_create

```cpp
static mediapipe::LocationData::BinaryMask mediapipe::LocationData::BinaryMask::get_create();
AutoIt:
    _Mediapipe_ObjCreate("mediapipe.LocationData.BinaryMask").create() -> <mediapipe.LocationData.BinaryMask object>
    _Mediapipe_ObjCreate("mediapipe.LocationData.BinaryMask")() -> <mediapipe.LocationData.BinaryMask object>
```

### mediapipe::LocationData::BinaryMask::str

```cpp
void mediapipe::LocationData::BinaryMask::str( std::string* output );
AutoIt:
    $oBinaryMask.str( [$output] ) -> $output
```

## mediapipe::LocationData::RelativeKeypoint

### mediapipe::LocationData::RelativeKeypoint::get_create

```cpp
static mediapipe::LocationData::RelativeKeypoint mediapipe::LocationData::RelativeKeypoint::get_create();
AutoIt:
    _Mediapipe_ObjCreate("mediapipe.LocationData.RelativeKeypoint").create() -> <mediapipe.LocationData.RelativeKeypoint object>
    _Mediapipe_ObjCreate("mediapipe.LocationData.RelativeKeypoint")() -> <mediapipe.LocationData.RelativeKeypoint object>
```

### mediapipe::LocationData::RelativeKeypoint::str

```cpp
void mediapipe::LocationData::RelativeKeypoint::str( std::string* output );
AutoIt:
    $oRelativeKeypoint.str( [$output] ) -> $output
```

## mediapipe::Detection

### mediapipe::Detection::get_create

```cpp
static mediapipe::Detection mediapipe::Detection::get_create();
AutoIt:
    _Mediapipe_ObjCreate("mediapipe.Detection").create() -> <mediapipe.Detection object>
    _Mediapipe_ObjCreate("mediapipe.Detection")() -> <mediapipe.Detection object>
```

### mediapipe::Detection::str

```cpp
void mediapipe::Detection::str( std::string* output );
AutoIt:
    $oDetection.str( [$output] ) -> $output
```

## google::protobuf::Repeated_float

### google::protobuf::Repeated_float::create

```cpp
static google::protobuf::Repeated_float google::protobuf::Repeated_float::create();
AutoIt:
    _Mediapipe_ObjCreate("google.protobuf.Repeated_float").create() -> <google.protobuf.Repeated_float object>
```

### google::protobuf::Repeated_float::CopyFrom

```cpp
void google::protobuf::Repeated_float::CopyFrom( const google::protobuf::Repeated_float other );
AutoIt:
    $oRepeated_float.CopyFrom( $other ) -> None
```

### google::protobuf::Repeated_float::MergeFrom

```cpp
void google::protobuf::Repeated_float::MergeFrom( const google::protobuf::Repeated_float other );
AutoIt:
    $oRepeated_float.MergeFrom( $other ) -> None
```

### google::protobuf::Repeated_float::Swap

```cpp
void google::protobuf::Repeated_float::Swap( google::protobuf::Repeated_float* other );
AutoIt:
    $oRepeated_float.Swap( $other ) -> None
```

### google::protobuf::Repeated_float::SwapElements

```cpp
void google::protobuf::Repeated_float::SwapElements( int index1,
                                                     int index2 );
AutoIt:
    $oRepeated_float.SwapElements( $index1, $index2 ) -> None
```

### google::protobuf::Repeated_float::append

```cpp
void google::protobuf::Repeated_float::append( const float value );
AutoIt:
    $oRepeated_float.append( $value ) -> None
```

### google::protobuf::Repeated_float::clear

```cpp
void google::protobuf::Repeated_float::clear();
AutoIt:
    $oRepeated_float.clear() -> None
```

### google::protobuf::Repeated_float::empty

```cpp
bool google::protobuf::Repeated_float::empty();
AutoIt:
    $oRepeated_float.empty() -> retval
```

### google::protobuf::Repeated_float::extend

```cpp
void google::protobuf::Repeated_float::extend( const google::protobuf::Repeated_float& items );
AutoIt:
    $oRepeated_float.extend( $items ) -> None
```

```cpp
void google::protobuf::Repeated_float::extend( const std::vector<float>& items );
AutoIt:
    $oRepeated_float.extend( $items ) -> None
```

### google::protobuf::Repeated_float::get_Item

```cpp
float google::protobuf::Repeated_float::get_Item( int index );
AutoIt:
    $oRepeated_float.Item( $index ) -> retval
    $oRepeated_float( $index ) -> retval
```

### google::protobuf::Repeated_float::get__NewEnum

```cpp
IUnknown* google::protobuf::Repeated_float::get__NewEnum();
AutoIt:
    $oRepeated_float._NewEnum() -> retval
```

### google::protobuf::Repeated_float::insert

```cpp
void google::protobuf::Repeated_float::insert( SSIZE_T      index,
                                               const float& item );
AutoIt:
    $oRepeated_float.insert( $index, $item ) -> None
```

### google::protobuf::Repeated_float::pop

```cpp
float google::protobuf::Repeated_float::pop( SSIZE_T index = -1 );
AutoIt:
    $oRepeated_float.pop( [$index] ) -> retval
```

### google::protobuf::Repeated_float::reverse

```cpp
void google::protobuf::Repeated_float::reverse();
AutoIt:
    $oRepeated_float.reverse() -> None
```

### google::protobuf::Repeated_float::set

```cpp
void google::protobuf::Repeated_float::set( int          index,
                                            const float& value );
AutoIt:
    $oRepeated_float.set( $index, $value ) -> None
```

### google::protobuf::Repeated_float::size

```cpp
int google::protobuf::Repeated_float::size();
AutoIt:
    $oRepeated_float.size() -> retval
```

### google::protobuf::Repeated_float::slice

```cpp
void google::protobuf::Repeated_float::slice( std::vector<float> list,
                                              SSIZE_T            start,
                                              SSIZE_T            deleteCount );
AutoIt:
    $oRepeated_float.slice( $start, $deleteCount[, $list] ) -> $list
```

```cpp
void google::protobuf::Repeated_float::slice( std::vector<float> list,
                                              SSIZE_T            start = 0 );
AutoIt:
    $oRepeated_float.slice( [$start[, $list]] ) -> $list
```

### google::protobuf::Repeated_float::sort

```cpp
void google::protobuf::Repeated_float::sort( void*  comparator,
                                             size_t start = 0,
                                             size_t count = __self->get()->size() );
AutoIt:
    $oRepeated_float.sort( $comparator[, $start[, $count]] ) -> None
```

### google::protobuf::Repeated_float::sort_variant

```cpp
void google::protobuf::Repeated_float::sort_variant( void*  comparator,
                                                     size_t start = 0,
                                                     size_t count = __self->get()->size() );
AutoIt:
    $oRepeated_float.sort_variant( $comparator[, $start[, $count]] ) -> None
```

### google::protobuf::Repeated_float::splice

```cpp
void google::protobuf::Repeated_float::splice( std::vector<float> list,
                                               SSIZE_T            start,
                                               SSIZE_T            deleteCount );
AutoIt:
    $oRepeated_float.splice( $start, $deleteCount[, $list] ) -> $list
```

```cpp
void google::protobuf::Repeated_float::splice( std::vector<float> list,
                                               SSIZE_T            start = 0 );
AutoIt:
    $oRepeated_float.splice( [$start[, $list]] ) -> $list
```

## google::protobuf::Repeated_mediapipe_Detection_AssociatedDetection

### google::protobuf::Repeated_mediapipe_Detection_AssociatedDetection::create

```cpp
static google::protobuf::Repeated_mediapipe_Detection_AssociatedDetection google::protobuf::Repeated_mediapipe_Detection_AssociatedDetection::create();
AutoIt:
    _Mediapipe_ObjCreate("google.protobuf.Repeated_mediapipe_Detection_AssociatedDetection").create() -> <google.protobuf.Repeated_mediapipe_Detection_AssociatedDetection object>
```

### google::protobuf::Repeated_mediapipe_Detection_AssociatedDetection::CopyFrom

```cpp
void google::protobuf::Repeated_mediapipe_Detection_AssociatedDetection::CopyFrom( const google::protobuf::Repeated_mediapipe_Detection_AssociatedDetection other );
AutoIt:
    $oRepeated_mediapipe_Detection_AssociatedDetection.CopyFrom( $other ) -> None
```

### google::protobuf::Repeated_mediapipe_Detection_AssociatedDetection::MergeFrom

```cpp
void google::protobuf::Repeated_mediapipe_Detection_AssociatedDetection::MergeFrom( const google::protobuf::Repeated_mediapipe_Detection_AssociatedDetection other );
AutoIt:
    $oRepeated_mediapipe_Detection_AssociatedDetection.MergeFrom( $other ) -> None
```

### google::protobuf::Repeated_mediapipe_Detection_AssociatedDetection::Swap

```cpp
void google::protobuf::Repeated_mediapipe_Detection_AssociatedDetection::Swap( google::protobuf::Repeated_mediapipe_Detection_AssociatedDetection* other );
AutoIt:
    $oRepeated_mediapipe_Detection_AssociatedDetection.Swap( $other ) -> None
```

### google::protobuf::Repeated_mediapipe_Detection_AssociatedDetection::SwapElements

```cpp
void google::protobuf::Repeated_mediapipe_Detection_AssociatedDetection::SwapElements( int index1,
                                                                                       int index2 );
AutoIt:
    $oRepeated_mediapipe_Detection_AssociatedDetection.SwapElements( $index1, $index2 ) -> None
```

### google::protobuf::Repeated_mediapipe_Detection_AssociatedDetection::add

```cpp
mediapipe::Detection::AssociatedDetection* google::protobuf::Repeated_mediapipe_Detection_AssociatedDetection::add();
AutoIt:
    $oRepeated_mediapipe_Detection_AssociatedDetection.add() -> retval
```

```cpp
mediapipe::Detection::AssociatedDetection* google::protobuf::Repeated_mediapipe_Detection_AssociatedDetection::add( const mediapipe::Detection::AssociatedDetection* value );
AutoIt:
    $oRepeated_mediapipe_Detection_AssociatedDetection.add( $value ) -> retval
```

```cpp
mediapipe::Detection::AssociatedDetection* google::protobuf::Repeated_mediapipe_Detection_AssociatedDetection::add( std::map<std::string, _variant_t> attrs );
AutoIt:
    $oRepeated_mediapipe_Detection_AssociatedDetection.add( $attrs ) -> retval
```

### google::protobuf::Repeated_mediapipe_Detection_AssociatedDetection::clear

```cpp
void google::protobuf::Repeated_mediapipe_Detection_AssociatedDetection::clear();
AutoIt:
    $oRepeated_mediapipe_Detection_AssociatedDetection.clear() -> None
```

### google::protobuf::Repeated_mediapipe_Detection_AssociatedDetection::empty

```cpp
bool google::protobuf::Repeated_mediapipe_Detection_AssociatedDetection::empty();
AutoIt:
    $oRepeated_mediapipe_Detection_AssociatedDetection.empty() -> retval
```

### google::protobuf::Repeated_mediapipe_Detection_AssociatedDetection::extend

```cpp
void google::protobuf::Repeated_mediapipe_Detection_AssociatedDetection::extend( const google::protobuf::Repeated_mediapipe_Detection_AssociatedDetection& items );
AutoIt:
    $oRepeated_mediapipe_Detection_AssociatedDetection.extend( $items ) -> None
```

```cpp
void google::protobuf::Repeated_mediapipe_Detection_AssociatedDetection::extend( const std::vector<std::shared_ptr<mediapipe::Detection::AssociatedDetection>>& items );
AutoIt:
    $oRepeated_mediapipe_Detection_AssociatedDetection.extend( $items ) -> None
```

```cpp
void google::protobuf::Repeated_mediapipe_Detection_AssociatedDetection::extend( const std::vector<_variant_t>& items );
AutoIt:
    $oRepeated_mediapipe_Detection_AssociatedDetection.extend( $items ) -> None
```

### google::protobuf::Repeated_mediapipe_Detection_AssociatedDetection::get_Item

```cpp
mediapipe::Detection::AssociatedDetection* google::protobuf::Repeated_mediapipe_Detection_AssociatedDetection::get_Item( int index );
AutoIt:
    $oRepeated_mediapipe_Detection_AssociatedDetection.Item( $index ) -> retval
    $oRepeated_mediapipe_Detection_AssociatedDetection( $index ) -> retval
```

### google::protobuf::Repeated_mediapipe_Detection_AssociatedDetection::get__NewEnum

```cpp
IUnknown* google::protobuf::Repeated_mediapipe_Detection_AssociatedDetection::get__NewEnum();
AutoIt:
    $oRepeated_mediapipe_Detection_AssociatedDetection._NewEnum() -> retval
```

### google::protobuf::Repeated_mediapipe_Detection_AssociatedDetection::insert

```cpp
void google::protobuf::Repeated_mediapipe_Detection_AssociatedDetection::insert( SSIZE_T                                           index,
                                                                                 const mediapipe::Detection::AssociatedDetection*& item );
AutoIt:
    $oRepeated_mediapipe_Detection_AssociatedDetection.insert( $index, $item ) -> None
```

### google::protobuf::Repeated_mediapipe_Detection_AssociatedDetection::pop

```cpp
std::shared_ptr<mediapipe::Detection::AssociatedDetection> google::protobuf::Repeated_mediapipe_Detection_AssociatedDetection::pop( SSIZE_T index = -1 );
AutoIt:
    $oRepeated_mediapipe_Detection_AssociatedDetection.pop( [$index] ) -> retval
```

### google::protobuf::Repeated_mediapipe_Detection_AssociatedDetection::reverse

```cpp
void google::protobuf::Repeated_mediapipe_Detection_AssociatedDetection::reverse();
AutoIt:
    $oRepeated_mediapipe_Detection_AssociatedDetection.reverse() -> None
```

### google::protobuf::Repeated_mediapipe_Detection_AssociatedDetection::size

```cpp
int google::protobuf::Repeated_mediapipe_Detection_AssociatedDetection::size();
AutoIt:
    $oRepeated_mediapipe_Detection_AssociatedDetection.size() -> retval
```

### google::protobuf::Repeated_mediapipe_Detection_AssociatedDetection::slice

```cpp
void google::protobuf::Repeated_mediapipe_Detection_AssociatedDetection::slice( std::vector<std::shared_ptr<mediapipe::Detection::AssociatedDetection>> list,
                                                                                SSIZE_T                                                                 start,
                                                                                SSIZE_T                                                                 count );
AutoIt:
    $oRepeated_mediapipe_Detection_AssociatedDetection.slice( $start, $count[, $list] ) -> $list
```

```cpp
void google::protobuf::Repeated_mediapipe_Detection_AssociatedDetection::slice( std::vector<std::shared_ptr<mediapipe::Detection::AssociatedDetection>> list,
                                                                                SSIZE_T                                                                 start = 0 );
AutoIt:
    $oRepeated_mediapipe_Detection_AssociatedDetection.slice( [$start[, $list]] ) -> $list
```

### google::protobuf::Repeated_mediapipe_Detection_AssociatedDetection::sort

```cpp
void google::protobuf::Repeated_mediapipe_Detection_AssociatedDetection::sort( void*  comparator,
                                                                               size_t start = 0,
                                                                               size_t count = __self->get()->size() );
AutoIt:
    $oRepeated_mediapipe_Detection_AssociatedDetection.sort( $comparator[, $start[, $count]] ) -> None
```

### google::protobuf::Repeated_mediapipe_Detection_AssociatedDetection::sort_variant

```cpp
void google::protobuf::Repeated_mediapipe_Detection_AssociatedDetection::sort_variant( void*  comparator,
                                                                                       size_t start = 0,
                                                                                       size_t count = __self->get()->size() );
AutoIt:
    $oRepeated_mediapipe_Detection_AssociatedDetection.sort_variant( $comparator[, $start[, $count]] ) -> None
```

### google::protobuf::Repeated_mediapipe_Detection_AssociatedDetection::splice

```cpp
void google::protobuf::Repeated_mediapipe_Detection_AssociatedDetection::splice( std::vector<std::shared_ptr<mediapipe::Detection::AssociatedDetection>> list,
                                                                                 SSIZE_T                                                                 start,
                                                                                 SSIZE_T                                                                 deleteCount );
AutoIt:
    $oRepeated_mediapipe_Detection_AssociatedDetection.splice( $start, $deleteCount[, $list] ) -> $list
```

```cpp
void google::protobuf::Repeated_mediapipe_Detection_AssociatedDetection::splice( std::vector<std::shared_ptr<mediapipe::Detection::AssociatedDetection>> list,
                                                                                 SSIZE_T                                                                 start = 0 );
AutoIt:
    $oRepeated_mediapipe_Detection_AssociatedDetection.splice( [$start[, $list]] ) -> $list
```

## mediapipe::Detection::AssociatedDetection

### mediapipe::Detection::AssociatedDetection::get_create

```cpp
static mediapipe::Detection::AssociatedDetection mediapipe::Detection::AssociatedDetection::get_create();
AutoIt:
    _Mediapipe_ObjCreate("mediapipe.Detection.AssociatedDetection").create() -> <mediapipe.Detection.AssociatedDetection object>
    _Mediapipe_ObjCreate("mediapipe.Detection.AssociatedDetection")() -> <mediapipe.Detection.AssociatedDetection object>
```

### mediapipe::Detection::AssociatedDetection::str

```cpp
void mediapipe::Detection::AssociatedDetection::str( std::string* output );
AutoIt:
    $oAssociatedDetection.str( [$output] ) -> $output
```

## mediapipe::DetectionList

### mediapipe::DetectionList::get_create

```cpp
static mediapipe::DetectionList mediapipe::DetectionList::get_create();
AutoIt:
    _Mediapipe_ObjCreate("mediapipe.DetectionList").create() -> <mediapipe.DetectionList object>
    _Mediapipe_ObjCreate("mediapipe.DetectionList")() -> <mediapipe.DetectionList object>
```

### mediapipe::DetectionList::str

```cpp
void mediapipe::DetectionList::str( std::string* output );
AutoIt:
    $oDetectionList.str( [$output] ) -> $output
```

## google::protobuf::Repeated_mediapipe_Detection

### google::protobuf::Repeated_mediapipe_Detection::create

```cpp
static google::protobuf::Repeated_mediapipe_Detection google::protobuf::Repeated_mediapipe_Detection::create();
AutoIt:
    _Mediapipe_ObjCreate("google.protobuf.Repeated_mediapipe_Detection").create() -> <google.protobuf.Repeated_mediapipe_Detection object>
```

### google::protobuf::Repeated_mediapipe_Detection::CopyFrom

```cpp
void google::protobuf::Repeated_mediapipe_Detection::CopyFrom( const google::protobuf::Repeated_mediapipe_Detection other );
AutoIt:
    $oRepeated_mediapipe_Detection.CopyFrom( $other ) -> None
```

### google::protobuf::Repeated_mediapipe_Detection::MergeFrom

```cpp
void google::protobuf::Repeated_mediapipe_Detection::MergeFrom( const google::protobuf::Repeated_mediapipe_Detection other );
AutoIt:
    $oRepeated_mediapipe_Detection.MergeFrom( $other ) -> None
```

### google::protobuf::Repeated_mediapipe_Detection::Swap

```cpp
void google::protobuf::Repeated_mediapipe_Detection::Swap( google::protobuf::Repeated_mediapipe_Detection* other );
AutoIt:
    $oRepeated_mediapipe_Detection.Swap( $other ) -> None
```

### google::protobuf::Repeated_mediapipe_Detection::SwapElements

```cpp
void google::protobuf::Repeated_mediapipe_Detection::SwapElements( int index1,
                                                                   int index2 );
AutoIt:
    $oRepeated_mediapipe_Detection.SwapElements( $index1, $index2 ) -> None
```

### google::protobuf::Repeated_mediapipe_Detection::add

```cpp
mediapipe::Detection* google::protobuf::Repeated_mediapipe_Detection::add();
AutoIt:
    $oRepeated_mediapipe_Detection.add() -> retval
```

```cpp
mediapipe::Detection* google::protobuf::Repeated_mediapipe_Detection::add( const mediapipe::Detection* value );
AutoIt:
    $oRepeated_mediapipe_Detection.add( $value ) -> retval
```

```cpp
mediapipe::Detection* google::protobuf::Repeated_mediapipe_Detection::add( std::map<std::string, _variant_t> attrs );
AutoIt:
    $oRepeated_mediapipe_Detection.add( $attrs ) -> retval
```

### google::protobuf::Repeated_mediapipe_Detection::clear

```cpp
void google::protobuf::Repeated_mediapipe_Detection::clear();
AutoIt:
    $oRepeated_mediapipe_Detection.clear() -> None
```

### google::protobuf::Repeated_mediapipe_Detection::empty

```cpp
bool google::protobuf::Repeated_mediapipe_Detection::empty();
AutoIt:
    $oRepeated_mediapipe_Detection.empty() -> retval
```

### google::protobuf::Repeated_mediapipe_Detection::extend

```cpp
void google::protobuf::Repeated_mediapipe_Detection::extend( const google::protobuf::Repeated_mediapipe_Detection& items );
AutoIt:
    $oRepeated_mediapipe_Detection.extend( $items ) -> None
```

```cpp
void google::protobuf::Repeated_mediapipe_Detection::extend( const std::vector<std::shared_ptr<mediapipe::Detection>>& items );
AutoIt:
    $oRepeated_mediapipe_Detection.extend( $items ) -> None
```

```cpp
void google::protobuf::Repeated_mediapipe_Detection::extend( const std::vector<_variant_t>& items );
AutoIt:
    $oRepeated_mediapipe_Detection.extend( $items ) -> None
```

### google::protobuf::Repeated_mediapipe_Detection::get_Item

```cpp
mediapipe::Detection* google::protobuf::Repeated_mediapipe_Detection::get_Item( int index );
AutoIt:
    $oRepeated_mediapipe_Detection.Item( $index ) -> retval
    $oRepeated_mediapipe_Detection( $index ) -> retval
```

### google::protobuf::Repeated_mediapipe_Detection::get__NewEnum

```cpp
IUnknown* google::protobuf::Repeated_mediapipe_Detection::get__NewEnum();
AutoIt:
    $oRepeated_mediapipe_Detection._NewEnum() -> retval
```

### google::protobuf::Repeated_mediapipe_Detection::insert

```cpp
void google::protobuf::Repeated_mediapipe_Detection::insert( SSIZE_T                      index,
                                                             const mediapipe::Detection*& item );
AutoIt:
    $oRepeated_mediapipe_Detection.insert( $index, $item ) -> None
```

### google::protobuf::Repeated_mediapipe_Detection::pop

```cpp
std::shared_ptr<mediapipe::Detection> google::protobuf::Repeated_mediapipe_Detection::pop( SSIZE_T index = -1 );
AutoIt:
    $oRepeated_mediapipe_Detection.pop( [$index] ) -> retval
```

### google::protobuf::Repeated_mediapipe_Detection::reverse

```cpp
void google::protobuf::Repeated_mediapipe_Detection::reverse();
AutoIt:
    $oRepeated_mediapipe_Detection.reverse() -> None
```

### google::protobuf::Repeated_mediapipe_Detection::size

```cpp
int google::protobuf::Repeated_mediapipe_Detection::size();
AutoIt:
    $oRepeated_mediapipe_Detection.size() -> retval
```

### google::protobuf::Repeated_mediapipe_Detection::slice

```cpp
void google::protobuf::Repeated_mediapipe_Detection::slice( std::vector<std::shared_ptr<mediapipe::Detection>> list,
                                                            SSIZE_T                                            start,
                                                            SSIZE_T                                            count );
AutoIt:
    $oRepeated_mediapipe_Detection.slice( $start, $count[, $list] ) -> $list
```

```cpp
void google::protobuf::Repeated_mediapipe_Detection::slice( std::vector<std::shared_ptr<mediapipe::Detection>> list,
                                                            SSIZE_T                                            start = 0 );
AutoIt:
    $oRepeated_mediapipe_Detection.slice( [$start[, $list]] ) -> $list
```

### google::protobuf::Repeated_mediapipe_Detection::sort

```cpp
void google::protobuf::Repeated_mediapipe_Detection::sort( void*  comparator,
                                                           size_t start = 0,
                                                           size_t count = __self->get()->size() );
AutoIt:
    $oRepeated_mediapipe_Detection.sort( $comparator[, $start[, $count]] ) -> None
```

### google::protobuf::Repeated_mediapipe_Detection::sort_variant

```cpp
void google::protobuf::Repeated_mediapipe_Detection::sort_variant( void*  comparator,
                                                                   size_t start = 0,
                                                                   size_t count = __self->get()->size() );
AutoIt:
    $oRepeated_mediapipe_Detection.sort_variant( $comparator[, $start[, $count]] ) -> None
```

### google::protobuf::Repeated_mediapipe_Detection::splice

```cpp
void google::protobuf::Repeated_mediapipe_Detection::splice( std::vector<std::shared_ptr<mediapipe::Detection>> list,
                                                             SSIZE_T                                            start,
                                                             SSIZE_T                                            deleteCount );
AutoIt:
    $oRepeated_mediapipe_Detection.splice( $start, $deleteCount[, $list] ) -> $list
```

```cpp
void google::protobuf::Repeated_mediapipe_Detection::splice( std::vector<std::shared_ptr<mediapipe::Detection>> list,
                                                             SSIZE_T                                            start = 0 );
AutoIt:
    $oRepeated_mediapipe_Detection.splice( [$start[, $list]] ) -> $list
```

## mediapipe::ImageFormat

### mediapipe::ImageFormat::get_create

```cpp
static mediapipe::ImageFormat mediapipe::ImageFormat::get_create();
AutoIt:
    _Mediapipe_ObjCreate("mediapipe.ImageFormat").create() -> <mediapipe.ImageFormat object>
    _Mediapipe_ObjCreate("mediapipe.ImageFormat")() -> <mediapipe.ImageFormat object>
```

### mediapipe::ImageFormat::str

```cpp
void mediapipe::ImageFormat::str( std::string* output );
AutoIt:
    $oImageFormat.str( [$output] ) -> $output
```

## mediapipe::Classification

### mediapipe::Classification::get_create

```cpp
static mediapipe::Classification mediapipe::Classification::get_create();
AutoIt:
    _Mediapipe_ObjCreate("mediapipe.Classification").create() -> <mediapipe.Classification object>
    _Mediapipe_ObjCreate("mediapipe.Classification")() -> <mediapipe.Classification object>
```

### mediapipe::Classification::str

```cpp
void mediapipe::Classification::str( std::string* output );
AutoIt:
    $oClassification.str( [$output] ) -> $output
```

## mediapipe::ClassificationList

### mediapipe::ClassificationList::get_create

```cpp
static mediapipe::ClassificationList mediapipe::ClassificationList::get_create();
AutoIt:
    _Mediapipe_ObjCreate("mediapipe.ClassificationList").create() -> <mediapipe.ClassificationList object>
    _Mediapipe_ObjCreate("mediapipe.ClassificationList")() -> <mediapipe.ClassificationList object>
```

### mediapipe::ClassificationList::str

```cpp
void mediapipe::ClassificationList::str( std::string* output );
AutoIt:
    $oClassificationList.str( [$output] ) -> $output
```

## google::protobuf::Repeated_mediapipe_Classification

### google::protobuf::Repeated_mediapipe_Classification::create

```cpp
static google::protobuf::Repeated_mediapipe_Classification google::protobuf::Repeated_mediapipe_Classification::create();
AutoIt:
    _Mediapipe_ObjCreate("google.protobuf.Repeated_mediapipe_Classification").create() -> <google.protobuf.Repeated_mediapipe_Classification object>
```

### google::protobuf::Repeated_mediapipe_Classification::CopyFrom

```cpp
void google::protobuf::Repeated_mediapipe_Classification::CopyFrom( const google::protobuf::Repeated_mediapipe_Classification other );
AutoIt:
    $oRepeated_mediapipe_Classification.CopyFrom( $other ) -> None
```

### google::protobuf::Repeated_mediapipe_Classification::MergeFrom

```cpp
void google::protobuf::Repeated_mediapipe_Classification::MergeFrom( const google::protobuf::Repeated_mediapipe_Classification other );
AutoIt:
    $oRepeated_mediapipe_Classification.MergeFrom( $other ) -> None
```

### google::protobuf::Repeated_mediapipe_Classification::Swap

```cpp
void google::protobuf::Repeated_mediapipe_Classification::Swap( google::protobuf::Repeated_mediapipe_Classification* other );
AutoIt:
    $oRepeated_mediapipe_Classification.Swap( $other ) -> None
```

### google::protobuf::Repeated_mediapipe_Classification::SwapElements

```cpp
void google::protobuf::Repeated_mediapipe_Classification::SwapElements( int index1,
                                                                        int index2 );
AutoIt:
    $oRepeated_mediapipe_Classification.SwapElements( $index1, $index2 ) -> None
```

### google::protobuf::Repeated_mediapipe_Classification::add

```cpp
mediapipe::Classification* google::protobuf::Repeated_mediapipe_Classification::add();
AutoIt:
    $oRepeated_mediapipe_Classification.add() -> retval
```

```cpp
mediapipe::Classification* google::protobuf::Repeated_mediapipe_Classification::add( const mediapipe::Classification* value );
AutoIt:
    $oRepeated_mediapipe_Classification.add( $value ) -> retval
```

```cpp
mediapipe::Classification* google::protobuf::Repeated_mediapipe_Classification::add( std::map<std::string, _variant_t> attrs );
AutoIt:
    $oRepeated_mediapipe_Classification.add( $attrs ) -> retval
```

### google::protobuf::Repeated_mediapipe_Classification::clear

```cpp
void google::protobuf::Repeated_mediapipe_Classification::clear();
AutoIt:
    $oRepeated_mediapipe_Classification.clear() -> None
```

### google::protobuf::Repeated_mediapipe_Classification::empty

```cpp
bool google::protobuf::Repeated_mediapipe_Classification::empty();
AutoIt:
    $oRepeated_mediapipe_Classification.empty() -> retval
```

### google::protobuf::Repeated_mediapipe_Classification::extend

```cpp
void google::protobuf::Repeated_mediapipe_Classification::extend( const google::protobuf::Repeated_mediapipe_Classification& items );
AutoIt:
    $oRepeated_mediapipe_Classification.extend( $items ) -> None
```

```cpp
void google::protobuf::Repeated_mediapipe_Classification::extend( const std::vector<std::shared_ptr<mediapipe::Classification>>& items );
AutoIt:
    $oRepeated_mediapipe_Classification.extend( $items ) -> None
```

```cpp
void google::protobuf::Repeated_mediapipe_Classification::extend( const std::vector<_variant_t>& items );
AutoIt:
    $oRepeated_mediapipe_Classification.extend( $items ) -> None
```

### google::protobuf::Repeated_mediapipe_Classification::get_Item

```cpp
mediapipe::Classification* google::protobuf::Repeated_mediapipe_Classification::get_Item( int index );
AutoIt:
    $oRepeated_mediapipe_Classification.Item( $index ) -> retval
    $oRepeated_mediapipe_Classification( $index ) -> retval
```

### google::protobuf::Repeated_mediapipe_Classification::get__NewEnum

```cpp
IUnknown* google::protobuf::Repeated_mediapipe_Classification::get__NewEnum();
AutoIt:
    $oRepeated_mediapipe_Classification._NewEnum() -> retval
```

### google::protobuf::Repeated_mediapipe_Classification::insert

```cpp
void google::protobuf::Repeated_mediapipe_Classification::insert( SSIZE_T                           index,
                                                                  const mediapipe::Classification*& item );
AutoIt:
    $oRepeated_mediapipe_Classification.insert( $index, $item ) -> None
```

### google::protobuf::Repeated_mediapipe_Classification::pop

```cpp
std::shared_ptr<mediapipe::Classification> google::protobuf::Repeated_mediapipe_Classification::pop( SSIZE_T index = -1 );
AutoIt:
    $oRepeated_mediapipe_Classification.pop( [$index] ) -> retval
```

### google::protobuf::Repeated_mediapipe_Classification::reverse

```cpp
void google::protobuf::Repeated_mediapipe_Classification::reverse();
AutoIt:
    $oRepeated_mediapipe_Classification.reverse() -> None
```

### google::protobuf::Repeated_mediapipe_Classification::size

```cpp
int google::protobuf::Repeated_mediapipe_Classification::size();
AutoIt:
    $oRepeated_mediapipe_Classification.size() -> retval
```

### google::protobuf::Repeated_mediapipe_Classification::slice

```cpp
void google::protobuf::Repeated_mediapipe_Classification::slice( std::vector<std::shared_ptr<mediapipe::Classification>> list,
                                                                 SSIZE_T                                                 start,
                                                                 SSIZE_T                                                 count );
AutoIt:
    $oRepeated_mediapipe_Classification.slice( $start, $count[, $list] ) -> $list
```

```cpp
void google::protobuf::Repeated_mediapipe_Classification::slice( std::vector<std::shared_ptr<mediapipe::Classification>> list,
                                                                 SSIZE_T                                                 start = 0 );
AutoIt:
    $oRepeated_mediapipe_Classification.slice( [$start[, $list]] ) -> $list
```

### google::protobuf::Repeated_mediapipe_Classification::sort

```cpp
void google::protobuf::Repeated_mediapipe_Classification::sort( void*  comparator,
                                                                size_t start = 0,
                                                                size_t count = __self->get()->size() );
AutoIt:
    $oRepeated_mediapipe_Classification.sort( $comparator[, $start[, $count]] ) -> None
```

### google::protobuf::Repeated_mediapipe_Classification::sort_variant

```cpp
void google::protobuf::Repeated_mediapipe_Classification::sort_variant( void*  comparator,
                                                                        size_t start = 0,
                                                                        size_t count = __self->get()->size() );
AutoIt:
    $oRepeated_mediapipe_Classification.sort_variant( $comparator[, $start[, $count]] ) -> None
```

### google::protobuf::Repeated_mediapipe_Classification::splice

```cpp
void google::protobuf::Repeated_mediapipe_Classification::splice( std::vector<std::shared_ptr<mediapipe::Classification>> list,
                                                                  SSIZE_T                                                 start,
                                                                  SSIZE_T                                                 deleteCount );
AutoIt:
    $oRepeated_mediapipe_Classification.splice( $start, $deleteCount[, $list] ) -> $list
```

```cpp
void google::protobuf::Repeated_mediapipe_Classification::splice( std::vector<std::shared_ptr<mediapipe::Classification>> list,
                                                                  SSIZE_T                                                 start = 0 );
AutoIt:
    $oRepeated_mediapipe_Classification.splice( [$start[, $list]] ) -> $list
```

## mediapipe::ClassificationListCollection

### mediapipe::ClassificationListCollection::get_create

```cpp
static mediapipe::ClassificationListCollection mediapipe::ClassificationListCollection::get_create();
AutoIt:
    _Mediapipe_ObjCreate("mediapipe.ClassificationListCollection").create() -> <mediapipe.ClassificationListCollection object>
    _Mediapipe_ObjCreate("mediapipe.ClassificationListCollection")() -> <mediapipe.ClassificationListCollection object>
```

### mediapipe::ClassificationListCollection::str

```cpp
void mediapipe::ClassificationListCollection::str( std::string* output );
AutoIt:
    $oClassificationListCollection.str( [$output] ) -> $output
```

## google::protobuf::Repeated_mediapipe_ClassificationList

### google::protobuf::Repeated_mediapipe_ClassificationList::create

```cpp
static google::protobuf::Repeated_mediapipe_ClassificationList google::protobuf::Repeated_mediapipe_ClassificationList::create();
AutoIt:
    _Mediapipe_ObjCreate("google.protobuf.Repeated_mediapipe_ClassificationList").create() -> <google.protobuf.Repeated_mediapipe_ClassificationList object>
```

### google::protobuf::Repeated_mediapipe_ClassificationList::CopyFrom

```cpp
void google::protobuf::Repeated_mediapipe_ClassificationList::CopyFrom( const google::protobuf::Repeated_mediapipe_ClassificationList other );
AutoIt:
    $oRepeated_mediapipe_ClassificationList.CopyFrom( $other ) -> None
```

### google::protobuf::Repeated_mediapipe_ClassificationList::MergeFrom

```cpp
void google::protobuf::Repeated_mediapipe_ClassificationList::MergeFrom( const google::protobuf::Repeated_mediapipe_ClassificationList other );
AutoIt:
    $oRepeated_mediapipe_ClassificationList.MergeFrom( $other ) -> None
```

### google::protobuf::Repeated_mediapipe_ClassificationList::Swap

```cpp
void google::protobuf::Repeated_mediapipe_ClassificationList::Swap( google::protobuf::Repeated_mediapipe_ClassificationList* other );
AutoIt:
    $oRepeated_mediapipe_ClassificationList.Swap( $other ) -> None
```

### google::protobuf::Repeated_mediapipe_ClassificationList::SwapElements

```cpp
void google::protobuf::Repeated_mediapipe_ClassificationList::SwapElements( int index1,
                                                                            int index2 );
AutoIt:
    $oRepeated_mediapipe_ClassificationList.SwapElements( $index1, $index2 ) -> None
```

### google::protobuf::Repeated_mediapipe_ClassificationList::add

```cpp
mediapipe::ClassificationList* google::protobuf::Repeated_mediapipe_ClassificationList::add();
AutoIt:
    $oRepeated_mediapipe_ClassificationList.add() -> retval
```

```cpp
mediapipe::ClassificationList* google::protobuf::Repeated_mediapipe_ClassificationList::add( const mediapipe::ClassificationList* value );
AutoIt:
    $oRepeated_mediapipe_ClassificationList.add( $value ) -> retval
```

```cpp
mediapipe::ClassificationList* google::protobuf::Repeated_mediapipe_ClassificationList::add( std::map<std::string, _variant_t> attrs );
AutoIt:
    $oRepeated_mediapipe_ClassificationList.add( $attrs ) -> retval
```

### google::protobuf::Repeated_mediapipe_ClassificationList::clear

```cpp
void google::protobuf::Repeated_mediapipe_ClassificationList::clear();
AutoIt:
    $oRepeated_mediapipe_ClassificationList.clear() -> None
```

### google::protobuf::Repeated_mediapipe_ClassificationList::empty

```cpp
bool google::protobuf::Repeated_mediapipe_ClassificationList::empty();
AutoIt:
    $oRepeated_mediapipe_ClassificationList.empty() -> retval
```

### google::protobuf::Repeated_mediapipe_ClassificationList::extend

```cpp
void google::protobuf::Repeated_mediapipe_ClassificationList::extend( const google::protobuf::Repeated_mediapipe_ClassificationList& items );
AutoIt:
    $oRepeated_mediapipe_ClassificationList.extend( $items ) -> None
```

```cpp
void google::protobuf::Repeated_mediapipe_ClassificationList::extend( const std::vector<std::shared_ptr<mediapipe::ClassificationList>>& items );
AutoIt:
    $oRepeated_mediapipe_ClassificationList.extend( $items ) -> None
```

```cpp
void google::protobuf::Repeated_mediapipe_ClassificationList::extend( const std::vector<_variant_t>& items );
AutoIt:
    $oRepeated_mediapipe_ClassificationList.extend( $items ) -> None
```

### google::protobuf::Repeated_mediapipe_ClassificationList::get_Item

```cpp
mediapipe::ClassificationList* google::protobuf::Repeated_mediapipe_ClassificationList::get_Item( int index );
AutoIt:
    $oRepeated_mediapipe_ClassificationList.Item( $index ) -> retval
    $oRepeated_mediapipe_ClassificationList( $index ) -> retval
```

### google::protobuf::Repeated_mediapipe_ClassificationList::get__NewEnum

```cpp
IUnknown* google::protobuf::Repeated_mediapipe_ClassificationList::get__NewEnum();
AutoIt:
    $oRepeated_mediapipe_ClassificationList._NewEnum() -> retval
```

### google::protobuf::Repeated_mediapipe_ClassificationList::insert

```cpp
void google::protobuf::Repeated_mediapipe_ClassificationList::insert( SSIZE_T                               index,
                                                                      const mediapipe::ClassificationList*& item );
AutoIt:
    $oRepeated_mediapipe_ClassificationList.insert( $index, $item ) -> None
```

### google::protobuf::Repeated_mediapipe_ClassificationList::pop

```cpp
std::shared_ptr<mediapipe::ClassificationList> google::protobuf::Repeated_mediapipe_ClassificationList::pop( SSIZE_T index = -1 );
AutoIt:
    $oRepeated_mediapipe_ClassificationList.pop( [$index] ) -> retval
```

### google::protobuf::Repeated_mediapipe_ClassificationList::reverse

```cpp
void google::protobuf::Repeated_mediapipe_ClassificationList::reverse();
AutoIt:
    $oRepeated_mediapipe_ClassificationList.reverse() -> None
```

### google::protobuf::Repeated_mediapipe_ClassificationList::size

```cpp
int google::protobuf::Repeated_mediapipe_ClassificationList::size();
AutoIt:
    $oRepeated_mediapipe_ClassificationList.size() -> retval
```

### google::protobuf::Repeated_mediapipe_ClassificationList::slice

```cpp
void google::protobuf::Repeated_mediapipe_ClassificationList::slice( std::vector<std::shared_ptr<mediapipe::ClassificationList>> list,
                                                                     SSIZE_T                                                     start,
                                                                     SSIZE_T                                                     count );
AutoIt:
    $oRepeated_mediapipe_ClassificationList.slice( $start, $count[, $list] ) -> $list
```

```cpp
void google::protobuf::Repeated_mediapipe_ClassificationList::slice( std::vector<std::shared_ptr<mediapipe::ClassificationList>> list,
                                                                     SSIZE_T                                                     start = 0 );
AutoIt:
    $oRepeated_mediapipe_ClassificationList.slice( [$start[, $list]] ) -> $list
```

### google::protobuf::Repeated_mediapipe_ClassificationList::sort

```cpp
void google::protobuf::Repeated_mediapipe_ClassificationList::sort( void*  comparator,
                                                                    size_t start = 0,
                                                                    size_t count = __self->get()->size() );
AutoIt:
    $oRepeated_mediapipe_ClassificationList.sort( $comparator[, $start[, $count]] ) -> None
```

### google::protobuf::Repeated_mediapipe_ClassificationList::sort_variant

```cpp
void google::protobuf::Repeated_mediapipe_ClassificationList::sort_variant( void*  comparator,
                                                                            size_t start = 0,
                                                                            size_t count = __self->get()->size() );
AutoIt:
    $oRepeated_mediapipe_ClassificationList.sort_variant( $comparator[, $start[, $count]] ) -> None
```

### google::protobuf::Repeated_mediapipe_ClassificationList::splice

```cpp
void google::protobuf::Repeated_mediapipe_ClassificationList::splice( std::vector<std::shared_ptr<mediapipe::ClassificationList>> list,
                                                                      SSIZE_T                                                     start,
                                                                      SSIZE_T                                                     deleteCount );
AutoIt:
    $oRepeated_mediapipe_ClassificationList.splice( $start, $deleteCount[, $list] ) -> $list
```

```cpp
void google::protobuf::Repeated_mediapipe_ClassificationList::splice( std::vector<std::shared_ptr<mediapipe::ClassificationList>> list,
                                                                      SSIZE_T                                                     start = 0 );
AutoIt:
    $oRepeated_mediapipe_ClassificationList.splice( [$start[, $list]] ) -> $list
```

## mediapipe::Landmark

### mediapipe::Landmark::get_create

```cpp
static mediapipe::Landmark mediapipe::Landmark::get_create();
AutoIt:
    _Mediapipe_ObjCreate("mediapipe.Landmark").create() -> <mediapipe.Landmark object>
    _Mediapipe_ObjCreate("mediapipe.Landmark")() -> <mediapipe.Landmark object>
```

### mediapipe::Landmark::str

```cpp
void mediapipe::Landmark::str( std::string* output );
AutoIt:
    $oLandmark.str( [$output] ) -> $output
```

## mediapipe::LandmarkList

### mediapipe::LandmarkList::get_create

```cpp
static mediapipe::LandmarkList mediapipe::LandmarkList::get_create();
AutoIt:
    _Mediapipe_ObjCreate("mediapipe.LandmarkList").create() -> <mediapipe.LandmarkList object>
    _Mediapipe_ObjCreate("mediapipe.LandmarkList")() -> <mediapipe.LandmarkList object>
```

### mediapipe::LandmarkList::str

```cpp
void mediapipe::LandmarkList::str( std::string* output );
AutoIt:
    $oLandmarkList.str( [$output] ) -> $output
```

## google::protobuf::Repeated_mediapipe_Landmark

### google::protobuf::Repeated_mediapipe_Landmark::create

```cpp
static google::protobuf::Repeated_mediapipe_Landmark google::protobuf::Repeated_mediapipe_Landmark::create();
AutoIt:
    _Mediapipe_ObjCreate("google.protobuf.Repeated_mediapipe_Landmark").create() -> <google.protobuf.Repeated_mediapipe_Landmark object>
```

### google::protobuf::Repeated_mediapipe_Landmark::CopyFrom

```cpp
void google::protobuf::Repeated_mediapipe_Landmark::CopyFrom( const google::protobuf::Repeated_mediapipe_Landmark other );
AutoIt:
    $oRepeated_mediapipe_Landmark.CopyFrom( $other ) -> None
```

### google::protobuf::Repeated_mediapipe_Landmark::MergeFrom

```cpp
void google::protobuf::Repeated_mediapipe_Landmark::MergeFrom( const google::protobuf::Repeated_mediapipe_Landmark other );
AutoIt:
    $oRepeated_mediapipe_Landmark.MergeFrom( $other ) -> None
```

### google::protobuf::Repeated_mediapipe_Landmark::Swap

```cpp
void google::protobuf::Repeated_mediapipe_Landmark::Swap( google::protobuf::Repeated_mediapipe_Landmark* other );
AutoIt:
    $oRepeated_mediapipe_Landmark.Swap( $other ) -> None
```

### google::protobuf::Repeated_mediapipe_Landmark::SwapElements

```cpp
void google::protobuf::Repeated_mediapipe_Landmark::SwapElements( int index1,
                                                                  int index2 );
AutoIt:
    $oRepeated_mediapipe_Landmark.SwapElements( $index1, $index2 ) -> None
```

### google::protobuf::Repeated_mediapipe_Landmark::add

```cpp
mediapipe::Landmark* google::protobuf::Repeated_mediapipe_Landmark::add();
AutoIt:
    $oRepeated_mediapipe_Landmark.add() -> retval
```

```cpp
mediapipe::Landmark* google::protobuf::Repeated_mediapipe_Landmark::add( const mediapipe::Landmark* value );
AutoIt:
    $oRepeated_mediapipe_Landmark.add( $value ) -> retval
```

```cpp
mediapipe::Landmark* google::protobuf::Repeated_mediapipe_Landmark::add( std::map<std::string, _variant_t> attrs );
AutoIt:
    $oRepeated_mediapipe_Landmark.add( $attrs ) -> retval
```

### google::protobuf::Repeated_mediapipe_Landmark::clear

```cpp
void google::protobuf::Repeated_mediapipe_Landmark::clear();
AutoIt:
    $oRepeated_mediapipe_Landmark.clear() -> None
```

### google::protobuf::Repeated_mediapipe_Landmark::empty

```cpp
bool google::protobuf::Repeated_mediapipe_Landmark::empty();
AutoIt:
    $oRepeated_mediapipe_Landmark.empty() -> retval
```

### google::protobuf::Repeated_mediapipe_Landmark::extend

```cpp
void google::protobuf::Repeated_mediapipe_Landmark::extend( const google::protobuf::Repeated_mediapipe_Landmark& items );
AutoIt:
    $oRepeated_mediapipe_Landmark.extend( $items ) -> None
```

```cpp
void google::protobuf::Repeated_mediapipe_Landmark::extend( const std::vector<std::shared_ptr<mediapipe::Landmark>>& items );
AutoIt:
    $oRepeated_mediapipe_Landmark.extend( $items ) -> None
```

```cpp
void google::protobuf::Repeated_mediapipe_Landmark::extend( const std::vector<_variant_t>& items );
AutoIt:
    $oRepeated_mediapipe_Landmark.extend( $items ) -> None
```

### google::protobuf::Repeated_mediapipe_Landmark::get_Item

```cpp
mediapipe::Landmark* google::protobuf::Repeated_mediapipe_Landmark::get_Item( int index );
AutoIt:
    $oRepeated_mediapipe_Landmark.Item( $index ) -> retval
    $oRepeated_mediapipe_Landmark( $index ) -> retval
```

### google::protobuf::Repeated_mediapipe_Landmark::get__NewEnum

```cpp
IUnknown* google::protobuf::Repeated_mediapipe_Landmark::get__NewEnum();
AutoIt:
    $oRepeated_mediapipe_Landmark._NewEnum() -> retval
```

### google::protobuf::Repeated_mediapipe_Landmark::insert

```cpp
void google::protobuf::Repeated_mediapipe_Landmark::insert( SSIZE_T                     index,
                                                            const mediapipe::Landmark*& item );
AutoIt:
    $oRepeated_mediapipe_Landmark.insert( $index, $item ) -> None
```

### google::protobuf::Repeated_mediapipe_Landmark::pop

```cpp
std::shared_ptr<mediapipe::Landmark> google::protobuf::Repeated_mediapipe_Landmark::pop( SSIZE_T index = -1 );
AutoIt:
    $oRepeated_mediapipe_Landmark.pop( [$index] ) -> retval
```

### google::protobuf::Repeated_mediapipe_Landmark::reverse

```cpp
void google::protobuf::Repeated_mediapipe_Landmark::reverse();
AutoIt:
    $oRepeated_mediapipe_Landmark.reverse() -> None
```

### google::protobuf::Repeated_mediapipe_Landmark::size

```cpp
int google::protobuf::Repeated_mediapipe_Landmark::size();
AutoIt:
    $oRepeated_mediapipe_Landmark.size() -> retval
```

### google::protobuf::Repeated_mediapipe_Landmark::slice

```cpp
void google::protobuf::Repeated_mediapipe_Landmark::slice( std::vector<std::shared_ptr<mediapipe::Landmark>> list,
                                                           SSIZE_T                                           start,
                                                           SSIZE_T                                           count );
AutoIt:
    $oRepeated_mediapipe_Landmark.slice( $start, $count[, $list] ) -> $list
```

```cpp
void google::protobuf::Repeated_mediapipe_Landmark::slice( std::vector<std::shared_ptr<mediapipe::Landmark>> list,
                                                           SSIZE_T                                           start = 0 );
AutoIt:
    $oRepeated_mediapipe_Landmark.slice( [$start[, $list]] ) -> $list
```

### google::protobuf::Repeated_mediapipe_Landmark::sort

```cpp
void google::protobuf::Repeated_mediapipe_Landmark::sort( void*  comparator,
                                                          size_t start = 0,
                                                          size_t count = __self->get()->size() );
AutoIt:
    $oRepeated_mediapipe_Landmark.sort( $comparator[, $start[, $count]] ) -> None
```

### google::protobuf::Repeated_mediapipe_Landmark::sort_variant

```cpp
void google::protobuf::Repeated_mediapipe_Landmark::sort_variant( void*  comparator,
                                                                  size_t start = 0,
                                                                  size_t count = __self->get()->size() );
AutoIt:
    $oRepeated_mediapipe_Landmark.sort_variant( $comparator[, $start[, $count]] ) -> None
```

### google::protobuf::Repeated_mediapipe_Landmark::splice

```cpp
void google::protobuf::Repeated_mediapipe_Landmark::splice( std::vector<std::shared_ptr<mediapipe::Landmark>> list,
                                                            SSIZE_T                                           start,
                                                            SSIZE_T                                           deleteCount );
AutoIt:
    $oRepeated_mediapipe_Landmark.splice( $start, $deleteCount[, $list] ) -> $list
```

```cpp
void google::protobuf::Repeated_mediapipe_Landmark::splice( std::vector<std::shared_ptr<mediapipe::Landmark>> list,
                                                            SSIZE_T                                           start = 0 );
AutoIt:
    $oRepeated_mediapipe_Landmark.splice( [$start[, $list]] ) -> $list
```

## mediapipe::LandmarkListCollection

### mediapipe::LandmarkListCollection::get_create

```cpp
static mediapipe::LandmarkListCollection mediapipe::LandmarkListCollection::get_create();
AutoIt:
    _Mediapipe_ObjCreate("mediapipe.LandmarkListCollection").create() -> <mediapipe.LandmarkListCollection object>
    _Mediapipe_ObjCreate("mediapipe.LandmarkListCollection")() -> <mediapipe.LandmarkListCollection object>
```

### mediapipe::LandmarkListCollection::str

```cpp
void mediapipe::LandmarkListCollection::str( std::string* output );
AutoIt:
    $oLandmarkListCollection.str( [$output] ) -> $output
```

## google::protobuf::Repeated_mediapipe_LandmarkList

### google::protobuf::Repeated_mediapipe_LandmarkList::create

```cpp
static google::protobuf::Repeated_mediapipe_LandmarkList google::protobuf::Repeated_mediapipe_LandmarkList::create();
AutoIt:
    _Mediapipe_ObjCreate("google.protobuf.Repeated_mediapipe_LandmarkList").create() -> <google.protobuf.Repeated_mediapipe_LandmarkList object>
```

### google::protobuf::Repeated_mediapipe_LandmarkList::CopyFrom

```cpp
void google::protobuf::Repeated_mediapipe_LandmarkList::CopyFrom( const google::protobuf::Repeated_mediapipe_LandmarkList other );
AutoIt:
    $oRepeated_mediapipe_LandmarkList.CopyFrom( $other ) -> None
```

### google::protobuf::Repeated_mediapipe_LandmarkList::MergeFrom

```cpp
void google::protobuf::Repeated_mediapipe_LandmarkList::MergeFrom( const google::protobuf::Repeated_mediapipe_LandmarkList other );
AutoIt:
    $oRepeated_mediapipe_LandmarkList.MergeFrom( $other ) -> None
```

### google::protobuf::Repeated_mediapipe_LandmarkList::Swap

```cpp
void google::protobuf::Repeated_mediapipe_LandmarkList::Swap( google::protobuf::Repeated_mediapipe_LandmarkList* other );
AutoIt:
    $oRepeated_mediapipe_LandmarkList.Swap( $other ) -> None
```

### google::protobuf::Repeated_mediapipe_LandmarkList::SwapElements

```cpp
void google::protobuf::Repeated_mediapipe_LandmarkList::SwapElements( int index1,
                                                                      int index2 );
AutoIt:
    $oRepeated_mediapipe_LandmarkList.SwapElements( $index1, $index2 ) -> None
```

### google::protobuf::Repeated_mediapipe_LandmarkList::add

```cpp
mediapipe::LandmarkList* google::protobuf::Repeated_mediapipe_LandmarkList::add();
AutoIt:
    $oRepeated_mediapipe_LandmarkList.add() -> retval
```

```cpp
mediapipe::LandmarkList* google::protobuf::Repeated_mediapipe_LandmarkList::add( const mediapipe::LandmarkList* value );
AutoIt:
    $oRepeated_mediapipe_LandmarkList.add( $value ) -> retval
```

```cpp
mediapipe::LandmarkList* google::protobuf::Repeated_mediapipe_LandmarkList::add( std::map<std::string, _variant_t> attrs );
AutoIt:
    $oRepeated_mediapipe_LandmarkList.add( $attrs ) -> retval
```

### google::protobuf::Repeated_mediapipe_LandmarkList::clear

```cpp
void google::protobuf::Repeated_mediapipe_LandmarkList::clear();
AutoIt:
    $oRepeated_mediapipe_LandmarkList.clear() -> None
```

### google::protobuf::Repeated_mediapipe_LandmarkList::empty

```cpp
bool google::protobuf::Repeated_mediapipe_LandmarkList::empty();
AutoIt:
    $oRepeated_mediapipe_LandmarkList.empty() -> retval
```

### google::protobuf::Repeated_mediapipe_LandmarkList::extend

```cpp
void google::protobuf::Repeated_mediapipe_LandmarkList::extend( const google::protobuf::Repeated_mediapipe_LandmarkList& items );
AutoIt:
    $oRepeated_mediapipe_LandmarkList.extend( $items ) -> None
```

```cpp
void google::protobuf::Repeated_mediapipe_LandmarkList::extend( const std::vector<std::shared_ptr<mediapipe::LandmarkList>>& items );
AutoIt:
    $oRepeated_mediapipe_LandmarkList.extend( $items ) -> None
```

```cpp
void google::protobuf::Repeated_mediapipe_LandmarkList::extend( const std::vector<_variant_t>& items );
AutoIt:
    $oRepeated_mediapipe_LandmarkList.extend( $items ) -> None
```

### google::protobuf::Repeated_mediapipe_LandmarkList::get_Item

```cpp
mediapipe::LandmarkList* google::protobuf::Repeated_mediapipe_LandmarkList::get_Item( int index );
AutoIt:
    $oRepeated_mediapipe_LandmarkList.Item( $index ) -> retval
    $oRepeated_mediapipe_LandmarkList( $index ) -> retval
```

### google::protobuf::Repeated_mediapipe_LandmarkList::get__NewEnum

```cpp
IUnknown* google::protobuf::Repeated_mediapipe_LandmarkList::get__NewEnum();
AutoIt:
    $oRepeated_mediapipe_LandmarkList._NewEnum() -> retval
```

### google::protobuf::Repeated_mediapipe_LandmarkList::insert

```cpp
void google::protobuf::Repeated_mediapipe_LandmarkList::insert( SSIZE_T                         index,
                                                                const mediapipe::LandmarkList*& item );
AutoIt:
    $oRepeated_mediapipe_LandmarkList.insert( $index, $item ) -> None
```

### google::protobuf::Repeated_mediapipe_LandmarkList::pop

```cpp
std::shared_ptr<mediapipe::LandmarkList> google::protobuf::Repeated_mediapipe_LandmarkList::pop( SSIZE_T index = -1 );
AutoIt:
    $oRepeated_mediapipe_LandmarkList.pop( [$index] ) -> retval
```

### google::protobuf::Repeated_mediapipe_LandmarkList::reverse

```cpp
void google::protobuf::Repeated_mediapipe_LandmarkList::reverse();
AutoIt:
    $oRepeated_mediapipe_LandmarkList.reverse() -> None
```

### google::protobuf::Repeated_mediapipe_LandmarkList::size

```cpp
int google::protobuf::Repeated_mediapipe_LandmarkList::size();
AutoIt:
    $oRepeated_mediapipe_LandmarkList.size() -> retval
```

### google::protobuf::Repeated_mediapipe_LandmarkList::slice

```cpp
void google::protobuf::Repeated_mediapipe_LandmarkList::slice( std::vector<std::shared_ptr<mediapipe::LandmarkList>> list,
                                                               SSIZE_T                                               start,
                                                               SSIZE_T                                               count );
AutoIt:
    $oRepeated_mediapipe_LandmarkList.slice( $start, $count[, $list] ) -> $list
```

```cpp
void google::protobuf::Repeated_mediapipe_LandmarkList::slice( std::vector<std::shared_ptr<mediapipe::LandmarkList>> list,
                                                               SSIZE_T                                               start = 0 );
AutoIt:
    $oRepeated_mediapipe_LandmarkList.slice( [$start[, $list]] ) -> $list
```

### google::protobuf::Repeated_mediapipe_LandmarkList::sort

```cpp
void google::protobuf::Repeated_mediapipe_LandmarkList::sort( void*  comparator,
                                                              size_t start = 0,
                                                              size_t count = __self->get()->size() );
AutoIt:
    $oRepeated_mediapipe_LandmarkList.sort( $comparator[, $start[, $count]] ) -> None
```

### google::protobuf::Repeated_mediapipe_LandmarkList::sort_variant

```cpp
void google::protobuf::Repeated_mediapipe_LandmarkList::sort_variant( void*  comparator,
                                                                      size_t start = 0,
                                                                      size_t count = __self->get()->size() );
AutoIt:
    $oRepeated_mediapipe_LandmarkList.sort_variant( $comparator[, $start[, $count]] ) -> None
```

### google::protobuf::Repeated_mediapipe_LandmarkList::splice

```cpp
void google::protobuf::Repeated_mediapipe_LandmarkList::splice( std::vector<std::shared_ptr<mediapipe::LandmarkList>> list,
                                                                SSIZE_T                                               start,
                                                                SSIZE_T                                               deleteCount );
AutoIt:
    $oRepeated_mediapipe_LandmarkList.splice( $start, $deleteCount[, $list] ) -> $list
```

```cpp
void google::protobuf::Repeated_mediapipe_LandmarkList::splice( std::vector<std::shared_ptr<mediapipe::LandmarkList>> list,
                                                                SSIZE_T                                               start = 0 );
AutoIt:
    $oRepeated_mediapipe_LandmarkList.splice( [$start[, $list]] ) -> $list
```

## mediapipe::NormalizedLandmark

### mediapipe::NormalizedLandmark::get_create

```cpp
static mediapipe::NormalizedLandmark mediapipe::NormalizedLandmark::get_create();
AutoIt:
    _Mediapipe_ObjCreate("mediapipe.NormalizedLandmark").create() -> <mediapipe.NormalizedLandmark object>
    _Mediapipe_ObjCreate("mediapipe.NormalizedLandmark")() -> <mediapipe.NormalizedLandmark object>
```

### mediapipe::NormalizedLandmark::str

```cpp
void mediapipe::NormalizedLandmark::str( std::string* output );
AutoIt:
    $oNormalizedLandmark.str( [$output] ) -> $output
```

## mediapipe::NormalizedLandmarkList

### mediapipe::NormalizedLandmarkList::get_create

```cpp
static mediapipe::NormalizedLandmarkList mediapipe::NormalizedLandmarkList::get_create();
AutoIt:
    _Mediapipe_ObjCreate("mediapipe.NormalizedLandmarkList").create() -> <mediapipe.NormalizedLandmarkList object>
    _Mediapipe_ObjCreate("mediapipe.NormalizedLandmarkList")() -> <mediapipe.NormalizedLandmarkList object>
```

### mediapipe::NormalizedLandmarkList::str

```cpp
void mediapipe::NormalizedLandmarkList::str( std::string* output );
AutoIt:
    $oNormalizedLandmarkList.str( [$output] ) -> $output
```

## google::protobuf::Repeated_mediapipe_NormalizedLandmark

### google::protobuf::Repeated_mediapipe_NormalizedLandmark::create

```cpp
static google::protobuf::Repeated_mediapipe_NormalizedLandmark google::protobuf::Repeated_mediapipe_NormalizedLandmark::create();
AutoIt:
    _Mediapipe_ObjCreate("google.protobuf.Repeated_mediapipe_NormalizedLandmark").create() -> <google.protobuf.Repeated_mediapipe_NormalizedLandmark object>
```

### google::protobuf::Repeated_mediapipe_NormalizedLandmark::CopyFrom

```cpp
void google::protobuf::Repeated_mediapipe_NormalizedLandmark::CopyFrom( const google::protobuf::Repeated_mediapipe_NormalizedLandmark other );
AutoIt:
    $oRepeated_mediapipe_NormalizedLandmark.CopyFrom( $other ) -> None
```

### google::protobuf::Repeated_mediapipe_NormalizedLandmark::MergeFrom

```cpp
void google::protobuf::Repeated_mediapipe_NormalizedLandmark::MergeFrom( const google::protobuf::Repeated_mediapipe_NormalizedLandmark other );
AutoIt:
    $oRepeated_mediapipe_NormalizedLandmark.MergeFrom( $other ) -> None
```

### google::protobuf::Repeated_mediapipe_NormalizedLandmark::Swap

```cpp
void google::protobuf::Repeated_mediapipe_NormalizedLandmark::Swap( google::protobuf::Repeated_mediapipe_NormalizedLandmark* other );
AutoIt:
    $oRepeated_mediapipe_NormalizedLandmark.Swap( $other ) -> None
```

### google::protobuf::Repeated_mediapipe_NormalizedLandmark::SwapElements

```cpp
void google::protobuf::Repeated_mediapipe_NormalizedLandmark::SwapElements( int index1,
                                                                            int index2 );
AutoIt:
    $oRepeated_mediapipe_NormalizedLandmark.SwapElements( $index1, $index2 ) -> None
```

### google::protobuf::Repeated_mediapipe_NormalizedLandmark::add

```cpp
mediapipe::NormalizedLandmark* google::protobuf::Repeated_mediapipe_NormalizedLandmark::add();
AutoIt:
    $oRepeated_mediapipe_NormalizedLandmark.add() -> retval
```

```cpp
mediapipe::NormalizedLandmark* google::protobuf::Repeated_mediapipe_NormalizedLandmark::add( const mediapipe::NormalizedLandmark* value );
AutoIt:
    $oRepeated_mediapipe_NormalizedLandmark.add( $value ) -> retval
```

```cpp
mediapipe::NormalizedLandmark* google::protobuf::Repeated_mediapipe_NormalizedLandmark::add( std::map<std::string, _variant_t> attrs );
AutoIt:
    $oRepeated_mediapipe_NormalizedLandmark.add( $attrs ) -> retval
```

### google::protobuf::Repeated_mediapipe_NormalizedLandmark::clear

```cpp
void google::protobuf::Repeated_mediapipe_NormalizedLandmark::clear();
AutoIt:
    $oRepeated_mediapipe_NormalizedLandmark.clear() -> None
```

### google::protobuf::Repeated_mediapipe_NormalizedLandmark::empty

```cpp
bool google::protobuf::Repeated_mediapipe_NormalizedLandmark::empty();
AutoIt:
    $oRepeated_mediapipe_NormalizedLandmark.empty() -> retval
```

### google::protobuf::Repeated_mediapipe_NormalizedLandmark::extend

```cpp
void google::protobuf::Repeated_mediapipe_NormalizedLandmark::extend( const google::protobuf::Repeated_mediapipe_NormalizedLandmark& items );
AutoIt:
    $oRepeated_mediapipe_NormalizedLandmark.extend( $items ) -> None
```

```cpp
void google::protobuf::Repeated_mediapipe_NormalizedLandmark::extend( const std::vector<std::shared_ptr<mediapipe::NormalizedLandmark>>& items );
AutoIt:
    $oRepeated_mediapipe_NormalizedLandmark.extend( $items ) -> None
```

```cpp
void google::protobuf::Repeated_mediapipe_NormalizedLandmark::extend( const std::vector<_variant_t>& items );
AutoIt:
    $oRepeated_mediapipe_NormalizedLandmark.extend( $items ) -> None
```

### google::protobuf::Repeated_mediapipe_NormalizedLandmark::get_Item

```cpp
mediapipe::NormalizedLandmark* google::protobuf::Repeated_mediapipe_NormalizedLandmark::get_Item( int index );
AutoIt:
    $oRepeated_mediapipe_NormalizedLandmark.Item( $index ) -> retval
    $oRepeated_mediapipe_NormalizedLandmark( $index ) -> retval
```

### google::protobuf::Repeated_mediapipe_NormalizedLandmark::get__NewEnum

```cpp
IUnknown* google::protobuf::Repeated_mediapipe_NormalizedLandmark::get__NewEnum();
AutoIt:
    $oRepeated_mediapipe_NormalizedLandmark._NewEnum() -> retval
```

### google::protobuf::Repeated_mediapipe_NormalizedLandmark::insert

```cpp
void google::protobuf::Repeated_mediapipe_NormalizedLandmark::insert( SSIZE_T                               index,
                                                                      const mediapipe::NormalizedLandmark*& item );
AutoIt:
    $oRepeated_mediapipe_NormalizedLandmark.insert( $index, $item ) -> None
```

### google::protobuf::Repeated_mediapipe_NormalizedLandmark::pop

```cpp
std::shared_ptr<mediapipe::NormalizedLandmark> google::protobuf::Repeated_mediapipe_NormalizedLandmark::pop( SSIZE_T index = -1 );
AutoIt:
    $oRepeated_mediapipe_NormalizedLandmark.pop( [$index] ) -> retval
```

### google::protobuf::Repeated_mediapipe_NormalizedLandmark::reverse

```cpp
void google::protobuf::Repeated_mediapipe_NormalizedLandmark::reverse();
AutoIt:
    $oRepeated_mediapipe_NormalizedLandmark.reverse() -> None
```

### google::protobuf::Repeated_mediapipe_NormalizedLandmark::size

```cpp
int google::protobuf::Repeated_mediapipe_NormalizedLandmark::size();
AutoIt:
    $oRepeated_mediapipe_NormalizedLandmark.size() -> retval
```

### google::protobuf::Repeated_mediapipe_NormalizedLandmark::slice

```cpp
void google::protobuf::Repeated_mediapipe_NormalizedLandmark::slice( std::vector<std::shared_ptr<mediapipe::NormalizedLandmark>> list,
                                                                     SSIZE_T                                                     start,
                                                                     SSIZE_T                                                     count );
AutoIt:
    $oRepeated_mediapipe_NormalizedLandmark.slice( $start, $count[, $list] ) -> $list
```

```cpp
void google::protobuf::Repeated_mediapipe_NormalizedLandmark::slice( std::vector<std::shared_ptr<mediapipe::NormalizedLandmark>> list,
                                                                     SSIZE_T                                                     start = 0 );
AutoIt:
    $oRepeated_mediapipe_NormalizedLandmark.slice( [$start[, $list]] ) -> $list
```

### google::protobuf::Repeated_mediapipe_NormalizedLandmark::sort

```cpp
void google::protobuf::Repeated_mediapipe_NormalizedLandmark::sort( void*  comparator,
                                                                    size_t start = 0,
                                                                    size_t count = __self->get()->size() );
AutoIt:
    $oRepeated_mediapipe_NormalizedLandmark.sort( $comparator[, $start[, $count]] ) -> None
```

### google::protobuf::Repeated_mediapipe_NormalizedLandmark::sort_variant

```cpp
void google::protobuf::Repeated_mediapipe_NormalizedLandmark::sort_variant( void*  comparator,
                                                                            size_t start = 0,
                                                                            size_t count = __self->get()->size() );
AutoIt:
    $oRepeated_mediapipe_NormalizedLandmark.sort_variant( $comparator[, $start[, $count]] ) -> None
```

### google::protobuf::Repeated_mediapipe_NormalizedLandmark::splice

```cpp
void google::protobuf::Repeated_mediapipe_NormalizedLandmark::splice( std::vector<std::shared_ptr<mediapipe::NormalizedLandmark>> list,
                                                                      SSIZE_T                                                     start,
                                                                      SSIZE_T                                                     deleteCount );
AutoIt:
    $oRepeated_mediapipe_NormalizedLandmark.splice( $start, $deleteCount[, $list] ) -> $list
```

```cpp
void google::protobuf::Repeated_mediapipe_NormalizedLandmark::splice( std::vector<std::shared_ptr<mediapipe::NormalizedLandmark>> list,
                                                                      SSIZE_T                                                     start = 0 );
AutoIt:
    $oRepeated_mediapipe_NormalizedLandmark.splice( [$start[, $list]] ) -> $list
```

## mediapipe::NormalizedLandmarkListCollection

### mediapipe::NormalizedLandmarkListCollection::get_create

```cpp
static mediapipe::NormalizedLandmarkListCollection mediapipe::NormalizedLandmarkListCollection::get_create();
AutoIt:
    _Mediapipe_ObjCreate("mediapipe.NormalizedLandmarkListCollection").create() -> <mediapipe.NormalizedLandmarkListCollection object>
    _Mediapipe_ObjCreate("mediapipe.NormalizedLandmarkListCollection")() -> <mediapipe.NormalizedLandmarkListCollection object>
```

### mediapipe::NormalizedLandmarkListCollection::str

```cpp
void mediapipe::NormalizedLandmarkListCollection::str( std::string* output );
AutoIt:
    $oNormalizedLandmarkListCollection.str( [$output] ) -> $output
```

## google::protobuf::Repeated_mediapipe_NormalizedLandmarkList

### google::protobuf::Repeated_mediapipe_NormalizedLandmarkList::create

```cpp
static google::protobuf::Repeated_mediapipe_NormalizedLandmarkList google::protobuf::Repeated_mediapipe_NormalizedLandmarkList::create();
AutoIt:
    _Mediapipe_ObjCreate("google.protobuf.Repeated_mediapipe_NormalizedLandmarkList").create() -> <google.protobuf.Repeated_mediapipe_NormalizedLandmarkList object>
```

### google::protobuf::Repeated_mediapipe_NormalizedLandmarkList::CopyFrom

```cpp
void google::protobuf::Repeated_mediapipe_NormalizedLandmarkList::CopyFrom( const google::protobuf::Repeated_mediapipe_NormalizedLandmarkList other );
AutoIt:
    $oRepeated_mediapipe_NormalizedLandmarkList.CopyFrom( $other ) -> None
```

### google::protobuf::Repeated_mediapipe_NormalizedLandmarkList::MergeFrom

```cpp
void google::protobuf::Repeated_mediapipe_NormalizedLandmarkList::MergeFrom( const google::protobuf::Repeated_mediapipe_NormalizedLandmarkList other );
AutoIt:
    $oRepeated_mediapipe_NormalizedLandmarkList.MergeFrom( $other ) -> None
```

### google::protobuf::Repeated_mediapipe_NormalizedLandmarkList::Swap

```cpp
void google::protobuf::Repeated_mediapipe_NormalizedLandmarkList::Swap( google::protobuf::Repeated_mediapipe_NormalizedLandmarkList* other );
AutoIt:
    $oRepeated_mediapipe_NormalizedLandmarkList.Swap( $other ) -> None
```

### google::protobuf::Repeated_mediapipe_NormalizedLandmarkList::SwapElements

```cpp
void google::protobuf::Repeated_mediapipe_NormalizedLandmarkList::SwapElements( int index1,
                                                                                int index2 );
AutoIt:
    $oRepeated_mediapipe_NormalizedLandmarkList.SwapElements( $index1, $index2 ) -> None
```

### google::protobuf::Repeated_mediapipe_NormalizedLandmarkList::add

```cpp
mediapipe::NormalizedLandmarkList* google::protobuf::Repeated_mediapipe_NormalizedLandmarkList::add();
AutoIt:
    $oRepeated_mediapipe_NormalizedLandmarkList.add() -> retval
```

```cpp
mediapipe::NormalizedLandmarkList* google::protobuf::Repeated_mediapipe_NormalizedLandmarkList::add( const mediapipe::NormalizedLandmarkList* value );
AutoIt:
    $oRepeated_mediapipe_NormalizedLandmarkList.add( $value ) -> retval
```

```cpp
mediapipe::NormalizedLandmarkList* google::protobuf::Repeated_mediapipe_NormalizedLandmarkList::add( std::map<std::string, _variant_t> attrs );
AutoIt:
    $oRepeated_mediapipe_NormalizedLandmarkList.add( $attrs ) -> retval
```

### google::protobuf::Repeated_mediapipe_NormalizedLandmarkList::clear

```cpp
void google::protobuf::Repeated_mediapipe_NormalizedLandmarkList::clear();
AutoIt:
    $oRepeated_mediapipe_NormalizedLandmarkList.clear() -> None
```

### google::protobuf::Repeated_mediapipe_NormalizedLandmarkList::empty

```cpp
bool google::protobuf::Repeated_mediapipe_NormalizedLandmarkList::empty();
AutoIt:
    $oRepeated_mediapipe_NormalizedLandmarkList.empty() -> retval
```

### google::protobuf::Repeated_mediapipe_NormalizedLandmarkList::extend

```cpp
void google::protobuf::Repeated_mediapipe_NormalizedLandmarkList::extend( const google::protobuf::Repeated_mediapipe_NormalizedLandmarkList& items );
AutoIt:
    $oRepeated_mediapipe_NormalizedLandmarkList.extend( $items ) -> None
```

```cpp
void google::protobuf::Repeated_mediapipe_NormalizedLandmarkList::extend( const std::vector<std::shared_ptr<mediapipe::NormalizedLandmarkList>>& items );
AutoIt:
    $oRepeated_mediapipe_NormalizedLandmarkList.extend( $items ) -> None
```

```cpp
void google::protobuf::Repeated_mediapipe_NormalizedLandmarkList::extend( const std::vector<_variant_t>& items );
AutoIt:
    $oRepeated_mediapipe_NormalizedLandmarkList.extend( $items ) -> None
```

### google::protobuf::Repeated_mediapipe_NormalizedLandmarkList::get_Item

```cpp
mediapipe::NormalizedLandmarkList* google::protobuf::Repeated_mediapipe_NormalizedLandmarkList::get_Item( int index );
AutoIt:
    $oRepeated_mediapipe_NormalizedLandmarkList.Item( $index ) -> retval
    $oRepeated_mediapipe_NormalizedLandmarkList( $index ) -> retval
```

### google::protobuf::Repeated_mediapipe_NormalizedLandmarkList::get__NewEnum

```cpp
IUnknown* google::protobuf::Repeated_mediapipe_NormalizedLandmarkList::get__NewEnum();
AutoIt:
    $oRepeated_mediapipe_NormalizedLandmarkList._NewEnum() -> retval
```

### google::protobuf::Repeated_mediapipe_NormalizedLandmarkList::insert

```cpp
void google::protobuf::Repeated_mediapipe_NormalizedLandmarkList::insert( SSIZE_T                                   index,
                                                                          const mediapipe::NormalizedLandmarkList*& item );
AutoIt:
    $oRepeated_mediapipe_NormalizedLandmarkList.insert( $index, $item ) -> None
```

### google::protobuf::Repeated_mediapipe_NormalizedLandmarkList::pop

```cpp
std::shared_ptr<mediapipe::NormalizedLandmarkList> google::protobuf::Repeated_mediapipe_NormalizedLandmarkList::pop( SSIZE_T index = -1 );
AutoIt:
    $oRepeated_mediapipe_NormalizedLandmarkList.pop( [$index] ) -> retval
```

### google::protobuf::Repeated_mediapipe_NormalizedLandmarkList::reverse

```cpp
void google::protobuf::Repeated_mediapipe_NormalizedLandmarkList::reverse();
AutoIt:
    $oRepeated_mediapipe_NormalizedLandmarkList.reverse() -> None
```

### google::protobuf::Repeated_mediapipe_NormalizedLandmarkList::size

```cpp
int google::protobuf::Repeated_mediapipe_NormalizedLandmarkList::size();
AutoIt:
    $oRepeated_mediapipe_NormalizedLandmarkList.size() -> retval
```

### google::protobuf::Repeated_mediapipe_NormalizedLandmarkList::slice

```cpp
void google::protobuf::Repeated_mediapipe_NormalizedLandmarkList::slice( std::vector<std::shared_ptr<mediapipe::NormalizedLandmarkList>> list,
                                                                         SSIZE_T                                                         start,
                                                                         SSIZE_T                                                         count );
AutoIt:
    $oRepeated_mediapipe_NormalizedLandmarkList.slice( $start, $count[, $list] ) -> $list
```

```cpp
void google::protobuf::Repeated_mediapipe_NormalizedLandmarkList::slice( std::vector<std::shared_ptr<mediapipe::NormalizedLandmarkList>> list,
                                                                         SSIZE_T                                                         start = 0 );
AutoIt:
    $oRepeated_mediapipe_NormalizedLandmarkList.slice( [$start[, $list]] ) -> $list
```

### google::protobuf::Repeated_mediapipe_NormalizedLandmarkList::sort

```cpp
void google::protobuf::Repeated_mediapipe_NormalizedLandmarkList::sort( void*  comparator,
                                                                        size_t start = 0,
                                                                        size_t count = __self->get()->size() );
AutoIt:
    $oRepeated_mediapipe_NormalizedLandmarkList.sort( $comparator[, $start[, $count]] ) -> None
```

### google::protobuf::Repeated_mediapipe_NormalizedLandmarkList::sort_variant

```cpp
void google::protobuf::Repeated_mediapipe_NormalizedLandmarkList::sort_variant( void*  comparator,
                                                                                size_t start = 0,
                                                                                size_t count = __self->get()->size() );
AutoIt:
    $oRepeated_mediapipe_NormalizedLandmarkList.sort_variant( $comparator[, $start[, $count]] ) -> None
```

### google::protobuf::Repeated_mediapipe_NormalizedLandmarkList::splice

```cpp
void google::protobuf::Repeated_mediapipe_NormalizedLandmarkList::splice( std::vector<std::shared_ptr<mediapipe::NormalizedLandmarkList>> list,
                                                                          SSIZE_T                                                         start,
                                                                          SSIZE_T                                                         deleteCount );
AutoIt:
    $oRepeated_mediapipe_NormalizedLandmarkList.splice( $start, $deleteCount[, $list] ) -> $list
```

```cpp
void google::protobuf::Repeated_mediapipe_NormalizedLandmarkList::splice( std::vector<std::shared_ptr<mediapipe::NormalizedLandmarkList>> list,
                                                                          SSIZE_T                                                         start = 0 );
AutoIt:
    $oRepeated_mediapipe_NormalizedLandmarkList.splice( [$start[, $list]] ) -> $list
```

## mediapipe::ConstantSidePacketCalculatorOptions

### mediapipe::ConstantSidePacketCalculatorOptions::get_create

```cpp
static mediapipe::ConstantSidePacketCalculatorOptions mediapipe::ConstantSidePacketCalculatorOptions::get_create();
AutoIt:
    _Mediapipe_ObjCreate("mediapipe.ConstantSidePacketCalculatorOptions").create() -> <mediapipe.ConstantSidePacketCalculatorOptions object>
    _Mediapipe_ObjCreate("mediapipe.ConstantSidePacketCalculatorOptions")() -> <mediapipe.ConstantSidePacketCalculatorOptions object>
```

### mediapipe::ConstantSidePacketCalculatorOptions::str

```cpp
void mediapipe::ConstantSidePacketCalculatorOptions::str( std::string* output );
AutoIt:
    $oConstantSidePacketCalculatorOptions.str( [$output] ) -> $output
```

## google::protobuf::Repeated_mediapipe_ConstantSidePacketCalculatorOptions_ConstantSidePacket

### google::protobuf::Repeated_mediapipe_ConstantSidePacketCalculatorOptions_ConstantSidePacket::create

```cpp
static google::protobuf::Repeated_mediapipe_ConstantSidePacketCalculatorOptions_ConstantSidePacket google::protobuf::Repeated_mediapipe_ConstantSidePacketCalculatorOptions_ConstantSidePacket::create();
AutoIt:
    _Mediapipe_ObjCreate("google.protobuf.Repeated_mediapipe_ConstantSidePacketCalculatorOptions_ConstantSidePacket").create() -> <google.protobuf.Repeated_mediapipe_ConstantSidePacketCalculatorOptions_ConstantSidePacket object>
```

### google::protobuf::Repeated_mediapipe_ConstantSidePacketCalculatorOptions_ConstantSidePacket::CopyFrom

```cpp
void google::protobuf::Repeated_mediapipe_ConstantSidePacketCalculatorOptions_ConstantSidePacket::CopyFrom( const google::protobuf::Repeated_mediapipe_ConstantSidePacketCalculatorOptions_ConstantSidePacket other );
AutoIt:
    $oRepeated_mediapipe_ConstantSidePacketCalculatorOptions_ConstantSidePacket.CopyFrom( $other ) -> None
```

### google::protobuf::Repeated_mediapipe_ConstantSidePacketCalculatorOptions_ConstantSidePacket::MergeFrom

```cpp
void google::protobuf::Repeated_mediapipe_ConstantSidePacketCalculatorOptions_ConstantSidePacket::MergeFrom( const google::protobuf::Repeated_mediapipe_ConstantSidePacketCalculatorOptions_ConstantSidePacket other );
AutoIt:
    $oRepeated_mediapipe_ConstantSidePacketCalculatorOptions_ConstantSidePacket.MergeFrom( $other ) -> None
```

### google::protobuf::Repeated_mediapipe_ConstantSidePacketCalculatorOptions_ConstantSidePacket::Swap

```cpp
void google::protobuf::Repeated_mediapipe_ConstantSidePacketCalculatorOptions_ConstantSidePacket::Swap( google::protobuf::Repeated_mediapipe_ConstantSidePacketCalculatorOptions_ConstantSidePacket* other );
AutoIt:
    $oRepeated_mediapipe_ConstantSidePacketCalculatorOptions_ConstantSidePacket.Swap( $other ) -> None
```

### google::protobuf::Repeated_mediapipe_ConstantSidePacketCalculatorOptions_ConstantSidePacket::SwapElements

```cpp
void google::protobuf::Repeated_mediapipe_ConstantSidePacketCalculatorOptions_ConstantSidePacket::SwapElements( int index1,
                                                                                                                int index2 );
AutoIt:
    $oRepeated_mediapipe_ConstantSidePacketCalculatorOptions_ConstantSidePacket.SwapElements( $index1, $index2 ) -> None
```

### google::protobuf::Repeated_mediapipe_ConstantSidePacketCalculatorOptions_ConstantSidePacket::add

```cpp
mediapipe::ConstantSidePacketCalculatorOptions::ConstantSidePacket* google::protobuf::Repeated_mediapipe_ConstantSidePacketCalculatorOptions_ConstantSidePacket::add();
AutoIt:
    $oRepeated_mediapipe_ConstantSidePacketCalculatorOptions_ConstantSidePacket.add() -> retval
```

```cpp
mediapipe::ConstantSidePacketCalculatorOptions::ConstantSidePacket* google::protobuf::Repeated_mediapipe_ConstantSidePacketCalculatorOptions_ConstantSidePacket::add( const mediapipe::ConstantSidePacketCalculatorOptions::ConstantSidePacket* value );
AutoIt:
    $oRepeated_mediapipe_ConstantSidePacketCalculatorOptions_ConstantSidePacket.add( $value ) -> retval
```

```cpp
mediapipe::ConstantSidePacketCalculatorOptions::ConstantSidePacket* google::protobuf::Repeated_mediapipe_ConstantSidePacketCalculatorOptions_ConstantSidePacket::add( std::map<std::string, _variant_t> attrs );
AutoIt:
    $oRepeated_mediapipe_ConstantSidePacketCalculatorOptions_ConstantSidePacket.add( $attrs ) -> retval
```

### google::protobuf::Repeated_mediapipe_ConstantSidePacketCalculatorOptions_ConstantSidePacket::clear

```cpp
void google::protobuf::Repeated_mediapipe_ConstantSidePacketCalculatorOptions_ConstantSidePacket::clear();
AutoIt:
    $oRepeated_mediapipe_ConstantSidePacketCalculatorOptions_ConstantSidePacket.clear() -> None
```

### google::protobuf::Repeated_mediapipe_ConstantSidePacketCalculatorOptions_ConstantSidePacket::empty

```cpp
bool google::protobuf::Repeated_mediapipe_ConstantSidePacketCalculatorOptions_ConstantSidePacket::empty();
AutoIt:
    $oRepeated_mediapipe_ConstantSidePacketCalculatorOptions_ConstantSidePacket.empty() -> retval
```

### google::protobuf::Repeated_mediapipe_ConstantSidePacketCalculatorOptions_ConstantSidePacket::extend

```cpp
void google::protobuf::Repeated_mediapipe_ConstantSidePacketCalculatorOptions_ConstantSidePacket::extend( const google::protobuf::Repeated_mediapipe_ConstantSidePacketCalculatorOptions_ConstantSidePacket& items );
AutoIt:
    $oRepeated_mediapipe_ConstantSidePacketCalculatorOptions_ConstantSidePacket.extend( $items ) -> None
```

```cpp
void google::protobuf::Repeated_mediapipe_ConstantSidePacketCalculatorOptions_ConstantSidePacket::extend( const std::vector<std::shared_ptr<mediapipe::ConstantSidePacketCalculatorOptions::ConstantSidePacket>>& items );
AutoIt:
    $oRepeated_mediapipe_ConstantSidePacketCalculatorOptions_ConstantSidePacket.extend( $items ) -> None
```

```cpp
void google::protobuf::Repeated_mediapipe_ConstantSidePacketCalculatorOptions_ConstantSidePacket::extend( const std::vector<_variant_t>& items );
AutoIt:
    $oRepeated_mediapipe_ConstantSidePacketCalculatorOptions_ConstantSidePacket.extend( $items ) -> None
```

### google::protobuf::Repeated_mediapipe_ConstantSidePacketCalculatorOptions_ConstantSidePacket::get_Item

```cpp
mediapipe::ConstantSidePacketCalculatorOptions::ConstantSidePacket* google::protobuf::Repeated_mediapipe_ConstantSidePacketCalculatorOptions_ConstantSidePacket::get_Item( int index );
AutoIt:
    $oRepeated_mediapipe_ConstantSidePacketCalculatorOptions_ConstantSidePacket.Item( $index ) -> retval
    $oRepeated_mediapipe_ConstantSidePacketCalculatorOptions_ConstantSidePacket( $index ) -> retval
```

### google::protobuf::Repeated_mediapipe_ConstantSidePacketCalculatorOptions_ConstantSidePacket::get__NewEnum

```cpp
IUnknown* google::protobuf::Repeated_mediapipe_ConstantSidePacketCalculatorOptions_ConstantSidePacket::get__NewEnum();
AutoIt:
    $oRepeated_mediapipe_ConstantSidePacketCalculatorOptions_ConstantSidePacket._NewEnum() -> retval
```

### google::protobuf::Repeated_mediapipe_ConstantSidePacketCalculatorOptions_ConstantSidePacket::insert

```cpp
void google::protobuf::Repeated_mediapipe_ConstantSidePacketCalculatorOptions_ConstantSidePacket::insert( SSIZE_T                                                                    index,
                                                                                                          const mediapipe::ConstantSidePacketCalculatorOptions::ConstantSidePacket*& item );
AutoIt:
    $oRepeated_mediapipe_ConstantSidePacketCalculatorOptions_ConstantSidePacket.insert( $index, $item ) -> None
```

### google::protobuf::Repeated_mediapipe_ConstantSidePacketCalculatorOptions_ConstantSidePacket::pop

```cpp
std::shared_ptr<mediapipe::ConstantSidePacketCalculatorOptions::ConstantSidePacket> google::protobuf::Repeated_mediapipe_ConstantSidePacketCalculatorOptions_ConstantSidePacket::pop( SSIZE_T index = -1 );
AutoIt:
    $oRepeated_mediapipe_ConstantSidePacketCalculatorOptions_ConstantSidePacket.pop( [$index] ) -> retval
```

### google::protobuf::Repeated_mediapipe_ConstantSidePacketCalculatorOptions_ConstantSidePacket::reverse

```cpp
void google::protobuf::Repeated_mediapipe_ConstantSidePacketCalculatorOptions_ConstantSidePacket::reverse();
AutoIt:
    $oRepeated_mediapipe_ConstantSidePacketCalculatorOptions_ConstantSidePacket.reverse() -> None
```

### google::protobuf::Repeated_mediapipe_ConstantSidePacketCalculatorOptions_ConstantSidePacket::size

```cpp
int google::protobuf::Repeated_mediapipe_ConstantSidePacketCalculatorOptions_ConstantSidePacket::size();
AutoIt:
    $oRepeated_mediapipe_ConstantSidePacketCalculatorOptions_ConstantSidePacket.size() -> retval
```

### google::protobuf::Repeated_mediapipe_ConstantSidePacketCalculatorOptions_ConstantSidePacket::slice

```cpp
void google::protobuf::Repeated_mediapipe_ConstantSidePacketCalculatorOptions_ConstantSidePacket::slice( std::vector<std::shared_ptr<mediapipe::ConstantSidePacketCalculatorOptions::ConstantSidePacket>> list,
                                                                                                         SSIZE_T                                                                                          start,
                                                                                                         SSIZE_T                                                                                          count );
AutoIt:
    $oRepeated_mediapipe_ConstantSidePacketCalculatorOptions_ConstantSidePacket.slice( $start, $count[, $list] ) -> $list
```

```cpp
void google::protobuf::Repeated_mediapipe_ConstantSidePacketCalculatorOptions_ConstantSidePacket::slice( std::vector<std::shared_ptr<mediapipe::ConstantSidePacketCalculatorOptions::ConstantSidePacket>> list,
                                                                                                         SSIZE_T                                                                                          start = 0 );
AutoIt:
    $oRepeated_mediapipe_ConstantSidePacketCalculatorOptions_ConstantSidePacket.slice( [$start[, $list]] ) -> $list
```

### google::protobuf::Repeated_mediapipe_ConstantSidePacketCalculatorOptions_ConstantSidePacket::sort

```cpp
void google::protobuf::Repeated_mediapipe_ConstantSidePacketCalculatorOptions_ConstantSidePacket::sort( void*  comparator,
                                                                                                        size_t start = 0,
                                                                                                        size_t count = __self->get()->size() );
AutoIt:
    $oRepeated_mediapipe_ConstantSidePacketCalculatorOptions_ConstantSidePacket.sort( $comparator[, $start[, $count]] ) -> None
```

### google::protobuf::Repeated_mediapipe_ConstantSidePacketCalculatorOptions_ConstantSidePacket::sort_variant

```cpp
void google::protobuf::Repeated_mediapipe_ConstantSidePacketCalculatorOptions_ConstantSidePacket::sort_variant( void*  comparator,
                                                                                                                size_t start = 0,
                                                                                                                size_t count = __self->get()->size() );
AutoIt:
    $oRepeated_mediapipe_ConstantSidePacketCalculatorOptions_ConstantSidePacket.sort_variant( $comparator[, $start[, $count]] ) -> None
```

### google::protobuf::Repeated_mediapipe_ConstantSidePacketCalculatorOptions_ConstantSidePacket::splice

```cpp
void google::protobuf::Repeated_mediapipe_ConstantSidePacketCalculatorOptions_ConstantSidePacket::splice( std::vector<std::shared_ptr<mediapipe::ConstantSidePacketCalculatorOptions::ConstantSidePacket>> list,
                                                                                                          SSIZE_T                                                                                          start,
                                                                                                          SSIZE_T                                                                                          deleteCount );
AutoIt:
    $oRepeated_mediapipe_ConstantSidePacketCalculatorOptions_ConstantSidePacket.splice( $start, $deleteCount[, $list] ) -> $list
```

```cpp
void google::protobuf::Repeated_mediapipe_ConstantSidePacketCalculatorOptions_ConstantSidePacket::splice( std::vector<std::shared_ptr<mediapipe::ConstantSidePacketCalculatorOptions::ConstantSidePacket>> list,
                                                                                                          SSIZE_T                                                                                          start = 0 );
AutoIt:
    $oRepeated_mediapipe_ConstantSidePacketCalculatorOptions_ConstantSidePacket.splice( [$start[, $list]] ) -> $list
```

## mediapipe::ConstantSidePacketCalculatorOptions::ConstantSidePacket

### mediapipe::ConstantSidePacketCalculatorOptions::ConstantSidePacket::get_create

```cpp
static mediapipe::ConstantSidePacketCalculatorOptions::ConstantSidePacket mediapipe::ConstantSidePacketCalculatorOptions::ConstantSidePacket::get_create();
AutoIt:
    _Mediapipe_ObjCreate("mediapipe.ConstantSidePacketCalculatorOptions.ConstantSidePacket").create() -> <mediapipe.ConstantSidePacketCalculatorOptions.ConstantSidePacket object>
    _Mediapipe_ObjCreate("mediapipe.ConstantSidePacketCalculatorOptions.ConstantSidePacket")() -> <mediapipe.ConstantSidePacketCalculatorOptions.ConstantSidePacket object>
```

### mediapipe::ConstantSidePacketCalculatorOptions::ConstantSidePacket::str

```cpp
void mediapipe::ConstantSidePacketCalculatorOptions::ConstantSidePacket::str( std::string* output );
AutoIt:
    $oConstantSidePacket.str( [$output] ) -> $output
```

## mediapipe::ScaleMode

### mediapipe::ScaleMode::get_create

```cpp
static mediapipe::ScaleMode mediapipe::ScaleMode::get_create();
AutoIt:
    _Mediapipe_ObjCreate("mediapipe.ScaleMode").create() -> <mediapipe.ScaleMode object>
    _Mediapipe_ObjCreate("mediapipe.ScaleMode")() -> <mediapipe.ScaleMode object>
```

### mediapipe::ScaleMode::str

```cpp
void mediapipe::ScaleMode::str( std::string* output );
AutoIt:
    $oScaleMode.str( [$output] ) -> $output
```

## mediapipe::RotationMode

### mediapipe::RotationMode::get_create

```cpp
static mediapipe::RotationMode mediapipe::RotationMode::get_create();
AutoIt:
    _Mediapipe_ObjCreate("mediapipe.RotationMode").create() -> <mediapipe.RotationMode object>
    _Mediapipe_ObjCreate("mediapipe.RotationMode")() -> <mediapipe.RotationMode object>
```

### mediapipe::RotationMode::str

```cpp
void mediapipe::RotationMode::str( std::string* output );
AutoIt:
    $oRotationMode.str( [$output] ) -> $output
```

## mediapipe::ImageTransformationCalculatorOptions

### mediapipe::ImageTransformationCalculatorOptions::get_create

```cpp
static mediapipe::ImageTransformationCalculatorOptions mediapipe::ImageTransformationCalculatorOptions::get_create();
AutoIt:
    _Mediapipe_ObjCreate("mediapipe.ImageTransformationCalculatorOptions").create() -> <mediapipe.ImageTransformationCalculatorOptions object>
    _Mediapipe_ObjCreate("mediapipe.ImageTransformationCalculatorOptions")() -> <mediapipe.ImageTransformationCalculatorOptions object>
```

### mediapipe::ImageTransformationCalculatorOptions::str

```cpp
void mediapipe::ImageTransformationCalculatorOptions::str( std::string* output );
AutoIt:
    $oImageTransformationCalculatorOptions.str( [$output] ) -> $output
```

## mediapipe::TensorsToDetectionsCalculatorOptions

### mediapipe::TensorsToDetectionsCalculatorOptions::get_create

```cpp
static mediapipe::TensorsToDetectionsCalculatorOptions mediapipe::TensorsToDetectionsCalculatorOptions::get_create();
AutoIt:
    _Mediapipe_ObjCreate("mediapipe.TensorsToDetectionsCalculatorOptions").create() -> <mediapipe.TensorsToDetectionsCalculatorOptions object>
    _Mediapipe_ObjCreate("mediapipe.TensorsToDetectionsCalculatorOptions")() -> <mediapipe.TensorsToDetectionsCalculatorOptions object>
```

### mediapipe::TensorsToDetectionsCalculatorOptions::str

```cpp
void mediapipe::TensorsToDetectionsCalculatorOptions::str( std::string* output );
AutoIt:
    $oTensorsToDetectionsCalculatorOptions.str( [$output] ) -> $output
```

## mediapipe::TensorsToDetectionsCalculatorOptions::TensorMapping

### mediapipe::TensorsToDetectionsCalculatorOptions::TensorMapping::get_create

```cpp
static mediapipe::TensorsToDetectionsCalculatorOptions::TensorMapping mediapipe::TensorsToDetectionsCalculatorOptions::TensorMapping::get_create();
AutoIt:
    _Mediapipe_ObjCreate("mediapipe.TensorsToDetectionsCalculatorOptions.TensorMapping").create() -> <mediapipe.TensorsToDetectionsCalculatorOptions.TensorMapping object>
    _Mediapipe_ObjCreate("mediapipe.TensorsToDetectionsCalculatorOptions.TensorMapping")() -> <mediapipe.TensorsToDetectionsCalculatorOptions.TensorMapping object>
```

### mediapipe::TensorsToDetectionsCalculatorOptions::TensorMapping::str

```cpp
void mediapipe::TensorsToDetectionsCalculatorOptions::TensorMapping::str( std::string* output );
AutoIt:
    $oTensorMapping.str( [$output] ) -> $output
```

## mediapipe::TensorsToDetectionsCalculatorOptions::BoxBoundariesIndices

### mediapipe::TensorsToDetectionsCalculatorOptions::BoxBoundariesIndices::get_create

```cpp
static mediapipe::TensorsToDetectionsCalculatorOptions::BoxBoundariesIndices mediapipe::TensorsToDetectionsCalculatorOptions::BoxBoundariesIndices::get_create();
AutoIt:
    _Mediapipe_ObjCreate("mediapipe.TensorsToDetectionsCalculatorOptions.BoxBoundariesIndices").create() -> <mediapipe.TensorsToDetectionsCalculatorOptions.BoxBoundariesIndices object>
    _Mediapipe_ObjCreate("mediapipe.TensorsToDetectionsCalculatorOptions.BoxBoundariesIndices")() -> <mediapipe.TensorsToDetectionsCalculatorOptions.BoxBoundariesIndices object>
```

### mediapipe::TensorsToDetectionsCalculatorOptions::BoxBoundariesIndices::str

```cpp
void mediapipe::TensorsToDetectionsCalculatorOptions::BoxBoundariesIndices::str( std::string* output );
AutoIt:
    $oBoxBoundariesIndices.str( [$output] ) -> $output
```

## mediapipe::LandmarksSmoothingCalculatorOptions

### mediapipe::LandmarksSmoothingCalculatorOptions::get_create

```cpp
static mediapipe::LandmarksSmoothingCalculatorOptions mediapipe::LandmarksSmoothingCalculatorOptions::get_create();
AutoIt:
    _Mediapipe_ObjCreate("mediapipe.LandmarksSmoothingCalculatorOptions").create() -> <mediapipe.LandmarksSmoothingCalculatorOptions object>
    _Mediapipe_ObjCreate("mediapipe.LandmarksSmoothingCalculatorOptions")() -> <mediapipe.LandmarksSmoothingCalculatorOptions object>
```

### mediapipe::LandmarksSmoothingCalculatorOptions::str

```cpp
void mediapipe::LandmarksSmoothingCalculatorOptions::str( std::string* output );
AutoIt:
    $oLandmarksSmoothingCalculatorOptions.str( [$output] ) -> $output
```

## mediapipe::LandmarksSmoothingCalculatorOptions::NoFilter

### mediapipe::LandmarksSmoothingCalculatorOptions::NoFilter::get_create

```cpp
static mediapipe::LandmarksSmoothingCalculatorOptions::NoFilter mediapipe::LandmarksSmoothingCalculatorOptions::NoFilter::get_create();
AutoIt:
    _Mediapipe_ObjCreate("mediapipe.LandmarksSmoothingCalculatorOptions.NoFilter").create() -> <mediapipe.LandmarksSmoothingCalculatorOptions.NoFilter object>
    _Mediapipe_ObjCreate("mediapipe.LandmarksSmoothingCalculatorOptions.NoFilter")() -> <mediapipe.LandmarksSmoothingCalculatorOptions.NoFilter object>
```

### mediapipe::LandmarksSmoothingCalculatorOptions::NoFilter::str

```cpp
void mediapipe::LandmarksSmoothingCalculatorOptions::NoFilter::str( std::string* output );
AutoIt:
    $oNoFilter.str( [$output] ) -> $output
```

## mediapipe::LandmarksSmoothingCalculatorOptions::VelocityFilter

### mediapipe::LandmarksSmoothingCalculatorOptions::VelocityFilter::get_create

```cpp
static mediapipe::LandmarksSmoothingCalculatorOptions::VelocityFilter mediapipe::LandmarksSmoothingCalculatorOptions::VelocityFilter::get_create();
AutoIt:
    _Mediapipe_ObjCreate("mediapipe.LandmarksSmoothingCalculatorOptions.VelocityFilter").create() -> <mediapipe.LandmarksSmoothingCalculatorOptions.VelocityFilter object>
    _Mediapipe_ObjCreate("mediapipe.LandmarksSmoothingCalculatorOptions.VelocityFilter")() -> <mediapipe.LandmarksSmoothingCalculatorOptions.VelocityFilter object>
```

### mediapipe::LandmarksSmoothingCalculatorOptions::VelocityFilter::str

```cpp
void mediapipe::LandmarksSmoothingCalculatorOptions::VelocityFilter::str( std::string* output );
AutoIt:
    $oVelocityFilter.str( [$output] ) -> $output
```

## mediapipe::LandmarksSmoothingCalculatorOptions::OneEuroFilter

### mediapipe::LandmarksSmoothingCalculatorOptions::OneEuroFilter::get_create

```cpp
static mediapipe::LandmarksSmoothingCalculatorOptions::OneEuroFilter mediapipe::LandmarksSmoothingCalculatorOptions::OneEuroFilter::get_create();
AutoIt:
    _Mediapipe_ObjCreate("mediapipe.LandmarksSmoothingCalculatorOptions.OneEuroFilter").create() -> <mediapipe.LandmarksSmoothingCalculatorOptions.OneEuroFilter object>
    _Mediapipe_ObjCreate("mediapipe.LandmarksSmoothingCalculatorOptions.OneEuroFilter")() -> <mediapipe.LandmarksSmoothingCalculatorOptions.OneEuroFilter object>
```

### mediapipe::LandmarksSmoothingCalculatorOptions::OneEuroFilter::str

```cpp
void mediapipe::LandmarksSmoothingCalculatorOptions::OneEuroFilter::str( std::string* output );
AutoIt:
    $oOneEuroFilter.str( [$output] ) -> $output
```

## mediapipe::LogicCalculatorOptions

### mediapipe::LogicCalculatorOptions::get_create

```cpp
static mediapipe::LogicCalculatorOptions mediapipe::LogicCalculatorOptions::get_create();
AutoIt:
    _Mediapipe_ObjCreate("mediapipe.LogicCalculatorOptions").create() -> <mediapipe.LogicCalculatorOptions object>
    _Mediapipe_ObjCreate("mediapipe.LogicCalculatorOptions")() -> <mediapipe.LogicCalculatorOptions object>
```

### mediapipe::LogicCalculatorOptions::str

```cpp
void mediapipe::LogicCalculatorOptions::str( std::string* output );
AutoIt:
    $oLogicCalculatorOptions.str( [$output] ) -> $output
```

## google::protobuf::Repeated_bool

### google::protobuf::Repeated_bool::create

```cpp
static google::protobuf::Repeated_bool google::protobuf::Repeated_bool::create();
AutoIt:
    _Mediapipe_ObjCreate("google.protobuf.Repeated_bool").create() -> <google.protobuf.Repeated_bool object>
```

### google::protobuf::Repeated_bool::CopyFrom

```cpp
void google::protobuf::Repeated_bool::CopyFrom( const google::protobuf::Repeated_bool other );
AutoIt:
    $oRepeated_bool.CopyFrom( $other ) -> None
```

### google::protobuf::Repeated_bool::MergeFrom

```cpp
void google::protobuf::Repeated_bool::MergeFrom( const google::protobuf::Repeated_bool other );
AutoIt:
    $oRepeated_bool.MergeFrom( $other ) -> None
```

### google::protobuf::Repeated_bool::Swap

```cpp
void google::protobuf::Repeated_bool::Swap( google::protobuf::Repeated_bool* other );
AutoIt:
    $oRepeated_bool.Swap( $other ) -> None
```

### google::protobuf::Repeated_bool::SwapElements

```cpp
void google::protobuf::Repeated_bool::SwapElements( int index1,
                                                    int index2 );
AutoIt:
    $oRepeated_bool.SwapElements( $index1, $index2 ) -> None
```

### google::protobuf::Repeated_bool::append

```cpp
void google::protobuf::Repeated_bool::append( const bool value );
AutoIt:
    $oRepeated_bool.append( $value ) -> None
```

### google::protobuf::Repeated_bool::clear

```cpp
void google::protobuf::Repeated_bool::clear();
AutoIt:
    $oRepeated_bool.clear() -> None
```

### google::protobuf::Repeated_bool::empty

```cpp
bool google::protobuf::Repeated_bool::empty();
AutoIt:
    $oRepeated_bool.empty() -> retval
```

### google::protobuf::Repeated_bool::extend

```cpp
void google::protobuf::Repeated_bool::extend( const google::protobuf::Repeated_bool& items );
AutoIt:
    $oRepeated_bool.extend( $items ) -> None
```

```cpp
void google::protobuf::Repeated_bool::extend( const std::vector<bool>& items );
AutoIt:
    $oRepeated_bool.extend( $items ) -> None
```

### google::protobuf::Repeated_bool::get_Item

```cpp
bool google::protobuf::Repeated_bool::get_Item( int index );
AutoIt:
    $oRepeated_bool.Item( $index ) -> retval
    $oRepeated_bool( $index ) -> retval
```

### google::protobuf::Repeated_bool::get__NewEnum

```cpp
IUnknown* google::protobuf::Repeated_bool::get__NewEnum();
AutoIt:
    $oRepeated_bool._NewEnum() -> retval
```

### google::protobuf::Repeated_bool::insert

```cpp
void google::protobuf::Repeated_bool::insert( SSIZE_T     index,
                                              const bool& item );
AutoIt:
    $oRepeated_bool.insert( $index, $item ) -> None
```

### google::protobuf::Repeated_bool::pop

```cpp
bool google::protobuf::Repeated_bool::pop( SSIZE_T index = -1 );
AutoIt:
    $oRepeated_bool.pop( [$index] ) -> retval
```

### google::protobuf::Repeated_bool::reverse

```cpp
void google::protobuf::Repeated_bool::reverse();
AutoIt:
    $oRepeated_bool.reverse() -> None
```

### google::protobuf::Repeated_bool::set

```cpp
void google::protobuf::Repeated_bool::set( int         index,
                                           const bool& value );
AutoIt:
    $oRepeated_bool.set( $index, $value ) -> None
```

### google::protobuf::Repeated_bool::size

```cpp
int google::protobuf::Repeated_bool::size();
AutoIt:
    $oRepeated_bool.size() -> retval
```

### google::protobuf::Repeated_bool::slice

```cpp
void google::protobuf::Repeated_bool::slice( std::vector<bool> list,
                                             SSIZE_T           start,
                                             SSIZE_T           deleteCount );
AutoIt:
    $oRepeated_bool.slice( $start, $deleteCount[, $list] ) -> $list
```

```cpp
void google::protobuf::Repeated_bool::slice( std::vector<bool> list,
                                             SSIZE_T           start = 0 );
AutoIt:
    $oRepeated_bool.slice( [$start[, $list]] ) -> $list
```

### google::protobuf::Repeated_bool::sort

```cpp
void google::protobuf::Repeated_bool::sort( void*  comparator,
                                            size_t start = 0,
                                            size_t count = __self->get()->size() );
AutoIt:
    $oRepeated_bool.sort( $comparator[, $start[, $count]] ) -> None
```

### google::protobuf::Repeated_bool::sort_variant

```cpp
void google::protobuf::Repeated_bool::sort_variant( void*  comparator,
                                                    size_t start = 0,
                                                    size_t count = __self->get()->size() );
AutoIt:
    $oRepeated_bool.sort_variant( $comparator[, $start[, $count]] ) -> None
```

### google::protobuf::Repeated_bool::splice

```cpp
void google::protobuf::Repeated_bool::splice( std::vector<bool> list,
                                              SSIZE_T           start,
                                              SSIZE_T           deleteCount );
AutoIt:
    $oRepeated_bool.splice( $start, $deleteCount[, $list] ) -> $list
```

```cpp
void google::protobuf::Repeated_bool::splice( std::vector<bool> list,
                                              SSIZE_T           start = 0 );
AutoIt:
    $oRepeated_bool.splice( [$start[, $list]] ) -> $list
```

## mediapipe::ThresholdingCalculatorOptions

### mediapipe::ThresholdingCalculatorOptions::get_create

```cpp
static mediapipe::ThresholdingCalculatorOptions mediapipe::ThresholdingCalculatorOptions::get_create();
AutoIt:
    _Mediapipe_ObjCreate("mediapipe.ThresholdingCalculatorOptions").create() -> <mediapipe.ThresholdingCalculatorOptions object>
    _Mediapipe_ObjCreate("mediapipe.ThresholdingCalculatorOptions")() -> <mediapipe.ThresholdingCalculatorOptions object>
```

### mediapipe::ThresholdingCalculatorOptions::str

```cpp
void mediapipe::ThresholdingCalculatorOptions::str( std::string* output );
AutoIt:
    $oThresholdingCalculatorOptions.str( [$output] ) -> $output
```

## mediapipe::BeliefDecoderConfig

### mediapipe::BeliefDecoderConfig::get_create

```cpp
static mediapipe::BeliefDecoderConfig mediapipe::BeliefDecoderConfig::get_create();
AutoIt:
    _Mediapipe_ObjCreate("mediapipe.BeliefDecoderConfig").create() -> <mediapipe.BeliefDecoderConfig object>
    _Mediapipe_ObjCreate("mediapipe.BeliefDecoderConfig")() -> <mediapipe.BeliefDecoderConfig object>
```

### mediapipe::BeliefDecoderConfig::str

```cpp
void mediapipe::BeliefDecoderConfig::str( std::string* output );
AutoIt:
    $oBeliefDecoderConfig.str( [$output] ) -> $output
```

## mediapipe::Lift2DFrameAnnotationTo3DCalculatorOptions

### mediapipe::Lift2DFrameAnnotationTo3DCalculatorOptions::get_create

```cpp
static mediapipe::Lift2DFrameAnnotationTo3DCalculatorOptions mediapipe::Lift2DFrameAnnotationTo3DCalculatorOptions::get_create();
AutoIt:
    _Mediapipe_ObjCreate("mediapipe.Lift2DFrameAnnotationTo3DCalculatorOptions").create() -> <mediapipe.Lift2DFrameAnnotationTo3DCalculatorOptions object>
    _Mediapipe_ObjCreate("mediapipe.Lift2DFrameAnnotationTo3DCalculatorOptions")() -> <mediapipe.Lift2DFrameAnnotationTo3DCalculatorOptions object>
```

### mediapipe::Lift2DFrameAnnotationTo3DCalculatorOptions::str

```cpp
void mediapipe::Lift2DFrameAnnotationTo3DCalculatorOptions::str( std::string* output );
AutoIt:
    $oLift2DFrameAnnotationTo3DCalculatorOptions.str( [$output] ) -> $output
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

### VectorOfVariant::get__NewEnum

```cpp
IUnknown* VectorOfVariant::get__NewEnum();
AutoIt:
    $oVectorOfVariant._NewEnum() -> retval
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
                                        size_t count = __self->get()->size() );
AutoIt:
    $oVectorOfVariant.slice( [$start[, $count]] ) -> retval
```

### VectorOfVariant::sort

```cpp
void VectorOfVariant::sort( void*  comparator,
                            size_t start = 0,
                            size_t count = __self->get()->size() );
AutoIt:
    $oVectorOfVariant.sort( $comparator[, $start[, $count]] ) -> None
```

### VectorOfVariant::sort_variant

```cpp
void VectorOfVariant::sort_variant( void*  comparator,
                                    size_t start = 0,
                                    size_t count = __self->get()->size() );
AutoIt:
    $oVectorOfVariant.sort_variant( $comparator[, $start[, $count]] ) -> None
```

### VectorOfVariant::start

```cpp
void* VectorOfVariant::start();
AutoIt:
    $oVectorOfVariant.start() -> retval
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

### VectorOfBool::get__NewEnum

```cpp
IUnknown* VectorOfBool::get__NewEnum();
AutoIt:
    $oVectorOfBool._NewEnum() -> retval
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
                                  size_t count = __self->get()->size() );
AutoIt:
    $oVectorOfBool.slice( [$start[, $count]] ) -> retval
```

### VectorOfBool::sort

```cpp
void VectorOfBool::sort( void*  comparator,
                         size_t start = 0,
                         size_t count = __self->get()->size() );
AutoIt:
    $oVectorOfBool.sort( $comparator[, $start[, $count]] ) -> None
```

### VectorOfBool::sort_variant

```cpp
void VectorOfBool::sort_variant( void*  comparator,
                                 size_t start = 0,
                                 size_t count = __self->get()->size() );
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

### VectorOfFloat::get__NewEnum

```cpp
IUnknown* VectorOfFloat::get__NewEnum();
AutoIt:
    $oVectorOfFloat._NewEnum() -> retval
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
                                    size_t count = __self->get()->size() );
AutoIt:
    $oVectorOfFloat.slice( [$start[, $count]] ) -> retval
```

### VectorOfFloat::sort

```cpp
void VectorOfFloat::sort( void*  comparator,
                          size_t start = 0,
                          size_t count = __self->get()->size() );
AutoIt:
    $oVectorOfFloat.sort( $comparator[, $start[, $count]] ) -> None
```

### VectorOfFloat::sort_variant

```cpp
void VectorOfFloat::sort_variant( void*  comparator,
                                  size_t start = 0,
                                  size_t count = __self->get()->size() );
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

### VectorOfImage::get__NewEnum

```cpp
IUnknown* VectorOfImage::get__NewEnum();
AutoIt:
    $oVectorOfImage._NewEnum() -> retval
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
                                    size_t count = __self->get()->size() );
AutoIt:
    $oVectorOfImage.slice( [$start[, $count]] ) -> retval
```

### VectorOfImage::sort

```cpp
void VectorOfImage::sort( void*  comparator,
                          size_t start = 0,
                          size_t count = __self->get()->size() );
AutoIt:
    $oVectorOfImage.sort( $comparator[, $start[, $count]] ) -> None
```

### VectorOfImage::sort_variant

```cpp
void VectorOfImage::sort_variant( void*  comparator,
                                  size_t start = 0,
                                  size_t count = __self->get()->size() );
AutoIt:
    $oVectorOfImage.sort_variant( $comparator[, $start[, $count]] ) -> None
```

### VectorOfImage::start

```cpp
void* VectorOfImage::start();
AutoIt:
    $oVectorOfImage.start() -> retval
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

### VectorOfInt::get__NewEnum

```cpp
IUnknown* VectorOfInt::get__NewEnum();
AutoIt:
    $oVectorOfInt._NewEnum() -> retval
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
                                size_t count = __self->get()->size() );
AutoIt:
    $oVectorOfInt.slice( [$start[, $count]] ) -> retval
```

### VectorOfInt::sort

```cpp
void VectorOfInt::sort( void*  comparator,
                        size_t start = 0,
                        size_t count = __self->get()->size() );
AutoIt:
    $oVectorOfInt.sort( $comparator[, $start[, $count]] ) -> None
```

### VectorOfInt::sort_variant

```cpp
void VectorOfInt::sort_variant( void*  comparator,
                                size_t start = 0,
                                size_t count = __self->get()->size() );
AutoIt:
    $oVectorOfInt.sort_variant( $comparator[, $start[, $count]] ) -> None
```

### VectorOfInt::start

```cpp
void* VectorOfInt::start();
AutoIt:
    $oVectorOfInt.start() -> retval
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

### VectorOfPacket::get__NewEnum

```cpp
IUnknown* VectorOfPacket::get__NewEnum();
AutoIt:
    $oVectorOfPacket._NewEnum() -> retval
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
                                      size_t count = __self->get()->size() );
AutoIt:
    $oVectorOfPacket.slice( [$start[, $count]] ) -> retval
```

### VectorOfPacket::sort

```cpp
void VectorOfPacket::sort( void*  comparator,
                           size_t start = 0,
                           size_t count = __self->get()->size() );
AutoIt:
    $oVectorOfPacket.sort( $comparator[, $start[, $count]] ) -> None
```

### VectorOfPacket::sort_variant

```cpp
void VectorOfPacket::sort_variant( void*  comparator,
                                   size_t start = 0,
                                   size_t count = __self->get()->size() );
AutoIt:
    $oVectorOfPacket.sort_variant( $comparator[, $start[, $count]] ) -> None
```

### VectorOfPacket::start

```cpp
void* VectorOfPacket::start();
AutoIt:
    $oVectorOfPacket.start() -> retval
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

### MapOfStringAndPacket::get__NewEnum

```cpp
IUnknown* MapOfStringAndPacket::get__NewEnum();
AutoIt:
    $oMapOfStringAndPacket._NewEnum() -> retval
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

### VectorOfString::get__NewEnum

```cpp
IUnknown* VectorOfString::get__NewEnum();
AutoIt:
    $oVectorOfString._NewEnum() -> retval
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
                                      size_t count = __self->get()->size() );
AutoIt:
    $oVectorOfString.slice( [$start[, $count]] ) -> retval
```

### VectorOfString::sort

```cpp
void VectorOfString::sort( void*  comparator,
                           size_t start = 0,
                           size_t count = __self->get()->size() );
AutoIt:
    $oVectorOfString.sort( $comparator[, $start[, $count]] ) -> None
```

### VectorOfString::sort_variant

```cpp
void VectorOfString::sort_variant( void*  comparator,
                                   size_t start = 0,
                                   size_t count = __self->get()->size() );
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

### VectorOfInt64::get__NewEnum

```cpp
IUnknown* VectorOfInt64::get__NewEnum();
AutoIt:
    $oVectorOfInt64._NewEnum() -> retval
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
                                    size_t count = __self->get()->size() );
AutoIt:
    $oVectorOfInt64.slice( [$start[, $count]] ) -> retval
```

### VectorOfInt64::sort

```cpp
void VectorOfInt64::sort( void*  comparator,
                          size_t start = 0,
                          size_t count = __self->get()->size() );
AutoIt:
    $oVectorOfInt64.sort( $comparator[, $start[, $count]] ) -> None
```

### VectorOfInt64::sort_variant

```cpp
void VectorOfInt64::sort_variant( void*  comparator,
                                  size_t start = 0,
                                  size_t count = __self->get()->size() );
AutoIt:
    $oVectorOfInt64.sort_variant( $comparator[, $start[, $count]] ) -> None
```

### VectorOfInt64::start

```cpp
void* VectorOfInt64::start();
AutoIt:
    $oVectorOfInt64.start() -> retval
```

## VectorOfShared_ptrMessage

### VectorOfShared_ptrMessage::create

```cpp
static VectorOfShared_ptrMessage VectorOfShared_ptrMessage::create();
AutoIt:
    _Mediapipe_ObjCreate("VectorOfShared_ptrMessage").create() -> <VectorOfShared_ptrMessage object>
```

```cpp
static VectorOfShared_ptrMessage VectorOfShared_ptrMessage::create( size_t size );
AutoIt:
    _Mediapipe_ObjCreate("VectorOfShared_ptrMessage").create( $size ) -> <VectorOfShared_ptrMessage object>
```

```cpp
static VectorOfShared_ptrMessage VectorOfShared_ptrMessage::create( VectorOfShared_ptrMessage other );
AutoIt:
    _Mediapipe_ObjCreate("VectorOfShared_ptrMessage").create( $other ) -> <VectorOfShared_ptrMessage object>
```

### VectorOfShared_ptrMessage::Add

```cpp
void VectorOfShared_ptrMessage::Add( std::shared_ptr<google::protobuf::Message> value );
AutoIt:
    $oVectorOfShared_ptrMessage.Add( $value ) -> None
```

### VectorOfShared_ptrMessage::Items

```cpp
VectorOfShared_ptrMessage VectorOfShared_ptrMessage::Items();
AutoIt:
    $oVectorOfShared_ptrMessage.Items() -> retval
```

### VectorOfShared_ptrMessage::Keys

```cpp
std::vector<int> VectorOfShared_ptrMessage::Keys();
AutoIt:
    $oVectorOfShared_ptrMessage.Keys() -> retval
```

### VectorOfShared_ptrMessage::Remove

```cpp
void VectorOfShared_ptrMessage::Remove( size_t index );
AutoIt:
    $oVectorOfShared_ptrMessage.Remove( $index ) -> None
```

### VectorOfShared_ptrMessage::at

```cpp
std::shared_ptr<google::protobuf::Message> VectorOfShared_ptrMessage::at( size_t index );
AutoIt:
    $oVectorOfShared_ptrMessage.at( $index ) -> retval
```

```cpp
void VectorOfShared_ptrMessage::at( size_t                                     index,
                                    std::shared_ptr<google::protobuf::Message> value );
AutoIt:
    $oVectorOfShared_ptrMessage.at( $index, $value ) -> None
```

### VectorOfShared_ptrMessage::clear

```cpp
void VectorOfShared_ptrMessage::clear();
AutoIt:
    $oVectorOfShared_ptrMessage.clear() -> None
```

### VectorOfShared_ptrMessage::empty

```cpp
bool VectorOfShared_ptrMessage::empty();
AutoIt:
    $oVectorOfShared_ptrMessage.empty() -> retval
```

### VectorOfShared_ptrMessage::end

```cpp
void* VectorOfShared_ptrMessage::end();
AutoIt:
    $oVectorOfShared_ptrMessage.end() -> retval
```

### VectorOfShared_ptrMessage::get_Item

```cpp
std::shared_ptr<google::protobuf::Message> VectorOfShared_ptrMessage::get_Item( size_t vIndex );
AutoIt:
    $oVectorOfShared_ptrMessage.Item( $vIndex ) -> retval
    $oVectorOfShared_ptrMessage( $vIndex ) -> retval
```

### VectorOfShared_ptrMessage::get__NewEnum

```cpp
IUnknown* VectorOfShared_ptrMessage::get__NewEnum();
AutoIt:
    $oVectorOfShared_ptrMessage._NewEnum() -> retval
```

### VectorOfShared_ptrMessage::push_back

```cpp
void VectorOfShared_ptrMessage::push_back( std::shared_ptr<google::protobuf::Message> value );
AutoIt:
    $oVectorOfShared_ptrMessage.push_back( $value ) -> None
```

### VectorOfShared_ptrMessage::push_vector

```cpp
void VectorOfShared_ptrMessage::push_vector( VectorOfShared_ptrMessage other );
AutoIt:
    $oVectorOfShared_ptrMessage.push_vector( $other ) -> None
```

```cpp
void VectorOfShared_ptrMessage::push_vector( VectorOfShared_ptrMessage other,
                                             size_t                    count,
                                             size_t                    start = 0 );
AutoIt:
    $oVectorOfShared_ptrMessage.push_vector( $other, $count[, $start] ) -> None
```

### VectorOfShared_ptrMessage::put_Item

```cpp
void VectorOfShared_ptrMessage::put_Item( size_t                                     vIndex,
                                          std::shared_ptr<google::protobuf::Message> vItem );
AutoIt:
    $oVectorOfShared_ptrMessage.Item( $vIndex ) = $vItem
```

### VectorOfShared_ptrMessage::size

```cpp
size_t VectorOfShared_ptrMessage::size();
AutoIt:
    $oVectorOfShared_ptrMessage.size() -> retval
```

### VectorOfShared_ptrMessage::slice

```cpp
VectorOfShared_ptrMessage VectorOfShared_ptrMessage::slice( size_t start = 0,
                                                            size_t count = __self->get()->size() );
AutoIt:
    $oVectorOfShared_ptrMessage.slice( [$start[, $count]] ) -> retval
```

### VectorOfShared_ptrMessage::sort

```cpp
void VectorOfShared_ptrMessage::sort( void*  comparator,
                                      size_t start = 0,
                                      size_t count = __self->get()->size() );
AutoIt:
    $oVectorOfShared_ptrMessage.sort( $comparator[, $start[, $count]] ) -> None
```

### VectorOfShared_ptrMessage::sort_variant

```cpp
void VectorOfShared_ptrMessage::sort_variant( void*  comparator,
                                              size_t start = 0,
                                              size_t count = __self->get()->size() );
AutoIt:
    $oVectorOfShared_ptrMessage.sort_variant( $comparator[, $start[, $count]] ) -> None
```

### VectorOfShared_ptrMessage::start

```cpp
void* VectorOfShared_ptrMessage::start();
AutoIt:
    $oVectorOfShared_ptrMessage.start() -> retval
```

## MapOfStringAndPacketDataType

### MapOfStringAndPacketDataType::create

```cpp
static MapOfStringAndPacketDataType MapOfStringAndPacketDataType::create();
AutoIt:
    _Mediapipe_ObjCreate("MapOfStringAndPacketDataType").create() -> <MapOfStringAndPacketDataType object>
```

```cpp
static std::shared_ptr<MapOfStringAndPacketDataType> MapOfStringAndPacketDataType::create( std::vector<std::pair<std::string, mediapipe::autoit::solution_base::PacketDataType>> pairs );
AutoIt:
    _Mediapipe_ObjCreate("MapOfStringAndPacketDataType").create( $pairs ) -> retval
```

### MapOfStringAndPacketDataType::Add

```cpp
void MapOfStringAndPacketDataType::Add( std::string                                      key,
                                        mediapipe::autoit::solution_base::PacketDataType value );
AutoIt:
    $oMapOfStringAndPacketDataType.Add( $key, $value ) -> None
```

### MapOfStringAndPacketDataType::Get

```cpp
mediapipe::autoit::solution_base::PacketDataType MapOfStringAndPacketDataType::Get( std::string key );
AutoIt:
    $oMapOfStringAndPacketDataType.Get( $key ) -> retval
```

### MapOfStringAndPacketDataType::Items

```cpp
std::vector<mediapipe::autoit::solution_base::PacketDataType> MapOfStringAndPacketDataType::Items();
AutoIt:
    $oMapOfStringAndPacketDataType.Items() -> retval
```

### MapOfStringAndPacketDataType::Keys

```cpp
std::vector<std::string> MapOfStringAndPacketDataType::Keys();
AutoIt:
    $oMapOfStringAndPacketDataType.Keys() -> retval
```

### MapOfStringAndPacketDataType::Remove

```cpp
size_t MapOfStringAndPacketDataType::Remove( std::string key );
AutoIt:
    $oMapOfStringAndPacketDataType.Remove( $key ) -> retval
```

### MapOfStringAndPacketDataType::clear

```cpp
void MapOfStringAndPacketDataType::clear();
AutoIt:
    $oMapOfStringAndPacketDataType.clear() -> None
```

### MapOfStringAndPacketDataType::contains

```cpp
bool MapOfStringAndPacketDataType::contains( std::string key );
AutoIt:
    $oMapOfStringAndPacketDataType.contains( $key ) -> retval
```

### MapOfStringAndPacketDataType::count

```cpp
size_t MapOfStringAndPacketDataType::count( std::string key );
AutoIt:
    $oMapOfStringAndPacketDataType.count( $key ) -> retval
```

### MapOfStringAndPacketDataType::empty

```cpp
bool MapOfStringAndPacketDataType::empty();
AutoIt:
    $oMapOfStringAndPacketDataType.empty() -> retval
```

### MapOfStringAndPacketDataType::erase

```cpp
size_t MapOfStringAndPacketDataType::erase( std::string key );
AutoIt:
    $oMapOfStringAndPacketDataType.erase( $key ) -> retval
```

### MapOfStringAndPacketDataType::get_Item

```cpp
mediapipe::autoit::solution_base::PacketDataType MapOfStringAndPacketDataType::get_Item( std::string vKey );
AutoIt:
    $oMapOfStringAndPacketDataType.Item( $vKey ) -> retval
    $oMapOfStringAndPacketDataType( $vKey ) -> retval
```

### MapOfStringAndPacketDataType::get__NewEnum

```cpp
IUnknown* MapOfStringAndPacketDataType::get__NewEnum();
AutoIt:
    $oMapOfStringAndPacketDataType._NewEnum() -> retval
```

### MapOfStringAndPacketDataType::has

```cpp
bool MapOfStringAndPacketDataType::has( std::string key );
AutoIt:
    $oMapOfStringAndPacketDataType.has( $key ) -> retval
```

### MapOfStringAndPacketDataType::max_size

```cpp
size_t MapOfStringAndPacketDataType::max_size();
AutoIt:
    $oMapOfStringAndPacketDataType.max_size() -> retval
```

### MapOfStringAndPacketDataType::merge

```cpp
void MapOfStringAndPacketDataType::merge( MapOfStringAndPacketDataType other );
AutoIt:
    $oMapOfStringAndPacketDataType.merge( $other ) -> None
```

### MapOfStringAndPacketDataType::put_Item

```cpp
void MapOfStringAndPacketDataType::put_Item( std::string                                      vKey,
                                             mediapipe::autoit::solution_base::PacketDataType vItem );
AutoIt:
    $oMapOfStringAndPacketDataType.Item( $vKey ) = $vItem
```

### MapOfStringAndPacketDataType::size

```cpp
size_t MapOfStringAndPacketDataType::size();
AutoIt:
    $oMapOfStringAndPacketDataType.size() -> retval
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

### VectorOfUchar::get__NewEnum

```cpp
IUnknown* VectorOfUchar::get__NewEnum();
AutoIt:
    $oVectorOfUchar._NewEnum() -> retval
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
                                    size_t count = __self->get()->size() );
AutoIt:
    $oVectorOfUchar.slice( [$start[, $count]] ) -> retval
```

### VectorOfUchar::sort

```cpp
void VectorOfUchar::sort( void*  comparator,
                          size_t start = 0,
                          size_t count = __self->get()->size() );
AutoIt:
    $oVectorOfUchar.sort( $comparator[, $start[, $count]] ) -> None
```

### VectorOfUchar::sort_variant

```cpp
void VectorOfUchar::sort_variant( void*  comparator,
                                  size_t start = 0,
                                  size_t count = __self->get()->size() );
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

### VectorOfMat::get__NewEnum

```cpp
IUnknown* VectorOfMat::get__NewEnum();
AutoIt:
    $oVectorOfMat._NewEnum() -> retval
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
                                size_t count = __self->get()->size() );
AutoIt:
    $oVectorOfMat.slice( [$start[, $count]] ) -> retval
```

### VectorOfMat::sort

```cpp
void VectorOfMat::sort( void*  comparator,
                        size_t start = 0,
                        size_t count = __self->get()->size() );
AutoIt:
    $oVectorOfMat.sort( $comparator[, $start[, $count]] ) -> None
```

### VectorOfMat::sort_variant

```cpp
void VectorOfMat::sort_variant( void*  comparator,
                                size_t start = 0,
                                size_t count = __self->get()->size() );
AutoIt:
    $oVectorOfMat.sort_variant( $comparator[, $start[, $count]] ) -> None
```

### VectorOfMat::start

```cpp
void* VectorOfMat::start();
AutoIt:
    $oVectorOfMat.start() -> retval
```

## VectorOfShared_ptrPacketFactoryConfig

### VectorOfShared_ptrPacketFactoryConfig::create

```cpp
static VectorOfShared_ptrPacketFactoryConfig VectorOfShared_ptrPacketFactoryConfig::create();
AutoIt:
    _Mediapipe_ObjCreate("VectorOfShared_ptrPacketFactoryConfig").create() -> <VectorOfShared_ptrPacketFactoryConfig object>
```

```cpp
static VectorOfShared_ptrPacketFactoryConfig VectorOfShared_ptrPacketFactoryConfig::create( size_t size );
AutoIt:
    _Mediapipe_ObjCreate("VectorOfShared_ptrPacketFactoryConfig").create( $size ) -> <VectorOfShared_ptrPacketFactoryConfig object>
```

```cpp
static VectorOfShared_ptrPacketFactoryConfig VectorOfShared_ptrPacketFactoryConfig::create( VectorOfShared_ptrPacketFactoryConfig other );
AutoIt:
    _Mediapipe_ObjCreate("VectorOfShared_ptrPacketFactoryConfig").create( $other ) -> <VectorOfShared_ptrPacketFactoryConfig object>
```

### VectorOfShared_ptrPacketFactoryConfig::Add

```cpp
void VectorOfShared_ptrPacketFactoryConfig::Add( std::shared_ptr<mediapipe::PacketFactoryConfig> value );
AutoIt:
    $oVectorOfShared_ptrPacketFactoryConfig.Add( $value ) -> None
```

### VectorOfShared_ptrPacketFactoryConfig::Items

```cpp
VectorOfShared_ptrPacketFactoryConfig VectorOfShared_ptrPacketFactoryConfig::Items();
AutoIt:
    $oVectorOfShared_ptrPacketFactoryConfig.Items() -> retval
```

### VectorOfShared_ptrPacketFactoryConfig::Keys

```cpp
std::vector<int> VectorOfShared_ptrPacketFactoryConfig::Keys();
AutoIt:
    $oVectorOfShared_ptrPacketFactoryConfig.Keys() -> retval
```

### VectorOfShared_ptrPacketFactoryConfig::Remove

```cpp
void VectorOfShared_ptrPacketFactoryConfig::Remove( size_t index );
AutoIt:
    $oVectorOfShared_ptrPacketFactoryConfig.Remove( $index ) -> None
```

### VectorOfShared_ptrPacketFactoryConfig::at

```cpp
std::shared_ptr<mediapipe::PacketFactoryConfig> VectorOfShared_ptrPacketFactoryConfig::at( size_t index );
AutoIt:
    $oVectorOfShared_ptrPacketFactoryConfig.at( $index ) -> retval
```

```cpp
void VectorOfShared_ptrPacketFactoryConfig::at( size_t                                          index,
                                                std::shared_ptr<mediapipe::PacketFactoryConfig> value );
AutoIt:
    $oVectorOfShared_ptrPacketFactoryConfig.at( $index, $value ) -> None
```

### VectorOfShared_ptrPacketFactoryConfig::clear

```cpp
void VectorOfShared_ptrPacketFactoryConfig::clear();
AutoIt:
    $oVectorOfShared_ptrPacketFactoryConfig.clear() -> None
```

### VectorOfShared_ptrPacketFactoryConfig::empty

```cpp
bool VectorOfShared_ptrPacketFactoryConfig::empty();
AutoIt:
    $oVectorOfShared_ptrPacketFactoryConfig.empty() -> retval
```

### VectorOfShared_ptrPacketFactoryConfig::end

```cpp
void* VectorOfShared_ptrPacketFactoryConfig::end();
AutoIt:
    $oVectorOfShared_ptrPacketFactoryConfig.end() -> retval
```

### VectorOfShared_ptrPacketFactoryConfig::get_Item

```cpp
std::shared_ptr<mediapipe::PacketFactoryConfig> VectorOfShared_ptrPacketFactoryConfig::get_Item( size_t vIndex );
AutoIt:
    $oVectorOfShared_ptrPacketFactoryConfig.Item( $vIndex ) -> retval
    $oVectorOfShared_ptrPacketFactoryConfig( $vIndex ) -> retval
```

### VectorOfShared_ptrPacketFactoryConfig::get__NewEnum

```cpp
IUnknown* VectorOfShared_ptrPacketFactoryConfig::get__NewEnum();
AutoIt:
    $oVectorOfShared_ptrPacketFactoryConfig._NewEnum() -> retval
```

### VectorOfShared_ptrPacketFactoryConfig::push_back

```cpp
void VectorOfShared_ptrPacketFactoryConfig::push_back( std::shared_ptr<mediapipe::PacketFactoryConfig> value );
AutoIt:
    $oVectorOfShared_ptrPacketFactoryConfig.push_back( $value ) -> None
```

### VectorOfShared_ptrPacketFactoryConfig::push_vector

```cpp
void VectorOfShared_ptrPacketFactoryConfig::push_vector( VectorOfShared_ptrPacketFactoryConfig other );
AutoIt:
    $oVectorOfShared_ptrPacketFactoryConfig.push_vector( $other ) -> None
```

```cpp
void VectorOfShared_ptrPacketFactoryConfig::push_vector( VectorOfShared_ptrPacketFactoryConfig other,
                                                         size_t                                count,
                                                         size_t                                start = 0 );
AutoIt:
    $oVectorOfShared_ptrPacketFactoryConfig.push_vector( $other, $count[, $start] ) -> None
```

### VectorOfShared_ptrPacketFactoryConfig::put_Item

```cpp
void VectorOfShared_ptrPacketFactoryConfig::put_Item( size_t                                          vIndex,
                                                      std::shared_ptr<mediapipe::PacketFactoryConfig> vItem );
AutoIt:
    $oVectorOfShared_ptrPacketFactoryConfig.Item( $vIndex ) = $vItem
```

### VectorOfShared_ptrPacketFactoryConfig::size

```cpp
size_t VectorOfShared_ptrPacketFactoryConfig::size();
AutoIt:
    $oVectorOfShared_ptrPacketFactoryConfig.size() -> retval
```

### VectorOfShared_ptrPacketFactoryConfig::slice

```cpp
VectorOfShared_ptrPacketFactoryConfig VectorOfShared_ptrPacketFactoryConfig::slice( size_t start = 0,
                                                                                    size_t count = __self->get()->size() );
AutoIt:
    $oVectorOfShared_ptrPacketFactoryConfig.slice( [$start[, $count]] ) -> retval
```

### VectorOfShared_ptrPacketFactoryConfig::sort

```cpp
void VectorOfShared_ptrPacketFactoryConfig::sort( void*  comparator,
                                                  size_t start = 0,
                                                  size_t count = __self->get()->size() );
AutoIt:
    $oVectorOfShared_ptrPacketFactoryConfig.sort( $comparator[, $start[, $count]] ) -> None
```

### VectorOfShared_ptrPacketFactoryConfig::sort_variant

```cpp
void VectorOfShared_ptrPacketFactoryConfig::sort_variant( void*  comparator,
                                                          size_t start = 0,
                                                          size_t count = __self->get()->size() );
AutoIt:
    $oVectorOfShared_ptrPacketFactoryConfig.sort_variant( $comparator[, $start[, $count]] ) -> None
```

### VectorOfShared_ptrPacketFactoryConfig::start

```cpp
void* VectorOfShared_ptrPacketFactoryConfig::start();
AutoIt:
    $oVectorOfShared_ptrPacketFactoryConfig.start() -> retval
```

## VectorOfShared_ptrInputCollection

### VectorOfShared_ptrInputCollection::create

```cpp
static VectorOfShared_ptrInputCollection VectorOfShared_ptrInputCollection::create();
AutoIt:
    _Mediapipe_ObjCreate("VectorOfShared_ptrInputCollection").create() -> <VectorOfShared_ptrInputCollection object>
```

```cpp
static VectorOfShared_ptrInputCollection VectorOfShared_ptrInputCollection::create( size_t size );
AutoIt:
    _Mediapipe_ObjCreate("VectorOfShared_ptrInputCollection").create( $size ) -> <VectorOfShared_ptrInputCollection object>
```

```cpp
static VectorOfShared_ptrInputCollection VectorOfShared_ptrInputCollection::create( VectorOfShared_ptrInputCollection other );
AutoIt:
    _Mediapipe_ObjCreate("VectorOfShared_ptrInputCollection").create( $other ) -> <VectorOfShared_ptrInputCollection object>
```

### VectorOfShared_ptrInputCollection::Add

```cpp
void VectorOfShared_ptrInputCollection::Add( std::shared_ptr<mediapipe::InputCollection> value );
AutoIt:
    $oVectorOfShared_ptrInputCollection.Add( $value ) -> None
```

### VectorOfShared_ptrInputCollection::Items

```cpp
VectorOfShared_ptrInputCollection VectorOfShared_ptrInputCollection::Items();
AutoIt:
    $oVectorOfShared_ptrInputCollection.Items() -> retval
```

### VectorOfShared_ptrInputCollection::Keys

```cpp
std::vector<int> VectorOfShared_ptrInputCollection::Keys();
AutoIt:
    $oVectorOfShared_ptrInputCollection.Keys() -> retval
```

### VectorOfShared_ptrInputCollection::Remove

```cpp
void VectorOfShared_ptrInputCollection::Remove( size_t index );
AutoIt:
    $oVectorOfShared_ptrInputCollection.Remove( $index ) -> None
```

### VectorOfShared_ptrInputCollection::at

```cpp
std::shared_ptr<mediapipe::InputCollection> VectorOfShared_ptrInputCollection::at( size_t index );
AutoIt:
    $oVectorOfShared_ptrInputCollection.at( $index ) -> retval
```

```cpp
void VectorOfShared_ptrInputCollection::at( size_t                                      index,
                                            std::shared_ptr<mediapipe::InputCollection> value );
AutoIt:
    $oVectorOfShared_ptrInputCollection.at( $index, $value ) -> None
```

### VectorOfShared_ptrInputCollection::clear

```cpp
void VectorOfShared_ptrInputCollection::clear();
AutoIt:
    $oVectorOfShared_ptrInputCollection.clear() -> None
```

### VectorOfShared_ptrInputCollection::empty

```cpp
bool VectorOfShared_ptrInputCollection::empty();
AutoIt:
    $oVectorOfShared_ptrInputCollection.empty() -> retval
```

### VectorOfShared_ptrInputCollection::end

```cpp
void* VectorOfShared_ptrInputCollection::end();
AutoIt:
    $oVectorOfShared_ptrInputCollection.end() -> retval
```

### VectorOfShared_ptrInputCollection::get_Item

```cpp
std::shared_ptr<mediapipe::InputCollection> VectorOfShared_ptrInputCollection::get_Item( size_t vIndex );
AutoIt:
    $oVectorOfShared_ptrInputCollection.Item( $vIndex ) -> retval
    $oVectorOfShared_ptrInputCollection( $vIndex ) -> retval
```

### VectorOfShared_ptrInputCollection::get__NewEnum

```cpp
IUnknown* VectorOfShared_ptrInputCollection::get__NewEnum();
AutoIt:
    $oVectorOfShared_ptrInputCollection._NewEnum() -> retval
```

### VectorOfShared_ptrInputCollection::push_back

```cpp
void VectorOfShared_ptrInputCollection::push_back( std::shared_ptr<mediapipe::InputCollection> value );
AutoIt:
    $oVectorOfShared_ptrInputCollection.push_back( $value ) -> None
```

### VectorOfShared_ptrInputCollection::push_vector

```cpp
void VectorOfShared_ptrInputCollection::push_vector( VectorOfShared_ptrInputCollection other );
AutoIt:
    $oVectorOfShared_ptrInputCollection.push_vector( $other ) -> None
```

```cpp
void VectorOfShared_ptrInputCollection::push_vector( VectorOfShared_ptrInputCollection other,
                                                     size_t                            count,
                                                     size_t                            start = 0 );
AutoIt:
    $oVectorOfShared_ptrInputCollection.push_vector( $other, $count[, $start] ) -> None
```

### VectorOfShared_ptrInputCollection::put_Item

```cpp
void VectorOfShared_ptrInputCollection::put_Item( size_t                                      vIndex,
                                                  std::shared_ptr<mediapipe::InputCollection> vItem );
AutoIt:
    $oVectorOfShared_ptrInputCollection.Item( $vIndex ) = $vItem
```

### VectorOfShared_ptrInputCollection::size

```cpp
size_t VectorOfShared_ptrInputCollection::size();
AutoIt:
    $oVectorOfShared_ptrInputCollection.size() -> retval
```

### VectorOfShared_ptrInputCollection::slice

```cpp
VectorOfShared_ptrInputCollection VectorOfShared_ptrInputCollection::slice( size_t start = 0,
                                                                            size_t count = __self->get()->size() );
AutoIt:
    $oVectorOfShared_ptrInputCollection.slice( [$start[, $count]] ) -> retval
```

### VectorOfShared_ptrInputCollection::sort

```cpp
void VectorOfShared_ptrInputCollection::sort( void*  comparator,
                                              size_t start = 0,
                                              size_t count = __self->get()->size() );
AutoIt:
    $oVectorOfShared_ptrInputCollection.sort( $comparator[, $start[, $count]] ) -> None
```

### VectorOfShared_ptrInputCollection::sort_variant

```cpp
void VectorOfShared_ptrInputCollection::sort_variant( void*  comparator,
                                                      size_t start = 0,
                                                      size_t count = __self->get()->size() );
AutoIt:
    $oVectorOfShared_ptrInputCollection.sort_variant( $comparator[, $start[, $count]] ) -> None
```

### VectorOfShared_ptrInputCollection::start

```cpp
void* VectorOfShared_ptrInputCollection::start();
AutoIt:
    $oVectorOfShared_ptrInputCollection.start() -> retval
```

## VectorOfShared_ptrNode

### VectorOfShared_ptrNode::create

```cpp
static VectorOfShared_ptrNode VectorOfShared_ptrNode::create();
AutoIt:
    _Mediapipe_ObjCreate("VectorOfShared_ptrNode").create() -> <VectorOfShared_ptrNode object>
```

```cpp
static VectorOfShared_ptrNode VectorOfShared_ptrNode::create( size_t size );
AutoIt:
    _Mediapipe_ObjCreate("VectorOfShared_ptrNode").create( $size ) -> <VectorOfShared_ptrNode object>
```

```cpp
static VectorOfShared_ptrNode VectorOfShared_ptrNode::create( VectorOfShared_ptrNode other );
AutoIt:
    _Mediapipe_ObjCreate("VectorOfShared_ptrNode").create( $other ) -> <VectorOfShared_ptrNode object>
```

### VectorOfShared_ptrNode::Add

```cpp
void VectorOfShared_ptrNode::Add( std::shared_ptr<mediapipe::CalculatorGraphConfig::Node> value );
AutoIt:
    $oVectorOfShared_ptrNode.Add( $value ) -> None
```

### VectorOfShared_ptrNode::Items

```cpp
VectorOfShared_ptrNode VectorOfShared_ptrNode::Items();
AutoIt:
    $oVectorOfShared_ptrNode.Items() -> retval
```

### VectorOfShared_ptrNode::Keys

```cpp
std::vector<int> VectorOfShared_ptrNode::Keys();
AutoIt:
    $oVectorOfShared_ptrNode.Keys() -> retval
```

### VectorOfShared_ptrNode::Remove

```cpp
void VectorOfShared_ptrNode::Remove( size_t index );
AutoIt:
    $oVectorOfShared_ptrNode.Remove( $index ) -> None
```

### VectorOfShared_ptrNode::at

```cpp
std::shared_ptr<mediapipe::CalculatorGraphConfig::Node> VectorOfShared_ptrNode::at( size_t index );
AutoIt:
    $oVectorOfShared_ptrNode.at( $index ) -> retval
```

```cpp
void VectorOfShared_ptrNode::at( size_t                                                  index,
                                 std::shared_ptr<mediapipe::CalculatorGraphConfig::Node> value );
AutoIt:
    $oVectorOfShared_ptrNode.at( $index, $value ) -> None
```

### VectorOfShared_ptrNode::clear

```cpp
void VectorOfShared_ptrNode::clear();
AutoIt:
    $oVectorOfShared_ptrNode.clear() -> None
```

### VectorOfShared_ptrNode::empty

```cpp
bool VectorOfShared_ptrNode::empty();
AutoIt:
    $oVectorOfShared_ptrNode.empty() -> retval
```

### VectorOfShared_ptrNode::end

```cpp
void* VectorOfShared_ptrNode::end();
AutoIt:
    $oVectorOfShared_ptrNode.end() -> retval
```

### VectorOfShared_ptrNode::get_Item

```cpp
std::shared_ptr<mediapipe::CalculatorGraphConfig::Node> VectorOfShared_ptrNode::get_Item( size_t vIndex );
AutoIt:
    $oVectorOfShared_ptrNode.Item( $vIndex ) -> retval
    $oVectorOfShared_ptrNode( $vIndex ) -> retval
```

### VectorOfShared_ptrNode::get__NewEnum

```cpp
IUnknown* VectorOfShared_ptrNode::get__NewEnum();
AutoIt:
    $oVectorOfShared_ptrNode._NewEnum() -> retval
```

### VectorOfShared_ptrNode::push_back

```cpp
void VectorOfShared_ptrNode::push_back( std::shared_ptr<mediapipe::CalculatorGraphConfig::Node> value );
AutoIt:
    $oVectorOfShared_ptrNode.push_back( $value ) -> None
```

### VectorOfShared_ptrNode::push_vector

```cpp
void VectorOfShared_ptrNode::push_vector( VectorOfShared_ptrNode other );
AutoIt:
    $oVectorOfShared_ptrNode.push_vector( $other ) -> None
```

```cpp
void VectorOfShared_ptrNode::push_vector( VectorOfShared_ptrNode other,
                                          size_t                 count,
                                          size_t                 start = 0 );
AutoIt:
    $oVectorOfShared_ptrNode.push_vector( $other, $count[, $start] ) -> None
```

### VectorOfShared_ptrNode::put_Item

```cpp
void VectorOfShared_ptrNode::put_Item( size_t                                                  vIndex,
                                       std::shared_ptr<mediapipe::CalculatorGraphConfig::Node> vItem );
AutoIt:
    $oVectorOfShared_ptrNode.Item( $vIndex ) = $vItem
```

### VectorOfShared_ptrNode::size

```cpp
size_t VectorOfShared_ptrNode::size();
AutoIt:
    $oVectorOfShared_ptrNode.size() -> retval
```

### VectorOfShared_ptrNode::slice

```cpp
VectorOfShared_ptrNode VectorOfShared_ptrNode::slice( size_t start = 0,
                                                      size_t count = __self->get()->size() );
AutoIt:
    $oVectorOfShared_ptrNode.slice( [$start[, $count]] ) -> retval
```

### VectorOfShared_ptrNode::sort

```cpp
void VectorOfShared_ptrNode::sort( void*  comparator,
                                   size_t start = 0,
                                   size_t count = __self->get()->size() );
AutoIt:
    $oVectorOfShared_ptrNode.sort( $comparator[, $start[, $count]] ) -> None
```

### VectorOfShared_ptrNode::sort_variant

```cpp
void VectorOfShared_ptrNode::sort_variant( void*  comparator,
                                           size_t start = 0,
                                           size_t count = __self->get()->size() );
AutoIt:
    $oVectorOfShared_ptrNode.sort_variant( $comparator[, $start[, $count]] ) -> None
```

### VectorOfShared_ptrNode::start

```cpp
void* VectorOfShared_ptrNode::start();
AutoIt:
    $oVectorOfShared_ptrNode.start() -> retval
```

## VectorOfShared_ptrPacketGeneratorConfig

### VectorOfShared_ptrPacketGeneratorConfig::create

```cpp
static VectorOfShared_ptrPacketGeneratorConfig VectorOfShared_ptrPacketGeneratorConfig::create();
AutoIt:
    _Mediapipe_ObjCreate("VectorOfShared_ptrPacketGeneratorConfig").create() -> <VectorOfShared_ptrPacketGeneratorConfig object>
```

```cpp
static VectorOfShared_ptrPacketGeneratorConfig VectorOfShared_ptrPacketGeneratorConfig::create( size_t size );
AutoIt:
    _Mediapipe_ObjCreate("VectorOfShared_ptrPacketGeneratorConfig").create( $size ) -> <VectorOfShared_ptrPacketGeneratorConfig object>
```

```cpp
static VectorOfShared_ptrPacketGeneratorConfig VectorOfShared_ptrPacketGeneratorConfig::create( VectorOfShared_ptrPacketGeneratorConfig other );
AutoIt:
    _Mediapipe_ObjCreate("VectorOfShared_ptrPacketGeneratorConfig").create( $other ) -> <VectorOfShared_ptrPacketGeneratorConfig object>
```

### VectorOfShared_ptrPacketGeneratorConfig::Add

```cpp
void VectorOfShared_ptrPacketGeneratorConfig::Add( std::shared_ptr<mediapipe::PacketGeneratorConfig> value );
AutoIt:
    $oVectorOfShared_ptrPacketGeneratorConfig.Add( $value ) -> None
```

### VectorOfShared_ptrPacketGeneratorConfig::Items

```cpp
VectorOfShared_ptrPacketGeneratorConfig VectorOfShared_ptrPacketGeneratorConfig::Items();
AutoIt:
    $oVectorOfShared_ptrPacketGeneratorConfig.Items() -> retval
```

### VectorOfShared_ptrPacketGeneratorConfig::Keys

```cpp
std::vector<int> VectorOfShared_ptrPacketGeneratorConfig::Keys();
AutoIt:
    $oVectorOfShared_ptrPacketGeneratorConfig.Keys() -> retval
```

### VectorOfShared_ptrPacketGeneratorConfig::Remove

```cpp
void VectorOfShared_ptrPacketGeneratorConfig::Remove( size_t index );
AutoIt:
    $oVectorOfShared_ptrPacketGeneratorConfig.Remove( $index ) -> None
```

### VectorOfShared_ptrPacketGeneratorConfig::at

```cpp
std::shared_ptr<mediapipe::PacketGeneratorConfig> VectorOfShared_ptrPacketGeneratorConfig::at( size_t index );
AutoIt:
    $oVectorOfShared_ptrPacketGeneratorConfig.at( $index ) -> retval
```

```cpp
void VectorOfShared_ptrPacketGeneratorConfig::at( size_t                                            index,
                                                  std::shared_ptr<mediapipe::PacketGeneratorConfig> value );
AutoIt:
    $oVectorOfShared_ptrPacketGeneratorConfig.at( $index, $value ) -> None
```

### VectorOfShared_ptrPacketGeneratorConfig::clear

```cpp
void VectorOfShared_ptrPacketGeneratorConfig::clear();
AutoIt:
    $oVectorOfShared_ptrPacketGeneratorConfig.clear() -> None
```

### VectorOfShared_ptrPacketGeneratorConfig::empty

```cpp
bool VectorOfShared_ptrPacketGeneratorConfig::empty();
AutoIt:
    $oVectorOfShared_ptrPacketGeneratorConfig.empty() -> retval
```

### VectorOfShared_ptrPacketGeneratorConfig::end

```cpp
void* VectorOfShared_ptrPacketGeneratorConfig::end();
AutoIt:
    $oVectorOfShared_ptrPacketGeneratorConfig.end() -> retval
```

### VectorOfShared_ptrPacketGeneratorConfig::get_Item

```cpp
std::shared_ptr<mediapipe::PacketGeneratorConfig> VectorOfShared_ptrPacketGeneratorConfig::get_Item( size_t vIndex );
AutoIt:
    $oVectorOfShared_ptrPacketGeneratorConfig.Item( $vIndex ) -> retval
    $oVectorOfShared_ptrPacketGeneratorConfig( $vIndex ) -> retval
```

### VectorOfShared_ptrPacketGeneratorConfig::get__NewEnum

```cpp
IUnknown* VectorOfShared_ptrPacketGeneratorConfig::get__NewEnum();
AutoIt:
    $oVectorOfShared_ptrPacketGeneratorConfig._NewEnum() -> retval
```

### VectorOfShared_ptrPacketGeneratorConfig::push_back

```cpp
void VectorOfShared_ptrPacketGeneratorConfig::push_back( std::shared_ptr<mediapipe::PacketGeneratorConfig> value );
AutoIt:
    $oVectorOfShared_ptrPacketGeneratorConfig.push_back( $value ) -> None
```

### VectorOfShared_ptrPacketGeneratorConfig::push_vector

```cpp
void VectorOfShared_ptrPacketGeneratorConfig::push_vector( VectorOfShared_ptrPacketGeneratorConfig other );
AutoIt:
    $oVectorOfShared_ptrPacketGeneratorConfig.push_vector( $other ) -> None
```

```cpp
void VectorOfShared_ptrPacketGeneratorConfig::push_vector( VectorOfShared_ptrPacketGeneratorConfig other,
                                                           size_t                                  count,
                                                           size_t                                  start = 0 );
AutoIt:
    $oVectorOfShared_ptrPacketGeneratorConfig.push_vector( $other, $count[, $start] ) -> None
```

### VectorOfShared_ptrPacketGeneratorConfig::put_Item

```cpp
void VectorOfShared_ptrPacketGeneratorConfig::put_Item( size_t                                            vIndex,
                                                        std::shared_ptr<mediapipe::PacketGeneratorConfig> vItem );
AutoIt:
    $oVectorOfShared_ptrPacketGeneratorConfig.Item( $vIndex ) = $vItem
```

### VectorOfShared_ptrPacketGeneratorConfig::size

```cpp
size_t VectorOfShared_ptrPacketGeneratorConfig::size();
AutoIt:
    $oVectorOfShared_ptrPacketGeneratorConfig.size() -> retval
```

### VectorOfShared_ptrPacketGeneratorConfig::slice

```cpp
VectorOfShared_ptrPacketGeneratorConfig VectorOfShared_ptrPacketGeneratorConfig::slice( size_t start = 0,
                                                                                        size_t count = __self->get()->size() );
AutoIt:
    $oVectorOfShared_ptrPacketGeneratorConfig.slice( [$start[, $count]] ) -> retval
```

### VectorOfShared_ptrPacketGeneratorConfig::sort

```cpp
void VectorOfShared_ptrPacketGeneratorConfig::sort( void*  comparator,
                                                    size_t start = 0,
                                                    size_t count = __self->get()->size() );
AutoIt:
    $oVectorOfShared_ptrPacketGeneratorConfig.sort( $comparator[, $start[, $count]] ) -> None
```

### VectorOfShared_ptrPacketGeneratorConfig::sort_variant

```cpp
void VectorOfShared_ptrPacketGeneratorConfig::sort_variant( void*  comparator,
                                                            size_t start = 0,
                                                            size_t count = __self->get()->size() );
AutoIt:
    $oVectorOfShared_ptrPacketGeneratorConfig.sort_variant( $comparator[, $start[, $count]] ) -> None
```

### VectorOfShared_ptrPacketGeneratorConfig::start

```cpp
void* VectorOfShared_ptrPacketGeneratorConfig::start();
AutoIt:
    $oVectorOfShared_ptrPacketGeneratorConfig.start() -> retval
```

## VectorOfShared_ptrStatusHandlerConfig

### VectorOfShared_ptrStatusHandlerConfig::create

```cpp
static VectorOfShared_ptrStatusHandlerConfig VectorOfShared_ptrStatusHandlerConfig::create();
AutoIt:
    _Mediapipe_ObjCreate("VectorOfShared_ptrStatusHandlerConfig").create() -> <VectorOfShared_ptrStatusHandlerConfig object>
```

```cpp
static VectorOfShared_ptrStatusHandlerConfig VectorOfShared_ptrStatusHandlerConfig::create( size_t size );
AutoIt:
    _Mediapipe_ObjCreate("VectorOfShared_ptrStatusHandlerConfig").create( $size ) -> <VectorOfShared_ptrStatusHandlerConfig object>
```

```cpp
static VectorOfShared_ptrStatusHandlerConfig VectorOfShared_ptrStatusHandlerConfig::create( VectorOfShared_ptrStatusHandlerConfig other );
AutoIt:
    _Mediapipe_ObjCreate("VectorOfShared_ptrStatusHandlerConfig").create( $other ) -> <VectorOfShared_ptrStatusHandlerConfig object>
```

### VectorOfShared_ptrStatusHandlerConfig::Add

```cpp
void VectorOfShared_ptrStatusHandlerConfig::Add( std::shared_ptr<mediapipe::StatusHandlerConfig> value );
AutoIt:
    $oVectorOfShared_ptrStatusHandlerConfig.Add( $value ) -> None
```

### VectorOfShared_ptrStatusHandlerConfig::Items

```cpp
VectorOfShared_ptrStatusHandlerConfig VectorOfShared_ptrStatusHandlerConfig::Items();
AutoIt:
    $oVectorOfShared_ptrStatusHandlerConfig.Items() -> retval
```

### VectorOfShared_ptrStatusHandlerConfig::Keys

```cpp
std::vector<int> VectorOfShared_ptrStatusHandlerConfig::Keys();
AutoIt:
    $oVectorOfShared_ptrStatusHandlerConfig.Keys() -> retval
```

### VectorOfShared_ptrStatusHandlerConfig::Remove

```cpp
void VectorOfShared_ptrStatusHandlerConfig::Remove( size_t index );
AutoIt:
    $oVectorOfShared_ptrStatusHandlerConfig.Remove( $index ) -> None
```

### VectorOfShared_ptrStatusHandlerConfig::at

```cpp
std::shared_ptr<mediapipe::StatusHandlerConfig> VectorOfShared_ptrStatusHandlerConfig::at( size_t index );
AutoIt:
    $oVectorOfShared_ptrStatusHandlerConfig.at( $index ) -> retval
```

```cpp
void VectorOfShared_ptrStatusHandlerConfig::at( size_t                                          index,
                                                std::shared_ptr<mediapipe::StatusHandlerConfig> value );
AutoIt:
    $oVectorOfShared_ptrStatusHandlerConfig.at( $index, $value ) -> None
```

### VectorOfShared_ptrStatusHandlerConfig::clear

```cpp
void VectorOfShared_ptrStatusHandlerConfig::clear();
AutoIt:
    $oVectorOfShared_ptrStatusHandlerConfig.clear() -> None
```

### VectorOfShared_ptrStatusHandlerConfig::empty

```cpp
bool VectorOfShared_ptrStatusHandlerConfig::empty();
AutoIt:
    $oVectorOfShared_ptrStatusHandlerConfig.empty() -> retval
```

### VectorOfShared_ptrStatusHandlerConfig::end

```cpp
void* VectorOfShared_ptrStatusHandlerConfig::end();
AutoIt:
    $oVectorOfShared_ptrStatusHandlerConfig.end() -> retval
```

### VectorOfShared_ptrStatusHandlerConfig::get_Item

```cpp
std::shared_ptr<mediapipe::StatusHandlerConfig> VectorOfShared_ptrStatusHandlerConfig::get_Item( size_t vIndex );
AutoIt:
    $oVectorOfShared_ptrStatusHandlerConfig.Item( $vIndex ) -> retval
    $oVectorOfShared_ptrStatusHandlerConfig( $vIndex ) -> retval
```

### VectorOfShared_ptrStatusHandlerConfig::get__NewEnum

```cpp
IUnknown* VectorOfShared_ptrStatusHandlerConfig::get__NewEnum();
AutoIt:
    $oVectorOfShared_ptrStatusHandlerConfig._NewEnum() -> retval
```

### VectorOfShared_ptrStatusHandlerConfig::push_back

```cpp
void VectorOfShared_ptrStatusHandlerConfig::push_back( std::shared_ptr<mediapipe::StatusHandlerConfig> value );
AutoIt:
    $oVectorOfShared_ptrStatusHandlerConfig.push_back( $value ) -> None
```

### VectorOfShared_ptrStatusHandlerConfig::push_vector

```cpp
void VectorOfShared_ptrStatusHandlerConfig::push_vector( VectorOfShared_ptrStatusHandlerConfig other );
AutoIt:
    $oVectorOfShared_ptrStatusHandlerConfig.push_vector( $other ) -> None
```

```cpp
void VectorOfShared_ptrStatusHandlerConfig::push_vector( VectorOfShared_ptrStatusHandlerConfig other,
                                                         size_t                                count,
                                                         size_t                                start = 0 );
AutoIt:
    $oVectorOfShared_ptrStatusHandlerConfig.push_vector( $other, $count[, $start] ) -> None
```

### VectorOfShared_ptrStatusHandlerConfig::put_Item

```cpp
void VectorOfShared_ptrStatusHandlerConfig::put_Item( size_t                                          vIndex,
                                                      std::shared_ptr<mediapipe::StatusHandlerConfig> vItem );
AutoIt:
    $oVectorOfShared_ptrStatusHandlerConfig.Item( $vIndex ) = $vItem
```

### VectorOfShared_ptrStatusHandlerConfig::size

```cpp
size_t VectorOfShared_ptrStatusHandlerConfig::size();
AutoIt:
    $oVectorOfShared_ptrStatusHandlerConfig.size() -> retval
```

### VectorOfShared_ptrStatusHandlerConfig::slice

```cpp
VectorOfShared_ptrStatusHandlerConfig VectorOfShared_ptrStatusHandlerConfig::slice( size_t start = 0,
                                                                                    size_t count = __self->get()->size() );
AutoIt:
    $oVectorOfShared_ptrStatusHandlerConfig.slice( [$start[, $count]] ) -> retval
```

### VectorOfShared_ptrStatusHandlerConfig::sort

```cpp
void VectorOfShared_ptrStatusHandlerConfig::sort( void*  comparator,
                                                  size_t start = 0,
                                                  size_t count = __self->get()->size() );
AutoIt:
    $oVectorOfShared_ptrStatusHandlerConfig.sort( $comparator[, $start[, $count]] ) -> None
```

### VectorOfShared_ptrStatusHandlerConfig::sort_variant

```cpp
void VectorOfShared_ptrStatusHandlerConfig::sort_variant( void*  comparator,
                                                          size_t start = 0,
                                                          size_t count = __self->get()->size() );
AutoIt:
    $oVectorOfShared_ptrStatusHandlerConfig.sort_variant( $comparator[, $start[, $count]] ) -> None
```

### VectorOfShared_ptrStatusHandlerConfig::start

```cpp
void* VectorOfShared_ptrStatusHandlerConfig::start();
AutoIt:
    $oVectorOfShared_ptrStatusHandlerConfig.start() -> retval
```

## VectorOfShared_ptrExecutorConfig

### VectorOfShared_ptrExecutorConfig::create

```cpp
static VectorOfShared_ptrExecutorConfig VectorOfShared_ptrExecutorConfig::create();
AutoIt:
    _Mediapipe_ObjCreate("VectorOfShared_ptrExecutorConfig").create() -> <VectorOfShared_ptrExecutorConfig object>
```

```cpp
static VectorOfShared_ptrExecutorConfig VectorOfShared_ptrExecutorConfig::create( size_t size );
AutoIt:
    _Mediapipe_ObjCreate("VectorOfShared_ptrExecutorConfig").create( $size ) -> <VectorOfShared_ptrExecutorConfig object>
```

```cpp
static VectorOfShared_ptrExecutorConfig VectorOfShared_ptrExecutorConfig::create( VectorOfShared_ptrExecutorConfig other );
AutoIt:
    _Mediapipe_ObjCreate("VectorOfShared_ptrExecutorConfig").create( $other ) -> <VectorOfShared_ptrExecutorConfig object>
```

### VectorOfShared_ptrExecutorConfig::Add

```cpp
void VectorOfShared_ptrExecutorConfig::Add( std::shared_ptr<mediapipe::ExecutorConfig> value );
AutoIt:
    $oVectorOfShared_ptrExecutorConfig.Add( $value ) -> None
```

### VectorOfShared_ptrExecutorConfig::Items

```cpp
VectorOfShared_ptrExecutorConfig VectorOfShared_ptrExecutorConfig::Items();
AutoIt:
    $oVectorOfShared_ptrExecutorConfig.Items() -> retval
```

### VectorOfShared_ptrExecutorConfig::Keys

```cpp
std::vector<int> VectorOfShared_ptrExecutorConfig::Keys();
AutoIt:
    $oVectorOfShared_ptrExecutorConfig.Keys() -> retval
```

### VectorOfShared_ptrExecutorConfig::Remove

```cpp
void VectorOfShared_ptrExecutorConfig::Remove( size_t index );
AutoIt:
    $oVectorOfShared_ptrExecutorConfig.Remove( $index ) -> None
```

### VectorOfShared_ptrExecutorConfig::at

```cpp
std::shared_ptr<mediapipe::ExecutorConfig> VectorOfShared_ptrExecutorConfig::at( size_t index );
AutoIt:
    $oVectorOfShared_ptrExecutorConfig.at( $index ) -> retval
```

```cpp
void VectorOfShared_ptrExecutorConfig::at( size_t                                     index,
                                           std::shared_ptr<mediapipe::ExecutorConfig> value );
AutoIt:
    $oVectorOfShared_ptrExecutorConfig.at( $index, $value ) -> None
```

### VectorOfShared_ptrExecutorConfig::clear

```cpp
void VectorOfShared_ptrExecutorConfig::clear();
AutoIt:
    $oVectorOfShared_ptrExecutorConfig.clear() -> None
```

### VectorOfShared_ptrExecutorConfig::empty

```cpp
bool VectorOfShared_ptrExecutorConfig::empty();
AutoIt:
    $oVectorOfShared_ptrExecutorConfig.empty() -> retval
```

### VectorOfShared_ptrExecutorConfig::end

```cpp
void* VectorOfShared_ptrExecutorConfig::end();
AutoIt:
    $oVectorOfShared_ptrExecutorConfig.end() -> retval
```

### VectorOfShared_ptrExecutorConfig::get_Item

```cpp
std::shared_ptr<mediapipe::ExecutorConfig> VectorOfShared_ptrExecutorConfig::get_Item( size_t vIndex );
AutoIt:
    $oVectorOfShared_ptrExecutorConfig.Item( $vIndex ) -> retval
    $oVectorOfShared_ptrExecutorConfig( $vIndex ) -> retval
```

### VectorOfShared_ptrExecutorConfig::get__NewEnum

```cpp
IUnknown* VectorOfShared_ptrExecutorConfig::get__NewEnum();
AutoIt:
    $oVectorOfShared_ptrExecutorConfig._NewEnum() -> retval
```

### VectorOfShared_ptrExecutorConfig::push_back

```cpp
void VectorOfShared_ptrExecutorConfig::push_back( std::shared_ptr<mediapipe::ExecutorConfig> value );
AutoIt:
    $oVectorOfShared_ptrExecutorConfig.push_back( $value ) -> None
```

### VectorOfShared_ptrExecutorConfig::push_vector

```cpp
void VectorOfShared_ptrExecutorConfig::push_vector( VectorOfShared_ptrExecutorConfig other );
AutoIt:
    $oVectorOfShared_ptrExecutorConfig.push_vector( $other ) -> None
```

```cpp
void VectorOfShared_ptrExecutorConfig::push_vector( VectorOfShared_ptrExecutorConfig other,
                                                    size_t                           count,
                                                    size_t                           start = 0 );
AutoIt:
    $oVectorOfShared_ptrExecutorConfig.push_vector( $other, $count[, $start] ) -> None
```

### VectorOfShared_ptrExecutorConfig::put_Item

```cpp
void VectorOfShared_ptrExecutorConfig::put_Item( size_t                                     vIndex,
                                                 std::shared_ptr<mediapipe::ExecutorConfig> vItem );
AutoIt:
    $oVectorOfShared_ptrExecutorConfig.Item( $vIndex ) = $vItem
```

### VectorOfShared_ptrExecutorConfig::size

```cpp
size_t VectorOfShared_ptrExecutorConfig::size();
AutoIt:
    $oVectorOfShared_ptrExecutorConfig.size() -> retval
```

### VectorOfShared_ptrExecutorConfig::slice

```cpp
VectorOfShared_ptrExecutorConfig VectorOfShared_ptrExecutorConfig::slice( size_t start = 0,
                                                                          size_t count = __self->get()->size() );
AutoIt:
    $oVectorOfShared_ptrExecutorConfig.slice( [$start[, $count]] ) -> retval
```

### VectorOfShared_ptrExecutorConfig::sort

```cpp
void VectorOfShared_ptrExecutorConfig::sort( void*  comparator,
                                             size_t start = 0,
                                             size_t count = __self->get()->size() );
AutoIt:
    $oVectorOfShared_ptrExecutorConfig.sort( $comparator[, $start[, $count]] ) -> None
```

### VectorOfShared_ptrExecutorConfig::sort_variant

```cpp
void VectorOfShared_ptrExecutorConfig::sort_variant( void*  comparator,
                                                     size_t start = 0,
                                                     size_t count = __self->get()->size() );
AutoIt:
    $oVectorOfShared_ptrExecutorConfig.sort_variant( $comparator[, $start[, $count]] ) -> None
```

### VectorOfShared_ptrExecutorConfig::start

```cpp
void* VectorOfShared_ptrExecutorConfig::start();
AutoIt:
    $oVectorOfShared_ptrExecutorConfig.start() -> retval
```

## VectorOfShared_ptrAny

### VectorOfShared_ptrAny::create

```cpp
static VectorOfShared_ptrAny VectorOfShared_ptrAny::create();
AutoIt:
    _Mediapipe_ObjCreate("VectorOfShared_ptrAny").create() -> <VectorOfShared_ptrAny object>
```

```cpp
static VectorOfShared_ptrAny VectorOfShared_ptrAny::create( size_t size );
AutoIt:
    _Mediapipe_ObjCreate("VectorOfShared_ptrAny").create( $size ) -> <VectorOfShared_ptrAny object>
```

```cpp
static VectorOfShared_ptrAny VectorOfShared_ptrAny::create( VectorOfShared_ptrAny other );
AutoIt:
    _Mediapipe_ObjCreate("VectorOfShared_ptrAny").create( $other ) -> <VectorOfShared_ptrAny object>
```

### VectorOfShared_ptrAny::Add

```cpp
void VectorOfShared_ptrAny::Add( std::shared_ptr<google::protobuf::Any> value );
AutoIt:
    $oVectorOfShared_ptrAny.Add( $value ) -> None
```

### VectorOfShared_ptrAny::Items

```cpp
VectorOfShared_ptrAny VectorOfShared_ptrAny::Items();
AutoIt:
    $oVectorOfShared_ptrAny.Items() -> retval
```

### VectorOfShared_ptrAny::Keys

```cpp
std::vector<int> VectorOfShared_ptrAny::Keys();
AutoIt:
    $oVectorOfShared_ptrAny.Keys() -> retval
```

### VectorOfShared_ptrAny::Remove

```cpp
void VectorOfShared_ptrAny::Remove( size_t index );
AutoIt:
    $oVectorOfShared_ptrAny.Remove( $index ) -> None
```

### VectorOfShared_ptrAny::at

```cpp
std::shared_ptr<google::protobuf::Any> VectorOfShared_ptrAny::at( size_t index );
AutoIt:
    $oVectorOfShared_ptrAny.at( $index ) -> retval
```

```cpp
void VectorOfShared_ptrAny::at( size_t                                 index,
                                std::shared_ptr<google::protobuf::Any> value );
AutoIt:
    $oVectorOfShared_ptrAny.at( $index, $value ) -> None
```

### VectorOfShared_ptrAny::clear

```cpp
void VectorOfShared_ptrAny::clear();
AutoIt:
    $oVectorOfShared_ptrAny.clear() -> None
```

### VectorOfShared_ptrAny::empty

```cpp
bool VectorOfShared_ptrAny::empty();
AutoIt:
    $oVectorOfShared_ptrAny.empty() -> retval
```

### VectorOfShared_ptrAny::end

```cpp
void* VectorOfShared_ptrAny::end();
AutoIt:
    $oVectorOfShared_ptrAny.end() -> retval
```

### VectorOfShared_ptrAny::get_Item

```cpp
std::shared_ptr<google::protobuf::Any> VectorOfShared_ptrAny::get_Item( size_t vIndex );
AutoIt:
    $oVectorOfShared_ptrAny.Item( $vIndex ) -> retval
    $oVectorOfShared_ptrAny( $vIndex ) -> retval
```

### VectorOfShared_ptrAny::get__NewEnum

```cpp
IUnknown* VectorOfShared_ptrAny::get__NewEnum();
AutoIt:
    $oVectorOfShared_ptrAny._NewEnum() -> retval
```

### VectorOfShared_ptrAny::push_back

```cpp
void VectorOfShared_ptrAny::push_back( std::shared_ptr<google::protobuf::Any> value );
AutoIt:
    $oVectorOfShared_ptrAny.push_back( $value ) -> None
```

### VectorOfShared_ptrAny::push_vector

```cpp
void VectorOfShared_ptrAny::push_vector( VectorOfShared_ptrAny other );
AutoIt:
    $oVectorOfShared_ptrAny.push_vector( $other ) -> None
```

```cpp
void VectorOfShared_ptrAny::push_vector( VectorOfShared_ptrAny other,
                                         size_t                count,
                                         size_t                start = 0 );
AutoIt:
    $oVectorOfShared_ptrAny.push_vector( $other, $count[, $start] ) -> None
```

### VectorOfShared_ptrAny::put_Item

```cpp
void VectorOfShared_ptrAny::put_Item( size_t                                 vIndex,
                                      std::shared_ptr<google::protobuf::Any> vItem );
AutoIt:
    $oVectorOfShared_ptrAny.Item( $vIndex ) = $vItem
```

### VectorOfShared_ptrAny::size

```cpp
size_t VectorOfShared_ptrAny::size();
AutoIt:
    $oVectorOfShared_ptrAny.size() -> retval
```

### VectorOfShared_ptrAny::slice

```cpp
VectorOfShared_ptrAny VectorOfShared_ptrAny::slice( size_t start = 0,
                                                    size_t count = __self->get()->size() );
AutoIt:
    $oVectorOfShared_ptrAny.slice( [$start[, $count]] ) -> retval
```

### VectorOfShared_ptrAny::sort

```cpp
void VectorOfShared_ptrAny::sort( void*  comparator,
                                  size_t start = 0,
                                  size_t count = __self->get()->size() );
AutoIt:
    $oVectorOfShared_ptrAny.sort( $comparator[, $start[, $count]] ) -> None
```

### VectorOfShared_ptrAny::sort_variant

```cpp
void VectorOfShared_ptrAny::sort_variant( void*  comparator,
                                          size_t start = 0,
                                          size_t count = __self->get()->size() );
AutoIt:
    $oVectorOfShared_ptrAny.sort_variant( $comparator[, $start[, $count]] ) -> None
```

### VectorOfShared_ptrAny::start

```cpp
void* VectorOfShared_ptrAny::start();
AutoIt:
    $oVectorOfShared_ptrAny.start() -> retval
```

## VectorOfShared_ptrInputStreamInfo

### VectorOfShared_ptrInputStreamInfo::create

```cpp
static VectorOfShared_ptrInputStreamInfo VectorOfShared_ptrInputStreamInfo::create();
AutoIt:
    _Mediapipe_ObjCreate("VectorOfShared_ptrInputStreamInfo").create() -> <VectorOfShared_ptrInputStreamInfo object>
```

```cpp
static VectorOfShared_ptrInputStreamInfo VectorOfShared_ptrInputStreamInfo::create( size_t size );
AutoIt:
    _Mediapipe_ObjCreate("VectorOfShared_ptrInputStreamInfo").create( $size ) -> <VectorOfShared_ptrInputStreamInfo object>
```

```cpp
static VectorOfShared_ptrInputStreamInfo VectorOfShared_ptrInputStreamInfo::create( VectorOfShared_ptrInputStreamInfo other );
AutoIt:
    _Mediapipe_ObjCreate("VectorOfShared_ptrInputStreamInfo").create( $other ) -> <VectorOfShared_ptrInputStreamInfo object>
```

### VectorOfShared_ptrInputStreamInfo::Add

```cpp
void VectorOfShared_ptrInputStreamInfo::Add( std::shared_ptr<mediapipe::InputStreamInfo> value );
AutoIt:
    $oVectorOfShared_ptrInputStreamInfo.Add( $value ) -> None
```

### VectorOfShared_ptrInputStreamInfo::Items

```cpp
VectorOfShared_ptrInputStreamInfo VectorOfShared_ptrInputStreamInfo::Items();
AutoIt:
    $oVectorOfShared_ptrInputStreamInfo.Items() -> retval
```

### VectorOfShared_ptrInputStreamInfo::Keys

```cpp
std::vector<int> VectorOfShared_ptrInputStreamInfo::Keys();
AutoIt:
    $oVectorOfShared_ptrInputStreamInfo.Keys() -> retval
```

### VectorOfShared_ptrInputStreamInfo::Remove

```cpp
void VectorOfShared_ptrInputStreamInfo::Remove( size_t index );
AutoIt:
    $oVectorOfShared_ptrInputStreamInfo.Remove( $index ) -> None
```

### VectorOfShared_ptrInputStreamInfo::at

```cpp
std::shared_ptr<mediapipe::InputStreamInfo> VectorOfShared_ptrInputStreamInfo::at( size_t index );
AutoIt:
    $oVectorOfShared_ptrInputStreamInfo.at( $index ) -> retval
```

```cpp
void VectorOfShared_ptrInputStreamInfo::at( size_t                                      index,
                                            std::shared_ptr<mediapipe::InputStreamInfo> value );
AutoIt:
    $oVectorOfShared_ptrInputStreamInfo.at( $index, $value ) -> None
```

### VectorOfShared_ptrInputStreamInfo::clear

```cpp
void VectorOfShared_ptrInputStreamInfo::clear();
AutoIt:
    $oVectorOfShared_ptrInputStreamInfo.clear() -> None
```

### VectorOfShared_ptrInputStreamInfo::empty

```cpp
bool VectorOfShared_ptrInputStreamInfo::empty();
AutoIt:
    $oVectorOfShared_ptrInputStreamInfo.empty() -> retval
```

### VectorOfShared_ptrInputStreamInfo::end

```cpp
void* VectorOfShared_ptrInputStreamInfo::end();
AutoIt:
    $oVectorOfShared_ptrInputStreamInfo.end() -> retval
```

### VectorOfShared_ptrInputStreamInfo::get_Item

```cpp
std::shared_ptr<mediapipe::InputStreamInfo> VectorOfShared_ptrInputStreamInfo::get_Item( size_t vIndex );
AutoIt:
    $oVectorOfShared_ptrInputStreamInfo.Item( $vIndex ) -> retval
    $oVectorOfShared_ptrInputStreamInfo( $vIndex ) -> retval
```

### VectorOfShared_ptrInputStreamInfo::get__NewEnum

```cpp
IUnknown* VectorOfShared_ptrInputStreamInfo::get__NewEnum();
AutoIt:
    $oVectorOfShared_ptrInputStreamInfo._NewEnum() -> retval
```

### VectorOfShared_ptrInputStreamInfo::push_back

```cpp
void VectorOfShared_ptrInputStreamInfo::push_back( std::shared_ptr<mediapipe::InputStreamInfo> value );
AutoIt:
    $oVectorOfShared_ptrInputStreamInfo.push_back( $value ) -> None
```

### VectorOfShared_ptrInputStreamInfo::push_vector

```cpp
void VectorOfShared_ptrInputStreamInfo::push_vector( VectorOfShared_ptrInputStreamInfo other );
AutoIt:
    $oVectorOfShared_ptrInputStreamInfo.push_vector( $other ) -> None
```

```cpp
void VectorOfShared_ptrInputStreamInfo::push_vector( VectorOfShared_ptrInputStreamInfo other,
                                                     size_t                            count,
                                                     size_t                            start = 0 );
AutoIt:
    $oVectorOfShared_ptrInputStreamInfo.push_vector( $other, $count[, $start] ) -> None
```

### VectorOfShared_ptrInputStreamInfo::put_Item

```cpp
void VectorOfShared_ptrInputStreamInfo::put_Item( size_t                                      vIndex,
                                                  std::shared_ptr<mediapipe::InputStreamInfo> vItem );
AutoIt:
    $oVectorOfShared_ptrInputStreamInfo.Item( $vIndex ) = $vItem
```

### VectorOfShared_ptrInputStreamInfo::size

```cpp
size_t VectorOfShared_ptrInputStreamInfo::size();
AutoIt:
    $oVectorOfShared_ptrInputStreamInfo.size() -> retval
```

### VectorOfShared_ptrInputStreamInfo::slice

```cpp
VectorOfShared_ptrInputStreamInfo VectorOfShared_ptrInputStreamInfo::slice( size_t start = 0,
                                                                            size_t count = __self->get()->size() );
AutoIt:
    $oVectorOfShared_ptrInputStreamInfo.slice( [$start[, $count]] ) -> retval
```

### VectorOfShared_ptrInputStreamInfo::sort

```cpp
void VectorOfShared_ptrInputStreamInfo::sort( void*  comparator,
                                              size_t start = 0,
                                              size_t count = __self->get()->size() );
AutoIt:
    $oVectorOfShared_ptrInputStreamInfo.sort( $comparator[, $start[, $count]] ) -> None
```

### VectorOfShared_ptrInputStreamInfo::sort_variant

```cpp
void VectorOfShared_ptrInputStreamInfo::sort_variant( void*  comparator,
                                                      size_t start = 0,
                                                      size_t count = __self->get()->size() );
AutoIt:
    $oVectorOfShared_ptrInputStreamInfo.sort_variant( $comparator[, $start[, $count]] ) -> None
```

### VectorOfShared_ptrInputStreamInfo::start

```cpp
void* VectorOfShared_ptrInputStreamInfo::start();
AutoIt:
    $oVectorOfShared_ptrInputStreamInfo.start() -> retval
```

## VectorOfShared_ptrInterval

### VectorOfShared_ptrInterval::create

```cpp
static VectorOfShared_ptrInterval VectorOfShared_ptrInterval::create();
AutoIt:
    _Mediapipe_ObjCreate("VectorOfShared_ptrInterval").create() -> <VectorOfShared_ptrInterval object>
```

```cpp
static VectorOfShared_ptrInterval VectorOfShared_ptrInterval::create( size_t size );
AutoIt:
    _Mediapipe_ObjCreate("VectorOfShared_ptrInterval").create( $size ) -> <VectorOfShared_ptrInterval object>
```

```cpp
static VectorOfShared_ptrInterval VectorOfShared_ptrInterval::create( VectorOfShared_ptrInterval other );
AutoIt:
    _Mediapipe_ObjCreate("VectorOfShared_ptrInterval").create( $other ) -> <VectorOfShared_ptrInterval object>
```

### VectorOfShared_ptrInterval::Add

```cpp
void VectorOfShared_ptrInterval::Add( std::shared_ptr<mediapipe::Rasterization::Interval> value );
AutoIt:
    $oVectorOfShared_ptrInterval.Add( $value ) -> None
```

### VectorOfShared_ptrInterval::Items

```cpp
VectorOfShared_ptrInterval VectorOfShared_ptrInterval::Items();
AutoIt:
    $oVectorOfShared_ptrInterval.Items() -> retval
```

### VectorOfShared_ptrInterval::Keys

```cpp
std::vector<int> VectorOfShared_ptrInterval::Keys();
AutoIt:
    $oVectorOfShared_ptrInterval.Keys() -> retval
```

### VectorOfShared_ptrInterval::Remove

```cpp
void VectorOfShared_ptrInterval::Remove( size_t index );
AutoIt:
    $oVectorOfShared_ptrInterval.Remove( $index ) -> None
```

### VectorOfShared_ptrInterval::at

```cpp
std::shared_ptr<mediapipe::Rasterization::Interval> VectorOfShared_ptrInterval::at( size_t index );
AutoIt:
    $oVectorOfShared_ptrInterval.at( $index ) -> retval
```

```cpp
void VectorOfShared_ptrInterval::at( size_t                                              index,
                                     std::shared_ptr<mediapipe::Rasterization::Interval> value );
AutoIt:
    $oVectorOfShared_ptrInterval.at( $index, $value ) -> None
```

### VectorOfShared_ptrInterval::clear

```cpp
void VectorOfShared_ptrInterval::clear();
AutoIt:
    $oVectorOfShared_ptrInterval.clear() -> None
```

### VectorOfShared_ptrInterval::empty

```cpp
bool VectorOfShared_ptrInterval::empty();
AutoIt:
    $oVectorOfShared_ptrInterval.empty() -> retval
```

### VectorOfShared_ptrInterval::end

```cpp
void* VectorOfShared_ptrInterval::end();
AutoIt:
    $oVectorOfShared_ptrInterval.end() -> retval
```

### VectorOfShared_ptrInterval::get_Item

```cpp
std::shared_ptr<mediapipe::Rasterization::Interval> VectorOfShared_ptrInterval::get_Item( size_t vIndex );
AutoIt:
    $oVectorOfShared_ptrInterval.Item( $vIndex ) -> retval
    $oVectorOfShared_ptrInterval( $vIndex ) -> retval
```

### VectorOfShared_ptrInterval::get__NewEnum

```cpp
IUnknown* VectorOfShared_ptrInterval::get__NewEnum();
AutoIt:
    $oVectorOfShared_ptrInterval._NewEnum() -> retval
```

### VectorOfShared_ptrInterval::push_back

```cpp
void VectorOfShared_ptrInterval::push_back( std::shared_ptr<mediapipe::Rasterization::Interval> value );
AutoIt:
    $oVectorOfShared_ptrInterval.push_back( $value ) -> None
```

### VectorOfShared_ptrInterval::push_vector

```cpp
void VectorOfShared_ptrInterval::push_vector( VectorOfShared_ptrInterval other );
AutoIt:
    $oVectorOfShared_ptrInterval.push_vector( $other ) -> None
```

```cpp
void VectorOfShared_ptrInterval::push_vector( VectorOfShared_ptrInterval other,
                                              size_t                     count,
                                              size_t                     start = 0 );
AutoIt:
    $oVectorOfShared_ptrInterval.push_vector( $other, $count[, $start] ) -> None
```

### VectorOfShared_ptrInterval::put_Item

```cpp
void VectorOfShared_ptrInterval::put_Item( size_t                                              vIndex,
                                           std::shared_ptr<mediapipe::Rasterization::Interval> vItem );
AutoIt:
    $oVectorOfShared_ptrInterval.Item( $vIndex ) = $vItem
```

### VectorOfShared_ptrInterval::size

```cpp
size_t VectorOfShared_ptrInterval::size();
AutoIt:
    $oVectorOfShared_ptrInterval.size() -> retval
```

### VectorOfShared_ptrInterval::slice

```cpp
VectorOfShared_ptrInterval VectorOfShared_ptrInterval::slice( size_t start = 0,
                                                              size_t count = __self->get()->size() );
AutoIt:
    $oVectorOfShared_ptrInterval.slice( [$start[, $count]] ) -> retval
```

### VectorOfShared_ptrInterval::sort

```cpp
void VectorOfShared_ptrInterval::sort( void*  comparator,
                                       size_t start = 0,
                                       size_t count = __self->get()->size() );
AutoIt:
    $oVectorOfShared_ptrInterval.sort( $comparator[, $start[, $count]] ) -> None
```

### VectorOfShared_ptrInterval::sort_variant

```cpp
void VectorOfShared_ptrInterval::sort_variant( void*  comparator,
                                               size_t start = 0,
                                               size_t count = __self->get()->size() );
AutoIt:
    $oVectorOfShared_ptrInterval.sort_variant( $comparator[, $start[, $count]] ) -> None
```

### VectorOfShared_ptrInterval::start

```cpp
void* VectorOfShared_ptrInterval::start();
AutoIt:
    $oVectorOfShared_ptrInterval.start() -> retval
```

## VectorOfShared_ptrRelativeKeypoint

### VectorOfShared_ptrRelativeKeypoint::create

```cpp
static VectorOfShared_ptrRelativeKeypoint VectorOfShared_ptrRelativeKeypoint::create();
AutoIt:
    _Mediapipe_ObjCreate("VectorOfShared_ptrRelativeKeypoint").create() -> <VectorOfShared_ptrRelativeKeypoint object>
```

```cpp
static VectorOfShared_ptrRelativeKeypoint VectorOfShared_ptrRelativeKeypoint::create( size_t size );
AutoIt:
    _Mediapipe_ObjCreate("VectorOfShared_ptrRelativeKeypoint").create( $size ) -> <VectorOfShared_ptrRelativeKeypoint object>
```

```cpp
static VectorOfShared_ptrRelativeKeypoint VectorOfShared_ptrRelativeKeypoint::create( VectorOfShared_ptrRelativeKeypoint other );
AutoIt:
    _Mediapipe_ObjCreate("VectorOfShared_ptrRelativeKeypoint").create( $other ) -> <VectorOfShared_ptrRelativeKeypoint object>
```

### VectorOfShared_ptrRelativeKeypoint::Add

```cpp
void VectorOfShared_ptrRelativeKeypoint::Add( std::shared_ptr<mediapipe::LocationData::RelativeKeypoint> value );
AutoIt:
    $oVectorOfShared_ptrRelativeKeypoint.Add( $value ) -> None
```

### VectorOfShared_ptrRelativeKeypoint::Items

```cpp
VectorOfShared_ptrRelativeKeypoint VectorOfShared_ptrRelativeKeypoint::Items();
AutoIt:
    $oVectorOfShared_ptrRelativeKeypoint.Items() -> retval
```

### VectorOfShared_ptrRelativeKeypoint::Keys

```cpp
std::vector<int> VectorOfShared_ptrRelativeKeypoint::Keys();
AutoIt:
    $oVectorOfShared_ptrRelativeKeypoint.Keys() -> retval
```

### VectorOfShared_ptrRelativeKeypoint::Remove

```cpp
void VectorOfShared_ptrRelativeKeypoint::Remove( size_t index );
AutoIt:
    $oVectorOfShared_ptrRelativeKeypoint.Remove( $index ) -> None
```

### VectorOfShared_ptrRelativeKeypoint::at

```cpp
std::shared_ptr<mediapipe::LocationData::RelativeKeypoint> VectorOfShared_ptrRelativeKeypoint::at( size_t index );
AutoIt:
    $oVectorOfShared_ptrRelativeKeypoint.at( $index ) -> retval
```

```cpp
void VectorOfShared_ptrRelativeKeypoint::at( size_t                                                     index,
                                             std::shared_ptr<mediapipe::LocationData::RelativeKeypoint> value );
AutoIt:
    $oVectorOfShared_ptrRelativeKeypoint.at( $index, $value ) -> None
```

### VectorOfShared_ptrRelativeKeypoint::clear

```cpp
void VectorOfShared_ptrRelativeKeypoint::clear();
AutoIt:
    $oVectorOfShared_ptrRelativeKeypoint.clear() -> None
```

### VectorOfShared_ptrRelativeKeypoint::empty

```cpp
bool VectorOfShared_ptrRelativeKeypoint::empty();
AutoIt:
    $oVectorOfShared_ptrRelativeKeypoint.empty() -> retval
```

### VectorOfShared_ptrRelativeKeypoint::end

```cpp
void* VectorOfShared_ptrRelativeKeypoint::end();
AutoIt:
    $oVectorOfShared_ptrRelativeKeypoint.end() -> retval
```

### VectorOfShared_ptrRelativeKeypoint::get_Item

```cpp
std::shared_ptr<mediapipe::LocationData::RelativeKeypoint> VectorOfShared_ptrRelativeKeypoint::get_Item( size_t vIndex );
AutoIt:
    $oVectorOfShared_ptrRelativeKeypoint.Item( $vIndex ) -> retval
    $oVectorOfShared_ptrRelativeKeypoint( $vIndex ) -> retval
```

### VectorOfShared_ptrRelativeKeypoint::get__NewEnum

```cpp
IUnknown* VectorOfShared_ptrRelativeKeypoint::get__NewEnum();
AutoIt:
    $oVectorOfShared_ptrRelativeKeypoint._NewEnum() -> retval
```

### VectorOfShared_ptrRelativeKeypoint::push_back

```cpp
void VectorOfShared_ptrRelativeKeypoint::push_back( std::shared_ptr<mediapipe::LocationData::RelativeKeypoint> value );
AutoIt:
    $oVectorOfShared_ptrRelativeKeypoint.push_back( $value ) -> None
```

### VectorOfShared_ptrRelativeKeypoint::push_vector

```cpp
void VectorOfShared_ptrRelativeKeypoint::push_vector( VectorOfShared_ptrRelativeKeypoint other );
AutoIt:
    $oVectorOfShared_ptrRelativeKeypoint.push_vector( $other ) -> None
```

```cpp
void VectorOfShared_ptrRelativeKeypoint::push_vector( VectorOfShared_ptrRelativeKeypoint other,
                                                      size_t                             count,
                                                      size_t                             start = 0 );
AutoIt:
    $oVectorOfShared_ptrRelativeKeypoint.push_vector( $other, $count[, $start] ) -> None
```

### VectorOfShared_ptrRelativeKeypoint::put_Item

```cpp
void VectorOfShared_ptrRelativeKeypoint::put_Item( size_t                                                     vIndex,
                                                   std::shared_ptr<mediapipe::LocationData::RelativeKeypoint> vItem );
AutoIt:
    $oVectorOfShared_ptrRelativeKeypoint.Item( $vIndex ) = $vItem
```

### VectorOfShared_ptrRelativeKeypoint::size

```cpp
size_t VectorOfShared_ptrRelativeKeypoint::size();
AutoIt:
    $oVectorOfShared_ptrRelativeKeypoint.size() -> retval
```

### VectorOfShared_ptrRelativeKeypoint::slice

```cpp
VectorOfShared_ptrRelativeKeypoint VectorOfShared_ptrRelativeKeypoint::slice( size_t start = 0,
                                                                              size_t count = __self->get()->size() );
AutoIt:
    $oVectorOfShared_ptrRelativeKeypoint.slice( [$start[, $count]] ) -> retval
```

### VectorOfShared_ptrRelativeKeypoint::sort

```cpp
void VectorOfShared_ptrRelativeKeypoint::sort( void*  comparator,
                                               size_t start = 0,
                                               size_t count = __self->get()->size() );
AutoIt:
    $oVectorOfShared_ptrRelativeKeypoint.sort( $comparator[, $start[, $count]] ) -> None
```

### VectorOfShared_ptrRelativeKeypoint::sort_variant

```cpp
void VectorOfShared_ptrRelativeKeypoint::sort_variant( void*  comparator,
                                                       size_t start = 0,
                                                       size_t count = __self->get()->size() );
AutoIt:
    $oVectorOfShared_ptrRelativeKeypoint.sort_variant( $comparator[, $start[, $count]] ) -> None
```

### VectorOfShared_ptrRelativeKeypoint::start

```cpp
void* VectorOfShared_ptrRelativeKeypoint::start();
AutoIt:
    $oVectorOfShared_ptrRelativeKeypoint.start() -> retval
```

## VectorOfShared_ptrAssociatedDetection

### VectorOfShared_ptrAssociatedDetection::create

```cpp
static VectorOfShared_ptrAssociatedDetection VectorOfShared_ptrAssociatedDetection::create();
AutoIt:
    _Mediapipe_ObjCreate("VectorOfShared_ptrAssociatedDetection").create() -> <VectorOfShared_ptrAssociatedDetection object>
```

```cpp
static VectorOfShared_ptrAssociatedDetection VectorOfShared_ptrAssociatedDetection::create( size_t size );
AutoIt:
    _Mediapipe_ObjCreate("VectorOfShared_ptrAssociatedDetection").create( $size ) -> <VectorOfShared_ptrAssociatedDetection object>
```

```cpp
static VectorOfShared_ptrAssociatedDetection VectorOfShared_ptrAssociatedDetection::create( VectorOfShared_ptrAssociatedDetection other );
AutoIt:
    _Mediapipe_ObjCreate("VectorOfShared_ptrAssociatedDetection").create( $other ) -> <VectorOfShared_ptrAssociatedDetection object>
```

### VectorOfShared_ptrAssociatedDetection::Add

```cpp
void VectorOfShared_ptrAssociatedDetection::Add( std::shared_ptr<mediapipe::Detection::AssociatedDetection> value );
AutoIt:
    $oVectorOfShared_ptrAssociatedDetection.Add( $value ) -> None
```

### VectorOfShared_ptrAssociatedDetection::Items

```cpp
VectorOfShared_ptrAssociatedDetection VectorOfShared_ptrAssociatedDetection::Items();
AutoIt:
    $oVectorOfShared_ptrAssociatedDetection.Items() -> retval
```

### VectorOfShared_ptrAssociatedDetection::Keys

```cpp
std::vector<int> VectorOfShared_ptrAssociatedDetection::Keys();
AutoIt:
    $oVectorOfShared_ptrAssociatedDetection.Keys() -> retval
```

### VectorOfShared_ptrAssociatedDetection::Remove

```cpp
void VectorOfShared_ptrAssociatedDetection::Remove( size_t index );
AutoIt:
    $oVectorOfShared_ptrAssociatedDetection.Remove( $index ) -> None
```

### VectorOfShared_ptrAssociatedDetection::at

```cpp
std::shared_ptr<mediapipe::Detection::AssociatedDetection> VectorOfShared_ptrAssociatedDetection::at( size_t index );
AutoIt:
    $oVectorOfShared_ptrAssociatedDetection.at( $index ) -> retval
```

```cpp
void VectorOfShared_ptrAssociatedDetection::at( size_t                                                     index,
                                                std::shared_ptr<mediapipe::Detection::AssociatedDetection> value );
AutoIt:
    $oVectorOfShared_ptrAssociatedDetection.at( $index, $value ) -> None
```

### VectorOfShared_ptrAssociatedDetection::clear

```cpp
void VectorOfShared_ptrAssociatedDetection::clear();
AutoIt:
    $oVectorOfShared_ptrAssociatedDetection.clear() -> None
```

### VectorOfShared_ptrAssociatedDetection::empty

```cpp
bool VectorOfShared_ptrAssociatedDetection::empty();
AutoIt:
    $oVectorOfShared_ptrAssociatedDetection.empty() -> retval
```

### VectorOfShared_ptrAssociatedDetection::end

```cpp
void* VectorOfShared_ptrAssociatedDetection::end();
AutoIt:
    $oVectorOfShared_ptrAssociatedDetection.end() -> retval
```

### VectorOfShared_ptrAssociatedDetection::get_Item

```cpp
std::shared_ptr<mediapipe::Detection::AssociatedDetection> VectorOfShared_ptrAssociatedDetection::get_Item( size_t vIndex );
AutoIt:
    $oVectorOfShared_ptrAssociatedDetection.Item( $vIndex ) -> retval
    $oVectorOfShared_ptrAssociatedDetection( $vIndex ) -> retval
```

### VectorOfShared_ptrAssociatedDetection::get__NewEnum

```cpp
IUnknown* VectorOfShared_ptrAssociatedDetection::get__NewEnum();
AutoIt:
    $oVectorOfShared_ptrAssociatedDetection._NewEnum() -> retval
```

### VectorOfShared_ptrAssociatedDetection::push_back

```cpp
void VectorOfShared_ptrAssociatedDetection::push_back( std::shared_ptr<mediapipe::Detection::AssociatedDetection> value );
AutoIt:
    $oVectorOfShared_ptrAssociatedDetection.push_back( $value ) -> None
```

### VectorOfShared_ptrAssociatedDetection::push_vector

```cpp
void VectorOfShared_ptrAssociatedDetection::push_vector( VectorOfShared_ptrAssociatedDetection other );
AutoIt:
    $oVectorOfShared_ptrAssociatedDetection.push_vector( $other ) -> None
```

```cpp
void VectorOfShared_ptrAssociatedDetection::push_vector( VectorOfShared_ptrAssociatedDetection other,
                                                         size_t                                count,
                                                         size_t                                start = 0 );
AutoIt:
    $oVectorOfShared_ptrAssociatedDetection.push_vector( $other, $count[, $start] ) -> None
```

### VectorOfShared_ptrAssociatedDetection::put_Item

```cpp
void VectorOfShared_ptrAssociatedDetection::put_Item( size_t                                                     vIndex,
                                                      std::shared_ptr<mediapipe::Detection::AssociatedDetection> vItem );
AutoIt:
    $oVectorOfShared_ptrAssociatedDetection.Item( $vIndex ) = $vItem
```

### VectorOfShared_ptrAssociatedDetection::size

```cpp
size_t VectorOfShared_ptrAssociatedDetection::size();
AutoIt:
    $oVectorOfShared_ptrAssociatedDetection.size() -> retval
```

### VectorOfShared_ptrAssociatedDetection::slice

```cpp
VectorOfShared_ptrAssociatedDetection VectorOfShared_ptrAssociatedDetection::slice( size_t start = 0,
                                                                                    size_t count = __self->get()->size() );
AutoIt:
    $oVectorOfShared_ptrAssociatedDetection.slice( [$start[, $count]] ) -> retval
```

### VectorOfShared_ptrAssociatedDetection::sort

```cpp
void VectorOfShared_ptrAssociatedDetection::sort( void*  comparator,
                                                  size_t start = 0,
                                                  size_t count = __self->get()->size() );
AutoIt:
    $oVectorOfShared_ptrAssociatedDetection.sort( $comparator[, $start[, $count]] ) -> None
```

### VectorOfShared_ptrAssociatedDetection::sort_variant

```cpp
void VectorOfShared_ptrAssociatedDetection::sort_variant( void*  comparator,
                                                          size_t start = 0,
                                                          size_t count = __self->get()->size() );
AutoIt:
    $oVectorOfShared_ptrAssociatedDetection.sort_variant( $comparator[, $start[, $count]] ) -> None
```

### VectorOfShared_ptrAssociatedDetection::start

```cpp
void* VectorOfShared_ptrAssociatedDetection::start();
AutoIt:
    $oVectorOfShared_ptrAssociatedDetection.start() -> retval
```

## VectorOfShared_ptrDetection

### VectorOfShared_ptrDetection::create

```cpp
static VectorOfShared_ptrDetection VectorOfShared_ptrDetection::create();
AutoIt:
    _Mediapipe_ObjCreate("VectorOfShared_ptrDetection").create() -> <VectorOfShared_ptrDetection object>
```

```cpp
static VectorOfShared_ptrDetection VectorOfShared_ptrDetection::create( size_t size );
AutoIt:
    _Mediapipe_ObjCreate("VectorOfShared_ptrDetection").create( $size ) -> <VectorOfShared_ptrDetection object>
```

```cpp
static VectorOfShared_ptrDetection VectorOfShared_ptrDetection::create( VectorOfShared_ptrDetection other );
AutoIt:
    _Mediapipe_ObjCreate("VectorOfShared_ptrDetection").create( $other ) -> <VectorOfShared_ptrDetection object>
```

### VectorOfShared_ptrDetection::Add

```cpp
void VectorOfShared_ptrDetection::Add( std::shared_ptr<mediapipe::Detection> value );
AutoIt:
    $oVectorOfShared_ptrDetection.Add( $value ) -> None
```

### VectorOfShared_ptrDetection::Items

```cpp
VectorOfShared_ptrDetection VectorOfShared_ptrDetection::Items();
AutoIt:
    $oVectorOfShared_ptrDetection.Items() -> retval
```

### VectorOfShared_ptrDetection::Keys

```cpp
std::vector<int> VectorOfShared_ptrDetection::Keys();
AutoIt:
    $oVectorOfShared_ptrDetection.Keys() -> retval
```

### VectorOfShared_ptrDetection::Remove

```cpp
void VectorOfShared_ptrDetection::Remove( size_t index );
AutoIt:
    $oVectorOfShared_ptrDetection.Remove( $index ) -> None
```

### VectorOfShared_ptrDetection::at

```cpp
std::shared_ptr<mediapipe::Detection> VectorOfShared_ptrDetection::at( size_t index );
AutoIt:
    $oVectorOfShared_ptrDetection.at( $index ) -> retval
```

```cpp
void VectorOfShared_ptrDetection::at( size_t                                index,
                                      std::shared_ptr<mediapipe::Detection> value );
AutoIt:
    $oVectorOfShared_ptrDetection.at( $index, $value ) -> None
```

### VectorOfShared_ptrDetection::clear

```cpp
void VectorOfShared_ptrDetection::clear();
AutoIt:
    $oVectorOfShared_ptrDetection.clear() -> None
```

### VectorOfShared_ptrDetection::empty

```cpp
bool VectorOfShared_ptrDetection::empty();
AutoIt:
    $oVectorOfShared_ptrDetection.empty() -> retval
```

### VectorOfShared_ptrDetection::end

```cpp
void* VectorOfShared_ptrDetection::end();
AutoIt:
    $oVectorOfShared_ptrDetection.end() -> retval
```

### VectorOfShared_ptrDetection::get_Item

```cpp
std::shared_ptr<mediapipe::Detection> VectorOfShared_ptrDetection::get_Item( size_t vIndex );
AutoIt:
    $oVectorOfShared_ptrDetection.Item( $vIndex ) -> retval
    $oVectorOfShared_ptrDetection( $vIndex ) -> retval
```

### VectorOfShared_ptrDetection::get__NewEnum

```cpp
IUnknown* VectorOfShared_ptrDetection::get__NewEnum();
AutoIt:
    $oVectorOfShared_ptrDetection._NewEnum() -> retval
```

### VectorOfShared_ptrDetection::push_back

```cpp
void VectorOfShared_ptrDetection::push_back( std::shared_ptr<mediapipe::Detection> value );
AutoIt:
    $oVectorOfShared_ptrDetection.push_back( $value ) -> None
```

### VectorOfShared_ptrDetection::push_vector

```cpp
void VectorOfShared_ptrDetection::push_vector( VectorOfShared_ptrDetection other );
AutoIt:
    $oVectorOfShared_ptrDetection.push_vector( $other ) -> None
```

```cpp
void VectorOfShared_ptrDetection::push_vector( VectorOfShared_ptrDetection other,
                                               size_t                      count,
                                               size_t                      start = 0 );
AutoIt:
    $oVectorOfShared_ptrDetection.push_vector( $other, $count[, $start] ) -> None
```

### VectorOfShared_ptrDetection::put_Item

```cpp
void VectorOfShared_ptrDetection::put_Item( size_t                                vIndex,
                                            std::shared_ptr<mediapipe::Detection> vItem );
AutoIt:
    $oVectorOfShared_ptrDetection.Item( $vIndex ) = $vItem
```

### VectorOfShared_ptrDetection::size

```cpp
size_t VectorOfShared_ptrDetection::size();
AutoIt:
    $oVectorOfShared_ptrDetection.size() -> retval
```

### VectorOfShared_ptrDetection::slice

```cpp
VectorOfShared_ptrDetection VectorOfShared_ptrDetection::slice( size_t start = 0,
                                                                size_t count = __self->get()->size() );
AutoIt:
    $oVectorOfShared_ptrDetection.slice( [$start[, $count]] ) -> retval
```

### VectorOfShared_ptrDetection::sort

```cpp
void VectorOfShared_ptrDetection::sort( void*  comparator,
                                        size_t start = 0,
                                        size_t count = __self->get()->size() );
AutoIt:
    $oVectorOfShared_ptrDetection.sort( $comparator[, $start[, $count]] ) -> None
```

### VectorOfShared_ptrDetection::sort_variant

```cpp
void VectorOfShared_ptrDetection::sort_variant( void*  comparator,
                                                size_t start = 0,
                                                size_t count = __self->get()->size() );
AutoIt:
    $oVectorOfShared_ptrDetection.sort_variant( $comparator[, $start[, $count]] ) -> None
```

### VectorOfShared_ptrDetection::start

```cpp
void* VectorOfShared_ptrDetection::start();
AutoIt:
    $oVectorOfShared_ptrDetection.start() -> retval
```

## VectorOfShared_ptrClassification

### VectorOfShared_ptrClassification::create

```cpp
static VectorOfShared_ptrClassification VectorOfShared_ptrClassification::create();
AutoIt:
    _Mediapipe_ObjCreate("VectorOfShared_ptrClassification").create() -> <VectorOfShared_ptrClassification object>
```

```cpp
static VectorOfShared_ptrClassification VectorOfShared_ptrClassification::create( size_t size );
AutoIt:
    _Mediapipe_ObjCreate("VectorOfShared_ptrClassification").create( $size ) -> <VectorOfShared_ptrClassification object>
```

```cpp
static VectorOfShared_ptrClassification VectorOfShared_ptrClassification::create( VectorOfShared_ptrClassification other );
AutoIt:
    _Mediapipe_ObjCreate("VectorOfShared_ptrClassification").create( $other ) -> <VectorOfShared_ptrClassification object>
```

### VectorOfShared_ptrClassification::Add

```cpp
void VectorOfShared_ptrClassification::Add( std::shared_ptr<mediapipe::Classification> value );
AutoIt:
    $oVectorOfShared_ptrClassification.Add( $value ) -> None
```

### VectorOfShared_ptrClassification::Items

```cpp
VectorOfShared_ptrClassification VectorOfShared_ptrClassification::Items();
AutoIt:
    $oVectorOfShared_ptrClassification.Items() -> retval
```

### VectorOfShared_ptrClassification::Keys

```cpp
std::vector<int> VectorOfShared_ptrClassification::Keys();
AutoIt:
    $oVectorOfShared_ptrClassification.Keys() -> retval
```

### VectorOfShared_ptrClassification::Remove

```cpp
void VectorOfShared_ptrClassification::Remove( size_t index );
AutoIt:
    $oVectorOfShared_ptrClassification.Remove( $index ) -> None
```

### VectorOfShared_ptrClassification::at

```cpp
std::shared_ptr<mediapipe::Classification> VectorOfShared_ptrClassification::at( size_t index );
AutoIt:
    $oVectorOfShared_ptrClassification.at( $index ) -> retval
```

```cpp
void VectorOfShared_ptrClassification::at( size_t                                     index,
                                           std::shared_ptr<mediapipe::Classification> value );
AutoIt:
    $oVectorOfShared_ptrClassification.at( $index, $value ) -> None
```

### VectorOfShared_ptrClassification::clear

```cpp
void VectorOfShared_ptrClassification::clear();
AutoIt:
    $oVectorOfShared_ptrClassification.clear() -> None
```

### VectorOfShared_ptrClassification::empty

```cpp
bool VectorOfShared_ptrClassification::empty();
AutoIt:
    $oVectorOfShared_ptrClassification.empty() -> retval
```

### VectorOfShared_ptrClassification::end

```cpp
void* VectorOfShared_ptrClassification::end();
AutoIt:
    $oVectorOfShared_ptrClassification.end() -> retval
```

### VectorOfShared_ptrClassification::get_Item

```cpp
std::shared_ptr<mediapipe::Classification> VectorOfShared_ptrClassification::get_Item( size_t vIndex );
AutoIt:
    $oVectorOfShared_ptrClassification.Item( $vIndex ) -> retval
    $oVectorOfShared_ptrClassification( $vIndex ) -> retval
```

### VectorOfShared_ptrClassification::get__NewEnum

```cpp
IUnknown* VectorOfShared_ptrClassification::get__NewEnum();
AutoIt:
    $oVectorOfShared_ptrClassification._NewEnum() -> retval
```

### VectorOfShared_ptrClassification::push_back

```cpp
void VectorOfShared_ptrClassification::push_back( std::shared_ptr<mediapipe::Classification> value );
AutoIt:
    $oVectorOfShared_ptrClassification.push_back( $value ) -> None
```

### VectorOfShared_ptrClassification::push_vector

```cpp
void VectorOfShared_ptrClassification::push_vector( VectorOfShared_ptrClassification other );
AutoIt:
    $oVectorOfShared_ptrClassification.push_vector( $other ) -> None
```

```cpp
void VectorOfShared_ptrClassification::push_vector( VectorOfShared_ptrClassification other,
                                                    size_t                           count,
                                                    size_t                           start = 0 );
AutoIt:
    $oVectorOfShared_ptrClassification.push_vector( $other, $count[, $start] ) -> None
```

### VectorOfShared_ptrClassification::put_Item

```cpp
void VectorOfShared_ptrClassification::put_Item( size_t                                     vIndex,
                                                 std::shared_ptr<mediapipe::Classification> vItem );
AutoIt:
    $oVectorOfShared_ptrClassification.Item( $vIndex ) = $vItem
```

### VectorOfShared_ptrClassification::size

```cpp
size_t VectorOfShared_ptrClassification::size();
AutoIt:
    $oVectorOfShared_ptrClassification.size() -> retval
```

### VectorOfShared_ptrClassification::slice

```cpp
VectorOfShared_ptrClassification VectorOfShared_ptrClassification::slice( size_t start = 0,
                                                                          size_t count = __self->get()->size() );
AutoIt:
    $oVectorOfShared_ptrClassification.slice( [$start[, $count]] ) -> retval
```

### VectorOfShared_ptrClassification::sort

```cpp
void VectorOfShared_ptrClassification::sort( void*  comparator,
                                             size_t start = 0,
                                             size_t count = __self->get()->size() );
AutoIt:
    $oVectorOfShared_ptrClassification.sort( $comparator[, $start[, $count]] ) -> None
```

### VectorOfShared_ptrClassification::sort_variant

```cpp
void VectorOfShared_ptrClassification::sort_variant( void*  comparator,
                                                     size_t start = 0,
                                                     size_t count = __self->get()->size() );
AutoIt:
    $oVectorOfShared_ptrClassification.sort_variant( $comparator[, $start[, $count]] ) -> None
```

### VectorOfShared_ptrClassification::start

```cpp
void* VectorOfShared_ptrClassification::start();
AutoIt:
    $oVectorOfShared_ptrClassification.start() -> retval
```

## VectorOfShared_ptrClassificationList

### VectorOfShared_ptrClassificationList::create

```cpp
static VectorOfShared_ptrClassificationList VectorOfShared_ptrClassificationList::create();
AutoIt:
    _Mediapipe_ObjCreate("VectorOfShared_ptrClassificationList").create() -> <VectorOfShared_ptrClassificationList object>
```

```cpp
static VectorOfShared_ptrClassificationList VectorOfShared_ptrClassificationList::create( size_t size );
AutoIt:
    _Mediapipe_ObjCreate("VectorOfShared_ptrClassificationList").create( $size ) -> <VectorOfShared_ptrClassificationList object>
```

```cpp
static VectorOfShared_ptrClassificationList VectorOfShared_ptrClassificationList::create( VectorOfShared_ptrClassificationList other );
AutoIt:
    _Mediapipe_ObjCreate("VectorOfShared_ptrClassificationList").create( $other ) -> <VectorOfShared_ptrClassificationList object>
```

### VectorOfShared_ptrClassificationList::Add

```cpp
void VectorOfShared_ptrClassificationList::Add( std::shared_ptr<mediapipe::ClassificationList> value );
AutoIt:
    $oVectorOfShared_ptrClassificationList.Add( $value ) -> None
```

### VectorOfShared_ptrClassificationList::Items

```cpp
VectorOfShared_ptrClassificationList VectorOfShared_ptrClassificationList::Items();
AutoIt:
    $oVectorOfShared_ptrClassificationList.Items() -> retval
```

### VectorOfShared_ptrClassificationList::Keys

```cpp
std::vector<int> VectorOfShared_ptrClassificationList::Keys();
AutoIt:
    $oVectorOfShared_ptrClassificationList.Keys() -> retval
```

### VectorOfShared_ptrClassificationList::Remove

```cpp
void VectorOfShared_ptrClassificationList::Remove( size_t index );
AutoIt:
    $oVectorOfShared_ptrClassificationList.Remove( $index ) -> None
```

### VectorOfShared_ptrClassificationList::at

```cpp
std::shared_ptr<mediapipe::ClassificationList> VectorOfShared_ptrClassificationList::at( size_t index );
AutoIt:
    $oVectorOfShared_ptrClassificationList.at( $index ) -> retval
```

```cpp
void VectorOfShared_ptrClassificationList::at( size_t                                         index,
                                               std::shared_ptr<mediapipe::ClassificationList> value );
AutoIt:
    $oVectorOfShared_ptrClassificationList.at( $index, $value ) -> None
```

### VectorOfShared_ptrClassificationList::clear

```cpp
void VectorOfShared_ptrClassificationList::clear();
AutoIt:
    $oVectorOfShared_ptrClassificationList.clear() -> None
```

### VectorOfShared_ptrClassificationList::empty

```cpp
bool VectorOfShared_ptrClassificationList::empty();
AutoIt:
    $oVectorOfShared_ptrClassificationList.empty() -> retval
```

### VectorOfShared_ptrClassificationList::end

```cpp
void* VectorOfShared_ptrClassificationList::end();
AutoIt:
    $oVectorOfShared_ptrClassificationList.end() -> retval
```

### VectorOfShared_ptrClassificationList::get_Item

```cpp
std::shared_ptr<mediapipe::ClassificationList> VectorOfShared_ptrClassificationList::get_Item( size_t vIndex );
AutoIt:
    $oVectorOfShared_ptrClassificationList.Item( $vIndex ) -> retval
    $oVectorOfShared_ptrClassificationList( $vIndex ) -> retval
```

### VectorOfShared_ptrClassificationList::get__NewEnum

```cpp
IUnknown* VectorOfShared_ptrClassificationList::get__NewEnum();
AutoIt:
    $oVectorOfShared_ptrClassificationList._NewEnum() -> retval
```

### VectorOfShared_ptrClassificationList::push_back

```cpp
void VectorOfShared_ptrClassificationList::push_back( std::shared_ptr<mediapipe::ClassificationList> value );
AutoIt:
    $oVectorOfShared_ptrClassificationList.push_back( $value ) -> None
```

### VectorOfShared_ptrClassificationList::push_vector

```cpp
void VectorOfShared_ptrClassificationList::push_vector( VectorOfShared_ptrClassificationList other );
AutoIt:
    $oVectorOfShared_ptrClassificationList.push_vector( $other ) -> None
```

```cpp
void VectorOfShared_ptrClassificationList::push_vector( VectorOfShared_ptrClassificationList other,
                                                        size_t                               count,
                                                        size_t                               start = 0 );
AutoIt:
    $oVectorOfShared_ptrClassificationList.push_vector( $other, $count[, $start] ) -> None
```

### VectorOfShared_ptrClassificationList::put_Item

```cpp
void VectorOfShared_ptrClassificationList::put_Item( size_t                                         vIndex,
                                                     std::shared_ptr<mediapipe::ClassificationList> vItem );
AutoIt:
    $oVectorOfShared_ptrClassificationList.Item( $vIndex ) = $vItem
```

### VectorOfShared_ptrClassificationList::size

```cpp
size_t VectorOfShared_ptrClassificationList::size();
AutoIt:
    $oVectorOfShared_ptrClassificationList.size() -> retval
```

### VectorOfShared_ptrClassificationList::slice

```cpp
VectorOfShared_ptrClassificationList VectorOfShared_ptrClassificationList::slice( size_t start = 0,
                                                                                  size_t count = __self->get()->size() );
AutoIt:
    $oVectorOfShared_ptrClassificationList.slice( [$start[, $count]] ) -> retval
```

### VectorOfShared_ptrClassificationList::sort

```cpp
void VectorOfShared_ptrClassificationList::sort( void*  comparator,
                                                 size_t start = 0,
                                                 size_t count = __self->get()->size() );
AutoIt:
    $oVectorOfShared_ptrClassificationList.sort( $comparator[, $start[, $count]] ) -> None
```

### VectorOfShared_ptrClassificationList::sort_variant

```cpp
void VectorOfShared_ptrClassificationList::sort_variant( void*  comparator,
                                                         size_t start = 0,
                                                         size_t count = __self->get()->size() );
AutoIt:
    $oVectorOfShared_ptrClassificationList.sort_variant( $comparator[, $start[, $count]] ) -> None
```

### VectorOfShared_ptrClassificationList::start

```cpp
void* VectorOfShared_ptrClassificationList::start();
AutoIt:
    $oVectorOfShared_ptrClassificationList.start() -> retval
```

## VectorOfShared_ptrLandmark

### VectorOfShared_ptrLandmark::create

```cpp
static VectorOfShared_ptrLandmark VectorOfShared_ptrLandmark::create();
AutoIt:
    _Mediapipe_ObjCreate("VectorOfShared_ptrLandmark").create() -> <VectorOfShared_ptrLandmark object>
```

```cpp
static VectorOfShared_ptrLandmark VectorOfShared_ptrLandmark::create( size_t size );
AutoIt:
    _Mediapipe_ObjCreate("VectorOfShared_ptrLandmark").create( $size ) -> <VectorOfShared_ptrLandmark object>
```

```cpp
static VectorOfShared_ptrLandmark VectorOfShared_ptrLandmark::create( VectorOfShared_ptrLandmark other );
AutoIt:
    _Mediapipe_ObjCreate("VectorOfShared_ptrLandmark").create( $other ) -> <VectorOfShared_ptrLandmark object>
```

### VectorOfShared_ptrLandmark::Add

```cpp
void VectorOfShared_ptrLandmark::Add( std::shared_ptr<mediapipe::Landmark> value );
AutoIt:
    $oVectorOfShared_ptrLandmark.Add( $value ) -> None
```

### VectorOfShared_ptrLandmark::Items

```cpp
VectorOfShared_ptrLandmark VectorOfShared_ptrLandmark::Items();
AutoIt:
    $oVectorOfShared_ptrLandmark.Items() -> retval
```

### VectorOfShared_ptrLandmark::Keys

```cpp
std::vector<int> VectorOfShared_ptrLandmark::Keys();
AutoIt:
    $oVectorOfShared_ptrLandmark.Keys() -> retval
```

### VectorOfShared_ptrLandmark::Remove

```cpp
void VectorOfShared_ptrLandmark::Remove( size_t index );
AutoIt:
    $oVectorOfShared_ptrLandmark.Remove( $index ) -> None
```

### VectorOfShared_ptrLandmark::at

```cpp
std::shared_ptr<mediapipe::Landmark> VectorOfShared_ptrLandmark::at( size_t index );
AutoIt:
    $oVectorOfShared_ptrLandmark.at( $index ) -> retval
```

```cpp
void VectorOfShared_ptrLandmark::at( size_t                               index,
                                     std::shared_ptr<mediapipe::Landmark> value );
AutoIt:
    $oVectorOfShared_ptrLandmark.at( $index, $value ) -> None
```

### VectorOfShared_ptrLandmark::clear

```cpp
void VectorOfShared_ptrLandmark::clear();
AutoIt:
    $oVectorOfShared_ptrLandmark.clear() -> None
```

### VectorOfShared_ptrLandmark::empty

```cpp
bool VectorOfShared_ptrLandmark::empty();
AutoIt:
    $oVectorOfShared_ptrLandmark.empty() -> retval
```

### VectorOfShared_ptrLandmark::end

```cpp
void* VectorOfShared_ptrLandmark::end();
AutoIt:
    $oVectorOfShared_ptrLandmark.end() -> retval
```

### VectorOfShared_ptrLandmark::get_Item

```cpp
std::shared_ptr<mediapipe::Landmark> VectorOfShared_ptrLandmark::get_Item( size_t vIndex );
AutoIt:
    $oVectorOfShared_ptrLandmark.Item( $vIndex ) -> retval
    $oVectorOfShared_ptrLandmark( $vIndex ) -> retval
```

### VectorOfShared_ptrLandmark::get__NewEnum

```cpp
IUnknown* VectorOfShared_ptrLandmark::get__NewEnum();
AutoIt:
    $oVectorOfShared_ptrLandmark._NewEnum() -> retval
```

### VectorOfShared_ptrLandmark::push_back

```cpp
void VectorOfShared_ptrLandmark::push_back( std::shared_ptr<mediapipe::Landmark> value );
AutoIt:
    $oVectorOfShared_ptrLandmark.push_back( $value ) -> None
```

### VectorOfShared_ptrLandmark::push_vector

```cpp
void VectorOfShared_ptrLandmark::push_vector( VectorOfShared_ptrLandmark other );
AutoIt:
    $oVectorOfShared_ptrLandmark.push_vector( $other ) -> None
```

```cpp
void VectorOfShared_ptrLandmark::push_vector( VectorOfShared_ptrLandmark other,
                                              size_t                     count,
                                              size_t                     start = 0 );
AutoIt:
    $oVectorOfShared_ptrLandmark.push_vector( $other, $count[, $start] ) -> None
```

### VectorOfShared_ptrLandmark::put_Item

```cpp
void VectorOfShared_ptrLandmark::put_Item( size_t                               vIndex,
                                           std::shared_ptr<mediapipe::Landmark> vItem );
AutoIt:
    $oVectorOfShared_ptrLandmark.Item( $vIndex ) = $vItem
```

### VectorOfShared_ptrLandmark::size

```cpp
size_t VectorOfShared_ptrLandmark::size();
AutoIt:
    $oVectorOfShared_ptrLandmark.size() -> retval
```

### VectorOfShared_ptrLandmark::slice

```cpp
VectorOfShared_ptrLandmark VectorOfShared_ptrLandmark::slice( size_t start = 0,
                                                              size_t count = __self->get()->size() );
AutoIt:
    $oVectorOfShared_ptrLandmark.slice( [$start[, $count]] ) -> retval
```

### VectorOfShared_ptrLandmark::sort

```cpp
void VectorOfShared_ptrLandmark::sort( void*  comparator,
                                       size_t start = 0,
                                       size_t count = __self->get()->size() );
AutoIt:
    $oVectorOfShared_ptrLandmark.sort( $comparator[, $start[, $count]] ) -> None
```

### VectorOfShared_ptrLandmark::sort_variant

```cpp
void VectorOfShared_ptrLandmark::sort_variant( void*  comparator,
                                               size_t start = 0,
                                               size_t count = __self->get()->size() );
AutoIt:
    $oVectorOfShared_ptrLandmark.sort_variant( $comparator[, $start[, $count]] ) -> None
```

### VectorOfShared_ptrLandmark::start

```cpp
void* VectorOfShared_ptrLandmark::start();
AutoIt:
    $oVectorOfShared_ptrLandmark.start() -> retval
```

## VectorOfShared_ptrLandmarkList

### VectorOfShared_ptrLandmarkList::create

```cpp
static VectorOfShared_ptrLandmarkList VectorOfShared_ptrLandmarkList::create();
AutoIt:
    _Mediapipe_ObjCreate("VectorOfShared_ptrLandmarkList").create() -> <VectorOfShared_ptrLandmarkList object>
```

```cpp
static VectorOfShared_ptrLandmarkList VectorOfShared_ptrLandmarkList::create( size_t size );
AutoIt:
    _Mediapipe_ObjCreate("VectorOfShared_ptrLandmarkList").create( $size ) -> <VectorOfShared_ptrLandmarkList object>
```

```cpp
static VectorOfShared_ptrLandmarkList VectorOfShared_ptrLandmarkList::create( VectorOfShared_ptrLandmarkList other );
AutoIt:
    _Mediapipe_ObjCreate("VectorOfShared_ptrLandmarkList").create( $other ) -> <VectorOfShared_ptrLandmarkList object>
```

### VectorOfShared_ptrLandmarkList::Add

```cpp
void VectorOfShared_ptrLandmarkList::Add( std::shared_ptr<mediapipe::LandmarkList> value );
AutoIt:
    $oVectorOfShared_ptrLandmarkList.Add( $value ) -> None
```

### VectorOfShared_ptrLandmarkList::Items

```cpp
VectorOfShared_ptrLandmarkList VectorOfShared_ptrLandmarkList::Items();
AutoIt:
    $oVectorOfShared_ptrLandmarkList.Items() -> retval
```

### VectorOfShared_ptrLandmarkList::Keys

```cpp
std::vector<int> VectorOfShared_ptrLandmarkList::Keys();
AutoIt:
    $oVectorOfShared_ptrLandmarkList.Keys() -> retval
```

### VectorOfShared_ptrLandmarkList::Remove

```cpp
void VectorOfShared_ptrLandmarkList::Remove( size_t index );
AutoIt:
    $oVectorOfShared_ptrLandmarkList.Remove( $index ) -> None
```

### VectorOfShared_ptrLandmarkList::at

```cpp
std::shared_ptr<mediapipe::LandmarkList> VectorOfShared_ptrLandmarkList::at( size_t index );
AutoIt:
    $oVectorOfShared_ptrLandmarkList.at( $index ) -> retval
```

```cpp
void VectorOfShared_ptrLandmarkList::at( size_t                                   index,
                                         std::shared_ptr<mediapipe::LandmarkList> value );
AutoIt:
    $oVectorOfShared_ptrLandmarkList.at( $index, $value ) -> None
```

### VectorOfShared_ptrLandmarkList::clear

```cpp
void VectorOfShared_ptrLandmarkList::clear();
AutoIt:
    $oVectorOfShared_ptrLandmarkList.clear() -> None
```

### VectorOfShared_ptrLandmarkList::empty

```cpp
bool VectorOfShared_ptrLandmarkList::empty();
AutoIt:
    $oVectorOfShared_ptrLandmarkList.empty() -> retval
```

### VectorOfShared_ptrLandmarkList::end

```cpp
void* VectorOfShared_ptrLandmarkList::end();
AutoIt:
    $oVectorOfShared_ptrLandmarkList.end() -> retval
```

### VectorOfShared_ptrLandmarkList::get_Item

```cpp
std::shared_ptr<mediapipe::LandmarkList> VectorOfShared_ptrLandmarkList::get_Item( size_t vIndex );
AutoIt:
    $oVectorOfShared_ptrLandmarkList.Item( $vIndex ) -> retval
    $oVectorOfShared_ptrLandmarkList( $vIndex ) -> retval
```

### VectorOfShared_ptrLandmarkList::get__NewEnum

```cpp
IUnknown* VectorOfShared_ptrLandmarkList::get__NewEnum();
AutoIt:
    $oVectorOfShared_ptrLandmarkList._NewEnum() -> retval
```

### VectorOfShared_ptrLandmarkList::push_back

```cpp
void VectorOfShared_ptrLandmarkList::push_back( std::shared_ptr<mediapipe::LandmarkList> value );
AutoIt:
    $oVectorOfShared_ptrLandmarkList.push_back( $value ) -> None
```

### VectorOfShared_ptrLandmarkList::push_vector

```cpp
void VectorOfShared_ptrLandmarkList::push_vector( VectorOfShared_ptrLandmarkList other );
AutoIt:
    $oVectorOfShared_ptrLandmarkList.push_vector( $other ) -> None
```

```cpp
void VectorOfShared_ptrLandmarkList::push_vector( VectorOfShared_ptrLandmarkList other,
                                                  size_t                         count,
                                                  size_t                         start = 0 );
AutoIt:
    $oVectorOfShared_ptrLandmarkList.push_vector( $other, $count[, $start] ) -> None
```

### VectorOfShared_ptrLandmarkList::put_Item

```cpp
void VectorOfShared_ptrLandmarkList::put_Item( size_t                                   vIndex,
                                               std::shared_ptr<mediapipe::LandmarkList> vItem );
AutoIt:
    $oVectorOfShared_ptrLandmarkList.Item( $vIndex ) = $vItem
```

### VectorOfShared_ptrLandmarkList::size

```cpp
size_t VectorOfShared_ptrLandmarkList::size();
AutoIt:
    $oVectorOfShared_ptrLandmarkList.size() -> retval
```

### VectorOfShared_ptrLandmarkList::slice

```cpp
VectorOfShared_ptrLandmarkList VectorOfShared_ptrLandmarkList::slice( size_t start = 0,
                                                                      size_t count = __self->get()->size() );
AutoIt:
    $oVectorOfShared_ptrLandmarkList.slice( [$start[, $count]] ) -> retval
```

### VectorOfShared_ptrLandmarkList::sort

```cpp
void VectorOfShared_ptrLandmarkList::sort( void*  comparator,
                                           size_t start = 0,
                                           size_t count = __self->get()->size() );
AutoIt:
    $oVectorOfShared_ptrLandmarkList.sort( $comparator[, $start[, $count]] ) -> None
```

### VectorOfShared_ptrLandmarkList::sort_variant

```cpp
void VectorOfShared_ptrLandmarkList::sort_variant( void*  comparator,
                                                   size_t start = 0,
                                                   size_t count = __self->get()->size() );
AutoIt:
    $oVectorOfShared_ptrLandmarkList.sort_variant( $comparator[, $start[, $count]] ) -> None
```

### VectorOfShared_ptrLandmarkList::start

```cpp
void* VectorOfShared_ptrLandmarkList::start();
AutoIt:
    $oVectorOfShared_ptrLandmarkList.start() -> retval
```

## VectorOfShared_ptrNormalizedLandmark

### VectorOfShared_ptrNormalizedLandmark::create

```cpp
static VectorOfShared_ptrNormalizedLandmark VectorOfShared_ptrNormalizedLandmark::create();
AutoIt:
    _Mediapipe_ObjCreate("VectorOfShared_ptrNormalizedLandmark").create() -> <VectorOfShared_ptrNormalizedLandmark object>
```

```cpp
static VectorOfShared_ptrNormalizedLandmark VectorOfShared_ptrNormalizedLandmark::create( size_t size );
AutoIt:
    _Mediapipe_ObjCreate("VectorOfShared_ptrNormalizedLandmark").create( $size ) -> <VectorOfShared_ptrNormalizedLandmark object>
```

```cpp
static VectorOfShared_ptrNormalizedLandmark VectorOfShared_ptrNormalizedLandmark::create( VectorOfShared_ptrNormalizedLandmark other );
AutoIt:
    _Mediapipe_ObjCreate("VectorOfShared_ptrNormalizedLandmark").create( $other ) -> <VectorOfShared_ptrNormalizedLandmark object>
```

### VectorOfShared_ptrNormalizedLandmark::Add

```cpp
void VectorOfShared_ptrNormalizedLandmark::Add( std::shared_ptr<mediapipe::NormalizedLandmark> value );
AutoIt:
    $oVectorOfShared_ptrNormalizedLandmark.Add( $value ) -> None
```

### VectorOfShared_ptrNormalizedLandmark::Items

```cpp
VectorOfShared_ptrNormalizedLandmark VectorOfShared_ptrNormalizedLandmark::Items();
AutoIt:
    $oVectorOfShared_ptrNormalizedLandmark.Items() -> retval
```

### VectorOfShared_ptrNormalizedLandmark::Keys

```cpp
std::vector<int> VectorOfShared_ptrNormalizedLandmark::Keys();
AutoIt:
    $oVectorOfShared_ptrNormalizedLandmark.Keys() -> retval
```

### VectorOfShared_ptrNormalizedLandmark::Remove

```cpp
void VectorOfShared_ptrNormalizedLandmark::Remove( size_t index );
AutoIt:
    $oVectorOfShared_ptrNormalizedLandmark.Remove( $index ) -> None
```

### VectorOfShared_ptrNormalizedLandmark::at

```cpp
std::shared_ptr<mediapipe::NormalizedLandmark> VectorOfShared_ptrNormalizedLandmark::at( size_t index );
AutoIt:
    $oVectorOfShared_ptrNormalizedLandmark.at( $index ) -> retval
```

```cpp
void VectorOfShared_ptrNormalizedLandmark::at( size_t                                         index,
                                               std::shared_ptr<mediapipe::NormalizedLandmark> value );
AutoIt:
    $oVectorOfShared_ptrNormalizedLandmark.at( $index, $value ) -> None
```

### VectorOfShared_ptrNormalizedLandmark::clear

```cpp
void VectorOfShared_ptrNormalizedLandmark::clear();
AutoIt:
    $oVectorOfShared_ptrNormalizedLandmark.clear() -> None
```

### VectorOfShared_ptrNormalizedLandmark::empty

```cpp
bool VectorOfShared_ptrNormalizedLandmark::empty();
AutoIt:
    $oVectorOfShared_ptrNormalizedLandmark.empty() -> retval
```

### VectorOfShared_ptrNormalizedLandmark::end

```cpp
void* VectorOfShared_ptrNormalizedLandmark::end();
AutoIt:
    $oVectorOfShared_ptrNormalizedLandmark.end() -> retval
```

### VectorOfShared_ptrNormalizedLandmark::get_Item

```cpp
std::shared_ptr<mediapipe::NormalizedLandmark> VectorOfShared_ptrNormalizedLandmark::get_Item( size_t vIndex );
AutoIt:
    $oVectorOfShared_ptrNormalizedLandmark.Item( $vIndex ) -> retval
    $oVectorOfShared_ptrNormalizedLandmark( $vIndex ) -> retval
```

### VectorOfShared_ptrNormalizedLandmark::get__NewEnum

```cpp
IUnknown* VectorOfShared_ptrNormalizedLandmark::get__NewEnum();
AutoIt:
    $oVectorOfShared_ptrNormalizedLandmark._NewEnum() -> retval
```

### VectorOfShared_ptrNormalizedLandmark::push_back

```cpp
void VectorOfShared_ptrNormalizedLandmark::push_back( std::shared_ptr<mediapipe::NormalizedLandmark> value );
AutoIt:
    $oVectorOfShared_ptrNormalizedLandmark.push_back( $value ) -> None
```

### VectorOfShared_ptrNormalizedLandmark::push_vector

```cpp
void VectorOfShared_ptrNormalizedLandmark::push_vector( VectorOfShared_ptrNormalizedLandmark other );
AutoIt:
    $oVectorOfShared_ptrNormalizedLandmark.push_vector( $other ) -> None
```

```cpp
void VectorOfShared_ptrNormalizedLandmark::push_vector( VectorOfShared_ptrNormalizedLandmark other,
                                                        size_t                               count,
                                                        size_t                               start = 0 );
AutoIt:
    $oVectorOfShared_ptrNormalizedLandmark.push_vector( $other, $count[, $start] ) -> None
```

### VectorOfShared_ptrNormalizedLandmark::put_Item

```cpp
void VectorOfShared_ptrNormalizedLandmark::put_Item( size_t                                         vIndex,
                                                     std::shared_ptr<mediapipe::NormalizedLandmark> vItem );
AutoIt:
    $oVectorOfShared_ptrNormalizedLandmark.Item( $vIndex ) = $vItem
```

### VectorOfShared_ptrNormalizedLandmark::size

```cpp
size_t VectorOfShared_ptrNormalizedLandmark::size();
AutoIt:
    $oVectorOfShared_ptrNormalizedLandmark.size() -> retval
```

### VectorOfShared_ptrNormalizedLandmark::slice

```cpp
VectorOfShared_ptrNormalizedLandmark VectorOfShared_ptrNormalizedLandmark::slice( size_t start = 0,
                                                                                  size_t count = __self->get()->size() );
AutoIt:
    $oVectorOfShared_ptrNormalizedLandmark.slice( [$start[, $count]] ) -> retval
```

### VectorOfShared_ptrNormalizedLandmark::sort

```cpp
void VectorOfShared_ptrNormalizedLandmark::sort( void*  comparator,
                                                 size_t start = 0,
                                                 size_t count = __self->get()->size() );
AutoIt:
    $oVectorOfShared_ptrNormalizedLandmark.sort( $comparator[, $start[, $count]] ) -> None
```

### VectorOfShared_ptrNormalizedLandmark::sort_variant

```cpp
void VectorOfShared_ptrNormalizedLandmark::sort_variant( void*  comparator,
                                                         size_t start = 0,
                                                         size_t count = __self->get()->size() );
AutoIt:
    $oVectorOfShared_ptrNormalizedLandmark.sort_variant( $comparator[, $start[, $count]] ) -> None
```

### VectorOfShared_ptrNormalizedLandmark::start

```cpp
void* VectorOfShared_ptrNormalizedLandmark::start();
AutoIt:
    $oVectorOfShared_ptrNormalizedLandmark.start() -> retval
```

## VectorOfShared_ptrNormalizedLandmarkList

### VectorOfShared_ptrNormalizedLandmarkList::create

```cpp
static VectorOfShared_ptrNormalizedLandmarkList VectorOfShared_ptrNormalizedLandmarkList::create();
AutoIt:
    _Mediapipe_ObjCreate("VectorOfShared_ptrNormalizedLandmarkList").create() -> <VectorOfShared_ptrNormalizedLandmarkList object>
```

```cpp
static VectorOfShared_ptrNormalizedLandmarkList VectorOfShared_ptrNormalizedLandmarkList::create( size_t size );
AutoIt:
    _Mediapipe_ObjCreate("VectorOfShared_ptrNormalizedLandmarkList").create( $size ) -> <VectorOfShared_ptrNormalizedLandmarkList object>
```

```cpp
static VectorOfShared_ptrNormalizedLandmarkList VectorOfShared_ptrNormalizedLandmarkList::create( VectorOfShared_ptrNormalizedLandmarkList other );
AutoIt:
    _Mediapipe_ObjCreate("VectorOfShared_ptrNormalizedLandmarkList").create( $other ) -> <VectorOfShared_ptrNormalizedLandmarkList object>
```

### VectorOfShared_ptrNormalizedLandmarkList::Add

```cpp
void VectorOfShared_ptrNormalizedLandmarkList::Add( std::shared_ptr<mediapipe::NormalizedLandmarkList> value );
AutoIt:
    $oVectorOfShared_ptrNormalizedLandmarkList.Add( $value ) -> None
```

### VectorOfShared_ptrNormalizedLandmarkList::Items

```cpp
VectorOfShared_ptrNormalizedLandmarkList VectorOfShared_ptrNormalizedLandmarkList::Items();
AutoIt:
    $oVectorOfShared_ptrNormalizedLandmarkList.Items() -> retval
```

### VectorOfShared_ptrNormalizedLandmarkList::Keys

```cpp
std::vector<int> VectorOfShared_ptrNormalizedLandmarkList::Keys();
AutoIt:
    $oVectorOfShared_ptrNormalizedLandmarkList.Keys() -> retval
```

### VectorOfShared_ptrNormalizedLandmarkList::Remove

```cpp
void VectorOfShared_ptrNormalizedLandmarkList::Remove( size_t index );
AutoIt:
    $oVectorOfShared_ptrNormalizedLandmarkList.Remove( $index ) -> None
```

### VectorOfShared_ptrNormalizedLandmarkList::at

```cpp
std::shared_ptr<mediapipe::NormalizedLandmarkList> VectorOfShared_ptrNormalizedLandmarkList::at( size_t index );
AutoIt:
    $oVectorOfShared_ptrNormalizedLandmarkList.at( $index ) -> retval
```

```cpp
void VectorOfShared_ptrNormalizedLandmarkList::at( size_t                                             index,
                                                   std::shared_ptr<mediapipe::NormalizedLandmarkList> value );
AutoIt:
    $oVectorOfShared_ptrNormalizedLandmarkList.at( $index, $value ) -> None
```

### VectorOfShared_ptrNormalizedLandmarkList::clear

```cpp
void VectorOfShared_ptrNormalizedLandmarkList::clear();
AutoIt:
    $oVectorOfShared_ptrNormalizedLandmarkList.clear() -> None
```

### VectorOfShared_ptrNormalizedLandmarkList::empty

```cpp
bool VectorOfShared_ptrNormalizedLandmarkList::empty();
AutoIt:
    $oVectorOfShared_ptrNormalizedLandmarkList.empty() -> retval
```

### VectorOfShared_ptrNormalizedLandmarkList::end

```cpp
void* VectorOfShared_ptrNormalizedLandmarkList::end();
AutoIt:
    $oVectorOfShared_ptrNormalizedLandmarkList.end() -> retval
```

### VectorOfShared_ptrNormalizedLandmarkList::get_Item

```cpp
std::shared_ptr<mediapipe::NormalizedLandmarkList> VectorOfShared_ptrNormalizedLandmarkList::get_Item( size_t vIndex );
AutoIt:
    $oVectorOfShared_ptrNormalizedLandmarkList.Item( $vIndex ) -> retval
    $oVectorOfShared_ptrNormalizedLandmarkList( $vIndex ) -> retval
```

### VectorOfShared_ptrNormalizedLandmarkList::get__NewEnum

```cpp
IUnknown* VectorOfShared_ptrNormalizedLandmarkList::get__NewEnum();
AutoIt:
    $oVectorOfShared_ptrNormalizedLandmarkList._NewEnum() -> retval
```

### VectorOfShared_ptrNormalizedLandmarkList::push_back

```cpp
void VectorOfShared_ptrNormalizedLandmarkList::push_back( std::shared_ptr<mediapipe::NormalizedLandmarkList> value );
AutoIt:
    $oVectorOfShared_ptrNormalizedLandmarkList.push_back( $value ) -> None
```

### VectorOfShared_ptrNormalizedLandmarkList::push_vector

```cpp
void VectorOfShared_ptrNormalizedLandmarkList::push_vector( VectorOfShared_ptrNormalizedLandmarkList other );
AutoIt:
    $oVectorOfShared_ptrNormalizedLandmarkList.push_vector( $other ) -> None
```

```cpp
void VectorOfShared_ptrNormalizedLandmarkList::push_vector( VectorOfShared_ptrNormalizedLandmarkList other,
                                                            size_t                                   count,
                                                            size_t                                   start = 0 );
AutoIt:
    $oVectorOfShared_ptrNormalizedLandmarkList.push_vector( $other, $count[, $start] ) -> None
```

### VectorOfShared_ptrNormalizedLandmarkList::put_Item

```cpp
void VectorOfShared_ptrNormalizedLandmarkList::put_Item( size_t                                             vIndex,
                                                         std::shared_ptr<mediapipe::NormalizedLandmarkList> vItem );
AutoIt:
    $oVectorOfShared_ptrNormalizedLandmarkList.Item( $vIndex ) = $vItem
```

### VectorOfShared_ptrNormalizedLandmarkList::size

```cpp
size_t VectorOfShared_ptrNormalizedLandmarkList::size();
AutoIt:
    $oVectorOfShared_ptrNormalizedLandmarkList.size() -> retval
```

### VectorOfShared_ptrNormalizedLandmarkList::slice

```cpp
VectorOfShared_ptrNormalizedLandmarkList VectorOfShared_ptrNormalizedLandmarkList::slice( size_t start = 0,
                                                                                          size_t count = __self->get()->size() );
AutoIt:
    $oVectorOfShared_ptrNormalizedLandmarkList.slice( [$start[, $count]] ) -> retval
```

### VectorOfShared_ptrNormalizedLandmarkList::sort

```cpp
void VectorOfShared_ptrNormalizedLandmarkList::sort( void*  comparator,
                                                     size_t start = 0,
                                                     size_t count = __self->get()->size() );
AutoIt:
    $oVectorOfShared_ptrNormalizedLandmarkList.sort( $comparator[, $start[, $count]] ) -> None
```

### VectorOfShared_ptrNormalizedLandmarkList::sort_variant

```cpp
void VectorOfShared_ptrNormalizedLandmarkList::sort_variant( void*  comparator,
                                                             size_t start = 0,
                                                             size_t count = __self->get()->size() );
AutoIt:
    $oVectorOfShared_ptrNormalizedLandmarkList.sort_variant( $comparator[, $start[, $count]] ) -> None
```

### VectorOfShared_ptrNormalizedLandmarkList::start

```cpp
void* VectorOfShared_ptrNormalizedLandmarkList::start();
AutoIt:
    $oVectorOfShared_ptrNormalizedLandmarkList.start() -> retval
```

## VectorOfShared_ptrConstantSidePacket

### VectorOfShared_ptrConstantSidePacket::create

```cpp
static VectorOfShared_ptrConstantSidePacket VectorOfShared_ptrConstantSidePacket::create();
AutoIt:
    _Mediapipe_ObjCreate("VectorOfShared_ptrConstantSidePacket").create() -> <VectorOfShared_ptrConstantSidePacket object>
```

```cpp
static VectorOfShared_ptrConstantSidePacket VectorOfShared_ptrConstantSidePacket::create( size_t size );
AutoIt:
    _Mediapipe_ObjCreate("VectorOfShared_ptrConstantSidePacket").create( $size ) -> <VectorOfShared_ptrConstantSidePacket object>
```

```cpp
static VectorOfShared_ptrConstantSidePacket VectorOfShared_ptrConstantSidePacket::create( VectorOfShared_ptrConstantSidePacket other );
AutoIt:
    _Mediapipe_ObjCreate("VectorOfShared_ptrConstantSidePacket").create( $other ) -> <VectorOfShared_ptrConstantSidePacket object>
```

### VectorOfShared_ptrConstantSidePacket::Add

```cpp
void VectorOfShared_ptrConstantSidePacket::Add( std::shared_ptr<mediapipe::ConstantSidePacketCalculatorOptions::ConstantSidePacket> value );
AutoIt:
    $oVectorOfShared_ptrConstantSidePacket.Add( $value ) -> None
```

### VectorOfShared_ptrConstantSidePacket::Items

```cpp
VectorOfShared_ptrConstantSidePacket VectorOfShared_ptrConstantSidePacket::Items();
AutoIt:
    $oVectorOfShared_ptrConstantSidePacket.Items() -> retval
```

### VectorOfShared_ptrConstantSidePacket::Keys

```cpp
std::vector<int> VectorOfShared_ptrConstantSidePacket::Keys();
AutoIt:
    $oVectorOfShared_ptrConstantSidePacket.Keys() -> retval
```

### VectorOfShared_ptrConstantSidePacket::Remove

```cpp
void VectorOfShared_ptrConstantSidePacket::Remove( size_t index );
AutoIt:
    $oVectorOfShared_ptrConstantSidePacket.Remove( $index ) -> None
```

### VectorOfShared_ptrConstantSidePacket::at

```cpp
std::shared_ptr<mediapipe::ConstantSidePacketCalculatorOptions::ConstantSidePacket> VectorOfShared_ptrConstantSidePacket::at( size_t index );
AutoIt:
    $oVectorOfShared_ptrConstantSidePacket.at( $index ) -> retval
```

```cpp
void VectorOfShared_ptrConstantSidePacket::at( size_t                                                                              index,
                                               std::shared_ptr<mediapipe::ConstantSidePacketCalculatorOptions::ConstantSidePacket> value );
AutoIt:
    $oVectorOfShared_ptrConstantSidePacket.at( $index, $value ) -> None
```

### VectorOfShared_ptrConstantSidePacket::clear

```cpp
void VectorOfShared_ptrConstantSidePacket::clear();
AutoIt:
    $oVectorOfShared_ptrConstantSidePacket.clear() -> None
```

### VectorOfShared_ptrConstantSidePacket::empty

```cpp
bool VectorOfShared_ptrConstantSidePacket::empty();
AutoIt:
    $oVectorOfShared_ptrConstantSidePacket.empty() -> retval
```

### VectorOfShared_ptrConstantSidePacket::end

```cpp
void* VectorOfShared_ptrConstantSidePacket::end();
AutoIt:
    $oVectorOfShared_ptrConstantSidePacket.end() -> retval
```

### VectorOfShared_ptrConstantSidePacket::get_Item

```cpp
std::shared_ptr<mediapipe::ConstantSidePacketCalculatorOptions::ConstantSidePacket> VectorOfShared_ptrConstantSidePacket::get_Item( size_t vIndex );
AutoIt:
    $oVectorOfShared_ptrConstantSidePacket.Item( $vIndex ) -> retval
    $oVectorOfShared_ptrConstantSidePacket( $vIndex ) -> retval
```

### VectorOfShared_ptrConstantSidePacket::get__NewEnum

```cpp
IUnknown* VectorOfShared_ptrConstantSidePacket::get__NewEnum();
AutoIt:
    $oVectorOfShared_ptrConstantSidePacket._NewEnum() -> retval
```

### VectorOfShared_ptrConstantSidePacket::push_back

```cpp
void VectorOfShared_ptrConstantSidePacket::push_back( std::shared_ptr<mediapipe::ConstantSidePacketCalculatorOptions::ConstantSidePacket> value );
AutoIt:
    $oVectorOfShared_ptrConstantSidePacket.push_back( $value ) -> None
```

### VectorOfShared_ptrConstantSidePacket::push_vector

```cpp
void VectorOfShared_ptrConstantSidePacket::push_vector( VectorOfShared_ptrConstantSidePacket other );
AutoIt:
    $oVectorOfShared_ptrConstantSidePacket.push_vector( $other ) -> None
```

```cpp
void VectorOfShared_ptrConstantSidePacket::push_vector( VectorOfShared_ptrConstantSidePacket other,
                                                        size_t                               count,
                                                        size_t                               start = 0 );
AutoIt:
    $oVectorOfShared_ptrConstantSidePacket.push_vector( $other, $count[, $start] ) -> None
```

### VectorOfShared_ptrConstantSidePacket::put_Item

```cpp
void VectorOfShared_ptrConstantSidePacket::put_Item( size_t                                                                              vIndex,
                                                     std::shared_ptr<mediapipe::ConstantSidePacketCalculatorOptions::ConstantSidePacket> vItem );
AutoIt:
    $oVectorOfShared_ptrConstantSidePacket.Item( $vIndex ) = $vItem
```

### VectorOfShared_ptrConstantSidePacket::size

```cpp
size_t VectorOfShared_ptrConstantSidePacket::size();
AutoIt:
    $oVectorOfShared_ptrConstantSidePacket.size() -> retval
```

### VectorOfShared_ptrConstantSidePacket::slice

```cpp
VectorOfShared_ptrConstantSidePacket VectorOfShared_ptrConstantSidePacket::slice( size_t start = 0,
                                                                                  size_t count = __self->get()->size() );
AutoIt:
    $oVectorOfShared_ptrConstantSidePacket.slice( [$start[, $count]] ) -> retval
```

### VectorOfShared_ptrConstantSidePacket::sort

```cpp
void VectorOfShared_ptrConstantSidePacket::sort( void*  comparator,
                                                 size_t start = 0,
                                                 size_t count = __self->get()->size() );
AutoIt:
    $oVectorOfShared_ptrConstantSidePacket.sort( $comparator[, $start[, $count]] ) -> None
```

### VectorOfShared_ptrConstantSidePacket::sort_variant

```cpp
void VectorOfShared_ptrConstantSidePacket::sort_variant( void*  comparator,
                                                         size_t start = 0,
                                                         size_t count = __self->get()->size() );
AutoIt:
    $oVectorOfShared_ptrConstantSidePacket.sort_variant( $comparator[, $start[, $count]] ) -> None
```

### VectorOfShared_ptrConstantSidePacket::start

```cpp
void* VectorOfShared_ptrConstantSidePacket::start();
AutoIt:
    $oVectorOfShared_ptrConstantSidePacket.start() -> retval
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

### VectorOfPairOfStringAndPacket::get__NewEnum

```cpp
IUnknown* VectorOfPairOfStringAndPacket::get__NewEnum();
AutoIt:
    $oVectorOfPairOfStringAndPacket._NewEnum() -> retval
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
                                                                    size_t count = __self->get()->size() );
AutoIt:
    $oVectorOfPairOfStringAndPacket.slice( [$start[, $count]] ) -> retval
```

### VectorOfPairOfStringAndPacket::sort

```cpp
void VectorOfPairOfStringAndPacket::sort( void*  comparator,
                                          size_t start = 0,
                                          size_t count = __self->get()->size() );
AutoIt:
    $oVectorOfPairOfStringAndPacket.sort( $comparator[, $start[, $count]] ) -> None
```

### VectorOfPairOfStringAndPacket::sort_variant

```cpp
void VectorOfPairOfStringAndPacket::sort_variant( void*  comparator,
                                                  size_t start = 0,
                                                  size_t count = __self->get()->size() );
AutoIt:
    $oVectorOfPairOfStringAndPacket.sort_variant( $comparator[, $start[, $count]] ) -> None
```

### VectorOfPairOfStringAndPacket::start

```cpp
void* VectorOfPairOfStringAndPacket::start();
AutoIt:
    $oVectorOfPairOfStringAndPacket.start() -> retval
```

## VectorOfPairOfStringAndPacketDataType

### VectorOfPairOfStringAndPacketDataType::create

```cpp
static VectorOfPairOfStringAndPacketDataType VectorOfPairOfStringAndPacketDataType::create();
AutoIt:
    _Mediapipe_ObjCreate("VectorOfPairOfStringAndPacketDataType").create() -> <VectorOfPairOfStringAndPacketDataType object>
```

```cpp
static VectorOfPairOfStringAndPacketDataType VectorOfPairOfStringAndPacketDataType::create( size_t size );
AutoIt:
    _Mediapipe_ObjCreate("VectorOfPairOfStringAndPacketDataType").create( $size ) -> <VectorOfPairOfStringAndPacketDataType object>
```

```cpp
static VectorOfPairOfStringAndPacketDataType VectorOfPairOfStringAndPacketDataType::create( VectorOfPairOfStringAndPacketDataType other );
AutoIt:
    _Mediapipe_ObjCreate("VectorOfPairOfStringAndPacketDataType").create( $other ) -> <VectorOfPairOfStringAndPacketDataType object>
```

### VectorOfPairOfStringAndPacketDataType::Add

```cpp
void VectorOfPairOfStringAndPacketDataType::Add( std::pair<std::string, mediapipe::autoit::solution_base::PacketDataType> value );
AutoIt:
    $oVectorOfPairOfStringAndPacketDataType.Add( $value ) -> None
```

### VectorOfPairOfStringAndPacketDataType::Items

```cpp
VectorOfPairOfStringAndPacketDataType VectorOfPairOfStringAndPacketDataType::Items();
AutoIt:
    $oVectorOfPairOfStringAndPacketDataType.Items() -> retval
```

### VectorOfPairOfStringAndPacketDataType::Keys

```cpp
std::vector<int> VectorOfPairOfStringAndPacketDataType::Keys();
AutoIt:
    $oVectorOfPairOfStringAndPacketDataType.Keys() -> retval
```

### VectorOfPairOfStringAndPacketDataType::Remove

```cpp
void VectorOfPairOfStringAndPacketDataType::Remove( size_t index );
AutoIt:
    $oVectorOfPairOfStringAndPacketDataType.Remove( $index ) -> None
```

### VectorOfPairOfStringAndPacketDataType::at

```cpp
std::pair<std::string, mediapipe::autoit::solution_base::PacketDataType> VectorOfPairOfStringAndPacketDataType::at( size_t index );
AutoIt:
    $oVectorOfPairOfStringAndPacketDataType.at( $index ) -> retval
```

```cpp
void VectorOfPairOfStringAndPacketDataType::at( size_t                                                                   index,
                                                std::pair<std::string, mediapipe::autoit::solution_base::PacketDataType> value );
AutoIt:
    $oVectorOfPairOfStringAndPacketDataType.at( $index, $value ) -> None
```

### VectorOfPairOfStringAndPacketDataType::clear

```cpp
void VectorOfPairOfStringAndPacketDataType::clear();
AutoIt:
    $oVectorOfPairOfStringAndPacketDataType.clear() -> None
```

### VectorOfPairOfStringAndPacketDataType::empty

```cpp
bool VectorOfPairOfStringAndPacketDataType::empty();
AutoIt:
    $oVectorOfPairOfStringAndPacketDataType.empty() -> retval
```

### VectorOfPairOfStringAndPacketDataType::end

```cpp
void* VectorOfPairOfStringAndPacketDataType::end();
AutoIt:
    $oVectorOfPairOfStringAndPacketDataType.end() -> retval
```

### VectorOfPairOfStringAndPacketDataType::get_Item

```cpp
std::pair<std::string, mediapipe::autoit::solution_base::PacketDataType> VectorOfPairOfStringAndPacketDataType::get_Item( size_t vIndex );
AutoIt:
    $oVectorOfPairOfStringAndPacketDataType.Item( $vIndex ) -> retval
    $oVectorOfPairOfStringAndPacketDataType( $vIndex ) -> retval
```

### VectorOfPairOfStringAndPacketDataType::get__NewEnum

```cpp
IUnknown* VectorOfPairOfStringAndPacketDataType::get__NewEnum();
AutoIt:
    $oVectorOfPairOfStringAndPacketDataType._NewEnum() -> retval
```

### VectorOfPairOfStringAndPacketDataType::push_back

```cpp
void VectorOfPairOfStringAndPacketDataType::push_back( std::pair<std::string, mediapipe::autoit::solution_base::PacketDataType> value );
AutoIt:
    $oVectorOfPairOfStringAndPacketDataType.push_back( $value ) -> None
```

### VectorOfPairOfStringAndPacketDataType::push_vector

```cpp
void VectorOfPairOfStringAndPacketDataType::push_vector( VectorOfPairOfStringAndPacketDataType other );
AutoIt:
    $oVectorOfPairOfStringAndPacketDataType.push_vector( $other ) -> None
```

```cpp
void VectorOfPairOfStringAndPacketDataType::push_vector( VectorOfPairOfStringAndPacketDataType other,
                                                         size_t                                count,
                                                         size_t                                start = 0 );
AutoIt:
    $oVectorOfPairOfStringAndPacketDataType.push_vector( $other, $count[, $start] ) -> None
```

### VectorOfPairOfStringAndPacketDataType::put_Item

```cpp
void VectorOfPairOfStringAndPacketDataType::put_Item( size_t                                                                   vIndex,
                                                      std::pair<std::string, mediapipe::autoit::solution_base::PacketDataType> vItem );
AutoIt:
    $oVectorOfPairOfStringAndPacketDataType.Item( $vIndex ) = $vItem
```

### VectorOfPairOfStringAndPacketDataType::size

```cpp
size_t VectorOfPairOfStringAndPacketDataType::size();
AutoIt:
    $oVectorOfPairOfStringAndPacketDataType.size() -> retval
```

### VectorOfPairOfStringAndPacketDataType::slice

```cpp
VectorOfPairOfStringAndPacketDataType VectorOfPairOfStringAndPacketDataType::slice( size_t start = 0,
                                                                                    size_t count = __self->get()->size() );
AutoIt:
    $oVectorOfPairOfStringAndPacketDataType.slice( [$start[, $count]] ) -> retval
```

### VectorOfPairOfStringAndPacketDataType::sort

```cpp
void VectorOfPairOfStringAndPacketDataType::sort( void*  comparator,
                                                  size_t start = 0,
                                                  size_t count = __self->get()->size() );
AutoIt:
    $oVectorOfPairOfStringAndPacketDataType.sort( $comparator[, $start[, $count]] ) -> None
```

### VectorOfPairOfStringAndPacketDataType::sort_variant

```cpp
void VectorOfPairOfStringAndPacketDataType::sort_variant( void*  comparator,
                                                          size_t start = 0,
                                                          size_t count = __self->get()->size() );
AutoIt:
    $oVectorOfPairOfStringAndPacketDataType.sort_variant( $comparator[, $start[, $count]] ) -> None
```

### VectorOfPairOfStringAndPacketDataType::start

```cpp
void* VectorOfPairOfStringAndPacketDataType::start();
AutoIt:
    $oVectorOfPairOfStringAndPacketDataType.start() -> retval
```

## VectorOfPacketDataType

### VectorOfPacketDataType::create

```cpp
static VectorOfPacketDataType VectorOfPacketDataType::create();
AutoIt:
    _Mediapipe_ObjCreate("VectorOfPacketDataType").create() -> <VectorOfPacketDataType object>
```

```cpp
static VectorOfPacketDataType VectorOfPacketDataType::create( size_t size );
AutoIt:
    _Mediapipe_ObjCreate("VectorOfPacketDataType").create( $size ) -> <VectorOfPacketDataType object>
```

```cpp
static VectorOfPacketDataType VectorOfPacketDataType::create( VectorOfPacketDataType other );
AutoIt:
    _Mediapipe_ObjCreate("VectorOfPacketDataType").create( $other ) -> <VectorOfPacketDataType object>
```

### VectorOfPacketDataType::Add

```cpp
void VectorOfPacketDataType::Add( mediapipe::autoit::solution_base::PacketDataType value );
AutoIt:
    $oVectorOfPacketDataType.Add( $value ) -> None
```

### VectorOfPacketDataType::Items

```cpp
VectorOfPacketDataType VectorOfPacketDataType::Items();
AutoIt:
    $oVectorOfPacketDataType.Items() -> retval
```

### VectorOfPacketDataType::Keys

```cpp
std::vector<int> VectorOfPacketDataType::Keys();
AutoIt:
    $oVectorOfPacketDataType.Keys() -> retval
```

### VectorOfPacketDataType::Remove

```cpp
void VectorOfPacketDataType::Remove( size_t index );
AutoIt:
    $oVectorOfPacketDataType.Remove( $index ) -> None
```

### VectorOfPacketDataType::at

```cpp
mediapipe::autoit::solution_base::PacketDataType VectorOfPacketDataType::at( size_t index );
AutoIt:
    $oVectorOfPacketDataType.at( $index ) -> retval
```

```cpp
void VectorOfPacketDataType::at( size_t                                           index,
                                 mediapipe::autoit::solution_base::PacketDataType value );
AutoIt:
    $oVectorOfPacketDataType.at( $index, $value ) -> None
```

### VectorOfPacketDataType::clear

```cpp
void VectorOfPacketDataType::clear();
AutoIt:
    $oVectorOfPacketDataType.clear() -> None
```

### VectorOfPacketDataType::empty

```cpp
bool VectorOfPacketDataType::empty();
AutoIt:
    $oVectorOfPacketDataType.empty() -> retval
```

### VectorOfPacketDataType::end

```cpp
void* VectorOfPacketDataType::end();
AutoIt:
    $oVectorOfPacketDataType.end() -> retval
```

### VectorOfPacketDataType::get_Item

```cpp
mediapipe::autoit::solution_base::PacketDataType VectorOfPacketDataType::get_Item( size_t vIndex );
AutoIt:
    $oVectorOfPacketDataType.Item( $vIndex ) -> retval
    $oVectorOfPacketDataType( $vIndex ) -> retval
```

### VectorOfPacketDataType::get__NewEnum

```cpp
IUnknown* VectorOfPacketDataType::get__NewEnum();
AutoIt:
    $oVectorOfPacketDataType._NewEnum() -> retval
```

### VectorOfPacketDataType::push_back

```cpp
void VectorOfPacketDataType::push_back( mediapipe::autoit::solution_base::PacketDataType value );
AutoIt:
    $oVectorOfPacketDataType.push_back( $value ) -> None
```

### VectorOfPacketDataType::push_vector

```cpp
void VectorOfPacketDataType::push_vector( VectorOfPacketDataType other );
AutoIt:
    $oVectorOfPacketDataType.push_vector( $other ) -> None
```

```cpp
void VectorOfPacketDataType::push_vector( VectorOfPacketDataType other,
                                          size_t                 count,
                                          size_t                 start = 0 );
AutoIt:
    $oVectorOfPacketDataType.push_vector( $other, $count[, $start] ) -> None
```

### VectorOfPacketDataType::put_Item

```cpp
void VectorOfPacketDataType::put_Item( size_t                                           vIndex,
                                       mediapipe::autoit::solution_base::PacketDataType vItem );
AutoIt:
    $oVectorOfPacketDataType.Item( $vIndex ) = $vItem
```

### VectorOfPacketDataType::size

```cpp
size_t VectorOfPacketDataType::size();
AutoIt:
    $oVectorOfPacketDataType.size() -> retval
```

### VectorOfPacketDataType::slice

```cpp
VectorOfPacketDataType VectorOfPacketDataType::slice( size_t start = 0,
                                                      size_t count = __self->get()->size() );
AutoIt:
    $oVectorOfPacketDataType.slice( [$start[, $count]] ) -> retval
```

### VectorOfPacketDataType::sort

```cpp
void VectorOfPacketDataType::sort( void*  comparator,
                                   size_t start = 0,
                                   size_t count = __self->get()->size() );
AutoIt:
    $oVectorOfPacketDataType.sort( $comparator[, $start[, $count]] ) -> None
```

### VectorOfPacketDataType::sort_variant

```cpp
void VectorOfPacketDataType::sort_variant( void*  comparator,
                                           size_t start = 0,
                                           size_t count = __self->get()->size() );
AutoIt:
    $oVectorOfPacketDataType.sort_variant( $comparator[, $start[, $count]] ) -> None
```

### VectorOfPacketDataType::start

```cpp
void* VectorOfPacketDataType::start();
AutoIt:
    $oVectorOfPacketDataType.start() -> retval
```
