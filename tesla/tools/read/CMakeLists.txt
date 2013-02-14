add_llvm_executable(tesla-read read.cpp)
target_link_libraries(tesla-read TeslaCommon)
install(TARGETS tesla-read DESTINATION bin)

