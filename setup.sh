#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"

DISTRO_FAMILY=""
DISTRO_ID="${DISTRO_ID:-unknown}"
FAILED_PACKAGES=()

if [[ ! -r /etc/os-release ]]; then
    echo "Cannot detect distro: /etc/os-release not found."
    exit 1
fi

# shellcheck source=/dev/null
source /etc/os-release
DISTRO_ID="${ID:-$DISTRO_ID}"
case "${ID:-}" in
    arch)
        DISTRO_FAMILY="arch"
        ;;
    ubuntu|debian|kali)
        DISTRO_FAMILY="debian"
        ;;
    *)
        case "${ID_LIKE:-}" in
            *arch*) DISTRO_FAMILY="arch" ;;
            *debian*) DISTRO_FAMILY="debian" ;;
            *) DISTRO_FAMILY="" ;;
        esac
        ;;
esac

if [[ -z "$DISTRO_FAMILY" ]]; then
    echo "Unsupported distro: ${DISTRO_ID}. Supported families: Arch, Debian/Ubuntu/Kali."
    exit 1
fi

echo "Detected distro: $DISTRO_ID ($DISTRO_FAMILY family)"

clone_repo() {
    local repo_url="$1"
    local dest_dir="$2"

    if [[ -d "$dest_dir/.git" ]]; then
        git -C "$dest_dir" pull --ff-only || echo "Warning: failed to update $dest_dir"
        return
    fi

    rm -rf "$dest_dir"
    git clone --depth 1 "$repo_url" "$dest_dir"
}

if [[ "$DISTRO_FAMILY" == "arch" ]]; then
    sudo pacman -Syu --noconfirm
    if ! command -v paru >/dev/null 2>&1; then
        echo "Installing paru..."
        sudo pacman -S --noconfirm --needed git base-devel
        rm -rf /tmp/paru
        git clone https://aur.archlinux.org/paru.git /tmp/paru
        cd /tmp/paru
        makepkg -si --noconfirm || {
            echo "Failed to install paru."
            cd -
            rm -rf /tmp/paru
            exit 1
        }
        cd -
        rm -rf /tmp/paru
    fi

    packages=(
        bat
        curlie
        eza
        fd
        fzf
        fzf-tab-git
        git
        micro
        python
        reflector
        ripgrep
        starship
        stow
        tealdeer
        trash-cli
        tree
        unifetch
        uutils-coreutils
        zoxide
        zsh
        zsh-autosuggestions
        zsh-fast-syntax-highlighting
    )
    echo "Installing packages..."
    for package in "${packages[@]}"; do
        if ! paru -S --noconfirm --needed "$package"; then
            FAILED_PACKAGES+=("$package")
        fi
    done
else
    sudo apt-get update
    sudo apt-get upgrade -y

    packages=(
        bat
        build-essential
        curlie
        eza
        fd-find
        fzf
        git
        micro
        python3
        ripgrep
        starship
        stow
        tldr
        trash-cli
        tree
        zoxide
        zsh
    )
    echo "Installing packages..."
    for package in "${packages[@]}"; do
        if ! sudo apt-get install -y "$package"; then
            FAILED_PACKAGES+=("$package")
        fi
    done

    echo "Installing zsh plugins from git..."
    PLUGIN_ROOT="$XDG_DATA_HOME/zsh/plugins"
    mkdir -p "$PLUGIN_ROOT"
    clone_repo "https://github.com/Aloxaf/fzf-tab.git" "$PLUGIN_ROOT/fzf-tab-git"
    clone_repo "https://github.com/zsh-users/zsh-autosuggestions.git" "$PLUGIN_ROOT/zsh-autosuggestions"
    clone_repo "https://github.com/zdharma-continuum/fast-syntax-highlighting.git" "$PLUGIN_ROOT/fast-syntax-highlighting"
    clone_repo "https://github.com/jirutka/zsh-shift-select.git" "$PLUGIN_ROOT/zsh-shift-select"
fi

zsh_path="$(command -v zsh || true)"
if [[ -z "$zsh_path" ]]; then
    echo "zsh was not installed properly, aborting."
    exit 1
fi

if [[ "${SHELL:-}" != "$zsh_path" ]]; then
    echo "Changing default shell to zsh..."
    chsh -s "$zsh_path"
fi

if [[ ${#FAILED_PACKAGES[@]} -gt 0 ]]; then
    echo
    echo "Some packages failed to install:"
    printf ' - %s\n' "${FAILED_PACKAGES[@]}"
    echo "Continuing with dotfiles sync."
fi

bash "$SCRIPT_DIR/sync.sh"
