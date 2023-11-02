BUILDDIR = build

.PHONY: build clean

build:
	mkdir -p $(BUILDDIR)
	gcc lab/hello-puts.s -o $(BUILDDIR)/hello-puts

	as lab/hello-write.s -o $(BUILDDIR)/hello-write.o
	ld $(BUILDDIR)/hello-write.o -o $(BUILDDIR)/hello-write

clean:
	rm -rf $(BUILDDIR)
