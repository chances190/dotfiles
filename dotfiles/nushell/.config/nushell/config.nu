# ─── History ────────────────────────────────────────────────────
$env.config.history = {
    max_size: 10000
    sync_on_enter: false
    file_format: "sqlite"
    isolation: false
}

$env.config.show_banner = false

# ─── Monokai Syntax Highlighting ────────────────────────────────
# Monokai-8 Palette
let m8_green       = "#a6e22e"
let m8_magenta     = "#ae81ff"
let m8_cyan        = "#66d9ef"
let m8_yellow      = "#e6db74"
let m8_red         = "#f92672"
let m8_white       = "#f8f8f2"
let m8_gray        = "#75715e"
let m8_none        = "#f8f8f2"
let m8_bg          = "#272822"

# Bold Accents
let m8_green_bold   = { fg: "#a6e22e" attr: b }
let m8_magenta_bold = { fg: "#ae81ff" attr: b }
let m8_cyan_bold    = { fg: "#66d9ef" attr: b }
let m8_yellow_bold  = { fg: "#e6db74" attr: b }
let m8_red_bold     = { fg: "#f92672" attr: b }
let m8_white_bold   = { fg: "#f8f8f2" attr: b }
let m8_gray_bold     = { fg: "#75715e" attr: b }

$env.config.color_config = {
    # --- Primitive Data Types (Structured Table Outputs) ---
    bool:          $m8_magenta
    int:           $m8_magenta
    float:         $m8_magenta
    range:         $m8_magenta
    binary:        $m8_magenta
    string:        $m8_yellow
    filesize:      $m8_yellow
    duration:      $m8_none
    date:          $m8_none
    nothing:       $m8_gray_bold
    cell-path:     $m8_none

    # --- Commands, Subcommands, and Functions ---
    shape_command:                $m8_green
    shape_custom:                 $m8_green
    shape_external:               $m8_green
    shape_internalcall:           $m8_green          # Builtins (Not Bold)
    shape_externalarg:            $m8_magenta_bold   # External subcommands (Bold Purple)

    # --- Key Syntax, Blocks, and Structural Coding ---
    shape_keyword:                $m8_red
    shape_or:                     $m8_red
    shape_pipe:                   $m8_red
    shape_redirection:            $m8_red
    shape_operator:               $m8_red
    shape_block:                  $m8_none
    shape_closure:                $m8_none
    shape_list:                   $m8_none
    shape_record:                 $m8_none
    shape_table:                  $m8_none

    # --- System Modifiers, Flags, and Core Arguments ---
    shape_flag:                   $m8_magenta_bold
    shape_int:                    $m8_magenta
    shape_literal:                $m8_magenta
    
    # --- Text & Input Parsing Values ---
    shape_string:                 $m8_yellow
    shape_string_interpolation:   $m8_white_bold
    shape_datetime:               $m8_yellow
    
    # --- Paths and Glob Patterns ---
    shape_directory:              $m8_yellow         # Path layouts (Yellow)
    shape_file:                   $m8_white         
    shape_filepath:               $m8_white         
    shape_globpattern:            $m8_white_bold    # Globs (Bold Yellow)
    
    # --- Variables and Scopes ---
    shape_variable:               $m8_white_bold     # Env variables (Bold White)
    shape_vardecl:                $m8_white_bold

    # --- Screen Buffers & Layout Safety Triggers ---
    shape_matching_brackets:      { fg: "#000000" bg: "#ffffff" }
    shape_garbage:                { fg: "#ffffff" bg: $m8_red attr: b }

    # --- Global Terminal UI Frame Elements ---
    separator:                    $m8_gray_bold
    header:                       $m8_green_bold
    leading_trailing_space_bg:    { attr: n }
    row_index:                    $m8_gray_bold
    hints:                        $m8_gray_bold
    search_result:                { fg: $m8_bg bg: $m8_yellow }
}

