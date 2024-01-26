# pop-launcher-plugin-uni
A unicode character search plugin for pop-launcher. Useful for searching for special characters and emojis

### Dependencies
Requires xclip for copying to clipboard\
Debian/Ubuntu and derivatives - `sudo apt install xclip`\
Nix package - `nix-env -iA nixpkgs.xclip`

### Installation
Clone the repo and run `make install`\
Run `make json_file` to update the list of unicode characters. This uses a [venv](https://docs.python.org/3/library/venv.html) python virtual environment to run a script to generate the file
Debian/Ubuntu and derivatives - `sudo apt install python3-venv`

### Usage
In pop launcher type uni followed by your query to search for the closest matching character. Pressing enter copies the result into the clipboard.
