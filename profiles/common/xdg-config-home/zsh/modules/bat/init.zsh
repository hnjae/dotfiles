# SPDX-License-Identifier: AGPL-3.0-or-later
# SPDX-FileCopyrightText: 2022-2026 KIM Hyunjae

if ((!$+commands[bat])); then
    return
fi

# -F: --quit-if-one-screen
# -L: --no-lessopen
# -R: --RAW-CONTROL-CHARS

export BAT_PAGER="less -iLR"

alias -- c="bat --paging=never --style=plane"
