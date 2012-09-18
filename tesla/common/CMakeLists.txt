protobuf_generate_cpp(PROTO_SRCS PROTO_HDRS tesla.proto)

add_library(TeslaProto ${PROTO_SRCS} ${PROTO_HDRS})
target_link_libraries(TeslaProto ${PROTOBUF_LIBRARY})

add_library(TeslaCommon Manifest.cpp)
target_link_libraries(TeslaCommon TeslaProto)

