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
$(BUILDDIR)/bof-server-pie \
$(BUILDDIR)/bof-server-no-pie2 \
$(BUILDDIR)/bof-server-pie2 \
$(BUILDDIR)/dyn \
$(BUILDDIR)/dyn2 \
$(BUILDDIR)/version.res \
$(BUILDDIR)/msf-msg-rsrc.exe

cargo-build:
	cargo build --target x86_64-pc-windows-gnu --manifest-path lab/shellcode/shc/Cargo.toml
	cargo build --target x86_64-unknown-linux-gnu --manifest-path lab/frida/Cargo.toml

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

$(BUILDDIR)/bof-server-no-pie2: lab/buffer-overflow/bof-server2.c
	gcc $< -g -o $@ -fno-stack-protector -z execstack

$(BUILDDIR)/bof-server-pie2: lab/buffer-overflow/bof-server2.c
	gcc $< -g -fPIE -pie -o $@ -fno-stack-protector -z execstack

$(BUILDDIR)/dyn: lab/frida/dyn.c
	gcc $< -g -o $@

$(BUILDDIR)/dyn2: lab/frida/dyn2.c
	gcc $< -g -o $@

$(BUILDDIR)/version.res: lab/rsrc/version.rc
	x86_64-w64-mingw32-windres $< -O coff -o $@

$(BUILDDIR)/msf-msg-rsrc.exe: lab/shellcode/shc.c $(BUILDDIR)/version.res
	x86_64-w64-mingw32-gcc $^ -g -o $@

clean:
	rm -rf $(BUILDDIR)
	cargo clean
