#----------------------------------------------------------------
# History =======================================================

# setopt SHARE_HISTORY # Instantaneous shared history between terminals
setopt APPEND_HISTORY # Share history between terminals only after current one exits
setopt EXTENDED_HISTORY # Include timestamps
setopt HIST_IGNORE_DUPS # Don't include repeated executions of a command

#----------------------------------------------------------------
# Keybindings ===================================================

typeset -gA key=(
    Esc                  '\e'
    Enter                '\n'
    Tab                  '\t'

    Up                   '^[[A'
    Down                 '^[[B'
    Right                '^[[C'
    Left                 '^[[D'
    Home                 '^[[H'
    End                  '^[[F'
    Insert               '^[[2~'
    Delete               '^[[3~'
    PageUp               '^[[5~'
    PageDown             '^[[6~'
    Backspace            '^?'

    Shift+Up             '^[[1;2A'
    Shift+Down           '^[[1;2B'
    Shift+Right          '^[[1;2C'
    Shift+Left           '^[[1;2D'
    Shift+End            '^[[1;2F'
    Shift+Home           '^[[1;2H'
    Shift+Insert         '^[[2;2~'
    Shift+Delete         '^[[3;2~'
    Shift+PageUp         '^[[5;2~'
    Shift+PageDown       '^[[6;2~'
    Shift+Backspace      '^?'
    Shift+Tab            '^[[Z'

    Alt+Up               '^[[1;3A'
    Alt+Down             '^[[1;3B'
    Alt+Right            '^[[1;3C'
    Alt+Left             '^[[1;3D'
    Alt+End              '^[[1;3F'
    Alt+Home             '^[[1;3H'
    Alt+Insert           '^[[2;3~'
    Alt+Delete           '^[[3;3~'
    Alt+PageUp           '^[[5;3~'
    Alt+PageDown         '^[[6;3~'
    Alt+Backspace        '^[^?'

    Alt+Shift+Up         '^[[1;4A'
    Alt+Shift+Down       '^[[1;4B'
    Alt+Shift+Right      '^[[1;4C'
    Alt+Shift+Left       '^[[1;4D'
    Alt+Shift+End        '^[[1;4F'
    Alt+Shift+Home       '^[[1;4H'
    Alt+Shift+Insert     '^[[2;4~'
    Alt+Shift+Delete     '^[[3;4~'
    Alt+Shift+PageUp     '^[[5;4~'
    Alt+Shift+PageDown   '^[[6;4~'
    Alt+Shift+Backspace  '^[^H'

    Ctrl+Up              '^[[1;5A'
    Ctrl+Down            '^[[1;5B'
    Ctrl+Right           '^[[1;5C'
    Ctrl+Left            '^[[1;5D'
    Ctrl+Home            '^[[1;5H'
    Ctrl+End             '^[[1;5F'
    Ctrl+Insert          '^[[2;5~'
    Ctrl+Delete          '^[[3;5~'
    Ctrl+PageUp          '^[[5;5~'
    Ctrl+PageDown        '^[[6;5~'
    Ctrl+Backspace       '^H'

    Ctrl+Shift+Up        '^[[1;6A'
    Ctrl+Shift+Down      '^[[1;6B'
    Ctrl+Shift+Right     '^[[1;6C'
    Ctrl+Shift+Left      '^[[1;6D'
    Ctrl+Shift+Home      '^[[1;6H'
    Ctrl+Shift+End       '^[[1;6F'
    Ctrl+Shift+Insert    '^[[2;6~'
    Ctrl+Shift+Delete    '^[[3;6~'
    Ctrl+Shift+PageUp    '^[[5;6~'
    Ctrl+Shift+PageDown  '^[[6;6~'
    Ctrl+Shift+Backspace '^?'

    Ctrl+Alt+Up          '^[[1;7A'
    Ctrl+Alt+Down        '^[[1;7B'
    Ctrl+Alt+Right       '^[[1;7C'
    Ctrl+Alt+Left        '^[[1;7D'
    Ctrl+Alt+Home        '^[[1;7H'
    Ctrl+Alt+End         '^[[1;7F'
    Ctrl+Alt+Insert      '^[[2;7~'
    Ctrl+Alt+Delete      '^[[3;7~'
    Ctrl+Alt+PageUp      '^[[5;7~'
    Ctrl+Alt+PageDown    '^[[6;7~'
    Ctrl+Alt+Backspace   '^[^H'

    Ctrl+Alt+Shift+Up        '^[[1;8A'
    Ctrl+Alt+Shift+Down      '^[[1;8B'
    Ctrl+Alt+Shift+Right     '^[[1;8C'
    Ctrl+Alt+Shift+Left      '^[[1;8D'
    Ctrl+Alt+Shift+Home      '^[[1;8H'
    Ctrl+Alt+Shift+End       '^[[1;8F'
    Ctrl+Alt+Shift+Insert    '^[[2;8~'
    Ctrl+Alt+Shift+Delete    '^[[3;8~'
    Ctrl+Alt+Shift+PageUp    '^[[5;8~'
    Ctrl+Alt+Shift+PageDown  '^[[6;8~'
    Ctrl+Alt+Shift+Backspace '^?'
  )

