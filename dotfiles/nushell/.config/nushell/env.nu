$env.PATH = ($env.PATH | prepend $"($env.HOME)/.local/bin")

$env.XDG_CONFIG_HOME = $"($env.HOME)/.config"
$env.XDG_CACHE_HOME = $"($env.HOME)/.cache"
$env.XDG_DATA_HOME = $"($env.HOME)/.local/share"
$env.XDG_STATE_HOME = $"($env.HOME)/.local/state"

$env.EDITOR = "micro"
$env.VISUAL = "code"

$env.TERMINAL = "ghostty"
$env.XMODIFIERS = "@im=fcitx"

$env.MANPAGER = "bat -plman"

$env.BAT_OPTS = "--strip-ansi=auto"

$env.DOCKER_HOST = $"unix://($env.XDG_RUNTIME_DIR)/podman/podman.sock"

$env.IDF_PATH = "/opt/espressif/esp-idf/v5.4.2"
$env.IDF_TOOLS_PATH = "/opt/espressif/idf-tools"

$env.OPENROUTER_API_KEY = (secret-tool lookup api openrouter)

# XDG paths for tools
$env.STARSHIP_CONFIG = $"($env.XDG_CONFIG_HOME)/starship/starship.toml"
$env.CARGO_HOME = $"($env.XDG_DATA_HOME)/cargo"
$env.DOTNET_CLI_HOME = $"($env.XDG_DATA_HOME)/dotnet"
$env.GNUPGHOME = $"($env.XDG_DATA_HOME)/gnupg"
$env.ANDROID_USER_HOME = $"($env.XDG_DATA_HOME)/android"
$env._JAVA_OPTIONS = $"-Djava.util.prefs.userRoot=($env.XDG_CONFIG_HOME)/java"
$env.GRADLE_USER_HOME = $"($env.XDG_DATA_HOME)/gradle"
$env.PUB_CACHE = $"($env.XDG_DATA_HOME)/dart/pub-cache"
$env.ANALYZER_STATE_LOCATION_OVERRIDE = $"($env.XDG_CACHE_HOME)/dart/dartServer"
$env.CHROME_EXECUTABLE = "/usr/bin/google-chrome-stable"
$env.NVM_DIR = $"($env.XDG_DATA_HOME)/nvm"
$env.COPILOT_CONFIG_PATH = $"($env.XDG_DATA_HOME)/copilot/config.json"
$env.CLAUDE_CONFIG_DIR = $"($env.XDG_DATA_HOME)/claude"
$env.GTK2_RC_FILES = $"($env.XDG_CONFIG_HOME)/gtk-2.0/gtkrc"
$env.PLATFORMIO_CORE_DIR = $"($env.XDG_DATA_HOME)/platformio"
$env.RUSTUP_HOME = $"($env.XDG_DATA_HOME)/rustup"

# Add Cargo bin to PATH
$env.PATH = ($env.PATH | prepend $"($env.CARGO_HOME)/bin")

# ─── Shell Integration Init Files ────────────────────────────────
# These run before config.nu loads, so the cache files exist at parse time.

# Zoxide smart cd
zoxide init nushell | save -f ~/.cache/zoxide_init.nu

# Starship Prompt
starship init nu | save -f ~/.cache/starship_init.nu

# FZF keybindings and completions (patch deprecated str downcase -> str lowercase)
^fzf --nushell | collect | str replace -a 'str downcase' 'str lowercase' | save -f ~/.cache/fzf_init.nu

# fnm (Node version manager — parse bash output since nushell not supported natively)
if (which fnm | is-not-empty) {
    load-env (fnm env --shell bash
        | lines
        | str replace 'export ' ''
        | str replace -a '"' ''
        | split column "="
        | rename name value
        | where name != "FNM_ARCH" and name != "PATH"
        | reduce -f {} {|it, acc| $acc | upsert $it.name $it.value }
    )
    $env.PATH = ($env.PATH | prepend $"($env.FNM_MULTISHELL_PATH)/bin")
}
