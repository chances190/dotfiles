# ==== ENVIRONMENT VARIABLES (Grouped by Function) ============================

### ---- Paths & XDG Base Directories ----
fish_add_path "$HOME/.local/bin"
set -gx XDG_CONFIG_HOME "$HOME/.config"
set -gx XDG_CACHE_HOME "$HOME/.cache"
set -gx XDG_DATA_HOME "$HOME/.local/share"
set -gx XDG_STATE_HOME "$HOME/.local/state"

### ---- System & Desktop ----
set -gx EDITOR micro
set -gx VISUAL code
set -gx TERMINAL ghostty
set -gx XMODIFIERS @im=fcitx
set -gx GTK2_RC_FILES "$XDG_CONFIG_HOME"/gtk-2.0/gtkrc
set -gx CHROME_EXECUTABLE /usr/bin/google-chrome-stable
set -gx GNUPGHOME "$XDG_DATA_HOME"/gnupg

### ---- CLI Tools & Containers ----
set -gx MANPAGER "bat -plman"
set -gx BAT_OPTS "--strip-ansi=auto"
set -gx DOCKER_HOST unix://"$XDG_RUNTIME_DIR"/podman/podman.sock

### ---- AI Tools ----
set -gx OPENROUTER_API_KEY (secret-tool lookup api openrouter)
set -gx COPILOT_CONFIG_PATH "$XDG_DATA_HOME"/copilot/config.json
set -gx CLAUDE_CONFIG_DIR "$XDG_DATA_HOME"/claude

### ---- Development Environments ----
# Rust
set -gx RUSTUP_HOME "$XDG_DATA_HOME"/rustup
set -gx CARGO_HOME "$XDG_DATA_HOME"/cargo

# Node.js
set -gx NVM_DIR "$XDG_DATA_HOME"/nvm

# Dart & Flutter
set -gx PUB_CACHE "$XDG_DATA_HOME"/dart/pub-cache
set -gx ANALYZER_STATE_LOCATION_OVERRIDE "$XDG_CACHE_HOME"/dart/dartServer

# Java & Gradle
set -gx _JAVA_OPTIONS -Djava.util.prefs.userRoot="$XDG_CONFIG_HOME"/java
set -gx GRADLE_USER_HOME "$XDG_DATA_HOME"/gradle

# Android
set -gx ANDROID_USER_HOME "$XDG_DATA_HOME"/android

# .NET
set -gx DOTNET_CLI_HOME "$XDG_DATA_HOME"/dotnet

# Embedded / Hardware (ESP-IDF & PlatformIO)
set -gx IDF_PATH /opt/espressif/esp-idf/v5.4.2
set -gx IDF_TOOLS_PATH /opt/espressif/idf-tools
set -gx PLATFORMIO_CORE_DIR "$XDG_DATA_HOME"/platformio


# ==== SHELL CONFIGURATION & INTERACTIVE SETTINGS =============================

### ---- History ----
set -gx fish_history_limit 10000
set -g fish_history_shared 0

### ---- Prompt & Shell Configurations ----
set -gx STARSHIP_CONFIG "$XDG_CONFIG_HOME"/starship/starship.toml

### ---- FZF & fifc Configuration ----
set -gx FZF_DEFAULT_OPTS '--height ~40% --layout=reverse'
set -Ux fifc_editor micro
set -Ux fifc_bat_opts --style=numbers
set -Ux fifc_fd_opts --hidden
set -Ux fifc_eza_opts --icons --tree --level=2


# ==== ALIASES, ABBREVIATIONS, & FUNCTIONS ====================================

### ---- Global Abbreviations ----
abbr -a --position anywhere -- -h '-h 2>&1 | bat -plhelp'
abbr -a --position anywhere -- --help '--help 2>&1 | bat -plhelp'

### ---- Regular Aliases ----
alias cat='bat'
alias ls='eza --icons --hyperlink=auto'
alias ll='ls -lh'
alias lt='ls -T'
alias trm='trash'
alias cd='z'
alias cdi='zi'
alias curl='curlie'
alias find='fd'
alias grep='rg'
alias zaproxy='zaproxy -dir "$XDG_DATA_HOME"/zaproxy'
alias adb='HOME="$XDG_DATA_HOME"/android adb'
alias rm="echo -e '⚠️ \e[1;33mWarning:\e[0m You ran raw \'rm\'. Consider using \'trm\' instead, or bypass with \'command rm\'.'"

### ---- Custom Functions ----
function help --description 'Run a command with its help flag and pipe to bat'
    if test (count $argv) -eq 0
        echo "Usage: help <command> [flags]" >&2
        return 1
    end
    command $argv -h 2>&1 | bat -plhelp
end


# ==== THEME & EXTERNAL TOOL INITIALIZATION ===================================

### ---- Visuals & Theme ----
set -gx LS_COLORS (vivid generate molokai)

if status is-interactive
    fish_config theme choose monokai
end

### ---- Tool Initializations ----
fzf --fish | source
zoxide init fish | source
starship init fish | source
enable_transience