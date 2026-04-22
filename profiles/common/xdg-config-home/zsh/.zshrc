# zmodload zsh/zprof

setopt no_global_rcs # do not source global zshrc/zprofile files

if [[ "${__ZSHRC_SOURCED-}" != "" ]]; then return; fi
typeset -g __ZSHRC_SOURCED=1

# {`#`, `~`, `^`} 를 glob 에서 제외하기
unsetopt EXTENDED_GLOB

# NOTE: This CHANGES the cursor style even if shell commands did not require it. <2026-04-18>
# if [[ "$GHOSTTY_RESOURCES_DIR" != "" && -f "${GHOSTTY_RESOURCES_DIR}/shell-integration/zsh/ghostty-integration" ]]; then
#   source "${GHOSTTY_RESOURCES_DIR}/shell-integration/zsh/ghostty-integration"
# fi

if [[ "$TERM" != "dumb" && "$NO_COLOR" == "" ]]; then
    # NOTE: took 1.3 ms
    PF_INFO="ascii title os host kernel uptime memory shell" pfetch || true
fi

#################################################
# interactive shell 설정
#################################################

case "$OSTYPE" in
    linux*)
        export LC_TIME="en_IE.UTF-8"
        ;;
    *)
        ;;
esac

# EDITOR가 vi 이여도, ^A, ^E 같은 emacs 키는 사용할 수 있게 설정
# https://github.com/simnalamburt/.dotfiles/blob/998d482/.zshrc
if (( $+commands[vim] )) && (( $+commands[nvim] )); then
    bindkey '^A' beginning-of-line
    bindkey '^E' end-of-line
fi

# NOTE: 2025-09-16
# tmux 에서는 HOME/END 를 눌렀을때 아래 키를 전달. (`cat -v` 로 확인 가능)
# bash/nvim 에서는 이 키로도 잘 작동함. 왜지?
# https://stackoverflow.com/a/58842892/30570492
bindkey "\E[1~" beginning-of-line
bindkey "\E[4~" end-of-line

#################################################
# 기타 플러그인 설정
#################################################

ZSH_AUTOSUGGEST_STRATEGY=(match_prev_cmd completion)

################################################################################
# Bootstrap zimfw (NOTE: zimfw 를 git-submodule 로 사용 중.)
################################################################################
zstyle ':zim:zmodule' use 'degit'
typeset -g ZIM_HOME="${XDG_DATA_HOME}/zimfw"

if [[ ! -f "${ZDOTDIR}/.zimrc" ]]; then
    echo "ERR: .zimrc not found." >&2
    return
fi

#################################################
# Init zimfw
#################################################

# Install missing modules, and update ${ZIM_HOME}/init.zsh if missing or outdated.
if [[ ! "${ZIM_HOME}/init.zsh" -nt "${ZDOTDIR}/.zimrc" ]]; then
    echo "INFO: Installing ZIM modules..." >&2
    source "${ZIM_HOME}/zimfw.zsh" init -q
fi

# Initialize modules.
source "${ZIM_HOME}/init.zsh"
