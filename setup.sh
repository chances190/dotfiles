#!/bin/bash
set -euo pipefail

sudo pacman -Syu --noconfirm

# Set up paru (AUR helper)
if ! command -v paru &> /dev/null; then
    echo "Installing paru..."
    sudo pacman -S --noconfirm --needed base-devel 
    git clone https://aur.archlinux.org/paru.git
    cd paru
    makepkg -si --noconfirm
    cd ..
    rm -rf paru
else
    echo "paru is already installed."
fi

packages=(
    uutils-coreutils
    git
    neofetch
    micro
    python
    reflector
    stow
    zsh
    zsh-autosuggestions 
    zsh-fast-syntax-highlighting
    zsh-shift-select
    fzf
    fzf-tab-git
    starship
    ripgrep
    zoxide
    eza
    bat
    curlies
    tealdeer
    fd
    hyperfine
)

# Install all packages (official & AUR) in one go
echo "Installing Packages..."
paru -S --noconfirm --needed "${packages[@]}"


source ./handle_ssh.sh && decrypt_ssh

# Apply GNU Stow to your dotfiles
cd dotfiles
stow --target="$HOME" --ignore '.*encrypted/.*' --dotfiles --no-folding --adopt --restow *
cd ..

# Detect modified files in the dotfiles folder
modified_files=$(git status --porcelain -- dotfiles | awk '{print $2}' | sed 's|^dotfiles/||')
if [[ -n "$modified_files" ]]; then
    echo "The following dotfiles have local changes:"
    printf '%s\n' "${modified_files}"
    read -r -p "Overwrite local dotfiles? [y/N] " reply
    if [[ "$reply" =~ ^[Yy]$ ]]; then
        echo "Overwriting local changes..."
        git reset --hard HEAD -- dotfiles
    fi
fi

