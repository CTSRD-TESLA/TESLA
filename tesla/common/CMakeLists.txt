protobuf_generate_cpp(PROTO_SRCS PROTO_HDRS tesla.proto)

add_library(TeslaCommon ${PROTO_SRCS} ${PROTO_HDRS})
target_link_libraries(TeslaCommon ${PROTOBUF_LIBRARY})