# ─── Dynamic LS_COLORS Generation ───────────────────────────────
# Helper closure to parse hex strings (e.g., "#a6e22e") into ANSI RGB components (38;2;R;G;B)
let hex_to_ansi_rgb = {|hex|
    let r = ($hex | str substring 1..2 | into int -r 16)
    let g = ($hex | str substring 3..4 | into int -r 16)
    let b = ($hex | str substring 5..6 | into int -r 16)
    $"38;2;($r);($g);($b)"
}

# Construct the global LS_COLORS environment map dynamically
$env.LS_COLORS = [
    $"di=(do $hex_to_ansi_rgb $env.config.color_config.shape_directory)"   # Directories
    $"fi=(do $hex_to_ansi_rgb $env.config.color_config.shape_file)"        # Regular Files
    $"ln=(do $hex_to_ansi_rgb $env.config.color_config.shape_directory)"   # Symlinks
    $"ex=(do $hex_to_ansi_rgb $env.config.color_config.shape_external)"    # Executables
] | str join ":"


# ─── Custom FZF Utilities ───────────────────────────────────────

# Function 1: Handles string swapping cleanly behind the cursor
def fzf-apply-completion [choice: string, current_line: string] {
    let pos = (commandline get-cursor)
    let left = ($current_line | str substring 0..<$pos)
    let right = ($current_line | str substring $pos..)
    
    # Swaps the partial word fragment right at the cursor boundary
    let new_left = if ($left | str ends-with " ") {
        $"($left)($choice)"
    } else {
        ($left | str replace -r '\S+$' $choice)
    }
    
    commandline edit --replace $'($new_left)($right)'
    commandline set-cursor ($new_left | str length)
}

# Function 2: The Core Integration Menu Engine
def run-fzf-completions [] {
    let current_line = (commandline)
    if ($current_line | str trim | is-empty) { return }

    let pos = (commandline get-cursor)
    let left_of_cursor = ($current_line | str substring 0..<$pos)
    let spans = ($left_of_cursor | split words)

    # 1. Fetch external completions
    let external = (try {
        if ($spans | length) > 0 { 
            "" | carapace $spans.0 nushell ...$spans | from json 
        } else { [] }
    } catch { [] })

    # 2. Fetch internal completions (isolated from background pipeline stdin)
    let internal = (try { 
        let engine_output = (commandline complete)
        $engine_output
    } catch { [] })

    # 3. Type-Safe Normalization Layer
    let all_suggestions = ($external | append $internal | each {|r|
        if ($r | describe | str starts-with "record") {
            {
                value: ($r.value? | default "")
                description: ($r.description? | default "")
            }
        } else {
            # It's a raw string (e.g., standard path completion like "../")
            {
                value: ($r | str trim)
                description: ""
            }
        }
    } | where {|r| not ($r.value | is-empty)} | uniq-by value)

    if ($all_suggestions | is-empty) { return }

    # 4. Quick exit if there is exactly one option total
    if ($all_suggestions | length) == 1 {
        fzf-apply-completion $all_suggestions.0.value $current_line
        return
    }

    # 5. Content-Driven Routing
    let has_descriptions = ($all_suggestions | any {|r| not ($r.description | is-empty)})

    if $has_descriptions {
        # --- COMMAND / FLAG MODE ---
        let aligned = ($all_suggestions | each {|r| 
            $"($r.value | fill -w 30)  ($r.description)"
        } | str join (char nl) | str trim)
        
        let selection = ($aligned | fzf --ansi
            --layout reverse
            --height 40%
            --border
            --preview-window hidden
        )
        
        if ($selection == "") { return }
        let choice = ($selection | split row ' ' | first)
        fzf-apply-completion $choice $current_line

    } else {
        # --- FILESYSTEM PATH MODE ---
        let fzf_input = ($all_suggestions | each {|r| $r.value} | str join (char nl))
    
        let selection = ($fzf_input | fzf --ansi
            --layout reverse
            --height 40%
            --border
            --preview 'sh -c "
                if [ -d {1} ]; then
                    eza -TL 2 --icons --color=always {1} 2>/dev/null | head -30
                elif [ -f {1} ]; then
                    bat --color=always --style=numbers --line-range=:15 {1} 2>/dev/null
                else
                    echo {1}
                fi
            "'
        ) # TODO: Didn't manage to get this exact behaviour in nushell. Debug and fix
    
        if ($selection | is-empty) { return }
        fzf-apply-completion ($selection | str trim) $current_line
    }
}

