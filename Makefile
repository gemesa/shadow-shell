BUILDDIR = build

$(shell mkdir -p $(BUILDDIR))

.PHONY: all clean

all: $(BUILDDIR)/crt-hello \
$(BUILDDIR)/crt-stack \
$(BUILDDIR)/nocrt-hello \
$(BUILDDIR)/nocrt-hello-nasm \
$(BUILDDIR)/nocrt-jmp-func \
$(BUILDDIR)/nocrt-call-func \
$(BUILDDIR)/nocrt-rep \
$(BUILDDIR)/crt-cmp \
$(BUILDDIR)/crt-loop \
$(BUILDDIR)/crt-lea-array \
$(BUILDDIR)/msf-msg.exe \
lab/sh/target/x86_64-pc-windows-gnu/debug/sh.exe

$(BUILDDIR)/crt-hello: lab/crt-hello.s
	gcc $< -g -o $@

$(BUILDDIR)/crt-stack: lab/crt-stack.s
	gcc $< -g -o $@

$(BUILDDIR)/nocrt-hello: lab/nocrt-hello.s
	as $< -g -o $(BUILDDIR)/nocrt-hello.o
	ld $(BUILDDIR)/nocrt-hello.o -g -o $@

$(BUILDDIR)/nocrt-hello-nasm: lab/nocrt-hello-nasm.s
	nasm -f elf64 $< -g -o $(BUILDDIR)/nocrt-hello-nasm.o
	ld $(BUILDDIR)/nocrt-hello-nasm.o -g -o $@

$(BUILDDIR)/nocrt-jmp-func: lab/nocrt-jmp-func.s
	as $< -g -o $(BUILDDIR)/nocrt-jmp-func.o
	ld $(BUILDDIR)/nocrt-jmp-func.o -g -o $@

$(BUILDDIR)/nocrt-call-func: lab/nocrt-call-func.s
	as $< -g -o $(BUILDDIR)/nocrt-call-func.o
	ld $(BUILDDIR)/nocrt-call-func.o -g -o $@

$(BUILDDIR)/nocrt-rep: lab/nocrt-rep.s
	as $< -g -o $(BUILDDIR)/nocrt-rep.o
	ld $(BUILDDIR)/nocrt-rep.o -g -o $@

$(BUILDDIR)/crt-cmp: lab/crt-cmp.s
	gcc $< -g -o $@

$(BUILDDIR)/crt-loop: lab/crt-loop.s
	gcc $< -g -o $@

$(BUILDDIR)/crt-lea-array: lab/crt-lea-array.s
	gcc $< -g -o $@

$(BUILDDIR)/msf-msg.exe: lab/sh.c
	x86_64-w64-mingw32-gcc $< -g -o $@

lab/sh/target/x86_64-pc-windows-gnu/debug/sh.exe: lab/sh/src/main.rs
	cargo build --target x86_64-pc-windows-gnu

clean:
	rm -rf $(BUILDDIR)
	cargo clean
