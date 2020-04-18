TOOL_NAME = dazzle
VERSION = 0.1

PREFIX = /usr/local
INSTALL_PATH = $(PREFIX)/bin/$(TOOL_NAME)
SHARE_PATH = $(PREFIX)/share/$(TOOL_NAME)
BUILD_PATH = .build/release/$(TOOL_NAME)
CURRENT_PATH = $(PWD)

build:
	swift build --disable-sandbox -c release

install: build
	mkdir -p $(PREFIX)/bin
	cp -f $(BUILD_PATH) $(INSTALL_PATH)
	mkdir -p $(SHARE_PATH)
	cp -R $(CURRENT_PATH)/Templates $(SHARE_PATH)

uninstall:
	rm -f $(INSTALL_PATH)
	rm -f $(SHARE_PATH)

