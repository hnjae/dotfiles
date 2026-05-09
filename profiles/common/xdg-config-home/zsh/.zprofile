# DOCS:
# Will be sourced after .zshenv and before .zshrc
# Will NOT be sourced if the shell is not a login shell.
# **DO NOT SOURCE Global `/etc/profile`**
#     - Debian 13 같은 배포반은 여기에서, PATH를 override 해버림. zshenv 가 먼저 source 되는 zsh 와 구조가 안맞음.

setopt no_global_rcs # do not source global zshrc

if [[ "${__ZPROFILE_SOURCED}" != "" ]]; then return; fi
typeset -g __ZPROFILE_SOURCED=1

# User profile
[[ -f "$HOME/.profile" ]] && emulate sh -c ". '$HOME/.profile'"
