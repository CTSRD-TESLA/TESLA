SPLC ?= ../../cfa/splc

tcpc_defs.h tcpc_automata.c tcpc.spec: tcpc.spl $(SPLC) Makefile
	$(SPLC) -t tesla -s tcpc tcpc.spl
