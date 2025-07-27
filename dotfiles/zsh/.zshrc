# Power Level 10k ===============================================

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input 
# (password prompts, [y/n] confirmations, etc.) 
# must go above this block; everything else may go below.

if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

#----------------------------------------------------------------
# History =======================================================

# History in cache directory:
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.cache/zsh/history

#----------------------------------------------------------------
# Completions ===================================================

autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit

bindkey -M menuselect '^[' send-break

# Enable completion for hidden files
_comp_options+=(globdots)

#----------------------------------------------------------------
# Keybindings ===================================================

# create a zkbd compatible hash;
# to add other keys to this hash, see: man 5 terminfo
typeset -g -A key

key[Insert]='^[[2~'
key[Delete]='^[[3~'
key[Ctrl-Delete]='^[[3;5~'
key[Backspace]='^?'
key[Ctrl-Backspace]='^H'
key[Home]='^[[H'
key[End]='^[[F'
key[PageUp]='^[[5~'
key[PageDown]='^[[6~'
key[Up]='^[[A'
key[Left]='^[[D'
key[Down]='^[[B'
key[Right]='^[[C'
key[Shift-Tab]='^[[Z'
key[Ctrl-Left]='^[[1;5D'
key[Ctrl-Right]='^[[1;5C'

# setup key accordingly
[[ -n "${key[Insert]}"         ]] && bindkey -- "${key[Insert]}"         overwrite-mode
[[ -n "${key[Delete]}"         ]] && bindkey -- "${key[Delete]}"         delete-char
[[ -n "${key[Ctrl-Delete]}"    ]] && bindkey -- "${key[Ctrl-Delete]}"    kill-word
[[ -n "${key[Backspace]}"      ]] && bindkey -- "${key[Backspace]}"      backward-delete-char
[[ -n "${key[Ctrl-Backspace]}" ]] && bindkey -- "${key[Ctrl-Backspace]}" backward-kill-word
[[ -n "${key[Home]}"           ]] && bindkey -- "${key[Home]}"           beginning-of-line
[[ -n "${key[End]}"            ]] && bindkey -- "${key[End]}"            end-of-line
[[ -n "${key[PageUp]}"         ]] && bindkey -- "${key[PageUp]}"         beginning-of-buffer-or-history
[[ -n "${key[PageDown]}"       ]] && bindkey -- "${key[PageDown]}"       end-of-buffer-or-history
[[ -n "${key[Up]}"             ]] && bindkey -- "${key[Up]}"             up-line-or-history
[[ -n "${key[Down]}"           ]] && bindkey -- "${key[Down]}"           down-line-or-history
[[ -n "${key[Left]}"           ]] && bindkey -- "${key[Left]}"           backward-char
[[ -n "${key[Ctrl-Left]}"      ]] && bindkey -- "${key[Ctrl-Left]}"      backward-word
[[ -n "${key[Right]}"          ]] && bindkey -- "${key[Right]}"          forward-char
[[ -n "${key[Ctrl-Right]}"     ]] && bindkey -- "${key[Ctrl-Right]}"     forward-word
[[ -n "${key[Shift-Tab]}"      ]] && bindkey -- "${key[Shift-Tab]}"      reverse-menu-complete

#---------------------------------------------------------------
# Aliases ======================================================

alias ls='ls --color=auto'
alias notepad='notepad.exe'

#----------------------------------------------------------------
# Plugins =======================================================

# ZSH Autosuggestions (text to the side)
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
# bindkey '\t' autosuggest-accept # Doesnt work with menu selection

# ZSH Autocomplete (instant list below)
# source /usr/share/zsh/plugins/zsh-autocomplete/zsh-autocomplete.plugin.zsh

# ZSH Syntax Hightlighting (colors in the commands)
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh



export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
