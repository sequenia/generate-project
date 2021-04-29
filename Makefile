prefix ?= /usr/local
bindir = $(prefix)/bin/x86_64-apple-macosx

build:
	swift package clean
	swift build -c release --disable-sandbox

uninstall:
	rm -rf "$(bindir)/project-generate"

clean:
	rm -rf .build

.PHONY: build install uninstall clean
