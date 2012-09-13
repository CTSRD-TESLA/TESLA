add_llvm_loadable_module(TeslaInstrumenter
	Instrumentation.cpp
	TeslaInstrumenter.cpp
)

target_link_libraries(TeslaInstrumenter Tesla LLVMSupport)

