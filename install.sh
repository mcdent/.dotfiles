# install nix
curl -L https://nixos.org/nix/install | sh

# source nix
. ~/.nix-profile/etc/profile.d/nix.sh

# install packages
nix-env -iA \
	nixpkgs.zsh \
	nixpkgs.antibody \
	nixpkgs.git \
	nixpkgs.neovim \
	nixpkgs.tmux \
	nixpkgs.stow \
	nixpkgs.yarn \
	nixpkgs.fzf \
	nixpkgs.ripgrep \
	nixpkgs.bat \
	nixpkgs.gnumake \
	nixpkgs.gcc \
	nixpkgs.direnv \
	nixpkgs.trash-cli \
    nixpkgs.nodePackages_latest.bash-language-server \
    nixpkgs.xclip \
    nixpkgs.shellcheck

# stow dotfiles
stow git
stow nvim
stow tmux
stow zsh

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

# use zsh as default shell
sudo chsh -s $(which zsh) $USER

# bundle zsh plugins 
antibody bundle < ~/.zsh_plugins.txt > ~/.zsh_plugins.sh

# install neovim plugins
nvim --headless +PlugInstall +qall

# Use kitty terminal on MacOS
# [ `uname -s` = 'Darwin' ] && stow kitty
