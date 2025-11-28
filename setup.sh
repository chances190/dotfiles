#!/bin/bash
set -euo pipefail

sudo pacman -Syu --noconfirm 

# Install paru (AUR helper) and verify
if ! command -v paru &> /dev/null; then
    echo "Installing paru..."
    sudo pacman -S --noconfirm --needed git base-devel
    git clone https://aur.archlinux.org/paru.git /tmp/paru
    cd /tmp/paru
    makepkg -si --noconfirm || { echo "Failed to build/install paru."; exit 1; }
    cd -
    rm -rf /tmp/paru
else
    echo "paru is already installed."
fi

packages=(
    uutils-coreutils
    unifetch
    tree
    micro
    python
    reflector
    stow
    zsh
    zsh-autosuggestions 
    zsh-fast-syntax-highlighting
    # zsh-shift-select # Not in the AUR yet. TODO: Submit PKGBUILD to the AUR
    fzf
    fzf-tab-git
    starship
    ripgrep
    zoxide
    eza
    bat
    curlie
    tealdeer
    fd
    hyperfine
    trash-cli
)

# Install all packages (official & AUR) in one go
echo "Installing Packages..."
paru -S --noconfirm --needed "${packages[@]}"

# Change default shell to zsh if installed
if which zsh &> /dev/null; then
    echo "Changing default shell to zsh..."
    chsh -s "$(which zsh)"
    exec zsh
else
    echo "zsh was not installed properly, aborting."
    exit 1
fi

source sync.sh

