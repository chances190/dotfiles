#!/usr/bin/env zsh

export PATH="$HOME/.local/bin:$PATH"
export XDG_CONFIG_HOME="$HOME"/.config
export XDG_CACHE_HOME="$HOME"/.cache
export XDG_DATA_HOME="$HOME"/.local/share
export XDG_STATE_HOME="$HOME"/.local/state

#----------------------------------------------------------------
# Editor ========================================================

export EDITOR=micro
export VISUAL=code

#----------------------------------------------------------------
# ZSH ===========================================================

export ZDOTDIR="$XDG_CONFIG_HOME"/zsh              # Config directory
export HISTFILE="$XDG_STATE_HOME"/zsh/history.log  # History direcotry
export HISTSIZE=10000
export SAVEHIST=10000

#----------------------------------------------------------------
# KDE ===========================================================

export TERMINAL=ghostty
export XMODIFIERS=@im=fcitx

#----------------------------------------------------------------
# Manpages ======================================================

export MANPAGER="bat -plman"

#----------------------------------------------------------------
# bat ===========================================================

export BAT_OPTS="--strip-ansi=auto"

#----------------------------------------------------------------
# Podman ========================================================

export DOCKER_HOST=unix://"$XDG_RUNTIME_DIR"/podman/podman.sock

#----------------------------------------------------------------
# ESP-IDF =======================================================

export IDF_PATH=/opt/espressif/esp-idf/v5.4.2
export IDF_TOOLS_PATH=/opt/espressif/idf-tools

#----------------------------------------------------------------
# Aider AI ======================================================

export OPENROUTER_API_KEY=$(secret-tool lookup api openrouter)

#----------------------------------------------------------------
# XDG ===========================================================

# Starship
export STARSHIP_CONFIG="$XDG_CONFIG_HOME"/starship/starship.toml

# Cargo 
export CARGO_HOME="$XDG_DATA_HOME"/cargo

# Microsoft .NET 
export DOTNET_CLI_HOME="$XDG_DATA_HOME"/dotnet

# GnuPG
export GNUPGHOME="$XDG_DATA_HOME"/gnupg

# Android SDK
export ANDROID_USER_HOME="$XDG_DATA_HOME"/android

# Java
export _JAVA_OPTIONS=-Djava.util.prefs.userRoot="$XDG_CONFIG_HOME"/java
export GRADLE_USER_HOME="$XDG_DATA_HOME"/gradle

# Flutter
export PUB_CACHE="$XDG_DATA_HOME"/dart/pub-cache
export ANALYZER_STATE_LOCATION_OVERRIDE="$XDG_CACHE_HOME"/dart/dartServer
export CHROME_EXECUTABLE=/usr/bin/google-chrome-stable

# Node
export NVM_DIR="$XDG_DATA_HOME"/nvm

# AI
export COPILOT_CONFIG_PATH="$XDG_DATA_HOME"/copilot/config.json
export CLAUDE_CONFIG_DIR="$XDG_DATA_HOME"/claude

# GTK
export GTK2_RC_FILES="$XDG_CONFIG_HOME"/gtk-2.0/gtkrc

# Platformio
export PLATFORMIO_CORE_DIR="$XDG_DATA_HOME"/platformio

# Rustup
export RUSTUP_HOME="$XDG_DATA_HOME"/rustup
