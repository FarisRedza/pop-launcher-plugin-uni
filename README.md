# pop-launcher-plugin-uni
A unicode character search plugin for [pop-launcher](https://github.com/pop-os/launcher). Useful for searching for special characters and emojis

### Dependencies
[xclip](https://github.com/astrand/xclip)\
Required for copying to clipboard\
Debian/Ubuntu and derivatives - `sudo apt install xclip`\
Nix package - `nix-env -iA nixpkgs.xclip`

### Installation
For user install, clone the repo and run `make install` in the repo's folder\
Run `make uninstall` in this folder to uninstall the plugin

To install system-wide, download and install the deb package

Run `make json_file` to update the list of unicode characters. This uses a [venv](https://docs.python.org/3/library/venv.html) python virtual environment to run a script to generate the file
Debian/Ubuntu and derivatives - `sudo apt install python3-venv`

### Usage
In pop launcher type uni followed by your query to search for the closest matching character. Pressing enter copies the result into the clipboard.
