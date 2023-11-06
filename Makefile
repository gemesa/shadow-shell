BUILDDIR = build

.PHONY: build clean

build:
	mkdir -p $(BUILDDIR)
	gcc lab/crt-hello.s -o $(BUILDDIR)/crt-hello

	gcc lab/crt-stack.s -o $(BUILDDIR)/crt-stack

	as lab/nocrt-hello.s -o $(BUILDDIR)/nocrt-hello.o
	ld $(BUILDDIR)/nocrt-hello.o -o $(BUILDDIR)/nocrt-hello

	as lab/nocrt-jmp-func.s -o $(BUILDDIR)/nocrt-jmp-func.o
	ld $(BUILDDIR)/nocrt-jmp-func.o -o $(BUILDDIR)/nocrt-jmp-func

	as lab/nocrt-call-func.s -o $(BUILDDIR)/nocrt-call-func.o
	ld $(BUILDDIR)/nocrt-call-func.o -o $(BUILDDIR)/nocrt-call-func

	gcc lab/crt-cmp.s -o $(BUILDDIR)/crt-cmp

	gcc lab/crt-loop.s -o $(BUILDDIR)/crt-loop

	gcc lab/crt-lea-array.s -o $(BUILDDIR)/crt-lea-array

clean:
	rm -rf $(BUILDDIR)
