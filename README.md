---
date: 2025-06-30T00:04:00+0900
lastmod: 2026-01-20T20:35:20+0900
---

# README

> [!NOTE]
> `dotbot` 의 한계로 [XDG Base Directory Specification](https://specifications.freedesktop.org/basedir-spec/latest/)에서 정의한 XDG 경로의 기본값만을 사용한다. 예로 환경변수 `$XDG_CONFIG_HOME`를 조작해도 dotfiles에서는 대응하지 않는다.

## Install

### 의존성 패키지

- `ansible`
- `python3`
- `git-lfs`
- `fd`
- `which`

### 실행

#### `dotfiles` 수정을 하지 않을 기기

```sh
git clone --depth 1 --recurse-submodules 'https://github.com/hnjae/dotfiles' "${XDG_DATA_HOME:-${HOME}/.local/share}/dotfiles"

"${XDG_DATA_HOME:-${HOME}/.local/share}/dotfiles/install.sh"

# TODO: write following
# systemctl --user enable --now update-dotfiles.timer
```

#### `dotfiles` 에 수정을 가할 기기

```sh
git clone --recurse-submodules git@github.com:hnjae/dotfiles ~/Projects/dotfiles
~/Projects/dotfiles/install.sh
```

## 데스크톱 가이드

1. `install.sh` 실행.
1. 1Password 로그인 및 설정
    - `Unlock using system authentication service` 키기
    - `Integrate with 1Password CLI` 키기
    - SSH Agent 설정
        - Ask approval for each new **application** 으로 설정하기
        - `$HOME/.config/1Password/ssh/agent.toml` 수정
1. `install.sh` 재실행.
1. Copilot 인증 하기 (사용한다면)
    - `nvim` 로 Copilot 이 활성화되는 filetype 의 파일을 열고, `Copilot auth` 실행

## 패키지 설치

#### claude-code

<https://github.com/anthropics/claude-code>

```sh
curl -fsSL https://claude.ai/install.sh | bash
```

#### opencode

<https://github.com/anomalyco/opencode>

```
XDG_BIN_DIR=$HOME/.local/bin curl -fsSL https://opencode.ai/install | bash
```


2026-01-20 기준 위 명령어는 opencode 를 .local/bin/opencode 에 설치 X
