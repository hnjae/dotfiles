# DOCS:
# Will be sourced after .zshenv and before .zshrc
# Will NOT be sourced if the shell is not a login shell.
# **DO NOT SOURCE Global `/etc/profile`** <2026-05-09>
#   - Debian 13 같은 배포반은 여기에서, PATH를 override 해버림. zshenv 가 먼저 source 되는 zsh 와 구조가 안맞음.
# **DO NOT SOURCE Global `$HOME/.profile`** <2026-05-09>
#   - .profile 이 하는 역할 직접 관리.

setopt no_global_rcs # do not source global zshrc

if [[ "${__ZPROFILE_SOURCED}" != "" ]]; then return; fi
typeset -g __ZPROFILE_SOURCED=1

for user_profile_file in "${XDG_CONFIG_HOME:-${HOME}/.config}/profile.d"/*.sh(N); do
    [[ -r "$user_env_file" ]] || continue
    emulate sh -c ". '$user_env_file'"
done
unset user_profile_file
