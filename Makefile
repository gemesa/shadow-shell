BUILDDIR = build

.PHONY: build clean

build:
	mkdir -p $(BUILDDIR)
	gcc lab/crt-hello.s -o $(BUILDDIR)/crt-hello

	as lab/nocrt-hello.s -o $(BUILDDIR)/nocrt-hello.o
	ld $(BUILDDIR)/nocrt-hello.o -o $(BUILDDIR)/nocrt-hello

	as lab/nocrt-jmp-func.s -o $(BUILDDIR)/nocrt-jmp-func.o
	ld $(BUILDDIR)/nocrt-jmp-func.o -o $(BUILDDIR)/nocrt-jmp-func

	as lab/nocrt-call-func.s -o $(BUILDDIR)/nocrt-call-func.o
	ld $(BUILDDIR)/nocrt-call-func.o -o $(BUILDDIR)/nocrt-call-func

clean:
	rm -rf $(BUILDDIR)