# ─── Keybindings ────────────────────────────────────────────────
$env.config.keybindings ++= [
    { modifier: control  keycode: left      mode: [emacs, vi_normal, vi_insert] event: { edit: MoveWordLeft } }
    { modifier: control  keycode: right     mode: [emacs, vi_normal, vi_insert] event: { edit: MoveWordRight } }
    { modifier: control  keycode: backspace mode: [emacs, vi_normal, vi_insert] event: { edit: BackspaceWord } }
    { modifier: control  keycode: delete    mode: [emacs, vi_normal, vi_insert] event: { edit: DeleteWord } }
    { modifier: alt      keycode: left      mode: [emacs, vi_normal, vi_insert] event: { edit: MoveWordLeft } }
    { modifier: alt      keycode: right     mode: [emacs, vi_normal, vi_insert] event: { edit: MoveWordRight } }
    { modifier: shift    keycode: left      mode: [emacs, vi_normal, vi_insert] event: { edit: MoveWordLeft } }
    { modifier: shift    keycode: right     mode: [emacs, vi_normal, vi_insert] event: { edit: MoveWordRight } }
    {
        name: fzf_ls_completion
        modifier: control
        keycode: char_f
        mode: [emacs, vi_normal, vi_insert]
        event: { send: executehostcommand, cmd: "fzf-ls-preview" }
    }
    {
        name: fzf_carapace_completion
        modifier: control
        keycode: char_g
        mode: [emacs, vi_normal, vi_insert]
        event: { send: executehostcommand, cmd: "fzf-complete" }
    }
    {
        name: universal_fzf_completions
        modifier: none
        keycode: tab
        mode: [emacs vi_insert]
        event: {
          send: ExecuteHostCommand
          cmd: "run-fzf-completions"
        }
    }
]

# ─── Aliases ─────────────────────────────────────────────────────
#alias cat = bat
#alias ls = eza --icons --hyperlink
#alias ll = eza -lh --icons --hyperlink
#alias lt = eza -T --icons --hyperlink
alias trm = trash
alias cdi = zi
alias find = fd
alias grep = rg
alias curl = curlie
def rm [...args] {
    let span = (metadata $args).span
    error make {
        msg: "Alias Restricted",
        label: {
            text: "Use `trm` instead (or override with ^rm)",
            span: $span
        }
    }
}
def help [...args: string] {
    let cmd = ($args | str join " ")
    nu -c $"($cmd) --help" | bat -plhelp
}

alias zaproxy = zaproxy -dir $env.XDG_DATA_HOME/zaproxy
alias adb = HOME=$env.XDG_DATA_HOME/android adb

# ─── Base Shell Integrations ────────────────────────────────────
# We load these first so they can initialize foundational variables
source ($nu.default-config-dir | path join "integrations/zoxide.nu")
source ($nu.default-config-dir | path join "integrations/starship.nu")
# source ($nu.default-config-dir | path join "integrations/fzf.nu")
# source ($nu.default-config-dir | path join "integrations/carapace.nu")

# Your standard Starship setup (if not already there)
$env.STARSHIP_SHELL = "nu"
$env.PROMPT_COMMAND = { || starship prompt --cmd-duration $env.CMD_DURATION_MS $'--status=($env.LAST_EXIT_CODE)' }

# This renders just the compact character module (e.g., "❯") when the line is executed
$env.TRANSIENT_PROMPT_COMMAND = { || starship module character }
$env.TRANSIENT_PROMPT_COMMAND_RIGHT = ""
$env.TRANSIENT_PROMPT_MULTILINE_INDICATOR = ""