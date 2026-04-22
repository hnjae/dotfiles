if (( ! $+commands[oh-my-posh] )); then
    autoload -Uz vcs_info
    precmd() { vcs_info }

    # %s : 현재 사용 중인 VCS 종류 (git, hg, svn 등)
    # %b : 현재 브랜치 정보
    # %a : 현재 액션 상태
    # %i : 현재 revision / commit identifier
    # %c : staged changes 표시 문자열
    # %u : unstaged changes 표시 문자열
    # %R : patch 관련
    zstyle ':vcs_info:git:*' check-for-changes true
    zstyle ':vcs_info:git:*' formats '[ %b]%u%c'
    zstyle ':vcs_info:git:*' actionformats '[ %b|%a]%u%c'

    setopt PROMPT_SUBST

    PS1='%F{yellow}%n@%m%f %F{blue}%~%f %F{magenta}${vcs_info_msg_0_}%f $ '
    return
fi

# NOTE: example of oh-my-posh result: `export POSH_SESSION_ID="f0f2ffb7-f1f2-423b-a4df-bd39162caf67";source $'/home/hnjae/.cache/oh-my-posh/init.14695981039346656037.zsh'`

eval "$($commands[oh-my-posh] --config "${0:A:h}/config.json" init zsh)"

