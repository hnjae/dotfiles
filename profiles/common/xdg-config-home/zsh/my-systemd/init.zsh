if (( ! $+commands[systemctl] )); then
    return
fi

local gp # global prefix
local up # user prefix

gp="sc"
up="scu"

alias $gp="systemctl"
alias $up="systemctl --user"

alias ${gp}z="sysz"
alias ${gp}lu="systemctl list-units"
alias ${up}lu="systemctl --user list-units"
alias ${gp}lam="systemctl list-automounts"
alias ${up}lam="systemctl --user list-automounts"
alias ${gp}lp="systemctl list-paths"
alias ${up}lp="systemctl --user list-paths"
alias ${gp}ld="systemctl list-dependencies"
alias ${up}ld="systemctl --user list-dependencies"
alias ${gp}lt="systemctl list-timers"
alias ${up}lt="systemctl --user list-timers"
alias ${gp}st="systemctl status"
alias ${up}st="systemctl --user status"
alias ${gp}sh="systemctl show"
alias ${up}sh="systemctl --user show"
alias ${gp}c="systemctl cat"
alias ${up}c="systemctl --user cat"
alias ${gp}h="systemctl help"
alias ${up}h="systemctl --user help"

# Requires privileges
alias ${gp}x="sudo systemctl start"
alias ${up}x="systemctl --user start"
alias ${gp}rx="sudo systemctl restart"
alias ${up}rx="systemctl --user restart"
alias ${gp}r="sudo systemctl reload"
alias ${up}r="systemctl --user reload"
alias ${gp}k="sudo systemctl stop"
alias ${up}k="systemctl --user stop"
alias ${gp}K="sudo systemctl kill"
alias ${up}K="systemctl --user kill"

########################################################################
# journalctl
########################################################################

gp="jc"
up="jcu"

alias ${gp}="journalctl"
alias ${up}="journalctl --user"
alias ${gp}f="journalctl --output=short-full --boot=0 --follow --unit="
alias ${up}f="journalctl --output=short-full --user --boot=0 --follow --unit="
alias ${gp}x="journalctl --output=short-full --boot=0 --catalog --follow --unit="
alias ${up}x="journalctl --output=short-full --user --boot=0 --catalog --follow --unit="

unset gp up

########################################################################
# MISC
########################################################################

# NOTE: NOT TESTED
scxl() {
    local unit="${1:?unit name required}"

    [[ $unit == *.service ]] || unit="${unit}.service"

    # Unit 존재 여부 확인
    if ! systemctl list-unit-files --type service | grep -q "^${unit}"; then
        echo "ERROR: Service '$unit' not found" >&2
        return 1
    fi

    echo "INFO: Starting $unit..." >&2
    nohup sudo systemctl start  "$unit" >/dev/null 2>&1 &

    exec journalctl --follow --since "12s ago" --output=short-full --unit "$unit"
}

# _sysstart_completion() {
#     local -a units
#     units=($(systemctl list-unit-files --type service --no-pager 2>/dev/null | awk 'NR>1 {print $1}' | sed 's/\.service$//'))
#     _describe 'systemd service' units
# }
#
# compdef _sysstart_completion sysstart