[[ -n "${key[Insert]}"         ]] && bindkey -- "${key[Insert]}"         overwrite-mode
[[ -n "${key[Delete]}"         ]] && bindkey -- "${key[Delete]}"         delete-char
[[ -n "${key[Ctrl+Delete]}"    ]] && bindkey -- "${key[Ctrl+Delete]}"    kill-word
[[ -n "${key[Backspace]}"      ]] && bindkey -- "${key[Backspace]}"      backward-delete-char
[[ -n "${key[Ctrl+Backspace]}" ]] && bindkey -- "${key[Ctrl+Backspace]}" backward-kill-word
[[ -n "${key[Home]}"           ]] && bindkey -- "${key[Home]}"           beginning-of-line
[[ -n "${key[End]}"            ]] && bindkey -- "${key[End]}"            end-of-line
[[ -n "${key[PageUp]}"         ]] && bindkey -- "${key[PageUp]}"         beginning-of-buffer-or-history
[[ -n "${key[PageDown]}"       ]] && bindkey -- "${key[PageDown]}"       end-of-buffer-or-history
[[ -n "${key[Up]}"             ]] && bindkey -- "${key[Up]}"             up-line-or-history
[[ -n "${key[Down]}"           ]] && bindkey -- "${key[Down]}"           down-line-or-history
[[ -n "${key[Left]}"           ]] && bindkey -- "${key[Left]}"           backward-char
[[ -n "${key[Ctrl+Left]}"      ]] && bindkey -- "${key[Ctrl+Left]}"      backward-word
[[ -n "${key[Right]}"          ]] && bindkey -- "${key[Right]}"          forward-char
[[ -n "${key[Ctrl+Right]}"     ]] && bindkey -- "${key[Ctrl+Right]}"     forward-word
[[ -n "${key[Shift+Left]}"  ]] && bindkey -- "${key[Shift+Left]}"        backward-word
[[ -n "${key[Shift+Right]}" ]] && bindkey -- "${key[Shift+Right]}"       forward-word

#----------------------------------------------------------------
# Completions ===================================================

# zmodload -i zsh/complist # Load default completion menu
autoload -Uz compinit && compinit

_comp_options+=(globdots)  # Enable completion for hidden files

eval "$(dircolors -b)" && zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS} # Colored completion output
# zstyle ':completion:*' completer _extensions _complete _approximate # Completion method
zstyle ':completion:*' menu no # Menu (selection/no)
zstyle ':completion:*' use-cache on # Cache the completions
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/.zcompcache"

# bindkey -M menuselect "${key[Esc]}" send-break
# bindkey -M menuselect "${key[Tab]}" accept-line

#---------------------------------------------------------------
# Aliases ======================================================

alias cat='bat'
alias curl='curlie'
alias find='fd'
alias ls='eza'
alias notepad='notepad.exe'
alias grep='rg'
alias cd='z'
alias cdi='zi'
alias rm='echo "Please use trash instead (or override with \\\rm)" >&2; return 1;'

#----------------------------------------------------------------
# Plugins =======================================================

# FZF Tab - Replace zsh's default completion selection menu with fzf!
source /usr/share/zsh/plugins/fzf-tab-git/fzf-tab.plugin.zsh
zstyle ':fzf-tab:*' fzf-flags --bind=tab:accept,shift-tab:accept
zstyle ':fzf-tab:*' switch-group '<' '>'
# zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath' # Show FZF Preview on cd

# ZSH Autosuggestions - It suggests commands as you type based on history and completions
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh
ZSH_AUTOSUGGEST_STRATEGY=(history completion)

# ZSH Completions - Additional completion definitions for Zsh
fpath=(/usr/share/zsh/site-functions/ $fpath)

# ZSH Fast Syntax Hightlighting 
source /usr/share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh

# Zsh Shift Select Mode - Select text in the command line using Shift as in many text editors, browsers and other GUI programs.
source /usr/share/zsh/plugins/zsh-shift-select/zsh-shift-select.plugin.zsh

#----------------------------------------------------------------
# Shell Integrations ============================================

eval "$(starship init zsh)" # Starship Prompt
eval "$(fzf --zsh)" # Fuzzy Finder
eval "$(zoxide init zsh)" # Zoxide

#----------------------------------------------------------------
# Starship Transient Prompt =====================================

function transient-prompt-precmd {
    SAVED_PROMPT="$(starship prompt --profile transient)"
    SAVED_RPROMPT="$(starship prompt --profile rtransient)"
    
    TRAPINT() { transient-prompt; return $(( 128 + $1 )) } # Apply transient-prompt on Ctrl+C
}
autoload -Uz add-zsh-hook
add-zsh-hook precmd transient-prompt-precmd

function transient-prompt() {
    PROMPT="$SAVED_PROMPT" RPROMPT="$SAVED_RPROMPT" zle .reset-prompt
}
autoload -Uz add-zle-hook-widget
add-zle-hook-widget zle-line-finish transient-prompt
