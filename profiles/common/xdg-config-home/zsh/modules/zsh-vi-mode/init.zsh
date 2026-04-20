function _zvm_osc52_copy() {
    emulate -L zsh

    local data encoded
    data=$(cat)
    [[ -z "$data" ]] && return 0

    encoded=$(printf '%s' "$data" | base64 | tr -d '\n')

    if [[ -n "$TMUX" ]]; then
        printf '\ePtmux;\e\e]52;c;%s\a\e\\' "$encoded"
    else
        printf '\e]52;c;%s\a' "$encoded"
    fi
}

function zvm_config() {
    ZVM_INIT_MODE="sourcing" # fzf 가 zvm 설정을 override 하는데 필요. (TODO:재검토 <2026-04-18>)
    ZVM_CURSOR_STYLE_ENABLED=false

    if [[ -n "$SSH_CONNECTION" || -n "$SSH_TTY" ]]; then
        ZVM_SYSTEM_CLIPBOARD_ENABLED=true
        ZVM_CLIPBOARD_COPY_CMD='_zvm_osc52_copy'
        ZVM_CLIPBOARD_PASTE_CMD='false'
    elif [[ "$XDG_SESSION_TYPE" == "wayland" ]]; then
        ZVM_SYSTEM_CLIPBOARD_ENABLED=true
    else
        ZVM_SYSTEM_CLIPBOARD_ENABLED=false
    fi

    ZVM_LINE_INIT_MODE="$ZVM_MODE_INSERT"
}

source "${0:A:h}/module/zsh-vi-mode.plugin.zsh"

# zsh-vi-mode leaves Tab unbound in vicmd by default. Mirror the insert-mode
# completion widget so Tab still completes when the line is in normal mode.
# if bindkey -M viins '^I' &>/dev/null; then
#     bindkey -M vicmd '^I' fzf-tab-complete
# fi
