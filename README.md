---
date: 2025-06-30T00:04:00+0900
lastmod: 2025-08-11T23:27:22+0900
---

# README

## Install

```sh
git clone --recurse-submodules git@github.com:hnjae/dotfiles ~/dotfiles
~/dotfiles/install.sh
```

`dotfiles` 수정을 하지 않을 기기라면:

```sh
git clone --depth 1 --recurse-submodules git@github.com:hnjae/dotfiles "${XDG_DATA_HOME:-${HOME}/.local/share}/dotfiles"
"${XDG_DATA_HOME:-${HOME}/.local/share}/dotfiles/install.sh"

# TODO: write following
# systemctl --user enable --now update-dotfiles.timer
```

## 데스크톱 가이드

1. 1Password 로그인 및 설정
    - `Unlock using system authentication service` 키기
    - `Integrate with 1Password CLI` 키기
    - SSH Agent 설정
        - Ask approval for each new **application** 으로 설정하기
        - `$HOME/.config/1Password/ssh/agent.toml` 수정
2. `install.sh` 실행.
