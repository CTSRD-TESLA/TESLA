all: mac_assertion.c

clean:
	rm -f mac_assertion.c

mac_assertion.c: mac_assertion.c.template ../mwc/syscalls.c.vars
	./generate.sh ../mwc/syscalls.c.vars $<

