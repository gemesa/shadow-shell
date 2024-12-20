BUILDDIR = build

$(shell mkdir -p $(BUILDDIR))
$(shell mkdir -p $(BUILDDIR)/linux)
$(shell mkdir -p $(BUILDDIR)/linux/x64)
$(shell mkdir -p $(BUILDDIR)/linux/arm64)
$(shell mkdir -p $(BUILDDIR)/linux/arm64x)
$(shell mkdir -p $(BUILDDIR)/windows)

.PHONY: arm64 arm64x x64 clean cargo-build

arm64: \
$(BUILDDIR)/linux/arm64/shexec \
$(BUILDDIR)/linux/arm64/nocrt-hello \
$(BUILDDIR)/linux/arm64/shcode_hello \
$(BUILDDIR)/linux/arm64/shcode_shell \

arm64x: \
$(BUILDDIR)/linux/arm64x/shexec \
$(BUILDDIR)/linux/arm64x/nocrt-hello \
$(BUILDDIR)/linux/arm64x/shcode_hello \
$(BUILDDIR)/linux/arm64x/shcode_shell \

x64: \
cargo-build \
$(BUILDDIR)/linux/x64/crt-hello \
$(BUILDDIR)/linux/x64/crt-stack \
$(BUILDDIR)/linux/x64/nocrt-hello \
$(BUILDDIR)/linux/x64/nocrt-hello-nasm \
$(BUILDDIR)/linux/x64/nocrt-jmp-func \
$(BUILDDIR)/linux/x64/nocrt-call-func \
$(BUILDDIR)/linux/x64/nocrt-rep \
$(BUILDDIR)/linux/x64/nocrt-args \
$(BUILDDIR)/linux/x64/crt-cmp \
$(BUILDDIR)/linux/x64/crt-loop \
$(BUILDDIR)/linux/x64/crt-lea-array \
$(BUILDDIR)/linux/x64/crt-args \
$(BUILDDIR)/linux/bof-server-no-pie \
$(BUILDDIR)/linux/bof-server-pie \
$(BUILDDIR)/linux/bof-server-no-pie2 \
$(BUILDDIR)/linux/bof-server-pie2 \
$(BUILDDIR)/linux/dyn \
$(BUILDDIR)/linux/dyn2 \
$(BUILDDIR)/linux/fstat \
$(BUILDDIR)/linux/x64/shexec \
$(BUILDDIR)/linux/x64/shcode_hello \
$(BUILDDIR)/windows/msf-msg.exe \
$(BUILDDIR)/windows/version.res \
$(BUILDDIR)/windows/msf-msg-rsrc.exe \
$(BUILDDIR)/windows/shexec.exe \

cargo-build:
	cargo build --target x86_64-pc-windows-gnu --manifest-path lab/windows/shellcode/shc/Cargo.toml
	cargo build --target x86_64-unknown-linux-gnu --manifest-path lab/linux/frida/Cargo.toml

$(BUILDDIR)/linux/arm64/shexec: arsenal/linux/arm64/shexec.s
	gcc $< -g -o $@ -pie

$(BUILDDIR)/linux/arm64/nocrt-hello: lab/linux/asm-hive/arm64/nocrt-hello.s
	as $< -g -o $(BUILDDIR)/linux/arm64/nocrt-hello.o
	ld $(BUILDDIR)/linux/arm64/nocrt-hello.o -g -o $@

$(BUILDDIR)/linux/arm64/shcode_hello: arsenal/linux/arm64/shcode_hello.s
	as $< -g -o $(BUILDDIR)/linux/arm64/shcode_hello.o
	ld $(BUILDDIR)/linux/arm64/shcode_hello.o -g -o $@
	llvm-objcopy -O binary --only-section=.text $@ $(BUILDDIR)/linux/arm64/shcode_hello.bin

$(BUILDDIR)/linux/arm64/shcode_shell: arsenal/linux/arm64/shcode_shell.s
	as $< -g -o $(BUILDDIR)/linux/arm64/shcode_shell.o
	ld $(BUILDDIR)/linux/arm64/shcode_shell.o -g -o $@
	llvm-objcopy -O binary --only-section=.text $@ $(BUILDDIR)/linux/arm64/shcode_shell.bin

$(BUILDDIR)/linux/arm64x/shexec: arsenal/linux/arm64/shexec.s
	aarch64-linux-gnu-gcc $< -g -o $@ -pie -L /usr/aarch64-redhat-linux/sys-root/fc41/lib64 -L /usr/aarch64-redhat-linux/sys-root/fc41/lib --sysroot=/usr/aarch64-redhat-linux/sys-root/fc41

$(BUILDDIR)/linux/arm64x/nocrt-hello: lab/linux/asm-hive/arm64/nocrt-hello.s
	aarch64-linux-gnu-as $< -g -o $(BUILDDIR)/linux/arm64x/nocrt-hello.o
	aarch64-linux-gnu-ld $(BUILDDIR)/linux/arm64x/nocrt-hello.o -g -o $@

$(BUILDDIR)/linux/arm64x/shcode_hello: arsenal/linux/arm64/shcode_hello.s
	aarch64-linux-gnu-as $< -g -o $(BUILDDIR)/linux/arm64x/shcode_hello.o
	aarch64-linux-gnu-ld $(BUILDDIR)/linux/arm64x/shcode_hello.o -g -o $@
	llvm-objcopy -O binary --only-section=.text $@ $(BUILDDIR)/linux/arm64x/shcode_hello.bin

