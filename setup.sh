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
    cd - >/dev/null
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

# # Change default shell to zsh if installed
# if which zsh &> /dev/null; then
#     echo "Changing default shell to zsh..."
#     chsh -s "$(which zsh)"
#     exec zsh
# else
#     echo "zsh was not installed properly, aborting."
#     exit 1
# fi

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
        git checkout -- dotfiles/
    fi
fi

