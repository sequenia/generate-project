prefix ?= /usr/local
bindir = $(prefix)/bin

build:
	swift package clean
	swift build -c release --disable-sandbox

install: 
	build
	install ".build/release/projectGenerate" "$(bindir)"

uninstall:
	rm -rf "$(bindir)/projectGenerate"

clean:
	rm -rf .build

.PHONY: build install uninstall clean