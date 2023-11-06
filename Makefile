BUILDDIR = build

.PHONY: build clean

build:
	mkdir -p $(BUILDDIR)
	gcc lab/crt-hello.s -g -o $(BUILDDIR)/crt-hello

	gcc lab/crt-stack.s -g -o $(BUILDDIR)/crt-stack

	as lab/nocrt-hello.s -g -o $(BUILDDIR)/nocrt-hello.o
	ld $(BUILDDIR)/nocrt-hello.o -g -o $(BUILDDIR)/nocrt-hello

	as lab/nocrt-jmp-func.s -g -o $(BUILDDIR)/nocrt-jmp-func.o
	ld $(BUILDDIR)/nocrt-jmp-func.o -g -o $(BUILDDIR)/nocrt-jmp-func

	as lab/nocrt-call-func.s -g -o $(BUILDDIR)/nocrt-call-func.o
	ld $(BUILDDIR)/nocrt-call-func.o -g -o $(BUILDDIR)/nocrt-call-func

	gcc lab/crt-cmp.s -g -o $(BUILDDIR)/crt-cmp

	gcc lab/crt-loop.s -g -o $(BUILDDIR)/crt-loop

	gcc lab/crt-lea-array.s -g -o $(BUILDDIR)/crt-lea-array

clean:
	rm -rf $(BUILDDIR)
