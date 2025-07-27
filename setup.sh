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
    git
    micro
    python
    reflector
    stow
    zsh
)

aur_packages=(
    neofetch
)

# Install all packages (official & AUR) in one go
echo "Installing Packages..."
paru -S --noconfirm --needed "${packages[@]}" "${aur_packages[@]}"


source ./handle_ssh.sh && decrypt_ssh

# Apply GNU Stow to your dotfiles
echo "Stowing dotfiles..."
cd dotfiles
stow --target="$HOME" --ignore '.*encrypted/.*' --dotfiles --no-folding --restow *
cd ..

