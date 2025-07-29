#!/usr/bin/env zsh

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

#----------------------------------------------------------------
# Editor ========================================================

export EDITOR="micro"
export VISUAL="code"

#----------------------------------------------------------------
# ZSH ===========================================================

export ZDOTDIR="$XDG_CONFIG_HOME/zsh"              # Config directory
export HISTFILE="$XDG_STATE_HOME/zsh/history.log"  # History direcotry
export HISTSIZE=10000
export SAVEHIST=10000

#----------------------------------------------------------------
# Starship ======================================================

export STARSHIP_CONFIG="$XDG_CONFIG_HOME/starship/starship.toml"
