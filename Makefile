BUILDDIR = build

.PHONY: build clean

build:
	mkdir -p $(BUILDDIR)
	gcc lab/crt-hello.s -o $(BUILDDIR)/crt-hello

	as lab/nocrt-hello.s -o $(BUILDDIR)/nocrt-hello.o
	ld $(BUILDDIR)/nocrt-hello.o -o $(BUILDDIR)/nocrt-hello

clean:
	rm -rf $(BUILDDIR)
