add_llvm_executable(tesla-graph graph.cpp)
target_link_libraries(tesla-graph TeslaCommon)
install(TARGETS tesla-graph DESTINATION bin)

