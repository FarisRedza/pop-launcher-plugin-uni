PLUGIN_NAME = uni

PLUGIN_DIR = $(HOME)/.local/share/pop-launcher/plugins
PLUGIN = $(PLUGIN_DIR)/$(PLUGIN_NAME)

install:
	mkdir -p $(PLUGIN)
	cp plugin.ron $(PLUGIN)
	cp $(PLUGIN_NAME) $(PLUGIN)
	cp characters.json $(PLUGIN)
	chmod +x $(PLUGIN)/$(PLUGIN_NAME)