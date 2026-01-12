---
date: 2025-06-11T13:02:30+0900
lastmod: 2026-01-12T16:31:53+0900
---

## alias 도식법

- 조심해야할 alias 는 대문자 사용.
- 강제로 실행하는 alias 는 `!` 사용

### 자주사용하는 abbreviations

| 단어 | abbrv |
| -- | -- |
| stat | s/st |
| list/log | l |
| start/run | x |
| push | p |
| rename | r/n |
| show | sh/s |


## zsh

### 변수 선언 방법

- <https://github.zshell.dev/post/zsh/cheatsheet/typeset/>

`typeset -g VAR="value"`
: 전역 스코프에서 셸 변수 선언, 자식 프로세스에 전달 X. zsh 세션 내에서만 사용

`export VAR="value"`
: `typeset` 자식 프로세스에 전달 되는 환경 변수 설정


## zimfw

> [!NOTE]
> `$ZIM_HOME/modules/` 경로에 module 들이 설치됨.

### Glossary

External module
: 내가 직접 작성한 module. `modules/my-bat` 같은 것.

### tl;dr

`.zimrc` 변경 반영 (`build` 는 `compile` 를 포함함)
: `zimfw clean && zimfw build && exec zsh`

<!--
External module 변경 반영
: `zimfw compile; exec zsh`
-->

Clean & Restart
: `zimfw uninstall -q; zimfw clean && zimfw build && exec zsh`

##### Manipulating with non-external module

Uninstall unused non-external module
: `zimfw uninstall`

Added new non-external module
: `zimfw install && exec zsh`

Fix damaged or non-working non-external module
: `zimfw reinstall && exec zsh`

Update non-external module
: `zimfw update && exec zsh`

### Code Snippets

zimfw 를 외부에서 받아 사용한다면, 다음 snippet 을 `.zshrc` 에 추가

```zsh
# Download zimfw plugin manager if missing.
if [[ ! -e ${ZIM_HOME}/zimfw.zsh ]]; then
    echo "INFO: Installing ZIM." >&2
    if (( $+commands[curl] )); then
        curl -fsSL --create-dirs -o "${ZIM_HOME}/zimfw.zsh" \
            "https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh"
    elif (( $+commands[wget] )); then
        mkdir -p "${ZIM_HOME}" && wget -nv -O "${ZIM_HOME}/zimfw.zsh" \
            "https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh"
    else
        echo "ERROR: Neither curl nor wget is available to download ZIM." >&2
        return
    fi
fi
```
