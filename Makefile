prefix = $(HOME)/.local/share

all: src/characters.json

src/characters.json:
	python3 -m venv .venv
	.venv/bin/pip install emoji
	.venv/bin/python scripts/characters

build: src/main.rs
	@if [ -f vendor.tar ]; then \
		echo "vendor.tar found, extracting and building offline..."; \
		tar -xf vendor.tar; \
		cargo build --release --offline; \
	else \
		echo "vendor.tar not found, building online..."; \
		cargo build --release; \
	fi

install: src/characters.json build
	install -Dm0644 src/*json src/plugin.ron \
		-t $(DESTDIR)$(prefix)/pop-launcher/plugins/uni/

	install -Dm0755 target/release/uni \
		-t $(DESTDIR)$(prefix)/pop-launcher/plugins/uni/

vendor: src/characters.json
	mkdir -p .cargo
	cargo vendor | head -n -1 > .cargo/config.toml
	echo 'directory = "vendor"' >> .cargo/config.toml
	tar pcf vendor.tar vendor
	rm -rf vendor .venv

clean:
	-rm -rf target vendor .venv

distclean: clean

uninstall:
	-rm -rf $(DESTDIR)$(prefix)/pop-launcher/plugins/uni

.PHONY: all install clean distclean uninstall 