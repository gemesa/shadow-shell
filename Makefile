BUILDDIR = build

$(shell mkdir -p $(BUILDDIR))
$(shell mkdir -p $(BUILDDIR)/x64)

.PHONY: all clean cargo-build

all: cargo-build \
$(BUILDDIR)/x64/crt-hello \
$(BUILDDIR)/x64/crt-stack \
$(BUILDDIR)/x64/nocrt-hello \
$(BUILDDIR)/x64/nocrt-hello-nasm \
$(BUILDDIR)/x64/nocrt-jmp-func \
$(BUILDDIR)/x64/nocrt-call-func \
$(BUILDDIR)/x64/nocrt-rep \
$(BUILDDIR)/x64/nocrt-args \
$(BUILDDIR)/x64/crt-cmp \
$(BUILDDIR)/x64/crt-loop \
$(BUILDDIR)/x64/crt-lea-array \
$(BUILDDIR)/x64/crt-args \
$(BUILDDIR)/msf-msg.exe \
$(BUILDDIR)/bof-server-no-pie \
$(BUILDDIR)/bof-server-pie \
$(BUILDDIR)/bof-server-no-pie2 \
$(BUILDDIR)/bof-server-pie2 \
$(BUILDDIR)/dyn \
$(BUILDDIR)/dyn2 \
$(BUILDDIR)/version.res \
$(BUILDDIR)/msf-msg-rsrc.exe\
$(BUILDDIR)/x64/shexec \
$(BUILDDIR)/fstat \

cargo-build:
	cargo build --target x86_64-pc-windows-gnu --manifest-path lab/shellcode/shc/Cargo.toml
	cargo build --target x86_64-unknown-linux-gnu --manifest-path lab/frida/Cargo.toml

$(BUILDDIR)/x64/crt-hello: lab/asm-hive/x64/crt-hello.s
	gcc $< -g -o $@

$(BUILDDIR)/x64/crt-stack: lab/asm-hive/x64/crt-stack.s
	gcc $< -g -o $@

$(BUILDDIR)/x64/nocrt-hello: lab/asm-hive/x64/nocrt-hello.s
	as $< -g -o $(BUILDDIR)/x64/nocrt-hello.o
	ld $(BUILDDIR)/x64/nocrt-hello.o -g -o $@

$(BUILDDIR)/x64/nocrt-hello-nasm: lab/asm-hive/x64/nocrt-hello-nasm.s
	nasm -f elf64 $< -g -o $(BUILDDIR)/x64/nocrt-hello-nasm.o
	ld $(BUILDDIR)/x64/nocrt-hello-nasm.o -g -o $@

$(BUILDDIR)/x64/nocrt-jmp-func: lab/asm-hive/x64/nocrt-jmp-func.s
	as $< -g -o $(BUILDDIR)/x64/nocrt-jmp-func.o
	ld $(BUILDDIR)/x64/nocrt-jmp-func.o -g -o $@

$(BUILDDIR)/x64/nocrt-call-func: lab/asm-hive/x64/nocrt-call-func.s
	as $< -g -o $(BUILDDIR)/x64/nocrt-call-func.o
	ld $(BUILDDIR)/x64/nocrt-call-func.o -g -o $@

$(BUILDDIR)/x64/nocrt-rep: lab/asm-hive/x64/nocrt-rep.s
	as $< -g -o $(BUILDDIR)/x64/nocrt-rep.o
	ld $(BUILDDIR)/x64/nocrt-rep.o -g -o $@

$(BUILDDIR)/x64/nocrt-args: lab/asm-hive/x64/nocrt-args.s
	as $< -g -o $(BUILDDIR)/x64/nocrt-args.o
	ld $(BUILDDIR)/x64/nocrt-args.o -g -o $@

$(BUILDDIR)/x64/crt-cmp: lab/asm-hive/x64/crt-cmp.s
	gcc $< -g -o $@

$(BUILDDIR)/x64/crt-loop: lab/asm-hive/x64/crt-loop.s
	gcc $< -g -o $@

$(BUILDDIR)/x64/crt-lea-array: lab/asm-hive/x64/crt-lea-array.s
	gcc $< -g -o $@

$(BUILDDIR)/x64/crt-args: lab/asm-hive/x64/crt-args.s
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

$(BUILDDIR)/x64/shexec: arsenal/x64/shexec.s
	gcc $< -g -o $@ -pie

$(BUILDDIR)/fstat: lab/util/fstat.c
	gcc $< -g -o $@

clean:
	rm -rf $(BUILDDIR)
	cargo clean
