# zmodload zsh/zprof


if [[ "$TERM" != "dumb" && "$NO_COLOR" != "" ]]; then
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
# https://github.com/simnalamburt/.dotfiles/blob/997d482/.zshrc
if (( $+commands[vim] )) || (( $+commands[nvim] )); then
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
# History 설정
#################################################

HISTSIZE="99999"
SAVEHIST="99999"
# HISTORY_IGNORE='(l|e|ls|cd *|s *|z *|zi *|si *|rm *|sudo rm *|trash *|trash-put *|trash-rm *|trash-empty|mv|pfkill *|exit|fg|bg|zfs destroy *|zpool destroy *|btrfs subvolume delete *|sudo zfs destroy *|sudo zpool destroy *|sudo btrfs subvolume delete *|* --please-destroy-my-drive *|reboot|shutdown|halt|kexec|systemctl reboot|systemctl halt|systemctl poweroff|systemctl kexec|systemctl soft-reboot|man *|just *|rg *|vi *|vim *|nvim *|nano *|which *|command *|stat *|xdg-open *|mpv *|psql *|git*--hard*|gcm *|sudo wipefs *|sudo badblocks *)'
HISTFILE="${XDG_STATE_HOME}/zsh_history"

typeset -a history_ignore_patterns=(
    # 단순 명령어
    'l' 'e' 'ls' 'exa' 'true' 'false'

    # 이동 명령어
    'cd *' 's *' 'z *' 'zi *' 'si *' 'si'

    # 파괴적 명령어
    'rm *' 'sudo rm *' 'mv'
    'trash *' 'trash-put *' 'trash-rm *' 'trash-empty'
    'zfs destroy *' 'sudo zfs destroy *'
    'zpool destroy *' 'sudo zpool destroy *'
    'btrfs subvolume delete *' 'sudo btrfs subvolume delete *'
    'btrfs su delete *' 'sudo btrfs su delete *'
    'sudo wipefs *' 'sudo badblocks *'
    '* --please-destroy-my-drive *'

    # 시스템 명령어
    'exit' 'fg' 'bg' 'pfkill *'
    'reboot' 'shutdown' 'halt' 'kexec'
    "sudo reboot" "sudo shutdown" "sudo halt"
    'systemctl reboot' 'systemctl halt' 'systemctl poweroff'
    'systemctl kexec' 'systemctl soft-reboot'

    # 읽기 전용 명령어
    'man *' 'which *' 'command *' 'stat *'
    'just *' 'rg *'

    # 편집기
    'vi *' 'vim *' 'nvim *' 'nano *'

    # 미디어/앱
    'xdg-open *' 'mpv *' 'psql *'

    # Git 관련
    'git*--hard*' 'gcm *'
)

# 패턴 조합
HISTORY_IGNORE="(${(j:|:)history_ignore_patterns})"

setopt HIST_FCNTL_LOCK
unsetopt APPEND_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
unsetopt HIST_SAVE_NO_DUPS
unsetopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_EXPIRE_DUPS_FIRST
setopt SHARE_HISTORY
setopt EXTENDED_HISTORY

#################################################
# zsh-abbr 설정
#################################################
# typeset -g ABBR_EXPAND_PUSH_ABBREVIATION_TO_HISTORY=1
# typeset -g ABBR_GET_AVAILABLE_ABBREVIATION=1
# typeset -g ABBR_LOG_AVAILABLE_ABBREVIATION=1
#
# # alias 에서 import 해서 사용할 예정이라 ~/.config 에 위치하지 않도록 한다.
# typeset -g ABBR_USER_ABBREVIATIONS_FILE="${XDG_STATE_HOME:-${HOME}/.local/state}/zsh-abbr-user"
#
# function sync-abbr() {
#     if [[ "$ABBR_USER_ABBREVIATIONS_FILE" != "" && -f "$ABBR_USER_ABBREVIATIONS_FILE" ]]; then
#       rm "$ABBR_USER_ABBREVIATIONS_FILE"
#     fi
#
#     abbr import-aliases
# }

#################################################
# ZVM 설정
#################################################
ZVM_CURSOR_STYLE_ENABLED=false
# ZVM_LINE_INIT_MODE=$ZVM_MODE_INSERT
ZVM_INIT_MODE=sourcing

#################################################
# 기타 플러그인 설정
#################################################
# export _ZO_FZF_OPTS="--color=16,border:8 --layout=reverse --height=22 --marker=░ --scheme=path"

ZSH_AUTOSUGGEST_STRATEGY=(match_prev_cmd completion)
zstyle ':fzf-tab:*' use-fzf-default-opts yes

################################################################################
# Bootstrap zimfw (NOTE: zimfw 를 git-submodule 로 사용 중.)
################################################################################
zstyle ':zim:zmodule' use 'degit'
typeset -g ZIM_HOME="${XDG_DATA_HOME}/zimfw"

if [[ ! -f "${ZDOTDIR}/.zimrc" ]]; then
    echo "ERROR: .zimrc not found."
    return
fi

# Install missing modules, and update ${ZIM_HOME}/init.zsh if missing or outdated.
if [[ ! "${ZIM_HOME}/init.zsh" -nt "${ZDOTDIR}/.zimrc" ]]; then
    echo "INFO: Installing ZIM modules..." >&2
    source "${ZIM_HOME}/zimfw.zsh" init -q
fi

# Initialize modules.
source "${ZIM_HOME}/init.zsh"

# alias mdream="podman run -it ghcr.io/harlan-zw/mdream:latest"
# alias mdreamp="podman run -it ghcr.io/harlan-zw/mdream:latest -driver playwright"

# opencode
export PATH=/home/hnjae/.opencode/bin:$PATH
