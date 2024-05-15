prefix = $(HOME)/.local/share

all: src/characters.json

src/characters.json: src/uni
	python3 -m venv .venv
	.venv/bin/pip install emoji
	.venv/bin/python scripts/characters

install: src/characters.json
	install -Dm0644 src/*json src/plugin.ron \
		-t $(DESTDIR)$(prefix)/pop-launcher/plugins/uni/

	install -Dm0755 src/uni -t $(DESTDIR)$(prefix)/pop-launcher/plugins/uni/

clean:
	-rm -rf .venv

distclean: clean

uninstall:
	-rm -rf $(DESTDIR)$(prefix)/pop-launcher/plugins/uni

.PHONY: all install clean distclean uninstall 