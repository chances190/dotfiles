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
    Ctrl+Backspace       '^W'

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
zstyle ':completion:*' completer _extensions _complete _approximate # Completion method
zstyle ':completion:*' menu no # Menu (selection/no)
zstyle ':completion:*' use-cache on # Cache the completions
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME"/zsh/.zcompcache
zstyle ':completion:*:descriptions' format '[%d]'

# bindkey -M menuselect "${key[Esc]}" send-break
# bindkey -M menuselect "${key[Tab]}" accept-line

compinit -d "$XDG_CACHE_HOME"/zsh/zcompdump-"$ZSH_VERSION"

#---------------------------------------------------------------
# Aliases ======================================================

alias cat='bat'
alias -g -- -h='-h 2>&1 | bat -plhelp'
alias -g -- --help='--help 2>&1 | bat -plhelp'

alias ls='eza --icons --hyperlink'
alias ll='ls -lh'
alias lt='ls -T'

alias rm='echo "Use \`trm\` instead (or override with \\\rm)" >&2; false'
alias trm='trash'

alias cd='z'
alias cdi='zi'

alias curl='curlie'
alias find='fd'
alias grep='rg'

# alias notepad='notepad.exe' # If WSL

# For silly programs that don't have env vars to set directiories:
alias zaproxy='zaproxy -dir "$XDG_DATA_HOME"/zaproxy'
alias adb='HOME="$XDG_DATA_HOME"/android adb'

#----------------------------------------------------------------
# Plugins =======================================================

if [[ -d "$XDG_DATA_HOME"/zsh/plugins ]]; then
    ZSH_PLUGIN_DIR="$XDG_DATA_HOME"/zsh/plugins
else
    ZSH_PLUGIN_DIR=/usr/share/zsh/plugins
fi

# FZF Tab - Replace zsh's default completion selection menu with fzf!
source "$ZSH_PLUGIN_DIR"/fzf-tab-git/fzf-tab.plugin.zsh
zstyle ':fzf-tab:*' fzf-flags '--bind=tab:accept,shift-tab:toggle,left-click:toggle,double-click:accept'
zstyle ':fzf-tab:*' switch-group '<' '>'

# Show FZF Preview on completions (Fixed string interpolation)
zstyle ':fzf-tab:complete:*:*' fzf-preview '
    if [ -d $realpath ]; then
        eza -TL 2 --icons --color=always $realpath | head -30
    else
        bat --color=always --style=numbers --line-range=:30 $realpath
    fi
'

# ZSH Autosuggestions - It suggests commands as you type based on history and completions
source "$ZSH_PLUGIN_DIR"/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh
ZSH_AUTOSUGGEST_STRATEGY=(history completion)

# ZSH Completions - Additional completion definitions for Zsh
fpath=(/usr/share/zsh/site-functions/ $fpath)

# ZSH Fast Syntax Hightlighting
FAST_WORK_DIR="$XDG_STATE_HOME"/fsh
source "$ZSH_PLUGIN_DIR"/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
FSH_THEME="$XDG_CONFIG_HOME"/zsh/syntax-highlighting-themes/monokai.ini
zstyle -T :plugin:fast-syntax-highlighting theme "monokai" || fast-theme "$FSH_THEME" > /dev/null 2>&1  # Re-apply theme if changed

# Zsh Shift Select Mode - Select text in the command line using Shift as in many text editors, browsers and other GUI programs.
source "$ZSH_PLUGIN_DIR"/zsh-shift-select/zsh-shift-select.plugin.zsh
source "$XDG_CONFIG_HOME"/zsh/shift-select.zsh

#----------------------------------------------------------------
# Shell Integrations ============================================

eval "$(fzf --zsh)"         # Fuzzy Finder
eval "$(zoxide init zsh)"   # Zoxide
eval "$(starship init zsh)" # Starship Prompt

source /usr/share/nvm/init-nvm.sh # Node Version Manager
# [ -s "$IDF_PATH"/export.sh ] && \. "$IDF_PATH"/export.sh # ESP-IDF

#----------------------------------------------------------------
# Starship Transient Prompt =====================================

TRANSIENT_PROMPT="${PROMPT// prompt / prompt --profile transient }"
TRANSIENT_RPROMPT="${PROMPT// prompt / prompt --profile rtransient }"

function transient-prompt-precmd {
    # Fix ctrl+c behavior
    TRAPINT() { 
        if zle; then
            transient-prompt
            return $(( 128 + $1 ))
        fi
    }

    # Save transient prompt
    SAVED_PROMPT="$(eval "printf '%s' \"${TRANSIENT_PROMPT}\"")"
    SAVED_RPROMPT="$(eval "printf '%s' \"${TRANSIENT_RPROMPT}\"")"
}

autoload -Uz add-zle-hook-widget
add-zle-hook-widget zle-line-finish transient-prompt

function transient-prompt() {
    # Use saved transient prompt
    PROMPT="$SAVED_PROMPT" RPROMPT="$SAVED_RPROMPT" zle .reset-prompt
}
