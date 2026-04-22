#################################################
# History 설정
#################################################

HISTSIZE="99999"
SAVEHIST="99999"
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

# CLEAN
unset history_ignore_patterns
