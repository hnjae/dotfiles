export FZF_DEFAULT_OPTS="--color=base16,border:8 --layout=reverse --smart-case --height=22 --marker=░"

() {
    local -r target=${1}
    shift
    local -r cmd=${1}
    (( ${+commands[${cmd}]} )) || return 1

    local -r sigfile="${target}.sig"
    local -r cmd_path="${commands[${cmd}]}"
    local -r sig="${cmd_path:A}"

    # Cache invalidation policy:
    # - `-ot` catches ordinary in-place binary updates.
    # - `${commands[fzf]:A}` catches Nix/NixOS upgrades because the real store path changes.
    #
    # hyperfine --warmup 10 --runs 100, 2026-05-17:
    # - hyperfine 1.20.0; zsh 5.9 (x86_64-pc-linux-gnu); fzf 0.72.0
    # - zsh -fc ':'                                    3.4 ms ± 0.9 ms
    # - zsh -fc 'source current-cache-hit.zsh'         6.4 ms ± 0.9 ms
    # - zsh -fc 'source sig-cache-hit.zsh'             6.6 ms ± 1.0 ms
    # - zsh -fc 'source always-regenerate.zsh'         8.3 ms ± 1.2 ms
    # - fzf --zsh >/dev/null                           1.6 ms ± 0.3 ms
    # Signature checking adds only noise-level overhead here, while making the
    # cache valid for Nix store path changes.
    if [[
        ! -s ${target} ||
        ${target} -ot ${cmd_path} ||
        ! -e ${sigfile} ||
        "$(<${sigfile})" != ${sig}
    ]]; then
        "${@}" >! ${target} || return 1
        print -r -- ${sig} >! ${sigfile}
        zcompile -UR ${target}
    fi
    source ${target}
} ${0:h}/_fzf---zsh.zsh fzf --zsh || return 1

local fd_cmd bat_cmd=${(k)commands[bat]-${(k)commands[batcat]}} ls_cmd

if (( ${+commands[bfs]} )); then
    export FZF_DEFAULT_COMMAND="command bfs -mindepth 1 -exclude -name .git -exclude -name .venv -exclude -name .devenv -type d,f -printf '%P\n' 2>/dev/null"
    export FZF_ALT_C_COMMAND="command bfs -mindepth 1 -exclude -name .git -exclude -name .venv -exclude -name .devenv -type d -printf '%P\n' 2>/dev/null"
    _fzf_compgen_path() {
        command bfs ${1} -exclude -name .git -exclude -name .venv -exclude -name .devenv -type d,f -a -not -path ${1} -print
    }
    _fzf_compgen_dir() {
        command bfs ${1} -exclude -name .git -exclude -name .venv -exclude -name .devenv -type d -a -not -path ${1} -print
    }

elif fd_cmd=${(k)commands[fd]-${(k)commands[fdfind]}}; [[ -n ${fd_cmd} ]]; then
    local fd_excludes=(
        # filesystem Snapshots
        ".snapshots"
        ".zfs"

        # Git
        ".git"
        ".git-crypt"

        # Build results or dependencies
        ".cache"
        ".direnv"
        ".husky/_"
        ".venv"
        "dist"
        "node_modules"

        # Editor
        ".idea"
        ".vscode"
        ".vscode-server"
        ".zed"

        # OS/DE generated files
        ".DS_Store"
        ".Thumbs.db"
        ".directory"

        # Language-specific cache
        ".__pycache__"
        ".mypy_cache"
        ".ruff_cache"
        '\*.pyc'
        '\*.zwc'

        # Editor temporary files
        '\*.swp'
        '\*~'
    )

    export FZF_CTRL_T_COMMAND="command ${fd_cmd} --hidden --one-file-system --follow ${fd_excludes[@]/#/--exclude } --type f --type d . 2>/dev/null"
    export FZF_ALT_C_COMMAND="command ${fd_cmd} --hidden --one-file-system --follow ${fd_excludes[@]/#/--exclude } --type d . 2>/dev/null"

    typeset -g _fzf_fd_cmd="${fd_cmd}"
    typeset -ga _fzf_fd_excludes=("${fd_excludes[@]}")
    typeset -ga _fzf_fd_exclude_args=()
    local fd_exclude
    for fd_exclude in "${fd_excludes[@]}"; do
        _fzf_fd_exclude_args+=("--exclude=${fd_exclude#\\}")
    done
    unset fd_exclude

    _fzf_compgen_path() {
        command "${_fzf_fd_cmd}" --hidden --one-file-system --no-ignore-vcs --follow \
            "${_fzf_fd_exclude_args[@]}" --type f --type d . "$1"
    }

    _fzf_compgen_dir() {
        command "${_fzf_fd_cmd}" --hidden --one-file-system --no-ignore-vcs --follow \
            "${_fzf_fd_exclude_args[@]}" --type d . "$1"
    }

elif (( ${+commands[rg]} )); then
    export FZF_DEFAULT_COMMAND="command rg -uu -g '!.git' --files --no-messages"
    _fzf_compgen_path() {
        command rg -uu -g '!.git' --files ${1}
    }
fi

if (( ${+commands[eza]} )); then
    ls_cmd='eza --group-directories-first --color=always'
else
    # Compatible with BSD & GNU
    ls_cmd='ls --color=always'
fi

if [[ -n ${bat_cmd} ]]; then
    export FZF_CTRL_T_OPTS="--bind ctrl-/:toggle-preview --preview 'if [[ -d {} ]]; then command ${ls_cmd} -1F {}; else command ${bat_cmd} --color=always --line-range :500 {}; fi' ${FZF_CTRL_T_OPTS}"
fi

export FZF_ALT_C_OPTS="--bind ctrl-/:toggle-preview --preview 'command ${ls_cmd} -1F {}' ${FZF_ALT_C_OPTS}"

unset fd_cmd bat_cmd ls_cmd

if (( ${+FZF_DEFAULT_COMMAND} )) export FZF_CTRL_T_COMMAND=${FZF_DEFAULT_COMMAND}
