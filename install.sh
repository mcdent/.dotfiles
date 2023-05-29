#!/bin/bash
# set locale, stops the warnings from perl. (needs fixing)
export LC_ALL="en_GB.UTF-8"
export LANG="en_GB.UTF-8"
export LANGUAGE="en_GB.UTF-8"
# Check to see if nix is already installed.
if [[ -f /nix/receipt.json || -d /nix ]]; then
    echo "Looks like Nix is already installed..."
    read -r -p "Do you want to continue with the rest of the script, omitting the Nix install? (Y/n): " decision
    if [[ $decision != "Y" && $decision != "y" ]]; then
        echo "Aborting."
        exit 0
    fi
else
    echo "Looks like Nix has not been installed."
    read -r -p "Do you want to install Nix? (Y/n): " decision
    if [[ $decision != "Y" && $decision != "y" ]]; then
        echo "Aborting."
        exit 0
    fi

    # Proceed with Nix installation
    curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix/tag/v0.9.0 | sh -s -- install
    # source nix
    . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
fi

read -r -p "Do you want to continue with package installation? (Y/n): " decision
if [[ $decision != "Y" && $decision != "y" ]]; then
    echo "Aborting, done, no packages to install!..."
    exit 0
fi

if [[ $(uname -s) =~ "Darwin" ]]; then
    read -r -p "We have detected you are running MacOS/Darwin, is this correct? (Y/n): " decision
        if [[ $decision != "Y" && $decision != "y" ]]; then
            echo "Aborting, something is afoot!..."
            exit 0
        fi
# continue with MacOS/Darwin packages here.
# (add any packages to install on MacOS/Darwin here, this may just
# be a copy of the ones below, although you likely don't need zsh.
 # install packages
echo "Installing MacOS packages..."
sleep 1
  nix profile install \
       nixpkgs#git \
       nixpkgs#kitty \
       nixpkgs#neovim \
       nixpkgs#tmux \
       nixpkgs#stow \
       nixpkgs#yarn \
       nixpkgs#fzf \
       nixpkgs#ripgrep \
       nixpkgs#bat \
       nixpkgs#gnumake \
       nixpkgs#gcc \
       nixpkgs#direnv \
       nixpkgs#trash-cli \
       nixpkgs#nodePackages_latest.bash-language-server \
       nixpkgs#yaml-language-server \
       nixpkgs#xclip \
       nixpkgs#nodejs-18_x \
       nixpkgs#nodePackages_latest.prettier \
       nixpkgs#shellcheck

  sleep 2
  # stow dotfiles
  stow git
  stow nvim
  stow tmux
  stow zsh
  stow kitty

fi

if [[ $(uname -s) =~ "Linux" ]]; then
      read -r -p "We have detected you are Linux, is this correct? (Y/n): " decision
          if [[ $decision != "Y" && $decision != "y" ]]; then
              echo "Aborting, something is afoot!..."
              exit 0
          fi
# Continue with package installation here
echo "Installing Linux packages...(you may receive some warnings about locale, ignore)..."
sleep 3
# install packages specific to Linux here.
nix profile install \
    nixpkgs#zsh \
     nixpkgs#git \
     nixpkgs#neovim \
     nixpkgs#tmux \
     nixpkgs#stow \
     nixpkgs#yarn \
     nixpkgs#fzf \
     nixpkgs#ripgrep \
     nixpkgs#bat \
     nixpkgs#gnumake \
     nixpkgs#gcc \
     nixpkgs#direnv \
     nixpkgs#trash-cli \
     nixpkgs#nodePackages_latest.bash-language-server \
     nixpkgs#yaml-language-server \
     nixpkgs#xclip \
     nixpkgs#nodejs-18_x \
     nixpkgs#nodePackages_latest.prettier \
     nixpkgs#shellcheck
sleep 2
# stow dotfiles
stow git
stow nvim
stow tmux
stow zsh

fi
# add zsh as a login shell but first check
# if the line already exists. This can happen
# if we run the install script multiple times.
if command -v zsh >/dev/null; then
    zsh_path=$(command -v zsh)

    # Check if zsh path already exists in /etc/shells
    if ! grep -Fxq "$zsh_path" /etc/shells; then
        echo "$zsh_path" | sudo tee -a /etc/shells
        echo -e "\e[1mZsh path has been added to /etc/shells.\e[0m"
    else
        echo -e "\e[1mZsh path already exists in /etc/shells.\e[0m"
    fi
else
    echo -e "\e[1mZsh is not installed.\e[0m"
fi
# Create a symlink of our ~/.bin folder
ln -sf "$HOME/.dotfiles/bin" "$HOME/.bin"
# use zsh as default shell
sudo chsh -s "$(which zsh)" "$USER"

# Pull down Antidote, which is a zsh package manager. (replaces Antibody)
echo "Installing/configuring antidote..."
git clone --depth=1 https://github.com/mattmc3/antidote.git ${ZDOTDIR:-~}/.antidote
chmod +x ~/.antidote/antidote && sed -i "1s|.*|#\!$SHELL|" ~/.antidote/antidote && ln -sfT ~/.antidote/antidote ~/.bin/antidote
sleep 1
antidote bundle < ~/.zsh_plugins.txt > ~/.zsh_plugins.sh

# install neovim plugins
echo "You may see some errors below as we try to install the NeoVim plugins, do not be alarmed!"
sleep 2
nvim --headless +PlugInstall +qall
#
echo "Almost done. Please log out and back in again to configure zsh etc."
echo "You may also need to open neovim to complete Plugin installation."
