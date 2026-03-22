---
date: 2026-03-22T20:44:34+0900
lastmod: 2026-03-22T20:44:34+0900
---

> [!NOTE]
> `dotbot` 의 한계로 [XDG Base Directory Specification](https://specifications.freedesktop.org/basedir-spec/latest/)에서 정의한 XDG 경로의 기본값만을 사용한다. 예로 환경변수 `$XDG_CONFIG_HOME`를 조작해도 dotfiles에서는 대응하지 않는다.

## Prerequisite

- `git-lfs`
- `python3`

## Install

```sh
git clone --recurse-submodules git@github.com:hnjae/dotfiles ~/Projects/dotfiles
~/Projects/dotfiles/install.sh
```

### 데스크톱 가이드

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
1. `gh auth login` 으로 인증하기
