BUILDDIR = build

$(shell mkdir -p $(BUILDDIR))
$(shell mkdir -p $(BUILDDIR)/linux)
$(shell mkdir -p $(BUILDDIR)/linux/x64)
$(shell mkdir -p $(BUILDDIR)/linux/arm64)
$(shell mkdir -p $(BUILDDIR)/linux/arm64x)
$(shell mkdir -p $(BUILDDIR)/windows)

.PHONY: arm64 arm64x x64 x64-lab clean cargo-build install-arm64 install-arm64x install-x64 uninstall

arm64: \
$(BUILDDIR)/linux/arm64/shexec \
$(BUILDDIR)/linux/arm64/shcode-hello \
$(BUILDDIR)/linux/arm64/shcode-shell

arm64x: \
$(BUILDDIR)/linux/arm64x/shexec \
$(BUILDDIR)/linux/arm64x/shcode-hello \
$(BUILDDIR)/linux/arm64x/shcode-shell

x64: \
$(BUILDDIR)/linux/x64/shexec \
$(BUILDDIR)/linux/x64/shcode-hello \
$(BUILDDIR)/linux/x64/shcode-shell \
$(BUILDDIR)/windows/shexec.exe \
$(BUILDDIR)/windows/msf-msg.exe

x64-lab: \
cargo-build \
$(BUILDDIR)/linux/dyn \
$(BUILDDIR)/linux/dyn2 \
$(BUILDDIR)/linux/fstat

cargo-build:
	cargo build --target x86_64-pc-windows-gnu --manifest-path lab/windows/shellcode/shc/Cargo.toml
	cargo build --target x86_64-unknown-linux-gnu --manifest-path lab/linux/frida/Cargo.toml

install-arm64:
	cp $(BUILDDIR)/linux/arm64/shexec /usr/local/bin/

install-arm64x:
	cp $(BUILDDIR)/linux/arm64x/shexec /usr/local/bin/

install-x64:
	cp $(BUILDDIR)/linux/x64/shexec /usr/local/bin/

uninstall:
	rm /usr/local/bin/shexec

$(BUILDDIR)/linux/arm64/shexec: arsenal/linux/arm64/shexec.s
	gcc $< -g -o $@ -pie

$(BUILDDIR)/linux/arm64/shcode-hello: arsenal/linux/arm64/shcode-hello.s
	as $< -g -o $(BUILDDIR)/linux/arm64/shcode-hello.o
	ld $(BUILDDIR)/linux/arm64/shcode-hello.o -g -o $@
	llvm-objcopy -O binary --only-section=.text $@ $(BUILDDIR)/linux/arm64/shcode-hello.bin

$(BUILDDIR)/linux/arm64/shcode-shell: arsenal/linux/arm64/shcode-shell.s
	as $< -g -o $(BUILDDIR)/linux/arm64/shcode-shell.o
	ld $(BUILDDIR)/linux/arm64/shcode-shell.o -g -o $@
	llvm-objcopy -O binary --only-section=.text $@ $(BUILDDIR)/linux/arm64/shcode-shell.bin

$(BUILDDIR)/linux/arm64x/shexec: arsenal/linux/arm64/shexec.s
	aarch64-linux-gnu-gcc $< -g -o $@ -pie -L /usr/aarch64-redhat-linux/sys-root/fc41/lib64 -L /usr/aarch64-redhat-linux/sys-root/fc41/lib --sysroot=/usr/aarch64-redhat-linux/sys-root/fc41

$(BUILDDIR)/linux/arm64x/shcode-hello: arsenal/linux/arm64/shcode-hello.s
	aarch64-linux-gnu-as $< -g -o $(BUILDDIR)/linux/arm64x/shcode-hello.o
	aarch64-linux-gnu-ld $(BUILDDIR)/linux/arm64x/shcode-hello.o -g -o $@
	llvm-objcopy -O binary --only-section=.text $@ $(BUILDDIR)/linux/arm64x/shcode-hello.bin

$(BUILDDIR)/linux/arm64x/shcode-shell: arsenal/linux/arm64/shcode-shell.s
	aarch64-linux-gnu-as $< -g -o $(BUILDDIR)/linux/arm64x/shcode-shell.o
	aarch64-linux-gnu-ld $(BUILDDIR)/linux/arm64x/shcode-shell.o -g -o $@
	llvm-objcopy -O binary --only-section=.text $@ $(BUILDDIR)/linux/arm64x/shcode-shell.bin

$(BUILDDIR)/linux/dyn: lab/linux/frida/dyn.c
	gcc $< -g -o $@

$(BUILDDIR)/linux/dyn2: lab/linux/frida/dyn2.c
	gcc $< -g -o $@

$(BUILDDIR)/linux/fstat: lab/linux/util/fstat.c
	gcc $< -g -o $@

$(BUILDDIR)/linux/x64/shexec: arsenal/linux/x64/shexec.s
	gcc $< -g -o $@ -pie

$(BUILDDIR)/linux/x64/shcode-hello: arsenal/linux/x64/shcode-hello.s
	as $< -g -o $(BUILDDIR)/linux/x64/shcode-hello.o
	ld $(BUILDDIR)/linux/x64/shcode-hello.o -g -o $@
	llvm-objcopy -O binary --only-section=.text $@ $(BUILDDIR)/linux/x64/shcode-hello.bin

$(BUILDDIR)/linux/x64/shcode-shell: arsenal/linux/x64/shcode-shell.s
	as $< -g -o $(BUILDDIR)/linux/x64/shcode-shell.o
	ld $(BUILDDIR)/linux/x64/shcode-shell.o -g -o $@
	llvm-objcopy -O binary --only-section=.text $@ $(BUILDDIR)/linux/x64/shcode-shell.bin

$(BUILDDIR)/windows/msf-msg.exe: lab/windows/shellcode/shc.c
	x86_64-w64-mingw32-gcc $< -g -o $@

$(BUILDDIR)/windows/shexec.exe: arsenal/windows/shexec.c
	x86_64-w64-mingw32-gcc $< -g -o $@

clean:
	rm -rf $(BUILDDIR)
	cargo clean
