BUILDDIR = build

$(shell mkdir -p $(BUILDDIR))

.PHONY: all clean cargo-build

all: cargo-build \
$(BUILDDIR)/crt-hello \
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
$(BUILDDIR)/bof-server-no-pie \
$(BUILDDIR)/bof-server-pie

cargo-build:
	cargo build --target x86_64-pc-windows-gnu

$(BUILDDIR)/crt-hello: lab/asm-hive/crt-hello.s
	gcc $< -g -o $@

$(BUILDDIR)/crt-stack: lab/asm-hive/crt-stack.s
	gcc $< -g -o $@

$(BUILDDIR)/nocrt-hello: lab/asm-hive/nocrt-hello.s
	as $< -g -o $(BUILDDIR)/nocrt-hello.o
	ld $(BUILDDIR)/nocrt-hello.o -g -o $@

$(BUILDDIR)/nocrt-hello-nasm: lab/asm-hive/nocrt-hello-nasm.s
	nasm -f elf64 $< -g -o $(BUILDDIR)/nocrt-hello-nasm.o
	ld $(BUILDDIR)/nocrt-hello-nasm.o -g -o $@

$(BUILDDIR)/nocrt-jmp-func: lab/asm-hive/nocrt-jmp-func.s
	as $< -g -o $(BUILDDIR)/nocrt-jmp-func.o
	ld $(BUILDDIR)/nocrt-jmp-func.o -g -o $@

$(BUILDDIR)/nocrt-call-func: lab/asm-hive/nocrt-call-func.s
	as $< -g -o $(BUILDDIR)/nocrt-call-func.o
	ld $(BUILDDIR)/nocrt-call-func.o -g -o $@

$(BUILDDIR)/nocrt-rep: lab/asm-hive/nocrt-rep.s
	as $< -g -o $(BUILDDIR)/nocrt-rep.o
	ld $(BUILDDIR)/nocrt-rep.o -g -o $@

$(BUILDDIR)/crt-cmp: lab/asm-hive/crt-cmp.s
	gcc $< -g -o $@

$(BUILDDIR)/crt-loop: lab/asm-hive/crt-loop.s
	gcc $< -g -o $@

$(BUILDDIR)/crt-lea-array: lab/asm-hive/crt-lea-array.s
	gcc $< -g -o $@

$(BUILDDIR)/msf-msg.exe: lab/shellcode/shc.c
	x86_64-w64-mingw32-gcc $< -g -o $@

$(BUILDDIR)/bof-server-no-pie: lab/buffer-overflow/bof-server.c
	gcc $< -g -o $@

$(BUILDDIR)/bof-server-pie: lab/buffer-overflow/bof-server.c
	gcc $< -g -fPIE -pie -o $@

clean:
	rm -rf $(BUILDDIR)
	cargo clean
