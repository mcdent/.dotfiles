# .dotfiles
This script is designed to install nix package manager and several packages. It should then setup some
links to config files and configure zsh and neovim.
It should try to detect platform you are installing on, either linux or MacOS and will
install differnt packages if required.

WARNING! Make sure you have access to the host you are running this on, as a different user/account, in case you
lock yourself out! 

1. Clone this repository
2. Run `install.sh`
3. Open up new window to initiate `zsh` shell

### Current issues

- installing `nvim` plugins in `--headless` causes error output, but doesn't break installation
- Would like to improve the install script
- Handle installation on different OS (MacOS, Linux, WSL2)

### Future optimizations

- Improve install script by automating step 3 above, initializing the `zsh` environment.
