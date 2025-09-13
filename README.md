---
date: 2025-06-30T00:04:00+0900
lastmod: 2025-09-13T16:30:55+0900
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
3. `install.sh` 재실행.
4. Copilot 인증 하기
    - `nvim` 로 Copilot 이 활성화되는 filetype 의 파일을 열고, `Copilot auth` 실행
