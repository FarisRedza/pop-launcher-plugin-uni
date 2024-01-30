PLUGIN_NAME = uni
PLUGIN_VERSION = 0.1

LOCAL_PLUGIN_DIR = $(HOME)/.local/share/pop-launcher/plugins/

BIN_DIR = usr/lib/pop-launcher/plugins/$(PLUGIN_NAME)/
PKG_NAME = pop-launcher-plugin-$(PLUGIN_NAME)_$(PLUGIN_VERSION)-1_all.deb

VENV_PATH = .venv/bin/
VENV_PYTHON = $(VENV_PATH)/python
VENV_PIP = $(VENV_PATH)/pip

install:
	mkdir -p $(LOCAL_PLUGIN_DIR)/$(PLUGIN_NAME)/
	cp -r src/* $(LOCAL_PLUGIN_DIR)/$(PLUGIN_NAME)
	chmod +x $(LOCAL_PLUGIN_DIR)/$(PLUGIN_NAME)

deb_package:
	mkdir -p PKG_SOURCE/$(BIN_DIR)/
	cp -r debian PKG_SOURCE/DEBIAN
	cp -r src/* PKG_SOURCE/$(BIN_DIR)
	dpkg-deb --root-owner-group --build PKG_SOURCE $(PKG_NAME)
	rm -r PKG_SOURCE

json_file:
	python3 -m venv .venv
	$(VENV_PIP) install emoji
	$(VENV_PYTHON) characters.py