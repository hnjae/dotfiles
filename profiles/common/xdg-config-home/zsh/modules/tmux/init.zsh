# SPDX-License-Identifier: AGPL-3.0-or-later
# SPDX-FileCopyrightText: 2022-2026 KIM Hyunjae

if ((!$+commands[tmux])); then
    return
fi

alias -- t=tmux
alias -- ta='tmux attach'
# alias -- tat='tmux attach -t'
# alias -- tat='tmux attach -t "$(tmux ls | cut -d: -f1 | fzf)"'
alias -- tat='tmux-attach'
alias -- tl='tmux ls'
alias -- tns='tmux new -s'
alias -- trn='tmux rename'
