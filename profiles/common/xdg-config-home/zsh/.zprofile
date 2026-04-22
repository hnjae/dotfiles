# DOCS:
# Will be sourced after .zshenv and before .zshrc
# Will NOT be sourced if the shell is not a login shell.

setopt no_global_rcs # do not source global zshrc/zprofile files

if [[ "${__ZPROFILE_SOURCED}" != "" ]]; then return; fi
typeset -g __ZPROFILE_SOURCED=1

# Profiles
[[ -f "/etc/profile" ]] && emulate sh -c '. /etc/profile'

# User profile
[[ -f "$HOME/.profile" ]] && emulate sh -c ". '$HOME/.profile'"
