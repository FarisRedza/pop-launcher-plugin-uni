PLUGIN_NAME = uni

PLUGIN_DIR = $(HOME)/.local/share/pop-launcher/plugins
PLUGIN = $(PLUGIN_DIR)/$(PLUGIN_NAME)

VENV_PATH = .venv/bin
VENV_PYTHON = $(VENV_PATH)/python
VENV_PIP = $(VENV_PATH)/pip

json_file:
	python3 -m venv .venv
	$(VENV_PIP) install emoji
	$(VENV_PYTHON) characters.py

install:
	mkdir -p $(PLUGIN)
	cp plugin.ron $(PLUGIN)
	cp $(PLUGIN_NAME) $(PLUGIN)
	cp characters.json $(PLUGIN)
	chmod +x $(PLUGIN)/$(PLUGIN_NAME)