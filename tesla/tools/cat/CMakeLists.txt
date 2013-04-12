add_llvm_executable(tesla-cat cat.cpp)
target_link_libraries(tesla-cat TeslaCommon)
install(TARGETS tesla-cat DESTINATION bin)

