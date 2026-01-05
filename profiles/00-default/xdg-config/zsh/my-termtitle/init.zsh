# NOTE:
# Update OSC 7 and OSC 2
# OSC 7
# https://wezterm.org/shell-integration.html#osc-7-escape-sequence-to-set-the-working-directory
# \e\\:  String Terminator
[[ "${TERM}" != dumb && "${TERM}" != screen* ]] && () {
    builtin emulate -L zsh
    local giticon=" "

    autoload -Uz vcs_info
    zstyle ':vcs_info:*' enable git
    zstyle ':vcs_info:git*' formats '%r/%S'  # repo-name/subdir

    _termtitle_precmd() {
        vcs_info  # vcs_info_msg_0_ 변수 업데이트
        local dir="${vcs_info_msg_0_:-${PWD/#$HOME/~}}"  # git이면 repo 기준, 아니면 HOME 기준

        dir="${dir%/.}"  # repo root의 /. 제거
        [[ -n ${vcs_info_msg_0_} ]] && dir="${giticon}${dir}"  # git repo면 아이콘 추가

        # Update OSC 7
        print -n "\e]7;file://${HOST}${PWD:gs/ /%20}\e\\"

        # Update OSC 2
        if [[ ${SSH_CONNECTION} != "" ]]; then
            print -Pn "\e]2;${USER}@${HOST}: ${dir}\e\\"
        else
            print -Pn "\e]2;${dir}\e\\"
        fi
    }

    _termtitle_preexec() {
        vcs_info  # vcs_info_msg_0_ 변수 업데이트
        local cmd="${${(Az)2}[1]}"
        local dir="${vcs_info_msg_0_:-${PWD/#$HOME/~}}"  # git이면 repo 기준, 아니면 HOME 기준

        dir="${dir%/.}"  # repo root의 /. 제거
        [[ -n ${vcs_info_msg_0_} ]] && dir="${giticon}${dir}"  # git repo면 아이콘 추가

        # Update OSC 2
        if [[ ${SSH_CONNECTION} != "" ]]; then
            print -Pn "\e]2;${cmd} (${USER}@${HOST}:${dir})\e\\"
        else
            print -Pn "\e]2;${cmd} (${dir})\e\\"
        fi
    }

    autoload -Uz add-zsh-hook
    add-zsh-hook precmd _termtitle_precmd
    add-zsh-hook preexec _termtitle_preexec
}
