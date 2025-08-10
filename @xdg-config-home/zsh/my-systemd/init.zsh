if (( ! $+commands[systemctl] )); then
  return
fi

local gp # global prefix
local up # user prefix

gp="sc"
up="scu"

alias $gp="systemctl"
alias $up="systemctl --user"

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

# Requires previleges
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
alias ${gp}x="journalctl -xeu"
alias ${up}x="journalctl --user -xeu"

unset gp up
