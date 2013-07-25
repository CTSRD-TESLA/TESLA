add_llvm_executable(tesla-print print.cpp)
target_link_libraries(tesla-print TeslaCommon)
install(TARGETS tesla-print DESTINATION bin)