$(BUILDDIR)/linux/arm64x/shcode_shell: arsenal/linux/arm64/shcode_shell.s
	aarch64-linux-gnu-as $< -g -o $(BUILDDIR)/linux/arm64x/shcode_shell.o
	aarch64-linux-gnu-ld $(BUILDDIR)/linux/arm64x/shcode_shell.o -g -o $@
	llvm-objcopy -O binary --only-section=.text $@ $(BUILDDIR)/linux/arm64x/shcode_shell.bin

$(BUILDDIR)/linux/x64/crt-hello: lab/linux/asm-hive/x64/crt-hello.s
	gcc $< -fPIE -pie -g -o $@

$(BUILDDIR)/linux/x64/crt-stack: lab/linux/asm-hive/x64/crt-stack.s
	gcc $< -fPIE -pie -g -o $@

$(BUILDDIR)/linux/x64/nocrt-hello: lab/linux/asm-hive/x64/nocrt-hello.s
	as $< -g -o $(BUILDDIR)/linux/x64/nocrt-hello.o
	ld $(BUILDDIR)/linux/x64/nocrt-hello.o -g -o $@

$(BUILDDIR)/linux/x64/nocrt-hello-nasm: lab/linux/asm-hive/x64/nocrt-hello-nasm.s
	nasm -f elf64 $< -g -o $(BUILDDIR)/linux/x64/nocrt-hello-nasm.o
	ld $(BUILDDIR)/linux/x64/nocrt-hello-nasm.o -g -o $@

$(BUILDDIR)/linux/x64/nocrt-jmp-func: lab/linux/asm-hive/x64/nocrt-jmp-func.s
	as $< -g -o $(BUILDDIR)/linux/x64/nocrt-jmp-func.o
	ld $(BUILDDIR)/linux/x64/nocrt-jmp-func.o -g -o $@

$(BUILDDIR)/linux/x64/nocrt-call-func: lab/linux/asm-hive/x64/nocrt-call-func.s
	as $< -g -o $(BUILDDIR)/linux/x64/nocrt-call-func.o
	ld $(BUILDDIR)/linux/x64/nocrt-call-func.o -g -o $@

$(BUILDDIR)/linux/x64/nocrt-rep: lab/linux/asm-hive/x64/nocrt-rep.s
	as $< -g -o $(BUILDDIR)/linux/x64/nocrt-rep.o
	ld $(BUILDDIR)/linux/x64/nocrt-rep.o -g -o $@

$(BUILDDIR)/linux/x64/nocrt-args: lab/linux/asm-hive/x64/nocrt-args.s
	as $< -g -o $(BUILDDIR)/linux/x64/nocrt-args.o
	ld $(BUILDDIR)/linux/x64/nocrt-args.o -g -o $@

$(BUILDDIR)/linux/x64/crt-cmp: lab/linux/asm-hive/x64/crt-cmp.s
	gcc $< -fPIE -pie -g -o $@

$(BUILDDIR)/linux/x64/crt-loop: lab/linux/asm-hive/x64/crt-loop.s
	gcc $< -fPIE -pie -g -o $@

$(BUILDDIR)/linux/x64/crt-lea-array: lab/linux/asm-hive/x64/crt-lea-array.s
	gcc $< -fPIE -pie -g -o $@

$(BUILDDIR)/linux/x64/crt-args: lab/linux/asm-hive/x64/crt-args.s
	gcc $< -g -o $@

$(BUILDDIR)/linux/bof-server-no-pie: lab/linux/buffer-overflow/bof-server.c
	gcc $< -g -o $@

$(BUILDDIR)/linux/bof-server-pie: lab/linux/buffer-overflow/bof-server.c
	gcc $< -g -fPIE -pie -o $@

$(BUILDDIR)/linux/bof-server-no-pie2: lab/linux/buffer-overflow/bof-server2.c
	gcc $< -g -o $@ -fno-stack-protector -z execstack

$(BUILDDIR)/linux/bof-server-pie2: lab/linux/buffer-overflow/bof-server2.c
	gcc $< -g -fPIE -pie -o $@ -fno-stack-protector -z execstack

$(BUILDDIR)/linux/dyn: lab/linux/frida/dyn.c
	gcc $< -g -o $@

$(BUILDDIR)/linux/dyn2: lab/linux/frida/dyn2.c
	gcc $< -g -o $@

$(BUILDDIR)/linux/fstat: lab/linux/util/fstat.c
	gcc $< -g -o $@

$(BUILDDIR)/linux/x64/shexec: arsenal/linux/x64/shexec.s
	gcc $< -g -o $@ -pie

$(BUILDDIR)/linux/x64/shcode_hello: arsenal/linux/x64/shcode_hello.s
	as $< -g -o $(BUILDDIR)/linux/x64/shcode_hello.o
	ld $(BUILDDIR)/linux/x64/shcode_hello.o -g -o $@
	llvm-objcopy -O binary --only-section=.text $@ $(BUILDDIR)/linux/x64/shcode_hello.bin

$(BUILDDIR)/windows/msf-msg.exe: lab/windows/shellcode/shc.c
	x86_64-w64-mingw32-gcc $< -g -o $@

$(BUILDDIR)/windows/version.res: lab/windows/rsrc/version.rc
	x86_64-w64-mingw32-windres $< -O coff -o $@

$(BUILDDIR)/windows/msf-msg-rsrc.exe: lab/windows/shellcode/shc.c $(BUILDDIR)/windows/version.res
	x86_64-w64-mingw32-gcc $^ -g -o $@

$(BUILDDIR)/windows/shexec.exe: arsenal/windows/shexec.c
	x86_64-w64-mingw32-gcc $< -g -o $@

clean:
	rm -rf $(BUILDDIR)
	cargo clean
